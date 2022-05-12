using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace BrokerCommissionWebApp {
    public partial class RootMaster : System.Web.UI.MasterPage {
        protected void Page_Load(object sender, EventArgs e) {
            ASPxLabel2.Text = DateTime.Now.Year + Server.HtmlDecode(" &copy; Copyright by [Clarity Benefits Solutions]");

            Assembly assembly = Assembly.GetCallingAssembly();
            string strVersion = assembly.GetName().Version.ToString();
            ASPxLabel1.Text = "System Version: "+ strVersion;



        }
    }
}