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
    }
}
