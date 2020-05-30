<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript"> 
        var showPurOrderDRecNo = undefined;
        $(function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                $("#tabPurOrderD").datagrid(
                    {
                        fit: true,
                        border: false,
                        remoteSort: false,
                        singleSelect: false,
                        columns: [[
                            { checkbox: true, field: "__cb", width: 30 },
                            { title: "类型", field: "sType", width: 40, sortable: true },
                            { title: "是否已完成", field: "sTheFinish", width: 70, sortable: true },
                            { title: "采购订单号", field: "sBillNo", width: 110, sortable: true },
                            { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                            { title: "存货编码", field: "sCode", width: 80, sortable: true },
                            { title: "存货名称", field: "sName", width: 80, sortable: true },
                            { title: "序列号", field: "sSerial", width: 50, sortable: true },
                            { title: "颜色", field: "sColorName", width: 80, sortable: true },
                            { title: "工序", field: "sProcessesName", width: 40, sortable: true },
                            { title: "工艺", field: "sFlowerType", width: 50, sortable: true },
                            { title: "总数量", field: "fQty", width: 60, sortable: true },
                            { title: "未入库数量", field: "fNotInQty", width: 60, sortable: true },
                            { title: "未入库金额", field: "fNotInTotal", width: 60, sortable: true },
                            { title: "已入库数量", field: "fInQty", width: 60, sortable: true },
                            { title: "已入库金额", field: "fInTotal", width: 60, sortable: true },
                            { title: "计量<br />单位", field: "sUnitName", width: 40, sortable: true },
                            { title: "日期", field: "dDate1", width: 80, sortable: true },
                            { title: "供应商", field: "sCustShortName", width: 80, sortable: true },
                            { title: "采购员", field: "sPurPersonName", width: 60, sortable: true },
                            { field: "iRecNo", hidden: true },
                            { field: "iBscDataCustomerRecNo", hidden: true },
                            { field: "sBscDataPersonID", hidden: true },
                            { field: "fPrice", hidden: true },
                            { field: "fTotal", hidden: true },
                            { field: "iSdOrderMRecNo", hidden: true },
                            { field: "fProductWidth", hidden: true },
                            { field: "fProductWeight", hidden: true },
                            { field: "iMainRecNo", hidden: true },
                            { field: "iBscDataMatRecNo", hidden: true },
                            { field: "ibscDataColorRecNo", hidden: true },
                            { field: "iBscDataFlowerTypeRecNo", hidden: true },
                            { field: "iBscDataProcessMRecNo", hidden: true },
                            { field: "sUnitID", hidden: true },
                            { field: "iSdOrderDRecNo", hidden: true },
                            { field: "sOrderNo", hidden: true },
                            { field: "iSDOrderMRecNoBatch", hidden: true },
                            { field: "iSDContractDProcessDRecNo", hidden: true }
                        ]],
                        onDblClickRow: function (index, row) {
                            passIn(row);
                        }
                    });
            }

            if (Page.usetype == "add") {
                var sqlObj = {
                    //表名或视图名
                    TableName: "bscDataPeriod",
                    //选择的字段
                    Fields: "sYearMonth",
                    //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                    SelectAll: "True",
                    //过滤条件，数组格式
                    Filters: [
                        {
                            //左括号
                            //字段名
                            Field: "convert(varchar(50),GETDATE(),23)",
                            //比较符
                            ComOprt: ">=",
                            //值
                            Value: "dBeginDate",
                            //连接符
                            LinkOprt: "and"
                        },
                        {
                            Field: "convert(varchar(50),GETDATE(),23)",
                            ComOprt: "<=",
                            Value: "dEndDate"
                        }
                    ]
                }
                var data = SqlGetData(sqlObj);
                if (data.length > 0) {
                    Page.setFieldValue("sYearMonth", (data[0]["sYearMonth"] || ""));
                }
            }

            if (Page.usetype != "add") {
                $("#tabTop").tabs("select", "采购入库单");
            }
        })

        function finish() {
            var getRows = $("#tabPurOrderD").datagrid('getChecked');
            if (getRows.length > 0) {
                $.messager.confirm("确认吗？", "您确认完成/取消完成吗？", function (r) {
                    if (r) {
                        for (var i = 0; i < getRows.length; i++) {
                            var jsonobj = {
                                StoreProName: "SpFinish",
                                StoreParms: [{
                                    ParmName: "@iformid",
                                    Value: "PurOrderD"
                                },
                                {
                                    ParmName: "@iRecNo",
                                    Value: getRows[i].iRecNo
                                },
                                {
                                    ParmName: "@sUserID",
                                    Value: Page.userid
                                }]
                            }
                            var Result = SqlStoreProce(jsonobj);
                        }
                        searchPurOrderMD();
                    }
                });
            }
        }

        function passIn(row) {
            if (row) {
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                iBscDataCustomerRecNo = isNaN(Number(iBscDataCustomerRecNo)) ? 0 : Number(iBscDataCustomerRecNo);

                if (iBscDataCustomerRecNo > 0) {
                    if (row.iBscDataCustomerRecNo != iBscDataCustomerRecNo) {
                        alert("转入的加工商不一致");
                        return false;
                    }
                }

                Page.setFieldValue("iBscDataCustomerRecNo", row.iBscDataCustomerRecNo);
                Page.setFieldValue("iPurOrderMRecNo", row.iMainRecNo);
                Page.setFieldValue("iPurOrderDRecNo", row.iRecNo);
                Page.setFieldValue("iBscDataMatRecNo", row.iBscDataMatRecNo);
                Page.setFieldValue("iBscDataColorRecNo", row.ibscDataColorRecNo);
                Page.setFieldValue("fProductWeight", row.fProductWeight);
                Page.setFieldValue("fProductWidth", row.fProductWidth);
                Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
                Page.setFieldValue("iBscDataFlowerTypeRecNo", row.iBscDataFlowerTypeRecNo);
                Page.setFieldValue("iBscDataProcessMRecNo", row.iBscDataProcessMRecNo);
                Page.setFieldValue("iSdOrderDRecNo", row.iSdOrderDRecNo);
                Page.setFieldValue("sUnitID", row.sUnitID);
                Page.setFieldValue("fPrice", row.fPrice);

                var a = {};
                a.iPurOrderDRecNo = row.iRecNo;
                a.iBscDataMatRecNo = row.iBscDataMatRecNo;
                a.iBscDataColorRecNo = row.ibscDataColorRecNo;
                a.fProductWeight = row.fProductWeight;
                a.fProductWidth = row.fProductWidth;
                a.iSdOrderMRecNo = row.iSdOrderMRecNo;
                a.iBscDataFlowerTypeRecNo = row.iBscDataFlowerTypeRecNo;
                a.iBscDataProcessesMRecNo = row.iBscDataProcessMRecNo;
                a.iSdOrderDRecNo = row.iSdOrderDRecNo;
                a.sCode = row.sCode;
                a.sName = row.sName;
                a.sColorID = row.sColorID;
                a.sColorName = row.sColorName;
                a.sFlowerType = row.sFlowerType;
                a.sProcessesName = row.sProcessesName;
                a.fPrice = row.fPrice;
                a.sUnitID = row.sUnitID;
                a.sUnitName = row.sUnitName;
                a.sBillNo = row.sBillNo;
                a.sOrderNo = row.sOrderNo;
                a.iSDOrderMRecNoBatch = row.iSDOrderMRecNoBatch;
                a.sSerial = row.sSerial;
                a.iSDContractDProcessDRecNo = row.iSDContractDProcessDRecNo;
                Page.tableToolbarClick("add", "MMStockProductInD", a);
                $("#tabTop").tabs("select", "采购入库单");
            } else {
                var rows = $("#tabPurOrderD").datagrid('getChecked');
                if (rows.length > 0) {
                    var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                    iBscDataCustomerRecNo = isNaN(Number(iBscDataCustomerRecNo)) ? 0 : Number(iBscDataCustomerRecNo);

                    if (iBscDataCustomerRecNo > 0) {
                        if (row.iBscDataCustomerRecNo != iBscDataCustomerRecNo) {
                            alert("转入的加工商不一致");
                            return false;
                        }
                    } else {
                        for (var i = 1; i < rows.length; i++) {
                            if (rows[i - 1].iBscDataCustomerRecNo != rows[i].iBscDataCustomerRecNo) {
                                alert("转入的加工商不一致");
                                return false;
                            }
                        }
                    }

                    $("#tabTop").tabs("select", "采购入库单");
                    Page.setFieldValue("iBscDataCustomerRecNo", rows[0].iBscDataCustomerRecNo);
                    Page.setFieldValue("iPurOrderMRecNo", rows[0].iMainRecNo);
                    Page.setFieldValue("iPurOrderDRecNo", rows[0].iRecNo);
                    Page.setFieldValue("iBscDataMatRecNo", rows[0].iBscDataMatRecNo);
                    Page.setFieldValue("iBscDataColorRecNo", rows[0].ibscDataColorRecNo);
                    Page.setFieldValue("fProductWeight", rows[0].fProductWeight);
                    Page.setFieldValue("fProductWidth", rows[0].fProductWidth);
                    Page.setFieldValue("iSdOrderMRecNo", rows[0].iSdOrderMRecNo);
                    Page.setFieldValue("iBscDataFlowerTypeRecNo", rows[0].iBscDataFlowerTypeRecNo);
                    Page.setFieldValue("iBscDataProcessMRecNo", rows[0].iBscDataProcessMRecNo);
                    Page.setFieldValue("iSdOrderDRecNo", rows[0].iSdOrderDRecNo);
                    Page.setFieldValue("sUnitID", rows[0].sUnitID);
                    Page.setFieldValue("fPrice", rows[0].fPrice);

                    for (var i = 0; i < rows.length; i++) {
                        var a = {};
                        a.iPurOrderDRecNo = rows[i].iRecNo;
                        a.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                        a.iBscDataColorRecNo = rows[i].ibscDataColorRecNo;
                        a.fProductWeight = rows[i].fProductWeight;
                        a.fProductWidth = rows[i].fProductWidth;
                        a.iSdOrderMRecNo = rows[i].iSdOrderMRecNo;
                        a.iBscDataFlowerTypeRecNo = rows[i].iBscDataFlowerTypeRecNo;
                        a.iBscDataProcessesMRecNo = rows[i].iBscDataProcessMRecNo;
                        a.iSdOrderDRecNo = rows[i].iSdOrderDRecNo;
                        a.sCode = rows[i].sCode;
                        a.sName = rows[i].sName;
                        a.sColorID = rows[i].sColorID;
                        a.sColorName = rows[i].sColorName;
                        a.sFlowerType = rows[i].sFlowerType;
                        a.sProcessesName = rows[i].sProcessesName;
                        a.fPrice = rows[i].fPrice;
                        a.sUnitID = rows[i].sUnitID;
                        a.sUnitName = rows[i].sUnitName;
                        a.sBillNo = rows[i].sBillNo;
                        a.sOrderNo = rows[i].sOrderNo;
                        a.iSDOrderMRecNoBatch = rows[i].iSDOrderMRecNoBatch;
                        a.sSerial = rows[i].sSerial;
                        a.iSDContractDProcessDRecNo = rows[i].iSDContractDProcessDRecNo;
                        Page.tableToolbarClick("add", "MMStockProductInD", a);
                    }
                    $("#tabTop").tabs("select", "采购入库单");
                }
            }
        }
        function searchPurOrderMD() {
            var dDate1 = Page.getFieldValue('dDate1').trim();
            var dDate2 = Page.getFieldValue('dDate2').trim();
            var sOrderNo2 = Page.getFieldValue('sOrderNo2').trim();
            var sPurBillNo = Page.getFieldValue('sPurBillNo').trim();
            var sPurCode = Page.getFieldValue('sPurCode').trim();
            var iIsPurFinish = isNaN(Number(Page.getFieldValue('iIsPurFinish'))) ? 0 : Number(Page.getFieldValue('iIsPurFinish'));

            if (dDate1 == "") {
                dDate1 = "1970-01-01";
            }
            if (dDate2 == "") {
                dDate2 = "2199-12-31";
            }

            var sqlObjPurOrderMD = {
                TableName: "vwPurOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "dDate",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sBillNo",
                        ComOprt: "like",
                        Value: "'%" + sPurBillNo + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sOrderNo",
                        ComOprt: "like",
                        Value: "'%" + sOrderNo2 + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sCode",
                        ComOprt: "like",
                        Value: "'%" + sPurCode + "%'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iFinish,0)",
                        ComOprt: "=",
                        Value: iIsPurFinish,
                        LinkOprt: "and"
                    },
                    //{
                    //    Field: "ISNULL(fQty,0)",
                    //    ComOprt: ">",
                    //    Value: "ISNULL(fInQty,0)",
                    //    LinkOprt: "and"
                    //},
                    {
                        Field: "iMatTypeM",
                        ComOprt: "=",
                        Value: "2",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: ">",
                        Value: "3"
                    }
                ],
                Sorts: [
                    {
                        SortName: "dInputDate",
                        SortOrder: "desc"
                    }
                ]
            };
            var resultPurOrderMD = SqlGetData(sqlObjPurOrderMD);
            if (resultPurOrderMD.length > 0) {
                $("#tabPurOrderD").datagrid("loadData", resultPurOrderMD);
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
                            Value: 1
                        }
                    ]
                }
                var result = SqlStoreProce(jsonobj);
            }
        }

        Page.Children.onAfterAddRow = function (tableid) {
            //if (tableid == "MMStockProductInD") {
            //    var rows = $("#" + tableid).datagrid("getRows");
            //    var row = rows[rows.length - 1];
            //    var a = {};
            //    a.iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
            //    a.sBerChID = Page.getFieldText("iBscDataStockDRecNo");
            //    a.iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
            //    a.sCode = Page.getFieldText("iBscDataMatRecNo");
            //    a.sName = Page.getFieldValue("sName");
            //    a.iBscDataColorRecNo = Page.getFieldValue("iBscDataColorRecNo");
            //    a.sColorID = Page.getFieldText("iBscDataColorRecNo");
            //    a.sColorName = Page.getFieldValue("sColorName");
            //    a.iBscDataFlowerTypeRecNo = Page.getFieldValue("iBscDataFlowerTypeRecNo");
            //    a.sFlowerType = Page.getFieldText("iBscDataFlowerTypeRecNo");
            //    a.iBscDataProcessesMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
            //    a.sProcessesName = Page.getFieldText("iBscDataProcessMRecNo");
            //    a.fProductWidth = Page.getFieldValue("fProductWidth");
            //    a.fProductWeight = Page.getFieldValue("fProductWeight");
            //    a.fPrice = Page.getFieldValue("fPrice");
            //    a.sUnitID = Page.getFieldValue("sUnitID");
            //    a.sUnitName = Page.getFieldText("sUnitID");
            //    a.iPurOrderDRecNo = Page.getFieldValue("iPurOrderDRecNo");
            //    a.iSdOrderMRecNo = Page.getFieldValue("iSdOrderMRecNo");
            //    a.iSdOrderDRecNo = Page.getFieldValue("iSdOrderDRecNo"); 
            //    $("#" + tableid).datagrid("updateRow", { index: rows.length - 1, row: a });
            //}
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "MMStockProductInD") {
                var sUnitID = row.sUnitID;
                sUnitID = isNaN(sUnitID) ? "" : sUnitID;
                sUnitID = sUnitID == "" ? "1" : sUnitID;
                var fPrice = isNaN(Number(row.fPrice)) ? 0 : Number(row.fPrice);
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fQty" && changes.fQty != undefined && changes.fQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fQty = isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                    }
                }
                //var iCalc1 = Page.getFieldValue("iCalc1");
                //if (iCalc1 == "1") {
                //    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                //        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                //        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                //        var fQty = (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode)) * 0.9144;
                //        var fPurQty = fQty * fProductWidth / 100 * fProductWeight / 1000;
                //        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fPurQty: fPurQty } });
                //    }
                //}
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(row.fProductWidth)) ? 0 : parseFloat(row.fProductWidth);
                        var fProductWeight = isNaN(parseFloat(row.fProductWeight)) ? 0 : parseFloat(row.fProductWeight);
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fProductWidth == 0 || fProductWeight == 0 ? 0 : fPurQty * 100 * 1000 / (fProductWeight * fProductWidth);
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fQty: fQty } });
                    }
                }


                if (sUnitID == "0") {
                    var fTotal = fPrice * (isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty));
                    $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                } else if (sUnitID == "1") {
                    var fTotal = fPrice * (isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty));
                    $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                } else {
                    var fTotal = fPrice * (isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode));
                    $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fTotal: fTotal } });
                }

                Page.Children.ReloadFooter("MMStockProductInD");
                var rows = $("#MMStockProductInD").datagrid('getRows');
                var fQtyM = 0;
                var fPurQtyM = 0;
                var sLetCodeM = 0;
                var fTotalM = 0;
                for (var i = 0; i < rows.length; i++) {
                    fQtyM += isNaN(parseFloat(row.fQty)) ? 0 : parseFloat(row.fQty);
                    fPurQtyM += isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                    sLetCodeM += isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode);
                    fTotalM += isNaN(parseFloat(row.fTotal)) ? 0 : parseFloat(row.fTotal);
                }
                Page.setFieldValue("fQty", fQtyM.toFixed(2));
                Page.setFieldValue("fPurQty", fPurQtyM.toFixed(2));
                Page.setFieldValue("sLetCode", sLetCodeM.toFixed(2));
                Page.setFieldValue("fTotal", fTotalM.toFixed(2));
            }
        }
        Page.Children.onAfterDeleteRow = function (tableid) {
            var allRows = $("#" + tableid).datagrid("getRows");
            if (allRows.length == 0) {
                Page.setFieldValue("iPurOrderMRecNo", 0);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true">

        <div title="未入库采购订单明细">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <div style="float: left; width: 80%;">
                            <table>
                                <tr> 
                                    <td>日期从
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="dDate1" Z_NoSave="True"  Z_FieldType="日期"  />
                                    </td>
                                    <td>至
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="dDate2" Z_NoSave="True"  Z_FieldType="日期" />
                                    </td>
                                    <td>采购订单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sPurBillNo" Z_NoSave="True" />
                                    </td> 
                                    <td rowspan="2" style="vertical-align:top;">
                                        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                            onclick='searchPurOrderMD()'>查询</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-import'" onclick='passIn()'>转入</a> <a href='javascript:void(0)' class="easyui-linkbutton"
                                                data-options="iconCls:'icon-remove'" onclick='finish()'>完成/取消完成</a>
                                    </td>                                   
                                </tr>
                                <tr>
                                    <td>订单号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sOrderNo2" Z_NoSave="True" />
                                    </td>
                                    <td>存货编号
                                    </td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sPurCode" Z_NoSave="True" />
                                    </td>
                                    <td>是否已完成
                                    </td>
                                    <td>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox11" runat="server" Z_FieldID="iIsPurFinish" Z_NoSave="True" />
                                    </td>
                                    
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="tabPurOrderD">
                    </table>
                </div>
            </div> 
        </div>
        <div title="采购入库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden;">
                    <!-- 如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="1" runat="server" />
                        <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iSdOrderMRecNo" runat="server"  Z_NoSave="True"/>
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldID="iPurOrderDRecNo" runat="server" Z_NoSave="true" />     
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iBscDataProcessMRecNo"  Z_readOnly="True"/> 
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iBscDataFlowerTypeRecNo" Z_NoSave="True" Z_readOnly="True"/> 
                                <cc1:ExtTextBox2 ID="ExtTextBox219" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" Z_NoSave="True" Z_readOnly="True"/> 
                                <cc1:ExtTextBox2 ID="ExtTextBox220" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" Z_NoSave="True" Z_readOnly="True"/>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iBscDataMatRecNo" Style="width: 150px;" Z_NoSave="True"  Z_readOnly="True"/>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" Style="width: 150px;" /> 
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="iBscDataColorRecNo"
                                    Style="width: 150px;" Z_NoSave="True"  Z_readOnly="True"/> 
                                <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                                    Z_readOnly="True" Width="150px" /> 
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                入库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                                    Width="150px" />
                            </td>
                            <td>
                                日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                                    Width="150px" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Style="width: 150px;" />
                            </td>
                            <td>
                                供应商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                采购单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iPurOrderMRecNo" Style="width: 150px;" Z_readOnly="True" />
                            </td>
                            <td>
                                经办人
                            </td>
                            <td style="margin-left: 40px">
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sBscDataPersonID" Width="150px" />
                            </td>
                            <td>
                                会计月份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                                    Style="width: 150px;" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox21" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox21">
                                    红冲</label>
                            </td>
                        </tr> 
                        
                        <tr> 
                            <td>
                                入库米数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                                    Width="150px" Z_decimalDigits="2" />
                            </td>
                            <td>
                                入库重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fPurQty" Z_readOnly="True"
                                    Width="150px" Z_decimalDigits="2" />
                            </td>
                            <td>
                                入库码数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sLetCode" Z_readOnly="True"
                                    Width="150px" Z_decimalDigits="2" />
                            </td>
                            <td>
                                单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sUnitID" Z_readOnly="True"
                                    Width="150px" Z_NoSave="True" />
                            </td>
                        </tr>
                        <tr> 
                            <td>
                                单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="fPrice" Z_readOnly="True"
                                    Width="150px" Z_NoSave="True" />
                            </td>
                             <td>
                                入库金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox217" runat="server" Z_FieldID="fTotal" Z_readOnly="True"
                                    Width="150px" />
                            </td> 
                            
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Width="347px" Z_FieldID="sReMark" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                                    Width="150px" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" Width="150px" />
                            </td>
                            <td>
                                仓位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iBscDataStockDRecNo"
                                    Style="width: 150px" Z_NoSave="True" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iCalc" Z_NoSave="True" />
                                <label for="__ExtCheckbox1">
                                    米数换算重量</label>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iCalc2" Z_NoSave="True" />
                                <label for="__ExtCheckbox2">
                                    重量换算米</label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false ">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="入库明细">
                            <!--  子表1  -->
                            <table id="MMStockProductInD" tablename="MMStockProductInD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
