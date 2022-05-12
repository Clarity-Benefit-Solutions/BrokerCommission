using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace BrokerCommissionWebApp
{
    public partial class brokerAdd : System.Web.UI.Page
    {
        Broker_CommissionEntities db = new Broker_CommissionEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadList();

                DataLoad();
            }
        }

        protected void LoadList()
        {
            cmb_qb_client.Items.Clear();
            cmb_qb_memo.Items.Clear();
            cmb_st_memo.Items.Clear();
            //cmb_qb_client.Items.Add(new ListEditItem("All"));
            var list = db.CLIENT_.Where(x => x.CLIENT_NAME != null).OrderBy(x => x.CLIENT_NAME).ToList();
            foreach (var items in list)
            {
                cmb_qb_client.Items.Add(new ListEditItem(items.CLIENT_NAME));

            }

            var list_memo = db.FEE_MEMO.Where(x => x.MEMO != null && x.COMMISIONABLE == 1).OrderBy(x => x.MEMO)
                .ToList();
            foreach (var items in list_memo)
            {
                cmb_qb_memo.Items.Add(new ListEditItem(items.MEMO));
                cmb_st_memo.Items.Add(new ListEditItem(items.MEMO));

            }
            //cmb_qb_client.SelectedIndex = 0;
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
                    if (model.BROKER_STATUS == "ELITE BROKER")
                    {
                        cb_premium.Checked = true;
                    }

                    txt_body.Text = model.NOTES;
                    txt_email.Text = model.EMAIL;
                    txt_sec_email.Text = model.SECONDARY_EMAIL;
                    txt_rate.Text = model.PREMIUM_TH == null ? "0" : model.PREMIUM_TH.ToString();

                    txt_paylicity.Text = model.PAYLOCITY_ID;
                    txt_qn_name_1.Text = model.BROKER_NAME_1;
                    txt_qn_name_2.Text = model.BROKER_NAME_2;
                    txt_qn_name_3.Text = model.BROKER_NAME_3;
                    txt_qn_name_4.Text = model.BROKER_NAME_4;

                    if (model.STATUS == null || string.IsNullOrEmpty(model.STATUS))
                    {
                        cmb_status.SelectedIndex = 0;
                    }
                    else
                    {
                        cmb_status.Text = model.STATUS;
                    }

                    loadClient_ByBrokerID(id);
                }
            }

        }


        protected void loadClient_ByBrokerID(int brokerID)
        {
            var list = db.CLIENTs.Where(x => x.BROKER_ID == brokerID).OrderBy(x => x.CLIENT_NAME).ToList();

            grid_client.DataSource = list;
            grid_client.DataBind();

        }

        protected void btn_Back_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("brokerMaster.aspx");
        }

        protected void save()
        {
            if (Request.QueryString["ID"] != null)
            {
                int id = int.Parse(Request.QueryString["ID"].ToString());
                var model = db.BROKER_MASTER.Where(x => x.ID == id).FirstOrDefault();
                if (model != null)
                {
                    if (!string.IsNullOrEmpty(txt_name.Text))
                    {
                        model.BROKER_NAME = txt_name.Text.ToUpper();
                    }

                    if (!string.IsNullOrEmpty(txt_qb_name.Text))
                    {
                        model.BROKER_NAME_ID = txt_qb_name.Text.ToUpper();
                    }

                    if (!string.IsNullOrEmpty(txt_email.Text))
                    {
                        model.EMAIL = txt_email.Text;
                    }

                    if (!string.IsNullOrEmpty(txt_sec_email.Text))
                    {
                        model.SECONDARY_EMAIL = txt_sec_email.Text;
                    }

                    if (!string.IsNullOrEmpty(txt_rate.Text))
                    {
                        decimal rate = 0.0m;
                        decimal.TryParse(txt_rate.Text, out rate);
                        model.PREMIUM_TH = rate;
                    }



                    if (cb_premium.Checked == true)
                    {
                        model.BROKER_STATUS = "ELITE BROKER";
                    }
                    else
                    {
                        model.BROKER_STATUS = "REGULAR";
                    }



                    model.PAYLOCITY_ID = txt_paylicity.Text;
                    model.BROKER_NAME_1 = !string.IsNullOrEmpty(txt_qn_name_1.Text) ? txt_qn_name_1.Text : null;
                    model.BROKER_NAME_2 = !string.IsNullOrEmpty(txt_qn_name_2.Text) ? txt_qn_name_2.Text : null;
                    model.BROKER_NAME_3 = !string.IsNullOrEmpty(txt_qn_name_3.Text) ? txt_qn_name_3.Text : null;
                    model.BROKER_NAME_4 = !string.IsNullOrEmpty(txt_qn_name_4.Text) ? txt_qn_name_4.Text : null;





                    if (!string.IsNullOrEmpty(txt_body.Text))
                    {
                        model.NOTES = txt_body.Text;
                    }



                    model.STATUS = cmb_status.Text;
                    db.SaveChanges();

                    string myStringVariable = "Saved Successfully!";
                    ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + myStringVariable + "');",
                        true);

                }
            }
        }

        protected void add()
        {


            var model = new BROKER_MASTER();

            if (!string.IsNullOrEmpty(txt_name.Text))
            {
                model.BROKER_NAME = txt_name.Text.ToUpper();
            }

            if (!string.IsNullOrEmpty(txt_qb_name.Text))
            {
                model.BROKER_NAME_ID = txt_qb_name.Text.ToUpper();
            }

            if (!string.IsNullOrEmpty(txt_email.Text))
            {
                model.EMAIL = txt_email.Text;
            }

            if (!string.IsNullOrEmpty(txt_rate.Text))
            {
                decimal rate = 0.0m;
                decimal.TryParse(txt_rate.Text, out rate);
                model.PREMIUM_TH = rate;
            }



            if (cb_premium.Checked == true)
            {
                model.BROKER_STATUS = "ELITE BROKER";
            }
            else
            {
                model.BROKER_STATUS = "REGULAR";
            }

            if (!string.IsNullOrEmpty(txt_sec_email.Text))
            {
                model.SECONDARY_EMAIL = txt_sec_email.Text;
            }

            model.PAYLOCITY_ID = txt_paylicity.Text;
            model.BROKER_NAME_1 = !string.IsNullOrEmpty(txt_qn_name_1.Text) ? txt_qn_name_1.Text : null;
            model.BROKER_NAME_2 = !string.IsNullOrEmpty(txt_qn_name_2.Text) ? txt_qn_name_2.Text : null;
            model.BROKER_NAME_3 = !string.IsNullOrEmpty(txt_qn_name_3.Text) ? txt_qn_name_3.Text : null;
            model.BROKER_NAME_4 = !string.IsNullOrEmpty(txt_qn_name_4.Text) ? txt_qn_name_4.Text : null;





            if (!string.IsNullOrEmpty(txt_body.Text))
            {
                model.NOTES = txt_body.Text;
            }



            model.STATUS = cmb_status.Text;
            db.BROKER_MASTER.Add(model);
            db.SaveChanges();

            string myStringVariable = "Saved Successfully!";
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + myStringVariable + "');",
                true);



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

        }

        protected void CLIENT_NAME_Init(object sender, EventArgs e)
        {
            ASPxComboBox combo = (ASPxComboBox)sender;
            if (combo != null)
            {
                GridViewDataItemTemplateContainer
                    container = combo.NamingContainer as GridViewDataItemTemplateContainer;

                var index = container.VisibleIndex;

                if (index >= 0)
                {
                    combo.Items.Clear();
                    var list = db.CLIENT_.Where(x => x.CLIENT_NAME != null).OrderBy(x => x.CLIENT_NAME).ToList();
                    foreach (var items in list)
                    {
                        combo.Items.Add(new ListEditItem(items.CLIENT_NAME));

                    }
                    //combo.Value = container.Grid.GetRowValues(container.VisibleIndex, "QB_CLIENT_NAME");

                    
                }

            }
        }

        protected void MEMO_Init(object sender, EventArgs e)
        {
            ASPxComboBox combo = (ASPxComboBox)sender;
            if (combo != null)
            {
                GridViewDataItemTemplateContainer
                    container = combo.NamingContainer as GridViewDataItemTemplateContainer;

                var index = container.VisibleIndex;

                if (index >= 0)
                {
                    combo.Items.Clear();
                    var list = db.FEE_MEMO.Where(x => x.MEMO != null).OrderBy(x => x.MEMO).ToList();
                    foreach (var items in list)
                    {
                        combo.Items.Add(new ListEditItem(items.MEMO));

                    }
                    //combo.Value = container.Grid.GetRowValues(container.VisibleIndex, "QB_FEE");
                }

            }
            
        }

        protected void sMEMO_Init(object sender, EventArgs e)
        {
            ASPxComboBox combo = (ASPxComboBox)sender;
            if (combo != null)
            {
                GridViewDataItemTemplateContainer
                    container = combo.NamingContainer as GridViewDataItemTemplateContainer;

                var index = container.VisibleIndex;

                if (index >= 0)
                {
                    combo.Items.Clear();
                    var list = db.FEE_MEMO.Where(x => x.MEMO != null).OrderBy(x => x.MEMO).ToList();
                    foreach (var items in list)
                    {
                        combo.Items.Add(new ListEditItem(items.MEMO));

                    }
                    //combo.Value = container.Grid.GetRowValues(container.VisibleIndex, "FEE_MEMO");
                }

            }
           
        }

        protected void loopandsave()
        {
            for (int i = 0; i < grid_client.VisibleRowCount; i++)
            {
                ASPxComboBox cmb_clientName = grid_client.FindRowCellTemplateControl(i, null, "cmb_clientName") as ASPxComboBox;//cmb_QB_FEE
                ASPxComboBox cmb_QB_FEE = grid_client.FindRowCellTemplateControl(i, null, "cmb_QB_FEE") as ASPxComboBox;//
                ASPxComboBox cmb_FEE_MEMO = grid_client.FindRowCellTemplateControl(i, null, "cmb_FEE_MEMO") as ASPxComboBox;//
                ASPxComboBox txt_UNIT = grid_client.FindRowCellTemplateControl(i, null, "txt_UNIT") as ASPxComboBox;//
                ASPxDateEdit de_start = grid_client.FindRowCellTemplateControl(i, null, "de_start") as ASPxDateEdit;// 
                ASPxTextBox txt_rate =
                    grid_client.FindRowCellTemplateControl(i, null, "txt_rate") as ASPxTextBox; 
                HiddenField hid_id = grid_client.FindRowCellTemplateControl(i, null, "hid_id") as HiddenField;

                if (hid_id != null)
                {

                    int PID = int.Parse(hid_id.Value);
                    var model = db.CLIENTs.Where(x => x.CLIENT_ID== PID).FirstOrDefault();
                    if (model != null)
                    {
                        model.QB_CLIENT_NAME = cmb_clientName.Text;
                        model.QB_FEE = cmb_QB_FEE.Text;
                        model.FEE_MEMO = cmb_FEE_MEMO.Text;
                        model.UNIT = txt_UNIT.Text;
                        model.START_DATE = de_start.Date.ToString();
                        decimal rate = 0.0m;
                        decimal.TryParse(txt_rate.Text, out rate);
                        model.COMMISSION_RATE = rate;

                        db.SaveChanges();
                        if (Request.QueryString["ID"] != null)
                        {
                            int id = int.Parse(Request.QueryString["ID"].ToString());
                            //loadClient_ByBrokerID(id);
                        }
                    }
                }


            }
        }
        protected void grid_client_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "DELETE")
            {
                int cid = int.Parse(e.CommandArgs.CommandArgument.ToString());
                var model = db.CLIENTs.Where((x => x.CLIENT_ID == cid)).FirstOrDefault();

                if (model != null)
                {
                    db.CLIENTs.Remove(model);
                    db.SaveChanges();
                    if (Request.QueryString["ID"] != null)
                    {
                        int id = int.Parse(Request.QueryString["ID"].ToString());
                        //loadClient_ByBrokerID(id);
                    }
                }

                DataLoad();
            }
        }

        protected void btn_add_client_OnClick(object sender, EventArgs e)
        {
            if (cmb_qb_client.SelectedIndex != -1 && cmb_qb_memo.SelectedIndex != -1)
            {
                if (Request.QueryString["ID"] != null)
                {
                    int id = int.Parse(Request.QueryString["ID"].ToString());
                    var model = new CLIENT();
                    model.BROKER_ID = id;
                    model.CLIENT_NAME = cmb_qb_client.Text;
                    model.QB_CLIENT_NAME = cmb_qb_client.Text;
                    model.QB_FEE = cmb_qb_memo.Text;
                    model.FEE_MEMO = cmb_st_memo.Text;

                    model.UNIT = cmb_unit.Text;
                    model.START_DATE = de_start_date.Date.ToString();
                    decimal rate = 0.0m;
                    decimal.TryParse(txt_cm_rate.Text, out rate);
                    model.COMMISSION_RATE = rate;
                    db.CLIENTs.Add(model);
                    db.SaveChanges();
                    //loadClient_ByBrokerID(id);
                }

            }

            //loopandsave();

            DataLoad();
        }
    }
}