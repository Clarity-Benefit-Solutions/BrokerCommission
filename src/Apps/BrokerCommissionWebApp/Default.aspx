<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Main.master" CodeBehind="Default.aspx.cs" Inherits="BrokerCommissionWebApp._Default" %>

<%@ Register Assembly="DevExpress.XtraCharts.v21.2.Web, Version=21.2.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>
<%@ Import Namespace="System.Globalization" %>


<asp:Content ID="Content" ContentPlaceHolderID="MainContent" runat="server">
    

 <script type="text/javascript">
     function popupwindow(url, title, w, h) {
         debugger;
         var left = (screen.width / 2) - (w / 2);
         var top = (screen.height / 2) - (h / 2);
         // sumeet - do not open popup window - open new tab
         // return window.open(url, title, 'toolbar=no, location=no, directories=no, status=no,      menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
         // return window.open(url, title);//, 'toolbar=no, location=no, directories=no, status=no,      menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);

         window.open(url, '_blank').focus();
         return false;
     }
 </script>

   


            <div class="row">
                <div class="col-1">
                    
                    
               

                </div>
                <div class="col-10">
                    <div style="width: 100%; margin-top: 30px"></div>
                    <div class="headerPane" style="width: 100%;text-align:center">
                        <h6 class="text-primary" style="font-weight: bold">BROKER COMMISSION DASHBOARD</h6>
                    </div> 
                    <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                        <Items>
                            <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="3" ShowCaption="False">

                                <Items>

                                    <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxComboBox runat="server" ID="cmb_broker" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                                                 AutoPostBack="True">
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="QB BROKER NAME" VerticalAlign="Middle" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxComboBox runat="server" ID="cmb_qb_broker" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                                                 AutoPostBack="True">
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="BROKER STATUS" VerticalAlign="Middle" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxComboBox runat="server" ID="cmb_status" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                                                 AutoPostBack="True">
                                                    <Items>
                                                        <dx:ListEditItem Text="ALL BROKER" Value="0" Selected="True"/>
                                                        <dx:ListEditItem Text="ELITE BROKER" Value="1"/>
                                                        <dx:ListEditItem Text="REGULAR BROKER" Value="2"/>
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout> 
                    <dx:ASPxGridView ID="grid_broker" runat="server" AutoGenerateColumns="False" OnPageIndexChanged="ASPxGridView1_OnPageIndexChanged"
                        OnRowCommand="grid_broker_OnRowCommand" Theme="Moderno"
                        Width="100%">
                        <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" />
                        <SettingsPager PageSize="100" />
                        <Paddings Padding="0px" />
                        <Border BorderWidth="0px" />
                        <BorderBottom BorderWidth="1px" />
                        <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                        <Columns>
                       <%--     <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="0" FixedStyle="Left" Caption="Broker ID" Width="80px">
                            </dx:GridViewDataTextColumn>--%>
                            <dx:GridViewDataTextColumn FieldName="BROKER_NAME" VisibleIndex="1" FixedStyle="Left" Width="200px" Caption="BROKER NAME">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="BROKER_NAME_ID" VisibleIndex="1"   Width="200px" Caption="QB BROKER NAME">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataColumn Caption="TOTAL AMOUNT($)" VisibleIndex="1" Width="200px" FixedStyle="Left">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxLabel runat="server" ID="lbl_total" Text='<%# string.Format(CultureInfo.GetCultureInfo(1033), "{0:C}", Math.Round(Eval("TOTAL_AMOUNT")==null?0:Convert.ToDouble(Eval("TOTAL_AMOUNT").ToString()) )) %>' Theme="Moderno"/>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn Caption="BROKER STATUS" VisibleIndex="2" Width="180px">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxLabel runat="server" ID="lbl_BROKER_STATUS" Text='<%# Eval("BROKER_STATUS") == null? "N/A": Eval("BROKER_STATUS").ToString() %>' />
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn Caption="ELITE PROGRESS" VisibleIndex="2"   Width="200px">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <%# int.Parse(Eval("STATUS")==null?"0":Eval("STATUS").ToString()) %>
                                    <dx:ASPxProgressBar ID="ASPxProgressBar1" runat="server"  Theme="Moderno" Position='<%# int.Parse(Eval("STATUS")==null?"0":Eval("STATUS").ToString()) %>' Width="180px"></dx:ASPxProgressBar>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataTextColumn FieldName="EMAIL" VisibleIndex="3" Width="280px">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="PAYLOCITY_ID" VisibleIndex="4" Caption="PAYLOCITY ID" Width="120px">
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="NOTES" VisibleIndex="5" Caption="NOTES" Width="200px">
                            </dx:GridViewDataTextColumn>  
                           
                         <%--   <dx:GridViewDataColumn Caption="STATUS" VisibleIndex="10"   Width="120px">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxLabel runat="server" ID="lbl_s" Text='<%# Eval("STATUS") == null || string.IsNullOrEmpty(Eval("STATUS").ToString())? "Active": Eval("STATUS").ToString()=="Active"? "Active": "Inactive"%>' />
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>--%>
                         
                            <dx:GridViewDataColumn Caption="VIEW" VisibleIndex="10" Width="120px">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxButton runat="server" ID="btn_edit" Text="DETAIL" Theme="Mulberry" CommandName="Edit" CommandArgument='<%# Eval("ID") %>'></dx:ASPxButton>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>

                        </Columns>
                    </dx:ASPxGridView>  
                    
                <div style="width: 100%; margin-top: 30px"></div>
                <div class="headerPane" style="width: 100%;text-align:center">
                    <h6 class="text-primary" style="font-weight: bold">BROKER ANALYSIS</h6>
                </div> 
                    
                    <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" Theme="Moderno" Width="100%">
        <TabPages>
            <dx:TabPage Name="ELITE BROKER" Text="ANALYTICAL SUMMARY">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                         
                      <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                                        <Items>
                                            <dx:LayoutGroup Width="40%" Caption="SEARCH" ColCount="2" ShowCaption="False">

                                                <Items>

                                                    <dx:LayoutItem Caption="TOTAL BROKER COUNT" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_count" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="TOTAL COMMISSION AMOUNT($)" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_sum" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="ELITE BROKER COUNT" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_elite" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="ELITE COMMISSION AMOUNT($)" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_elite_sum" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="REGULAR BROKER COUNT" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_regular" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="REGULAR COMMISSION AMOUNT($)" VerticalAlign="Middle">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer>
                                                                <dx:ASPxLabel runat="server" ID="lbl_regular_sum" Theme="Moderno" Font-Bold="True" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:ASPxFormLayout>
                         
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
            <dx:TabPage Name="ELITE BROKER" Text="ELITE BROKER">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                          <dx:WebChartControl ID="WebChartControl2" runat="server" Height="600px" Width="1200px" IndicatorsPaletteName="Chameleon" PaletteName="Civic" ToolTipEnabled="True" CrosshairEnabled="True">
                                        <BorderOptions Color="192, 0, 0" />
                                        <FillStyle FillMode="Gradient">
                                        </FillStyle>
                                        <Legend Name="Default Legend"></Legend>
                                    </dx:WebChartControl>
                        
                         
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
            <dx:TabPage Name="REGULAR BROKER" Text="REGULAR">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                         <dx:WebChartControl ID="WebChartControl1" runat="server" Height="700px" Width="1200px" IndicatorsPaletteName="Chameleon" 
                      PaletteName="Civic" ToolTipEnabled="True" CrosshairEnabled="True">
                                        <BorderOptions Color="192, 0, 0" />
                                        <FillStyle FillMode="Gradient">
                                        </FillStyle>
                                        <Legend Name="Default Legend"></Legend>
                                    </dx:WebChartControl>
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
        </TabPages>
                        
                        
                        

    </dx:ASPxPageControl>




                 <%--   <dx:ASPxDockPanel runat="server" ID="panel1" PanelUID="panel1" VisibleIndex="0" Width="30%"
                        Height="400px" ShowHeader="false" AllowResize="true" OwnerZoneUID="leftZone">
                        <Styles>
                            <Content Border-BorderStyle="Solid" Border-BorderWidth="1px" Border-BorderColor="#BBD7E7"
                                BackColor="#DBEBF4" Paddings-Padding="0">
                            </Content>
                        </Styles>
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <div class="panelNum" style="margin-top: 205px;">
                                    
                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                        <Border BorderStyle="None"></Border>
                    </dx:ASPxDockPanel>
                    <dx:ASPxDockPanel runat="server" ID="panel2" PanelUID="panel2" Width="70%" Height="300px"
                        AllowResize="true" OwnerZoneUID="rightZone" ShowHeader="false" VisibleIndex="0">
                        <Styles>
                            <Content Border-BorderStyle="Solid" Border-BorderWidth="1px" Border-BorderColor="#BBE7BF"
                                BackColor="#DBF4DE" Paddings-Padding="0">
                            </Content>
                        </Styles>
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <div class="panelNum" style="margin-top: 85px;">
                                   
                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                        <Border BorderStyle="None"></Border>
                    </dx:ASPxDockPanel>
                    <dx:ASPxDockPanel runat="server" ID="panel3" PanelUID="panel3" Width="70%" Height="250px"
                        AllowResize="true" OwnerZoneUID="rightZone" ShowHeader="false" VisibleIndex="1">
                        <Styles>
                            <Content Border-BorderStyle="Solid" Border-BorderWidth="1px" Border-BorderColor="#DBCBE9"
                                BackColor="#F3EAFB" Paddings-Padding="0">
                            </Content>
                        </Styles>
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <div class="panelNum" style="margin-top: 57px;">
                                   
                                </div>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                        <Border BorderStyle="None"></Border>
                    </dx:ASPxDockPanel>--%>
    <div style="float: left;">
        <dx:ASPxDockZone runat="server" ID="LeftZone" ZoneUID="leftZone" Width="300px" PanelSpacing="10">
        </dx:ASPxDockZone>
    </div>
    <div style="float: left; margin-left: 10px;">
        <dx:ASPxDockZone runat="server" ID="RightZone" ZoneUID="rightZone" Width="800px"
            PanelSpacing="10">
        </dx:ASPxDockZone>
    </div>
    <dx:ASPxDockManager ID="dockManager" runat="server" FreezeLayout="true"  >
    </dx:ASPxDockManager>

                </div>
                <div class="col-1">
                    
                    
               

                </div>




            </div>
        
</asp:Content>
