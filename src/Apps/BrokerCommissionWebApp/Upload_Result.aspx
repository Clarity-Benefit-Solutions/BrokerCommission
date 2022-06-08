<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="Upload_Result.aspx.cs" Inherits="BrokerCommissionWebApp.Upload_Result" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
        }

        .menu {
            float: right;
            width: 50%;
        }

        .description {
            float: right;
            width: 48%;
        }

        .wrapper {
            float: left;
            clear: both;
            width: 100%
        }

        .linkMenu {
            background: none !important;
            border: 0 !important;
            color: #162436 !important;
            padding: 0 !important;
            text-decoration: none !important;
        }

            .linkMenu a:hover,
            .linkMenu a:hover * {
                text-decoration: underline !important;
            }

        .linkMenuItem,
        .linkMenuItem > div {
            padding: 0 !important;
            font: 14px Tahoma !important;
        }

        .linkMenuSeparator {
            padding: 0 14px !important;
        }

            .linkMenuSeparator > * {
                background: #5386CB !important;
                margin: 4px 0 !important;
                height: 10px !important;
                width: 1px !important;
            }

        @media (max-width: 576px) {
            .menu {
                float: none;
                width: 100%;
                margin-bottom: 20px;
            }

            .description {
                float: none;
                width: 100% !;
            }
        }
    </style>
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
        <div class="col-lg-1">
        </div>
        <div class="col-lg-10">

            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%; text-align: center">
                <h6 class="text-primary" style="font-weight: bold">UPLOAD RESULT</h6>
            </div>
            <div style="width: 100%; text-align: right; margin-bottom: 20px">&nbsp;&nbsp;
                Show&nbsp;&nbsp;
                <dx:ASPxComboBox ID="cboShowAllOrSome" runat="server" Theme="Moderno"  Width="25%"
                    OnSelectedIndexChanged="cboShowAllOrSome_SelectedIndexChanged" AutoPostBack="True">
                </dx:ASPxComboBox>
                &nbsp;&nbsp;
                <dx:ASPxButton runat="server" ID="ASPxButton1" Text="RECALCULATE" Theme="Moderno"
                    OnClick="btn_refresh_OnClick">
                </dx:ASPxButton>
                &nbsp;&nbsp;
                <dx:ASPxButton runat="server" ID="btn_Approve_Email"
                    Text="EMAIL ALL & ARCHIVE" Theme="Moderno" OnClick="btn_Approve_Email_OnClick">
                </dx:ASPxButton>
            </div>
            <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                <Items>
                    <dx:LayoutGroup Width="40%" Caption="SEARCH" ColCount="2" ShowCaption="False">

                        <Items>

                            <dx:LayoutItem Caption="INVOICE PERIOD" VerticalAlign="Middle" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="lbl_month" Theme="Moderno" Font-Bold="True" />
                                        &nbsp;
                                        <dx:ASPxLabel runat="server" ID="lbl_year" Theme="Moderno" Font-Bold="True" />
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox ID="cmb_broker" runat="server" Theme="Moderno" Width="50%"
                                            OnSelectedIndexChanged="SelectedIndexChanged" AutoPostBack="True">
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
            <div style="float: right; margin-right: 30px; margin-top: 20px; margin-bottom: 20px">

                <dx:ASPxMenu ID="ASPxMenu1" SkinID="None" runat="server"
                    AutoSeparators="RootOnly"
                    CssClass="linkMenu"
                    Font-Size="Larger" Target="_blank"
                    OnItemClick="ASPxMenu1_ItemClick"
                    SeparatorCssClass="linkMenuSeparator">
                    <Items>
                        <dx:MenuItem Text="EXPORT TO EXCEL" Name="Excel" GroupName="Excel" Image-IconID="export_exporttoxls_16x16office2013">
                        </dx:MenuItem>
                        <dx:MenuItem Text="EXPORT TO CSV" Name="CSV" GroupName="CSV" Image-IconID="export_exporttocsv_16x16office2013">
                        </dx:MenuItem>

                    </Items>
                    <ItemStyle CssClass="linkMenuItem" />
                </dx:ASPxMenu>

            </div>
            <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="grid_summary" FileName="Upload_Summary_File"></dx:ASPxGridViewExporter>

            <dx:ASPxLabel ID="lbl_count" runat="server" CssClass="text-primary" Font-Bold="true"></dx:ASPxLabel>
            <dx:ASPxGridView ID="grid_summary" runat="server" ClientInstanceName="ASPxGridView1" Theme="Moderno" OnRowCommand="grid_summary_OnRowCommand" OnPageIndexChanged="grid_summary_OnPageIndexChanged"
                Width="100%" AutoGenerateColumns="True" DataSourceID="SqlDataSource1" KeyFieldName="BROKER_ID">
                <SettingsAdaptivity AdaptivityMode="HideDataCells" />
                <SettingsPager PageSize="150" />
                <Settings ShowFilterRow="False" HorizontalScrollBarMode="Auto" ShowFooter="true"
                    VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" />
                <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                <Columns>
                    <dx:GridViewDataColumn Caption="INDEX" VisibleIndex="0" FixedStyle="Left" Width="10%">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <%# Container.ItemIndex + 1 %>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="BROKER_NAME" VisibleIndex="1" FixedStyle="Left" Width="30%" Caption="BROKER NAME">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PAYLOCITY_ID" VisibleIndex="2" FixedStyle="Left" Width="10%" Caption="PAYLOCITY ID">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="STATEMENT_TOTAL" VisibleIndex="3" Width="20%" Caption="TO PAY ($)">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="STATEMENT_PROCESSED_THIS_PERIOD" VisibleIndex="3" Width="20%" Caption="PAID ($)">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="STATEMENT_PENDING_TOTAL" VisibleIndex="3" Width="20%" Caption="PENDING ($)">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataColumn Caption="VIEW STATEMENT" VisibleIndex="4" Width="20%">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxButton runat="server" ID="btn_edit" Text="STATEMENT" Theme="Moderno"
                                CommandName="statement" CommandArgument='<%# Eval("HEADER_ID") %>'>
                            </dx:ASPxButton>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <%--     <dx:GridViewDataColumn Caption="EMAIL & ARCHIVE" VisibleIndex="2" Width="20%">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxButton runat="server" ID="btn_edit2" Text="EMAIL & ARCHIVE" Theme="Moderno"
                                CommandName="email" CommandArgument='<%# Eval("BROKER_ID") %>'>
                            </dx:ASPxButton>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>--%>
                </Columns>
            </dx:ASPxGridView>
            <div style="height: 30px; width: 100%"></div>
        </div>
        <div class="col-lg-1">
        </div>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:Broker_CommissionConnectionString %>"></asp:SqlDataSource>


</asp:Content>
