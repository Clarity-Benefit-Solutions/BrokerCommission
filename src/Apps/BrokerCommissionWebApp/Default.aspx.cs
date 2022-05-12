using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.XtraReports.Parameters;
using System.Web.Configuration;
using System.Web.UI.WebControls;
using DevExpress.XtraCharts;
using DevExpress.XtraRichEdit.Commands.Internal;

using BrokerCommissionWebApp.DataModel;

namespace BrokerCommissionWebApp {
    public partial class _Default : System.Web.UI.Page
    {
        Broker_CommissionEntities db = new Broker_CommissionEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadList();
                loadChart();
                DataLoad();
            }
        }

        protected void LoadList()
        {
            cmb_broker.Items.Clear();
            cmb_broker.Items.Add(new ListEditItem("All"));

            cmb_qb_broker.Items.Clear();
            cmb_qb_broker.Items.Add(new ListEditItem("All"));


            var list = db.BROKER_MASTER.Where(x => x.BROKER_NAME != null).OrderBy(x => x.BROKER_NAME).ToList();
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

        protected void loadChart()
        {
            WebChartControl1.Series.Clear();
            WebChartControl2.Series.Clear();

            var list = db.DASH_BOARD.Where(x => x.BROKER_NAME != null).ToList();
             
            var regu = list.Where(x => x.BROKER_STATUS == "REGULAR" && x.TOTAL_AMOUNT!=0 && x.TOTAL_AMOUNT!=null).ToList();
            var eli = list.Where(x => x.BROKER_STATUS == "ELITE BROKER" && x.TOTAL_AMOUNT != 0 && x.TOTAL_AMOUNT != null ).ToList();
            foreach (var item in regu)
            {
                string seriesName = item.BROKER_NAME;
                Series newSeries = new Series();
                newSeries.Name = seriesName;

                newSeries.Points.Add(new SeriesPoint(item.BROKER_NAME
                                  , new double[] { Convert.ToDouble(item.TOTAL_AMOUNT) }));

                newSeries.ShowInLegend = false;
                newSeries.LabelsVisibility = DefaultBoolean.True;
                newSeries.Label.TextPattern = "{V:C1}";
                newSeries.Label.TextAlignment = StringAlignment.Far;
                SideBySideBarSeriesView view = newSeries.View as SideBySideBarSeriesView;
                view.Border.Visibility = DevExpress.Utils.DefaultBoolean.True;
                view.BarWidth = 5;
                WebChartControl1.Series.Add(newSeries);

            }


            foreach (var item in eli)
            {
                string seriesName = item.BROKER_NAME;
              
                Series newSeries = new Series();
                newSeries.Name = seriesName;

                newSeries.Points.Add(new SeriesPoint(item.BROKER_NAME
                    , new double[] { Convert.ToDouble(item.TOTAL_AMOUNT) }));

                newSeries.ShowInLegend = false;
                newSeries.LabelsVisibility = DefaultBoolean.True;
                newSeries.Label.TextPattern = "{V:C1}";
                newSeries.Label.TextAlignment = StringAlignment.Far;
                SideBySideBarSeriesView view = newSeries.View as SideBySideBarSeriesView;
                view.Border.Visibility = DevExpress.Utils.DefaultBoolean.True;
                view.BarWidth = 5;
                WebChartControl2.Series.Add(newSeries);

            }
        }
        protected void DataLoad()
        {
            var list = db.DASH_BOARD.Where(x => x.BROKER_NAME != null).ToList();
            foreach (var item in list)
            {
                if (item.BROKER_STATUS != "ELITE BROKER")
                {
                    item.STATUS = getPercentage(item.TOTAL_AMOUNT == null ? 0 : Convert.ToDecimal(item.TOTAL_AMOUNT));
                }
                else
                {
                    item.STATUS = "100";
                }
               
            }

            lbl_count.Text = list.Count().ToString();
            lbl_sum.Text = string.Format(CultureInfo.GetCultureInfo(1033), "{0:C}", Math.Round(list.Sum(x => x.TOTAL_AMOUNT) == null ? 0 : Convert.ToDouble(list.Sum(x => x.TOTAL_AMOUNT).ToString())));

            var regu = list.Where(x => x.BROKER_STATUS == "REGULAR").ToList();
            var eli = list.Where(x => x.BROKER_STATUS == "ELITE BROKER").ToList();

            lbl_elite.Text = eli.Count().ToString();
            lbl_regular.Text = regu.Count().ToString();



            lbl_elite_sum.Text = string.Format(CultureInfo.GetCultureInfo(1033), "{0:C}", Math.Round(eli.Sum(x => x.TOTAL_AMOUNT) == null ? 0 : Convert.ToDouble(eli.Sum(x => x.TOTAL_AMOUNT).ToString())));
            lbl_regular_sum.Text = string.Format(CultureInfo.GetCultureInfo(1033), "{0:C}", Math.Round(regu.Sum(x => x.TOTAL_AMOUNT) == null ? 0 : Convert.ToDouble(regu.Sum(x => x.TOTAL_AMOUNT).ToString())));

            if (!string.IsNullOrEmpty(cmb_broker.Text) && cmb_broker.SelectedIndex != 0)
            {
                string borkertext = cmb_broker.SelectedItem.Text;
                list = list.Where(x => x.BROKER_NAME == borkertext).ToList();
            }
            if (!string.IsNullOrEmpty(cmb_qb_broker.Text) && cmb_qb_broker.SelectedIndex != 0)
            {
                string borkertext = cmb_qb_broker.SelectedItem.Text;
                list = list.Where(x => x.BROKER_NAME_ID == borkertext).ToList();
            }
            if (cmb_status.SelectedIndex != 0 && cmb_status.SelectedIndex != -1)
            {
                int index = cmb_status.SelectedIndex;
                if (index == 1)
                {
                    list = list.Where(x => x.BROKER_STATUS == "ELITE BROKER").ToList();
                }
                else if (index == 2)
                {
                    list = list.Where(x => x.BROKER_STATUS == "REGULAR").ToList();
                }

            }


            grid_broker.DataSource = list;
            grid_broker.DataBind();

        }

        protected string getPercentage(decimal currentValue)
        {
            string a;
             
            decimal maxValue = 30000;
           
            int percentValue = (int)Math.Round(100 * (currentValue  ) / (maxValue  ));
            //ASPxProgressBar1.Position = percentValue;

            if (percentValue > 100)
            {
                percentValue = 100;
            }
            a = percentValue.ToString();


            return a;
        }
            
        protected void cmb_broker_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            DataLoad();
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
                string url = "BROKER_VIEW.aspx?ID=" + id;
                Response.Redirect(url, false);
                // note:: avoid ThreadAbort Exception in .Net v4.7x on redirect
                Context.ApplicationInstance.CompleteRequest();
            }
        }



       
    }
}