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
            if (Page.usetype == "add" || Page.usetype == "modify") {
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
                        { title: "通知日期", field: "dDateStr", width: 100, sortable: true },
                        { title: "出库", field: "btnOut", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnOut(" + str + ", " + index + ")' value='出库' />";
                            return btnStr;
                        }
                        },
                    //                        { title: "客户", field: "sCustShortName", width: 80, sortable: true },
                        {title: "订单号", field: "sOrderNo", width: 120, sortable: true },
                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                        { title: "色号", field: "sColorID", width: 80, sortable: true },
                        { title: "颜色名称", field: "sColorName", width: 80, sortable: true },
                        { title: "业务员", field: "sUserName", width: 80, sortable: true },
                        { title: "通知数量", field: "fSumQty", width: 80, sortable: true },
                        { title: "已发货数量", field: "fOutQty", width: 80, sortable: true },
                        { title: "未发货数量", field: "fNotOutQty", width: 80, sortable: true },
                        { title: "销售单位", field: "sSaleUnitName", width: 60, sortable: true },
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
            if (Page.usetype == "modify" || Page.usetype == "view") {
                $("#tabTop").tabs("select", 1);

                var sqlobj2 = { TableName: "vwMMStockProductOutM",
                    Fields: "sSDSendMBillNo,sCustShortName,sOrderNo,sCode,sName,sColorID,sColorName,sPerson,sTel,sTransType,sPackageType,sAddress,iBscDataMatRecNo,iBscDataColorRecNo,iSdOrderMRecNo,iBscDataCustomerRecNo,fProductWeight,fProductWidth",
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
                Page.setFieldValue("fProductWeight", data2[0].fProductWeight);
                Page.setFieldValue("fProductWidth", data2[0].fProductWidth);
                Page.setFieldValue("iSdOrderMRecNo", data2[0].iSdOrderMRecNo);
                Page.setFieldValue('iBscDataCustomerRecNo', data2[0].iBscDataCustomerRecNo);
            }
        });

        function btnOut(row, index) {
            Page.setFieldValue("sSDSendMBillNo", row.sBillNo);
            Page.setFieldValue("dDate", row.dDateStr);
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
            Page.setFieldValue("fProductWeight", row.fProductWeight);
            Page.setFieldValue("fProductWidth", row.fProductWidth);
            Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
            $("#tabTop").tabs("select", "销售出库单");

            document.getElementById("txtBarcode").focus();
        }

        function searchSDSendD() {
            var sqlObjSDSendD = {
                TableName: "vwSdSendD_StockProductOut",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                  {
                      Field: "case when ISNULL(iRed,0)=0 then fNotOutQty else ABS(fNotOutQty) end",
                      ComOprt: ">",
                      Value: "0",
                      LinkOprt: "and"
                  },
                  {
                      Field: "isnull(iFinish,0)",
                      ComOprt: "<>",
                      Value: "1"
                  }
                ],
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
                    var rows = $("#MMStockProductOutD").datagrid("getRows");
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == barcode) {
                                alert("条码已存在！");
                                PlayVoice("条码已存在！");
                                return false;
                            }
                        }
                    }

                    var sqlObj = { TableName: "vwMMStockQty",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                        { Field: "sBarCode", ComOprt: "=", Value: "'" + barcode + "'", LinkOprt: "and" },
                        { Field: "fQty", ComOprt: ">", Value: "0", LinkOprt: "and" },
                        { Field: "iBscDataStockMRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataMatRecNo") + "'", LinkOprt: "and" },
                        { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + Page.getFieldValue("iBscDataColorRecNo") + "'", LinkOprt: "and" },
                        { Field: "fProductWidth", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWidth") + "'", LinkOprt: "and" },
                        { Field: "fProductWeight", ComOprt: "=", Value: "'" + Page.getFieldValue("fProductWeight") + "'" }
                        ]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var addRow = [{
                            sBarCode: data[0].sBarCode,
                            sBatchNo: data[0].sBatchNo,
                            sReelNo: data[0].sReelNo,
                            fQty: data[0].fQty,
                            fPurQty: data[0].fPurQty,
                            sLetCode: data[0].sLetCode,
                            sCustShortName: data[0].sCustShortName,
                            iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                            iStockSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            sBerChID: data[0].sBerChID
                        }];

                        Page.tableToolbarClick("add", "MMStockProductOutD", addRow[0]);
                    }
                    else {
                        var message = $("#txaBarcodeTip").val();
                        $("#txaBarcodeTip").val(message + "条码" + barcode + "不存在\n");
                        PlayVoice("条码" + barcode + "不存在");
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

        Page.afterSave = function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                var jsonobj = {
                    StoreProName: "SpBuildBatchNo",
                    StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@iType",
                        Value: 2
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }

        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var flag = false;
                var rows = $("#MMStockProductOutD").datagrid("getRows");
                for (var i = 0; i < rows.length; i++) {
                    var theRow = rows[i];
                    if (Number(theRow.fQty) < 0) {
                        flag = true;
                        break;
                    }
                    theRow.fQty = theRow.fQty * -1;
                    theRow.fPurQty = theRow.fPurQty * -1;
                    theRow.sLetCode = theRow.sLetCode * -1;
                    $("#MMStockProductOutD").datagrid("updateRow", { index: i, row: theRow });
                }
                if (flag == false) {
                    Page.Children.ReloadFooter("MMStockProductOutD");
                }
            }
            //汇总子表的缸号
            var allRows = $("#MMStockProductOutD").datagrid("getRows");
            var sBatchSum = "";
            for (var i = 0; i < allRows.length; i++) {
                var sBatchNo = allRows[i].sBatchNo;
                if (("," + sBatchSum).indexOf("," + sBatchNo + ",") == -1) {
                    sBatchSum += sBatchNo + ",";
                }
            }
            if (sBatchSum.length > 0) {
                sBatchSum = sBatchSum.substr(0, sBatchSum.length - 1);
            }
            Page.setFieldValue("sBatchSum", sBatchSum);
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "MMStockProductOutD") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var sLetCode = isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode);
                        var fPurQty = sLetCode * 0.9144;
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fQty: fQty, fPurQty: fPurQty} });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        //var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var sLetCode = fPurQty / 0.9144;
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductOutD").datagrid("updateRow", { index: index, row: { fQty: fQty, sLetCode: sLetCode} });
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="height:700,border:false,">
        <div title="未完成发货通知单">
            <table id="SDSendD">
            </table>
        </div>
        <div title="销售出库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div style="display: none;">
                    <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iBillType" />
                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSDSendDRecNo" Style="display: none;" />
                    <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataMatRecNo" Style="display: none;" />
                    <%--<cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBscDataColorRecNo" />--%>
                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="iSdOrderMRecNo" Style="display: none;" />
                    <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sBatchSum" />
                    <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
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
                                    Style="width: 150px;" />
                            </td>
                            <td>
                                发货通知单
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sSDSendMBillNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td style="display:none;">
                                客户
                            </td>
                            <td style="display:none;">
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
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iBscDataColorRecNo"
                                    Style="width: 150px;" />
                            </td>
                            <td>
                                颜色名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                幅度
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                            </td>
                            <td>
                                克重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                                    Z_FieldType="数值" Z_decimalDigits="2" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
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
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" Z_FieldID="iCalc" runat="server" Z_NoSave="true" />
                                <label for="__ExtCheckbox2">
                                    码换算重量</label>
                                <br />
                                <cc1:ExtCheckbox2 ID="ExtCheckbox3" Z_FieldID="iCalc2" runat="server" Z_NoSave="true" />
                                <label for="__ExtCheckbox3">
                                    米换算重量</label>
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
                            <%--<td>
                                出库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                            </td>--%>
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
        <div title="发货信息">
            <table style="display:none;">
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
