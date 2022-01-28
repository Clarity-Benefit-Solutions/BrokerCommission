<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="RawDataUpload.aspx.cs" Inherits="Broker_Commission.RawDataUpload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
      <script type="text/javascript">
        function popupwindow(url, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            return window.open(url, title, 'toolbar=no, location=no, directories=no, status=no,      menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        }
    </script>
<%--    <dx:ASPxGridView ID="gridview" runat="server">

    </dx:ASPxGridView>--%>
     
    <div class="row">
        <div class="col-1">
                    
                    
               

        </div>
        <div class="col-10">
            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%;text-align:center">
                <h6 class="text-primary" style="font-weight: bold">NEW QUICKBOOKS UPLOAD</h6>
            </div>
            <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
            <Items>
                <dx:LayoutGroup Width="100%" Caption="QUICKBOOKS FILES" ColCount="2">
                 
                    <Items>
                      
                      
                        

                        <dx:LayoutItem Caption="FILE UPLOAD" VerticalAlign="Middle"> 
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <asp:FileUpload runat="server" ID="upload_Excel" AllowMultiple="False"  />
                                    <asp:RegularExpressionValidator ID="regexValidator" runat="server"
                                        ControlToValidate="upload_Excel"
                                        ErrorMessage="Only csv files are allowed"
                                        ValidationExpression="(.*\.([cC][sS][vV])$)">
                                    </asp:RegularExpressionValidator>
                              <asp:Label ID="lbl_error" runat="server" CssClass="txt-danger"></asp:Label>
                                
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="USER EMAIL" VerticalAlign="Middle">
                           
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxTextBox runat="server" ID="ASPxTextBox1" Theme="Moderno" Width="100%" >
                                        <ValidationSettings SetFocusOnError="true">
                                            <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="SATEMENT MONTH" VerticalAlign="Middle">
                           
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxComboBox runat="server" ID="cmb_month" Theme="Moderno"  Width="100%" >
                                        <ValidationSettings SetFocusOnError="true">
                                            <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxComboBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="STATEMENT YEAR" VerticalAlign="Middle">
                           
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                    <dx:ASPxComboBox runat="server" ID="cmb_Year" Theme="Moderno"  Width="100%" >
                                        <ValidationSettings SetFocusOnError="true">
                                            <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                    </dx:ASPxComboBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem ShowCaption="False" HorizontalAlign="Right" VerticalAlign="Middle" Paddings-PaddingTop="20px" CssClass="lastItem" ColSpan="2">
                            
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer>
                                   
                                    <dx:ASPxButton runat="server" ID="btn_process_paymentfile" Text="PROCESS RAW DATA"
                                        OnClick="btn_process_paymentfile_OnClick" Theme="Moderno" ></dx:ASPxButton>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                    </Items>
                </dx:LayoutGroup>
            </Items>
        </dx:ASPxFormLayout> 
        </div>
    <div class="col-lg-1"></div>
    </div>
</asp:Content>
