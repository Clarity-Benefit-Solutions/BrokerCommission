<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="broker_group.aspx.cs" Inherits="Broker_Commission.broker_group" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col-lg-1"></div>
        <div class="col-lg-10">
            <dx:ASPxGridView ID="ASPxGridView1" runat="server"   Theme="Moderno" 
                             Width="100%">
                <SettingsAdaptivity AdaptivityMode="HideDataCells" />
                <SettingsPager PageSize="50" />
                <Paddings Padding="0px" />
                <Border BorderWidth="0px" />
                <BorderBottom BorderWidth="1px" />
                <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                <%-- <Columns>
                    <dx:GridViewDataColumn>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn>
                    </dx:GridViewDataColumn>
                </Columns>--%>
            </dx:ASPxGridView>

        </div>
        <div class="col-lg-1"></div>
    </div>
    

</asp:Content>
