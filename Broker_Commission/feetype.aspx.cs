using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Web.Data;

namespace Broker_Commission
{
    public partial class feetype : System.Web.UI.Page
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
            cmb_feetype.Items.Clear();
            cmb_feetype.Items.Add(new ListEditItem("All"));
            var list = db.FEE_MEMO.Where(x => x.MEMO!= null).ToList();
            foreach (var items in list)
            {
                cmb_feetype.Items.Add(new ListEditItem(items.MEMO));

            }

            cmb_feetype.SelectedIndex = 0;
        }


        protected void DataLoad()
        {
            var list = db.FEE_MEMO.Where(x => x.MEMO != null).ToList();
            if (!string.IsNullOrEmpty(cmb_feetype.Text) && cmb_feetype.SelectedIndex != 0)
            {
                string borkertext = cmb_feetype.SelectedItem.Text;
                list = list.Where(x => x.MEMO == borkertext).ToList();
            }

            grid_feetype.DataSource = list;
           grid_feetype.DataBind();

        }

        protected void cmb_feetype_OnSelectedIndexChanged(object sender, EventArgs e)
        {
           DataLoad();
        }

        protected void grid_broker_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Edit")
            {
                string id = e.CommandArgs.CommandArgument.ToString();
                string url = "feetype_add.aspx?ID=" + id;
                Response.Redirect(url);

            }
        }

        protected void grid_broker_OnPageIndexChanged(object sender, EventArgs e)
        {
            var view = sender as ASPxGridView;
            if (view == null) return;
            var pageIndex = view.PageIndex;
            grid_feetype.PageIndex = pageIndex;
            DataLoad();
        }

       
        protected void ASPxCheckBox1_OnCheckedChanged(object sender, EventArgs e)
        {
            ASPxCheckBox cbChkBox = sender as ASPxCheckBox;
            GridViewDataItemTemplateContainer container = cbChkBox.NamingContainer as GridViewDataItemTemplateContainer;
            String chkLstid;
            chkLstid = container.KeyValue.ToString();

            //Response.Write(chkLstid);

            int id = int.Parse(chkLstid);
            var model = db.FEE_MEMO.Where(x => x.ID == id).FirstOrDefault();
            if (model != null)
            {
                if (cbChkBox.Checked)
                {
                    model.COMMISIONABLE = 1;
                }
                else
                {
                    model.COMMISIONABLE = 0;
                }

                db.SaveChanges();
            }

            DataLoad();
        }

        protected void btn_new_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("feetype_add.aspx");
        }
    }
}