//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BrokerCommissionWebApp
{
    using System;
    using System.Collections.Generic;
    
    public partial class VW_STATEMENT
    {
        public int HEADER_ID { get; set; }
        public string PID { get; set; }
        public string MONTH { get; set; }
        public int YEAR { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public string BROKER_NAME { get; set; }
        public int FLAG { get; set; }
        public Nullable<decimal> STATEMENT_TOTAL { get; set; }
        public Nullable<System.DateTime> Change_Date { get; set; }
        public string QB_CLIENT_NAME { get; set; }
        public string CLIENT_NAME { get; set; }
        public string QB_FEE { get; set; }
        public string FEE_MEMO { get; set; }
        public Nullable<int> QUANTITY { get; set; }
        public Nullable<decimal> COMMISSION_RATE { get; set; }
        public string UNIT { get; set; }
        public Nullable<decimal> SALES_PRICE { get; set; }
        public Nullable<decimal> TOTAL_PRICE { get; set; }
        public string START_DATE { get; set; }
        public string BROKER_STATUS { get; set; }
        public Nullable<decimal> OPEN_BALANCE { get; set; }
    }
}
