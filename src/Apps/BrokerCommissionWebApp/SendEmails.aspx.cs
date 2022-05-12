using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                if (Request.QueryString["Year"] != null && Request.QueryString["Month"] != null)
                {
                    lbl_month.Text = Request.QueryString["Month"].ToString();
                    lbl_year.Text = Request.QueryString["Year"].ToString();
                    string month = lbl_month.Text;
                    int year = int.Parse(lbl_year.Text); 
                    lbl_status.Text = "In Progress"; 
                    lbl_not_sent.Text = "0"; 
                    ASPxProgressBar1.Position = 0;
                    sendEmails(); 
                }
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

                #region email statement

                // setup statement header list
                //tod: uncoment next line
                var list = db.STATEMENT_HEADER.Where(x => x.MONTH == month && x.YEAR == year && x.BROKER_ID != null /*&& ( x.FLAG == 0 || x.FLAG == 4 )*/)
                    .OrderBy(x => x.BROKER_ID).ToList();
                int current = 0;
                int totalCount = list.Count();

                // show statement count
                lbl_TotalCount.Text = totalCount.ToString();

                // populate statement details from statement headers
                util.Statement_Detail_Updates();

                foreach (var item in list)
                {
                    int headerID = item.HEADER_ID;
                    // Create PDF Statement with PDF string output
                    string outputPath = ReportHelper.CreatedWord(headerID);


                    string from = util.from_email;
                    string to = "";

                    if(debugMode == "True")
                    {
                        to = "aidubor@claritybenefitsolutions.com";
                        //to = "azhu@claritybenefitsolutions.com" ;
                    }
                    else
                    {
                        //to = util.getEmailAddress(int.Parse(item.BROKER_ID.ToString())); //remove comment Ayo 05/06/2022
                    }

                    

                    util.email_send_with_attachment(from, to, outputPath, item.BROKER_NAME, item.MONTH, item.YEAR);

                    decimal totalAmount = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == headerID && x.OPEN_BALANCE == 0).Sum(x => x.TOTAL_PRICE) == null ? 0 : db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == headerID && x.OPEN_BALANCE == 0).Sum(x => x.TOTAL_PRICE).Value;
 
                    item.STATEMENT_TOTAL = totalAmount;
                    item.FLAG = 3;
                    db.SaveChanges();
                    current++;

                    lbl_sent.Text = current.ToString();
                    lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                    int position = util.getPercentage(current, totalCount);
                    ASPxProgressBar1.Position = position;

                    if (position == 100)
                    {
                        lbl_status.Text = "Complete";
                    }
                } 

                watch.Stop();

                lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds"; 

                #endregion

            }
            catch (Exception exception)
            {
                //Response.Write(exception);
                //Response.Redirect("Upload_Result.aspx");
                watch.Stop(); 
                Response.Write(exception.Message);
                //string executionTime = "Execution Time: " + Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                //string emai_sent = "Total Email Sent Out: " + util.getCompleteCount(month, year).ToString();
                //string emai_nonsent = "Total Email Sent Out: " + util.getinCompleteCount(month, year).ToString();

                lbl_time_execution.Text = Math.Round(Convert.ToDouble((watch.ElapsedMilliseconds) / 1000), 2) + " Seconds";
                lbl_not_sent.Text = "0";
                lbl_status.Text = "Execution Fail Please retry or all I.T. for help.";


            }
        }


        protected void btn_exit_onclick(object sender, EventArgs e)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "wincloses", "<script>CloseTheFreakingWindow();</script>");
        }

    }
}