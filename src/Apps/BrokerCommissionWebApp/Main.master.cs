using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BrokerCommissionWebApp {
    public partial class MainMaster : System.Web.UI.MasterPage {
        protected void Page_Load(object sender, EventArgs e) {
            if (!Page.IsPostBack)
            {
                this.txtEnvironment.Text = util.Environment + " Environment";
            }
          
        }
    }
}