<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var iBillType = "";
        $(function () {
            if (Page.usetype == "add") {
                iBillType = getQueryString("iBillType");
                Page.setFieldValue("iBillType", iBillType);
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
            if (Page.usetype != "view") {
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
                        { field: "sCustShortName", title: "染厂", width: 80, align: "center" },
                        { field: "sCode", title: "产品编号", width: 80, align: "center" },
                        { field: "sName", title: "产品名称", width: 80, align: "center" },
                        { field: "sBscDataFabCode", title: "坯布编号", width: 100, align: "center" },
                        { field: "sBscDataFabName", title: "坯布名称", width: 80, align: "center" },
                        { field: "fFabQty", title: "下单重量", width: 80, align: "center" },
                        { field: "fOutQty", title: "已发重量", width: 80, align: "center" },
                        { field: "fNotOutQty", title: "未发重量", width: 80, align: "center" },
                        { field: "sUserName", title: "业务员", width: 60, align: "center" },
                        { field: "sBillNo", title: "单号", width: 110, align: "center" },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataMatFabRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                         { field: "sUserID", hidden: true },
                        { field: "iRecNo", hidden: true }
                    ]
                    ],
                    onSelect: function (index, row) {
                        Page.setFieldValue("iBscDataMatFabRecNo", row.iBscDataMatFabRecNo);
                        Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
                        Page.setFieldValue("sOrderUserID", row.sUserID);
                        Page.setFieldValue("sOrderUserName", row.sUserName);
                    },
                    onDblClickRow: function (index, row) {
                        var sqlObj = {
                            TableName: "vwProPlanD",
                            Fields: "sColorID,sColorName,fQty,fPrice,fTotal,sReMark",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: "'" + row.iRecNo + "'"
                                }
                            ]
                        }
                        var result = SqlGetData(sqlObj);
                        $("#tbProPlanDD").datagrid("loadData", result);
                        $("#divProPlanD").window("open");
                    }
                });

                $("#tbProPlanDD").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [
                    [
                        { field: "sColorID", title: "色号", width: 110, align: "center" },
                        { field: "sColorName", title: "颜色", width: 80, align: "center" },
                        { field: "fQty", title: "下单重量", width: 80, align: "center" },
                        { field: "fPrice", title: "单价", width: 80, align: "center" },
                        { field: "fTotal", title: "金额", width: 80, align: "center" },
                        { field: "sReMark", title: "备注", width: 150, align: "center" }
                    ]
                    ]
                }
                );
            }
        })

        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "dDate") {
                    var dDate = Page.getFieldValue("dDate");
                    var SqlObjYearMonth = {
                        TableName: "bscDataPeriod",
                        Fields: "sYearMonth",
                        SelectAll: "True",
                        Filters: [
                {
                    Field: "dBeginDate",
                    ComOprt: "<=",
                    Value: "'" + dDate + "'",
                    LinkOprt: "and"
                },
                {
                    Field: "dEndDate",
                    ComOprt: ">=",
                    Value: "'" + dDate + "'"
                }
            ]
                    }
                    var resultYearMonth = SqlGetData(SqlObjYearMonth);
                    if (resultYearMonth.length > 0) {
                        Page.setFieldValue("sYearMonth", resultYearMonth[0].sYearMonth);
                    }
                    checkMonth();
                }
            }
        }

        function checkMonth() {
            var sYearMonth = Page.getFieldValue("sYearMonth");
            var stockRecNo = Page.getFieldValue("iBscDataStockMRecNo");
            var SqlObj = {
                TableName: "MMStockMonthM",
                Fields: "1",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iBscDataStockMRecNo",
                        ComOprt: "=",
                        Value: "'" + stockRecNo + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "sYearMonth",
                        ComOprt: "=",
                        Value: "'" + sYearMonth + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "isnull(iStatus,0)",
                        ComOprt: "=",
                        Value: "'4'"
                    }
                ]
            };
            var result = SqlGetData(SqlObj);
            if (result.length > 0) {
                Page.MessageShow("仓库此月份已月结", "对不起，此仓库此月份已月结！");
                return false;
            }
        }

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1195") {
                doSearch();
            }
        }

        function doSearch(type) {
            var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
            if (iBscDataCustomerRecNo == "") {
                alert("请先选择染厂！");
                return;
            }
            var sqlObj = {
                TableName: "vwProPlanM",
                Fields: "sCustShortName,sCode,sName,sBscDataFabCode,sUserName,sUserID,sBillNo,sBscDataFabName,fFabQty,fOutQty,fNotOutQty,iBscDataMatRecNo,iBscDataMatFabRecNo,iSdOrderMRecNo,iRecNo",
                SelectAll: "True",
                Filters: [
                        {
                            Field: "iBscDataCustomerRecNo",
                            ComOprt: "=",
                            Value: "'" + iBscDataCustomerRecNo + "'",
                            LinkOprt: "and"
                        },
                        {
                            Field: "fNotOutQty",
                            ComOprt: ">",
                            Value: "0",
                            LinkOprt: "and"
                        },
                /*{
                Field: "isnull(fStockFabQty,0)",
                ComOprt: ">",
                Value: "0",
                LinkOprt: "and"
                },*/
                        {
                        Field: "isnull(iRed,0)",
                        ComOprt: "<>",
                        Value: "1",
                        LinkOprt: "and"
                    },
                        {
                            Field: "isnull(iFinish,0)",
                            ComOprt: "=",
                            Value: "0",
                            LinkOprt: "and"
                        },
                        {
                            Field: "isnull(iWarp,0)",
                            ComOprt: "=",
                            Value: "(case when '" + Page.companyid + "'='01' then isnull(iWarp,0) else 1 end)"
                        }
                    ]
            }

            if (type != null && type != undefined && type != "") {
                sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                sqlObj.Filters.push(
                    {
                        Field: "sUserName",
                        ComOprt: "like",
                        Value: "'%" + $("#__ExtTextBox7").val() + "%'"
                    }
                )
            }
            if (type != null && type != undefined && type != "") {
                sqlObj.Filters[sqlObj.Filters.length - 1].LinkOprt = "and";
                sqlObj.Filters.push(
                    {
                        Field: "sBillNo",
                        ComOprt: "like",
                        Value: "'%" + $("#__ExtTextBox10").val() + "%'"
                    }
                )
            }
            var result = SqlGetData(sqlObj);
            $("#tdProPlanD").datagrid("loadData", result);
        }
        dataForm.beforeSetRowValue = function (uniqueid, index, data, row) {
            if (uniqueid == "332") {
                var selectedRow = $("#tdProPlanD").datagrid("getSelected");
                if (selectedRow) {
                    row.iProPlanMRecNo = selectedRow.iRecNo;
                    row.iSdOrderMRecNo = selectedRow.iSdOrderMRecNo;
                    row.sProPlanNo = selectedRow.sBillNo;
                    return row;
                }
            }
        }
        Page.beforeSave = function () {
            if (checkMonth() == false) {
                return false;
            }
        }
        function doFinish() {
            var selectedRow = $("#tdProPlanD").datagrid("getSelected");
            if (selectedRow) {
                $.messager.confirm("您确认吗？", "您确认标记完成吗?", function (r) {
                    if (r) {
                        var jsonobj = {
                            StoreProName: "SpProPlanMFinish",
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
                })
            }
            else {
                Page.MessageShow("请选择一行！", "请选择一行！");
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="height: 180px;">
            <div class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'west',split:true,border:false" style="height: 180px; width: 680px;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataMatFabRecNo"
                            Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iSdOrderMRecNo" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sOrderUserID" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOrderUserName" Z_NoSave="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>
                                出库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
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
                                    Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                出库类型
                            </td>
                            <td>
                                <cc1:ExtSelect2 ID="ExtSelect1" runat="server" Z_FieldID="sTypeName" Z_Options="染色出库" />
                            </td>
                            <td id="tdCustomer">
                                染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Width="150px" />
                            </td>
                            <td>
                                会计月份
                            </td>
                            <td style="margin-left: 40px">
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sYearMonth" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                出库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                            <td>
                                重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan='5'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="98%" />
                            </td>
                        </tr>
                        <tr>
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
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false" style="height: 180px;">
                    <table id="tdProPlanD">
                    </table>
                </div>
            </div>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <table id="MMStockOutD" tablename="MMStockOutD">
                    </table>
                </div>
            </div>
        </div>
        <div id="divProPlanD" class="easyui-window" data-options="closed:true,closable:true,title:'点色单明细',collapsible:false,minimizable:false,maximizable:false,modal:true,width:600,height:300">
            <table id="tbProPlanDD">
            </table>
        </div>
        <div id="dgtool">
            <table>
                <tr>
                    <td>
                        业务员：<cc1:ExtTextBox2 ID="ExtTextBox7" Z_FieldID="sSaleName" Z_NoSave="true" runat="server" />
                    </td>
                    <td>
                        单号：<cc1:ExtTextBox2 ID="ExtTextBox10" Z_FieldID="sBillNo" Z_NoSave="true" runat="server" />
                    </td>
                    <td>
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                            onclick="doSearch(1)">查找</a>
                    </td>
                    <td>
                        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"
                            onclick="doFinish()">标记完成</a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
