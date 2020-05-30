<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                Page.setFieldValue("iBillType", getQueryString("iBillType"));
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
            if (Page.usetype == "add" || Page.usetype == "modify") {
                columns = [[
                        { field: "__ck", width: 80, sortable: true, checkbox: true },
                        { title: "单据号", field: "sBillNo", width: 110, sortable: true },
                        { title: "日期", field: "dDate1", width: 100, sortable: true },
                         { title: "加工厂家", field: "sCustShortName", width: 100, sortable: true },
                        { title: "坯布编号", field: "sBscDataFabCode", width: 100, sortable: true },
                        { title: "坯布名称", field: "sBscDataFabName", width: 100, sortable: true },
                        { title: "加工重量", field: "fQty", width: 80, sortable: true },
                        { title: "匹数", field: "fPurQty", width: 60, sortable: true },
                        { title: "未入库重量", field: "fNoInQty", width: 80, sortable: true },
                        { title: "单价", field: "fPrice", width: 80, sortable: true, hidden: true },
                        { field: "金额", field: "fNoInTotal", width: 80, sortable: true, hidden: true },
                        { field: "iMainRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "iSDOrderDRecNo", hidden: true },
                        { field: "iBscDataMatRecNo", hidden: true }

                ]];
                $("#table2").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 100, 500, 5000],
                    columns: columns,
                    toolbar: [{
                        iconCls: 'icon-search',
                        text: "查询",
                        handler: function () {
                            search1();
                        }
                    }, '-', {
                        iconCls: 'icon-import',
                        text: "转入",
                        handler: function () {
                            passIn();
                        }
                    }
                    , '-', {
                        iconCls: 'icon-ok',
                        text: "标记完成",
                        handler: function () {
                            flagFinish();
                        }
                    }

                    ],
                    onSelect: function (index, row) {
                        lastSelectedSendMRecNo = row.iRecNo;
                    }
                }
                );
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            else {
                $('#tabTop').tabs('close', '未入库外加工单');
            }
        })

        function search1() {
            var sqlObjOrderMD = {
                TableName: "vwProOutProduceMDFab",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                //                                        {
                //                        Field: "isnull(fNoInQty,0)",
                //                        ComOprt: ">",
                //                        Value: "0",
                //                        LinkOprt: "and"
                //                    },
                    {
                    Field: "isnull(iStatus,0)",
                    ComOprt: ">",
                    Value: "3",
                    LinkOprt: "and"
                },
                    {
                        Field: "sFinish",
                        ComOprt: "<>",
                        Value: "'√'"
                    }
                    ],
                Sorts: [
                    {
                        SortName: "sCustShortName",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
            };

            var resultSendMD = SqlGetData(sqlObjOrderMD);
            $("#table2").datagrid("loadData", resultSendMD);
        }

        function passIn() {
            var rows = $('#table2').datagrid('getChecked');
            if (rows.length > 0) {
                var iCustomerRecNo = 0;
                iCustomerRecNo = rows[0].iBscDataCustomerRecNo;
                for (var i = 1; i < rows.length; i++) {
                    if (iCustomerRecNo != rows[i].iBscDataCustomerRecNo) {
                        alert("一次只能转入同一个加工厂商的入库记录！");
                        return;
                    }
                }

                Page.setFieldValue("iBscDataCustomerRecNo", iCustomerRecNo);
                for (var i = 0; i < rows.length; i++) {
                    var appRow = {};
                    appRow.iBscDataMatRecNo = rows[i].iBscDataMatRecNo;
                    appRow.fQty = rows[i].fNoInQty;
                    appRow.sOrderNo = rows[i].sOrderNo;
                    appRow.fPrice = isNaN(parseFloat(rows[i].fPrice)) ? 0 : parseFloat(rows[i].fPrice);
                    appRow.fTotal = isNaN(parseFloat(rows[i].fNoInTotal)) ? 0 : parseFloat(rows[i].fNoInTotal);
                    appRow.fPurQty = rows[i].fPurQty;
                    appRow.iSDOrderMRecNo = rows[i].iSdOrderMRecNo;
                    appRow.sCode = rows[i].sBscDataFabCode;
                    appRow.sName = rows[i].sBscDataFabName;
                    appRow.sProOutProduceBillNo = rows[i].sBillNo;
                    appRow.iProOutProduceDRecNo = rows[i].iRecNo;
                    Page.tableToolbarClick("add", "table1", appRow);
                }
                $("#tabTop").tabs("select", 1);
            }
        }

        function flagFinish() {
            var selectRows = $("#table2").datagrid("getChecked");
            if (selectRows.length > 0) {

                $.messager.confirm("您确认标记完成吗？", "您确认标记完成吗？", function (r) {
                    if (r) {
                        for (var i = 0; i < selectRows.length; i++) {
                            var jsonobj = {
                                StoreProName: "SpProOutProduceDFinish",
                                StoreParms: [
                                    {
                                        ParmName: "@iformid",
                                        Value: 1
                                    },
                                    {
                                        ParmName: "@keys",
                                        Value: selectRows[i].iRecNo
                                    }
                                    ,
                                    {
                                        ParmName: "@userid",
                                        Value: Page.userid
                                    }
                                    ,
                                    {
                                        ParmName: "@btnid",
                                        Value: "aa"
                                    }
                                    ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                alert(result)
                            }
                            else {
                                search1();
                            }

                        }
                    }
                })
            }
        }

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

        Page.beforeSave = function () {
            if (checkMonth() == false) {
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="未入库外加工单" data-options="fit:true">
            <table id="table2">
            </table>
        </div>
        <div title="外加工入库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <div style="display: none;">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBillType" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <td>
                                入库单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                入库日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                仓库
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td>
                                入库单位
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCompany" Style="width: 140px;" />
                            </td>
                        </tr>
                        <tr>
                            <td id="iBscDataCustomerRecNo3">
                                外加工商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px" />
                            </td>
                            <td id="Td1">
                                会计月份
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sYearMonth" Style="width: 150px"
                                    Z_readOnly="True" Z_Required="True" />
                            </td>
                            <td>
                                <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                <label for="__ExtCheckbox1">
                                    红冲</label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan='7'>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="99%" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_readOnly="True" />
                            </td>
                            <td style="display: none;">
                                金额
                            </td>
                            <td style="display: none;">
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
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="入库明细">
                            <table id="table1" tablename="MMStockInD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
