using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;

using Aspose.Words;
using Aspose.Words.Rendering;
using Aspose.Words.Tables;
using iTextSharp.text;
using Document = Aspose.Words.Document;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public class ReportHelper
    {
        private static Broker_CommissionEntities db = new Broker_CommissionEntities();
        public static string PDFOutPut =
                System.Web.Configuration.WebConfigurationManager.AppSettings["PDFOutPut"].ToString();

        public static string PDFOutPut_Test =
               System.Web.Configuration.WebConfigurationManager.AppSettings["PDFOutPut_Test"].ToString();

        private static string debugMode =
          System.Web.Configuration.WebConfigurationManager.AppSettings["DebugMode"].ToString();

        private static void WriteCell(int tableindex, int rowindex, int colindex, string str, Document document)
        {
          
            DocumentBuilder builder = new DocumentBuilder(document);
            builder.MoveToCell(tableindex, rowindex, colindex, 0);
            builder.Write(str);
        }


        private static void InsertRow(int tableindex, int rowindex, int colindex, Document document)
        {
            DocumentBuilder builder = new DocumentBuilder(document);
            string guid = Guid.NewGuid().ToString();
            builder.MoveToCell(tableindex, rowindex, colindex, 0);
            builder.StartBookmark(guid);
            builder.EndBookmark(guid);
            builder.MoveToBookmark(guid);
            Cell refCell = builder.CurrentNode.GetAncestor(NodeType.Cell) as Cell;
            if (refCell != null)
            {
                Row srcRow = (Row)refCell.ParentRow.Clone(true);
                Row newRow = (Row)srcRow.Clone(true);
                refCell.ParentRow.ParentTable.InsertAfter(newRow, refCell.ParentRow);

            }
            builder.Document.Range.Bookmarks[guid].Remove();
        }
        #region Request Form
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sq"></param>
        public static string CreatedWord(int statementID)
        {
            string output = "";

            Document doc = new Document();

            var statement_Header = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == statementID).FirstOrDefault();
            if (statement_Header != null)
            {
                string paylocity_ID = "";
                string broker_Status = "";

                //todo: also order by memo within clientname
                var list = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE == 0).OrderBy(x => x.CLIENT_NAME).ToList();
                var list_pending = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE != 0).OrderBy(x => x.CLIENT_NAME).ToList();
                int broker_Id = int.Parse(statement_Header.BROKER_ID.ToString());

                var broker_Master = db.BROKER_MASTER.Where(x => x.ID == broker_Id).FirstOrDefault();
                if (broker_Master != null)
                {
                    paylocity_ID = broker_Master.PAYLOCITY_ID;
                    broker_Status = broker_Master.BROKER_STATUS;
                }

                DateTime From = Convert.ToDateTime((statement_Header.MONTH + "/01/" + statement_Header.YEAR).ToString());
                DateTime To = Convert.ToDateTime((From.Month + "/" + DateTime.DaysInMonth(statement_Header.YEAR, From.Month) + "/" + statement_Header.YEAR).ToString());
                string flowpath = System.Web.HttpContext.Current.Server.MapPath("~/Content/BrokerCommissionStatement.doc");
                doc = new Document(flowpath);
                SetBookMark(doc, "BorkerName", statement_Header.BROKER_NAME);

                //SetBookMark(doc, "From", );
                SetBookMark(doc, "Month", char.ToUpper(statement_Header.MONTH[0]) + statement_Header.MONTH.Substring(1).ToLower());
                SetBookMark(doc, "From", From.ToShortDateString());

                //SetBookMark(doc, "To", statement_Header.MONTH.Substring(0, 3) + "/01/" + statement_Header.YEAR);
                SetBookMark(doc, "Year", statement_Header.YEAR.ToString());
                SetBookMark(doc, "To", To.ToShortDateString());

                int i = 1;
                int CurrentRow = 9;//starting line
                int tableindex = 0;//table col index
                decimal total_1 = 0.00m;
                foreach (var a in list)
                {
                    if (list.Count() != i)
                    {
                        InsertRow(tableindex, CurrentRow, 0, doc);
                    }
                    //Insert to each row
                    //WriteCell(tableindex, CurrentRow, 0, i.ToString(), doc);
                    //WriteCell(tableindex, CurrentRow, 1, statement_Header.MONTH.ToString().Substring(0, 3) + "/"+ statement_Header.YEAR.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 1, Convert.ToDateTime(a.INVOICE_DATE).ToString("MM/dd/yyyy"), doc);

                    WriteCell(tableindex, CurrentRow, 2, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble(a.SALES_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble((a.SALES_PRICE * a.QUANTITY)).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Convert.ToDouble(a.COMMISSION_RATE).ToString("C3", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Convert.ToDouble(a.TOTAL_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    total_1 += a.TOTAL_PRICE == null ? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());
                  
                    i++;
                    CurrentRow++;

                    var invoiceMode = new SENT_INVOICE()
                    {
                        INVOICE_NUM = a.INVOICE_NUM
                        , OPEN_BALANCE = a.BROKER_ID

                    };
                    db.SENT_INVOICE.Add(invoiceMode);
                    db.SaveChanges();

                }
                SetBookMark(doc, "Paid_Total", Convert.ToDouble(total_1).ToString("C3", CultureInfo.CurrentCulture));
                CurrentRow = CurrentRow + 6;

                decimal total_2 = 0.00m;
                foreach (var a in list_pending)
                {
                    if (list_pending.Count() != i)
                    {
                        InsertRow(tableindex, CurrentRow, 0, doc);
                    }
                   
                    WriteCell(tableindex, CurrentRow, 1, Convert.ToDateTime(a.INVOICE_DATE).ToString("MM/dd/yyyy"), doc);

                    WriteCell(tableindex, CurrentRow, 2, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble(a.SALES_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble((a.SALES_PRICE * a.QUANTITY)).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Convert.ToDouble(a.COMMISSION_RATE).ToString("C3", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Convert.ToDouble(a.TOTAL_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);

                    total_2 += a.TOTAL_PRICE == null ? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());

                    i++;
                    CurrentRow++;
                }

                SetBookMark(doc, "pending_Total", Convert.ToDouble(total_2).ToString("C3", CultureInfo.CurrentCulture));
                string urlsp = "http://" + System.Web.HttpContext.Current.Request.Url.Authority;
                string imgpath = "<img width='250' height='100' src='" + urlsp + "/Content/Images/Clarity_Secondary.png.png' />";
                DocumentBuilder dbuiderfuj = new DocumentBuilder(doc);
                dbuiderfuj.MoveToBookmark("Logo");
                dbuiderfuj.InsertHtml(imgpath);

                MemoryStream ms = new MemoryStream();
                doc.Save(ms, SaveFormat.Doc);
                //sq.docBase64 = Convert.ToBase64String(ms.ToArray());
                string pdfPath = PDFOutPut + paylocity_ID + "_" + statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";
                string pdfPath_Test = PDFOutPut_Test + paylocity_ID + "_" + statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";

                string savedUrl = "";

                if (debugMode == "True")
                {
                    //\\+ statement_Header.MONTH + "_" + statement_Header.YEAR + "\\"

                    savedUrl = pdfPath_Test;
                }
                else
                {
                    savedUrl = pdfPath;
                }

                doc.Save(savedUrl);
                ms.Close();


                output = savedUrl;
            }

            return output;
        }
        public static DataTable dataTable_master(string bid)
        {
            DataTable dt = new DataTable();
            string queryString = "SELECT BROKER_NAME_1, BROKER_NAME_2, BROKER_NAME_3, BROKER_NAME_4, BROKER_NAME_ID FROM dbo.BROKER_MASTER WHERE ID =" + bid;
            string conn = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ToString();
            var table = new DataTable();
            using (SqlConnection sql = new SqlConnection(conn))
            {
                SqlCommand command = new SqlCommand(queryString, sql);
                sql.Open();
                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(table);
                sql.Close();
                da.Dispose();
            }
            dt = table;

            return dt;
        }
        public static DataTable datatable(string bid)
        {
            DataTable dt = new DataTable();
            //todo: memo added to order by
            string queryString = "SELECT * FROM [dbo].[COMMISSION_RESULT] WHERE BROKER_ID = " + bid + " ORDER BY QB_CLIENT_NAME, MEMO";
            string conn = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ToString();
            var table = new DataTable();
            using (SqlConnection sql = new SqlConnection(conn))
            {
                SqlCommand command = new SqlCommand(queryString, sql);
                sql.Open();
                SqlDataAdapter da = new SqlDataAdapter(command);
                da.Fill(table);
                sql.Close();
                da.Dispose();
            }
            dt = table;

            return dt;
        }
        public static string CreatedWord_fromResult(int brokerID)
        {
            string output = "";

            Document doc = new Document();
            //todo: sumeet - walways generate a statement for now.&& x.FLAG == 0 commneted below
            var statement_Header = db.STATEMENT_HEADER.Where(x => x.BROKER_ID == brokerID/* && x.FLAG == 0*/).FirstOrDefault();
            if (statement_Header != null)
            {
                string paylocity_ID = "";
                string broker_Status = "";
                int statementID = statement_Header.HEADER_ID; 

                DataTable datat = datatable(brokerID.ToString());
                List<STATEMENT_DETAILS> list = new List<STATEMENT_DETAILS>();
                list = (from DataRow dr in datat.Rows
                        select new STATEMENT_DETAILS()
                        {
                            QB_CLIENT_NAME = dr["CLIENT_NAME"].ToString(),
                            QB_FEE = dr["QB_FEE"].ToString(),
                            BROKER_NAME = dr["QB_BROKER_NAME"].ToString(),
                            QUANTITY = int.Parse(dr["Qty"].ToString()),
                            COMMISSION_RATE = Convert.ToDecimal(dr["COMMISSION_RATE"].ToString()),
                            SALES_PRICE = Convert.ToDecimal(dr["Sales Price"].ToString()),
                            TOTAL_PRICE = Convert.ToDecimal(dr["COMMISSION AMOUNT"].ToString()),
                            BROKER_STATUS = dr["BROKER_STATUS"].ToString(),
                            DETAIL_ID = int.Parse(dr["ID"].ToString()),
                            START_DATE = dr["START_DATE"].ToString(),
                            BROKER_ID = brokerID,
                            CLIENT_NAME = dr["CLIENT_NAME"].ToString(),
                            FEE_MEMO = dr["QB_FEE"].ToString(),
                            HEADER_ID = statementID,
                            INVOICE_DATE = Convert.ToDateTime(dr["INVOICE_DATE"].ToString()),
                            INVOICE_NUM = dr["Num"].ToString(),
                            OPEN_BALANCE = Convert.ToDecimal(dr["Open Balance"].ToString()) 

                        }).ToList();
                var list_paid = list.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE == 0).OrderBy(x => x.CLIENT_NAME).ToList();
                var list_pending = list.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE != 0).OrderBy(x => x.CLIENT_NAME).ToList();
                int broker_Id = int.Parse(statement_Header.BROKER_ID.ToString());

                var broker_Master = db.BROKER_MASTER.Where(x => x.ID == broker_Id).FirstOrDefault();
                if (broker_Master != null)
                {
                    paylocity_ID = broker_Master.PAYLOCITY_ID;
                    broker_Status = broker_Master.BROKER_STATUS;
                }

                DateTime From = Convert.ToDateTime((statement_Header.MONTH + "/01/" + statement_Header.YEAR).ToString());
                DateTime To = Convert.ToDateTime((From.Month + "/" + DateTime.DaysInMonth(statement_Header.YEAR, From.Month) + "/" + statement_Header.YEAR).ToString());
                string flowpath = System.Web.HttpContext.Current.Server.MapPath("~/Content/BrokerCommissionStatement.doc");
                doc = new Document(flowpath);
                SetBookMark(doc, "BorkerName", statement_Header.BROKER_NAME);

                //SetBookMark(doc, "From", );
                SetBookMark(doc, "Month", char.ToUpper(statement_Header.MONTH[0]) + statement_Header.MONTH.Substring(1).ToLower());
                SetBookMark(doc, "From", From.ToShortDateString());

                //SetBookMark(doc, "To", statement_Header.MONTH.Substring(0, 3) + "/01/" + statement_Header.YEAR);
                SetBookMark(doc, "Year", statement_Header.YEAR.ToString());
                SetBookMark(doc, "To", To.ToShortDateString());

                int i = 1;
                int CurrentRow = 9;//starting line
                int tableindex = 0;//table col index
                decimal total_1 = 0.00m;
                foreach (var a in list_paid)
                {
                    if (list_paid.Count() != i)
                    {
                        InsertRow(tableindex, CurrentRow, 0, doc);
                    }
                    //Insert to each row
                    //WriteCell(tableindex, CurrentRow, 0, i.ToString(), doc);
                    //WriteCell(tableindex, CurrentRow, 1, statement_Header.MONTH.ToString().Substring(0, 3) + "/"+ statement_Header.YEAR.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 1, Convert.ToDateTime(a.INVOICE_DATE).ToString("MM/dd/yyyy"), doc);

                    WriteCell(tableindex, CurrentRow, 2, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble(a.SALES_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble((a.SALES_PRICE * a.QUANTITY)).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Convert.ToDouble(a.COMMISSION_RATE).ToString("C3", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Convert.ToDouble(a.TOTAL_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    total_1 += a.TOTAL_PRICE == null ? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());

                    i++;
                    CurrentRow++;
                }
                SetBookMark(doc, "Paid_Total", Convert.ToDouble(total_1).ToString("C3", CultureInfo.CurrentCulture));
                CurrentRow = CurrentRow + 6;

                decimal total_2 = 0.00m;
                foreach (var a in list_pending)
                {
                    if (list_pending.Count() != i)
                    {
                        InsertRow(tableindex, CurrentRow, 0, doc);
                    }
                    //Insert to each row
                    //WriteCell(tableindex, CurrentRow, 0, i.ToString(), doc);
                    //WriteCell(tableindex, CurrentRow, 1, statement_Header.MONTH.ToString().Substring(0, 3) + "/" + statement_Header.YEAR.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 1, Convert.ToDateTime(a.INVOICE_DATE).ToString("MM/dd/yyyy"), doc);

                    WriteCell(tableindex, CurrentRow, 2, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble(a.SALES_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Convert.ToDouble((a.SALES_PRICE * a.QUANTITY)).ToString("C3", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Convert.ToDouble(a.COMMISSION_RATE).ToString("C3", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Convert.ToDouble(a.TOTAL_PRICE).ToString("C3", CultureInfo.CurrentCulture)), doc);

                    total_2 += a.TOTAL_PRICE == null ? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());

                    i++;
                    CurrentRow++;
                }

                SetBookMark(doc, "pending_Total", Convert.ToDouble(total_2).ToString("C3", CultureInfo.CurrentCulture));
                string urlsp = "http://" + System.Web.HttpContext.Current.Request.Url.Authority;
                string imgpath = "<img width='250' height='100' src='" + urlsp + "/Content/Images/Clarity_Secondary.png.png' />";
                DocumentBuilder dbuiderfuj = new DocumentBuilder(doc);
                dbuiderfuj.MoveToBookmark("Logo");
                dbuiderfuj.InsertHtml(imgpath);

                MemoryStream ms = new MemoryStream();
                doc.Save(ms, SaveFormat.Doc);

                //todo: modified as we DONT want to replace prod statements when working in TEST mode!
                //string savedUrl = PDFOutPut + paylocity_ID + "_" + statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";

                string pdfPath = PDFOutPut + paylocity_ID + "_" + statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";
                string pdfPath_Test = PDFOutPut_Test + paylocity_ID + "_" + statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";
                string savedUrl = "";

                if (debugMode == "True")
                {
                    savedUrl = pdfPath_Test;
                }
                else
                {
                    savedUrl = pdfPath;
                }
                                
                   
                doc.Save(savedUrl);
                ms.Close();


                output = savedUrl;
            }

            return output;
        }
        #endregion
        /// <summary>
        /// 
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="MarkName"></param>
        /// <param name="value"></param>
        private static void SetBookMark(Document doc, string MarkName, string value)
        {
            if (doc.Range.Bookmarks[MarkName] != null)
            {
                //thisValue(value);
                Bookmark mark = doc.Range.Bookmarks[MarkName];
                if (value == null)
                {
                    mark.Text = "";
                }
                else
                {
                    mark.Text = value;
                }

            }
        }
        private string thisValue(string value)
        {
            if (value == null)
            {
                return "N/A";
            }
            return value;
        }
     
    }
}