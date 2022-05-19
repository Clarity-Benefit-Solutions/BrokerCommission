<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="ViewFile.aspx.cs" Inherits="BrokerCommissionWebApp.ViewFile" %>


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
        <%--<div class="col-1"></div>--%>
        <div class="col-12">
            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%; text-align: center">
                <h6 class="text-primary" style="font-weight: bold">
                    <dx:ASPxLabel runat="server" ID="lblBRoker" Theme="Moderno" />
                </h6>
            </div>

            <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="1" Theme="Moderno" Width="100%" Height="1200">
                <TabPages>
                    <dx:TabPage Name="DESIGN VIEW" Text="DESIGN VIEW">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">

                                <dx:ASPxGridView ID="ASPxGridView1" runat="server" Width="100%" Theme="MaterialCompact" OnPageIndexChanged="ASPxGridView1_PageIndexChanged" OnRowCommand="ASPxGridView1_RowCommand">
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="QB_CLIENT_NAME" ShowInCustomizationForm="True" VisibleIndex="2" Caption="NAME" Width="20%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="QB_FEE" ShowInCustomizationForm="True" VisibleIndex="3" Caption="ITEM" Width="20%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="BROKER_NAME" ShowInCustomizationForm="True" VisibleIndex="4" Caption="BROKER NAME" Width="20%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="QUANTITY" ShowInCustomizationForm="True" VisibleIndex="5" Caption="QUANTITY" Width="10%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="COMMISSION_RATE" ShowInCustomizationForm="True" VisibleIndex="6" Caption="RATE" Width="10%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="SALES_PRICE" ShowInCustomizationForm="True" VisibleIndex="9" Caption="AMOUNT" Width="10%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="TOTAL_PRICE" ShowInCustomizationForm="True" VisibleIndex="10" Caption="COMMISSION AMOUNT" Width="10%" HeaderStyle-HorizontalAlign="Center">
                                        </dx:GridViewDataTextColumn>
                                        <%--      <dx:GridViewDataTextColumn FieldName="START_DATE" ShowInCustomizationForm="True" VisibleIndex="10" Caption="START_DATE" Width="10%">
                                        </dx:GridViewDataTextColumn>--%>
                                        <dx:GridViewDataColumn Caption="Edit" VisibleIndex="10" Width="120px" HeaderStyle-HorizontalAlign="Center">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <%--
                                                    ToDo: How do these buttons work - will they work now that we regerante statements  directly from Imports-OCT
                                                --%>
                                                <dx:ASPxButton runat="server" ID="btn_delete"
                                                    Visible='<%# Eval("STATUS") == null ? true: Eval("STATUS").ToString() == "" ?true:false %>'
                                                    Text="DELETE" Theme="Mulberry" CommandName="delete"
                                                    CommandArgument='<%# Eval("INVOICE_NUM") %>'>
                                                </dx:ASPxButton>


                                                <dx:ASPxButton runat="server" ID="ASPxButton1"
                                                    Visible='<%# Eval("STATUS") == null ? false: Eval("STATUS").ToString() == "" ?false:true %>'
                                                    Text="DELETE" Theme="Mulberry" CommandName="delete_client"
                                                    CommandArgument='<%# Eval("OPEN_BALANCE") %>'>
                                                </dx:ASPxButton>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns>

                                </dx:ASPxGridView>
                                <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                                    <Items>
                                        <dx:LayoutGroup Width="100%" Caption="ADD STATEMENT LINE" ColCount="3" ShowCaption="False">

                                            <Items>

                                                <dx:LayoutItem Caption="CLIENT NAME" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_name" runat="server" Width="100%" Theme="Mulberry">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>

                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="ITEM" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_item" runat="server" Width="100%" Theme="Mulberry">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>

                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="QUANTITY" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_qt" runat="server" Width="100%" Theme="Mulberry">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>
                                                                <MaskSettings Mask="<0..9999>" />
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="SALES PRICE" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_sales" runat="server" Width="100%" Theme="Mulberry">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>
                                                                <MaskSettings Mask="<0..999999>.<0..99>" />
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="RATE" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_commissionrate" runat="server" Width="100%" Theme="Mulberry">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>
                                                            </dx:ASPxTextBox>

                                                            <%--<MaskSettings Mask="<0..0>.<0..99>" />--%>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="COMMISION AMOUNT($)" VerticalAlign="Middle">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxTextBox ID="txt_commission_amount" runat="server" Width="100%" Theme="Mulberry" ClientInstanceName="txtWCNSerialFrom">
                                                                <ValidationSettings RequiredField-IsRequired="true" RegularExpression-ErrorText="This Field IS Required" ValidationGroup="al"
                                                                    ErrorFrameStyle-ForeColor="Red">
                                                                </ValidationSettings>
                                                                <MaskSettings Mask="<0..999999>.<0..99>" />
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                <dx:LayoutItem ShowCaption="False" VerticalAlign="Middle" ColSpan="3" HorizontalAlign="Right">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer>
                                                            <dx:ASPxButton runat="server" ID="btn_addNew" Text="ADD NEW LINE" Theme="MaterialCompact" OnClick="btn_addNew_Click" ValidationGroup="al"></dx:ASPxButton>

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
                    <dx:TabPage Name="STATEMENT VIEW" Text="STATEMENT VIEW">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div style="width: 100%; text-align: center; margin-top: 80px">
                                    <%--    <dx:ASPxButton runat="server" ID="ASPxButton2" Text="REFRESH" Theme="Moderno" OnClick="ASPxButton2_Click"></dx:ASPxButton>
                                    &nbsp;&nbsp;--%>
                                    <dx:ASPxButton runat="server" ID="btn_view_statement" Text="VIEW/DOWNLOAD STATEMENT" Theme="Moderno"
                                        OnClick="btn_view_statement_OnClick">
                                    </dx:ASPxButton>
                                </div>

                                <%--    <dx:ASPxImage ID="ASPxImage1" runat="server" ShowLoadingImage="true" Height="600" Width="600"  ></dx:ASPxImage>
                                --%>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Name="RAW DATA" Text="QUICKBOOKS RAW DATA">
                        <ContentCollection>
                            <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                                <div style="width: 100%; text-align: right; margin-bottom: 20px">
                                    <dx:ASPxButton runat="server" ID="ASPxButton3" Text="SAVE CHANGES" Theme="Moderno" OnClick="btn_save_OnClick">
                                    </dx:ASPxButton>
                                </div>

                                <dx:ASPxGridView ID="grid_import" runat="server" AutoGenerateColumns="False"
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
                                        <dx:GridViewDataColumn Caption="STATEMENT" VisibleIndex="0" Width="12%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxCheckBox ID="cb" runat="server" Theme="Moderno" Checked='<%#Eval("exist") %>' Enabled='<%# Convert.ToBoolean( Eval("exist")) == true?false:true %>'></dx:ASPxCheckBox>
                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="NO#" VisibleIndex="0" Width="8%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <asp:HiddenField runat="server" ID="hid_id" Value='<%# Eval("broker_id") %>' />
                                                <asp:HiddenField runat="server" ID="hid_clientID" Value='<%# Eval("broker_id") %>' />
                                                <%# Container.ItemIndex + 1 %>
                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="CLIENT NAME" VisibleIndex="1"
                                            Width="30%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_qb_clientName" Text='<%# Eval("Name") %>' Theme="Moderno" />


                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="MEMO" VisibleIndex="2"
                                            Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_QB_FEE" Text='<%# Eval("Memo") %>' Theme="Moderno" />

                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="AGENT" VisibleIndex="2"
                                            Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_agent" Text='<%# Eval("Agent") %>' Theme="Moderno" />

                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="QT" VisibleIndex="2"
                                            Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_qt" Text='<%# Eval("Qty") %>' Theme="Moderno" />

                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="SALES PRIE($)" VisibleIndex="2"
                                            Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_sp" Text='<%# Eval("Sales_Price") %>' Theme="Moderno" />

                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="AMOUNT($)" VisibleIndex="2"
                                            Width="12%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxLabel runat="server" ID="lbl_amount" Text='<%# Eval("Amount") %>' Theme="Moderno" />

                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="COMMISSION RATE ($)" VisibleIndex="4"
                                            Width="16%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <%--<dx:ASPxLabel runat="server" ID="lbl_FEE_MEMO" Text='<%# Eval("COMMISSION_RATE") %>' Theme="Moderno"/>  --%>
                                                <dx:ASPxTextBox ID="txt_rate" runat="server" Width="100%" Theme="Moderno" Text='<%# Eval("COMMISSION_RATE") %>'>
                                                    <MaskSettings Mask="<0..99999g>.<00..99>" ErrorText="Please input missing digits" />
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" ErrorTextPosition="Bottom" />
                                                </dx:ASPxTextBox>
                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="UNIT" VisibleIndex="5"
                                            Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <%--<dx:ASPxLabel runat="server" ID="lbl_UNIT" Text='<%# Eval("UNIT") %>' Theme="Moderno"/>--%>
                                                <dx:ASPxComboBox ID="txt_UNIT" runat="server" Theme="Moderno" Width="100%" Text='<%# Eval("UNIT") %>'>
                                                    <Items>
                                                        <dx:ListEditItem Value="0" Text="Per Qt" />
                                                        <dx:ListEditItem Value="1" Text="Per Amount" />
                                                        <dx:ListEditItem Value="2" Text="Flat Rate" />
                                                    </Items>
                                                    <ClearButton DisplayMode="Never" ToolTip="Please Select a Unite">
                                                    </ClearButton>
                                                </dx:ASPxComboBox>
                                            </DataItemTemplate>

                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>

                                            <CellStyle HorizontalAlign="Left"></CellStyle>
                                        </dx:GridViewDataColumn>
                                        <%-- <dx:GridViewDataColumn Caption="BILLING START" VisibleIndex="6"
                                            Width="20%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                            HeaderStyle-Font-Bold="true">
                                            <SettingsHeaderFilter>
                                                <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                            </SettingsHeaderFilter>
                                            <DataItemTemplate>
                                                <dx:ASPxDateEdit runat="server" ID="de_start" Theme="Moderno" Date='<%# Eval("START_DATE") == null ? null : Convert.ToDateTime(Eval("START_DATE").ToString()) %>' ></dx:ASPxDateEdit>
                                                 
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>--%>
                                    </Columns>
                                </dx:ASPxGridView>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                </TabPages>
            </dx:ASPxPageControl>
        </div>
        <%--  <div class="col-1"></div>--%>
    </div>




</asp:Content>
