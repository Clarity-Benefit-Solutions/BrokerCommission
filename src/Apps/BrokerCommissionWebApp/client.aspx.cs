using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace BrokerCommissionWebApp
{
    public partial class client : System.Web.UI.Page
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
            cmb_client.Items.Clear();
            cmb_client.Items.Add(new ListEditItem("All"));
            var list = db.CLIENT_.Where(x => x.CLIENT_NAME!= null).ToList();
            foreach (var items in list)
            {
                cmb_client.Items.Add(new ListEditItem(items.CLIENT_NAME));

            }

            cmb_client.SelectedIndex = 0;
        }

        protected void DataLoad()
        {
            var list = db.CLIENT_.Where(x => x.CLIENT_NAME != null).ToList();
            if (!string.IsNullOrEmpty(cmb_client.Text) && cmb_client.SelectedIndex != 0)
            {
                string borkertext = cmb_client.SelectedItem.Text;
                list = list.Where(x => x.CLIENT_NAME == borkertext).ToList();
            }

            grid_client.DataSource = list;
            grid_client.DataBind();

        }

        protected void grid_client_OnPageIndexChanged(object sender, EventArgs e)
        {
            var view = sender as ASPxGridView;
            if (view == null) return;
            var pageIndex = view.PageIndex;
            grid_client.PageIndex = pageIndex;
            DataLoad();
        }

        protected void grid_client_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Edit")
            {
                string id = e.CommandArgs.CommandArgument.ToString();
                string url = "client_add.aspx?ID=" + id;
                Response.Redirect(url);

            }
        }

        protected void cmb_client_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            DataLoad();
        }

        protected void btn_new_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("client_add.aspx");
        }
    }
}