<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="feetype_add.aspx.cs" Inherits="BrokerCommissionWebApp.feetype_add" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
    <div class="col-sm-2"></div>
    <div class="col-sm-8">
      <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
        <Items>
            <dx:LayoutGroup Width="100%" Caption="MEMO PROFILE" ColCount="2">

                <Items>
                    <dx:LayoutItem Caption="MEMO ID" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxLabel runat="server" ID="lbl_no"/>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    <dx:LayoutItem Caption="MEMO NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_name" Width="100%"></dx:ASPxTextBox> 
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem> 
                    
                    <dx:LayoutItem Caption="COMMISSIONABLE?" VerticalAlign="Middle" HorizontalAlign="Left" ColSpan="2" >
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               <dx:ASPxCheckBox runat="server" ID="cb_commission" ></dx:ASPxCheckBox>
                               
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                   
                    <dx:LayoutItem Caption="NOTES" VerticalAlign="Middle" HorizontalAlign="Left" ColSpan="2" >
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                               <dx:ASPxMemo runat="server" ID="memo_note" Theme="Mulberry" Width="100%" Rows="5"></dx:ASPxMemo>
                               
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    
                    <dx:LayoutItem Caption=" " VerticalAlign="Middle" ColSpan="2" ShowCaption="False" HorizontalAlign="Right">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxButton runat="server" ID="btn_confirm" Text="SAVE CHANGES" OnClick="btn_confirm_OnClick" Theme="MaterialCompact" Width="100px"></dx:ASPxButton>
                                &nbsp;&nbsp;
                                <dx:ASPxButton runat="server" ID="btn_Back" Text="GO BACK" OnClick="btn_Back_OnClick" Theme="Moderno" Width="100px"></dx:ASPxButton>
                                &nbsp;&nbsp;
                                <dx:ASPxButton runat="server" ID="btn_delete" Text="DELETE MEMO" OnClick="btn_delete_OnClick" Theme="Mulberry" Width="100px"></dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>
        </Items>
    </dx:ASPxFormLayout>
    </div>
    <div class="col-sm-2"></div>
    </div>

</asp:Content>
