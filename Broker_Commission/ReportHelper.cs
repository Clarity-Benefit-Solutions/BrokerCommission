using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

using Aspose.Words;
 
using Aspose.Words.Tables;

namespace Broker_Commission
{
    public class ReportHelper
    {
        private static Broker_CommissionEntities db = new Broker_CommissionEntities();

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
        public static void CreatedWord(int statementID)
        {
         
            Document doc = new Document();

            var statement_Header = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == statementID).FirstOrDefault();
            if(statement_Header != null)
            {
                string paylocity_ID = "";
                string broker_Status = "";
                
                var list = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE == 0 ).OrderBy(x => x.CLIENT_NAME).ToList();
                var list_pending = db.STATEMENT_DETAILS.Where(x => x.HEADER_ID == statementID && x.OPEN_BALANCE != 0).OrderBy(x => x.CLIENT_NAME).ToList();
                int broker_Id = int.Parse(statement_Header.BROKER_ID.ToString());

                var broker_Master = db.BROKER_MASTER.Where(x => x.ID == broker_Id).FirstOrDefault();
                if (broker_Master != null)
                {
                    paylocity_ID = broker_Master.PAYLOCITY_ID;
                    broker_Status = broker_Master.BROKER_STATUS; 
                }


                string flowpath = System.Web.HttpContext.Current.Server.MapPath("~/Content/BrokerCommissionStatement.doc");
                doc = new Document(flowpath);
                SetBookMark(doc, "Broker_Name", statement_Header.BROKER_NAME);

                SetBookMark(doc, "From", statement_Header.MONTH);
                SetBookMark(doc, "Month", statement_Header.MONTH);
                SetBookMark(doc, "Month_1", statement_Header.MONTH);

                SetBookMark(doc, "To", statement_Header.YEAR.ToString());
                SetBookMark(doc, "Year", statement_Header.YEAR.ToString());
                SetBookMark(doc, "Year_1", statement_Header.YEAR.ToString());

                int i = 1;
                int CurrentRow = 3;//starting line
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
                    WriteCell(tableindex, CurrentRow, 0, statement_Header.MONTH.ToString() + "/"+ statement_Header.YEAR.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 1, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 2, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 5, a.SALES_PRICE == null ? "0.00":(" $"+ a.SALES_PRICE.ToString()), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "0.00" : (" $" + (a.SALES_PRICE*a.QUANTITY).ToString()), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.COMMISSION_RATE == null ? "0.00" : a.COMMISSION_RATE.ToString() + "%", doc);
                    WriteCell(tableindex, CurrentRow, 8, a.TOTAL_PRICE == null ? "0.00" : (" $" + a.TOTAL_PRICE.ToString()), doc);

                    total_1 += a.TOTAL_PRICE == null? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());
                    #endregion
                    i++;
                    CurrentRow++;
                    
                }
                SetBookMark(doc, "Paid_Total", total_1.ToString());
                CurrentRow = CurrentRow + 3;

                decimal total_2 = 0.00m;
                foreach (var a in list_pending)
                {
                    if (list_pending.Count() != i)
                    {
                        InsertRow(tableindex, CurrentRow, 0, doc);
                    }
                    //Insert to each row
                    //WriteCell(tableindex, CurrentRow, 0, i.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 0, statement_Header.MONTH.ToString() + "/" + statement_Header.YEAR.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 1, a.CLIENT_NAME, doc);
                    WriteCell(tableindex, CurrentRow, 2, a.START_DATE == null ? "" : a.START_DATE, doc);
                    WriteCell(tableindex, CurrentRow, 3, a.FEE_MEMO, doc);
                    WriteCell(tableindex, CurrentRow, 4, a.QUANTITY == null ? "0" : a.QUANTITY.ToString(), doc);
                    WriteCell(tableindex, CurrentRow, 5, a.SALES_PRICE == null ? "0.00" : (" $" + a.SALES_PRICE.ToString()), doc);
                    WriteCell(tableindex, CurrentRow, 6, a.SALES_PRICE == null ? "0.00" : (" $" + (a.SALES_PRICE * a.QUANTITY).ToString()), doc);
                    WriteCell(tableindex, CurrentRow, 7, a.COMMISSION_RATE == null ? "0.00" : a.COMMISSION_RATE.ToString()+ "%", doc);
                    WriteCell(tableindex, CurrentRow, 8, a.TOTAL_PRICE == null ? "0.00" : (" $" + a.TOTAL_PRICE.ToString()), doc);

                    total_2 += a.TOTAL_PRICE == null ? 0 : Convert.ToDecimal(a.TOTAL_PRICE.ToString());
 
                    i++;
                    CurrentRow++;
                }
                SetBookMark(doc, "Pending_Total", total_2.ToString());

                string urlsp = "http://" + System.Web.HttpContext.Current.Request.Url.Authority;
                string imgpath = "<img width='250' height='100' src='" + urlsp + "/Content/Images/Clarity_Secondary.png.png' />";
                DocumentBuilder dbuiderfuj = new DocumentBuilder(doc);
                dbuiderfuj.MoveToBookmark("picture");
                dbuiderfuj.InsertHtml(imgpath);

                MemoryStream ms = new MemoryStream();
                doc.Save(ms, SaveFormat.Doc);
                //sq.docBase64 = Convert.ToBase64String(ms.ToArray());
                doc.Save("D:\\testFolder\\"+ statement_Header.MONTH + "_" + statement_Header.YEAR+"\\" + statement_Header.BROKER_NAME+"_"+ statement_Header.MONTH+"_"+ statement_Header.YEAR +".pdf");
                ms.Close();
            }
          
 
            }




        /// <summary>
        /// 填充字段数据
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
                return "N / A";
            }
            return value;
        }
     
    }
}