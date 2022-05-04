using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Mail;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Text;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Globalization;

namespace Broker_Commission
{
    public class util
    {
        protected static Broker_CommissionEntities db = new Broker_CommissionEntities();
        public static string  subject_line = "Commission Statement";
        public static string from_email =
           System.Web.Configuration.WebConfigurationManager.AppSettings["from_email"].ToString();

        public static string from_email_pass =
            System.Web.Configuration.WebConfigurationManager.AppSettings["from_email_pass"].ToString();

        public static string cc_email =
           System.Web.Configuration.WebConfigurationManager.AppSettings["cc_email"].ToString();
        public static StringBuilder stringPDF(DataTable dtp, string month, int year)
        {
            StringBuilder sb = new StringBuilder();


            try
            {
                string Err = string.Empty;
                DataTable dt = dtp;


                //pdfDocument Content in HTml Format  
                if (dt.Rows.Count > 0)
                {
                    Double total = 0.00;
                    sb.Append("<html><head><title></title>" +

                              "</head><body>");
                    string strActualRecords = string.Empty;
                    strActualRecords = "<table border=\"1\" style=\"width:100%;font-size: 10pt; font-family:Tahoma; border: 1px solid black;border - collapse: collapse;\">";
                    strActualRecords += "<tr><td colspan=\"9\" style=\"text-align: center;white-space: nowrap; border: 1px solid black;border - collapse: collapse;font-weight:bold;\">" +
                                        dt.Rows[0]["BROKER_NAME"].ToString().Replace("&","").Replace(":", "").Replace(",", "").Replace("-", "") + " " 
                                        + (string.IsNullOrEmpty(dt.Rows[0]["PAYLOCITY_ID"].ToString()) ? "" : dt.Rows[0]["PAYLOCITY_ID"]) + " : " + month + " " + year +
                                        " Commission Statement</td></tr>";

                    strActualRecords += "<tr><td colspan=\"9\" style=\"background-color:DodgerBlue;text-align: center;font-weight:bold; white-space: nowrap;border: 1px solid black;border - collapse: collapse;\">" +
                                        dt.Rows[0]["BROKER_STATUS"] + " </td></tr>";
                    strActualRecords += "<tr><td width=\"10% \" style=\"text-align: center;font-size: 9pt;font-weight:bold;border: 1px solid black;border - collapse: collapse; white-space: nowrap;border=\"1\"\">" + "DATE" + "</td>" +
                                        "<td width=\"20% \" style=\"text-align: center;font-weight:bold;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">NAME</td>"

                                        + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt; border: 1px solid black;border - collapse: collapse;\">START DATE</td>"
                                        + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">ITEM</td>"
                                        + "<td width=\"15% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AGENT</td>"
                                        + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">QTY</td>"
                                        + "<td width=\"10% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">AMOUNT($)</td>"
                                        + "<td width=\"5% \" style=\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">RATE</td>"
                                        + "<td width=\"15% \" style =\"font-weight:bold;text-align: center;font-size: 9pt;border: 1px solid black;border - collapse: collapse;\">COMMISSION AMOUNT($)</td></tr>";
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        strActualRecords += "<tr>";
                        strActualRecords += "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + month + " " + year + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["QB_CLIENT_NAME"].ToString() + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["START_DATE"].ToString() + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["QB_FEE"].ToString() + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["BROKER_NAME"].ToString()
                                            + "</td>" + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["Qty"].ToString() + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + DoFormat(Convert.ToDouble(dt.Rows[i]["Sales Price"].ToString())) + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + dt.Rows[i]["COMMISSION_RATE"].ToString() + "</td>"
                                            + "<td style=\"text-align: left;border: 1px solid black;border-collapse: collapse;font-size: 8pt; \">"
                                            + DoFormat(Convert.ToDouble(dt.Rows[i]["COMMISSION AMOUNT"].ToString())) + "</td>";
                        strActualRecords += "</tr>";

                        total += Convert.ToDouble(dt.Rows[i]["COMMISSION AMOUNT"].ToString());
                    }

                    strActualRecords += "<tr><td colspan=\"9\" style=\"height:50px;text-align: right;font-weight:bold; white-space: nowrap;\">" 
                        + " Total Commission Payable for " + month + " " + year + "    $" +
                                        DoFormat(total) + " </td></tr>";
                    strActualRecords += "</table>";
                    sb.Append(strActualRecords);
                    sb.Append("</body></html>");
                }



            }
            catch (Exception ex)
            {
                throw ex;
            }

            return sb;
        } 
        public static string DoFormat(double myNumber)
        {
            var s = string.Format("{0:0.00}", myNumber);

            //if (s.EndsWith("00"))
            //{
            //    return ((int)myNumber).ToString();
            //}
            //else
            //{
            //    return s;
            //}
            return s;
        } 
        public static DataTable STATEMENT_VIEW(string month, int year, int broker_id)
        {
            DataTable table = new DataTable();


            //WHERE [MONTH] = 'November' AND [YEAR] = '2021' AND BROKER_ID= 3
            //string query = "SELECT * FROM [dbo].[VW_STATEMENT] WHERE QB_CLIENT_NAME IS NOT NULL AND [MONTH]='" + month + "' "+ " AND [YEAR]="+year + " AND [BROKER_ID]="+ broker_id;

            string query = "SELECT * FROM [dbo].[COMMISSION_RESULT] WHERE BROKER_ID ="+broker_id;
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

        public static DataTable COMMISSION_SUMMARY_GRIDTABLE()
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

        public static string GetCustomAbbreviatedMonthNames(int month)
        {
            string monthtext = "";
            string[] template = CultureInfo.InvariantCulture.DateTimeFormat.MonthNames;
            // replace the september but also you might want to do it with the other months as well
            monthtext = template[month];
            return monthtext;
        }

        public static void statement_process(string Month, int year)
        {
           
            string query = "";

            query = "EXEC [dbo].[SP_IMPORT_FILE_SENT_SSIS] @Month='" + Month + "', @Year='" + year+"'";


            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ConnectionString;

            // Define the ADO.NET Objects


            SqlConnection con = new SqlConnection(constr);

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.CommandType = CommandType.Text;
            con.Open();

            int rowsAffected = cmd.ExecuteNonQuery();

            con.Close();

        }

        public static DataTable RESULT_VIEW()
        {
            DataTable table = new DataTable();


            //WHERE [MONTH] = 'November' AND [YEAR] = '2021' AND BROKER_ID= 3
            string query = "SELECT * FROM [dbo].[COMMISSION_RESULT]";
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

        public static void Statement_Detail_Updates()
        {

            string query = "";

            query = "EXEC [dbo].[SP_STATEMENT_DETAIL_UPDATE]";


            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"].ConnectionString;

            // Define the ADO.NET Objects


            SqlConnection con = new SqlConnection(constr);

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.CommandType = CommandType.Text;
            con.Open();

            int rowsAffected = cmd.ExecuteNonQuery();

            con.Close();

        }

        public static int getMaxResult()
        {
            int id = 0;
            DataTable datat = RESULT_VIEW();
            List<broker_Import> list = new List<broker_Import>();
            list = (from DataRow dr in datat.Rows
                    select new broker_Import()
                    {
                        ID = int.Parse(dr["ID"].ToString())
                    }).ToList();

            var id_object = list.OrderByDescending(x => x.ID).FirstOrDefault();
            if (id_object != null)
            {
                id = id_object.ID;
            }
            return id;
        } 

        public static void toSQL(DataTable dt, string monthS, int yearS)
        {

            foreach (DataRow dr in dt.Rows)
            {

                if (!string.IsNullOrEmpty(dr[2].ToString()))
                {
                    int broker_id = int.Parse(dr[0].ToString());
                    string month = monthS;
                    int year = yearS;
                    string broker_name = dr[1].ToString();
                    double amount = Convert.ToDouble(dr[2].ToString());

                    var model = new STATEMENT_HEADER()
                    {
                        BROKER_NAME = broker_name,
                        Change_Date = DateTime.Now,
                        FLAG = 0,
                        BROKER_ID = broker_id,
                        MONTH = month,
                        YEAR = year,
                        STATEMENT_TOTAL = Convert.ToDecimal(amount)

                    };

                    db.STATEMENT_HEADER.Add(model);
                    db.SaveChanges(); 



                    //Response.Write(broker_id + " " + month + " " + year + " " + broker_name + " " + amount);
                    //Response.Write(dr[0] + " " + dr[1] + " " + dr[2]  );

                }
            }
        }

        public static void SendPDFEmail(string sender, string receiver, string broker, string month, int year, int broker_id)
        {
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                {
                     
                    DataTable dtp = STATEMENT_VIEW(month,  year, broker_id);
                    StringBuilder sb = stringPDF(dtp, month,year);

                    StringReader sr = new StringReader(sb.ToString());

                    Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
                    HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                    using (MemoryStream memoryStream = new MemoryStream())
                    {
                        PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
                        pdfDoc.Open();
                       
                        htmlparser.Parse(sr);
                        pdfDoc.Close();
                        byte[] bytes = memoryStream.ToArray();
                        memoryStream.Close();

                        MailMessage mm = new MailMessage(sender, receiver);

                        MailAddress copy = new MailAddress(cc_email);
                        mm.CC.Add(copy);


                        mm.Subject = subject_line;
                        
                        mm.Body = "Good Morning/Afternoon," + "<br/>" + "<br/>" + "Thank you for your continued support and partnership. Attached you will find your most recent Commission Statement."
                            + "Thank you and have a great day," + "<br/>" + "<br/>" +
                            "Clarity Finance Dept." + "<br/>" + "(finance@claritybenefitsolutions.com)";

                        mm.Attachments.Add(new Attachment(new MemoryStream(bytes), month + "_" + year + "_" + broker + ".pdf"));
                        mm.IsBodyHtml = true;
                        SmtpClient smtp = new SmtpClient();
                        // todo: put in app settings
                        /*
                         SMTP
                        Host:
                        smtp.mailtrap.io
                        Port:
                        25 or 465 or 587 or 2525
                        Username:
                        a6abec2c4cbb52
                        Password:
                        39218b05e65de1
                        Auth:
                        PLAIN, LOGIN and CRAM-MD5
                        TLS:
                        Optional (STARTTLS on all ports)
                         */
                        smtp.Host = "smtp.mailtrap.io";
                        //smtp.EnableSsl = true;
                        NetworkCredential NetworkCred = new NetworkCredential();
                        NetworkCred.UserName = a6abec2c4cbb52;
                        NetworkCred.Password = 39218b05e65de1;
                        //smtp.UseDefaultCredentials = true;
                        //smtp.Credentials = NetworkCred;
                        smtp.Port = 465;
                        smtp.Send(mm);
                        
                        //Original Mail setting comment out 05/04/2022
                        //smtp.Host = "smtp.office365.com";
                        //smtp.EnableSsl = true;
                        //NetworkCredential NetworkCred = new NetworkCredential();
                        //NetworkCred.UserName = from_email;
                        //NetworkCred.Password = from_email_pass;
                        //smtp.UseDefaultCredentials = true;
                        //smtp.Credentials = NetworkCred;
                        //smtp.Port = 587;
                        //smtp.Send(mm);
                    }
                }
            }
        }

        public static string getCompleteCount(string month, int year)
        {
            string memberID = "";

            string query = " SELECT COUNT(*) AS C FROM [dbo].[STATEMENT_HEADER] WHERE [MONTH] = '"+month+"' AND [YEAR]="+year+" AND FLAG=3";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"]
                .ConnectionString;


            using (SqlConnection sqlConnection = new SqlConnection(constr))
            {
                sqlConnection.Open();
                using (SqlCommand cmd = sqlConnection.CreateCommand())
                {
                    cmd.CommandText = query;
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {


                            memberID = reader["C"].ToString();


                        }
                    }
                }
            }




            return memberID;
        }

        public static int getPercentage(decimal currentValue, decimal maxValue)
        {
            int a = 0;



            int percentValue = (int)Math.Round(100 * (currentValue) / (maxValue));
            //ASPxProgressBar1.Position = percentValue;

            if (percentValue > 100)
            {
                percentValue = 100;
            }
            a = percentValue;


            return a;
        }

        public static string getEmailAddress(int BrokerID)
        {
            string Address = "";

            var broker_model = db.BROKER_MASTER.Where(x => x.ID == BrokerID).FirstOrDefault();

            if (broker_model != null)
            {
                if(broker_model.EMAIL != null && broker_model.EMAIL.Contains("@"))
                {
                    Address = broker_model.EMAIL;
                }
                else if (broker_model.SECONDARY_EMAIL!= null && broker_model.SECONDARY_EMAIL.Contains("@"))
                {
                    Address = broker_model.SECONDARY_EMAIL;
                }
                else
                {
                    Address = "azhu@claritybenefitsolutions.com";
                }
            }

             
            return Address;
        }


        public static string getinCompleteCount(string month, int year)
        {
            string memberID = "";

            string query = " SELECT COUNT(*) AS C FROM [dbo].[STATEMENT_HEADER] WHERE [MONTH] = '" + month + "' AND [YEAR]=" + year + " AND FLAG!=3";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"]
                .ConnectionString;


            using (SqlConnection sqlConnection = new SqlConnection(constr))
            {
                sqlConnection.Open();
                using (SqlCommand cmd = sqlConnection.CreateCommand())
                {
                    cmd.CommandText = query;
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {


                            memberID = reader["C"].ToString();


                        }
                    }
                }
            }




            return memberID;
        }



        public static string getLASTSTATEMENTYEAR()
        {
            string memberID = "";

            string query = "SELECT TOP (1) [YEAR] FROM [dbo].[STATEMENT_HEADER] ORDER BY FLAG, [MONTH] ";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"]
                .ConnectionString;


            using (SqlConnection sqlConnection = new SqlConnection(constr))
            {
                sqlConnection.Open();
                using (SqlCommand cmd = sqlConnection.CreateCommand())
                {
                    cmd.CommandText = query;
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {


                            memberID = reader["YEAR"].ToString();


                        }
                    }
                }
            }




            return memberID;
        }


        public static string getLASTSTATEMENTMONTH()
        {
            string memberID = "";

            string query = "SELECT TOP (1) [MONTH] FROM [dbo].[STATEMENT_HEADER] ORDER BY FLAG, [MONTH] ";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionConnectionString"]
                .ConnectionString;


            using (SqlConnection sqlConnection = new SqlConnection(constr))
            {
                sqlConnection.Open();
                using (SqlCommand cmd = sqlConnection.CreateCommand())
                {
                    cmd.CommandText = query;
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {


                            memberID = reader["MONTH"].ToString();


                        }
                    }
                }
            }




            return memberID;
        }
        private static string debugMode =
         System.Web.Configuration.WebConfigurationManager.AppSettings["DebugMode"].ToString();

        protected static string secondemail(string brokerName)
        {
            string secondEmail = "";

            var model = db.BROKER_MASTER.Where(x => x.BROKER_NAME == brokerName).FirstOrDefault();

            if (model != null)
            {
                secondEmail = model.SECONDARY_EMAIL;
            }



            return secondEmail;
        }
        public static void email_send_with_attachment(string sender, string receiver, string filePath, string BrokerName, string Month, int year)
        {
            MailMessage mail = new MailMessage(sender, receiver);

            MailAddress copy = new MailAddress(cc_email);
           


            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.office365.com";
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential();
            NetworkCred.UserName = from_email;
            NetworkCred.Password = from_email_pass;
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = 587;
            System.Net.Mail.Attachment attachment;
            attachment = new System.Net.Mail.Attachment(filePath); 
            mail.Subject = Month+ " "+year.ToString()+" "+ "Commission Statement for "+ BrokerName;// subject_line;

            mail.Body = "Dear "+ BrokerName+ "," + "<br/>" + "<br/>" 
                + "Thank you for your continued support of Clarity Benefit Solutions." + "<br/>" 
                +"Attached you will find your Commission Statement for "+Month+"." + "<br/>"
                + "You can also review your Commission Statements through the Clarity Portal – simply login and select My Commissions from the Manage menu. " 
                //+ "<br/>"
                //+ "You can also review your Commission Statements through the Clarity Portal – simply login and select My Commissions from the Manage menu. " 
                + "<br/>" + "<br/>"
                + "Thank you again for being a valued Clarity Broker." 
                + "<br/>" + "<br/>" 
                + "Sincerely,"  
                +"<br/>" 
                + "Clarity Benefit Solutions";

            if (debugMode == "True")
            {
                mail.CC.Add(new MailAddress("finance-it@claritybenefitsolutions.com")); 
            }
            else
            {
                mail.CC.Add(copy);
                mail.CC.Add(new MailAddress("azhu@claritybenefitsolutions.com"));
                string copy2 = secondemail(BrokerName);
                if (copy2 != "")
                {
                    MailAddress copy_2 = new MailAddress(copy2);
                    mail.CC.Add(copy_2);
                }
            }
            mail.IsBodyHtml = true;
            mail.Attachments.Add(attachment);
            smtp.Send(mail);
        }


    }
}