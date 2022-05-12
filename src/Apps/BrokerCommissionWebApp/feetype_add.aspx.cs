using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public partial class feetype_add : System.Web.UI.Page
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
                var model = db.FEE_MEMO.Where(x => x.ID == id).FirstOrDefault();
                if (model != null)
                {
                    txt_name.Text = model.MEMO;
                    lbl_no.Text = model.ID.ToString();
                    if (model.COMMISIONABLE != null)
                    {
                        if (model.COMMISIONABLE == 1)
                        {
                            cb_commission.Checked = true;
                        }
                        else
                        {
                            cb_commission.Checked = false;
                        }
                    }
                    else
                    {
                        cb_commission.Checked = false;
                    }
                }
            }
        }


        protected void save()
        {
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.FEE_MEMO.Where(x => x.ID == id).FirstOrDefault();
                if (model != null)
                {
                    model.MEMO = txt_name.Text;
                    model.NOTE = memo_note.Text; 
                    if(cb_commission.Checked){ model.COMMISIONABLE = 1; } else{ model.COMMISIONABLE = 0; } 
                    db.SaveChanges();
                }
            }
        }

        protected void add()
        {
            var model = new FEE_MEMO()
            {
                MEMO = txt_name.Text,
                NOTE = memo_note.Text,
                COMMISIONABLE = cb_commission.Checked ? 1 : 0 
            };


            db.FEE_MEMO.Add(model);
            db.SaveChanges(); 
        }

        protected void delete()
        {
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.FEE_MEMO.Where(x => x.ID == id).FirstOrDefault();
                if (model != null)
                {
                    db.FEE_MEMO.Remove(model);
                    db.SaveChanges();
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
            Response.Redirect("feetype.aspx");
        }

        protected void btn_delete_OnClick(object sender, EventArgs e)
        {
            delete();
            string message = "Deleted Successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);

            Response.Redirect("feetype.aspx");
        }
    }
}