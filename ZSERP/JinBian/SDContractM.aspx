<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script language="javascript" type="text/javascript">
        var isModify = false;
        var iOrderType = "";
        var iModifying = 0;
        var sModifyType = "";
        var serialData = [];
        var bscDataProcessM = [];
        var currentTableID = "";
        var canAddRow = false;

        var sCopyOrderNoInfoRecNo = 0;

        var clickfield = "";

        var originalSerialData = [];
        var currentBscDataMatRecNo = 0;
        var currentSelectedRow = undefined;
        $(function () {
            //$("#divTabs1").tabs({
            //    onSelect: function () {
            //        $("#table1").datagrid("resize");
            //        $("#table3").datagrid("resize");
            //        $("#table4").datagrid("resize");
            //    }
            //})
            if (Page.getQueryString("from") == "proc") {
                $("#viewpici").show();
                $("#viewbaozhuang").show();
                //showchange
                //table1 table3

            }
            if (Page.getQueryString("from") == "proc") {
                window.setTimeout(function () {
                    var rows = $("#table1").datagrid("getRows");
                    var crows = $("#table3").datagrid("getRows");
                    for (var i = 0; i < rows.length; i++) {
                        if (rows[i].fOldProductWeight != rows[i].fProductWeight) {
                            $("#showchange").html($("#showchange").html() + "产品" + rows[i].sName + "克重修改，原克重" + rows[i].fOldProductWeight + ",新克重" + rows[i].fProductWeight + "<br>");
                        }
                        if (rows[i].sDiName) {
                            var bl = false;
                            var sName = "";
                            for (var j = 0; j < crows.length; j++) {
                                if (rows[i].iRecNo == crows[j].iSDContractDRecNo && crows[j].iIsBottom == 1) {
                                    if (crows[j].sName == rows[i].sDiName) {
                                        bl = true;
                                        break;
                                    } else {
                                        sName = crows[j].sName;
                                        break;
                                    }
                                }
                            }
                            if (bl == false) {
                                $("#showchange").html($("#showchange").html() + "产品" + rows[i].sName + "底布修改，原底布" + rows[i].sDiName + ",新底布" + sName + "<br>");
                            }
                        }
                    }
                }, 1000);
            }


            // $("#divTabs").tabs("disableTab", "验布要求")
            //$("#divTabs1").tabs("disableTab", "条码生成规则")
            //table2
            Page.Children.toolBarBtnRemove("table2", "add");
            Page.Children.toolBarBtnRemove("table2", "delete");
            Page.Children.toolBarBtnRemove("table2", "copy");

            Page.Children.toolBarBtnRemove("tabSerial", "copy");
            Page.Children.toolBarBtnRemove("tabSerial", "export");

            //$("#divTabs1").tabs("close", "条码生成规则");

            //Page.DoNotCloseWinWhenSave = true;
            iOrderType = getQueryString("iOrderType");
            if (iOrderType == "2") {
                // $("#divTabs").tabs("disableTab", "验布要求");
                //$("#divTabs1").tabs("disableTab", "");
            }

            if (iOrderType == "1") {
                window.setTimeout(function () {
                    Page.Children.ReloadFooter("table1");
                    Page.Children.ReloadFooter("table4");
                    sumtotalfn();
                }, 100)
            }

            if (iOrderType == "1") {
                Page.Children.toolBarBtnDisabled("table3", "add");
                //Page.Children.toolBarBtnDisabled("table3", "delete");
                Page.Children.toolBarBtnDisabled("table3", "copy");
            }

            if (Page.usetype != "view") {
                var sqlObjSerial = {
                    TableName: "BscDataProcessesM",
                    Fields: "sProcessesName,iRecNo",
                    SelectAll: "True"
                }
                var resultSerial = SqlGetData(sqlObjSerial);
                bscDataProcessM = resultSerial;

                Page.Children.toolBarBtnAdd("table3", "importMat", "导入复合原料", null, function () {
                    var doImport = function () {
                        canAddRow = true;
                        var allRows = $("#table1").datagrid("getRows");
                        var colorNotMust = getQueryString("colorNotMust");
                        if (colorNotMust != "1") {
                            var nullColorRows = allRows.filter(function (p) {
                                return p.iBscDataColorRecNo == 0 || p.iBscDataColorRecNo == undefined || p.iBscDataColorRecNo == null;
                            })
                            if (nullColorRows.length > 0) {
                                for (var i = 0; i < allRows.length; i++) {
                                    Page.MessageShow("检测到有颜色空行", "第[" + (i + 1) + "]行颜色为空，请重新选择！");
                                    return false;
                                }
                            }
                        }

                        var fuRows = allRows.filter(function (p) {
                            return p.bMergeMat == 1;
                        })
                        if (fuRows.length > 0) {
                            for (var i = 0; i < fuRows.length; i++) {
                                var iBscDataMatRecNo = fuRows[i].iBscDataMatRecNo;
                                var SqlObj1 = {
                                    TableName: "vwBscDataMatDWaste",
                                    Fields: "iBscDataMatRecNo,sCode,sName,iIsBottom,iProductWidth,iProductWeight,fProductWidth,fProductWeight,iBscDataColorRecNo,sColorID,sColorName,iBscDataMatFabRecNo",
                                    SelectAll: "True",
                                    Filters: [
                                        {
                                            Field: "iMainRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'"
                                        }
                                    ], Sorts: [
                                        {
                                            SortName: "iSerial", SortOrder: "asc"
                                        }
                                    ]
                                }
                                var result1 = SqlGetData(SqlObj1);

                                if (result1.length > 0) {
                                    for (var j = 0; j < result1.length; j++) {
                                        var allRows = $("#table3").datagrid("getRows");
                                        var appRow = {
                                            iSerial: allRows.length + 1,
                                            sType: (result1[j].iIsBottom == "1" ? "底布" : "面布"),
                                            sBelongName: fuRows[i].sName,
                                            sBelongColorName: fuRows[i].sColorName,
                                            sCode: result1[j].sCode,
                                            sName: result1[j].sName,
                                            sSerial: fuRows[i].sSerial,
                                            sColorID: (result1[j].iIsBottom == "1" ? result1[j].sColorID : fuRows[i].sColorID),
                                            fQty: fuRows[i].fProduceQty,
                                            fProduceQty: fuRows[i].fProduceQty,
                                            iBscDataMatRecNo: result1[j].iBscDataMatRecNo,
                                            iBscDataColorRecNo: (result1[j].iIsBottom == "1" ? result1[j].iBscDataColorRecNo : fuRows[i].iBscDataColorRecNo),
                                            iIsComposite: 1,
                                            iSDContractDRecNo: fuRows[i].iRecNo,
                                            iIsBottom: result1[j].iIsBottom,
                                            fProductWidth: result1[j].iProductWidth,
                                            fProductWeight: result1[j].iProductWeight,
                                            sProcessInfo: fuRows[i].sProcessInfo,
                                            sProductName: fuRows[i].sName,
                                            iBelongBscDataMatRecNo: fuRows[i].iBscDataMatRecNo,
                                            iBaseBscDataMatRecNo: result1[j].iBscDataMatFabRecNo
                                        }
                                        var getCustColorID = function (iBscDataMatRecNo, iBscDataCustomerRecNo) {
                                            var sqlObj1 = {
                                                TableName: "vwSDContractMD",
                                                Fields: "top 1 sCustColorID",
                                                SelectAll: "True",
                                                Filters: [
                                                    {
                                                        Field: "ibscDataCustomerRecNo",
                                                        ComOprt: "=",
                                                        Value: "'" + iBscDataCustomerRecNo + "'",
                                                        LinkOprt: "and"
                                                    },
                                                    {
                                                        Field: "iBscDataMatRecNo",
                                                        ComOprt: "=",
                                                        Value: "'" + iBscDataMatRecNo + "'"
                                                    }
                                                ],
                                                Sorts: [
                                                    {
                                                        SortName: "dInputDate",
                                                        SortOrder: "desc"
                                                    }
                                                ]
                                            }
                                            var result1 = SqlGetData(sqlObj1);
                                            if (result1.length > 0) {
                                                return result1[0];
                                            }
                                            else {
                                                return null;
                                            }
                                        }

                                        var iBscDataMatRecNo = appRow.iBscDataMatRecNo;
                                        var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                                        if (iBscDataCustomerRecNo != "" && iBscDataMatRecNo) {
                                            var result = getCustColorID(iBscDataMatRecNo, iBscDataCustomerRecNo);

                                            if (result != null) {
                                                appRow.sCustColorID = result.sCustColorID ? result.sCustColorID : "";
                                            }
                                        }
                                        Page.tableToolbarClick("add", "table3", appRow);
                                    }
                                }
                            }
                        }
                        else {
                            Page.MessageShow("没有类型为复合的明细", "没有类型为复合的明细");
                        }
                        canAddRow = false;
                    }
                    var allRowsFu = $("#table3").datagrid("getRows");
                    if (allRowsFu.length > 0) {
                        $.messager.confirm("确定重新生成？", "确定重新导入复合原料吗，将删除增加原料？", function (r) {
                            if (r) {
                                var allRowsFu = $("#table3").datagrid("getRows");
                                var deleteKey = $("#table3").attr("deleteKey");
                                if (deleteKey == undefined || deleteKey == null) {
                                    deleteKey = "";
                                }
                                while (allRowsFu.length > 0) {
                                    deleteKey += allRowsFu[0].iRecNo + ",";
                                    var rowindex = $("#table3").datagrid("getRowIndex", allRowsFu[0]);
                                    $("#table3").datagrid("deleteRow", rowindex);

                                }
                                $("#table3").attr("deleteKey", deleteKey);
                                doImport();
                            }
                        });
                    }
                    else {
                        doImport();
                    }
                })
                var param2 = Page.getQueryString("param2");
                if (param2 == "B") {
                    Page.Children.toolBarBtnAdd("table1", "serialConfig", "设置工序", null, function () {
                        var selectedRow = $("#table1").datagrid("getSelected");
                        var iBscDataMatRecNo = 0;
                        var allRows = $("#table1").datagrid("getRows");

                        if (selectedRow) {
                            iBscDataMatRecNo = selectedRow.iBscDataMatRecNo;
                            currentSelectedRow = selectedRow;
                        } else {
                            if (allRows.length > 0) {
                                iBscDataMatRecNo = allRows[0].iBscDataMatRecNo;
                                selectedRow = allRows[0];
                                currentSelectedRow = selectedRow;
                            }
                        }
                        currentBscDataMatRecNo = iBscDataMatRecNo;
                        if (iBscDataMatRecNo) {
                            $("#tabSerial").datagrid("loadData", []);
                            var theMatSerial = originalSerialData.filter(function (p) {
                                return p.iBscDataMatRecNo == iBscDataMatRecNo;
                            })
                            if (theMatSerial.length == 0) {
                                //如果是新增状态，且工序子表里没有此物料的工序，则从产品档案中获取
                                if (Page.usetype == "add") {
                                    var SqlObjOrinSerial = {
                                        TableName: "bscDataMatDProcesses",
                                        Fields: "iSerial,iBscDataProcessesMRecNo,fLoss,iProduceType,iProduceBscDataCustomerRecNo,iBscDataFlowerRecNo",
                                        SelectAll: "True",
                                        Filters: [
                                            {
                                                Field: "iMainRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'"//, LinkOprt: "and"
                                            }
                                        ], Sorts: [
                                            {
                                                SortName: "iSerial", SortOrder: "asc"
                                            }
                                        ]
                                    }
                                    var resultOrinSerial = SqlGetData(SqlObjOrinSerial);
                                    for (var i = 0; i < resultOrinSerial.length; i++) {
                                        var app = {
                                            iSerial: resultOrinSerial[i].iSerial,
                                            iBscDataProcessMRecNo: resultOrinSerial[i].iBscDataProcessesMRecNo,
                                            fLoss: resultOrinSerial[i].fLoss,
                                            iProduceType: resultOrinSerial[i].iProduceType,
                                            iProduceBscDataCustomerRecNo: resultOrinSerial[i].iProduceBscDataCustomerRecNo,
                                            iBscDataFlowerTypeRecNo: resultOrinSerial[i].iBscDataFlowerRecNo,
                                            iBscDataMatRecNo: iBscDataMatRecNo,
                                            sName: selectedRow.sName
                                        };
                                        Page.tableToolbarClick("add", "tabSerial", app);
                                    }
                                    //var appRows = $("#tabSerial").datagrid("getRows");
                                    //for (var i = 0; i < appRows.length; i++) {
                                    //    originalSerialData.push(appRows[i]);
                                    //}
                                }
                            } else {
                                theMatSerial.sort(function (a, b) {
                                    return a.iSerial - b.iSerial;
                                })
                                $("#tabSerial").datagrid("loadData", theMatSerial);
                            }
                            $("#divSerial").dialog("open");
                        } else {
                            Page.MessageShow("请先增加产品明细", "请先增加产品明细");
                        }
                    })
                }


                Page.Children.toolBarBtnAdd("table1", "complele1", "填充幅宽克重", null, function () {
                    var selectedRow = $("#table1").datagrid("getSelected");
                    var iBscDataMatRecNo = 0;
                    var allRows = $("#table1").datagrid("getRows");
                    var fProductWidth = 0;
                    var fProductWeight = 0;
                    if (selectedRow) {
                        iBscDataMatRecNo = selectedRow.iBscDataMatRecNo;
                        fProductWidth = selectedRow.fProductWidth;
                        fProductWeight = selectedRow.fProductWeight;
                        for (var i = 0; i < allRows.length; i++) {
                            if (allRows[i].iBscDataMatRecNo == iBscDataMatRecNo) {
                                $("#table1").datagrid("updateRow", { index: i, row: { fProductWidth: fProductWidth, fProductWeight: fProductWeight } });
                            }
                        }
                    } else {
                        Page.MessageShow("请选择一行", "请选择一行");
                    }
                })


                Page.Children.toolBarBtnAdd("table1", "previewOrderNoReplace", "导入返单号信息", null, function () {
                    var sPreviewOrderNo = Page.getFieldValue("sPreviewOrderNo");
                    var sqlObjt = {
                        TableName: "SDContractM",
                        Fields: "iRecNo",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "sOrderNo",
                                ComOprt: "=",
                                Value: "'" + sPreviewOrderNo + "'"
                            }
                        ]
                    }
                    var resultt = SqlGetData(sqlObjt);
                    if (resultt.length == 0) {
                        alert("返单号不存在或返单号存在多个，只能替换单个返单号");
                        return false;
                    } else {
                        var iRecNoM = resultt[0].iRecNo;

                        $("#table1").datagrid("loadData", []);
                        $("#table3").datagrid("loadData", []);

                        var sqlObj1 = {
                            TableName: "vwSDContractD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: iRecNoM,
                                    LinkOprt: "and"
                                },
                                {
                                    Field: "isnull(iIsComposite,0)",
                                    ComOprt: "=",
                                    Value: "0"
                                }
                            ]
                        }
                        var result1 = SqlGetData(sqlObj1);
                        if (result1.length > 0) {
                            for (var i = 0; i < result1.length; i++) {
                                delete result1[i].iMainRecNo;
                                result1[i].iRecNoOld = result1[i].iRecNo;
                                Page.tableToolbarClick("add", "table1", result1[i]);
                            }
                        }

                        var sqlObj3 = {
                            TableName: "vwSDContractD",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: iRecNoM,
                                    LinkOprt: "and"
                                },
                                {
                                    Field: "isnull(iIsComposite,0)",
                                    ComOprt: "=",
                                    Value: "1"
                                }
                            ]
                        }
                        var result3 = SqlGetData(sqlObj3);
                        if (result3.length > 0) {
                            var tmpTable1Rows = $("#table1").datagrid("getRows");
                            for (var i = 0; i < result3.length; i++) {
                                delete result3[i].iMainRecNo;
                                for (var j = 0; j < tmpTable1Rows.length; j++) {
                                    if (tmpTable1Rows[j].iRecNoOld == result3[i].iSDContractDRecNo) {
                                        result3[i].iSDContractDRecNo = tmpTable1Rows[j].iRecNo;
                                        break;
                                    }
                                }
                                Page.tableToolbarClick("add", "table3", result3[i]);
                            }
                        }

                        //var sqlObj4 = {
                        //    TableName: "vwSDContractDMatProcess",
                        //    Fields: "*",
                        //    SelectAll: "True",
                        //    Filters: [
                        //        {
                        //            Field: "iMainRecNo",
                        //            ComOprt: "=",
                        //            Value: iRecNoM
                        //        }
                        //    ]
                        //}
                        //var result4 = SqlGetData(sqlObj4);
                        //if (result4.length > 0) {
                        //    originalSerialData = deepClone(result4);
                        //} else {
                        //    originalSerialData = [];
                        //}
                        sCopyOrderNoInfoRecNo = iRecNoM;
                    }


                })

                Page.Children.toolBarBtnAdd("table3", "complele2", "填充底布信息", null, function () {
                    var selectedRow = $("#table3").datagrid("getSelected");
                    //var iBscDataMatRecNo = 0;
                    var allRows = $("#table3").datagrid("getRows");
                    if (selectedRow) {
                        //var iBscDataMatRecNo = selectedRow.iBscDataMatRecNo;
                        var sType = selectedRow.sType;
                        var iBelongBscDataMatRecNo = selectedRow.iBelongBscDataMatRecNo;
                        for (var i = 0; i < allRows.length; i++) {
                            if (allRows[i] != selectedRow) {
                                if (allRows[i].iBelongBscDataMatRecNo == iBelongBscDataMatRecNo && allRows[i].sType == sType) {
                                    $("#table3").datagrid("updateRow", {
                                        index: i,
                                        row: {
                                            iBscDataMatRecNo: selectedRow.iBscDataMatRecNo,
                                            sCode: selectedRow.sCode,
                                            sName: selectedRow.sName,
                                            sColorID: selectedRow.sColorID,
                                            iBscDataColorRecNo: selectedRow.iBscDataColorRecNo
                                        }
                                    });
                                }
                            }
                        }
                        Page.MessageShow("填充成功！", sType + "填充成功！");
                    } else {
                        Page.MessageShow("请选择一行", "请选择一行");
                    }
                })
                Page.Children.toolBarBtnAdd("table3", "complele2", "填充幅宽克重", null, function () {
                    var selectedRow = $("#table3").datagrid("getSelected");
                    var iBscDataMatRecNo = 0;
                    var allRows = $("#table3").datagrid("getRows");
                    var fProductWidth = 0;
                    var fProductWeight = 0;
                    if (selectedRow) {
                        iBscDataMatRecNo = selectedRow.iBscDataMatRecNo;
                        fProductWidth = selectedRow.fProductWidth;
                        fProductWeight = selectedRow.fProductWeight;
                        for (var i = 0; i < allRows.length; i++) {
                            if (allRows[i].iBscDataMatRecNo == iBscDataMatRecNo) {
                                $("#table3").datagrid("updateRow", { index: i, row: { fProductWidth: fProductWidth, fProductWeight: fProductWeight } });
                            }
                        }
                    } else {
                        Page.MessageShow("请选择一行", "请选择一行");
                    }
                })

                var options = $("#table1").datagrid("options");
                delete options.url;
                for (var i = 0; i < options.columns[0].length; i++) {
                    if (options.columns[0][i].field == "fStockQtyCanUse") {
                        options.columns[0][i].formatter = function (value, row, index) {
                            if (row.iRecNo) {
                                if (row.fStockQtyCanUse != null && row.fStockQtyCanUse != undefined) {
                                    return "<a href='#'>" + row.fStockQtyCanUse + "</a>";
                                } else {
                                    return "<a href='#'>显示库存</a>";
                                }
                            }
                        }
                    }
                }
                $("#table1").datagrid(options);
                if (Page.usetype == "add") {
                    var allLoadRows = $("#table1").datagrid("getRows");
                    for (var i = 0; i < allLoadRows.length; i++) {
                        allLoadRows[i].sProcesses = "设置工序";
                    }
                    $("#table1").datagrid("loadData", allLoadRows);
                }
                var options1 = $("#table3").datagrid("options");
                delete options1.url;
                for (var i = 0; i < options1.columns[0].length; i++) {
                    if (options1.columns[0][i].field == "fStockQtyCanUse") {
                        options1.columns[0][i].formatter = function (value, row, index) {
                            if (row.iRecNo) {
                                if (row.fStockQtyCanUse != null && row.fStockQtyCanUse != undefined) {
                                    return "<a href='#'>" + row.fStockQtyCanUse + "</a>";
                                } else {
                                    return "<a href='#'>显示库存</a>";
                                }
                            }
                        }
                    }
                }
                $("#table3").datagrid(options1);

            }
            if (Page.usetype != "add") {
            }
            $("#table3").attr("tablename", "SDContractD");

            if (Page.usetype == "modify") {
                var sqlObj = {
                    TableName: "SDContractM",
                    Fields: "iStatus,iModifying",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + Page.key + "'"
                        }
                    ]
                };
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    if (result[0].iStatus != "" && result[0].iStatus != null && result[0].iStatus != undefined) {
                        var iStatus = parseInt(result[0].iStatus);
                        if (iStatus > 1) {
                            iModifying = result[0].iModifying;
                            if (iModifying == 1) {
                                //获取变更类型
                                var sqlObjChange = {
                                    TableName: "SDChange",
                                    Fields: "top 1 sType",
                                    SelectAll: "True",
                                    Filters: [
                                        {
                                            Field: "iSdOrderMRecNo",
                                            ComOprt: "=",
                                            Value: Page.key
                                        }
                                    ],
                                    Sorts: [
                                        {
                                            SortOrder: "desc",
                                            SortName: "iRecNo"
                                        }
                                    ]
                                }
                                var resultChange = SqlGetData(sqlObjChange);
                                if (resultChange.length > 0) {
                                    sModifyType = resultChange[0].sType;
                                    if (sModifyType == "主表信息变更") {
                                        Page.childrenDisabled();
                                    }
                                }
                            }
                        }
                    }
                }
            }

        })
        var isLoadSerialData = false;
        Page.Children.onLoadSuccess = function (tableid, data) {
            if (tableid == "tabSerial") {
                if (isLoadSerialData == false) {
                    originalSerialData = deepClone(data.rows);
                    isLoadSerialData = true;
                }
            }
        }

        Page.Children.onAfterDeleteRow = function (tableid, rows) {
            if (tableid == "table1") {
                sumtotalfn();
            }
            if (tableid == "table4") {
                sumtotalfn();
            }
        }

        Page.Children.onAfterEdit = function (tableid, index, row, changes) {

            if (tableid == "table1") {
                sumtotalfn();
            }
            if (tableid == "table4") {
                sumtotalfn();
            }
        }

        sumtotalfn = function () {
            var fTotal1 = Page.getFieldValue("fTotal1");

            fTotal1 = Number(isNaN(fTotal1) == false ? fTotal1 : 0);

            var fTotal2 = Page.getFieldValue("fTotal2");
            fTotal2 = Number(isNaN(fTotal2) == false ? fTotal2 : 0);
            Page.setFieldValue("fTotal", fTotal1 + fTotal2);
        }

        function openwin1(index) {
            var selectRow = $("#table1").datagrid("getRows")[index];
            var iRecNo = selectRow.iRecNo;
            var sqlObj = {
                TableName: "SDContractD",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + iRecNo + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                var iBscDataMatRecNo = selectRow.iBscDataMatRecNo;
                var sqlObjMatD = {
                    TableName: "bscDataMatDWaste",
                    Fields: "count(iRecNo) as c",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'"
                        }
                    ]
                }
                var resultMatD = SqlGetData(sqlObjMatD);
                if (resultMatD.length > 0) {
                    if (parseInt(resultMatD[0].c) == 0) {
                        Page.MessageShow("此产品未设置复合布", "此产品未设置复合布，请先在产品档案中设置");
                        return;
                    }
                }


                var type = selectRow.iType;  //判断类型为成品复合
                if (type == 6) {
                    var pageType = Page.usetype == "add" || Page.usetype == "modify" ? "modify" : "view";
                    window.open("/ZSERP/JinBian/SDOrderDPart.aspx?iformid=8053&usetype=" + pageType + "&key=" + iRecNo + "&r=" + Math.random(), 'newwindow', 'height=600,width=1150,top=(window.screen.availHeight-30-iHeight)/2,left=(window.screen.availWidth-10-iWidth)/2,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
                }
                else {
                    Page.MessageShow("订单类型复合才可点击", "订单类型复合才可点击");
                    return false;
                }
            }
            else {
                Page.MessageShow("请选保存后再指定复合用料", "请选保存后再指定复合用料");
                return false;
            }
        }
        var checkColorStr = "";
        Page.beforeSave = function () {

            Page.Children.ReloadFooter("table1");
            Page.Children.ReloadFooter("table4");
            sumtotalfn();

            //if (iOrderType == "1") {
            //    //判断重复，同一个产品、颜色、幅宽、克重、订单类型，不能重复
            //    var str = ",";
            //    var allRows = $("#table1").datagrid("getRows");
            //    for (var i = 0; i < allRows.length; i++) {
            //        var theStr = allRows[i].iBscDataMatRecNo + "`" + allRows[i].iBscDataColorRecNo + "`" + allRows[i].fProductWidth + "`" + allRows[i].fProductWeight + "`" + allRows[i].iBscDataFlowerTypeRecNo;
            //        if (str.indexOf("," + theStr + ",") > -1) {
            //            Page.MessageShow("同一产品、颜色、幅宽、克重、花型不能重复", "同一产品、颜色、幅宽、克重、花型不能重复，第" + (i + 1) + "行发现重复！");
            //            return false;
            //        }
            //        str += theStr + ",";
            //    }
            //}


            ////判断是否是变更
            //var jsonobj = {
            //    StoreProName: "SpSDContractDDeleteFu",
            //    StoreParms: [

            //    {
            //        ParmName: "@iRecNo",
            //        Value: Page.key
            //    }

            //    ]
            //}
            //var result = SqlStoreProce(jsonobj);



            if (Page.getQueryString("iNeedCheckWaste") == "1") {
                var allRows = $("#table1").datagrid("getRows");
                //console.log(allRows)
                for (var i = 0; i < allRows.length; i++) {

                    if (allRows[i].bMergeMat == 1 && parseInt(allRows[i].fProduceQty) > 0) {
                        var frows = $("#table3").datagrid("getRows");
                        if (frows.length == 0) {
                            Page.MessageShow("错误提示", "产品第[" + (i + 1) + "]行,没有设置复合用料");
                            return false;
                        }

                        var bl = false;
                        for (var j = 0; j < frows.length; j++) {
                            if (frows[j].iSDContractDRecNo == allRows[i].iRecNo) {
                                bl = true;
                                break;
                            }
                        }

                        if (bl == false) {
                            Page.MessageShow("错误提示", "产品第[" + (i + 1) + "]行,没有设置复合用料");
                            return false;
                        }


                    }
                }
            }

            var schongfu = "";
            checkColorStr = "";
            var allRows = $("#table1").datagrid("getRows");
            for (var i = 0; i < allRows.length; i++) {
                schongfu = (allRows[i].sCode || "") + "-" + (allRows[i].sColorID || "") + "-" + (allRows[i].sFlowerTypeID || "") + "-" + (allRows[i].sSerial || "");
                var allRows1 = $("#table1").datagrid("getRows");
                var bl = false;
                for (var j = 0; j < allRows1.length; j++) {
                    var schongfu1 = (allRows1[j].sCode || "") + "-" + (allRows1[j].sColorID || "") + "-" + (allRows1[j].sFlowerTypeID || "") + "-" + (allRows1[j].sSerial || "");
                    if (allRows[i].iRecNo != allRows1[j].iRecNo) {
                        if (schongfu == schongfu1) {
                            bl = true;
                            break;
                        }
                    }
                }
                if (bl == true) {
                    Page.MessageShow("同一产品、颜色、花型、序列号不能重复", "同一产品、颜色、花型、序列号不能重复，第" + (i + 1) + "行发现重复！");
                    return false;
                }

                checkColorStr += allRows[i].iRecNo + ":" + allRows[i].iBscDataColorRecNo + ":" + allRows[i].sColorID + ",";
            }
            if (checkColorStr != "") {
                checkColorStr = checkColorStr.substr(0, checkColorStr.length - 1);
            }
            //颜色是否可以为空
            var colorNotMust = getQueryString("colorNotMust");
            if (colorNotMust != "1") {
                //判断颜色是否是对应
                var jsonobjColorCheck = {
                    StoreProName: "SpCheckOrderColor",
                    StoreParms: [
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@sStr",
                        Value: checkColorStr,
                        Size: -1
                    }
                    ]
                }
                var resultCheckColor = SqlStoreProce(jsonobjColorCheck);
                if (resultCheckColor != "1") {
                    Page.MessageShow("错误", resultCheckColor);
                    return false;
                }
            }

            //判断复合用料颜色是否不一致
            var allRows3 = $("#table3").datagrid("getRows");
            var allRows1 = $("#table1").datagrid("getRows");
            var mianRows = allRows3.filter(function (p) {
                return p.sType == "面布";
            });
            for (var i = 0; i < mianRows.length; i++) {
                var iSDContractDRecNo = mianRows[i].iSDContractDRecNo;
                var iBscDataColorRecNo = mianRows[i].iBscDataColorRecNo;
                var theMainRow = allRows1.filter(function (p) {
                    return p.iRecNo == iSDContractDRecNo;
                })
                if (theMainRow.length > 0) {
                    if (iBscDataColorRecNo != theMainRow[0].iBscDataColorRecNo) {
                        Page.MessageShow("检测到面布与成品布颜色不一致", "检测到面布[" + mianRows[i].sName + "]的颜色[" + mianRows[i].sColorID + "]与成品布颜色不一致");
                        return false;
                    }
                } else {
                    Page.MessageShow("检测到面布没有对应的成品布", "检测到面布[" + mianRows[i].sName + "]的颜色[" + mianRows[i].sColorID + "]没有对应的成品布");
                    return false;
                }
            }

            if (Page.getFieldValue("sSaleID") == "") {
                Page.MessageShow("错误提示", "业务员不能为空");
                return false;
            }

            var sSaleCode = "";
            var jsonObj = {
                TableName: "bscDataPerson",
                Fields: "sSaleCode",
                SelectAll: "True",
                Filters: [{
                    Field: "sCode",
                    ComOprt: "=",
                    Value: "'" + Page.getFieldValue("sSaleID") + "'"
                }]
            };
            var result = SqlGetData(jsonObj);

            if (result.length > 0) {
                sSaleCode = result[0].sSaleCode || "";
            }

            var sYear = Page.getFieldValue("dDate");
            sYear = sYear.substring(0, 4);
            sYear = sYear.substring(2);


            if (Page.usetype == "add" && Page.getFieldValue("sOrderNo") == "") {
                var sCode = "";
                var sqlObj = {
                    TableName: "SDContractM",
                    Fields: "max(sOrderNo) as sOrderNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sOrderNo like 'HH" + sSaleCode + sYear + "%'",
                            ComOprt: "",
                            Value: ""
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                //console.log(result);
                if (result.length > 0) {
                    if (result[0].sOrderNo != null && result[0].sOrderNo != undefined && result[0].sOrderNo != "") {
                        var maxidStr = result[0].sOrderNo.substr(("HH" + sSaleCode + sYear).length, 3);
                        var maxid = parseFloat(maxidStr);
                        maxid = maxid + 1;
                        var length = maxid.toString().length;
                        for (var i = 0; i < 3 - length; i++) {
                            maxid = "0" + maxid.toString();
                        }
                        sCode = "HH" + sSaleCode + sYear + maxid;
                    }
                    else {
                        sCode = "HH" + sSaleCode + sYear + "001";
                    }
                }
                else {
                    sCode = "HH" + sSaleCode + sYear + "001";
                }
                Page.setFieldValue("sOrderNo", sCode);
            }

            var param2 = Page.getQueryString("param2");
            //如果可以改工序，则保存前判断是否有设置工序
            if (param2 == "B") {
                if (originalSerialData.length == 0) {
                    Page.MessageShow("尚未设置工序", "尚未设置工序");
                    return false;
                }

                $("#tabSerial").datagrid("loadData", originalSerialData);
                //检测复合布是否有复合工序
                var allRows = $("#table1").datagrid("getRows");
                var fhRows = allRows.filter(function (p) {
                    return p.bMergeMat == 1;
                })
                if (fhRows.length > 0) {
                    for (var i = 0; i < fhRows.length; i++) {
                        var serialDataRows = originalSerialData.filter(function (p) {
                            return p.iBscDataMatRecNo == fhRows[i].iBscDataMatRecNo && p.iBscDataProcessMRecNo == 12;
                        })
                        if (serialDataRows.length == 0) {
                            Page.MessageShow("复合布必须有复合工序", "复合布[" + fhRows[i].sName + "]必须有复合工序！");
                            return false;
                        }
                    }
                }
            }
        }
        lookUp.afterSelected = function (uniqueid, index, data, row, rowIndex) {

            if (uniqueid == "1780") {

                var rows = $("#table2").datagrid("getRows");

                if (rows.length == 0) {
                    var sqlObj = {
                        TableName: "BscDataCustomerDBarcodeRule",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.getFieldValue("iBscDataCustomerRecNo") + "'"
                            }
                        ],
                        Sorts: [

                        ]
                    }
                    var result = SqlGetData(sqlObj);

                    $(result).each(function () {
                        var a = {
                            iSerial: (this.iSerial || 0),
                            iWhile: (this.iWhile || 0),
                            sRemark: (this.sRemark || ""),
                            iRecNo: Page.getChildID("SDContractDBarcodeRule")
                        };

                        $("#table2").datagrid("appendRow", a);
                    })
                }
            }
        }
        lookUp.afterSetRowValue = function (uniqueid, index, data, row, rowIndex) {

            if (uniqueid == "1772") {
                var getLastOrderBase = function (iBscDataMatRecNo, iBscDataCustomerRecNo) {
                    var sqlObj1 = {
                        TableName: "vwSDContractMD",
                        Fields: "top 1 iBaseBscDataMatRecNo,sBaseCode,sBaseName",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "ibscDataCustomerRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataCustomerRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataMatRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "dInputDate",
                                SortOrder: "desc"
                            }
                        ]
                    }
                    var result1 = SqlGetData(sqlObj1);
                    if (result1.length > 0) {
                        return result1[0];
                    }
                    else {
                        return null;
                    }
                }

                var getMatBase = function (iBscDataMatRecNo) {
                    var sqlObj2 = {
                        TableName: "vwbscDataMatDWaste",
                        Fields: "top 1 iBscDataMatRecNo as iBaseBscDataMatRecNo,sCode as sBaseCode,sName as sBaseName",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "iSerial",
                                SortOrder: "asc"
                            }
                        ]
                    }
                    var result2 = SqlGetData(sqlObj2);
                    if (result2.length > 0) {
                        return result2[0];
                    }
                    else {
                        return null;
                    }
                }


                var iBscDataMatRecNo = data.iRecNo;
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                if (iBscDataCustomerRecNo == "") {
                    var result = getMatBase(iBscDataMatRecNo);
                    if (result != null) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: result });
                    }
                }
                else {
                    var result = getLastOrderBase(iBscDataMatRecNo, iBscDataCustomerRecNo);
                    if (result == null) {
                        result = getMatBase(iBscDataMatRecNo);
                    }
                    if (result != null) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: result });
                    }
                }


            }

            if (uniqueid == "1810") {
                var getCustColorID = function (iBscDataMatRecNo, iBscDataCustomerRecNo) {
                    var sqlObj1 = {
                        TableName: "vwSDContractMD",
                        Fields: "top 1 sCustColorID",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "ibscDataCustomerRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataCustomerRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iBscDataMatRecNo",
                                ComOprt: "=",
                                Value: "'" + iBscDataMatRecNo + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "dInputDate",
                                SortOrder: "desc"
                            }
                        ]
                    }
                    var result1 = SqlGetData(sqlObj1);
                    if (result1.length > 0) {
                        return result1[0];
                    }
                    else {
                        return null;
                    }
                }

                var iBscDataMatRecNo = data.iRecNo;
                var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                if (iBscDataCustomerRecNo != "" && iBscDataMatRecNo) {
                    var result = getCustColorID(iBscDataMatRecNo, iBscDataCustomerRecNo);
                    if (result != null) {
                        $("#table1").datagrid("updateRow", { index: rowIndex, row: result });
                    }
                }
            }
        }

        Page.afterSave = function () {
            var sPreviewOrderNo = Page.getFieldValue("sPreviewOrderNo");
            if (sPreviewOrderNo != "") {
                var jsonobjPreviewSDContractM = {
                    StoreProName: "SpPreviewSDContractMCopy",
                    StoreParms: [{
                        ParmName: "@iRecNo",
                        Value: Page.key
                    }, {
                        ParmName: "@iPreviewSDContractMRecNo",
                        Value: sCopyOrderNoInfoRecNo
                    }
                    ]
                }
                var resultPreviewSDContractM = SqlStoreProce(jsonobjPreviewSDContractM);
            }

            var str = "";
            for (var i = 0; i < serialData.length; i++) {
                str += serialData[i].iRecNo + "`" + serialData[i].iMainRecNo + "`" + serialData[i].iSerial + "`" + serialData[i].iBscDataProcessMRecNo + ",";
            }
            if (str != "") {
                str = str.substr(0, str.length - 1);
            }
            //var jsonobjSerial = {
            //    StoreProName: "SpSDContractMSerialSave",
            //    StoreParms: [{
            //        ParmName: "@iRecNo",
            //        Value: Page.key
            //    }, {
            //        ParmName: "@sStr",
            //        Value: str,
            //        Size: -1
            //    }
            //    ]
            //}
            //var resultSerial = SqlStoreProce(jsonobjSerial);

            var jsonobjSerial = {
                StoreProName: "SpSDContractMSaveBuildMatD",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }, {
                    ParmName: "@sUserID",
                    Value: Page.userid
                }
                ]
            }
            var resultSerial = SqlStoreProce(jsonobjSerial);

            var jsonobjSerial = {
                StoreProName: "SPSDContractMSaveCustomer",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var resultSerial = SqlStoreProce(jsonobjSerial);

            var jsonobjSerial = {
                StoreProName: "spSDContractDBatchsave",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                },
                {
                    ParmName: "@userid",
                    Value: Page.userid
                }
                ]
            }
            var resultSerial = SqlStoreProce(jsonobjSerial);
            var colorNotMust = getQueryString("colorNotMust");
            if (colorNotMust != "1") {
                var jsonobjCheckColor = {
                    StoreProName: "SpCheckOrderColorAfterSave",
                    StoreParms: [{
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@sStr",
                        Value: checkColorStr,
                        Size: -1
                    }
                    ]
                }
                var resultCheckColor = SqlStoreProce(jsonobjCheckColor);
                if (resultCheckColor != "1") {
                    alert(resultCheckColor);
                }
            }
            var param2 = Page.getQueryString("param2");
            ////如果不可以改工序，则保存后更新工序
            //if (param2 == "A") {
            var jsonobjMatProcess = {
                StoreProName: "SpSDContractDMatProcess",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                },
                {
                    ParmName: "@userid",
                    Value: Page.userid
                },
                {
                    ParmName: "@param",
                    Value: param2
                }
                ]
            }
            var resultMatProcess = SqlStoreProce(jsonobjMatProcess);
            //}
            if (iModifying == "1") {
                if (Page.usetype == "modify") {
                    //判断是否是变更
                    var jsonobj = {
                        StoreProName: "SpSDOrderMChangeSave",
                        StoreParms: [
                        {
                            ParmName: "@iformid",
                            Value: Page.iformid
                        },
                        {
                            ParmName: "@iRecNo",
                            Value: Page.key
                        },
                        {
                            ParmName: "@sUserID",
                            Value: Page.userid
                        }

                        ]
                    }
                    var result = SqlStoreProce(jsonobj);

                }
            }
        }

        Page.Formula = function (field) {
            if (field == "dOrderDate") {
                var dOrderDate = Page.getFieldValue("dOrderDate");
                Page.setFieldValue("dProduceDate", dOrderDate);
            }
        }
        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (iModifying == "1") {
                if (sModifyType == "主表信息变更") {
                    return false;
                }
                if (sModifyType == "子表次要信息变更") {
                    if (tableid == "table1" || tableid == "table3") {
                        var field = datagridOp.clickColumnName;
                        if (field == "sCustColorID" || field == "sPrintProductWidth" || field == "sPrintProductWeight" || field == "fPrice" || field == "sCustomerAsk" || field == "dOrderDate" || field == "sReMark" || field == "sCustColorName" || field == "sCustMatName" || field == "sEngCustMatName" || field == "sSampleBillNo" || field == "sAddMessage1" || field == "sAddMessage2") {
                            return true;
                        }
                        return false;
                    }
                }
            }

            if (tableid == "table3") {
                Page.setFieldValue("clickType", row.sType);
                var param1 = Page.getQueryString("param1");
                if (param1 == "A") {
                    if (clickfield == "sCode") {
                        Page.MessageShow("错误提示", "不能更改面布、底布");
                        return false;
                    }
                }
                if (param1 == "C") {
                    if (clickfield == "sCode") {
                        if (row.iIsBottom != 1) {
                            Page.MessageShow("错误提示", "不能更换面布");
                            return false;
                        }
                    }
                }

                if (clickfield == "sColorID") {
                    if (row.iIsBottom != 1) {
                        Page.MessageShow("错误提示", "只能更换底布颜色");
                        return false;
                    }
                }
            }
            if (tableid == "table1") {
                if (clickfield == "sCode" || clickfield == "sColorID" || clickfield == "fQty" || clickfield == "fProduceQty") {
                    var sqlObj1 = {
                        TableName: "SDContractDBatch",
                        Fields: "*",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.key + "' and iStatus=4"

                            }
                        ]

                    }
                    var result1 = SqlGetData(sqlObj1);
                    if (result1.length > 0) {
                        Page.MessageShow("错误提示", "生产计划已提交，订单明细的产品、颜色、数量不能更改，除非撤销计划");
                        return false;
                    }
                }
            }
        }
        Page.Children.onBeginEdit = function (tableid, index, row) {
            if (iModifying == "1") {
                if (sModifyType == "主表信息变更") {
                    return false;
                }
                if (tableid == "table1" || tableid == "table3") {
                    if (sModifyType == "子表次要信息变更") {
                        var field = datagridOp.currentColumnName;
                        if (field == "sCustColorID" || field == "sPrintProductWidth" || field == "sPrintProductWeight" || field == "fPrice" || field == "sCustomerAsk" || field == "dOrderDate" || field == "sReMark" || field == "sCustColorName" || field == "sCustMatName" || field == "sEngCustMatName" || field == "sSampleBillNo" || field == "sAddMessage1" || field == "sAddMessage2") {
                            return true;
                        }
                        return false;
                    }
                }
            }
        }

        function selectDemand() {
            var selectRows = $("#tabQu").datagrid("getChecked");
            if (selectRows.length > 0) {
                var Str = "";
                for (var i = 0; i < selectRows.length; i++) {
                    Str += selectRows[i].iSerial + "." + selectRows[i].sName + "\r\n";
                }
                Page.setFieldValue("sQualityDemand", Str);
                $("#divDemand").dialog("close");
            }
            else {
                Page.MessageShow("未选择任何行", "未选择任何行");
            }
        }
        var selectMainRecNo = undefined;
        var selectBscDataMatRecNo = undefined;
        function showSerail(iMainRecNo, tableid, iBscDataMatRecNo) {
            selectBscDataMatRecNo = iBscDataMatRecNo;
            currentTableID = tableid;
            selectMainRecNo = iMainRecNo;
            var result = serialData.filter(function (p) {
                return p.iMainRecNo == iMainRecNo;
            })
            result.sort(function (x, y) {
                return x.iSerial - y.iSerial;
            })
            $("#tabSerial").datagrid("loadData", result);
            for (var i = 0; i < result.length; i++) {
                $("#tabSerial").datagrid("beginEdit", i);
            }
            $("#divSerial").dialog("open");
        }

        function confirmSerial() {
            var allRow = $("#tabSerial").datagrid("getRows");
            var sSerialCheck = ",";
            var sSerialName = "";
            var iSerialCheckStr = ",";
            for (var i = 0; i < allRow.length; i++) {
                //if (sSerialCheck.indexOf("," + allRow[i].iBscDataProcessMRecNo + ",") > -1) {
                //    Page.MessageShow("工序不可重复", "工序不可重复");
                //    for (var j = 0; j < allRow.length; j++) {
                //        $("#tabSerial").datagrid("beginEdit", j);
                //    }
                //    return false;
                //}
                if (iSerialCheckStr.indexOf("," + allRow[i].iSerial + ",") > -1) {
                    Page.MessageShow("序号不能重复", "序号不能重复");
                    return false;
                }
                iSerialCheckStr += allRow[i].iSerial + ",";
                sSerialCheck += allRow[i].iBscDataProcessMRecNo + ",";
                var theProcessRow = bscDataProcessM.filter(function (p) {
                    return p.iRecNo == allRow[i].iBscDataProcessMRecNo;
                })
                try {
                    sSerialName += theProcessRow[0].sProcessesName + ",";
                }
                catch (e) {

                }
            }
            if (sSerialName.length > 0) {
                sSerialName = sSerialName.substr(0, sSerialName.length - 1);
            }
            for (var i = 0; i < originalSerialData.length; i++) {
                if (originalSerialData[i].iBscDataMatRecNo == currentBscDataMatRecNo) {
                    originalSerialData.splice(i, 1);
                    i--;
                }
            }
            for (var i = 0; i < allRow.length; i++) {
                originalSerialData.push(allRow[i]);
            }

            var dRows = $("#table1").datagrid("getRows");//订单明细数据
            for (var j = 0; j < dRows.length; j++) {
                if (dRows[j].iBscDataMatRecNo == currentBscDataMatRecNo) {
                    $("#table1").datagrid("updateRow", { index: j, row: { sProcesses: sSerialName } });
                }
            }
            $("#divSerial").dialog("close");
        }
        function addSerial() {
            var iRecNo = Page.getChildID("SDContractDProcessD");
            var iSerial = $("#tabSerial").datagrid("getRows").length + 1;
            var appendRow = { iRecNo: iRecNo, iSerial: iSerial, iMainRecNo: selectMainRecNo };
            $("#tabSerial").datagrid("appendRow", appendRow);
            var allRow = $("#tabSerial").datagrid("getRows");
            $("#tabSerial").datagrid("beginEdit", allRow.length - 1);
        }
        function deleteSerial() {
            var checkedRow = $("#tabSerial").datagrid("getChecked");
            if (checkedRow) {
                $.messager.confirm("确认删除吗？", "您确认删除所选择工序吗？", function (r) {
                    if (r) {
                        for (var i = 0; i < checkedRow.length; i++) {
                            var iRecNo = checkedRow[i].iRecNo;
                            for (var j = 0; j < serialData.length; j++) {
                                if (iRecNo == serialData[j].iRecNo) {
                                    serialData.splice(j, 1);
                                    break;
                                }
                            }
                            var rowindex = $("#tabSerial").datagrid("getRowIndex", checkedRow[i]);
                            $("#tabSerial").datagrid("deleteRow", rowindex);
                        }
                    }
                })
            }
        }

        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid == "tabSerial") {
                if (Page.isInited == true) {
                    var allRows = $("#tabSerial").datagrid("getRows");
                    $("#tabSerial").datagrid("updateRow", { index: allRows.length - 1, row: { iBscDataMatRecNo: currentBscDataMatRecNo, sName: currentSelectedRow.sName } });
                }
            }
        }

        Page.Children.onClickCell = function (tableid, index, field, value) {
            clickfield = field;
            if (tableid == "table1" || tableid == "table3") {
                if (field == "fStockQtyCanUse") {
                    var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                    //if (iBscDataCustomerRecNo == "" || iBscDataCustomerRecNo == null) {
                    //    Page.MessageShow("请先选择客户", "请先选择客户");
                    //    return;
                    //}
                    var theRow = $("#" + tableid).datagrid("getRows")[index];
                    var iBscDataMatRecNo = theRow.iBscDataMatRecNo;
                    var iBscDataColorRecNo = theRow.iBscDataColorRecNo;
                    if (iBscDataMatRecNo && iBscDataColorRecNo) {
                        var sqlObj = {
                            TableName: "MMStockQty", Fields: "sum(fQty) as fQty", SelectAll: "True",
                            Filters: [
                                { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'", LinkOprt: "and" },
                                { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + iBscDataColorRecNo + "'", LinkOprt: "and" },
                                { Field: "iBscDataStockMRecNo", ComOprt: "in", Value: " (134,192)" }
                                //,
                                //{ LeftParenthese: "(", Field: "iBscDataCustomerRecNo", ComOprt: "=", Value: "'" + iBscDataCustomerRecNo + "'", LinkOprt: "or" },
                                //{ Field: "isnull(iBscDataCustomerRecNo,0)", ComOprt: "=", Value: "0", RightParenthese: ")" }
                            ]
                        }
                        var result = SqlGetData(sqlObj);
                        if (result.length > 0) {
                            $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: (result[0].fQty ? result[0].fQty : 0) } });
                        } else {
                            $("#" + tableid).datagrid("updateRow", { index: index, row: { fStockQtyCanUse: 0 } });
                        }
                    }
                    else {
                        Page.MessageShow("产品或颜色不能为空", "产品或颜色不能为空");
                    }
                }
            }
        }

        viewpicifn = function () {
            var url = "/ZSERP/HH/SDContractDBatch.aspx?iformid=55634&usetype=modify&key=" + Page.key + "&r=" + Math.random();
            OpenWindow(url, "-1", "-1", "订单分批");
        }
        viewbaozhuangfn = function () {
            var url = "/ZSERP/HH/SDContractDMatAsk.aspx?iformid=55636&usetype=modify&key=" + Page.key + "&r=" + Math.random();

            OpenWindow(url, "-1", "-1", "订单分批");
        }
        OpenWindow = function (url, iWidth, iHeight) {

            iWidth = window.screen.availWidth;
            iHeight = window.screen.availHeight;
            var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
            var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
            var win = window.open(url, "", "width=" + iWidth + "px, height=" + iHeight + "px,top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
        }
        function getType(obj) {
            //tostring会返回对应不同的标签的构造函数
            var toString = Object.prototype.toString;
            var map = {
                '[object Boolean]': 'boolean',
                '[object Number]': 'number',
                '[object String]': 'string',
                '[object Function]': 'function',
                '[object Array]': 'array',
                '[object Date]': 'date',
                '[object RegExp]': 'regExp',
                '[object Undefined]': 'undefined',
                '[object Null]': 'null',
                '[object Object]': 'object'
            };
            if (obj instanceof Element) {
                return 'element';
            }
            return map[toString.call(obj)];
        }

        function deepClone(data) {
            var type = getType(data);
            var obj;
            if (type === 'array') {
                obj = [];
            } else if (type === 'object') {
                obj = {};
            } else {
                //不再具有下一层次
                return data;
            }
            if (type === 'array') {
                for (var i = 0, len = data.length; i < len; i++) {
                    obj.push(deepClone(data[i]));
                }
            } else if (type === 'object') {
                for (var key in data) {
                    obj[key] = deepClone(data[key]);
                }
            }
            return obj;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div>
        <div id="divHiden" style="display: none;">
            <!--隐藏字段位置-->
            <%-- <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sDeptID" />--%>
            <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iOrderType" />
            <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_NoSave="true" Z_FieldID="clickType" />
        </div>
        <table class="tabmain">
            <tr>
                <!--这里是主表字段摆放位置-->
                <td>订单号
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" />
                </td>
                <td>合同号
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sContractNo" />
                </td>
                <td>客户
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                </td>
                <td>签订日期
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                </td>
                <td>
                    <a class="button orange" onclick="viewpicifn()" id="viewpici" href="#" style="display: none;">查看批次</a>

                </td>
                <td></td>
                <td rowspan="6" id="showchange" style="vertical-align: top"></td>
                <%-- <td rowspan="5" style="width: 400px; height: 185px;"></td>--%>
            </tr>
            <tr>
                <td>订单类型
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sTradeType" />
                </td>
                <td>业务员
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSaleID" />
                </td>
                <td>所属部门
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox40" runat="server" Z_FieldID="sDeptID" />
                </td>
                <!--这里是主表字段摆放位置-->
                <td>订单交期
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="dOrderDate" Z_FieldType="日期" />
                </td>
                <td>
                    <a class="button orange" onclick="viewbaozhuangfn()" id="viewbaozhuang" href="#" style="display: none;">查看包装要求</a>

                </td>
                <%--<td colspan="2">
                                <label>
                                    <cc1:ExtCheckbox2 runat="server" ID="ExtCheckbox2" Z_FieldID="iBatch" />
                                    分批次
                                </label>

                            </td>--%>
                <%--                            <td>生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dProduceDate" Z_FieldType="日期" />
                            </td>--%>
            </tr>
            <tr>
                <td>计价单位
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sSaleUnitID" />
                </td>
                <td>币别
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBB" />
                </td>
                <td>付款方式
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sPayMethodID" />
                </td>
                <td>价格条款
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sPriceTerm" Style="width: 80px;" />
                    <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sPriceItemGk" Style="width: 70px;" />
                </td>
                <%--<td>订单类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="iOrderClass" />
                            </td>--%>

                <%--<td>贸易公司
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sTradeCompany" />
                            </td>--%>

                <%--<td>汇率
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fRate" />
                            </td>--%>
            </tr>
            <tr>

                <td>结算方式
                </td>
                <td colspan="3">
                    <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sMiddleCostName" Style="width: 99%" />
                </td>
                <td>订单要求
                </td>
                <td colspan="3" rowspan="2">
                    <cc1:ExtTextArea2 ID="ExtTextArea3" Style="width: 99%; height: 99%; float: left;" Z_FieldID="sQualityDemand" runat="server" />
                </td>
                <td>
                    <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="附件" />
                </td>

            </tr>
            <tr>

                <td>目的地
                </td>
                <td colspan="3">

                    <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sDESTINATION" Style="width: 99%" />
                </td>

            </tr>
            <tr>
                <td>返单号
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="sPreviewOrderNo" />
                </td>
                <td>批次
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iBatchNum" Z_FieldType="整数" />
                </td>
                <td>复合要求
                </td>
                <td colspan="3">
                    <cc1:ExtTextArea2 ID="ExtTextArea2" Style="width: 99%; height: 100%; float: left;" Z_FieldID="sComRemark" runat="server" />
                </td>
            </tr>
            <tr style="display: none">
                <td>总数量
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                        Z_FieldID="fQty" Z_FieldType="数值" />
                </td>
                <td>总金额
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                        Z_FieldID="fTotal1" Z_FieldType="数值" Z_NoSave="true" Style="display: none;" />
                    <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                        Z_FieldID="fTotal2" Z_FieldType="数值" Z_NoSave="true" Style="display: none;" />
                    <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_decimalDigits="2" Z_readOnly="true"
                        Z_FieldID="fTotal" Z_FieldType="数值" />
                </td>
                <td>制单人
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                </td>
                <!--这里是主表字段摆放位置-->
                <td>制单日期
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                        Z_readOnly="true" />
                </td>

                <td>&nbsp;
                </td>
            </tr>
            <tr style="display: none;">

                <td>备注
                </td>
                <td colspan="5">
                    <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Style="width: 99%" />
                </td>

            </tr>
            <tr style="display: none;">
                <td>
                    <div data-options="title:'验布要求',fit:true,border:false">
                        <table class="tabmain">
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td>计量单位
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sUnitID" Style="width: 150px;" />
                                </td>
                                <td>卷号生成规格
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="iReelNoBulidType" Style="width: 150px;" />
                                </td>
                                <td>前缀
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sReelNoPre" Style="width: 150px;" />
                                </td>
                                <td>流水位数
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReelNoFlag" Style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                                <td>打印模板
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="iPrintMoudleRecNo" Style="width: 150px;" />
                                </td>
                                <td>打印份数(内/外)
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iPrintCount" Z_FieldType="数值"
                                        Z_decimalDigits="0" Style="width: 70px;" />
                                    <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="iPackPrintCount" Z_FieldType="数值"
                                        Z_decimalDigits="0" Style="width: 70px;" />
                                </td>
                                <td>合格证模板
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="iPrintMoudleRecNo2"
                                        Style="width: 150px;" />
                                </td>
                                <td>允许卷号空号
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iAllowBlankReelNo" Style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>

                                <td>打印二次包装模板
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="iPackPrintMoudleRecNo" Style="width: 150px;" />
                                </td>

                                <td>
                                    <label>
                                        允许同缸号卷号不连续<cc1:ExtCheckbox2 runat="server" ID="ExtCheckbox1" Z_FieldID="iAllowVatNoReelNoDiscontinuities" />
                                    </label>
                                </td>
                                <td></td>
                                <td>纸管重量(KG)
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fPaperTube" Z_FieldType="数值"
                                        Z_decimalDigits="2" Style="width: 150px;" />
                                </td>
                                <td>差额重量(KG)
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fMargin" Z_FieldType="数值"
                                        Z_decimalDigits="2" Style="width: 150px;" />
                                </td>
                            </tr>
                            <tr>
                            </tr>
                            <tr>
                            </tr>
                        </table>
                    </div>
                    <div title="条码生成规则" style="display: none;">
                        <!--  子表1  -->
                        <table id="table2" tablename="SDContractDBarcodeRule">
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div data-options="region:'center',border:false ">
        <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
        <div id="divTabs1" class="easyui-tabs" data-options="border:false">
            <div id="divTabs11" title="订单明细">
                <!--  子表1  -->
                <table id="table1" tablename="SDContractD">
                </table>
            </div>
            <div data-options="fit:true" title="其它费用">
                <!--  子表1  -->
                <table id="table4" tablename="SDContractDOtherCost">
                </table>
            </div>
            <div data-options="fit:true" title="复合用料">
                <!--  子表1  -->
                <table id="table3" tablename="SDContractD1">
                </table>
            </div>
        </div>
    </div>
    <div id="divDemand" class="easyui-dialog" data-options="title:'选择质量要求',closed:true,width:800,height:400,buttons:[{text:'确定',handler:selectDemand},{text:'取消',handler:function(){ $('#divDemand').dialog('close'); }}]">
        <table id="tabQu" class="easyui-datagrid" data-options="fit:true,border:false,remoteSort:false">
            <thead>
                <tr>
                    <th data-options="field:'__cb',checkbox:true,width:40"></th>
                    <th data-options="field:'iSerial',width:40">序号</th>
                    <th data-options="field:'sName',width:500">名称</th>
                </tr>
            </thead>
        </table>
    </div>
    <div id="divSerial" class="easyui-dialog" data-options="title:'工序设置',width:600,height:300,
        closed:true,modal:true,minimizable:false,collapsible:false,closable:true,
        buttons:[{text:'确定',handler:confirmSerial},{text:'取消',handler:function(){$('#divSerial').dialog('close')}}]">
        <table id="tabSerial" tablename="SDContractDMatProcess"></table>
    </div>
    <div id="divSerialMenu" style="display:none;">
        <table>
            <tr>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addSerial()">增加</a>
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deleteSerial()">删除</a>
                </td>
                <td>
                    <input id="Checkbox1" type="checkbox" checked="checked" />
                    <label for="Checkbox1">同产品工序相同</label>
                </td>
            </tr>
        </table>
    </div>
    <div id="divFhMatUse" class="easyui-dialog" data-options="title:'复合用料设置',width:900,height:500,
        closed:true,modal:true,minimizable:false,collapsible:false,closable:true,
        buttons:[{text:'确定',handler:confirmSerial},{text:'取消',handler:function(){$('#divSerial').dialog('close')}}]">
        <%--<table id="tabFhMatUse"></table>--%>
    </div>
</asp:Content>
