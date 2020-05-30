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

            $("#tabSendMD").datagrid({
                fit: true,
                columns: [
                    [
                        { field: "__ck", width: "40", checkbox: true },
                        { field: "sBillNo", title: "剪货单号", width: 100, align: "center" },
                        //{ field: "sCustShortName", title: "客户简称", width: 80, align: "center" },
                        { field: "sCode", title: "产品型号", width: 80, align: "center" },
                        { field: "sFlowerCode", title: "花本型号", width: 80, align: "center" },
                        { field: "fSumQty", title: "要求发货米数", width: 80, align: "center" },
                        { field: "fOutQty", title: "已发货米数", width: 80, align: "center" },
                        { field: "fNoOutQty", title: "未发货米数", width: 80, align: "center" },
                        { field: "sSuggestReelNo", title: "建议选卷", width: 200, align: "center" },
                        { field: "fStockQty", title: "当前库存数", width: 80, align: "center" },
                        { field: "sFinish", title: "出库完成", width: 60, align: "center" }
                    ]
                ],
                singleSelect: true,
                rownumbers: true,
                /*pagination: true,
                pageSize: 30,
                pageList: [30, 100, 500, 1000],
                remoteSort: false,
                loadFilter: pagerFilter,*/
                toolbar: "#divMenu"
            })
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "copy");
        })

        lookUp.afterSelected = function (unique, data) {
            if (unique == "52") {
                loadSDSendMD();
            }
        }

        function loadSDSendMD() {
            var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
            if (iBscDataCustomerRecNo == "") {
                Page.MessageShow("请先选择客户", "请先选择客户");
                return false;
            }
            var iFinish = $("#ckbFinish")[0].checked;
            var Filters = [
                {
                    Field: "iStatus",
                    ComOprt: "=",
                    Value: "4",
                    LinkOprt: "and"
                },
                {
                    Field: "iBscDataCustomerRecNo",
                    ComOprt: "=",
                    Value: "'" + iBscDataCustomerRecNo + "'"
                }
            ]
            if (iFinish != true) {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "isnull(iFinish,0)",
                    ComOprt: "=",
                    Value: "0"
                })
            }
            var sqlObj = {
                TableName: "vwSDSendMD",
                Fields: "*",
                SelectAll: "True",
                Filters: Filters,
                Sorts: [
                    {
                        SortName: "sDate",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabSendMD").datagrid("loadData", result);
        }
        function doSendMDFinish() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                $.messager.confirm("您确认标记吗?", "您确认标记所选明细出库完成/未完成吗?", function (r) {
                    if (r) {
                        var RecNoStr = checkedRows[0].iRecNo;
                        var jsonobj = {
                            StoreProName: "SpSDSendDFinish",
                            StoreParms: [{
                                ParmName: "@iformid",
                                Value: ""
                            }, {
                                ParmName: "@keys",
                                Value: RecNoStr
                            }, {
                                ParmName: "@userid",
                                Value: Page.userid
                            }, {
                                ParmName: "@btnid",
                                Value: ""
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                        else {
                            Page.MessageShow("成功", "标记成功");
                            loadSDSendMD();
                        }
                    }
                })
            }
        }

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
                    if (iRed != "1") {
                        var checkedRow = $("#tabSendMD").datagrid("getChecked");
                        if (checkedRow.length == 0) {
                            Page.MessageShow("请先选择剪货单明细", "请先选择剪货单明细");
                            return false;
                        }
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
                                fQty: data[0].fQty,
                                fPurQty: data[0].fPurQty,
                                fPrice: data[0].fPrice,
                                fTotal: data[0].fTotal,
                                fSalePrice: checkedRow[0].fOrderPrice,
                                fSaleTotal: (isNaN(Number(checkedRow[0].fOrderPrice)) ? 0 : Number(checkedRow[0].fOrderPrice)) * (isNaN(Number(data[0].fQty)) ? 0 : Number(data[0].fQty)),
                                sBarCode: data[0].sBarCode,
                                iSDContractDRecNo: checkedRow[0].iSdOrderDRecNo,
                                iSDSendDRecNo: checkedRow[0].iRecNo,
                                iBscDataMatRecNo: data[0].iBscDataMatRecNo,
                                sBerChID: data[0].sBerChID,
                                iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                                sSerial: data[0].sSerial,
                                sCustShortName: data[0].sCustShortName,
                                sSendBillNo: checkedRow[0].sBillNo,
                                sBatchNo: data[0].sBatchNo,
                                iStockSdOrderMRecNo: data[0].iSdOrderMRecNo,
                                iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo
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
                            TableName: "vwMMStockProductOutMD",
                            //选择的字段
                            Fields: "*",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: [
                                {
                                    //字段名
                                    Field: "sBarCode",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + barcode + "'",
                                    LinkOprt: "and"
                                }, {
                                    //字段名
                                    Field: "iMainRecNo",
                                    //比较符
                                    ComOprt: "<>",
                                    //值
                                    Value: "'" + Page.key + "'",
                                    LinkOprt: "and"
                                }, {
                                    //字段名
                                    Field: "iBscDataCustomerRecNo",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'",
                                    LinkOprt: "and"
                                }, {
                                    //字段名
                                    Field: "iBscDataStockMRecNo",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'"
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
                                fQty: Number(data[0].fQty) * -1,
                                fPurQty: (isNaN(Number(data[0].fPurQty)) ? 0 : Number(data[0].fPurQty)) * -1,
                                fPrice: data[0].fPrice,
                                fTotal: (isNaN(Number(data[0].fTotal)) ? 0 : Number(data[0].fTotal)) * -1,
                                fSalePrice: data[0].fSalePrice,
                                fSaleTotal: (isNaN(Number(data[0].fSaleTotal)) ? 0 : Number(data[0].fSaleTotal)) * -1,
                                sBarCode: data[0].sBarCode,
                                iSDContractDRecNo: data[0].iSDContractDRecNo,
                                iSDSendDRecNo: data[0].iSDSendDRecNo,
                                iBscDataMatRecNo: data[0].iBscDataMatRecNo,
                                sBerChID: data[0].sBerChID,
                                iBscDataStockDRecNo: data[0].iBscDataStockDRecNo,
                                sSerial: data[0].sSerial,
                                sCustShortName: data[0].sCustShortName,
                                sSendBillNo: data[0].sSendBillNo,
                                sBatchNo: data[0].sBatchNo,
                                iStockSdOrderMRecNo: data[0].iStockSdOrderMRecNo,
                                iBscDataCustomerRecNo: data[0].iBscDataCustomerRecNo
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

        Page.beforeSave = function () {
            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var allRows = $("#table1").datagrid("getRows");
                $.each(allRows, function (index, o) {
                    var needUpdate = false;
                    var fQty = isNaN(Number(o.fQty)) ? 0 : Number(o.fQty);
                    var fPurQty = isNaN(Number(o.fPurQty)) ? 0 : Number(o.fPurQty);
                    var fTotal = isNaN(Number(o.fTotal)) ? 0 : Number(o.fTotal);
                    var fSaleTotal = isNaN(Number(o.fSaleTotal)) ? 0 : Number(o.fSaleTotal);
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
                    if (fSaleTotal > 0) {
                        updateRow.fSaleTotal = (fSaleTotal > 0 ? fSaleTotal * -1 : fSaleTotal);
                        needUpdate = true;
                    }
                    if (needUpdate) {
                        $("#table1").datagrid("updateRow", { index: index, row: updateRow });
                    }
                })
            }
        }

        dataForm.beforeOpen=function(unique) {
            if (unique == "400") {
                var iRed = Page.getFieldValue("iRed");
                if (iRed != "1") {
                    Page.MessageShow("只有红冲时可以转入", "只有红冲时可以从销售出库转入！");
                    return false;
                }
            }
        }
        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "399") {
                var checkedRow = $("#tabSendMD").datagrid("getChecked");
                if (checkedRow.length > 0) {
                    row.fSalePrice = checkedRow[0].fOrderPrice,
                    row.fSaleTotal = (isNaN(Number(checkedRow[0].fOrderPrice)) ? 0 : Number(checkedRow[0].fOrderPrice)) * (isNaN(Number(row.fQty)) ? 0 : Number(row.fQty));
                    row.iSDContractDRecNo = checkedRow[0].iSdOrderDRecNo;
                    row.iSDSendDRecNo = checkedRow[0].iRecNo;
                    row.sSendBillNo = checkedRow[0].sBillNo
                    return row;
                }
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
                    Value: 3
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result);
            }
        }

        function pagerFilter(data) {
            if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    dg.datagrid('loadData', data);
                }
            });
            if (!data.originalRows) {
                data.originalRows = (data.rows);
            }
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }
    </script>
    <style type="text/css">
        #divSdSendMD .datagrid-row {
            height: 25px;
        }

        #divSdSendMD .datagrid-header-row {
            height: 25px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden; height: 205px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',border:false" style="width: 650px;">
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fPurQty" Z_readOnly="true" Z_FieldType="数值" Z_decimalDigits="2" />
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iQty" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>单据号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                            </td>
                            <td>日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo" />
                            </td>

                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>会计月份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sYearMonth" />
                            </td>
                            <td>经办人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sPersonID" />
                            </td>
                            <td>客户
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>

                        </tr>
                        <tr>
                            <td>总米数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fQty" Z_readOnly="true" Z_FieldType="数值" Z_decimalDigits="2" />
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
                            <td>备注
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextBox7" runat="server" Z_FieldID="sRemark" Style="width: 99%" />
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
                <div data-options="region:'center',border:false" id="divSdSendMD">
                    <table id="tabSendMD"></table>
                </div>
            </div>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <!--子表1  -->
                    <table id="table1" tablename="MMStockProductOutD">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div id="divMenu">
        <table>
            <tr>
                <td>
                    <input id="ckbFinish" type="checkbox" />
                    <label for="ckbFinish">包含已完成</label>
                </td>
                <td>
                    <a id="btnSDSendMDReload" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="loadSDSendMD()">刷新</a>
                </td>
                <td>
                    <a id="btnSDSendMDFinish" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="doSendMDFinish()">标记完成</a>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

