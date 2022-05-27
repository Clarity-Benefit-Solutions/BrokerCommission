<%@ Page Title="" Language="C#" MasterPageFile="~/Main.master" AutoEventWireup="true" CodeBehind="brokerMaster.aspx.cs" Inherits="BrokerCommissionWebApp.brokerMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function popupwindow(url, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            return window.open(url, title, 'toolbar=no, location=no, directories=no, status=no,      menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        }
    </script>

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


    <div class="row">
<%--        <div class="col-1">
        </div>--%>
        <div class="col-10" style="margin-left:60px;">
            <div style="width: 100%; margin-top: 30px"></div>
            <div class="headerPane" style="width: 100%; text-align: center">
                <h6 class="text-primary" style="font-weight: bold">BROKER MASTER</h6>
            </div>

            <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout" Width="100%" ClientInstanceName="FormLayout" Theme="Moderno">
                <Items>
                    <dx:LayoutGroup Width="100%" Caption="SEARCH" ColCount="3" ShowCaption="False">

                        <Items>

                            <dx:LayoutItem Caption="BROKER NAME" VerticalAlign="Middle">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cmb_broker" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                            AutoPostBack="True">
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="QB BROKER NAME" VerticalAlign="Middle">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cmb_qb_broker" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                            AutoPostBack="True">
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="BROKER STATUS" VerticalAlign="Middle">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cmb_status" Theme="Moderno" Width="100%" OnSelectedIndexChanged="cmb_broker_OnSelectedIndexChanged"
                                            AutoPostBack="True">
                                            <Items>
                                                <dx:ListEditItem Text="ALL BROKER" Value="0" Selected="True" />
                                                <dx:ListEditItem Text="ELITE BROKER" Value="1" />
                                                <dx:ListEditItem Text="REGULAR BROKER" Value="2" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                         <%--   <dx:LayoutItem VerticalAlign="Bottom" HorizontalAlign="Right" ColSpan="3" ShowCaption="False">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxButton runat="server" ID="btn_add" Text="NEW BROKER" OnClick="btn_add_OnClick" Theme="Moderno"></dx:ASPxButton>

                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>--%>

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
                          <dx:MenuItem Text="NEW BROKER" Name="New" GroupName="New" Image-IconID="actions_add_16x16office2013">
                        </dx:MenuItem>
                    </Items>
                    <ItemStyle CssClass="linkMenuItem" />
                </dx:ASPxMenu>

            </div>
            <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="grid_broker" FileName="Broker_Master_File"></dx:ASPxGridViewExporter>
            <dx:ASPxGridView ID="grid_broker" runat="server" AutoGenerateColumns="False" OnPageIndexChanged="ASPxGridView1_OnPageIndexChanged"
                OnRowCommand="grid_broker_OnRowCommand" Theme="Moderno"
                Width="100%">
                <%--  <SettingsAdaptivity AdaptivityMode="HideDataCells" />--%>
                <%-- sumeet - changed to allow scrolling to right evcen on lower res --%>
                <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" />
                <SettingsPager PageSize="100" />
                <Paddings Padding="0px" />
                <Border BorderWidth="0px" />
                <BorderBottom BorderWidth="1px" />
                <%-- DXCOMMENT: Configure ASPxGridView's columns in accordance with datasource fields --%>
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="0" FixedStyle="Left" Caption="Broker ID" Width="80px" HeaderStyle-HorizontalAlign="Center">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="BROKER_NAME" VisibleIndex="1" FixedStyle="Left" Width="280px" HeaderStyle-HorizontalAlign="Center" Caption="BROKER NAME">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="BROKER_NAME_ID" VisibleIndex="1" FixedStyle="Left" Width="280px" HeaderStyle-HorizontalAlign="Center" Caption="QB BROKER NAME">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataColumn Caption="BROKER STATUS" VisibleIndex="2" Width="120px" HeaderStyle-HorizontalAlign="Center">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxLabel runat="server" ID="lbl_BROKER_STATUS" Text='<%# Eval("BROKER_STATUS") == null? "N/A": Eval("BROKER_STATUS").ToString() %>' />
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="EMAIL" VisibleIndex="3" Width="280px" HeaderStyle-HorizontalAlign="Center">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PAYLOCITY_ID" VisibleIndex="4" Caption="PAYLOCITY ID" Width="100px" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="NOTES" VisibleIndex="5" Caption="NOTES" Width="250px" HeaderStyle-HorizontalAlign="Center">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataColumn Caption="STATUS" VisibleIndex="10" Width="90px" HeaderStyle-HorizontalAlign="Center">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxLabel runat="server" ID="lbl_s" Text='<%# Eval("STATUS") == null || string.IsNullOrEmpty(Eval("STATUS").ToString())? "Active": Eval("STATUS").ToString()=="Active"? "Active": "Inactive"%>' />
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="Edit" VisibleIndex="10" Width="100px" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center">
                        <SettingsHeaderFilter>
                            <DateRangePickerSettings EditFormatString=""></DateRangePickerSettings>
                        </SettingsHeaderFilter>
                        <DataItemTemplate>
                            <dx:ASPxButton runat="server" ID="btn_edit" Text="Edit" Theme="Mulberry" CommandName="Edit" CommandArgument='<%# Eval("ID") %>'></dx:ASPxButton>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>

                </Columns>
            </dx:ASPxGridView>

            <div>
                &nbsp;
            </div>

        </div>
        <div class="col-1">
        </div>




    </div>

</asp:Content>
