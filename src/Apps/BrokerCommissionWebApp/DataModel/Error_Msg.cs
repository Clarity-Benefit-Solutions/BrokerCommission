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
    
    public partial class Error_Msg
    {
        public int ID { get; set; }
        public string Flat_File_Source_Error_Output_Column { get; set; }
        public Nullable<int> ErrorCode { get; set; }
        public Nullable<int> ErrorColumn { get; set; }
        public System.DateTime created_at { get; set; }
        public string created_by { get; set; }
    }
}
