using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BrokerCommissionWebApp
{
    public partial class broker_group : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataLoad();
            }
          
        }


        protected void DataLoad()
        {
            //DataView dv = GRIDTABLE_All().DefaultView;
            //dv.Sort = cmb_orderBy.SelectedItem.Text;
            DataTable dt = GRIDTABLE_All();
            ASPxGridView1.DataSource = dt;
            ASPxGridView1.DataBind();
        }

        protected DataTable GRIDTABLE_All()
        {
            DataTable table = new DataTable();


            string first_dayMonth = DateTime.Now.Month.ToString() + "-01-" + DateTime.Now.Year.ToString();
           
            //string query = "SELECT * FROM " + tablename + " WHERE BILLING_START_DATE = '" + first_dayMonth + "' AND PREMIUM_DATE = '" + first_dayMonth + "' ORDER BY MEMBER_ID";
            string query = "SELECT * FROM [dbo].[BROKER_GROUP_DETAIL]";
            string constr = ConfigurationManager.ConnectionStrings["Broker_CommissionEntities"].ConnectionString;
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
    }
}