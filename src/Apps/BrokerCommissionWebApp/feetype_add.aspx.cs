using System;
using System.Linq;

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
            if (Request.QueryString["MEMO"] != null)
            {
                // todo: @Ayo: pass memo as querystring not id
                string memo = Request.QueryString["MEMO"].ToString();
                var model = db.Fee_Memo.Where(x => x.MEMO == memo).FirstOrDefault();
                if (model != null)
                {
                    txt_name.Text = model.MEMO;
                    //lbl_no.Text = model.ID.ToString();
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
            if (Request.QueryString["MEMO"] != null)
            {
                // todo: @Ayo: pass memo as querystring not id
                string memo = Request.QueryString["MEMO"].ToString();
                var model = db.Fee_Memo.Where(x => x.MEMO == memo).FirstOrDefault();
                if (model != null)
                {
                    model.MEMO = txt_name.Text;
                    model.NOTE = memo_note.Text;
                    if (cb_commission.Checked) { model.COMMISIONABLE = 1; } else { model.COMMISIONABLE = 0; }
                    db.SaveChanges();
                }
            }
        }

        protected void add()
        {
            var model = new Fee_Memo()
            {
                MEMO = txt_name.Text,
                NOTE = memo_note.Text,
                COMMISIONABLE = cb_commission.Checked ? 1 : 0
            };


            db.Fee_Memo.Add(model);
            db.SaveChanges();
        }

        protected void delete()
        {
            if (Request.QueryString["MEMO"] != null)
            {
                // todo: @Ayo: pass memo as querystring not id
                string memo = Request.QueryString["MEMO"].ToString();
                var model = db.Fee_Memo.Where(x => x.MEMO == memo).FirstOrDefault();
                if (model != null)
                {
                    db.Fee_Memo.Remove(model);
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
            Response.Redirect("feetype.aspx", false);
            // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btn_delete_OnClick(object sender, EventArgs e)
        {
            delete();
            string message = "Deleted Successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + message + "');", true);

            Response.Redirect("feetype.aspx", false);
            // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}