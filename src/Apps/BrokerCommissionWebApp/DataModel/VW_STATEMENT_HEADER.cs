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
    
    public partial class VW_STATEMENT_HEADER
    {
        public int HEADER_ID { get; set; }
        public string MONTH { get; set; }
        public int YEAR { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public string BROKER_NAME { get; set; }
        public int FLAG { get; set; }
        public Nullable<System.DateTime> Change_Date { get; set; }
        public Nullable<decimal> STATEMENT_TOTAL { get; set; }
        public Nullable<decimal> STATEMENT_PENDING_TOTAL { get; set; }
    }
}
