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
                //note: take only those invoices we have not already processed this month and have a pending amount
                // this can still resend statements duplicate that have only pending amount for the broker for this period
                var headers = db.STATEMENT_HEADER
                    .Where(
                            /*for current month*/
                            x => x.MONTH == month
                            /*for current yer*/
                            && x.YEAR == year
                            /* for valid broker*/
                            && x.BROKER_ID != null
                            /*to pay + pending > 0*/
                            && x.TOTAL > 0
                            /*statement not yet generated and emailed*/
                            && x.STATEMENT_PROCESSED_THIS_PERIOD <= 0
                    )
                    .OrderBy(x => x.BROKER_ID).ToList();
                int sent = 0;
                int errors = 0;
                int totalCount = headers.Count();

                // show statement count
                lbl_TotalCount.Text = totalCount.ToString();


                // send email for each header
                foreach (var header in headers)
                {
                    int headerID = header.HEADER_ID;

                    // 
                    lbl_sent.Text = sent.ToString();
                    lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                    int position = util.getPercentage(sent, totalCount);
                    ASPxProgressBar1.Position = position;
                    try
                    {
                        // sendEmail
                        sendEmailForStatement(header);
                        // 
                        sent++;
                        lbl_sent.Text = sent.ToString();

                    }
                    catch (Exception ex)
                    {
                        // 
                        errors++;
                        lbl_not_sent.Text = errors.ToString();

                    }
                    //
                    ASPxProgressBar1.Position = util.getPercentage(sent, totalCount);
                    lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";

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
            // todo: inform user that we have started this operation
            // refresh data
            Response.Write("Refreshing Totals<BR><BR>");
            Response.Flush();

            //
            util.reProcessImportedRawData();
            //
            Response.Write("Refreshed Totals<BR><BR>");
            Response.Flush();
        }

        protected void sendEmailForStatement(STATEMENT_HEADER header)
        {
            // sumeet use new db context to avoid isolate entities being tracked from other queries
            Broker_CommissionEntities db2 = new Broker_CommissionEntities();

            // try for each client
            int headerID = header.HEADER_ID;

            // Create PDF Statement with PDF string output
            PdfGenerationResults pdfGenerationResults = ReportHelper.GenerateStatementPdf(headerID, false);

            // move the 2 generated files from Rollback path top final path
            string processingOutputPath1 = pdfGenerationResults.outputPath1;
            string processingOutputPath2 = pdfGenerationResults.outputPath2;
            string finalOutputPath1 = $"{Path.GetDirectoryName(Path.GetDirectoryName(processingOutputPath1))}\\{Path.GetFileName(processingOutputPath1)}";
            string finalOutputPath2 = $"{Path.GetDirectoryName(Path.GetDirectoryName(processingOutputPath2))}\\{Path.GetFileName(processingOutputPath2)}";

            // save invoice sent lines
            try
            {
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
                    }
                }

                //set header flag
                header.FLAG = 3;

                // commit transactiopn
                db2.SaveChanges();
            }
            catch (Exception ex)
            {
                // rollback all changes
                db2.Dispose();

                //todo: show error on UI by broker ideally in broker grid as well as below button
                var message = $"Error Saving Sent Invoices Or Other Database Error Statement for {header.BROKER_NAME} as ";
                message += $"{ex.Message}";
                message += $"<br><br>{ex.StackTrace.ToString()}";

                // save error message to both paths
                FileUtils.WriteToFile($"{processingOutputPath1}.err", message, null);
                FileUtils.WriteToFile($"{processingOutputPath2}.err", message, null);

                //
                throw new EmailBrokerStatementsException(message);
            }

            // set email from/to/etc
            string from = util.from_email;
            string to = "";

            if (util.debugMode == "True")
            {
                //to = "aidubor@claritybenefitsolutions.com";
                //to = "azhu@claritybenefitsolutions.com" ;
                to = util.getEmailAddress(int.Parse(header.BROKER_ID.ToString()));
            }
            else
            {
                // todo: change to actual email address when ready
                to = "claritydev@claritybenefitsolutions.com";
                // to = util.getEmailAddress(int.Parse(item.BROKER_ID.ToString())); //remove comment Ayo 05/06/2022
            }

            // send the email with pdf attached - use the one wiothout the paylocity code
            var emailAttachmentPath = !Utils.IsBlank(pdfGenerationResults.outputPath2) ? pdfGenerationResults.outputPath2 : pdfGenerationResults.outputPath1;
            try
            {
                util.email_send_with_attachment(from, to, emailAttachmentPath, header.BROKER_NAME, header.MONTH, header.YEAR);
            }
            catch (Exception ex)
            {
                // todo: we could nt send the email - so we need to unsave the saved invouice sent lines

                //
                var message = $"Error Sending Email for Statement for {header.BROKER_NAME} as ";
                message += $"{ex.Message}";
                message += $"<br><br>{ex.StackTrace.ToString()}";

                // save error message to both paths
                FileUtils.WriteToFile($"{processingOutputPath1}.err", message, null);
                FileUtils.WriteToFile($"{processingOutputPath2}.err", message, null);

                throw new EmailBrokerStatementsException(message);
            }


            // Move file to one directory above if we reached here without any error. Other file will remain in ToBeProcessed subdirectory for examination
            FileUtils.MoveFile(processingOutputPath1, finalOutputPath1, null, null);
            if (!Utils.IsBlank(processingOutputPath2))
            {
                FileUtils.MoveFile(processingOutputPath2, finalOutputPath2, null, null);
            }

            // as we processed it delete any previous err files
            FileUtils.DeleteFileIfExists($"{processingOutputPath1}.err", null, null);
            FileUtils.DeleteFileIfExists($"{processingOutputPath2}.err", null, null);

        }
        protected void btn_exit_onclick(object sender, EventArgs e)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "wincloses", "<script>CloseTheFreakingWindow();</script>");
        }

    }
}