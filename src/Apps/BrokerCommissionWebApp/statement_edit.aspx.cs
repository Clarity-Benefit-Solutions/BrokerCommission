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
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btn_Back_OnClick(object sender, EventArgs e) 
        {
            string url = "ViewFile.aspx";
            Response.Redirect(url, false);
        }
    }
}