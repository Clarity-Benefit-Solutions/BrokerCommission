﻿
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

    public partial class Upload_Result : System.Web.UI.Page
    {

        Broker_CommissionEntities db = new Broker_CommissionEntities();


        public static string receive =
           System.Web.Configuration.WebConfigurationManager.AppSettings["receive_emails"].ToString();

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
                
            string query = "SELECT MAX(H.HEADER_ID) HEADER_ID " +
                " , A.BROKER_ID " +
                " , A.BROKER_NAME " +
                " , A.PAYLOCITY_ID " +
                " , A.TOTAL " +
                " FROM " +
                "   [dbo].[COMMISSION_SUMMARY] AS A " +
                "     LEFT JOIN[dbo].[STATEMENT_HEADER] AS H ON A.BROKER_ID = H.BROKER_ID ";
            query += " WHERE 1=1 ";

            // todo: commented. add checkbox for all or only not yet emailed. ?show all statements not only those which have been emailed by default
            //query += " AND H.FLAG!=3 ";


            if (cmb_broker.SelectedIndex > 0)
            {
                query += " AND  A.BROKER_NAME = '" + cmb_broker.SelectedItem.Text + "'";

            }

            query += " GROUP BY A.BROKER_ID , A.BROKER_NAME , A.PAYLOCITY_ID , A.TOTAL ";
            query += " ORDER BY A.BROKER_NAME ";

            SqlDataSource1.SelectCommand = query;
            //lbl_count.Text = q
        }

        protected void LoadList()
        {
            if (Request.QueryString["YEAR"] != null && Request.QueryString["MONTH"] != null)
            {
                lbl_month.Text = util.GetCustomAbbreviatedMonthNames(int.Parse(Request.QueryString["MONTH"].ToString()));
                lbl_year.Text = Request.QueryString["YEAR"].ToString();
            }
            else
            {
                //lbl_month.Text = util.GetCustomAbbreviatedMonthNames(DateTime.Now.Month - 1);
                //lbl_year.Text = DateTime.Now.Year.ToString();

                DataTable last = getLastUpload();

                foreach (DataRow row in last.Rows)
                {
                    lbl_month.Text = row[0].ToString();
                    lbl_year.Text = row[1].ToString();

                }

            }


            cmb_broker.Items.Clear();
            cmb_broker.Items.Add(new ListEditItem("All"));
            DataTable dt_first = LoadDataForBrokersCombo();

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
                    string url = "ViewFile.aspx?BID=" + brokerID + "&MONTH=" + lbl_month.Text + "&YEAR="
                        + lbl_year.Text + "&TOTAL= &&StatementID=" + headerID;
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "popup_window", "popupwindow('" + url + "','" + "View Download Files" + "','" + "1600" + "','" + "1000" + "');", true);
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

                    if (receive == "Broker")
                    {
                        util.SendPDFEmail(from, util.getEmailAddress(int.Parse(model.BROKER_ID.ToString())), model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));
                    }
                    else
                    {
                        util.SendPDFEmail(from, receive, model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));
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
            string url = "SendEmails.aspx?Month=" + lbl_month.Text + "&Year=" + lbl_year.Text;
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

        protected DataTable getLastUpload()
        {
            //todo: what is the purpose of this - it will show the first invoice date in the file!
            DataTable table = new DataTable();

            string query = "SELECT TOP(1) H.MONTH, H.YEAR FROM [dbo].[STATEMENT_HEADER] AS H ORDER BY FLAG, MONTH";

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


        protected DataTable LoadDataForBrokersCombo()
        {
            DataTable table = new DataTable();
            string query = "SELECT * FROM  [dbo].[COMMISSION_SUMMARY]";
            query += " Order by BROKER_NAME ";

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
    }
}