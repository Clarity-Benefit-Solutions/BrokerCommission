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
    
    public partial class Client_Prv
    {
        public int CLIENT_ID { get; set; }
        public string QB_CLIENT_NAME { get; set; }
        public string CLIENT_NAME { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public string QB_FEE { get; set; }
        public string FEE_MEMO { get; set; }
        public Nullable<decimal> COMMISSION_RATE { get; set; }
        public string UNIT { get; set; }
        public string STATUS { get; set; }
        public string FEE { get; set; }
        public string START_DATE { get; set; }
        public string QB_CLIENT_NAME_FORMATTED { get; set; }
        public string QB_FEE_FORMATTED { get; set; }
        public System.DateTime created_at { get; set; }
        public string created_by { get; set; }
    }
}
