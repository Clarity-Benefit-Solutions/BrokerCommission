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
using CoreUtils.Classes;

using BrokerCommissionWebApp.DataModel;
using System.Reflection;

namespace BrokerCommissionWebApp
{

    public class PdfGenerationResults
    {
        public string outputPath1 = "";
        public string outputPath2 = "";
        public List<STATEMENT_DETAILS> statementLinesAddedToPdf = new List<STATEMENT_DETAILS>();
        public Boolean success = false;
        public Exception error = null;
    }
    public class ReportHelper
    {
        private static Broker_CommissionEntities db = new Broker_CommissionEntities();
      
        private static void WriteCell(int tableindex, int rowindex, int colindex, string str, Document document)
        {
            str = str ?? "";
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
        public static int GetStatementIdForBrokerId(int brokerID)
        {
            var statement_Header = db.STATEMENT_HEADER.Where(x => x.BROKER_ID == brokerID).FirstOrDefault();
            if (statement_Header != null)
            {
                return statement_Header.HEADER_ID;
            }
            return 0;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sq"></param>
        /// 
        public static PdfGenerationResults GenerateStatementPdf(int statementID, Boolean generateToTempPath)
        {
            //
            PdfGenerationResults pdfGenerationResults = new PdfGenerationResults();
            //
            var statement_Header = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == statementID).ToList().FirstOrDefault();
            if (statementID <= 0 || statement_Header == null)
            {
                var message = $"ERROR: {MethodBase.GetCurrentMethod()?.Name} : Cannot Create Statement for HeaderId : {statementID} as no such Header was found";
                throw new Exception(message);
            }

            string paylocity_ID = "";
            string broker_Status = "";
            //
            int broker_Id = int.Parse(statement_Header.BROKER_ID.ToString());
            var broker_Master = db.BROKER_MASTER.Where(x => x.ID == broker_Id).FirstOrDefault();
            if (broker_Master == null)
            {
                var message = $"ERROR: {MethodBase.GetCurrentMethod()?.Name} : Cannot Create Statement for HeaderId : {statementID} as no matching broker found";
                throw new Exception(message);
            }
            paylocity_ID = broker_Master.PAYLOCITY_ID;
            broker_Status = broker_Master.BROKER_STATUS;

            //  calcpaths
            string tempPath = generateToTempPath ? "TEMP\\" : "";
            string filename = statement_Header.BROKER_NAME + "_" + statement_Header.MONTH + "_" + statement_Header.YEAR + ".pdf";

            // calculate output path
            string pdfPath = util.PDFOutPut + tempPath;
            string pdfPath_Test = util.PDFOutPut_Test + tempPath;

            string savedFilePath1 = "";
            string savedFilePath2 = "";
            if (util.debugMode == "True")
            {
                savedFilePath1 = pdfPath_Test;
            }
            else
            {
                savedFilePath1 = pdfPath;
            }

            // also archive with broker name first for easier sorting by finance
            savedFilePath2 = savedFilePath1 + "BY_BROKER_NAME\\";

            // we will save to a rtemp path till caller verifies all went well
            savedFilePath2 += "ToBeProcessed\\";
            savedFilePath1 += "ToBeProcessed\\";

            // ensure paths exist
            Directory.CreateDirectory(savedFilePath1);
            Directory.CreateDirectory(savedFilePath2);

            // add filename with id
            savedFilePath1 += paylocity_ID + "_" + filename;

            // add filename without id
            savedFilePath2 += filename;

            pdfGenerationResults.outputPath1 = savedFilePath1;
            pdfGenerationResults.outputPath2 = savedFilePath2;
            try
            {
                //
                Document doc = new Document();

                //note: use line status to determine paid, pending and already paid
                /*   var list_paid = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE == 0).OrderBy(x => x.CLIENT_NAME).ToList();
                   var list_pending = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE != 0).OrderBy(x => x.CLIENT_NAME).ToList();
                */
                //todo: added filter for Total price > 0 and pending > 0
                var list_paid = db.STATEMENT_DETAILS.Where(
                    x => x.HEADER_ID == statementID &&
                    x.line_payment_status == "paid" &&
                    x.TOTAL_PRICE > 0
                    ).OrderBy(x => x.CLIENT_NAME).ThenBy(x => x.QB_FEE)
                    .ToList();
                //
                var list_pending = db.STATEMENT_DETAILS.Where
                    (x => x.HEADER_ID == statementID && 
                    x.line_payment_status == "pending" && 
                    x.TOTAL_PRICE > 0
                    )
                    .OrderBy(x => x.CLIENT_NAME)
                    .ThenBy(x => x.QB_FEE)
                    .ToList();
                //


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
                    //todo: Sumeet: verify if this the correct field - it is coming from Client.Start_date. And why this logic of invoice date
                    WriteCell(tableindex, CurrentRow, 3, a.INVOICE_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Utils.ToDecimal(a.SALES_PRICE).ToString("C2", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Utils.ToDecimal((a.SALES_PRICE * a.QUANTITY)).ToString("C2", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Utils.ToDecimal(a.COMMISSION_RATE).ToString("C2", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Utils.ToDecimal(a.TOTAL_PRICE).ToString("C2", CultureInfo.CurrentCulture)), doc);
                    total_1 += a.TOTAL_PRICE == null ? 0 : Utils.ToDecimal(a.TOTAL_PRICE.ToString());

                    i++;
                    CurrentRow++;

                    // add processed lines to paid lines
                    pdfGenerationResults.statementLinesAddedToPdf.Add(a);

                }
                SetBookMark(doc, "Paid_Total", Utils.ToDecimal(total_1).ToString("C2", CultureInfo.CurrentCulture));
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
                    //todo: Sumeet: verify if this the correct field - it is coming from Client.Start_date. And why this logic of invoice date
                    WriteCell(tableindex, CurrentRow, 3, a.INVOICE_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.FEE_MEMO.Count() > 30 ? a.FEE_MEMO.Substring(0, 30) + "..." : a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 5, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "$0.00" : (Utils.ToDecimal(a.SALES_PRICE).ToString("C2", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.SALES_PRICE == null ? "$0.00" : (Utils.ToDecimal((a.SALES_PRICE * a.QUANTITY)).ToString("C2", CultureInfo.CurrentCulture)), doc);
                    WriteCell(tableindex, CurrentRow, 8, a.COMMISSION_RATE == null ? "0.00" : (Utils.ToDecimal(a.COMMISSION_RATE).ToString("C2", CultureInfo.CurrentCulture)), doc); // a.COMMISSION_RATE.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 9, a.TOTAL_PRICE == null ? "$0.00" : (Utils.ToDecimal(a.TOTAL_PRICE).ToString("C2", CultureInfo.CurrentCulture)), doc);

                    total_2 += a.TOTAL_PRICE == null ? 0 : Utils.ToDecimal(a.TOTAL_PRICE.ToString());

                    i++;
                    CurrentRow++;
                }

                SetBookMark(doc, "pending_Total", Utils.ToDecimal(total_2).ToString("C2", CultureInfo.CurrentCulture));
                string urlsp = "http://" + System.Web.HttpContext.Current.Request.Url.Authority;
                string imgpath = "<img width='250' height='100' src='" + urlsp + "/Content/Images/Clarity_Secondary.png.png' />";
                DocumentBuilder dbuiderfuj = new DocumentBuilder(doc);
                dbuiderfuj.MoveToBookmark("Logo");
                dbuiderfuj.InsertHtml(imgpath);

                // todo: why do we save to Memory stream - is it needed?
                MemoryStream ms = new MemoryStream();
                doc.Save(ms, SaveFormat.Doc);
                ms.Close();

                //
                doc.Save(savedFilePath1);

                // also archive with broker name first for easier sorting by finance
                FileUtils.CopyFile(savedFilePath1, savedFilePath2, null, null);
                //
                pdfGenerationResults.success = true;

            }
            catch (Exception ex)
            {
                pdfGenerationResults.success = false;
                pdfGenerationResults.error = ex;
            }
            //
            return pdfGenerationResults;
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
        public static DataTable GetCommissionResultForBroker(string bid)
        {
            DataTable dt = new DataTable();
            //todo: memo added to order by
            //string queryString = "SELECT * FROM [dbo].[COMMISSION_RESULT] WHERE BROKER_ID = " + bid + " ORDER BY QB_CLIENT_NAME, MEMO";
            string queryString = "SELECT * FROM [dbo].[vw_statement_design_view] WHERE BROKER_ID = " + bid + " ORDER BY QB_CLIENT_NAME, FEE_MEMO";
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