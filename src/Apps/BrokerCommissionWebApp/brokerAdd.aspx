<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="brokerAdd.aspx.cs" Inherits="BrokerCommissionWebApp.brokerAdd" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Mulberry">
        <Items>
            <dx:LayoutGroup Width="100%" Caption="BROKER PROFILE" ColCount="3">
                <Items>
                    <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_name" Width="100%" Theme="Moderno">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="QB BROKER NAME" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_qb_name" Width="100%" Theme="Moderno">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="ELITE BROKER" VerticalAlign="Middle" HorizontalAlign="Left">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxCheckBox runat="server" ID="cb_premium" Theme="Moderno">
                                </dx:ASPxCheckBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="PRIMARY EMAIL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_email" Width="100%" Theme="Moderno">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="SECONDARY EMAIL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_sec_email" Width="100%" Theme="Moderno">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="STATUS" VerticalAlign="Middle" HorizontalAlign="Left">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxComboBox runat="server" ID="cmb_status" Theme="Moderno">
                                    <Items>
                                        <dx:ListEditItem Text="Active" Value="0" Selected="True" />
                                        <dx:ListEditItem Text="Inactive" Value="1" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="PAYLOCITY ID" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox runat="server" ID="txt_paylicity" Width="100%" Theme="Moderno">
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="ELITE LEVEL" VerticalAlign="Middle">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxTextBox ID="txt_rate" runat="server" Width="100%" Theme="Moderno">
                                    <MaskSettings Mask="<0..99999g>.<00..99>" ErrorText="Please input missing digits" />
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" ErrorTextPosition="Bottom" />
                                </dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="NOTES" VerticalAlign="Middle" ColSpan="3">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxMemo runat="server" ID="txt_body" Width="100%" Rows="5">
                                </dx:ASPxMemo>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>
        </Items>
    </dx:ASPxFormLayout>
    <dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" Theme="Moderno" Width="100%">
        <TabPages>
            <dx:TabPage Name="QUICKBOOS SETTINS" Text="QUICKBOOS SETTINS">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                        <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                            <Items>
                                <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="2" ShowCaption="False">
                                    <Items>
                                        <dx:LayoutItem Caption="OTHER QB BROKER NAME #1" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox runat="server" ID="txt_qn_name_1" Width="100%" Theme="Moderno">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="OTHER QB BROKER NAME #2" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox runat="server" ID="txt_qn_name_2" Width="100%" Theme="Moderno">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="OTHER QB BROKER NAME #3" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox runat="server" ID="txt_qn_name_3" Width="100%" Theme="Moderno">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="OTHER QB BROKER NAME #4" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox runat="server" ID="txt_qn_name_4" Width="100%" Theme="Moderno">
                                                    </dx:ASPxTextBox>
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
            <dx:TabPage Name="CLIENTS DETAILS" Text="CLIENTS DETAILS">
                <ContentCollection>
                    <dx:ContentControl runat="server" SupportsDisabledAttribute="True">
                        <dx:ASPxGridView ID="grid_client" runat="server" AutoGenerateColumns="False" OnRowCommand="grid_client_OnRowCommand"
                            Theme="Moderno" KeyFieldName="CLIENT_ID"
                            Width="100%">
                            <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="500" VerticalScrollBarMode="Auto" />
                            <SettingsPager PageSize="100" />
                            <Paddings Padding="0px" />
                            <Border BorderWidth="0px" />
                            <BorderBottom BorderWidth="1px" />
                            <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                            <Columns>
                                <dx:GridViewDataColumn Caption="NO#" VisibleIndex="0" Width="8%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <asp:HiddenField runat="server" ID="hid_id" Value='<%# Eval("CLIENT_ID") %>' />
                                        <%# Container.ItemIndex + 1 %>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="QB CLIENT NAME" VisibleIndex="1"
                                    Width="30%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel runat="server" ID="lbl_qb_clientName" Text='<%# Eval("QB_CLIENT_NAME") %>' Theme="Moderno"/>

                                       <%-- <dx:ASPxComboBox ID="cmb_clientName" runat="server" Value='<%# Bind("QB_CLIENT_NAME") %>' Width="100%" Theme="Moderno"
                                            OnInit="CLIENT_NAME_Init">
                                            <ClearButton DisplayMode="Never" ToolTip="Please Select a Client">
                                            </ClearButton>
                                        </dx:ASPxComboBox>--%>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="QB MEMO" VisibleIndex="2"
                                    Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel runat="server" ID="lbl_QB_FEE" Text='<%# Eval("QB_FEE") %>' Theme="Moderno"/>
                                      <%--  <dx:ASPxComboBox ID="cmb_QB_FEE" runat="server" Value='<%# Bind("QB_FEE") %>' Width="100%" Theme="Moderno"
                                            OnInit="MEMO_Init">
                                            <ClearButton DisplayMode="Never" ToolTip="Please Select a QUICKBOOK Memo">
                                            </ClearButton>
                                        </dx:ASPxComboBox>--%>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="STATEMENT MEMO" VisibleIndex="3"
                                    Width="15%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel runat="server" ID="lbl_FEE_MEMO" Text='<%# Eval("FEE_MEMO") %>' Theme="Moderno"/>
                                       <%-- <dx:ASPxComboBox ID="cmb_FEE_MEMO" runat="server" Value='<%# Bind("FEE_MEMO") %>' Width="100%" Theme="Moderno"
                                            OnInit="sMEMO_Init">
                                            <ClearButton DisplayMode="Never" ToolTip="Please Select a STATEMENT Memo">
                                            </ClearButton>
                                        </dx:ASPxComboBox>--%>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="COMMISSION RATE ($)" VisibleIndex="4"
                                    Width="20%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel runat="server" ID="lbl_commission_rate" Text='<%# Eval("COMMISSION_RATE") %>' Theme="Moderno"/>
                                      <%--  <dx:ASPxTextBox ID="txt_rate" runat="server" Width="100%" Theme="Moderno" Text='<%# Eval("COMMISSION_RATE") %>'>
                                            <MaskSettings Mask="<0..99999g>.<00..99>" ErrorText="Please input missing digits" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" ErrorTextPosition="Bottom" />
                                        </dx:ASPxTextBox>--%>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="UNIT" VisibleIndex="5"
                                    Width="10%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxLabel runat="server" ID="lbl_UNIT" Text='<%# Eval("UNIT") %>' Theme="Moderno"/>
                                      <%--  <dx:ASPxComboBox ID="txt_UNIT" runat="server" Theme="Moderno" Value='<%# Bind("UNIT") %>' Width="100%">
                                            <Items>
                                                <dx:ListEditItem Value="0" Text="Per Qt" />
                                                <dx:ListEditItem Value="1" Text="Per Amount" />
                                                <dx:ListEditItem Value="2" Text="Flat Rate" />
                                            </Items>
                                            <ClearButton DisplayMode="Never" ToolTip="Please Select a Unite">
                                            </ClearButton>
                                        </dx:ASPxComboBox>--%>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="BILLING START" VisibleIndex="6"
                                    Width="20%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <%--<dx:ASPxDateEdit runat="server" ID="de_start" Theme="Moderno" Date='<%# Eval("START_DATE") == null? Convert.ToDateTime("01/01/2099") : string.IsNullOrEmpty(Eval("START_DATE").ToString())?Convert.ToDateTime("01/01/2099") :Convert.ToDateTime(Eval("START_DATE").ToString()) %>'></dx:ASPxDateEdit>--%>
                                           <dx:ASPxLabel runat="server" ID="lbl_StartDate" Text='<%# Eval("START_DATE") == null ? "N/A" : Eval("START_DATE") %>' Theme="Moderno"/>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn Caption="EDIT" VisibleIndex="7"
                                    Width="20%" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Left"
                                    HeaderStyle-Font-Bold="true">
                                    <SettingsHeaderFilter>
                                        <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                                    </SettingsHeaderFilter>
                                    <DataItemTemplate>
                                        <dx:ASPxButton runat="server" ID="btn_edit" Text="DELETE" Theme="Moderno"
                                            CommandName="DELETE" CommandArgument='<%#Eval("CLIENT_ID") %>'>
                                        </dx:ASPxButton>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                            </Columns>
                        </dx:ASPxGridView>
                        <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout2" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                            <Items>
                                <dx:LayoutGroup Width="100%" ColCount="3" ShowCaption="False">
                                    <Items>
                                        <dx:LayoutItem Caption="QB CLIENT NAME" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cmb_qb_client" Theme="Moderno" Width="100%">
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="QB MEMO" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cmb_qb_memo" Theme="Moderno" Width="100%">
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="STATEMENT MEMO" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cmb_st_memo" Theme="Moderno" Width="100%">
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="COMMISSION RATE ($)" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="txt_cm_rate" runat="server" Width="100%" Theme="Moderno">
                                                        <MaskSettings Mask="<0..99999g>.<00..99>" ErrorText="Please input missing digits" />
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic" ErrorTextPosition="Bottom" />
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="UNIT" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cmb_unit" Theme="Moderno" Width="100%">
                                                        <Items>
                                                            <dx:ListEditItem Text="Per Qt" Value="0" Selected="True" />
                                                            <dx:ListEditItem Text="Per Amount" Value="1" />
                                                            <dx:ListEditItem Text="Flat Rate" Value="2" />
                                                            <%----%>
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="BILLING START DATE" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxDateEdit runat="server" ID="de_start_date" Theme="Moderno" DisplayFormatString="MM/dd/yyyy" Width="100%"></dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption=" " VerticalAlign="Middle" ShowCaption="False" ColSpan="3" HorizontalAlign="Right">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxButton runat="server" ID="btn_add_client" Text="SAVE CLIENTS" Theme="MaterialCompact" Width="100px" OnClick="btn_add_client_OnClick">
                                                    </dx:ASPxButton>
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
        </TabPages>
    </dx:ASPxPageControl>
    <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout3" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
        <Items>
            <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="4" ShowCaption="False">
                <Items>
                    <dx:LayoutItem Caption=" " VerticalAlign="Middle" ColSpan="3" ShowCaption="False" HorizontalAlign="Right">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer>
                                <dx:ASPxButton runat="server" ID="btn_confirm" Text="CONFIRM CHANGES" OnClick="btn_confirm_OnClick" Theme="MaterialCompact" Width="100px">
                                </dx:ASPxButton>
                                &nbsp;&nbsp;
                                <dx:ASPxButton runat="server" ID="btn_Back" Text="GO BACK" OnClick="btn_Back_OnClick" Theme="Moderno" Width="100px">
                                </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:LayoutGroup>
        </Items>
    </dx:ASPxFormLayout>


    <%--<asp:SqlDataSource ID="D_clint" runat="server" ConnectionString="<%$ ConnectionStrings:Broker_CommissionConnectionString %>" SelectCommand="SELECT DISTINCT [CLIENT_NAME] FROM [CLIENT_] ORDER BY [CLIENT_NAME]"></asp:SqlDataSource>

    <asp:SqlDataSource ID="D_memo" runat="server" ConnectionString="<%$ ConnectionStrings:Broker_CommissionConnectionString %>" SelectCommand="SELECT DISTINCT [MEMO] FROM [dbo].[FEE_MEMO] ORDER BY [MEMO]"></asp:SqlDataSource>--%>
</asp:Content>
