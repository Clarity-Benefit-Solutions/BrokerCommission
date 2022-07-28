<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="client.aspx.cs" Inherits="BrokerCommissionWebApp.client" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-10">
            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%; text-align: center">
                <h6 class="text-primary" style="font-weight: bold">Client MASTER</h6>
            </div>
            <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" Theme="Moderno" Paddings="0">
                <Items>
                    <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="3" ShowCaption="False">

                        <Items>
                            <dx:LayoutItem Caption="Client" VerticalAlign="Middle" HorizontalAlign="Left">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cmb_client" Theme="Moderno" OnSelectedIndexChanged="cmb_client_OnSelectedIndexChanged" Width="50%"
                                            AutoPostBack="True">
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption=" " VerticalAlign="Middle" ColSpan="2" HorizontalAlign="Right" ShowCaption="False">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxButton runat="server" ID="btn_new" Theme="Moderno" OnClick="btn_new_OnClick" Text="NEW Client" Width="100%"></dx:ASPxButton>

                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
            <dx:ASPxGridView ID="grid_client" runat="server" AutoGenerateColumns="False" OnPageIndexChanged="grid_client_OnPageIndexChanged"
                OnRowCommand="grid_client_OnRowCommand" Theme="Moderno" KeyFieldName="ID"
                Width="100%">
                <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="520" VerticalScrollBarMode="Auto" />
                <SettingsPager PageSize="50" />
                <Paddings Padding="0px" />
                <Border BorderWidth="0px" />
                <BorderBottom BorderWidth="1px" />
                <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="CLIENT_ID" VisibleIndex="0" FixedStyle="Left" Caption="Client ID" Width="5%">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="CLIENT_NAME" VisibleIndex="1" FixedStyle="Left" Width="40%" Caption="Client NAME">
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataColumn Caption="STATUS" VisibleIndex="4" Width="10%">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxLabel runat="server" ID="lbl_s" Text='<%# Eval("STATUS") == null? "Active": Eval("STATUS").ToString()=="ACTIVE"? "Active": "Inactive"%>' />
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn Caption="EDIT" VisibleIndex="10" Width="10%">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxButton runat="server" ID="btn_edit" Text="Edit" Theme="Mulberry" CommandName="Edit" CommandArgument='<%# Eval("CLIENT_ID") %>'></dx:ASPxButton>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                </Columns>
            </dx:ASPxGridView>

        </div>
        <div class="col-sm-1"></div>
    </div>


    <%--  --%>
            

       <%-- </div>
        <div class="col-sm-1"></div>
    </div>--%>
</asp:Content>
