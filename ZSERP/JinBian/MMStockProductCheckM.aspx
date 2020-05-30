<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        //Page.Children.fit = true;
        $(function () {
            
            //Page.Children.toolBarBtnDisabled("table1", "add");
            if (Page.usetype == "add") {
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
        })
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
                        { Field: "fQty", ComOprt: ">", Value: "0" }
                        ]
                    };
                    var data = SqlGetData(sqlObj);
                    if (data.length > 0) {
                        var addRow = [{
                            iStockQty: data[0].iQty,
                            sBarCode: data[0].sBarCode,
                            sBatchNo: data[0].sBatchNo,
                            sReelNo: data[0].sReelNo,
                            fStockQty: data[0].fQty,
                            fStockPurQty: data[0].fPurQty,
                            fStockLetCoe: data[0].sLetCode,
                            sCustShortName: data[0].sCustShortName,
                            iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo,
                            iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                            iStockSdOrderMRecNo: data[0].iSdOrderMRecNo,
                            sBerChID: data[0].sBerChID,
                            sOrderNo: data[0].sOrderNo,
                            iStockSDOrderMRecNoBatch: data[0].iSDOrderMRecNoBatch
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

        Page.afterSave = function () {
             
        }
        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "table1") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fPcLetCode" && changes.fPcLetCode != undefined && changes.fPcLetCode != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var sLetCode = isNaN(parseFloat(row.fPcLetCode)) ? 0 : parseFloat(row.fPcLetCode);
                        var fPurQty = sLetCode * 0.9144;
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fPcQty: fQty, fPcPurQty: fPurQty} });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPcPurQty" && changes.fPcPurQty != undefined && changes.fPcPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        //var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = isNaN(parseFloat(row.fPcPurQty)) ? 0 : parseFloat(row.fPcPurQty);
                        var sLetCode = fPurQty / 0.9144;
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#table1").datagrid("updateRow", { index: index, row: { fPcQty: fQty, fPcLetCode: sLetCode} });
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox4" Z_FieldID="fQty" runat="server" Z_FieldType="数值"
                    Z_decimalDigits="2" />
                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="fPurQty" runat="server" Z_FieldType="数值"
                    Z_decimalDigits="2" />
                <cc1:ExtTextBox2 ID="ExtTextBox6" Z_FieldID="fLetCode" runat="server" Z_FieldType="数值"
                    Z_decimalDigits="2" />
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单据号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        盘点日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                    </td>
                    <td>
                        盘点仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sReMark" Width="737px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
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
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 335px;
                            height: 40px; font-size: 20px; font-weight: bold;" class="txb" />
                    </td>
                    <td colspan="4">
                        <textarea id="txaBarcodeTip" style="height: 40px; width: 260px;" readonly="readonly"
                            class="txb"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="盘点明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="MMStockProductCheckD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
