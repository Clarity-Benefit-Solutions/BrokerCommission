<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="BROKER_VIEW.aspx.cs" Inherits="BrokerCommissionWebApp.BROKER_VIEW" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
<dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
        <Items>
            <dx:LayoutGroup Width="100%" Caption="BROKER PROFILE" ColCount="3">

                <Items>
                    <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle" HorizontalAlign="Right" ShowCaption="False" ColSpan="3">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               
                                <dx:ASPxButton runat="server" ID="btn_back" Text="GO BACK" Theme="Moderno" OnClick="btn_back_OnClick">
                                                                     
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               
                                <dx:ASPxLabel runat="server" ID="txt_name"  Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="QB BROKER NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                
                                <dx:ASPxLabel runat="server" ID="txt_qb_name"  Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="BROKER STATUS" VerticalAlign="Middle" HorizontalAlign="Left">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                              
                                <dx:ASPxLabel runat="server" ID="cb_premium"  Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="PRIMARY EMAIL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               
                                <dx:ASPxLabel runat="server" ID="txt_email" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="SECONDARY EMAIL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                              
                                <dx:ASPxLabel runat="server" ID="txt_sec_email" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="STATUS" VerticalAlign="Middle" HorizontalAlign="Left">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                 
                                <dx:ASPxLabel runat="server" ID="cmb_status" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>


                  
                    <dx:LayoutItem Caption="PAYLOCITY ID" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                
                                <dx:ASPxLabel runat="server" ID="txt_paylicity" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                 <%--   <dx:LayoutItem Caption="ELITE LEVEL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               
                              <dx:ASPxLabel runat="server" ID="txt_rate" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>--%>

                    <dx:LayoutItem Caption="NOTES" VerticalAlign="Middle" ColSpan="3">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                
                                <dx:ASPxLabel runat="server" ID="txt_body" Width="100%" Theme="Moderno" />
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>

                   
                </Items>
            </dx:LayoutGroup>
        </Items>
    </dx:ASPxFormLayout>
    <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" Theme="Moderno" Width="100%">
        <TabPages>
          
            <dx:TabPage Name="CLIENTS DETAILS" Text="CLIENTS DETAILS">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                        <dx:ASPxGridView ID="grid_client" runat="server" AutoGenerateColumns="False"
                            Theme="Moderno" KeyFieldName="ID"
                            Width="100%">
                            <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="500" VerticalScrollBarMode="Auto" />
                            <SettingsPager PageSize="100" />
                            <Paddings Padding="0px" />
                            <Border BorderWidth="0px" />
                            <BorderBottom BorderWidth="1px" />
                            <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                            <Columns>

                                <dx:GridViewDataTextColumn FieldName="QB_CLIENT_NAME" VisibleIndex="1" FixedStyle="Left" Caption="QB CLIENT NAME" Width="35%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="QB_FEE" VisibleIndex="2" FixedStyle="Left" Caption="QB MEMO" Width="15%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="FEE_MEMO" VisibleIndex="3" FixedStyle="Left" Caption="STATEMENT MEMO" Width="25%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="COMMISSION_RATE" VisibleIndex="4" FixedStyle="Left" Caption="COMMISSION RATE ($)" Width="25%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="UNIT" VisibleIndex="5" FixedStyle="Left" Caption="UNIT" Width="15%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="START_DATE" VisibleIndex="6" FixedStyle="Left" Caption="BILLING START" Width="15%">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>

                         
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
            <dx:TabPage Name="STATEMENT HISTORY" Text="STATEMENT HISTORY">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                         <dx:ASPxGridView ID="grid_history" runat="server" AutoGenerateColumns="False" OnRowCommand="grid_history_OnRowCommand"
                            Theme="Moderno" KeyFieldName="HEADER_ID"
                            Width="100%">
                            <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" /> [][][][PERIOD]--%>
                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="500" VerticalScrollBarMode="Auto" />
                            <SettingsPager PageSize="100" />
                            <Paddings Padding="0px" />
                            <Border BorderWidth="0px" />
                            <BorderBottom BorderWidth="1px" />
                            <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                            <Columns>
                                 <dx:GridViewDataTextColumn FieldName="YEAR" VisibleIndex="1" FixedStyle="Left" Caption="STATEMENT YEAR" Width="15%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="MONTH" VisibleIndex="1" FixedStyle="Left" Caption="STATEMENT MONTH" Width="15%">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="BROKER_NAME" VisibleIndex="2" FixedStyle="Left" Caption="BROKER_NAME" Width="25%">
                                </dx:GridViewDataTextColumn>
                              <%--  <dx:GridViewDataTextColumn FieldName="PAYLOCITY_NUMBER" VisibleIndex="3" FixedStyle="Left" Caption="PAYLOCITY_NUMBER" Width="10%">
                                </dx:GridViewDataTextColumn>--%>
                                <dx:GridViewDataTextColumn FieldName="STATEMENT_TOTAL" VisibleIndex="4" FixedStyle="Left" Caption="STATEMENT TOTLA ($)" Width="15%">
                                </dx:GridViewDataTextColumn>
                                  <dx:GridViewDataColumn Caption="UPDATE" VisibleIndex="5"  Width="25%">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel ID="updatelbl" runat="server" Text='<%# Eval("Change_Date")==null?"N/A" : Convert.ToDateTime(Eval("Change_Date").ToString()).ToString("MM/dd/yyyy") %>'></dx:ASPxLabel>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="STATEMENT" VisibleIndex="5"  Width="25%">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxButton runat="server" ID="btn_edit" Text="VIEW" Theme="Mulberry" CommandName="statement" CommandArgument='<%# Eval("HEADER_ID") %>'></dx:ASPxButton>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                            </Columns>
                        </dx:ASPxGridView>
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
        </TabPages>
    </dx:ASPxPageControl>
    
</asp:Content>
