using BrokerCommissionWebApp.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BrokerCommissionWebApp
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        Broker_CommissionEntities db = new Broker_CommissionEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ID"] != null)
                {
                    string id = Request.QueryString["ID"].ToString();
                    loadeditdata(id);
                }
            }
               


        }

        private void loadeditdata(string id)
        {
            var model = db.STATEMENT_DETAILS.Where(x => x.INVOICE_NUM == id).FirstOrDefault();
            txt_name.Text = model.CLIENT_NAME;
            txt_item.Text = model.FEE_MEMO;
            txt_brokername.Text = model.BROKER_NAME;
            txt_quantity.Text = model.QUANTITY.ToString();
            txt_rate.Text = model.COMMISSION_RATE.ToString();
            txt_amount.Text = model.SALES_PRICE.ToString();
            txt_commissionamount.Text = model.TOTAL_PRICE.ToString();

        }

        protected void save()
        {
            if (Request.QueryString["ID"] != null)
            {
                string id = Request.QueryString["ID"].ToString();
                var model = db.STATEMENT_DETAILS.Where(x => x.INVOICE_NUM == id).FirstOrDefault();
                if (model != null)
                {
                    model.CLIENT_NAME = txt_name.Text;
                    model.FEE_MEMO = txt_item.Text;
                    model.BROKER_NAME = txt_brokername.Text;
                    model.QUANTITY = Convert.ToInt32( txt_quantity.Text);
                    model.COMMISSION_RATE = Convert.ToDecimal(txt_rate.Text);
                    model.SALES_PRICE = Convert.ToDecimal(txt_amount.Text);
                    model.TOTAL_PRICE = Convert.ToDecimal( txt_commissionamount.Text);
                    db.SaveChanges();
                }
            }
        }
        protected void btn_confirm_OnClick(object sender, EventArgs e)
        {
            //if (Request.QueryString["ID"] != null)
            //{
                save();
            //}
            //else
            //{
            //    add();
            //}

            string message = "Saved Successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);

        }

        protected void btn_Back_OnClick(object sender, EventArgs e) 
        {
            if (Request.QueryString["ID"] != null)
            {
                string id = Request.QueryString["ID"].ToString();
                string url = "ViewFile.aspx?ID=" + id;
                Response.Redirect(url, false);
            }
        }

       
    }
}