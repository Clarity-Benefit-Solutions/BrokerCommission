<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="statement_edit.aspx.cs" Inherits="BrokerCommissionWebApp.WebForm3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="server">
    <div class="row">
    <div class="col-sm-2"></div>
    <div class="col-sm-8">
      <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
        <Items>
            <dx:LayoutItem Caption="" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               <dx:ASPxButton runat="server" ID="btn_confirm" Text="BACK" OnClick="btn_Back_OnClick" Theme="MaterialCompact" Width="100px"></dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
            <dx:LayoutGroup Width="100%" Caption="BROKER PROFILE" ColCount="2">

                <Items>
                    <dx:LayoutItem Caption="NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_name" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="ITEM">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_item" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="BROKER NAME">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_brokername" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="QUANTITY">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_quantity" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="RATE">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_rate" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="AMOUNT">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_amount" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="COMMISSION AMOUNT">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_commissionamount" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>                    
                    <dx:LayoutItem Caption=" " VerticalAlign="Middle" ColSpan="2" ShowCaption="False" HorizontalAlign="Right">
                      <%--  <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxButton runat="server" ID="btn_confirm" Text="CONFIRM CHANGES" OnClick="btn_confirm_OnClick" Theme="MaterialCompact" Width="100px"></dx:ASPxButton>
                                &nbsp;&nbsp;
                                <dx:ASPxButton runat="server" ID="btn_Back" Text="GO BACK" OnClick="btn_Back_OnClick" Theme="Moderno" Width="100px"></dx:ASPxButton>
                                &nbsp;&nbsp;
                               <dx:ASPxButton runat="server" ID="btn_delete" Text="DELETE CLIENT" OnClick="btn_delete_OnClick" Theme="Mulberry" Width="100px"></dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>--%>
                    </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>
        </Items>
    </dx:ASPxFormLayout>
    </div>
    <div class="col-sm-2"></div>
    </div>
</asp:Content>
