//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BrokerCommissionWebApp.DataModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class db_error_log
    {
        public int log_id { get; set; }
        public string sql_state { get; set; }
        public string err_no { get; set; }
        public string err_source { get; set; }
        public string err_msg { get; set; }
        public System.DateTime created_at { get; set; }
        public string created_by { get; set; }
    }
}
