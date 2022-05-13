using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using CoreUtils.Classes;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public partial class WebForm1 : System.Web.UI.Page
    {

        Broker_CommissionEntities db = new Broker_CommissionEntities();

        public static string receive =
           System.Web.Configuration.WebConfigurationManager.AppSettings["receive_emails"].ToString();

        private static string debugMode =
          System.Web.Configuration.WebConfigurationManager.AppSettings["DebugMode"].ToString();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                // sumeet: always use month of last uploaded raw data
                var month = "";
                var year = "";
                util.Period period = util.getLastUpload();

                month = period.month;
                year = period.year.ToString();

                // todo: if we need to switch to view/process previops perreiod statements, we need to add a UI and method to swetch to the period

                lbl_month.Text = month;
                lbl_year.Text = year;
                //

                lbl_status.Text = "In Progress";
                lbl_not_sent.Text = "0";
                ASPxProgressBar1.Position = 0;
                //
                sendEmails();
            }

        }

        protected void sendEmails()
        {

            var watch = new System.Diagnostics.Stopwatch();
            watch.Start();
            string month = lbl_month.Text;
            int year = int.Parse(lbl_year.Text);

            try
            {

                // setup statement header list
                //tod: uncoment next line
                var headers = db.STATEMENT_HEADER.Where(x => x.MONTH == month && x.YEAR == year && x.BROKER_ID != null /*&& ( x.FLAG == 0 || x.FLAG == 4 )*/)
                    .OrderBy(x => x.BROKER_ID).ToList();
                int current = 0;
                int totalCount = headers.Count();

                // show statement count
                lbl_TotalCount.Text = totalCount.ToString();


                // send email for each header
                foreach (var header in headers)
                {
                    int headerID = header.HEADER_ID;

                    // sendEmail
                    sendEmailForStatement(header);

                    //
                    current++;

                    // 
                    lbl_sent.Text = current.ToString();
                    lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                    int position = util.getPercentage(current, totalCount);
                    ASPxProgressBar1.Position = position;

                    if (position == 10)
                    {
                        lbl_status.Text = "Processing";
                    }

                } // for each statement

                watch.Stop();

                lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";

            } // try

            catch (Exception exception)
            {
                //Response.Write(exception);
                //Response.Redirect("Upload_Result.aspx", false);
                //// note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
                //Context.ApplicationInstance.CompleteRequest();
                watch.Stop();
                Response.Write(exception.Message);

                lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                lbl_not_sent.Text = "0";
                lbl_status.Text = "Execution Fail Please retry or all I.T. for help.";


            } //try

        }

        protected void sendEmailForStatement(STATEMENT_HEADER header)
        {
            // sumeet use new db context to avoid isolate entities being tracked from other queries
            Broker_CommissionEntities db2 = new Broker_CommissionEntities();

            // try for each client
            try
            {
                int headerID = header.HEADER_ID;

                // Create PDF Statement with PDF string output
                PdfGenerationResults pdfGenerationResults = ReportHelper.CreatedWord(headerID, false);
                if (!pdfGenerationResults.success)
                {
                    //todo: display error
                    return;
                }

                // set email from/to/etc
                string from = util.from_email;
                string to = "";

                if (debugMode == "True")
                {
                    //to = "aidubor@claritybenefitsolutions.com";
                    //to = "azhu@claritybenefitsolutions.com" ;
                    to = util.getEmailAddress(int.Parse(header.BROKER_ID.ToString()));
                }
                else
                {
                    // todo: remove comment when we are ready to go live
                    // to = util.getEmailAddress(int.Parse(item.BROKER_ID.ToString())); //remove comment Ayo 05/06/2022
                }

                // send the email with pdf attached - use the one wiothout the paylocity code
                var emailAttachmentPath = !Utils.IsBlank(pdfGenerationResults.outputPath2) ? pdfGenerationResults.outputPath2 : pdfGenerationResults.outputPath1;
                util.email_send_with_attachment(from, to, emailAttachmentPath, header.BROKER_NAME, header.MONTH, header.YEAR);

                // save Invoices that were paid so we dont pay them again
                if (pdfGenerationResults.statementLinesAddedToPdf.Count > 0)
                {
                    IEnumerable<STATEMENT_DETAILS> distintLines = pdfGenerationResults.statementLinesAddedToPdf.GroupBy(p => p.INVOICE_NUM).Select(g => g.First());

                    //todo: get distinct inv numbers
                    foreach (var statement_dtl in distintLines)
                    {
                        // tried insert using SP - we can either merge or raise error if already present - but got error in explicit transactions handling
                        if (statement_dtl.line_payment_status == "paid")
                        {
                            var sentInvoice = new SENT_INVOICE()
                            {
                                INVOICE_NUM = statement_dtl.INVOICE_NUM,
                                OPEN_BALANCE = Utils.ToDecimal(statement_dtl.OPEN_BALANCE),
                                COMMISSION_PAID = Utils.ToDecimal(statement_dtl.TOTAL_PRICE),
                                BROKER_ID = header.BROKER_ID ?? 0,
                                month = header.MONTH,
                                year = header.YEAR,
                                DATE_PAID = DateTime.Now
                            };

                            db2.SENT_INVOICE.Add(sentInvoice);

                        }
                        else
                        {
                            Console.WriteLine($"Statement Item was not paid: {statement_dtl}");
                        }
                    }
                }

                //set header flag
                header.FLAG = 3;

                // commit transactiopn
                db2.SaveChanges();

                // move the 2 generated files from Rollback path top final path
                string outputPath1 = pdfGenerationResults.outputPath1;
                string outputPath2 = pdfGenerationResults.outputPath2;

                // Move file to one directoty above
                FileUtils.MoveFile(outputPath1, $"{Path.GetDirectoryName(Path.GetDirectoryName(outputPath1))}\\{Path.GetFileName(outputPath1)}", null, null);
                if (!Utils.IsBlank(outputPath2))
                {
                    FileUtils.MoveFile(outputPath2, $"{Path.GetDirectoryName(Path.GetDirectoryName(outputPath2))}\\{Path.GetFileName(outputPath2)}", null, null);
                }

            } // try
            catch (Exception ex)
            {
                // rollback all changes
                db2.Dispose();

                //todo: show error on UI by broker ideally in broker grid as well as below button
                Response.Write(ex.Message);
            }

        }
        protected void btn_exit_onclick(object sender, EventArgs e)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "wincloses", "<script>CloseTheFreakingWindow();</script>");
        }

    }
}