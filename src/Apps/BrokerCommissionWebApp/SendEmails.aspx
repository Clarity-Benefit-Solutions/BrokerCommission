<%@ Page Title="" Language="C#" MasterPageFile="~/Light.master" AutoEventWireup="true" CodeBehind="SendEmails.aspx.cs" Inherits="BrokerCommissionWebApp.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
    function CloseTheFreakingWindow() {
            if (window.opener != null) {
                window.opener.location = window.opener.location;
            } else {
                window.parent.opener.location = window.parent.opener.location;
                window.parent.open('', '_self', ''); window.parent.close();
                window.open('', '_self', ''); window.close();
            }
            window.open('', '_self', ''); window.close();
        }
    </script>
  
    <div class="row">
        <div class="col-lg-1">
        </div>
        <div class="col-lg-10">
           
             <div style="width: 100%; text-align: right; margin-bottom: 20px">

                  
            
                        <dx:ASPxButton runat="server" ID="btn_exit" Text="EXIT" Theme="Moderno" OnClick="btn_exit_onclick">
                        </dx:ASPxButton>
                   
         

            </div>
     
                    <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                <Items>
                    <dx:LayoutGroup Width="40%" Caption="SEARCH" ColCount="2" ShowCaption="False">

                        <Items>

                            <dx:LayoutItem Caption="STATEMENT PERIOD" VerticalAlign="Middle" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="lbl_month" Theme="Moderno" Font-Bold="True" />
                                        &nbsp;
                                        <dx:ASPxLabel runat="server" ID="lbl_year" Theme="Moderno" Font-Bold="True" />
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="ASPxLabel1" Theme="Moderno" Font-Bold="True" Text="Execution Time:" />
                                        
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem> 
                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Left" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbl_time_execution" runat="server" Font-Bold="true"></dx:ASPxLabel>
                                       
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="ASPxLabel4" Theme="Moderno" Font-Bold="True" Text="Status:" />
                                        
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem> 
                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Left" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel ID="lbl_status" runat="server" Font-Bold="true"></dx:ASPxLabel>
                                       
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="ASPxLabel5" Theme="Moderno" Font-Bold="True" Text="Total Brokers:" />
                                        
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem> 
                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Left" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                         <dx:ASPxLabel ID="lbl_TotalCount" runat="server" Font-Bold="true"></dx:ASPxLabel>
                                       
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="ASPxLabel2" Theme="Moderno" Font-Bold="True" Text="Emails Sent:" />
                                        
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem> 
                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Left" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                         <dx:ASPxLabel ID="lbl_sent" runat="server" Font-Bold="true"></dx:ASPxLabel>
                                       
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                            <dx:LayoutItem Caption="PROGRESS" VerticalAlign="Middle" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                       <dx:ASPxProgressBar ID="ASPxProgressBar1" runat="server"  Theme="Moderno"   Width="100%"></dx:ASPxProgressBar>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>


                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="ASPxLabel3" Theme="Moderno" Font-Bold="True" Text="Error Emails:" />
                                        
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem> 
                             <dx:LayoutItem  VerticalAlign="Middle" HorizontalAlign="Left" ShowCaption="False"  >
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                         <dx:ASPxLabel ID="lbl_not_sent" runat="server" Font-Bold="true"></dx:ASPxLabel>
                                       
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
           
            
        </div>
        <div class="col-lg-1">
        </div>
    </div>

    
</asp:Content>
