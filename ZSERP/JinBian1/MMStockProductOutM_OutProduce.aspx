<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                Page.setFieldValue("iBillType", getQueryString("iBillType"));
                var sqlObj = {
                    TableName: "bscDataPeriod",
                    Fields: "sYearMonth",
                    SelectAll: "True",
                    Filters: [
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: ">=",
                                Value: "dBeginDate",
                                LinkOprt: "and"
                            },
                            {
                                Field: "convert(varchar(50),GETDATE(),23)",
                                ComOprt: "<=",
                                Value: "dEndDate"
                            }]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }
            }
            if (Page.usetype == "add" || Page.usetype == "modify") {
                columns = [[
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "出库", field: "__btn", width: 80, formatter: function (value, row, index) {
                            return "<input type='button' onclick='passIn(" + index + ")' value='出库' ></input>";
                        }
                        },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                         { title: "加工厂家", field: "sCustShortName", width: 100, sortable: true },
                        { title: "产品编号", field: "sCode", width: 100, sortable: true },
                        { title: "产品名称", field: "sName", width: 100, sortable: true },
                        { title: "色号", field: "sColorID", width: 100, sortable: true },
                        { title: "颜色", field: "sColorName", width: 100, sortable: true },
                        { title: "幅宽", field: "fProductWidth", width: 100, sortable: true },
                        { title: "克重", field: "fProductWeight", width: 100, sortable: true },
                        { title: "米数", field: "fQty", width: 80, sortable: true },
                        { title: "未出库米数", field: "fNoOutQty", width: 80, sortable: true },
                //                        { title: "单价", field: "fPrice", width: 80, sortable: true, hidden: true },
                //                        { field: "金额", field: "fNoInTotal", width: 80, sortable: true, hidden: true },
                        {field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iSDOrderDRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iRecNo", hidden: true }

                ]];
                $("#table2").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 500, 5000],
                    columns: columns,
                    toolbar: [{
                        iconCls: 'icon-search',
                        text: "查询",
                        handler: function () {
                            search1();
                        }
                    }],
                    onSelect: function (index, row) {
                    }
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            else {
                $('#tabTop').tabs('close', '未出库外加工单');
            }
        })


        function search1() {
            var sqlObjOrderMD = {
                TableName: "vwProOutProduceMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sOutFinish",
                        ComOprt: "=",
                        Value: "'x'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3",
                        LinkOprt:"and"
                    },
                    {
                        Field: "isnull(iOut,0)",
                        ComOprt: "=",
                        Value: "1",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iBillType,0)",
                        ComOprt: "=",
                        Value: "2"
                    }
                    ],
                Sorts: [
                    {
                        SortName: "sCustShortName",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
            };

            var resultSendMD = SqlGetData(sqlObjOrderMD);
            $("#table2").datagrid("loadData", resultSendMD);
        }

        function passIn(index) {
            var selectedRow = $("#table2").datagrid("getRows")[index];
            Page.setFieldValue("iBscDataCustomerRecNo", selectedRow.iBscDataCustomerRecNo);
            Page.setFieldValue("iBscDataMatRecNo", selectedRow.iBscDataMatRecNo);
            Page.setFieldValue("iBscDataColorRecNo", selectedRow.iBscDataColorRecNo);
            Page.setFieldValue("fProductWidth", selectedRow.fProductWidth);
            Page.setFieldValue("fProductWeight", selectedRow.fProductWeight);
            Page.setFieldValue("iBscDataCustomerRecNo", selectedRow.iBscDataCustomerRecNo);
            Page.setFieldValue("iProOutProduceDRecNo", selectedRow.iRecNo);
            Page.setFieldValue("iSdOrderMRecNo", selectedRow.iSdOrderMRecNo);
            $("#tabTop").tabs("select", "外加工出库单");
            document.getElementById("txtBarcode").focus();
            //            var rows = $('#table2').datagrid('getChecked');
            //            if (rows.length > 0) {
            //                var iCustomerRecNo = 0;
            //                iCustomerRecNo = rows[0].iBscDataCustomerRecNo;
            //                for (var i = 1; i < rows.length; i++) {
            //                    if (iCustomerRecNo != rows[i].iBscDataCustomerRecNo) {
            //                        alert("一次只能转入同一个加工厂商的入库记录！");
            //                        return;
            //                    }
            //                }
            //                Page.setFieldValue("iBscDataCustomerRecNo", iCustomerRecNo);
            //                for (var i = 0; i < rows.length; i++) {
            //                    var appRow = {};
            //                    appRow.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
            //                    appRow.fQty = rows[i].fNoInQty;
            //                    appRow.sOrderNo = rows[i].sOrderNo;
            //                    appRow.fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
            //                    appRow.fTotal = isNaN(parseFloat(rows[i].fNoInTotal)) ? 0 : parseFloat(rows[i].fNoInTotal);
            //                    appRow.fPurQty = rows[i].fPurQty;
            //                    appRow.iSDOrderMRecNo = rows[i].iSdOrderMRecNo;
            //                    appRow.sCode = rows[i].sBscDataFabCode;
            //                    appRow.sName = rows[i].sBscDataFabName;
            //                    Page.tableToolbarClick("add", "table1", appRow);
            //                }
            //            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fQty: fQty} });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty} });
                    }
                }
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
                    var rows = $("#table1").datagrid("getRows");
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if (rows[i].sBarCode == barcode) {
                                alert("条码已存在！");
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

                        Page.tableToolbarClick("add", "table1", addRow[0]);
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
        <div title="未出库外加工单" data-options="fit:true">
            <table id="table2">
            </table>
        </div>
        <div title="外加工出库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iProOutProduceDRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iSdOrderMRecNo" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
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
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    style="width:150px;" />
                            </td>
                            <td id="Td2">
                                加工厂/染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                     style="width:150px;"  />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatRecNo" style="width:150px;"  />
                            </td>
                            <td>
                                产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sName" Z_readOnly="true"
                                    Z_NoSave="true" />
                            </td>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBscDataColorRecNo" style="width:150px;"  />
                            </td>
                            <td>
                                颜色
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sColorName" Z_readOnly="true"
                                    Z_NoSave="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                幅宽
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fProductWidth" />
                            </td>
                            <td>
                                克重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fProductWeight" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan='3'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Width="358px" Z_FieldID="sReMark" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCalc2" Z_NoSave="True" checked="checked" />
                                <label for="__ExtCheckbox1">
                                    重量换算米数</label>
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
                        <%--<tr>                            
                            
                        </tr>--%>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="出库明细">
                            <table id="table1" tablename="MMStockProductOutD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
