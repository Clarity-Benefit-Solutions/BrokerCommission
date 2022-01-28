using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace Broker_Commission
{
    public partial class RawDataUpload : System.Web.UI.Page
    {
        string file_import =
            System.Web.Configuration.WebConfigurationManager.AppSettings["import"].ToString();

        Broker_CommissionEntities db = new Broker_CommissionEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataLoad();
            }
        }


        protected void DataLoad()
        {
            cmb_Year.Items.Clear();
            cmb_month.Items.Clear();


            
            foreach (var items in GetCustomAbbreviatedMonthNames())
            {
                cmb_month.Items.Add(new ListEditItem(items.ToString())); 
            }


            for (int i = DateTime.Now.Year-2; i <= DateTime.Now.Year + 2; i++)
            {
                cmb_Year.Items.Add(new ListEditItem(i.ToString()));
            }
        }

        #region Read CSV

        //public DataTable ReadCsvFile(string FileSaveWithPath)
        //{

        //    DataTable dtCsv = new DataTable();
        //    string Fulltext;


        //    using (StreamReader sr = new StreamReader(FileSaveWithPath))
        //    {
        //        while (!sr.EndOfStream)
        //        {
        //            Fulltext = sr.ReadToEnd().ToString(); //read full file text  
        //            string[] rows = Fulltext.Split('\n'); //split full file text into rows  
        //            for (int i = 0; i < rows.Count(); i++)
        //            {

        //                DataRow dr = dtCsv.NewRow();
        //                string[] rowValues = rows[i].Split(',');


        //                if (i == 0)
        //                {

        //                    for (int j = 0; j < rowValues.Count(); j++)
        //                    {
        //                        dtCsv.Columns.Add(rowValues[j].ToString().Trim()); //add headers  
        //                        //Response.Write(rowValues[j]);
        //                    }
        //                }

        //                else
        //                {


        //                    //if (!string.IsNullOrEmpty(rowValues[0].ToString()) && !string.IsNullOrEmpty(rowValues[1].ToString()))
        //                    //{
        //                    if(rowValues.Count() == 9)
        //                    {
        //                        for (int k = 0; k < rowValues.Count(); k++)
        //                        {
        //                            //if (!string.IsNullOrEmpty(rowValues[0]))
        //                            //{
        //                                dr[k] = rowValues[k].ToString().Replace("\"", "").Replace("$", "").Trim();

        //                            //}

        //                        }


        //                        dtCsv.Rows.Add(dr);
        //                    }
        //                    else if(rowValues.Count() == 10)
        //                    {

        //                    }

        //                   //add other rows 
        //                                        //split each row with comma to get individual values  
        //                                        //}
        //                }



        //            }

        //        }

        //    }

        //    return dtCsv;
        //}


        #endregion

        protected bool saveFile()
        {
            bool uploaded = false;

            if (upload_Excel.HasFile )
            {
                string filePath = file_import + "\\file_import.csv";
                upload_Excel.SaveAs(filePath);
               
                lbl_error.Text = "File Uploaded: " + upload_Excel.FileName  ;
                lbl_error.CssClass = "text-success";

                uploaded = true;
                 
            }
            else
            {
                lbl_error.Text = "Please Upload QUICKBOOK FILES in csv files.";
                lbl_error.CssClass = "text-danger";
            }

            return uploaded;
        }
        
        protected void btn_process_paymentfile_OnClick(object sender, EventArgs e)
        {
            if (saveFile())
            {
                try
                {
                    execute_ssis();

                    #region add satement to sql
                    string month = cmb_month.Text.ToUpper(); //util.GetCustomAbbreviatedMonthNames(int.Parse());  
                    int year = int.Parse(cmb_Year.Text);
                    util.statement_process(month, year);
                    #endregion


                    Response.Redirect("Upload_Result.aspx?YEAR=" + cmb_Year.Text + "&&MONTH=" + (cmb_month.SelectedIndex).ToString());
                }
                catch (Exception exception)
                {
                    var list = db.Error_Msg.ToList();
                    string text = "";
                    foreach(var item in list)
                    {
                        text += item.ErrorColumn + " " + item.ErrorCode + "<br/>";
                    }

                    lbl_error.Text = text;

                    Response.Write(exception);

                    
                    throw;
                }
            }
           
            
        }

       
      
      
        protected string[] GetCustomAbbreviatedMonthNames()
        {
            string monthtext = "";
            string[] template = CultureInfo.InvariantCulture.DateTimeFormat.MonthNames;
            // replace the september but also you might want to do it with the other months as well
            
            return template;
        }
       



        //FRS_SSIS_PaymentFile
        protected void execute_ssis()
        {
            string sum = "";
            string query = "";

            query = "[dbo].[SP_FILE_IMPORT_SSIS]";


            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ConnectionString;

            // Define the ADO.NET Objects


            SqlConnection con = new SqlConnection(constr);

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.CommandType = CommandType.Text;
            con.Open();

            int rowsAffected = cmd.ExecuteNonQuery();

            con.Close();

        }
    }
}