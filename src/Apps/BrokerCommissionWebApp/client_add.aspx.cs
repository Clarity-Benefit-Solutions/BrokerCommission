using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using BrokerCommissionWebApp.DataModel;


namespace BrokerCommissionWebApp
{
    public partial class client_add : System.Web.UI.Page
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
                var model = db.CLIENT_.Where(x => x.CLIENT_ID == id).FirstOrDefault();
                if (model != null)
                {
                    txt_name.Text = model.CLIENT_NAME;
                    lbl_no.Text = model.CLIENT_ID.ToString();
                    //if (model.COMMISSION_RATE != null)
                    //{
                    //    txt_rate.Text = model.COMMISSION_RATE.ToString();
                    //}

                    memo_note.Text = model.FEE_MEMO;
                    cmb_status.Text = model.STATUS == null ? "ACTIVE" : model.STATUS;
                }
            }
        }


        protected void save()
        {
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.CLIENT_.Where(x => x.CLIENT_ID == id).FirstOrDefault();
                if (model != null)
                {
                    model.CLIENT_NAME = txt_name.Text;
                    model.FEE_MEMO = memo_note.Text;
                    model.STATUS = cmb_status.Text;
                    decimal rate = 0.0m;
                    //decimal.TryParse(txt_rate.Text, out rate);
                    //if (!string.IsNullOrEmpty(txt_rate.Text))
                    //{
                    //    model.COMMISSION_RATE = rate;
                    //}
                    
                    db.SaveChanges();
                }
            }
        }

        protected void add()
        {
            decimal rate = 0.0m;
            //decimal.TryParse(txt_rate.Text, out rate);
            var model = new CLIENT_()
            {
                CLIENT_NAME = txt_name.Text,
                FEE_MEMO = memo_note.Text,
                STATUS = cmb_status.Text
                //COMMISSION_RATE = rate
            };


            db.CLIENT_.Add(model);
            db.SaveChanges();
        }

        protected void delete()
        {
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.CLIENT_.Where(x => x.CLIENT_ID == id).FirstOrDefault();
                if (model != null)
                {
                    db.CLIENT_.Remove(model);
                    db.SaveChanges();
                    //string message = "Deleted Successfully!";
                    //ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);

                }
            }
        }


        protected void btn_confirm_OnClick(object sender, EventArgs e)
        {
            if (Request.QueryString["ID"] != null)
            {
                save();
            }
            else
            {
                add();
            }

            string message = "Saved Successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);

        }

        protected void btn_Back_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("client.aspx", false);
            // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btn_delete_OnClick(object sender, EventArgs e)
        {
          

            if (Request.QueryString["ID"] != null)
            {
                delete();
                ScriptManager.RegisterStartupScript(this, this.GetType(),
            "alert",
             "alert('Deleted Successfully!');window.location ='client.aspx';",
              true);
            }
           
           // Response.Redirect("client.aspx", false);
            // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
            //Context.ApplicationInstance.CompleteRequest();
        }
    }
}