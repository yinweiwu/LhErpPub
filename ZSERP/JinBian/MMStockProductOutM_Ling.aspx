<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("MMStockProductOutD", "add");
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

            $('#__ExtTextBox4').combobox({
                onSelect: function (record) {
                    if (record.sName == "外加工领用") {
                        var data = $('#__ExtTextBox6').combobox("getData");
                        console.log(data);
                    }
                }
            })

            $("#tdProPlanD").datagrid(
                {
                    toolbar: '#dgtool',
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [
                        [
                            { field: "__ck", checkbox: true },
                            { field: "sSendFinish", title: "完成否", width: 50, align: "center" },
                            { field: "sOrderNo", title: "订单号", width: 100, align: "center" },
                            { field: "sName", title: "成品名称", width: 100, align: "center" },
                            { field: "面布名称", title: "面布名称", width: 100, align: "center" },
                            { field: "底布名称", title: "底布名称", width: 100, align: "center" },
                            { field: "fOutQty", title: "已领数量", width: 100, align: "center" },   
                            { field: "fNoOutQty", title: "未领数量", width: 100, align: "center" },   
                            { field: "sProPlanMBillNo", title: "生产计划单号", width: 100, align: "center" },
                            { field: "sColorNameChinese", title: "颜色", width: 80, align: "center" },
                            { field: "sColorIDSelf", title: "本厂色号", width: 80, align: "center" },
                            { field: "fProductWidth", title: "幅宽", width: 80, align: "center" },
                            { field: "fProductWeight", title: "克重", width: 100, align: "center" },
                            { field: "fProcessProductWidth", title: "定型门幅", width: 80, align: "center" },
                            //{ field: "sColorID", title: "色号", width: 80, align: "center" },
                            //{ field: "sColorName", title: "颜色", width: 80, align: "center" },
                            //{ field: "sUnitName", title: "单位", width: 80, align: "center" },
                            { field: "sRcProductWeight", title: "染厂克重", width: 80, align: "center" },
                            { title: "成品名称", field: "sProName", width: 100  },
                            { field: "fQty", title: "米数", width: 60, align: "center" },
                            { field: "iQty", title: "匹数", width: 60, align: "center" }, 
                            { field: "iSDContractDProcessDRecNo", hidden: true },
                            { field: "iTmpDiBscDataMatRecNo", hidden: true }, 
                            { field: "iRecNo", hidden: true },
                            { field: "iBscDataMatRecNo", hidden: true },
                            { field: "iBscDataColorRecNo", hidden: true },  
                            { field: "iMainRecNo", hidden: true }
                        ]
                    ],
                    onSelect: function (index, row) {
                        var sTypeName = Page.getFieldValue("sTypeName");
                        if (sTypeName == "车间生产领用") {
                            Page.setFieldValue("iTmpProPlanDayDRecNo", row.iRecNo);
                            Page.setFieldValue("iTmpProPlanDayMRecNo", row.iMainRecNo);
                            Page.setFieldValue("iTmpProPlanDRecNo", "");
                        } else { 
                            Page.setFieldValue("iTmpProPlanDRecNo", row.iRecNo);
                            Page.setFieldValue("iTmpProPlanDayDRecNo", "");
                            Page.setFieldValue("iTmpProPlanDayMRecNo", "");
                        }
                        Page.setFieldValue("sProPlanMBillNo", row.sProPlanMBillNo);
                        Page.setFieldValue("iTmpSDContractDProcessDRecNo", row.iSDContractDProcessDRecNo);
                        Page.setFieldValue("iTmpDiBscDataMatRecNo", row.iTmpDiBscDataMatRecNo);
                        Page.setFieldValue("iTmpBscDataMatRecNo", row.iBscDataMatRecNo);
                        Page.setFieldValue("iTmpBscDataColorRecNo", row.iBscDataColorRecNo);
                        
                        //Page.setFieldValue("iSdOrderMRecNo", row.iSDContractMRecNo);
                        //Page.setFieldValue("sOrderUserID", row.sUserID);
                        //Page.setFieldValue("sOrderUserName", row.sUserName);
                    }
                }); 
             
        })

        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == 421) { 
                row.sProPlanMBillNo = Page.getFieldValue("sProPlanMBillNo");
                var sTypeName = Page.getFieldValue("sTypeName");
                if (sTypeName == "车间生产领用") {
                    row.iProPlanDayDRecNo = Page.getFieldValue("iTmpProPlanDayDRecNo");
                    row.iProPlanDayMRecNo = Page.getFieldValue("iTmpProPlanDayMRecNo"); 
                } else {
                    row.iProPlanDRecNo = Page.getFieldValue("iTmpProPlanDRecNo");
                    row.iProPlanMRecNo = Page.getFieldValue("iProPlanMRecNo"); 
                }
                row.iSDContractDProcessDRecNo = Page.getFieldValue("iTmpSDContractDProcessDRecNo"); 
            }
            return row;
        }

        lookUp.afterSelected = function (uniqueid, data) { 
            if (uniqueid == 2514) { 
                doSearch(); 
            } 
        } 

        function doSearch() {

            var sTypeName = Page.getFieldValue("sTypeName");
            if (sTypeName == "车间生产领用") {
                var sqlObj = {
                    TableName: "vwProPlanDayMFMD a",
                    Fields: "* ",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "1",
                            ComOprt: "=",
                            Value: "1"
                        }
                    ]
                }
                var iFinish = Page.getFieldValue("iFinish");
                if (iFinish == "1") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "isnull(a.iSendFinish,0)",
                            ComOprt: "=",
                            Value: "1"
                        });
                }
                else {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "isnull(a.iSendFinish,0)",
                            ComOprt: "=",
                            Value: "0"
                        });
                }
                var iFinish = Page.getFieldValue("iFinish");

                var sColorNameChinese = Page.getFieldValue("sColorNameChinese");
                if (sColorNameChinese != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sColorNameChinese",
                            ComOprt: "like",
                            Value: "'%" + sColorNameChinese + "%'"
                        }
                    )
                }

                var sOrderNo1 = Page.getFieldValue("sOrderNo1");
                if (sOrderNo1 != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "a.sOrderNo",
                            ComOprt: "like",
                            Value: "'%" + sOrderNo1 + "%'"
                        }
                    )
                }

                var result = SqlGetData(sqlObj);
                $("#tdProPlanD").datagrid("loadData", result);
            } else {
                var iProPlanMRecNo = isNaN(Number(Page.getFieldValue("iProPlanMRecNo"))) ? 0 : Number(Page.getFieldValue("iProPlanMRecNo"));
                if (iProPlanMRecNo == 0) {
                    alert("请先选择加工单！");
                    return;
                }

                var sqlObj = {
                    TableName: "vwProPlanMFMD a",
                    Fields: "* ",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMainRecNo",
                            ComOprt: "=",
                            Value: "'" + iProPlanMRecNo + "'"
                        }
                    ]
                }
                var iFinish = Page.getFieldValue("iFinish");
                if (iFinish == "1") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "isnull(a.iSendFinish,0)",
                            ComOprt: "=",
                            Value: "1"
                        });
                }
                else {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "isnull(a.iSendFinish,0)",
                            ComOprt: "=",
                            Value: "0"
                        });
                }
                var iFinish = Page.getFieldValue("iFinish");

                var sColorNameChinese = Page.getFieldValue("sColorNameChinese");
                if (sColorNameChinese != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "sColorNameChinese",
                            ComOprt: "like",
                            Value: "'%" + sColorNameChinese + "%'"
                        }
                    )
                }

                var sOrderNo1 = Page.getFieldValue("sOrderNo1");
                if (sOrderNo1 != "") {
                    sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                    sqlObj.Filters.push(
                        {
                            Field: "a.sOrderNo",
                            ComOprt: "like",
                            Value: "'%" + sOrderNo1 + "%'"
                        }
                    )
                }

                var result = SqlGetData(sqlObj);
                $("#tdProPlanD").datagrid("loadData", result);
            }

            
        } 

        function doFinish() {
            var selectedRow = $("#tdProPlanD").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("您确认吗？", "您确认标记完成/未完成吗?", function (r) {
                    if (r) {

                        var sTypeName = Page.getFieldValue("sTypeName");
                        if (sTypeName == "车间生产领用") {
                            var jsonobj = {
                                StoreProName: "SpProPlanDayDSendFinish",
                                StoreParms: [{
                                    ParmName: "@iRecNo",
                                    Value: selectedRow.iRecNo
                                }
                                ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                alert(result);
                            }
                            else {
                                $("#tdProPlanD").datagrid("deleteRow", $("#tdProPlanD").datagrid("getRowIndex", selectedRow));
                            }
                        } else {
                            var jsonobj = {
                                StoreProName: "SpProPlanDSendFinish",
                                StoreParms: [{
                                    ParmName: "@iRecNo",
                                    Value: selectedRow.iRecNo
                                }
                                ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                alert(result);
                            }
                            else {
                                $("#tdProPlanD").datagrid("deleteRow", $("#tdProPlanD").datagrid("getRowIndex", selectedRow));
                            }
                        }

                        
                    }
                })
            }
            else {
                Page.MessageShow("请选择一行！", "请选择一行！");
            }
        }

        Page.beforeSave = function () {
            var sTypeName = Page.getFieldValue("sTypeName");
            var iBscDataCustomerRecNo = isNaN(Number(Page.getFieldValue("iBscDataCustomerRecNo"))) ? 0 : Number(Page.getFieldValue("iBscDataCustomerRecNo"));
            var iProPlanMRecNo = isNaN(Number(Page.getFieldValue("iProPlanMRecNo"))) ? 0 : Number(Page.getFieldValue("iProPlanMRecNo"));
            var sDeptID = Page.getFieldValue("sDeptID"); 

            if (sTypeName == "内部领用" && iProPlanMRecNo > 0) {
                alert("内部领用加工单不能填写");
                return false;
            }

            if (sTypeName == "外加工领用") {
                if (iBscDataCustomerRecNo == 0) {
                    alert("外加工领用加工商必填");
                    return false;
                }
                if (iProPlanMRecNo == 0) {
                    alert("外加工领用加工单必填");
                    return false;
                }
            }

            if (sTypeName == "车间生产领用") {
                if (!sDeptID) {
                    alert("车间生产领用领用部门必填");
                    return false;
                } 
            } 

            var iRed = Page.getFieldValue("iRed");
            if (iRed == "1") {
                var allRows = $("#MMStockProductOutD").datagrid("getRows");
                for (var i = 0; i < allRows.length; i++) {
                    var fQty = isNaN(Number(allRows[i].fQty)) ? 0 : Number(allRows[i].fQty);
                    var fPurQty = isNaN(Number(allRows[i].fPurQty)) ? 0 : Number(allRows[i].fPurQty);
                    var sLetCode = isNaN(Number(allRows[i].sLetCode)) ? 0 : Number(allRows[i].sLetCode);
                    var fTotal = isNaN(Number(allRows[i].fTotal)) ? 0 : Number(allRows[i].fTotal);
                    var iQty = isNaN(Number(allRows[i].iQty)) ? 0 : Number(allRows[i].iQty);
                    if (fQty > 0) {
                        fQty = -1 * fQty;
                    }
                    if (fPurQty > 0) {
                        fPurQty = -1 * fPurQty;
                    }
                    if (sLetCode > 0) {
                        sLetCode = -1 * sLetCode;
                    }
                    if (fTotal > 0) {
                        fTotal = -1 * fTotal;
                    }
                    if (iQty > 0) {
                        iQty = -1 * iQty;
                    }
                    $("#MMStockProductOutD").datagrid("updateRow", { index: i, row: { fQty: fQty, fPurQty: fPurQty, sLetCode: sLetCode, fTotal: fTotal, iQty: iQty } });
                }
                Page.Children.ReloadFooter("MMStockProductOutD");
            }
        }

        function BarcodeScan() {
            if (event.keyCode == 13) {
                var barcode = $("#txtBarcode").val();
                if (barcode != "") {

                    var rows = $("#MMStockProductOutD").datagrid("getRows");
                    for (var j = 0; j < rows.length; j++) {
                        if (barcode == rows[j].sBarCode) {
                            alert("已扫描");
                            return false;
                        }
                    }

                    if (Page.getFieldValue("iRed") == 0) {
                        var sqlObj = {
                            //表名或视图名
                            TableName: "MMStockQty a inner join BscDataMat b on a.iBscDataMatRecNo=b.iRecNo inner join BscDataColor c on a.iBscDataColorRecNo=c.iRecNo left join SDContractM d on a.iSdOrderMRecNo=d.iRecNo left join BscDataStockD e on a.iBscDataStockDRecNo=e.iRecNo LEFT JOIN dbo.BscDataFlowerType f ON f.iRecNo=a.iBscDataFlowerTypeRecNo left join SDOrderM g on g.iRecNo=a.iSDOrderMRecNoBatch",
                            //选择的字段
                            Fields: "a.*,f.sFlowerType,b.sName,c.sColorID,d.sContractNo,g.sOrderNo,isnull(e.sBerChID,'') as sBerChID",
                            //是否选择全部数据，如果为否，则要指定ChooseCount和SkipCount
                            SelectAll: "True",
                            //过滤条件，数组格式
                            Filters: [
                                {
                                    //左括号
                                    //字段名
                                    Field: "a.sBarCode",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + barcode + "'",
                                    LinkOprt: "and"
                                },
                                {
                                    Field: "a.iBscDataStockMRecNo",
                                    //比较符
                                    ComOprt: "=",
                                    //值
                                    Value: "'" + Page.getFieldValue("iBscDataStockMRecNo") + "'"
                                }
                            ]
                        }
                        var data = SqlGetData(sqlObj);
                        if (data.length > 0) {
                            var r = data[0];
                            r.sProPlanMBillNo = Page.getFieldValue("sProPlanMBillNo");
                            var sTypeName = Page.getFieldValue("sTypeName");
                            if (sTypeName == "车间生产领用") {
                                r.iProPlanDayDRecNo = Page.getFieldValue("iTmpProPlanDayDRecNo");
                                r.iProPlanDayMRecNo = Page.getFieldValue("iTmpProPlanDayMRecNo");
                            } else {
                                r.iProPlanDRecNo = Page.getFieldValue("iTmpProPlanDRecNo");
                                r.iProPlanMRecNo = Page.getFieldValue("iProPlanMRecNo");
                            }
                            r.iStockSDOrderMRecNoBatch = Page.getFieldValue("iSDOrderMRecNoBatch"); 
                            var isSame = 0;
                            if (r.iBscDataColorRecNo != Number(Page.getFieldValue("iTmpBscDataColorRecNo")) || r.iBscDataMatRecNo != Number(Page.getFieldValue("iTmpBscDataMatRecNo"))) {
                                alert("产品或产品颜色未对应");
                                $("#txtBarcode").val("");
                                $("#txtBarcode").focus();
                                stopBubble($("#txtBarcode")[0]);
                                return false;
                            }
                            
                            
                            Page.tableToolbarClick("add", "MMStockProductOutD", r);
                        }
                        else {
                            alert("条码不存在");
                        }
                    }
                    else {
                        var sqlObj = {
                            StoreProName: "SpGetOutLingProduct",
                            StoreParms: [
                                {
                                    ParmName: "@sBarCode",
                                    Value: barcode
                                }
                            ]
                        }
                        var data = SqlStoreProce(sqlObj, true);
                        var r = data[0];
                        r.sProPlanMBillNo = Page.getFieldValue("sProPlanMBillNo");
                        r.iProPlanDRecNo = Page.getFieldValue("iTmpProPlanDRecNo"); 
                        var isSame = 0;
                        if (data.length > 0) {
                            Page.tableToolbarClick("add", "MMStockProductOutD", r);
                        }
                        else {
                            alert("条码不存在");
                        }
                    }
                }
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
                stopBubble($("#txtBarcode")[0]);
            }
        }
        Page.Formula = function (field) {
            if (Page.isInited) {
                if (field == "sTypeName") {
                    var sTypeName = Page.getFieldValue("sTypeName");
                    if (sTypeName == "车间生产领用") {
                        Page.setFieldValue("iBscDataCustomerRecNo", 1902);
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
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',split:true,border:false" style="height: 100px; width: 840px;">
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <%--<cc1:ExtHidden2 ID="ExtHidden5" Z_FieldID="iBscDataCustomerRecNo" Z_Value="0" runat="server" />--%>
                <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="4" runat="server" />
                <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iMatType" Z_Value="2" runat="server" /> 
                <cc1:ExtTextBox2 ID="ExtTextBox11" Z_FieldID="sProPlanMBillNo" Z_NoSave="true"  runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox12" Z_FieldID="iTmpProPlanDRecNo"  Z_NoSave="true" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox16" Z_FieldID="iTmpProPlanDayDRecNo"  Z_NoSave="true" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox17" Z_FieldID="iTmpProPlanDayMRecNo"  Z_NoSave="true" runat="server" /> 
                <cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2"  runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox13" Z_FieldID="iTmpSDContractDProcessDRecNo" Z_NoSave="true" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox14" Z_FieldID="iTmpDiBscDataMatRecNo" Z_NoSave="true" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox18" Z_FieldID="iTmpBscDataMatRecNo" Z_NoSave="true" runat="server" />
                <cc1:ExtTextBox2 ID="ExtTextBox19" Z_FieldID="iTmpBscDataColorRecNo" Z_NoSave="true" runat="server" />
                
                <%--<cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="sReMark" Z_Value="扫码领用出库" runat="server" />--%>
                <%--<cc1:ExtHidden2 ID="ExtHidden3" Z_FieldID="iSdOrderMRecNo" runat="server" />--%>
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>出库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="150px" />
                    </td>
                    <td>仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Width="150px" />
                    </td>
                    <td>加工商
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                            Width="150px" />
                    </td>
                </tr>
                <tr>
                    <td>会计月份
                    </td>
                    <td style="margin-left: 40px">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>领用类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTypeName"
                            Width="150px" />
                    </td>
                    <td>经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="sBscDataPersonID" Width="150px" />
                    </td>
                    <td>领用部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sDeptID" Width="150px" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                        <label for="__ExtCheckbox1">
                            红冲</label>
                    </td>
                     <td>加工单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="iProPlanMRecNo" 
                            Width="150px" />
                    </td>

                    <td>备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" Style="width: 99%;" Z_FieldID="sReMark" runat="server" />
                    </td>

                   
                </tr>
                <tr>
                     <td>制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Width="150px" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" Width="150px" />
                    </td>
                    <td>出库单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sUnitID" 
                            Width="150px" />
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td>
                        <strong style="font-size: xx-large">条 码</strong>
                    </td>
                    <td>
                        <input id="txtBarcode" onkeydown="BarcodeScan()" type="text" title="请刷入条码" style="width: 200px; height: 50px; font-size: 20px; font-weight: bold; background-color: pink;"
                            class="txb" />
                    </td>
                </tr>
            </table>
                      </div>
                <div data-options="region:'center',border:false" style="height: 100px;">
                    <table id="tdProPlanD">
                    </table>
                </div>
                </div>
            
        </div>
        <div id="dgtool">
            <table>
                <tr>
                     
                    <td>颜色：<cc1:ExtTextBox2 ID="ExtTextBox9" Z_FieldID="sColorNameChinese" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td>订单号：<cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sOrderNo1" style="width:80px" Z_NoSave="true" runat="server" />
                    </td>
                    <td>
                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iFinish" Z_NoSave="true" />
                        <label for="__ExtCheckbox2">
                            已完成</label>
                    </td>
                    <td>
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                            onclick="doSearch()">查找</a>
                    </td>
                    <td>
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                            onclick="doFinish()">标记完成</a>
                    </td>
                </tr>
            </table>
        </div>
         
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <!--  子表1  -->
                    <table id="MMStockProductOutD" tablename="MMStockProductOutD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
