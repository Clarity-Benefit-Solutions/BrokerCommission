using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Export;

using DevExpress.XtraPrinting;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public partial class StatementSearch : System.Web.UI.Page
    {

        Broker_CommissionEntities db = new Broker_CommissionEntities();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadList();
                DataLoad();
            }
        }
        protected void ASPxMenu1_ItemClick(object source, MenuItemEventArgs e)
        {
            DataLoad();
            if (e.Item.GroupName == "Excel")
            {
                gridExport.WriteXlsxToResponse(new XlsxExportOptionsEx { ExportType = ExportType.WYSIWYG });
            }
            else if (e.Item.GroupName == "CSV")
            {
                gridExport.WriteCsvToResponse(new CsvExportOptionsEx { ExportType = ExportType.WYSIWYG });
            }


        }

        protected void DataLoad()
        {


            string query = "SELECT [dbo].[STATEMENT_HEADER].[HEADER_ID], [dbo].[STATEMENT_HEADER].[MONTH],[dbo].[STATEMENT_HEADER].[YEAR],[dbo].[STATEMENT_HEADER].[BROKER_NAME],[FLAG],[STATEMENT_TOTAL],[Change_Date],[dbo].[BROKER_MASTER].PAYLOCITY_ID " +
                     "FROM[dbo].[STATEMENT_HEADER] LEFT JOIN[dbo].[BROKER_MASTER] ON[dbo].[STATEMENT_HEADER].BROKER_ID = [dbo].[BROKER_MASTER].ID";


            if (cmb_broker.SelectedIndex > 0)
            {
                query += " WHERE [dbo].[STATEMENT_HEADER].BROKER_NAME = '" + cmb_broker.SelectedItem.Text + "'";

            }

            SqlDataSource1.SelectCommand = query;
            //lbl_count.Text = q
        }

        protected void LoadList()
        {

            // sumeet: always use month of last uploaded raw data
            var month = "";
            var year = "";
            util.Period period = util.getLastUpload();

            month = period.month;
            year = period.year.ToString();

            // todo: if we need to switch to view/process previops perreiod statements, we need to add a UI and method to swetch to the period
            lbl_month.Text = month;
            lbl_year.Text = year.ToString();


            cmb_broker.Items.Clear();
            cmb_broker.Items.Add(new ListEditItem("All"));
            DataTable dt_first = GRIDTABLE();

            foreach (DataRow row in dt_first.Rows)
            {
                string first = row["BROKER_Name"].ToString();
                cmb_broker.Items.Add(new ListEditItem(first));
            }

            cmb_broker.SelectedIndex = 0;




        }

        protected void grid_summary_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "statement")
            {
                int headerID = int.Parse(e.CommandArgs.CommandArgument.ToString());
                var model = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == headerID).FirstOrDefault();
                if (model != null)
                {
                    int brokerID = model.BROKER_ID == null ? 0 : int.Parse(model.BROKER_ID.ToString());
                    string url = "ViewFile.aspx?BID=" + brokerID + "&StatementID=" + headerID + "&Flag=3";
                    // Page.ClientScript.RegisterStartupScript(this.GetType(), "popup_window", "popupwindow('" + url + "','" + "View Download Files" + "','" + "1600" + "','" + "1000" + "');", true);
                    ClientScript.RegisterClientScriptBlock(this.GetType(), "redirect", "window.open('" + url + "')", true);
                    //Response.Redirect (url);

                }

            }
            else if (e.CommandArgs.CommandName == "email")
            {
                #region email statement
                string month = lbl_month.Text;
                int year = int.Parse(lbl_year.Text);
                int bid = int.Parse(e.CommandArgs.CommandArgument.ToString());
                var model = db.STATEMENT_HEADER.Where(x => x.MONTH == month && x.YEAR == year && x.BROKER_ID == bid).FirstOrDefault();

                if (model != null)
                {
                    string from = util.from_email;
                    //util.SendPDFEmail(from, receive, model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));

                    if (util.receive == "Broker")
                    {
                        util.SendPDFEmail(from, util.getEmailAddress(int.Parse(model.BROKER_ID.ToString())), model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));
                    }
                    else
                    {
                        util.SendPDFEmail(from, util.receive, model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));
                    }


                    model.FLAG = 3;
                    db.SaveChanges();
                }


                DataLoad();

                #endregion
            }
        }




        protected void btn_Approve_Email_OnClick(object sender, EventArgs e)
        {
            string url = "SendEmails.aspx";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "popup_window", "popupwindow('" + url + "','" + "View Download Files" + "','" + "1200" + "','" + "800" + "');", true);
        }

        protected void btn_refresh_OnClick(object sender, EventArgs e)
        {
            DataLoad();
        }


        //FRS_SSIS_PaymentFile
        protected void execute_ssis()
        {
            string sum = "";
            string query = "";

            query = "[dbo].[SP_IMPORT_FILE_SENT_SSIS]";


            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ConnectionString;

            // Define the ADO.NET Objects


            SqlConnection con = new SqlConnection(constr);

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();

            int rowsAffected = cmd.ExecuteNonQuery();

            con.Close();

        }

       

        protected DataTable GRIDTABLE()
        {
            DataTable table = new DataTable();
            string query = "SELECT * FROM  [dbo].[COMMISSION_SUMMARY]";

            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"]
                .ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;

                        sda.Fill(table);



                    }
                }
            }

            return table;
        }

        protected void SelectedIndexChanged(object sender, EventArgs e)
        {

            DataLoad();

        }

        



        protected void grid_summary_OnPageIndexChanged(object sender, EventArgs e)
        {
            var view = sender as ASPxGridView;
            if (view == null) return;
            var pageIndex = view.PageIndex;
            grid_summary.PageIndex = pageIndex;
            DataLoad();
        }

        protected void filter_btn_Click(object sender, EventArgs e)
        {
            string query = "SELECT [dbo].[STATEMENT_HEADER].[HEADER_ID], [dbo].[STATEMENT_HEADER].[MONTH],[dbo].[STATEMENT_HEADER].[YEAR],[dbo].[STATEMENT_HEADER].[BROKER_NAME],[FLAG],[STATEMENT_TOTAL],[Change_Date],[dbo].[BROKER_MASTER].PAYLOCITY_ID " +
                        "FROM[dbo].[STATEMENT_HEADER] LEFT JOIN[dbo].[BROKER_MASTER] ON[dbo].[STATEMENT_HEADER].BROKER_ID = [dbo].[BROKER_MASTER].ID";


            if (cmb_broker.SelectedIndex > 0)
            {
                query += " WHERE [dbo].[STATEMENT_HEADER].BROKER_NAME = '" + cmb_broker.SelectedItem.Text + "'";

            }
            else if (from_date.Value != "" && to_date.Value != "")
            {
                DateTime toDateinfo = Convert.ToDateTime(to_date.Value);
                DateTime fromDateinfo = Convert.ToDateTime(from_date.Value);
                string fromyear = Convert.ToString(fromDateinfo.Year + "" + fromDateinfo.Month);
                string toyear = Convert.ToString(toDateinfo.Year+""+toDateinfo.Month);

                //lbl_count.Text = q
                query += " where Convert(int,CONCAT([dbo].[STATEMENT_HEADER].[YEAR], MONTH([MONTH] + '1,1')))  between " + fromyear + " and " + toyear + "";
            }

            
            SqlDataSource1.SelectCommand = query;
            //lbl_count.Text = q
        }
    }
}