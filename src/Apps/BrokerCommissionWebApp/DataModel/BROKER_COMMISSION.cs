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
    
    public partial class Broker_Commission
    {
        public int ID { get; set; }
        public string PERIOD { get; set; }
        public Nullable<int> BROKER_ID { get; set; }
        public string BROKER_NAME { get; set; }
        public Nullable<int> PAYLOCITY_NUMBER { get; set; }
        public Nullable<decimal> PAYMENT_AMOUNT { get; set; }
        public System.DateTime created_at { get; set; }
        public string created_by { get; set; }
    }
}
