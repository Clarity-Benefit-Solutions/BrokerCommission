using System;
using System.Text;
using System.Data.SqlClient;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Data;
using System.Configuration;
using System.Linq;
using System.IO;
using System.Web;
using System.Collections.Generic;
using DevExpress.Web;
using System.Web.UI.WebControls;
using System.Net;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public partial class ViewFile : System.Web.UI.Page
    {
        Broker_CommissionEntities db = new Broker_CommissionEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["BID"] != null)
                {
                    string bid = Request.QueryString["BID"].ToString();
                    DataLoad();
                    LoadEditTable(bid);
                }
                if (Request.QueryString["statement"] != null)
                {
                    ASPxPageControl1.TabPages[0].Visible = false;
                    ASPxPageControl1.TabPages[2].Visible = false;
                    //ASPxButton1.Visible = false;
                    string bid = Request.QueryString["BID"].ToString();
                    DataLoad();
                    LoadEditTable( bid );
                }
            }

        }

        protected void LoadEditTable(string headerID)
        {

            //string bid = Request.QueryString["BID"].ToString();
            DataTable datat = ReportHelper.datatable(headerID);
            List<STATEMENT_DETAILS> list = new List<STATEMENT_DETAILS>();
            list = (from DataRow dr in datat.Rows
                           select new STATEMENT_DETAILS()
                           {
                               STATUS = dr["EMAIL"].ToString(),
                               QB_CLIENT_NAME =  dr["CLIENT_NAME"].ToString(),
                               QB_FEE =  dr["QB_FEE"].ToString() ,
                               BROKER_NAME =  dr["QB_BROKER_NAME"].ToString() ,
                               QUANTITY = int.Parse(dr["Qty"].ToString()),
                               COMMISSION_RATE = Convert.ToDecimal(dr["COMMISSION_RATE"].ToString()),
                               SALES_PRICE = Convert.ToDecimal(dr["Sales Price"].ToString()), 
                               TOTAL_PRICE = Convert.ToDecimal(dr["COMMISSION AMOUNT"].ToString()),
                               BROKER_STATUS = dr["BROKER_STATUS"].ToString(),
                               DETAIL_ID = int.Parse(dr["ID"].ToString()),
                               START_DATE = dr["START_DATE"].ToString(),
                               INVOICE_NUM = dr["Num"].ToString(),
                               OPEN_BALANCE = decimal.Parse( dr["CLIENT_ID"].ToString() )
                             

                           }).ToList();


            ASPxGridView1.DataSource = list;
            ASPxGridView1.DataBind();
        }

        protected void DataLoad()
        {
            string bid = Request.QueryString["BID"].ToString();
            int brokerID = int.Parse(bid);
            DataTable datat = ReportHelper.datatable(bid); 
          

            DataTable dataM = ReportHelper.dataTable_master(bid);
            List<string> broker_name_list = new List<string>();
            if (dataM.Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(dataM.Rows[0]["BROKER_NAME_ID"].ToString()))
                {
                    //var model = new broker_name() { name = dataM.Rows[0]["BROKER_NAME_ID"].ToString() };
                    broker_name_list.Add(dataM.Rows[0]["BROKER_NAME_ID"].ToString());
                }


                if (!string.IsNullOrEmpty(dataM.Rows[0]["BROKER_NAME_1"].ToString()))
                {
                    //var model = new broker_name() { name = dataM.Rows[0]["BROKER_NAME_1"].ToString() };
                    broker_name_list.Add(dataM.Rows[0]["BROKER_NAME_1"].ToString());
                }


                if (!string.IsNullOrEmpty(dataM.Rows[0]["BROKER_NAME_2"].ToString()))
                {
                    //var model = new broker_name() { name = dataM.Rows[0]["BROKER_NAME_2"].ToString() };
                    broker_name_list.Add(dataM.Rows[0]["BROKER_NAME_2"].ToString());
                }


                if (!string.IsNullOrEmpty(dataM.Rows[0]["BROKER_NAME_3"].ToString()))
                {
                    //var model = new broker_name() { name = dataM.Rows[0]["BROKER_NAME_3"].ToString() };
                    broker_name_list.Add(dataM.Rows[0]["BROKER_NAME_3"].ToString());
                }


                if (!string.IsNullOrEmpty(dataM.Rows[0]["BROKER_NAME_4"].ToString()))
                {
                    //var model = new broker_name() { name = dataM.Rows[0]["BROKER_NAME_4"].ToString() };
                    broker_name_list.Add(dataM.Rows[0]["BROKER_NAME_4"].ToString());
                }

                //todo: not using BROKER_NAME_5 & 6?

            }
            if (broker_name_list.Count > 0)
            {

                List<broker_Import> combine_list = new List<broker_Import>();
                var list = db.Import_OCT.Where(x => broker_name_list.Contains(x.Agent)).OrderBy(x => x.Name).ToList();
                foreach (var item in list)
                {
                    broker_Import model = new broker_Import();

                    string qb_client = item.Name; string qb_memo = item.Memo;
                    model.ID = item.ID;
                    model.Name = qb_client;
                    model.Agent = item.Agent;
                    model.Memo = qb_memo;
                    model.Sales_Price = item.Sales_Price == null? 0 : Convert.ToDecimal(item.Sales_Price.ToString());
                    model.Amount = item.Amount == null ? 0 : Convert.ToDecimal(item.Amount.ToString());
                    model.Qty = item.Qty == null ? 0 : int.Parse(item.Qty.ToString());
                    var client_model = db.CLIENTs.Where(x => x.QB_CLIENT_NAME == qb_client && x.QB_FEE == qb_memo).FirstOrDefault();
                    if (client_model != null)
                    {
                        model.COMMISSION_RATE = client_model.COMMISSION_RATE == null ? 0 : Convert.ToDecimal(client_model.COMMISSION_RATE);
                        model.UNIT = client_model.UNIT;
                        model.broker_id = client_model.BROKER_ID == null ? 0 : int.Parse(client_model.BROKER_ID.ToString());
                        model.START_DATE = client_model.START_DATE;
                        model.exist = true;
                    }
                    else
                    {
                        model.exist = false;
                    }

                    combine_list.Add(model);
                }
                grid_import.DataSource = combine_list.OrderByDescending(x=>x.exist).ThenBy(x=>x.Name).ToList();
                grid_import.DataBind();
            } 
        }
       
      
      

        #region old conversion
        //protected StringBuilder stringb(DataTable dtp)
        //{
        //    StringBuilder sb = new StringBuilder();

        //    string year = Request.QueryString["YEAR"].ToString();
        //    string month = Request.QueryString["MONTH"].ToString();
        //    try
        //    {
        //        string Err = string.Empty;
        //        DataTable dt = dtp;


        //        //pdfDocument Content in HTml Format  
        //        if (dt.Rows.Count > 0)
        //        {
        //            lblBRoker.Text = dt.Rows[0]["BROKER_NAME"] + " #" + dt.Rows[0]["PAYLOCITY_ID"];
        //            sb.Append("<html><head><title></title><link href=\"Content / bootstrap.min.css\" rel=\"stylesheet\" />" +
        //                      //"<style>" + "table, th, td { border: 1px solid black;border - collapse: collapse;  } " +
        //                      //"</style>" +
        //                      "</head><body>");
        //            string strActualRecords = string.Empty;
        //            strActualRecords = "<table style=\"width:100%;font-size: 10pt; font-family:Georgia, serif;border: 1px solid black;border - collapse: collapse; \">";
        //            strActualRecords += "<tr><td colspan=\"9\" style=\"height:60px;background-color:DodgerBlue;text-align: center;white-space: nowrap; border: 1px solid black;border - collapse: collapse;font-weight:bolder\">" +
        //                                dt.Rows[0]["BROKER_NAME"] + " " + dt.Rows[0]["PAYLOCITY_ID"] + " : " + month + " " + year +
        //                                " Commission Statement</td></tr>";

        //            strActualRecords += "<tr><td colspan=\"9\" style=\"height:50px;text-align: center;font-weight:bold; white-space: nowrap;;border: 1px solid black;border - collapse: collapse; \">" +
        //                                dt.Rows[0]["BROKER_STATUS"] + " </td></tr>";
        //            strActualRecords += "<tr><td style=\"text-align: center;font-weight:bold;width: 5%;font-size: 7pt;white-space: nowrap;;border: 1px solid black;border - collapse: collapse; \">" + "DATE" + "</td>" +
        //                                "<td style=\"width: 20%;text-align: center;font-weight:bold;font-size: 7pt;;border: 1px solid black;border - collapse: collapse; \">NAME</td>"

        //                                + "<td style=\"width: 10%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">START DATE</td>"
        //                                + "<td style=\"width: 20%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">ITEM</td>"
        //                                + "<td style=\"width: 15%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">AGENT</td>"
        //                                + "<td style=\"width: 5%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">QUANTITY</td>"
        //                                + "<td style=\"width: 10%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">AMOUNT</td>"
        //                                + "<td style=\"width: 5%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">RATE</td>"
        //                                + "<td style =\"width: 10%;font-weight:bold;font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">COMMISSION AMOUNT</td></tr>";
        //            for (int i = 0; i < dt.Rows.Count; i++)
        //            {
        //                strActualRecords += "<tr>";
        //                strActualRecords += "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + Convert.ToDateTime(dt.Rows[i]["date"].ToString()).ToString("MM/dd/yyyy") + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["QB_CLIENT"].ToString() + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["START_DATE"].ToString() + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["QB_FEE"].ToString() + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["QB_BROKER_NAME"].ToString()
        //                                    + "</td>" + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["Qty"].ToString() + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + util.DoFormat(Convert.ToDouble(dt.Rows[i]["Amount"].ToString())) + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + dt.Rows[i]["COMMISSION_RATE"].ToString() + "</td>"
        //                                    + "<td style=\"font-size: 7pt;border: 1px solid black;border - collapse: collapse;height:40px; \">"
        //                                    + util.DoFormat(Convert.ToDouble(dt.Rows[i]["COMMISSION AMOUNT"].ToString())) + "</td>";
        //                strActualRecords += "</tr>";
        //            }
        //            strActualRecords += "<tr><td colspan=\"8\" style=\"height:50px;text-align: center;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" + " Total Commission Payable for " + month + " " + year + " </td>"+
        //                "<td style=\"height:50px;text-align: right;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" +

        //                  "$" + util.DoFormat(Convert.ToDouble(get_Total())) + " </td></tr>";

        //            strActualRecords += "</table>";
        //            sb.Append(strActualRecords);
        //            sb.Append("</body></html>");
        //        }



        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }

        //    return sb;
        //}
        //protected StringBuilder stringPDF(DataTable dtp)
        //{
        //    StringBuilder sb = new StringBuilder();

        //    string year = Request.QueryString["YEAR"].ToString();
        //    string month = Request.QueryString["MONTH"].ToString();
        //    try
        //    {
        //        string Err = string.Empty;
        //        DataTable dt = dtp;


        //        //pdfDocument Content in HTml Format  
        //        if (dt.Rows.Count > 0)
        //        {
        //            sb.Append("<html><head><title></title>" +

        //                      "</head><body>");
        //            string strActualRecords = string.Empty;
        //            strActualRecords = "<table border=\"1\" style=\"width:100%;font-size: 10pt; font-family:Tahoma; border: 1px solid black;border - collapse: collapse;\">";
        //            strActualRecords += "<tr><td colspan=\"9\" style=\"text-align: center;white-space: nowrap; border: 1px solid black;border - collapse: collapse;font-weight:bold;\">" +
        //                                dt.Rows[0]["BROKER_NAME"] + " " + dt.Rows[0]["PAYLOCITY_ID"] + " : " + month + " " + year +
        //                                " Commission Statement</td></tr>";

        //            strActualRecords += "<tr><td colspan=\"9\" style=\"background-color:DodgerBlue;text-align: center;font-weight:bold; white-space: nowrap;border: 1px solid black;border - collapse: collapse;\">" +
        //                                dt.Rows[0]["BROKER_STATUS"] + " </td></tr>";
        //            strActualRecords += "<tr><td width=\"10% \" style=\"text-align: center;font-size: 9pt;font-weight:bold;border: 1px solid black;border - collapse: collapse; white-space: nowrap;border=\"1\"\">" + "DATE" + "</td>" +
        //                                "<td width=\"20% \" style=\"text-align: center;font-weight:bold;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">NAME</td>"

        //                                + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">START DATE</td>"
        //                                + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">ITEM</td>"
        //                                + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AGENT</td>"
        //                                + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">QTY</td>"
        //                                + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AMOUNT($)</td>"
        //                                + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">RATE</td>"
        //                                + "<td width=\"15% \" style =\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">COMMISSION AMOUNT($)</td></tr>";
        //            for (int i = 0; i < dt.Rows.Count; i++)
        //            {
        //                strActualRecords += "<tr>";
        //                strActualRecords += "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + Convert.ToDateTime(dt.Rows[i]["date"].ToString()).ToString("MM/dd/yyyy") + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["QB_CLIENT"].ToString() + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["START_DATE"].ToString() + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["QB_FEE"].ToString() + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["QB_BROKER_NAME"].ToString()
        //                                    + "</td>" + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["Qty"].ToString() + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + util.DoFormat(Convert.ToDouble(dt.Rows[i]["Amount"].ToString())) + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + dt.Rows[i]["COMMISSION_RATE"].ToString() + "</td>"
        //                                    + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
        //                                    + util.DoFormat(Convert.ToDouble(dt.Rows[i]["COMMISSION AMOUNT"].ToString())) + "</td>";
        //                strActualRecords += "</tr>";
        //            }

        //            //strActualRecords += "<tr><td colspan=\"9\" style=\"height:50px;text-align: right;font-weight:bold; white-space: nowrap;\">" + " Total Commission Payable for " + month + " " + year + "    $" +
        //            //                    util.DoFormat(Convert.ToDouble(get_Total())) + " </td></tr>";
        //            strActualRecords += "<tr><td colspan=\"8\" style=\"height:50px;text-align: center;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" + " Total Commission Payable for " + month + " " + year + " </td>" +
        //              "<td style=\"height:50px;text-align: right;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" +

        //                "$" + util.DoFormat(Convert.ToDouble(get_Total())) + " </td></tr>";
        //            strActualRecords += "</table>";
        //            sb.Append(strActualRecords);
        //            sb.Append("</body></html>");
        //        }

        //        else
        //        {
        //            sb.Append("<html><head><title></title>" +

        //                      "</head><body>");
        //            string strActualRecords = string.Empty;
        //            strActualRecords = "<table border=\"1\" style=\"width:100%;font-size: 10pt; font-family:Tahoma; border: 1px solid black;border - collapse: collapse;\">";
        //            strActualRecords += "<tr><td colspan=\"9\" style=\"text-align: center;white-space: nowrap; border: 1px solid black;border - collapse: collapse;font-weight:bold;\">" +
        //                                dt.Rows[0]["BROKER_NAME"] + " " + dt.Rows[0]["PAYLOCITY_ID"] + " : " + month + " " + year +
        //                                " Commission Statement</td></tr>";

        //            strActualRecords += "<tr><td colspan=\"9\" style=\"background-color:DodgerBlue;text-align: center;font-weight:bold; white-space: nowrap;border: 1px solid black;border - collapse: collapse;\">" +
        //                                dt.Rows[0]["BROKER_STATUS"] + " </td></tr>";
        //            strActualRecords += "<tr><td width=\"10% \" style=\"text-align: center;font-size: 9pt;font-weight:bold;border: 1px solid black;border - collapse: collapse; white-space: nowrap;border=\"1\"\">" + "DATE" + "</td>" +
        //                                "<td width=\"20% \" style=\"text-align: center;font-weight:bold;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">NAME</td>"

        //                                + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">START DATE</td>"
        //                                + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">ITEM</td>"
        //                                + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AGENT</td>"
        //                                + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">QTY</td>"
        //                                + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AMOUNT($)</td>"
        //                                + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">RATE</td>"
        //                                + "<td width=\"15% \" style =\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">COMMISSION AMOUNT($)</td></tr>";


        //            //strActualRecords += "<tr><td colspan=\"9\" style=\"height:50px;text-align: right;font-weight:bold; white-space: nowrap;\">" + " Total Commission Payable for " + month + " " + year + "    $" +
        //            //                    util.DoFormat(Convert.ToDouble(get_Total())) + " </td></tr>";
        //            strActualRecords += "<tr><td colspan=\"8\" style=\"height:50px;text-align: center;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" + " Total Commission Payable for " + month + " " + year + " </td>" +
        //              "<td style=\"height:50px;text-align: right;font-weight:bold;font-size: 7pt; white-space: nowrap;border: 1px solid black;border - collapse: collapse;height:40px; \">" +

        //                "$" + util.DoFormat(Convert.ToDouble(get_Total())) + " </td></tr>";
        //            strActualRecords += "</table>";
        //            sb.Append(strActualRecords);
        //            sb.Append("</body></html>");
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }

        //    return sb;
        //}

        #endregion
        protected string get_Total()
        {
            string total = "";

            DataTable dt = GRIDTABLE();
            foreach (DataRow row in dt.Rows)
            {
                string stringValue = row[0].ToString();

                double d;
                if (double.TryParse(stringValue, out d))
                {
                    total = d.ToString();
                }

            }


            return total;
        }
        protected DataTable GRIDTABLE()
        {
            DataTable table = new DataTable();



            string query = "EXEC [dbo].[GET_TOTAL] @bid = '" + Request.QueryString["BID"].ToString() + "' ";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataTable dt = new DataTable())
                        {
                            sda.Fill(dt);


                            table = dt;
                        }
                    }
                }
            }

            return table;
        }
        protected void LoadHtml(DataTable dtp)
        {
            //lbl_literal.Text = 
                
                //stringb(dtp).ToString();
        }

        protected void btn_edit_OnClick(object sender, EventArgs e)
        {
            if (Request.QueryString["Flag"] != null)
            {
                string bid = Request.QueryString["BID"].ToString();
                int brokerID = int.Parse(bid);
                var model = db.BROKER_MASTER.Where(x => x.ID == brokerID).FirstOrDefault();
                if (model != null)
                {
                    string FilePath = ReportHelper.PDFOutPut
                   + "\\"
                   + model.PAYLOCITY_ID + "_" + model.BROKER_NAME + "_" + Request.QueryString["MONTH"]
                   + "_" + Request.QueryString["YEAR"] + ".pdf";


                   WebClient User = new WebClient();
                    Byte[] FileBuffer = User.DownloadData(FilePath);
                    if (FileBuffer != null)
                    {
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("content-length", FileBuffer.Length.ToString());
                        Response.BinaryWrite(FileBuffer);
                    }
                }
               
            }
            else
            {
                string bid = Request.QueryString["BID"].ToString();
                int brokerID = int.Parse(bid);
                string FilePath = ReportHelper.CreatedWord_fromResult(brokerID); 
                WebClient User = new WebClient();
                Byte[] FileBuffer = User.DownloadData(FilePath);
                if (FileBuffer != null)
                {
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("content-length", FileBuffer.Length.ToString());
                    Response.BinaryWrite(FileBuffer);
                }
            }
           
            #region
            //Document pdfDocument = new Document();
            //string pdffilename = DateTime.Now.Ticks.ToString() + ".pdf";
            //PdfWriter pdfWriter = PdfWriter.GetInstance(pdfDocument, HttpContext.Current.Response.OutputStream);
            //pdfDocument.Open();


            //string bid = Request.QueryString["BID"].ToString();
            //DataTable datat = ReportHelper.datatable(bid);
            //String htmlText =
            //    //stringPDF(datat).ToString();

            //StringReader str = new StringReader(htmlText);
            //HTMLWorker htmlworker = new HTMLWorker(pdfDocument);
            //htmlworker.Parse(str);
            //pdfWriter.CloseStream = false;
            //pdfDocument.Close();
            ////Download Pdf  
            //Response.Buffer = true;
            //Response.ContentType = "application/pdf";
            //Response.AppendHeader("Content-Disposition", "attachment; filename=" + pdffilename);
            //Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //Response.Write(pdfDocument);
            //Response.Flush();
            //Response.End();
            #endregion
        }


        protected void btn_save_OnClick(object sender, EventArgs e)
        {

            save_all();
            DataLoad();


        }

        protected void save_all()
        {
            int bid = 0;
            if (Request.QueryString["BID"] != null)
            {
                bid = int.Parse(Request.QueryString["BID"].ToString());
            }
                for (int i = 0; i < grid_import.VisibleRowCount; i++)
            {
                
               ASPxCheckBox cb = grid_import.FindRowCellTemplateControl(i, null, "cb") as ASPxCheckBox; 
               HiddenField  hid_id = grid_import.FindRowCellTemplateControl(i, null, "hid_id") as HiddenField;
               ASPxLabel lbl_qb_clientName = grid_import.FindRowCellTemplateControl(i, null, "lbl_qb_clientName") as ASPxLabel;
               ASPxLabel lbl_QB_FEE = grid_import.FindRowCellTemplateControl(i, null, "lbl_QB_FEE") as ASPxLabel;
               //ASPxLabel lbl_QB_FEE = grid_import.FindRowCellTemplateControl(i, null, "lbl_QB_FEE") as ASPxLabel;
               ASPxTextBox txt_rate = grid_import.FindRowCellTemplateControl(i, null, "txt_rate") as ASPxTextBox;

                ASPxComboBox txt_UNIT = grid_import.FindRowCellTemplateControl(i, null, "txt_UNIT") as ASPxComboBox;

                if (cb != null && cb.Enabled == true && cb.Checked == true)
                {
                    if(!string.IsNullOrEmpty(txt_UNIT.Text) && !string.IsNullOrEmpty(txt_rate.Text))
                    {
                        //int bid = int.Parse(hid_id.Value == null ? "0" : hid_id.Value);
                        string text = txt_rate.Text.Replace("$", "");
                        decimal amount = 0.0m;
                        decimal.TryParse(txt_rate.Text, out amount);

                        CLIENT cl = new CLIENT()
                        {
                            QB_CLIENT_NAME = lbl_qb_clientName.Text,
                            CLIENT_NAME = lbl_qb_clientName.Text,
                            QB_FEE = lbl_QB_FEE.Text,
                            FEE_MEMO = lbl_QB_FEE.Text,
                            BROKER_ID = bid,
                            COMMISSION_RATE = amount,
                            UNIT = txt_UNIT.Text
                        };

                        db.CLIENTs.Add(cl);
                        db.SaveChanges();
                    }
                      
                    else
                    {
                        string message = "Please Fill Out the QTY and Unit";
                        ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);
                    }
                   



                }
                //else if (cb != null && cb.Enabled == false && cb.Checked == true)
                //{
                //    if (!string.IsNullOrEmpty(txt_UNIT.Text) && !string.IsNullOrEmpty(txt_rate.Text))
                //    {
                //        //int bid = int.Parse(hid_id.Value == null ? "0" : hid_id.Value);
                //        string text = txt_rate.Text.Replace("$", "");
                //        decimal amount = 0.0m;
                //        decimal.TryParse(txt_rate.Text, out amount);

                //        CLIENT cl = new CLIENT()
                //        {
                //            QB_CLIENT_NAME = lbl_qb_clientName.Text,
                //            CLIENT_NAME = lbl_qb_clientName.Text,
                //            QB_FEE = lbl_QB_FEE.Text,
                //            FEE_MEMO = lbl_QB_FEE.Text,
                //            BROKER_ID = bid,
                //            COMMISSION_RATE = amount,
                //            UNIT = txt_UNIT.Text
                //        };

                //        db.CLIENTs.Add(cl);
                //        db.SaveChanges();
                //    }

                //}


            }


           
        }

        public static string receive =
        System.Web.Configuration.WebConfigurationManager.AppSettings["receive_emails"].ToString();

        protected void btn_state_OnClick(object sender, EventArgs e)
        {
            if (Request.QueryString["BID"] != null && Request.QueryString["MONTH"] != null && Request.QueryString["YEAR"] != null)
            {
                int bid = int.Parse(Request.QueryString["BID"].ToString());
                int year = int.Parse(Request.QueryString["YEAR"].ToString());
                string month = (Request.QueryString["MONTH"].ToString());
                #region email statement

                var model = db.STATEMENT_HEADER.Where(x => x.MONTH == month && x.YEAR == year && x.BROKER_ID == bid).FirstOrDefault();

                if (model != null)
                {
                    string from = util.from_email;
                    util.SendPDFEmail(from, receive, model.BROKER_NAME, month, year, int.Parse(model.BROKER_ID.ToString()));
                    model.FLAG = 3;
                    db.SaveChanges();
                }


                DataLoad();

                #endregion

                Page.ClientScript.RegisterStartupScript(this.GetType(), "wincloses", "<script>CloseTheFreakingWindow();</script>");
            }
        }

        protected void ASPxGridView1_PageIndexChanged(object sender, EventArgs e)
        {
            var view = sender as ASPxGridView;
            if (view == null) return;
            var pageIndex = view.PageIndex;
            ASPxGridView1.PageIndex = pageIndex;
            string bid = Request.QueryString["BID"].ToString();
            LoadEditTable( bid) ;
        }

        protected void ASPxGridView1_RowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if(e.CommandArgs.CommandName.ToString() == "delete")
            {
                int detailID = int.Parse(e.CommandArgs.CommandArgument.ToString());
                //Response.Write(detailID);
                var model = db.STATEMENT_DETAILS_ADD.Where(x => x.DETAIL_ID == detailID).FirstOrDefault();
                if (model != null)
                {
                    db.STATEMENT_DETAILS_ADD.Remove(model);
                    db.SaveChanges();
                }
                string bid = Request.QueryString["BID"].ToString();
                LoadEditTable(bid);
            }
            else if (e.CommandArgs.CommandName.ToString() == "delete_client")
            {
                int detailID = int.Parse(e.CommandArgs.CommandArgument.ToString());
                //Response.Write(detailID);
                var model = db.CLIENTs.Where(x => x.CLIENT_ID == detailID).FirstOrDefault();
                if (model != null)
                {
                    db.CLIENTs.Remove(model);
                    db.SaveChanges();
                }
                string bid = Request.QueryString["BID"].ToString();
                LoadEditTable(bid);
            }
        }

        protected void btn_addNew_Click(object sender, EventArgs e)
        {
            string bid = Request.QueryString["BID"].ToString();
            int statementID = int.Parse(bid);//brokerID

            if (Request.QueryString["StatementID"] != null) 
            {
                int sid = int.Parse(Request.QueryString["StatementID"].ToString());

                STATEMENT_DETAILS_ADD model = new STATEMENT_DETAILS_ADD()
                {
                    HEADER_ID = sid,
                    BROKER_ID = getBrokerID(sid),
                    BROKER_NAME = getBrokerName(sid),
                    CLIENT_NAME = txt_name.Text,
                    QB_CLIENT_NAME = txt_name.Text,
                    COMMISSION_RATE = Convert.ToDecimal(txt_commissionrate.Text),
                    SALES_PRICE = Convert.ToDecimal(txt_sales.Text),
                    FEE_MEMO = txt_item.Text,
                    QB_FEE = txt_item.Text,
                    QUANTITY = int.Parse(txt_qt.Text),
                    UNIT = "Per Qt",
                    PAYLOCITY_ID = getPaylocityID(statementID),
                    TOTAL_PRICE = Convert.ToDecimal(txt_commission_amount.Text),
                    RESULTID = util.getMaxResult(),
                    START_DATE = "N/A",
                    BROKER_STATUS = getBRokerStatus(statementID)
                };

                db.STATEMENT_DETAILS_ADD.Add(model);
                db.SaveChanges();
                LoadEditTable(bid);



            }//? 0 : int.Parse(Request.QueryString["StatementID"].ToString())

          
        }


        protected int getBrokerID(int statementID)
        {
            int id = 0;
            var statementModel = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == statementID).FirstOrDefault();
            if(statementModel != null)
            {
                id = statementModel.BROKER_ID == null? 0:int.Parse(statementModel.BROKER_ID.ToString());

            }


            return id;
        }

        protected string getPaylocityID(int brokerID)
        {
            string id = "";
            var statementModel = db.BROKER_MASTER.Where(x => x.ID == brokerID).FirstOrDefault();
            if (statementModel != null)
            {
                id = statementModel.PAYLOCITY_ID == null ? "" :  statementModel.PAYLOCITY_ID.ToString();

            }


            return id;
        }
        protected string getBRokerStatus(int brokerID)
        {
            string id = "";
            var statementModel = db.BROKER_MASTER.Where(x => x.ID == brokerID).FirstOrDefault();
            if (statementModel != null)
            {
                id = statementModel.BROKER_STATUS == null ? "" : statementModel.BROKER_STATUS.ToString();

            }


            return id;
        }
        protected string getBrokerName(int statementID)
        {
            string id = "";
            var statementModel = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == statementID).FirstOrDefault();
            if (statementModel != null)
            {
                id = statementModel.BROKER_NAME == null ? "" : statementModel.BROKER_NAME;

            } 
            return id;
        }

       

        protected void ASPxButton2_Click(object sender, EventArgs e)
        {
            DataLoad();
        }
    }

    public class broker_Import
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Memo { get; set; }
        public string Agent { get; set; }
        public int Qty { get; set; }
        public decimal COMMISSION_RATE { get; set; }
        public string UNIT { get; set; }
        public string START_DATE { get; set; } 
        public decimal Sales_Price { get; set; }
        public decimal Amount { get; set; }
        public bool exist { get; set; }
        public int broker_id { get; set; }
    }

}