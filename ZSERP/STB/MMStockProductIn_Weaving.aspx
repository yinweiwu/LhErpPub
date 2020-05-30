<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                var sqlObjPeriod = {
                    TableName: "bscDataPeriod",
                    Fields: "sYearMonth",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "convert(varchar(10),dBeginDate,23)",
                            ComOprt: "<=",
                            Value: "convert(varchar(10),getdate(),23)",
                            LinkOprt: "and"
                        },
                        {
                            Field: "convert(varchar(10),dEndDate,23)",
                            ComOprt: ">=",
                            Value: "convert(varchar(10),getdate(),23)"
                        }
                    ]
                }
                var resultPeriod = SqlGetData(sqlObjPeriod);
                if (resultPeriod.length > 0) {
                    Page.setFieldValue("sYearMonth", resultPeriod[0].sYearMonth);
                }
            }
        })
        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {
                    var rows = $("#table1").datagrid("getRows");
                    for (var j = 0; j < rows.length; j++) {
                        if (barcode == rows[j].sBarCode) {
                            var message = $("#txbBarcodeMessage").val();
                            $("#txbBarcodeMessage").val(message + "条码[" + barcode + "]已扫描\r\n");
                            $("#txtBarcode").val("");
                            $("#txtBarcode").focus();
                            stopBubble($("#txtBarcode")[0]);
                            return false;
                        }
                    }
                    var iRed = Page.getFieldValue("iRed");
                    if (iRed == "1") {
                        //从库存中找
                        var sqlObj = {
                            //表名或视图名
                            TableName: "vwMMStockQty",
                            //选择的字段
                            Fields: "*",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: [
                                {
                                    Field: "sBarCode",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + barcode + "'",
                                    LinkOprt: "and"
                                },
                                {
                                    Field: "iMatType",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "2"
                                }
                            ]
                        }
                        var data = SqlGetData(sqlObj);
                        if (data.length > 0) {
                            //var allRow = $("#table1").datagrid("getRows");
                            var apppendRow = {
                                sReelNo: data[0].sReelNo,
                                sCode: data[0].sCode,
                                sName: data[0].sName,
                                sFlowerCode: data[0].sFlowerCode,
                                sColorID: data[0].sColorID,
                                sColorName: data[0].sColorName,
                                fQty: data[0].fQty * -1,
                                fPurQty: data[0].fPurQty * -1,
                                fPrice: data[0].fPrice,
                                fTotal: data[0].fTotal,
                                sBarCode: data[0].sBarCode,
                                iSDContractMRecNo: data[0].iSdOrderMRecNo,
                                iBscDataMatRecNo: data[0].iBscDataMatRecNo,
                                sBerChID: sBerChID,
                                iBscDataStockDRecNo: iBscDataStockDRecNo,
                                sBatchNo: data[0].sBatchNo
                            };
                            Page.tableToolbarClick("add", "table1", apppendRow);
                        } else {
                            var message = $("#txbBarcodeMessage").val();
                            $("#txbBarcodeMessage").val(message + "条码[" + barcode + "]不存在\r\n");
                        }
                    }
                    else {
                        var sqlObj = {
                            //表名或视图名
                            TableName: "vwProWeavingDBarcodeMD",
                            //选择的字段
                            Fields: "*",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: [
                                {
                                    //左括号
                                    //字段名
                                    Field: "sBarCode",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + barcode + "'"
                                }
                            ]
                        }
                        var data = SqlGetData(sqlObj);

                        if (data.length > 0) {
                            var sBerChID = Page.getFieldText("iBscDataStocDRecNo");
                            var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
                            var allRow = $("#table1").datagrid("getRows");
                            var apppendRow = {
                                sReelNo: allRow.length + 1,
                                sCode: data[0].sCode,
                                sName: data[0].sName,
                                sFlowerCode: data[0].sFlowerCode,
                                sColorID: data[0].sColorID,
                                sColorName: data[0].sColorName,
                                fQty: data[0].fQty,
                                sBarCode: data[0].sBarcode,
                                sWeavingBillNo: data[0].sBillNo,
                                iSDContractMRecNo: data[0].iSDContractMRecNo,
                                iBscDataMatRecNo: data[0].iBscDataMatRecNo,
                                iProWeavingMRecNo: data[0].iMainRecNo,
                                sBerChID: sBerChID,
                                iBscDataStockDRecNo: iBscDataStockDRecNo
                            };
                            Page.tableToolbarClick("add", "table1", apppendRow);
                        } else {
                            var message = $("#txbBarcodeMessage").val();
                            $("#txbBarcodeMessage").val(message + "条码[" + barcode + "]不存在\r\n");
                        }
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
        Page.Children.onAfterAddRow = function () {
            //var allRows = $("#table1").datagrid("getRows");
            //var updateRow = { sBerChID: sBerChID, iBscDataStockDRecNo: iBscDataStockDRecNo }
            //$("#table1").datagrid("updateRow", { index: allRows.length - 1, row: updateRow });
        }
        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var allRows = $("#table1").datagrid("getRows");
                $.each(allRows, function (index, o) {
                    var needUpdate = false;
                    var fQty = isNaN(Number(o.fQty)) ? 0 : Number(o.fQty);
                    var fPurQty = isNaN(Number(o.fPurQty)) ? 0 : Number(o.fPurQty);
                    var fTotal = isNaN(Number(o.fTotal)) ? 0 : Number(o.fTotal);
                    var updateRow = {
                    }
                    if (fQty > 0) {
                        updateRow.fQty = (fQty > 0 ? fQty * -1 : fQty);
                        needUpdate = true;
                    }
                    if (fPurQty > 0) {
                        updateRow.fPurQty = (fPurQty > 0 ? fPurQty * -1 : fPurQty);
                        needUpdate = true;
                    }
                    if (fTotal > 0) {
                        updateRow.fTotal = (fTotal > 0 ? fTotal * -1 : fTotal);
                        needUpdate = true;
                    }
                    if (needUpdate) {
                        $("#table1").datagrid("updateRow", { index: index, row: updateRow });
                    }
                })
            }
        }

        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpMMStockProductBuildBarcode",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                },
                {
                    ParmName: "@iType",
                    Value: 1
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result);
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
                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBillType" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>单据编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>单据日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" />
                    </td>
                    <td>仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                    </td>
                    <td>生产商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <td>会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sYearMonth" Z_readOnly="true" />
                    </td>
                    <td>经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sBscDataPersonID" />
                    </td>
                    <td>备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Style="width: 99%" />
                    </td>
                </tr>
                <tr>
                    <td>总米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fQty" Z_readOnly="true" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>总卷数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iQty" Z_readOnly="true" Z_FieldType="整数" />
                    </td>
                    <td>总金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fTotal" Z_readOnly="true" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox1">红冲</label>
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                    </td>
                    <td>制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间" Z_readOnly="true" />
                    </td>
                    <td>仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBscDataStockDRecNo" Z_NoSave="true" />
                    </td>
                </tr>
                <tr>
                    <td>条码
                    </td>
                    <td colspan="3">
                        <input type="text" id="txtBarcode" style="width: 99%; height: 30px; border: none; border-bottom: solid 1px #a0a0a0; font-size: 20px; font-weight: bold; vertical-align: middle;" onkeydown="BarcodeScan()" />
                    </td>
                    <td colspan="2">
                        <textarea id="txbBarcodeMessage" style="width: 99%" readonly="readonly"></textarea>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--子表1  -->
                    <table id="table1" tablename="MMStockProductInD">
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

