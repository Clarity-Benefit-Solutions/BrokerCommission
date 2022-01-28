using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace Broker_Commission
{
    public partial class BROKER_VIEW : System.Web.UI.Page
    {
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
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.BROKER_MASTER.Where(x => x.ID == id).FirstOrDefault();
                if (model != null)
                {
                    txt_name.Text = model.BROKER_NAME;
                    txt_qb_name.Text = model.BROKER_NAME_ID;
                    cb_premium.Text = model.BROKER_STATUS;
                    txt_body.Text = model.NOTES;
                    txt_email.Text = model.EMAIL;
                    txt_sec_email.Text = model.SECONDARY_EMAIL;
                    //txt_rate.Text = model.PREMIUM_TH == null ? "0" : model.PREMIUM_TH.ToString();

                    txt_paylicity.Text = model.PAYLOCITY_ID;


                    cmb_status.Text = string.IsNullOrWhiteSpace(model.STATUS)  ? "ACTIVE": model.STATUS;

                    loadClient_ByBrokerID(id);
                    loadhistory_ByBrokerID(id);
                }
            }

        }


        protected void loadClient_ByBrokerID(int brokerID)
        {
            var list = db.CLIENTs.Where(x => x.BROKER_ID == brokerID).OrderBy(x => x.CLIENT_NAME).ToList();

            grid_client.DataSource = list;
            grid_client.DataBind();

        }


        protected void loadhistory_ByBrokerID(int brokerID)
        {

            //var list = db.BROKER_COMMISSION.Where(x => x.BROKER_ID == brokerID).OrderByDescending(x => x.PERIOD)
            //    .ToList();

            var list = db.STATEMENT_HEADER.Where(x => x.BROKER_ID == brokerID && x.FLAG == 3).OrderByDescending(x => x.YEAR).ThenByDescending(x => x.MONTH).ToList();
            grid_history.DataSource = list;
            grid_history.DataBind();


        }


        


        protected void grid_history_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "statement")
            {
               int id =  int.Parse(e.CommandArgs.CommandArgument.ToString());
               var model = db.STATEMENT_HEADER.Where(x => x.HEADER_ID == id).FirstOrDefault();
               if (model != null)
               {
                   string url = "ViewFile.aspx?BID=" + model.BROKER_ID + "&YEAR=" + model.YEAR+ "&MONTH="+model.MONTH +"&&statement=1";
                   Page.ClientScript.RegisterStartupScript(this.GetType(), "popup_window", "popupwindow('" + url + "','" + "View Download Files" + "','" + "1200" + "','" + "800" + "');", true);
                }

            }
        }

        protected void btn_back_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}