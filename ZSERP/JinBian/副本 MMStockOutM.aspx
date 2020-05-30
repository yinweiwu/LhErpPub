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
                if (iBillType == "2") {
                    $("#iBscDataCustomerRecNo1").hide();
                    $("#iBscDataCustomerRecNo2").hide();
                    $("#iBscDataCustomerRecNo3").hide();
                    $("#iBscDataCustomerRecNo4").hide();
                    var tab2 = $('#tabTop').tabs('getTab', '采购入库单');
                    $('#tabTop').tabs('update', {
                        tab: tab2,
                        options: {
                            title: '生产入库单'
                        }
                    });
                    var tab = $('#tabTop').tabs('getTab', '未入库采购订单');
                    $('#tabTop').tabs('update', {
                        tab: tab,
                        options: {
                            title: '未入库生产指令单'
                        }
                    });
                }
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

                $("#PurOrderM").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { title: "通知单号", field: "sBillNo", width: 110, sortable: true },
                        { title: "出库", field: "btnOut", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnOut(" + str + ", " + index + ")' value='出库' />";
                            return btnStr;
                        }
                        },
                        { title: "日期", field: "dDate1", width: 120, sortable: true },
                        { title: "供应商", field: "sCustShortName", width: 120, sortable: true },
                        { title: "单价", field: "fPrice", width: 80, sortable: true },
                        { title: "总数量", field: "fSumQtyM", width: 80, sortable: true },
                        { title: "总金额", field: "fSumTotalM", width: 80, sortable: true },
                        { title: "未出库数量", field: "fNoOutQty", width: 80, sortable: true },
                        { title: "未出库金额", field: "fNoOutTotal", width: 80, sortable: true },
                    //                        { title: "本次出库数量", field: "fOutQty1", width: 80, sortable: true, editor: { type: "numberbox", options: { precision: 1}} },
                    //                        { title: "本次出库金额", field: "fOutTotal1", width: 80, sortable: true, editor: { type: "numberbox", options: { precision: 1}} },
                        {field: "iRecNo", hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSDOrderMRecNo", hidden: true },
                        { field: "iBscDataMatFabRecNo", hidden: true },
                        { field: "sCode", hidden: true },
                        { field: "sName", hidden: true },
                        { field: "fPurQty", hidden: true },
                        { field: "iStockSdOrderMRecNo", hidden: true },
                        { field: "sOrderNo", hidden: true }

                    ]],
                    onSelect: function (index, row) {
                        lastSelectedSendMRecNo = row.iRecNo;
                    },
                    onDblClickRow: function (index, row) {
                        btnOut(row, index);
                    }
                }
                );
                if (iBillType == "1") {
                    //searchOrderMD();
                }
                else if (iBillType == "2") {
                    //searchSDOrderMD()
                }
            }
            else {
                $('#tabTop').tabs('close', '未出库染色点色单');
            }
        })

        function searchOrderMD() {
            var sqlObjOrderMD = {
                TableName: "vwProPlanMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(fNoOutQty,0)",
                        ComOprt: ">",
                        Value: "0"
                    }
                    ],
                Sorts: [
                {
                    SortName: "iRecNo",
                    SortOrder: "asc"
                }
                ]
            };
            var resultSendMD = SqlGetData(sqlObjOrderMD);
            if (resultSendMD.length > 0) {
                $("#PurOrderM").datagrid("loadData", resultSendMD);
                for (var i = 0; i < resultSendMD.length; i++) {
                    $("#PurOrderM").datagrid("beginEdit", i);
                }
                var ed = $('#PurOrderM').datagrid('getEditor', { index: 0, field: 'fOutQty1' });
                $($(ed.target).numberbox('textbox')).focus();
            }
        }

        function btnOut(row, index) {
            var iBscDataCustomerRecNo = Page.getFieldValue('iBscDataCustomerRecNo1');
            if (iBscDataCustomerRecNo == "" && iBillType == "1") {
                $.messager.show({
                    title: '错误',
                    msg: '染厂不能为空！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
            else {
                Page.setFieldValue("iBscDataCustomerRecNo", iBscDataCustomerRecNo);
            }
            $("#MMStockOutD").datagrid("loadData", []);
            var iRecNoStr = "";

            var rows = $("#PurOrderM").datagrid("getRows");
            for (var i = 0; i < rows.length; i++) {
                $("#PurOrderM").datagrid("endEdit", i);
            }
            var rowsConfirm = $("#PurOrderM").datagrid("getRows");
            for (var i = 0; i < rowsConfirm.length; i++) {
                if (rowsConfirm[i].iRecNo == row.iRecNo) {
                    if (rowsConfirm[i].fOutQty1 > row.fNoOutQty) {
                        $.messager.show({
                            title: '错误',
                            msg: '本次入库数量不能超过未入库数量！',
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        for (var i = 0; i < rows.length; i++) {
                            $("#PurOrderM").datagrid("beginEdit", i);
                        }
                        return false;
                    }
                    var appRow = {};
                    appRow.iBscDataMatRecNo = row.iBscDataMatFabRecNo;
                    appRow.iSDOrderMRecNo = row.iSdOrderMRecNo;
                    appRow.sOrderNo = row.sOrderNo;
                    appRow.fPrice = isNaN(parseFloat(row.fPrice)) ? 0 : parseFloat(row.fPrice);
                    appRow.fQty = isNaN(parseFloat(rowsConfirm[i].fNoOutQty)) ? 0 : parseFloat(rowsConfirm[i].fNoOutQty);
                    appRow.fTotal = rowsConfirm[i].fNoOutTotal == "" ? appRow.fPrice * appRow.fQty : rowsConfirm[i].fNoOutTotal;
                    appRow.iBscDataMatRecNo = row.iBscDataMatFabRecNo;
                    appRow.sCode = row.sBscDataFabCode;
                    appRow.sName = row.sBscDataFabName;
                    appRow.fPurQty = row.fPurQty;
                    appRow.sProPlanNo = row.sBillNo;
                    appRow.iStockSdOrderMRecNo = row.iStockSdOrderMRecNo;
                    appRow.sOrderNo = row.sOrderNo;
                    if (iBillType == "1") {
                        appRow.iProPlanMRecNo = row.iMainRecNo;
                    }
                    else if (iBillType == "2") {
                        appRow.iSDOrderMRecNo = row.iMainRecNo;
                    }
                    Page.tableToolbarClick("add", "MMStockOutD", appRow);
                    for (var i = 0; i < rows.length; i++) {
                        $("#PurOrderM").datagrid("beginEdit", i);
                    }
                }
            }
            if (iBillType == "1") {
                $("#tabTop").tabs("select", "领用出库单");
            }
            else if (iBillType == "2") {
                $("#tabTop").tabs("select", "生产入库单");
            }
        }

        function search1() {
            var iBscDataCustomerRecNo = Page.getFieldValue('iBscDataCustomerRecNo1');
            if (iBscDataCustomerRecNo == "") {
                $.messager.show({
                    title: '错误',
                    msg: '染厂不能为空！',
                    timeout: 1000,
                    showType: 'show',
                    style: {
                        right: '',
                        top: document.body.scrollTop + document.documentElement.scrollTop,
                        bottom: ''
                    }
                });
                return false;
            }
            var dDate1 = Page.getFieldValue('dDate1') == "" ? "1990-01-01" : Page.getFieldValue('dDate1');
            var dDate2 = Page.getFieldValue('dDate2') == "" ? "2990-01-01" : Page.getFieldValue('dDate12');
            var sqlObjOrderMD = {
                TableName: "vwProPlanMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "isnull(fNoOutQty,0)",
                        ComOprt: ">",
                        Value: "0",
                        LinkOprt: "and"
                    },
                    {
                        Field: "iBscDataCustomerRecNo",
                        ComOprt: "=",
                        Value: iBscDataCustomerRecNo,
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate1",
                        ComOprt: ">=",
                        Value: "'" + dDate1 + "'",
                        LinkOprt: "and"
                    },
                    {
                        Field: "dDate1",
                        ComOprt: "<=",
                        Value: "'" + dDate2 + "'"
                    }
                    ],
                Sorts: [
                {
                    SortName: "iRecNo",
                    SortOrder: "asc"
                }
                ]
            };
            var resultSendMD = SqlGetData(sqlObjOrderMD);
            $("#PurOrderM").datagrid("loadData", resultSendMD);

        }

        Page.beforeSave = function () {
            var iBscDataCustomerRecNo = Page.getFieldValue("iBscDataCustomerRecNo");
            Page.setFieldValue("iBscDataCustomerRecNo1", iBscDataCustomerRecNo);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未出库染色点色单">
            <div class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="vertical-align: middle">
                        <img alt="" src="../../Base/JS/easyui/themes/icons/search.png" />查询条件
                        <hr />
                    </div>
                    <div style="margin-left: 35px; margin-bottom: 5px;">
                        <table>
                            <tr>
                                <td>
                                    日期从
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldType="日期" Z_FieldID="dDate1"
                                        Z_NoSave="True" />
                                </td>
                                <td>
                                    至
                                </td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldType="日期" Z_FieldID="dDate2"
                                        Z_NoSave="True" />
                                </td>
                                <td id="iBscDataCustomerRecNo1">
                                    染厂
                                </td>
                                <td id="iBscDataCustomerRecNo2">
                                    <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBscDataCustomerRecNo1"
                                        Z_NoSave="True" Z_Required="True" />
                                </td>
                                <td>
                                    <a href='javascript:void(0)' class="easyui-linkbutton" data-options="iconCls:'icon-search'"
                                        onclick='search1()'>查询</a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div data-options="region:'center'" style="overflow: hidden;">
                    <table id="PurOrderM">
                    </table>
                </div>
            </div>
        </div>
        <div title="领用出库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
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
                                    Width="150px" />
                            </td>
                            <td>
                                出库类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sTypeName" Width="150px" />
                            </td>
                            <td style="display: none">
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iBillType" />
                            </td>
                        </tr>
                        <tr>
                            <td id="iBscDataCustomerRecNo3">
                                染厂
                            </td>
                            <td id="iBscDataCustomerRecNo4">
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Width="150px" />
                            </td>
                            <td>
                                备注
                            </td>
                            <td colspan='3'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="99%" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                            <td style="display: none">
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sYearMonth" />
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
                                金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal" Z_readOnly="True" />
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
                        </tr>
                        <tr>
                            <td>
                                出库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" />
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
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="出库明细">
                            <table id="MMStockOutD" tablename="MMStockOutD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
