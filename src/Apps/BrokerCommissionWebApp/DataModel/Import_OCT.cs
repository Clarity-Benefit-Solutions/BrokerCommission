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
    
    public partial class Import_OCT
    {
        public int ID { get; set; }
        public string Type { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public string Num { get; set; }
        public string Name { get; set; }
        public string Memo { get; set; }
        public string Agent { get; set; }
        public Nullable<int> Qty { get; set; }
        public Nullable<decimal> Sales_Price { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<decimal> Open_Balance { get; set; }
        public string NUM_FORMATTED { get; set; }
        public string memo_FORMATTED { get; set; }
        public string Agent_FORMATTED { get; set; }
        public string Name_FORMATTED { get; set; }
        public Nullable<System.DateTime> created_at { get; set; }
        public string statement_month { get; set; }
        public string statement_year { get; set; }
        public int is_deleted { get; set; }
        public string created_by { get; set; }
    }
}
