<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 843px;
        }
        .style2
        {
            width: 72px;
        }
    </style>
    <script language="javascript" type="text/javascript">

        $(function () {
            Page.Children.toolBarBtnDisabled("SDOrderD", "add");
            Page.Children.toolBarBtnDisabled("SDOrderD", "copy");

            if (Page.usetype == "add") {
                $("#tabTop").tabs({
                    tools: [{
                        iconCls: 'icon-search',
                        handler: function () {
                            searchSDSendD();
                        }
                    }
                        ]
                });

                $("#SDSendD").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { title: "发货通知单编号", field: "sBillNo", width: 110, sortable: true },
                        { title: "出库", field: "btnOut", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnOut(" + str + ", " + index + ")' value='出库' />";
                            return btnStr;
                        }
                        },
                        { title: "客户", field: "sCustShortName", width: 80, sortable: true },
                        { title: "订单号", field: "sOrderNo", width: 120, sortable: true },
                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                        { title: "色号", field: "sColorID", width: 80, sortable: true },
                        { title: "颜色名称", field: "sColorName", width: 80, sortable: true },
                        { field: "iRecNo", hidden: true },
                        { field: "sTransType", hidden: true },
                        { field: "sPackageType", hidden: true },
                        { field: "sPerson", hidden: true },
                        { field: "sTel", hidden: true },
                        { field: "sAddress", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true }
                    ]],
                    onDblClickRow: function (index, row) {
                        btnOut(row, index);
                    }
                }
                );
                searchSDSendD();
            }
            else if (Page.usetype == "modify" || Page.usetype == "view") {
                $("#tabTop").tabs("close", "未完成发货通知单");

                var sqlobj2 = { TableName: "vwMMStockProductOutM",
                    Fields: "sSDSendMBillNo,sCustShortName,sOrderNo,sCode,sName,sColorID,sColorName,sPerson,sTel,sTransType,sPackageType,sAddress,iBscDataMatRecNo,iBscDataColorRecNo,iSdOrderMRecNo,iBscDataCustomerRecNo",
                    SelectAll: "True",
                    Filters: [
                    {
                        //字段名
                        Field: "iRecNo",
                        //比较符
                        ComOprt: "=",
                        //值
                        Value: Page.key
                    }
                    ]

                }
                var data2 = SqlGetData(sqlobj2);

                Page.setFieldValue('sSDSendMBillNo', data2[0].sSDSendMBillNo);
                Page.setFieldValue('sCustShortName', data2[0].sCustShortName);
                Page.setFieldValue('sOrderNo', data2[0].sOrderNo);
                Page.setFieldValue('sCode', data2[0].sCode);
                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('sColorID', data2[0].sColorID);
                Page.setFieldValue('sColorName', data2[0].sColorName);
                Page.setFieldValue('sPerson', data2[0].sPerson);
                Page.setFieldValue('sTel', data2[0].sTel);
                Page.setFieldValue('sTransType', data2[0].sTransType);
                Page.setFieldValue('sPackageType', data2[0].sPackageType);
                Page.setFieldValue('sAddress', data2[0].sAddress);
                Page.setFieldValue('iBscDataMatRecNo', data2[0].iBscDataMatRecNo);
                Page.setFieldValue('iBscDataColorRecNo', data2[0].iBscDataColorRecNo);
                Page.setFieldValue('iSdOrderMRecNo', data2[0].iSdOrderMRecNo);
                Page.setFieldValue('iBscDataCustomerRecNo', data2[0].iBscDataCustomerRecNo);
            }
        });

        function btnOut(row, index) {
            Page.setFieldValue("sSDSendMBillNo", row.sBillNo);
            Page.setFieldValue("iSDSendDRecNo", row.iRecNo);
            Page.setFieldValue("sCustShortName", row.sCustShortName);
            Page.setFieldValue("sOrderNo", row.sOrderNo);
            Page.setFieldValue("sCode", row.sCode);
            Page.setFieldValue("sName", row.sName);
            Page.setFieldValue("sColorID", row.sColorID);
            Page.setFieldValue("sColorName", row.sColorName);
            Page.setFieldValue("sTransType", row.sTransType);
            Page.setFieldValue("sPackageType", row.sPackageType);
            Page.setFieldValue("sPerson", row.sPerson);
            Page.setFieldValue("sTel", row.sTel);
            Page.setFieldValue("sAddress", row.sAddress);
            Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo);
            Page.setFieldValue("iBscDataColorRecNo", row.iBscDataColorRecNo);
            Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
            Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
            $("#tabTop").tabs("select", "销售出库单");
        }

        function searchSDSendD() {
            var sqlObjSDSendD = {
                TableName: "vwSdSendD_StockProductOut",
                Fields: "*",
                SelectAll: "True",
                Sorts: [
                {
                    SortName: "iRecNo",
                    SortOrder: "asc"
                }
                ]
            };
            var resultSDSendD = SqlGetData(sqlObjSDSendD);
            if (resultSDSendD.length > 0) {
                $("#SDSendD").datagrid("loadData", resultSDSendD);
            }
        }


        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (Page.getFieldValue("iBscDataStockMRecNo") == "") {
                    Page.MessageShow("错误", "请选择仓库！");
                    return;
                }
                if (barcode != "") {
                    var sqlObj = { TableName: "MMStockQty",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [{ Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", LinkOprt: "and" }, { Field: "fQty", ComOprt: ">", Value: "0", LinkOprt: "and" }, { Field: "iBscDataStockMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'", LinkOprt: "and" },
                                    { Field: "iSdOrderMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iSdOrderMRecNo") + "'", LinkOprt: "and" }, { Field: "iBscDataCustomerRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'", LinkOprt: "and" },
                                    { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataMatRecNo") + "'", LinkOprt: "and" }, { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataColorRecNo") + "'"}]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var addRow = [{
                            sBarCode: data[0].sBarCode,
                            sBatchNo: data[0].sBatchNo,
                            sReelNo: data[0].sReelNo,
                            fQty: data[0].fQty,
                            fPurQty: data[0].fPurQty,
                            sLetCode: data[0].sLetCode
                        }];

                        Page.tableToolbarClick("add", "MMStockProductOutD", addRow[0]);
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                        //PlayVoice("条码" + barcode + "不存在");
                    }
                }

                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }

        function stopBubble(e) {
            // 如果传入了事件对象，那么就是非ie浏览器
            if (e && e.stopPropagation) {
                //因此它支持W3C的stopPropagation()方法
                e.stopPropagation();
            } else {
                //否则我们使用ie的方法来取消事件冒泡
                window.event.cancelBubble = true;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未完成发货通知单">
            <table id="SDSendD">
            </table>
        </div>
        <div title="销售出库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div style="display: none;">
                    <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iBillType" />
                </div>
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                出库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                出库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Width="150px" />
                            </td>
                            <td>
                                发货通知单
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sSDSendMBillNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSDSendDRecNo" Style="display: none;" />
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataMatRecNo" Style="display: none;"
                                    Z_NoSave="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBscDataColorRecNo"
                                    Style="display: none;" Z_NoSave="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iSdOrderMRecNo" Style="display: none;"
                                    Z_NoSave="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="display: none;" Z_NoSave="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sCustShortName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sColorID" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                颜色名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                            </td>
                            <td>
                                红冲
                            </td>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                                    Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <strong>请扫入条码</strong>
                            </td>
                            <td colspan="3">
                                <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 300px;
                                    height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                            </td>
                            <td colspan="2">
                                <textarea id="txaBarcodeTip" style="height: 40px; width: 260px;" readonly="readonly"
                                    class="txb"></textarea>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                                    Z_Required="False" Width="120px" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" Width="120px" />
                            </td>
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td class="style2">
                                备注
                            </td>
                            <td class="style1">
                                <textarea id="sReMark" style="border-bottom: 1px solid black; width: 839px; border-left-style: none;
                                    border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                                    border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                                    border-top-color: inherit; border-top-width: 0px;" fieldid="sRemark"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="销售出库单明细">
                            <!--  子表1  -->
                            <table id="MMStockProductOutD" tablename="MMStockProductOutD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div title="客户信息">
            <table>
                <tr>
                    <td>
                        收货人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPerson" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        联系电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sTel" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        运输方式
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" Width="120px" runat="server" Z_FieldID="sTransType"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                    <td>
                        包装方式
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" Width="120px" runat="server" Z_FieldID="sPackageType"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        收货地址
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sAddress" Width="742px"
                            Z_NoSave="True" Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
</asp:Content>
