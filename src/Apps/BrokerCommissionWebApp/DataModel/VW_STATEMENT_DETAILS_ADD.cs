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
    
    public partial class VW_STATEMENT_DETAILS_ADD
    {
        public int ID { get; set; }
        public string BROKER_NAME { get; set; }
        public string QB_BROKER_NAME { get; set; }
        public string QB_AGENT { get; set; }
        public string CLIENT_NAME { get; set; }
        public string QB_CLIENT { get; set; }
        public string QB_FEE { get; set; }
        public string MEMO { get; set; }
        public Nullable<decimal> Qty { get; set; }
        public Nullable<decimal> Sales_Price { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public int Open_Balance { get; set; }
        public Nullable<decimal> COMMISSION_RATE { get; set; }
        public string UNIT { get; set; }
        public Nullable<decimal> COMMISSION_AMOUNT { get; set; }
        public string BROKER_STATUS { get; set; }
        public string EMAIL { get; set; }
        public string QB_CLIENT_NAME { get; set; }
        public string FEE_MEMO { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public System.DateTime Date { get; set; }
        public string PAYLOCITY_ID { get; set; }
        public string START_DATE { get; set; }
        public string Num { get; set; }
        public string invoice_date { get; set; }
        public int CLIENT_ID { get; set; }
    }
}
