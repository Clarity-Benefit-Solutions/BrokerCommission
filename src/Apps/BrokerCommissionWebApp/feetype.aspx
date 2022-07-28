<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="feetype.aspx.cs" Inherits="BrokerCommissionWebApp.feetype" MaintainScrollPositionOnPostback="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-10">
          
            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%;text-align:center">
                <h6 class="text-primary" style="font-weight: bold">MEMO MASTER</h6>
            </div>
             <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%"  Theme="Moderno"  Border="0" >
                        <Items>
                            <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="3" ShowCaption="False">

                                <Items>
                                    <dx:LayoutItem Caption="MEMO" VerticalAlign="Middle"  HorizontalAlign="Left" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxComboBox runat="server" ID="cmb_feetype"  Theme="Moderno" Width="50%"  OnSelectedIndexChanged="cmb_feetype_OnSelectedIndexChanged"
                                                                 AutoPostBack="True"> 
                                                </dx:ASPxComboBox> 
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption=" " VerticalAlign="Middle" ColSpan="2" HorizontalAlign="Right" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <dx:ASPxButton runat="server" ID="btn_new" Theme="Moderno" OnClick="btn_new_OnClick" Text="NEW MEMO" Width="100%"></dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                           
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    
                 
           <dx:ASPxGridView ID="grid_feetype" runat="server" AutoGenerateColumns="False" OnPageIndexChanged="grid_broker_OnPageIndexChanged"
                                     OnRowCommand="grid_broker_OnRowCommand" Theme="Moderno" KeyFieldName="MEMO"
                                     Width="100%">
                        <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                        <Settings   VerticalScrollableHeight="520" VerticalScrollBarMode="Auto" />
                        <SettingsPager PageSize="50" />
                        <Paddings Padding="0px" />
                        <Border BorderWidth="0px" />
                        <BorderBottom BorderWidth="1px" />
                        <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                        <Columns>
                           
                            <dx:GridViewDataTextColumn FieldName="MEMO" VisibleIndex="1" FixedStyle="Left" Width="55%" >
                            </dx:GridViewDataTextColumn>


                            <dx:GridViewDataColumn Caption="COMMISIONABLE?" VisibleIndex="10" Width="20%">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxCheckBox ID="ASPxCheckBox1" Value='<%# Bind("COMMISIONABLE") %>' runat="server" AutoPostBack="True" OnCheckedChanged="ASPxCheckBox1_OnCheckedChanged" ValueType="System.Int32" ValueChecked="1" ValueUnchecked="0">
                                    </dx:ASPxCheckBox>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn Caption="Edit" VisibleIndex="10" Width="15%">
                                <SettingsHeaderFilter>
                                    <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <dx:ASPxButton runat="server" ID="btn_edit" Text="Edit" Theme="Mulberry" CommandName="Edit" CommandArgument='<%# Eval("MEMO") %>'></dx:ASPxButton>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                        </Columns>
                    </dx:ASPxGridView>
           
         
       
            

        </div>
        <div class="col-sm-1"></div>
    </div>
</asp:Content>
