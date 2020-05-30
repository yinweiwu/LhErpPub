<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        /*.style1
        {
            width: 843px;
        }*/
        .style2 {
            width: 72px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var isFishiLoaded = false;
        $(function () {
            Page.Children.toolBarBtnDisabled("ProPlanD", "add");
            Page.Children.toolBarBtnDisabled("SDOrderD", "delete");
            Page.Children.toolBarBtnDisabled("ProPlanD", "copy");

            if (Page.usetype == "add" || Page.usetype == "modify") {
                $("#tabTop").tabs({
                    tools: [{
                        iconCls: 'icon-search',
                        handler: function () {
                            searchSDOrderM();
                        }
                    }
                    ],
                    onSelect: function (title, index) {
                        if (index == 2) {
                            //if (isFishiLoaded == false) {
                            //    $.messager.progress({ title: "正在加载，请稍候..." });
                            //    setTimeout(function () {
                            //        searchFinishSDOrderM();
                            //        isFishiLoaded = true;
                            //        $.messager.progress("close");
                            //    }, 500);

                            //}
                        }
                    }
                });

                $("#SDOrderM").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: false,
                    columns: [[
                        { checkbox: true, field: "", width: 50, rowspan: 2 },
                        { title: "订单号", field: "sBatchOrderNo", width: 100, sortable: true, rowspan: 2 },
                        //{ title: "染色", field: "btnPro", width: 80, align: "center", formatter: function (value, row, index) {
                        //    var str = JSON2.stringify(row);
                        //    var btnStr = "<input id='btn" + index + "' type='button' onclick='btnPro(" + str + ", " + index + ")' value='染色' />";
                        //    return btnStr;
                        //}
                        //},
                        { title: "产品编码", field: "sCode", width: 80, sortable: true, rowspan: 2 },
                        { title: "产品名称", field: "sName", width: 100, sortable: true, rowspan: 2 },
                        { title: "幅宽", field: "fProductWidth", width: 40, sortable: true, rowspan: 2 },
                        { title: "克重", field: "fProductWeight", width: 40, sortable: true, rowspan: 2 },
                        { title: "颜色", field: "sColorName", width: 80, sortable: true, rowspan: 2 },
                        { title: "本厂色号", field: "sProduceColorID", width: 60, sortable: true, rowspan: 2 },
                        { title: "工序", field: "sProcessesName", width: 60, sortable: true, rowspan: 2 },
                        { title: "工艺", field: "sFlowerTypeAndID", width: 60, sortable: true, rowspan: 2 },
                        { title: "加工厂家", field: "sProduceCustShortName", width: 80, sortable: true, rowspan: 2 },
                        { title: "需求", colspan: 2 },
                        { title: "应投料", colspan: 3 },
                        { title: "已投料", colspan: 3 },
                        { title: "未投料", colspan: 3 },
                        //{ title: "完成", field: "btnFinsiPro", width: 80, formatter: function (value, row, index) {
                        //    var btnFinishStr = "<input id='btnFinish" + index + "' type='button' onclick='btnFinishPro(" + index + ")' value='完成' />";
                        //    return btnFinishStr;
                        //}
                        //},
                        { title: "完成", field: "sPrcessFinish", width: 80, sortable: true, rowspan: 2 },
                        { title: "单价", field: "fPrice", width: 80, sortable: true, rowspan: 2 },
                        { title: "计价单位", field: "sCalcUnitName", width: 80, sortable: true, rowspan: 2 },
                        { title: "计价方式", field: "sProduceType", width: 80, sortable: true, rowspan: 2 },
                        { title: "交期", field: "sDelivery", width: 80, sortable: true, rowspan: 2 },
                        { field: "iRecNo", hidden: true, rowspan: 2 },
                        { field: "iSDOrderMRecNo", hidden: true, rowspan: 2 }
                    ], [
                        { title: "重量", field: "fNeedWeight", width: 60, sortable: true },
                        { title: "米数", field: "fNeedQty", width: 60, sortable: true },

                        { title: "匹数", field: "iQty", width: 40, sortable: true },
                        { title: "重量", field: "fFeedWeight", width: 60, sortable: true },
                        { title: "米数", field: "fFeedQty", width: 60, sortable: true },

                        { title: "匹数", field: "iProcessQty", width: 40, sortable: true },
                        { title: "重量", field: "fPrcessWeight10", width: 60, sortable: true },
                        { title: "米数", field: "fPrcessQty10", width: 60, sortable: true },

                        { title: "匹数", field: "iNotPrcessQty10", width: 40, sortable: true },
                        { title: "重量", field: "fNotPrcessWeight10", width: 60, sortable: true },
                        { title: "米数", field: "fNotPrcessQty10", width: 60, sortable: true }
                    ]],
                    onDblClickRow: function (index, row) {
                        //btnPro(row, index);
                    }
                }
                );
                //$("#SDOrderMFinish").datagrid(
                //{
                //    fit: true,
                //    border: false,
                //    remoteSort: false,
                //    singleSelect: true,
                //    columns: [[
                //        { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                //        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                //        { title: "产品名称", field: "sName", width: 120, sortable: true },
                //        { title: "幅宽", field: "fProductWidth", width: 60, sortable: true },
                //        { title: "克重", field: "fProductWeight", width: 60, sortable: true },
                //        { title: "坯布编号", field: "sBscDataFabCode", width: 80, sortable: true },
                //        { title: "坯布名称", field: "sBscDataFabName", width: 80, sortable: true },
                //        { title: "需坯布重量", field: "fNeedFabQty", width: 80, sortable: true },
                //        { title: "未点色重量", field: "fNotDyeQty", width: 80, sortable: true },
                //        { title: "已点色重量", field: "fDyeQty", width: 80, sortable: true },
                //        { title: "业务员", field: "sOrderUserName", width: 80, sortable: true },
                //        { title: "完成类型", field: "sFinishType", width: 80, sortable: true },
                //        { title: "撤销完成", field: "btnCancelFinish", width: 80, formatter: function (value, row, index) {
                //            if (row.sFinishType == "手动完成") {
                //                var btnFinishStr = "<input id='btnCancelFinish" + index + "' type='button' onclick='btnCancelFinish(" + index + ")' value='撤销完成' />";
                //                return btnFinishStr;
                //            }
                //        }
                //        },
                //        { field: "iRecNo", hidden: true },
                //        { field: "iSdOrderMRecNo", hidden: true }
                //    ]],
                //    onDblClickRow: function (index, row) {
                //        btnPro(row, index);
                //    },
                //    pagination: true,
                //    pageSize: 30,
                //    pageList: [30, 100, 300, 500],
                //    loadFilter: pagerFilter
                //}
                //);

                //searchSDOrderM();
                //searchFinishSDOrderM();
                if (Page.usetype == "modify" || Page.usetype == "view") {
                    $("#tabTop").tabs("select", 1);
                }
                //if (Page.usetype = "add") {
                //    var sqlObjAsk = {
                //        TableName: "bscDataListD", Fields: "sName,iSerial", SelectAll: "True",
                //        Filters: [{
                //            Field: "sClassID", ComOprt: "=", Value: "'dyeAsk'"
                //        }], Sorts: [{ SortName: "iSerial", SortOrder: "asc" }]
                //    }
                //    var resultAsk = SqlGetData(sqlObjAsk);
                //    for (var i = 0; i < resultAsk.length; i++) {
                //        var appRow = { iSerial: resultAsk[i].iSerial, sAsk: resultAsk[i].sName };
                //        Page.tableToolbarClick("add", "Table2", appRow);
                //    }
                //}

                Page.Children.toolBarBtnAdd("ProPlanD", "btnSyn", "从染色同步染厂克重", "down", function () {
                    var iSDContractMRecNo = Page.getFieldValue("iSDContractMRecNo");
                    var iBscDataMatRecNo = Page.getFieldValue("iBscDataMatRecNo");
                    var sBatchNum = Page.getFieldValue("sBatchNum");
                    var sqlObjD = {
                        TableName: "ProPlanD as a inner join ProPlanM as b on a.iMainRecNo=b.iRecNo", Fields: "a.iBscDataColorRecNo,a.sRcProductWeight", SelectAll: "True",
                        Filters: [
                            { Field: "b.iSDContractMRecNo", ComOprt: "=", Value: iSDContractMRecNo, LinkOprt: "and" },
                            //{ Field: "b.iBscDataMatRecNo", ComOprt: "=", Value: iBscDataMatRecNo, LinkOprt: "and" },
                            { Field: "b.sBatchNum", ComOprt: "=", Value: "'" + sBatchNum + "'", LinkOprt: "and" },
                            { LeftParenthese: "(", Field: "b.iBscDataProcessMRecNo", ComOprt: "=", Value: 6, LinkOprt: "or" },
                            { Field: "b.iBscDataProcessMRecNo", ComOprt: "=", Value: 35, LinkOprt: "or" },
                            { Field: "b.iBscDataProcessMRecNo", ComOprt: "=", Value: 57, RightParenthese: ")" }
                        ]
                    }
                    var resultD = SqlGetData(sqlObjD);
                    if (resultD.length > 0) {
                        var allRows = $("#ProPlanD").datagrid("getRows");
                        for (var i = 0; i < resultD.length; i++) {
                            var theRows = allRows.filter(function (p) {
                                return p.iBscDataColorRecNo == resultD[i].iBscDataColorRecNo;
                            });
                            for (var j = 0; j < theRows.length; j++) {
                                var theRowIndex = $("#ProPlanD").datagrid("getRowIndex", theRows[j]);
                                $("#ProPlanD").datagrid("updateRow", { index: theRowIndex, row: { sRcProductWeight: resultD[i].sRcProductWeight } });
                            }
                        }
                    }

                });

                Page.Children.toolBarBtnAdd("ProPlanD", "btnFill", "向下填充", "down", function () {
                    var crows = $("#ProPlanD").datagrid("getChecked");
                    if (crows.length == 0) {
                        Page.MessageShow("错误提示", "填充功能需要先勾选一行数据");
                        return;
                    }
                    var irecno = crows[0].iRecNo;
                    var fProcessProductWidth = 0;
                    var sRcProductWeight = 0;
                    var sReMark = "";

                    if (parseInt(crows[0].fProcessProductWidth) > 0) {
                        fProcessProductWidth = crows[0].fProcessProductWidth;
                    }
                    if (parseInt(crows[0].sRcProductWeight) > 0) {
                        sRcProductWeight = crows[0].sRcProductWeight;
                    }
                     
                        sReMark = (crows[0].sReMark) ? (crows[0].sReMark) : ""; 

                    var rows = $("#ProPlanD").datagrid("getRows");
                    var bl = false;
                    for (var i = 0; i < rows.length; i++) {
                        if (bl == true) {
                            rows[i].fProcessProductWidth = fProcessProductWidth;
                            rows[i].sRcProductWeight = sRcProductWeight;
                            rows[i].sReMark = sReMark;
                        }
                        if (rows[i].iRecNo == irecno) {
                            bl = true;
                        }
                    }
                    $("#ProPlanD").datagrid("loadData", rows); 
                }); 
            }
            if (Page.usetype == "modify" || Page.usetype == "view") {
                $("#tabTop").tabs("select", 1);
            }
            if (Page.usetype == "modify" || Page.usetype == "view") {
                if (Page.usetype == "view") {
                    $("#tabTop").tabs("close", "未下染色单的订单");
                }

                var sqlobj2 = {
                    TableName: "vwProPlanM",
                    Fields: "sOrderNo,sCode,sName,sFlowerTypeID,sFlowerType,sFlowerTypeID2,sFlowerType2,sFlowerTypeID3,sFlowerType3",
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

                Page.setFieldValue('sOrderNo', data2[0].sOrderNo);
                Page.setFieldValue('sCode', data2[0].sCode);
                Page.setFieldValue('sName', data2[0].sName);
                Page.setFieldValue('sFlowerTypeID', ((data2[0].sFlowerTypeID || "") + "-" + (data2[0].sFlowerType || "")));
                Page.setFieldValue('sFlowerTypeID2', ((data2[0].sFlowerTypeID2 || "") + "-" + (data2[0].sFlowerType2 || "")));
                Page.setFieldValue('sFlowerTypeID3', ((data2[0].sFlowerTypeID3 || "") + "-" + (data2[0].sFlowerType3 || "")));

                //Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);

            }
        });

        function btnPro() {

            var rows = $("#SDOrderM").datagrid("getChecked");
            if (rows.length > 0) { } else { return; }

            var iRecNos = [];
            var bl = false;
            var ss = "";
            var bll = false;
            for (var i = 0; i < rows.length; i++) {
                var ss1 = rows[i].iSDContractMRecNo + "-" + rows[i].iBscDataMatRecNo + "-" + rows[i].iBscDataProcessMRecNo + "-" + (rows[i].sBatchNum || "");
                if (ss == "") {
                    ss = ss1;
                } else {
                    if (ss != ss1) {
                        bl = true;
                        break;

                    }
                }
                var ProPlanDrows = $("#ProPlanD").datagrid("getRows");

                for (var j = 0; j < ProPlanDrows.length; j++) {
                    if (ProPlanDrows[j].iSDContractDProcessDRecNo == rows[i].iRecNo) {
                        bll = true;
                        break;
                    }
                }

            }

            if (bl == true) {
                Page.MessageShow("错误提示", "第" + (i) + "行,订单,产品,工序,批交与现有所选的不一致");
                return;
            }
            if (bll == true) {
                Page.MessageShow("错误提示", "转入时,第" + (i) + "行,已转入，不需要重复转入");
                return;
            }

            for (var i = 0; i < rows.length; i++) {
                var ProPlanDrows = $("#ProPlanD").datagrid("getRows");
                if (ProPlanDrows.length == 0) {
                    Page.setFieldValue("iSDContractMRecNo", rows[i].iSDContractMRecNo);
                    Page.setFieldValue("iBscDataMatRecNo", rows[i].iBscDataMatRecNo);
                    Page.setFieldValue("iBscDataProcessMRecNo", rows[i].iBscDataProcessMRecNo);
                    Page.setFieldValue("iBscDataFlowerTypeRecNo", rows[i].iBscDataFlowerTypeRecNo);
                    Page.setFieldValue("sBatchNum", rows[i].sBatchNum);
                    Page.setFieldValue('sFlowerType', rows[i].sFlowerType);
                    Page.setFieldValue('sFlowerTypeID', rows[i].sFlowerTypeID);
                    Page.setFieldValue('iSdOrderMRecNo', rows[i].iSDOrderMRecNo);
                } else {
                    //if (rows[i].iSDContractMRecNo == Page.getFieldValue("iSDContractMRecNo") && rows[i].iBscDataMatRecNo == Page.getFieldValue("iBscDataMatRecNo") && rows[i].iBscDataProcessMRecNo == Page.getFieldValue("iBscDataProcessMRecNo")) {

                    //} else {
                    //    Page.MessageShow("转入第" + (i + 1) + "行,订单,产品,工序与现有所选的不一致,停止转入", "转入时,第" + (i + 1) + "行,订单,产品,工序与现有所选的不一致,停止转入");
                    //    break;
                    //}

                }
                var dDeliverDate = Page.getFieldValue('dDeliverDate');
                if (dDeliverDate == "") {
                    Page.setFieldValue('dDeliverDate', rows[i].sDelivery);
                }

                var bl = false;

                for (var j = 0; j < ProPlanDrows.length; j++) {
                    if (ProPlanDrows[j].iSDContractDProcessDRecNo == rows[i].iRecNo) {
                        bl = true;
                    }
                }
                if (bl == true) {
                    Page.MessageShow("错误提示", "转入时,第" + (i + 1) + "行,已转入，不需要重复转入");
                    break;
                }

                if (Page.getFieldValue("iBscDataCustomerRecNo") == "") {
                    Page.setFieldValue("iBscDataCustomerRecNo", rows[i].iProduceBscDataCustomerRecNo)
                }
                if (Page.getFieldValue("iCalcUnitID") == "") {
                    Page.setFieldValue("iCalcUnitID", rows[i].iCalcUnitID)
                }
                if (Page.getFieldValue("iCalcType") == "") {
                    Page.setFieldValue("iCalcType", rows[i].iCalcType)
                }

                Page.setFieldValue("sOrderNo", rows[i].sBatchOrderNo);
                Page.setFieldValue("sCode", rows[i].sCode);
                Page.setFieldValue("sName", rows[i].sName);
                Page.setFieldValue("sBatchNum", rows[i].sBatchNum);

                var appRow = {};

                appRow.iBscDataColorRecNo = rows[i].iBscDataColorRecNo;
                appRow.iBscDataFlowerTypeRecNo = rows[i].iBscDataFlowerTypeRecNo;
                appRow.sColorName = rows[i].sColorName;
                appRow.sFlowerType = rows[i].sFlowerType;
                appRow.fProductWidth = rows[i].fProductWidth;
                appRow.fProductWeight = rows[i].fProductWeight;
                appRow.sBatchNum = rows[i].sBatchNum || "";

                appRow.iSDContractDProcessDRecNo = rows[i].iRecNo;
                appRow.fPrice = rows[i].fPrice;
                appRow.iQty = rows[i].iNotPrcessQty10;
                appRow.fQty = rows[i].fNotPrcessQty10;
                appRow.fPurQty = rows[i].fNotPrcessWeight10;
                appRow.fProcessProductWidth = rows[i].fProcessProductWidth || 0;
                appRow.sProduceColorID = rows[i].sProduceColorID;


                iRecNos.push(rows[i].iRecNo)

                Page.tableToolbarClick("add", "ProPlanD", appRow);
            }

            var alrows = $("#SDOrderM").datagrid("getRows");

            for (var j = iRecNos.length - 1; j > -1; j--) {
                for (var i = alrows.length - 1; i > -1; i--) {
                    if (alrows[i].iRecNo == iRecNos[j]) {
                        alrows.splice(i, 1);
                    }
                }
            }

            $("#SDOrderM").datagrid("loadData", alrows);


            $("#tabTop").tabs("select", "外加工单");

            var iBscDataProcessMRecNo = Page.getFieldValue("iBscDataProcessMRecNo");
            var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");

            var t2rows = $("#Table2").datagrid("getRows");
            if (t2rows.length == 0) { } else { return; }


            var sqlObj3 = {
                TableName: "ProPlanDColor",
                Fields: "sItemName,sAsk",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo=(select top 1 iRecNo from ProPlanM where iBscDataProcessMRecNo='" + iBscDataProcessMRecNo + "' and iBscDataCustomerRecNo='" + iBscDataCustomerRecNo + "' order by dInputDate desc)",
                        ComOprt: "",
                        Value: ""
                    }
                ]
            }
            colorAsk = SqlGetData(sqlObj3);

            if (colorAsk.length == 0) {
                var sqlObj = {
                    TableName: "BscDataProcessesD",
                    Fields: "sProjectName sItemName,sRemark sAsk",
                    SelectAll: "True",
                    Filters: [{ Field: "iMainRecNo", ComOprt: "=", Value: "'" + iBscDataProcessMRecNo + "'" }]
                };
                colorAsk = SqlGetData(sqlObj);
            }
            if (colorAsk.length > 0) {

                for (var j = 0; j < colorAsk.length; j++) {
                    Page.tableToolbarClick("add", "Table2", colorAsk[j]);
                }
            }



        }

        function btnFinishPro() {
            $.messager.confirm("您确认/取消完成？", "您确认/取消完成？", function (r) {
                if (r) {
                    var rows = $("#SDOrderM").datagrid("getChecked");



                    var iRecNo = "";

                    for (var i = 0; i < rows.length; i++) {
                        if (iRecNo == "") {
                            iRecNo = rows[i].iRecNo;
                        } else {
                            iRecNo = iRecNo + ';' + rows[i].iRecNo;
                        }
                    }
                    if (iRecNo) { } else {
                        return;
                    }

                    var jsonobj = {
                        StoreProName: "SpSdOrderMColorFinish",
                        StoreParms: [
                        {
                            ParmName: "@iRecNo",
                            Value: iRecNo
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result == "1") {
                        searchSDOrderM();
                    }
                }
            })
        }

        function btnCancelFinish(index) {
            $.messager.confirm("您确认撤销完成？", "您确认撤销完成所选择行吗？", function (r) {
                if (r) {
                    var selectRow = $("#SDOrderMFinish").datagrid("getRows")[index];
                    var iRecNo = selectRow.iRecNo;
                    var jsonobj = {
                        StoreProName: "SpSdOrderMColorFinish",
                        StoreParms: [
                        {
                            ParmName: "@iRecNo",
                            Value: iRecNo
                        },
                        {
                            ParmName: "@iType",
                            Value: 0
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result == "1") {
                        $("#SDOrderMFinish").datagrid("deleteRow", index);
                        searchSDOrderM();
                    }
                }
            })
        }

        function searchSDOrderM() {
            // console.log('dd')
            var arr = "";

            if (Page.getFieldValue("dDate1")) {
                arr = arr + " dDate>='" + Page.getFieldValue("dDate1") + "' and "
            }
            if (Page.getFieldValue("dDate2")) {
                arr = arr + "dDate<='" + Page.getFieldValue("dDate2") + "' and "
            }
            if (Page.getFieldValue("sOrderNo1")) {
                arr = arr + "isnull(sBatchOrderNo,'') like '%" + Page.getFieldValue("sOrderNo1") + "%' and "
            }
            if (Page.getFieldValue("sProduceCustShortName1")) {
                arr = arr + "iProduceBscDataCustomerRecNo= '" + Page.getFieldValue("sProduceCustShortName1") + "' and "
            }

            if (Page.getFieldValue("sProcessesName1")) {
                arr = arr + "iBscDataProcessMRecNo = " + Page.getFieldValue("sProcessesName1") + " and "
            }

            if (Page.getFieldValue("sCode1")) {
                arr = arr + "isnull(sCode,'') like '%" + Page.getFieldValue("sCode1") + "%' and "
            }
            if (Page.getFieldValue("sName1")) {
                arr = arr + "isnull(sName,'') like '%" + Page.getFieldValue("sName1") + "%' and "
            }
            if (Page.getFieldValue("bfinish") == 1) {

            }
            if (Page.getFieldValue("bfinish") == "0") {
                //arr = arr + "isnull(iPrcessFinish,0)=0   and "
            } else if (Page.getFieldValue("bfinish") == "1") {
                arr = arr + "isnull(iPrcessFinish,0)=0   and "
            } else if (Page.getFieldValue("bfinish") == "2") {
                arr = arr + "isnull(iPrcessFinish,0)=1   and "
            } else if (Page.getFieldValue("bfinish") == "") {
                //arr = arr + "isnull(iPrcessFinish,0)=1   and "
            }
            if (!arr) {
                arr = " 1=1 "
            } else {
                arr = arr + " 1=1 ";
            }
            var sqlObjSDOrderM = {
                TableName: "vwSDContractDProcessMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "isnull(iBscDataMatRecNo,0)<>0 and isnull(iProduceType,0)=2 and isnull(iStatus,0)=4 and isnull(iBscDataProcessMRecNo,0)<>24 and " + arr,
                    ComOprt: "",
                    Value: ""
                }

                ],
                Sorts: [

                ]
            };

            var resultSDOrderM = SqlGetData(sqlObjSDOrderM);
            //if (resultSDOrderM.length > 0) {
            $("#SDOrderM").datagrid("loadData", resultSDOrderM);
            //}
        }

        function searchFinishSDOrderM() {
            var sqlObjSDOrderM = {
                TableName: "vwSDOrderM_ProPlan",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "isnull(iBscDataMatRecNo,0)",
                    ComOprt: "<>",
                    Value: "0",
                    LinkOprt: "and"
                },
                {
                    LeftParenthese: "(",
                    Field: "'" + Page.userid + "'",
                    ComOprt: "=",
                    Value: "'master'",
                    LinkOprt: "or"
                },
                {
                    Field: "sOrderUserID",
                    ComOprt: "=",
                    Value: "'" + Page.userid + "'",
                    RightParenthese: ")",
                    LinkOprt: "and"
                },
                {
                    Field: "sFinishType",
                    ComOprt: "in",
                    Value: "('手动完成','自动完成')",
                    LinkOprt: "and"
                },
		        {
		            Field: "isnull(iprepare,0)",
		            ComOprt: "<>",
		            Value: "1",
		            LinkOprt: "and"
		        },
                {
                    Field: "iOrderType",
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
            var resultSDOrderM = SqlGetData(sqlObjSDOrderM);
            if (resultSDOrderM.length > 0) {
                $("#SDOrderMFinish").datagrid("loadData", resultSDOrderM);
            }
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "ProPlanD") {
                if (datagridOp.currentColumnName == "fQty" && changes.fQty) {
                    //                    if (Number(row.fQty) > Number(row.fNotProQty)) {
                    //                        row.fQty = row.fNotProQty;
                    //                        $.messager.show({
                    //                            title: '投坯重量',
                    //                            msg: "投坯重量输入错误,剩余未投坯重量为" + row.fNotProQty,
                    //                            timeout: 1000,
                    //                            showType: 'show',
                    //                            style: {
                    //                                right: '',
                    //                                top: document.body.scrollTop + document.documentElement.scrollTop,
                    //                                bottom: ''
                    //                            }
                    //                        });
                    //                    }
                }
            }
        }

        Page.beforeSave = function () {
            //var rowsColor = $("#Table2").datagrid("getRows");
            //var isFill = false;
            //for (var i = 0; i < rowsColor.length; i++) {
            //    if (rowsColor[i].sAsk != "" && rowsColor[i].sAsk != undefined && rowsColor[i].sAsk != null) {
            //        isFill = true;
            //        break;
            //    }
            //}
            //if (isFill == false) {
            //    Page.MessageShow("染色要求尚未填写", "对不起，染色要求尚未填写！");
            //    return false;
            //}
            var sqlObjSDOrderM = {
                TableName: "bscDataMatDProcesses",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                {
                    Field: "iMainRecNo='" + Page.getFieldValue("iBscDataMatRecNo") + "'",
                    ComOprt: "",
                    Value: ""
                }

                ],
                Sorts: [

                ]
            };
            var result = SqlGetData(sqlObjSDOrderM);
            var iserial1 = -1;
            var iserial2 = -1;
            var iserial3 = -1;
            for (var i = 0; i < result.length; i++) {
                if (result[i].iBscDataProcessesMRecNo == Page.getFieldValue("iBscDataProcessMRecNo") && iserial1 != -1) {
                    iserial1 = result[i].iSerial;
                }
                if (result[i].iBscDataProcessesMRecNo == Page.getFieldValue("iBscDataProcessMRecNo2") && iserial2 != -1) {
                    iserial2 = result[i].iSerial;
                }
                if (result[i].iBscDataProcessesMRecNo == Page.getFieldValue("iBscDataProcessMRecNo3") && iserial3 != -1) {
                    iserial3 = result[i].iSerial;
                }
            }

            if (iserial2 != -1) {
                if (iserial2 > iserial1) { } else {
                    Page.MessageShow("提示", "工序2不能排在工序1前面");
                    return false;
                }
            }
            if (iserial3 != -1) {
                if (iserial3 > iserial2 && iserial2 != -1) { } else {
                    Page.MessageShow("提示", "工序3不能排在工序3前面");
                    return false;
                }
            }
        }

        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "spProPlanDGetDRecNo",
                StoreParms: [

                {
                    ParmName: "@iRecNo",
                    Value: Page.key
                }

                ]
            }
            var result = SqlStoreProce(jsonobj);
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="border:false,fit:true">
        <div title="未完成加工的订单">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'">
                    <table>
                        <tr>
                            <td>日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dDate1" Z_FieldType="日期" Z_NoSave="true" Style="width: 100px" />
                            </td>
                            <td>至
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dDate2" Z_FieldType="日期" Z_NoSave="true" Style="width: 100px" />
                            </td>
                            <td>订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOrderNo1" Z_NoSave="true" Style="width: 80px" />
                            </td>
                            <td>加工厂家
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sProduceCustShortName1" Z_NoSave="true" Style="width: 130px" />
                            </td>
                            <td>加工工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sProcessesName1" Z_NoSave="true" Style="width: 80px" />
                            </td>
                            <td>产品编码
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sCode1" Z_NoSave="true" Style="width: 80px" />
                            </td>
                            <td>颜色
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sName1" Z_NoSave="true" Style="width: 80px" />
                            </td>
                            <td>状态
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="bfinish" Z_NoSave="true" Style="width: 80px" />

                            </td>
                            <td>
                                <%--<a href="#" class="easyui-linkbutton" data-options="" onclick="searchSDOrderM()">查询</a>
                                <a href="#" class="easyui-linkbutton" data-options="" onclick="btnPro()">转入</a>
                                <a href="#" class="easyui-linkbutton" data-options="" onclick="btnFinishPro()">完成/取消</a>--%>
                                <a class="button orange" style="padding: .3em 0.3em .30em" onclick="searchSDOrderM()" href="#">查询</a>
                                <a class="button orange" style="padding: .3em 0.3em .30em" onclick="btnPro()" href="#">转入</a>
                                <a class="button orange" style="padding: .3em 0.3em .30em" onclick="btnFinishPro()" href="#">完成/取消</a>
                            </td>
                        </tr>

                    </table>

                </div>
                <div data-options="region:'center'">
                    <table id="SDOrderM">
                    </table>

                </div>
            </div>

        </div>
        <div title="外加工单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox21" Z_FieldID="iBscDataFlowerTypeRecNo" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox25" Z_FieldID="iBscDataFlowerTypeRecNo2" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox26" Z_FieldID="iBscDataFlowerTypeRecNo3" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox32" Z_FieldID="sBatchNum" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox33" Z_FieldID="iSdOrderMRecNo" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>加工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>加工日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>加工交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="dDeliverDate" Z_FieldType="日期" />
                            </td>
                            <td>经办人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sPerson"
                                    Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>加工厂商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px;" />
                            </td>
                            <td>订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSDContractMRecNo" Style="display: none;" />
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataMatRecNo" Style="display: none;" />
                            </td>
                            <td>产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>



                        </tr>
                        <tr>
                            <td>加工工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iBscDataProcessMRecNo"
                                    Style="width: 150px;" Z_readOnly="true" />
                            </td>
                            <td>工序工艺1
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sFlowerTypeID" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>

                            <td>加工工序2
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataProcessMRecNo2"
                                    Style="width: 150px;" />
                            </td>
                            <td>工序工艺2
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sFlowerTypeID2" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>

                        </tr>
                        <tr>
                            <td>加工工序3
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBscDataProcessMRecNo3"
                                    Style="width: 150px;" />
                            </td>
                            <td>工序工艺3
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sFlowerTypeID3" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>

                            <td>计价单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iCalcUnitID" Z_Required="true" />
                            </td>
                            <td>计价方式
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iCalcType" Z_Required="true" />
                            </td>

                        </tr>

                        <tr>
                            <td class="style2">备注
                            </td>
                            <td class="style1" colspan="5">
                                <textarea id="sReMark" style="border-bottom: 1px solid black; width: 99%; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"
                                    fieldid="sReMark"></textarea>
                            </td>
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                                    Z_Required="False" />
                                <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" Style="display: none;" />
                            </td>
                        </tr>
                    </table>

                </div>
                <div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="加工明细">
                            <!--  子表1  -->
                            <table id="ProPlanD" tablename="ProPlanD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="加工要求">
                            <!--  子表1  -->
                            <table id="Table2" tablename="ProPlanDColor">
                            </table>
                        </div>
                        <%--<div data-options="fit:true" title="备注">
                            <!--  子表1  -->
                            <table id="Table1" tablename="ProPlanDRemark">
                            </table>
                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
        <%--<div title="已完成加工的订单">
            <table id="SDOrderMFinish">
            </table>
        </div>--%>
</asp:Content>
