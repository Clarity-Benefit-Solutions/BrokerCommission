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
    
    public partial class STATEMENT_DETAILS_ARCHIVE
    {
        public int ARCHIVE_DETAIL_ID { get; set; }
        public int DETAIL_ID { get; set; }
        public int HEADER_ID { get; set; }
        public Nullable<System.DateTime> INVOICE_DATE { get; set; }
        public string INVOICE_NUM { get; set; }
        public string QB_CLIENT_NAME { get; set; }
        public string CLIENT_NAME { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public string BROKER_NAME { get; set; }
        public string QB_FEE { get; set; }
        public string FEE_MEMO { get; set; }
        public Nullable<int> QUANTITY { get; set; }
        public Nullable<decimal> COMMISSION_RATE { get; set; }
        public string UNIT { get; set; }
        public string STATUS { get; set; }
        public Nullable<decimal> SALES_PRICE { get; set; }
        public Nullable<decimal> TOTAL_PRICE { get; set; }
        public string START_DATE { get; set; }
        public string BROKER_STATUS { get; set; }
        public Nullable<decimal> OPEN_BALANCE { get; set; }
        public string month { get; set; }
        public Nullable<int> year { get; set; }
        public string line_payment_status { get; set; }
        public Nullable<decimal> TOTAL_PRICE_PAID_THIS_PERIOD { get; set; }
    }
}
