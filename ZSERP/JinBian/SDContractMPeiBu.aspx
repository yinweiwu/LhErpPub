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

        $(function () {

            $("#divTabs").tabs("disableTab", "验布要求")
            //table2
           
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
                Page.Children.toolBarBtnDisabled("table3", "delete");
                Page.Children.toolBarBtnDisabled("table3", "copy");
            }
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
                                    if (sModifyType == "合同主表变更") {
                                        Page.Children.toolBarBtnDisabled("table1", "add");
                                        Page.Children.toolBarBtnDisabled("table1", "delete");
                                        Page.Children.toolBarBtnDisabled("table1", "copy");
                                    }
                                    else if (sModifyType == "产品明细变更") {
                                        Page.mainDisabled();
                                    }
                                    else if (sModifyType == "全部变更") {
                                        //Page.mainDisabled();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (Page.usetype != "view") {
                var sqlObjDemand = {
                    TableName: "bscDataListD",
                    Fields: "iSerial,sName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "sClassID", ComOprt: "=", Value: "'TechAsk'"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "iSerial", SortOrder: "asc"
                        }
                    ]
                }
                var resultDemand = SqlGetData(sqlObjDemand);
                $("#tabQu").datagrid("loadData", resultDemand);

                var sqlObjSerial = {
                    TableName: "BscDataProcessesM",
                    Fields: "sProcessesName,iRecNo",
                    SelectAll: "True"
                }
                var resultSerial = SqlGetData(sqlObjSerial);
                bscDataProcessM = resultSerial;

                $("#tabSerial").datagrid({
                    fit: true,
                    border: false,
                    columns: [
                        [
                            { field: "__cb", checkbox: true, width: 40, align: "center" },
                            {
                                field: "iSerial", title: "序号", width: 40, align: "center",
                                editor: { type: "numberbox", options: { height: 35 } }
                            },
                            {
                                field: "iBscDataProcessMRecNo", title: "工序", width: 80, align: "center",
                                editor: {
                                    type: "combobox",
                                    options: { valueField: "iRecNo", textField: "sProcessesName", height: 35, data: resultSerial }
                                }
                            },
                            {
                                field: "iRecNo", hidden: true
                            }
                        ]
                    ],
                    remoteSort: false,
                    toolbar: "#divSerialMenu"
                })

                //Page.Children.toolBarBtnAdd("table1", "editProcess", "工序设置", null, function () {
                //    currentTableID = "table1";
                //    var selectRow = $("#table1").datagrid("getChecked");
                //    if (selectRow.length > 0) {
                //        var iRecNo = selectRow[0].iRecNo;
                //        selectBscDataMatRecNo = selectRow[0].iBscDataMatRecNo;
                //        showSerail(iRecNo);
                //    }
                //    else {
                //        Page.MessageShow("请选择一行", "请选择一行");
                //    }
                //})

                Page.Children.toolBarBtnAdd("table3", "importMat", "导入复合原料", null, function () {
                    var doImport = function () {
                        canAddRow = true;
                        var allRows = $("#table1").datagrid("getRows");
                        var fuRows = allRows.filter(function (p) {
                            return p.bMergeMat == 1;
                        })
                        if (fuRows.length > 0) {
                            for (var i = 0; i < fuRows.length; i++) {
                                var iBscDataMatRecNo = fuRows[i].iBscDataMatRecNo;
                                var SqlObj1 = {
                                    TableName: "vwBscDataMatDWaste",
                                    Fields: "iBscDataMatRecNo,sCode,sName",
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
                                            sCode: result1[j].sCode,
                                            sName: result1[j].sName,
                                            sColorID: fuRows[i].sColorID,
                                            fQty: fuRows[i].fQty,
                                            iBscDataMatRecNo: result1[j].iBscDataMatRecNo,
                                            iBscDataColorRecNo: fuRows[i].iBscDataColorRecNo,
                                            iIsComposite: 1,
                                            iSDContractDRecNo: fuRows[i].iRecNo
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
                                while (allRowsFu.length > 0) {
                                    var rowindex = $("#table3").datagrid("getRowIndex", allRowsFu[0]);
                                    $("#table3").datagrid("deleteRow", rowindex);
                                }
                                doImport();
                            }
                        });
                    }
                    else {
                        doImport();
                    }
                })

                //Page.Children.toolBarBtnAdd("table3", "editProcess", "工序设置", null, function () {
                //    currentTableID = "table3";
                //    var selectRow = $("#table3").datagrid("getChecked");
                //    if (selectRow.length > 0) {
                //        var iRecNo = selectRow[0].iRecNo;
                //        selectBscDataMatRecNo = selectRow[0].iBscDataMatRecNo;
                //        showSerail(iRecNo);
                //    }
                //    else {
                //        Page.MessageShow("请选择一行", "请选择一行");
                //    }
                //})

                var options = $("#table1").datagrid("options");
                delete options.url;
                for (var i = 0; i < options.columns[0].length; i++) {
                    //if (options.columns[0][i].field == "sProcesses") {
                    //    options.columns[0][i].formatter = function (value, row, index) {
                    //        if (row.iRecNo) {
                    //            if (row.sProcesses) {
                    //                return "<a href='#' onclick='showSerail(" + row.iRecNo + ",&apos;table1&apos;," + row.iBscDataMatRecNo + ")'>" + row.sProcesses + "</a>";
                    //            } else {
                    //                return "<a href='#' onclick='showSerail(" + row.iRecNo + ",&apos;table1&apos;," + row.iBscDataMatRecNo + ")'>设置工序</a>";
                    //            }
                    //        }
                    //    }
                    //}
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
                    //if (options1.columns[0][i].field == "sProcesses") {
                    //    options1.columns[0][i].formatter = function (value, row, index) {
                    //        if (row.iRecNo) {
                    //            if (row.sProcesses) {
                    //                return "<a href='#' onclick='showSerail(" + row.iRecNo + ",&apos;table3&apos;," + row.iBscDataMatRecNo + ")'>" + row.sProcesses + "</a>";
                    //            } else {
                    //                return "<a href='#' onclick='showSerail(" + row.iRecNo + ",&apos;table3&apos;," + row.iBscDataMatRecNo + ")'>设置工序</a>";
                    //            }
                    //        }
                    //    }
                    //}
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
                //if (Page.usetype == "add") {
                //    var allLoadRows = $("#table3").datagrid("getRows");
                //    for (var i = 0; i < allLoadRows.length; i++) {
                //        allLoadRows[i].sProcesses = "设置工序";
                //    }
                //    $("#table3").datagrid("loadData", allLoadRows);
                //}

            }
            if (Page.usetype != "add") {
                var sqlObj = {
                    TableName: "SDContractDProcessD",
                    Fields: "iRecNo,iMainRecNo,iBscDataProcessMRecNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "in",
                            Value: "(select iRecNo from sdcontractd where iMainRecNo='" + Page.key + "')"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "iMainRecNo",
                            SortOrder: "asc"
                        }

                    ]
                }
                var result = SqlGetData(sqlObj);
                serialData = result;
            } else if (Page.getQueryString("copyKey") != null) {
                var copyKey = Page.getQueryString("copyKey");
                var sqlObj = {
                    TableName: "SDContractDProcessD",
                    Fields: "iRecNo,iMainRecNo,iBscDataProcessMRecNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "in",
                            Value: "(select iRecNo from sdcontractd where iMainRecNo='" + copyKey + "')"
                        }
                    ],
                    Sorts: [
                        {
                            SortName: "iMainRecNo",
                            SortOrder: "asc"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                serialData = result;
            }
            $("#table3").attr("tablename", "SDContractD");

        })


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

            var allRows = $("#table1").datagrid("getRows");
           
            for (var i = 0; i < allRows.length; i++) {

                if (allRows[i].bMergeMat == 1 && parseInt(allRows[i].fProduceQty) > 0) {
                    var frows = $("#table3").datagrid("getRows");
                    if (frows.length == 0) {
                        Page.MessageShow("产品第[" + (i + 1) + "]行,没有设置复合用料","");
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
                        Page.MessageShow("产品第[" + (i + 1) + "]行,没有设置复合用料", "");
                        return false;
                    }


                }
            }

            var schongfu = "";

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
            }
           

            //var allRows = $("#table1").datagrid("getRows");
            //for (var i = 0; i < allRows.length; i++) {
            //    var isIn = serialData.filter(function (p) {
            //        return p.iMainRecNo == allRows[i].iRecNo;
            //    })
            //    if (isIn.length == 0 && allRows[i].iType != 1) {
            //        Page.MessageShow("第" + (i + 1) + "行明细未设置工序", "注意，第" + (i + 1) + "行订单明细未设置工序");
            //        return false;
            //    }
            //}
            //var allRows1 = $("#table3").datagrid("getRows");
            //for (var i = 0; i < allRows1.length; i++) {
            //    var isIn = serialData.filter(function (p) {
            //        return p.iMainRecNo == allRows1[i].iRecNo;
            //    })
            //    if (isIn.length == 0 && allRows1[i].iType != 1) {
            //        Page.MessageShow("第" + (i + 1) + "行复合用料明细未设置工序", "注意，第" + (i + 1) + "行订单复合用料明细未设置工序");
            //        return false;
            //    }
            //}
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


        }
        Page.Formula = function (field) {
            if (field == "dOrderDate") {
                var dOrderDate = Page.getFieldValue("dOrderDate");
                Page.setFieldValue("dProduceDate", dOrderDate);
            }

        }
        Page.Children.onBeforeEdit = function (tableid, index, row) {
            if (iModifying == "1") {
                if (sModifyType == "合同主表变更") {
                    if (tableid == "table2") {
                        return true;
                    }
                    else {
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
            for (var i = 0; i < allRow.length; i++) {
                $("#tabSerial").datagrid("endEdit", i);
            }
            var allRow = $("#tabSerial").datagrid("getRows");
            var sSerialCheck = ",";
            var sSerialName = "";
            for (var i = 0; i < allRow.length; i++) {
                if (sSerialCheck.indexOf("," + allRow[i].iBscDataProcessMRecNo + ",") > -1) {
                    Page.MessageShow("工序不可重复", "工序不可重复");
                    for (var j = 0; j < allRow.length; j++) {
                        $("#tabSerial").datagrid("beginEdit", j);
                    }
                    return false;
                }
                sSerialCheck += allRow[i].iBscDataProcessMRecNo + ",";
                var theProcessRow = bscDataProcessM.filter(function (p) {
                    return p.iRecNo == allRow[i].iBscDataProcessMRecNo;
                })
                sSerialName += theProcessRow[0].sProcessesName + ",";
            }
            if (sSerialName.length > 0) {
                sSerialName = sSerialName.substr(0, sSerialName.length - 1);
            }
            for (var i = 0; i < allRow.length; i++) {
                var isExists = false;
                for (var j = 0; j < serialData.length; j++) {
                    if (allRow[i].iRecNo == serialData[j].iRecNo) {
                        isExists = true;
                        serialData[j].iSerial = allRow[i].iSerial;
                        serialData[j].iBscDataProcessMRecNo = allRow[i].iBscDataProcessMRecNo;
                        break;
                    }
                }
                if (isExists == false) {
                    serialData.push(allRow[i]);
                }
            }

            var dRows = $("#" + currentTableID).datagrid("getRows");//订单明细数据
            for (var j = 0; j < dRows.length; j++) {
                if (dRows[j].iRecNo == selectMainRecNo) {
                    $("#" + currentTableID).datagrid("updateRow", { index: j, row: { sProcesses: sSerialName } });
                    break;
                }
            }
            //其他同产品是否要增加
            var isOtherSame = $("#Checkbox1")[0].checked;//是否同产品工序一致
            if (isOtherSame) {

                var iBscDataMatRecNo = selectBscDataMatRecNo;//产品主键
                //同产品的订单子表行
                var theSameRows = dRows.filter(function (p) {
                    return (p.iBscDataMatRecNo == iBscDataMatRecNo && p.iRecNo != selectMainRecNo);
                });
                for (var j = 0; j < theSameRows.length; j++) {
                    var theRowIndex = $("#" + currentTableID).datagrid("getRowIndex", theSameRows[j]);
                    $("#" + currentTableID).datagrid("updateRow", { index: theRowIndex, row: { sProcesses: sSerialName } });
                    //是否已设置了工序
                    var theSerailExists = serialData.filter(function (p) {
                        return p.iMainRecNo == theSameRows[j].iRecNo;
                    })
                    //如果已设置了工序
                    if (theSerailExists.length > 0) {
                        //var gsarr = [];
                        for (var k = 0; k < allRow.length; k++) {
                            //工序是否在已设置的工序中
                            var isIn = theSerailExists.filter(function (p) {
                                return p.iBscDataProcessMRecNo == allRow[k].iBscDataProcessMRecNo;
                            });
                            //在的话，更新serialData中的数据
                            if (isIn.length > 0) {
                                //gsarr.push(allRow[k].iBscDataProcessMRecNo);
                                for (var l = 0; l < serialData.length; l++) {
                                    if (serialData[l].iRecNo == allRow[k].iRecNo) {
                                        serialData[l].iSerial = allRow[k].iSerial;
                                        serialData[l].iBscDataProcessMRecNo = allRow[k].iBscDataProcessMRecNo;
                                        break;
                                    }
                                }
                            }//不在的话，向serialData插入
                            else {
                                //gsarr.push(allRow[k].iBscDataProcessMRecNo);
                                var oneSerial = {};
                                oneSerial.iSerial = allRow[k].iSerial;
                                oneSerial.iBscDataProcessMRecNo = allRow[k].iBscDataProcessMRecNo;
                                oneSerial.iMainRecNo = theSameRows[j].iRecNo;
                                oneSerial.iRecNo = Page.getChildID("SDContractDProcessD");
                                serialData.push(oneSerial);
                            }
                        }
                        //在theSerailExists但不在allRow中的删除
                        for (var k = 0; k < theSerailExists.length; k++) {
                            var isIn = allRow.filter(function (p) {
                                return p.iBscDataProcessMRecNo == theSerailExists[k].iBscDataProcessMRecNo;
                            });
                            if (isIn.length == 0) {
                                for (var l = 0; l < serialData.length; l++) {
                                    if (serialData[l].iRecNo == theSerailExists[k].iRecNo) {
                                        serialData.splice(l, 1);
                                        break;
                                    }
                                }
                            }
                        }
                    } else {//如果尚未设置工序
                        for (var k = 0; k < allRow.length; k++) {
                            var oneSerial = {};
                            oneSerial.iSerial = allRow[k].iSerial;
                            oneSerial.iBscDataProcessMRecNo = allRow[k].iBscDataProcessMRecNo;
                            oneSerial.iMainRecNo = theSameRows[j].iRecNo;
                            oneSerial.iRecNo = Page.getChildID("SDContractDProcessD");
                            serialData.push(oneSerial);
                        }
                    }
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

        Page.Children.onBeforeAddRow = function (tableid) {
            if (tableid == "table3") {
                if (canAddRow == false) {
                    return false;
                }
            }
        }

        Page.Children.onClickCell = function (tableid, index, field, value) {
            if (tableid == "table1" || tableid == "table3") {
                if (field == "fStockQtyCanUse") {
                    var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
                    if (iBscDataCustomerRecNo == "" || iBscDataCustomerRecNo == null) {
                        Page.MessageShow("请先选择客户", "请先选择客户");
                        return;
                    }
                    var theRow = $("#" + tableid).datagrid("getRows")[index];
                    var iBscDataMatRecNo = theRow.iBscDataMatRecNo;
                    var iBscDataColorRecNo = theRow.iBscDataColorRecNo;
                    if (iBscDataMatRecNo && iBscDataColorRecNo) {
                        var sqlObj = {
                            TableName: "MMStockQty", Fields: "sum(fQty) as fQty", SelectAll: "True",
                            Filters: [
                                { Field: "iBscDataMatRecNo", ComOprt: "=", Value: "'" + iBscDataMatRecNo + "'", LinkOprt: "and" },
                                { Field: "iBscDataColorRecNo", ComOprt: "=", Value: "'" + iBscDataColorRecNo + "'", LinkOprt: "and" },
                                { LeftParenthese: "(", Field: "iBscDataCustomerRecNo", ComOprt: "=", Value: "'" + iBscDataCustomerRecNo + "'", LinkOprt: "or" },
                                { Field: "isnull(iBscDataCustomerRecNo,0)", ComOprt: "=", Value: "0", RightParenthese: ")" }
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

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="height: 220px; overflow: hidden;">
            <div id="divTabs" class="easyui-tabs" data-options="fit:true">
                <div data-options="title:'订单信息',fit:true,border:false">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <%-- <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sDeptID" />--%>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iOrderType" />
                    </div>
                    <!--主表部分-->
                    <table class="tabmain" >
                        
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_readOnly="true" />
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

                            <%-- <td rowspan="5" style="width: 400px; height: 185px;"></td>--%>
                        </tr>
                        <tr>
                            <td>销售类型
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
                            <td>订单类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="iOrderClass" />
                            </td>
                            <td>批次
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iBatchNum" Z_FieldType="整数" />
                            </td>
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
                            <td>目的地
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sDESTINATION" Style="width: 99%" />
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
                        <tr>
                            <td>翻单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="sPreviewOrderNo" />
                            </td>
                            <td>备注
                            </td>
                            <td colspan="5">
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Style="width: 99%" />
                            </td>
                            <td>
                                <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="附件" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="title:'订单要求',fit:true,border:false">
                    <table class="tabmain">
                        <tr>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="8">结算方式：定金<cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iSubscription" Z_FieldType="整数" Style="width: 35px;" Z_Required="true" />
                                %&nbsp;&nbsp;<cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sMiddleCostName" Style="width: 99px;" />
                                <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="iMiddleCost" Z_FieldType="整数" Style="width: 36px;" Z_Required="true" />

                                %&nbsp; 尾款
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iEndCost" Z_FieldType="整数" Style="width: 32px;" Z_Required="true" />

                                %
                            </td>

                        </tr>
                        <tr>
                            <td>订单要求
                            </td>
                            <td colspan="7" style="vertical-align: middle;">
                                <cc1:ExtTextArea2 ID="ExtTextArea3" Style="width: 500px; height: 100px; float: left;" Z_FieldID="sQualityDemand" runat="server" />
                                <%--<input id="Button1" type="button" value="..." style="width: 30px; height: 100px; float: left;" onclick="$('#divDemand').dialog('open')" />--%>
                            </td>
                            <%--<td>包装要求
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea4" Style="width: 300px; height: 100px;" Z_FieldID="sPackDemand" runat="server" />
                            </td>--%>
                            <%--</tr>
                        <tr>
                            <td>交换地址
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea5" Style="width: 500px; height: 60px;" Z_FieldID="sDeliveryAddress" runat="server" />
                            </td>--%>
                        </tr>
                    </table>
                </div>
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
            </div>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTabs1" class="easyui-tabs" data-options="fit:true,border:false">
                <div id="divTabs11" data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDContractD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="其它费用">
                    <!--  子表1  -->
                    <table id="table4" tablename="SDContractDOtherCost">
                    </table>
                </div>
                <div data-options="fit:true" title="复合用料">
                    <!--  子表1  -->
                    <table id="table3" tablename="SDContractD1">
                    </table>
                </div>--%>
                <div data-options="fit:true" title="条码生成规则">
                    <!--  子表1  -->
                    <table id="table2" tablename="SDContractDBarcodeRule">
                    </table>
                </div>
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
    <div id="divSerial" class="easyui-dialog" data-options="title:'工序设置',width:260,height:400,
        closed:true,modal:true,minimizable:false,collapsible:false,closable:true,
        buttons:[{text:'确定',handler:confirmSerial},{text:'取消',handler:function(){$('#divSerial').dialog('close')}}]">
        <table id="tabSerial"></table>
    </div>
    <div id="divSerialMenu">
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
