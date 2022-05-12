using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Export;
using DevExpress.Web;
using DevExpress.XtraPrinting;
using DevExpress.XtraReports.Parameters;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp
{
    public partial class brokerMaster : System.Web.UI.Page
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
            cmb_broker.Items.Clear();
            cmb_broker.Items.Add(new ListEditItem("All"));

            cmb_qb_broker.Items.Clear();
            cmb_qb_broker.Items.Add(new ListEditItem("All"));


            var list = db.BROKER_MASTER.Where(x => x.BROKER_NAME != null).OrderBy(x=>x.BROKER_NAME).ToList();
            foreach (var items in list)
            {
                cmb_broker.Items.Add(new ListEditItem(items.BROKER_NAME));
                if (!string.IsNullOrEmpty(items.BROKER_NAME_ID))
                {
                    cmb_qb_broker.Items.Add(new ListEditItem(items.BROKER_NAME_ID));
                }
               
            }
            cmb_qb_broker.SelectedIndex = 0;
            cmb_broker.SelectedIndex = 0;
        }

        protected void DataLoad()
        {
            var list = db.BROKER_MASTER.Where(x => x.BROKER_NAME != null).ToList();
            if (!string.IsNullOrEmpty(cmb_broker.Text) && cmb_broker.SelectedIndex!= 0)
            {
                string borkertext = cmb_broker.SelectedItem.Text;
                list = list.Where(x => x.BROKER_NAME == borkertext).ToList();
            }
            if (!string.IsNullOrEmpty(cmb_qb_broker.Text) && cmb_qb_broker.SelectedIndex != 0)
            {
                string borkertext = cmb_qb_broker.SelectedItem.Text;
                list = list.Where(x => x.BROKER_NAME_ID == borkertext).ToList();
            }
            if ( cmb_status.SelectedIndex != 0 && cmb_status.SelectedIndex != -1)
            {
                int index = cmb_status.SelectedIndex;
                if (index == 1)
                {
                    list = list.Where(x => x.BROKER_STATUS == "ELITE BROKER").ToList();
                }else if (index == 2)
                {
                    list = list.Where(x => x.BROKER_STATUS == "REGULAR").ToList();
                }
               
            }


            grid_broker.DataSource = list;
            grid_broker.DataBind();

        }

        protected void cmb_broker_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            DataLoad();
        }

        protected void ASPxMenu1_ItemClick(object source, MenuItemEventArgs e)
        {
            DataLoad();
            if (e.Item.GroupName == "Excel")
            {
                gridExport.WriteXlsxToResponse(new XlsxExportOptionsEx { ExportType = ExportType.WYSIWYG });
            }
            else if (e.Item.GroupName == "CSV")
            {
                gridExport.WriteCsvToResponse(new CsvExportOptionsEx { ExportType = ExportType.WYSIWYG });
            }

            else if (e.Item.GroupName == "New")
            {
                string url = "brokerAdd.aspx";
                Response.Redirect(url, false);
                // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
                Context.ApplicationInstance.CompleteRequest();
            }

        }

        protected void ASPxGridView1_OnPageIndexChanged(object sender, EventArgs e)
        {
            var view = sender as ASPxGridView;
            if (view == null) return;
            var pageIndex = view.PageIndex;
            grid_broker.PageIndex = pageIndex;
            DataLoad();
        }

        protected void grid_broker_OnRowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Edit")
            {
                string id = e.CommandArgs.CommandArgument.ToString();
                string url = "brokerAdd.aspx?ID=" + id;
                Response.Redirect(url, false);
                // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        protected void btn_add_OnClick(object sender, EventArgs e)
        {
            string url = "brokerAdd.aspx";
            Response.Redirect(url, false);
            // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}