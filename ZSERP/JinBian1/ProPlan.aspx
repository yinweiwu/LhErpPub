<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 843px;
        }
        .style2
        {
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
                            if (isFishiLoaded == false) {
                                $.messager.progress({ title: "正在加载，请稍候..." });
                                setTimeout(function () {
                                    searchFinishSDOrderM();
                                    isFishiLoaded = true;
                                    $.messager.progress("close");
                                }, 500);

                            }
                        }
                    }
                });

                $("#SDOrderM").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                        { title: "染色", field: "btnPro", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnPro(" + str + ", " + index + ")' value='染色' />";
                            return btnStr;
                        }
                        },
                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                        { title: "幅宽", field: "fProductWidth", width: 60, sortable: true },
                        { title: "克重", field: "fProductWeight", width: 60, sortable: true },
                        { title: "坯布编号", field: "sBscDataFabCode", width: 80, sortable: true },
                        { title: "坯布名称", field: "sBscDataFabName", width: 80, sortable: true },
                        { title: "需坯布重量", field: "fNeedFabQty", width: 80, sortable: true },
                        { title: "未点色重量", field: "fNotDyeQty", width: 80, sortable: true },
                        { title: "已点色重量", field: "fDyeQty", width: 80, sortable: true },
                        { title: "业务员", field: "sOrderUserName", width: 80, sortable: true },
                        { title: "完成", field: "btnFinsiPro", width: 80, formatter: function (value, row, index) {
                            var btnFinishStr = "<input id='btnFinish" + index + "' type='button' onclick='btnFinishPro(" + index + ")' value='完成' />";
                            return btnFinishStr;
                        }
                        },
                        { field: "iRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true }
                    ]],
                    onDblClickRow: function (index, row) {
                        btnPro(row, index);
                    }
                }
                );
                $("#SDOrderMFinish").datagrid(
                {
                    fit: true,
                    border: false,
                    remoteSort: false,
                    singleSelect: true,
                    columns: [[
                        { title: "订单号", field: "sOrderNo", width: 110, sortable: true },
                        { title: "产品编码", field: "sCode", width: 120, sortable: true },
                        { title: "产品名称", field: "sName", width: 120, sortable: true },
                        { title: "幅宽", field: "fProductWidth", width: 60, sortable: true },
                        { title: "克重", field: "fProductWeight", width: 60, sortable: true },
                        { title: "坯布编号", field: "sBscDataFabCode", width: 80, sortable: true },
                        { title: "坯布名称", field: "sBscDataFabName", width: 80, sortable: true },
                        { title: "需坯布重量", field: "fNeedFabQty", width: 80, sortable: true },
                        { title: "未点色重量", field: "fNotDyeQty", width: 80, sortable: true },
                        { title: "已点色重量", field: "fDyeQty", width: 80, sortable: true },
                        { title: "业务员", field: "sOrderUserName", width: 80, sortable: true },
                        { title: "完成类型", field: "sFinishType", width: 80, sortable: true },
                        { title: "撤销完成", field: "btnCancelFinish", width: 80, formatter: function (value, row, index) {
                            if (row.sFinishType == "手动完成") {
                                var btnFinishStr = "<input id='btnCancelFinish" + index + "' type='button' onclick='btnCancelFinish(" + index + ")' value='撤销完成' />";
                                return btnFinishStr;
                            }
                        }
                        },
                        { field: "iRecNo", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true }
                    ]],
                    onDblClickRow: function (index, row) {
                        btnPro(row, index);
                    },
                    pagination: true,
                    pageSize: 30,
                    pageList: [30, 100, 300, 500],
                    loadFilter: pagerFilter
                }
                );

                searchSDOrderM();
                //searchFinishSDOrderM();
                if (Page.usetype == "modify") {
                    $("#tabTop").tabs("select", 1);
                }
            }
            if (Page.usetype == "modify" || Page.usetype == "view") {
                if (Page.usetype == "view") {
                    $("#tabTop").tabs("close", "未下染色单的订单");
                }

                var sqlobj2 = { TableName: "vwProPlanM",
                    Fields: "sOrderNo,sCode,sName,sBscDataFabCode",
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
                Page.setFieldValue('sBscDataFabCode', data2[0].sBscDataFabCode);

            }
        });

        function btnPro(row, index) {
            Page.setFieldValue("sOrderNo", row.sOrderNo);
            Page.setFieldValue("iSdOrderMRecNo", row.iSdOrderMRecNo);
            Page.setFieldValue("sCode", row.sCode);
            Page.setFieldValue("sName", row.sName);
            Page.setFieldValue("sBscDataFabCode", row.sBscDataFabCode);
            //Page.setFieldValue("fFabQty", row.fNotProFabQty);

            var sqlObjSDOrderFabD = {
                TableName: "vwSDOrderFabD_ProPlan",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                            {
                                Field: "iMainRecNo",
                                ComOprt: "=",
                                Value: "'" + row.iRecNo + "'"
                            }
                            ]
            };
            var resultSDOrderFabD = SqlGetData(sqlObjSDOrderFabD);
            $("#tabTop").tabs("select", "染色点色单");
            $("#ProPlanD").datagrid("loadData", []);
            if (resultSDOrderFabD.length > 0) {
                for (var i = 0; i < resultSDOrderFabD.length; i++) {
                    var appRow = {};
                    appRow.iSerial = resultSDOrderFabD[i].iSerial;
                    appRow.iBscDataColorRecNo = resultSDOrderFabD[i].iBscDataColorRecNo;
                    appRow.sColorID = resultSDOrderFabD[i].sColorID;
                    appRow.sColorName = resultSDOrderFabD[i].sColorName;
                    appRow.fQty = resultSDOrderFabD[i].fQty;
                    appRow.fNotProQty = resultSDOrderFabD[i].fQty;
                    appRow.iBscDataColorRecNo = resultSDOrderFabD[i].iBscDataColorRecNo;
                    appRow.sReMark = resultSDOrderFabD[i].sFabReMark;
                    appRow.iSdOrderDRecNo = resultSDOrderFabD[i].iRecNo;
                    appRow.fPrice = 0;
                    appRow.fTotal = 0;
                    Page.tableToolbarClick("add", "ProPlanD", appRow);
                }
            }

            var sqlObj = { TableName: "BscDataListD",
                Fields: "*",
                SelectAll: "True",
                Filters: [{ Field: "sClassID", ComOprt: "=", Value: "'sColorItem'"}]
            };
            var data = SqlGetData(sqlObj);
            if (data.length > 0) {
                $("#Table2").datagrid("loadData", []);
                var colorAsk = [];
                var iSdOrderMRecNo = Page.getFieldValue("iSdOrderMRecNo")
                var sqlObj1 = {
                    TableName: "SDOrderM",
                    Fields: "iBscDataMatRecNo,iBscDataCustomerRecNo",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iRecNo",
                            ComOprt: "=",
                            Value: "'" + iSdOrderMRecNo + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj1);
                if (result.length > 0) {
                    var sqlObj2 = {
                        TableName: "vwProPlanM",
                        Fields: "iRecNo",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iBscDataMatRecNo",
                                ComOprt: "=",
                                Value: "'" + result[0].iBscDataMatRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "iOrderBscDataCustomerRecNo",
                                ComOprt: "=",
                                Value: "'" + result[0].iBscDataCustomerRecNo + "'",
                                LinkOprt: "and"
                            },
                            {
                                Field: "sUserID",
                                ComOprt: "=",
                                Value: "'" + Page.userid + "'"
                            }
                        ],
                        Sorts: [
                            {
                                SortName: "dInputDate",
                                SortOrder: "desc"
                            }
                        ]
                    }
                    var result1 = SqlGetData(sqlObj2);
                    if (result1.length > 0) {
                        var sqlObj3 = {
                            TableName: "ProPlanDColor",
                            Fields: "sItemName,sAsk",
                            SelectAll: "True",
                            Filters: [
                                {
                                    Field: "iMainRecNo",
                                    ComOprt: "=",
                                    Value: "'" + result1[0].iRecNo + "'"
                                }
                            ]
                        }
                        colorAsk = SqlGetData(sqlObj3);
                    }
                }
                for (var i = 0; i < data.length; i++) {
                    var addRow = {};
                    addRow.sItemName = data[i].sName;
                    if (colorAsk.length > 0) {
                        for (var j = 0; j < colorAsk.length; j++) {
                            if (data[i].sName == colorAsk[j].sItemName) {
                                addRow.sAsk = colorAsk[j].sAsk;
                                break;
                            }
                        }
                    }
                    Page.tableToolbarClick("add", "Table2", addRow);
                }
            }
        }

        function btnFinishPro(index) {
            $.messager.confirm("您确认完成？", "您确认完成所选择行吗？", function (r) {
                if (r) {
                    var selectRow = $("#SDOrderM").datagrid("getRows")[index];
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
                            Value: 1
                        }
                        ]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result == "1") {
                        $("#SDOrderM").datagrid("deleteRow", index);
                        searchFinishSDOrderM();
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
                    Field: "fNotDyeQty",
                    ComOprt: ">",
                    Value: "0",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(iColorFinish,0)",
                    ComOprt: "=",
                    Value: "0",
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
                $("#SDOrderM").datagrid("loadData", resultSDOrderM);
            }
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
            var rowsColor = $("#Table2").datagrid("getRows");
            var isFill = false;
            for (var i = 0; i < rowsColor.length; i++) {
                if (rowsColor[i].sAsk != "" && rowsColor[i].sAsk != undefined && rowsColor[i].sAsk != null) {
                    isFill = true;
                    break;
                }
            }
            if (isFill == false) {
                Page.MessageShow("染色要求尚未填写", "对不起，染色要求尚未填写！");
                return false;
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="border:false,height:700">
        <div title="未完成染色单的订单">
            <table id="SDOrderM">
            </table>
        </div>
        <div title="染色点色单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
                    </div>
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                染色单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                            <td>
                                订单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                                    Z_readOnly="True" />
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iSdOrderMRecNo" Style="display: none;" />
                            </td>
                            <td>
                                下单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>
                                染厂
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                    Style="width: 150px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldType="日期" Z_FieldID="dDeliverDate" />
                            </td>
                            <td>
                                产品编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                产品名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                坯布编号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="sBscDataFabCode" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                坯布重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fFabQty" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td>
                                金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fTotal" Z_NoSave="True"
                                    Z_readOnly="True" />
                            </td>
                            <td colspan="2">
                                <cc1:ExtCheckbox2 ID="ExtCheckbox4" Z_FieldID="iRed" runat="server" />
                                <label for="__ExtCheckbox4">
                                    是否成品改色</label>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                                    Z_Required="False" Width="120px" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                                    Z_readOnly="True" Width="120px" />
                            </td>
                        </tr>
                    </table>
                    <table class="tabmain">
                        <tr>
                            <td class="style2">
                                备注
                            </td>
                            <td class="style1">
                                <textarea id="sReMark" style="border-bottom: 1px solid black; width: 839px; border-left-style: none;
                                    border-left-color: inherit; border-left-width: 0px; border-right-style: none;
                                    border-right-color: inherit; border-right-width: 0px; border-top-style: none;
                                    border-top-color: inherit; border-top-width: 0px;" fieldid="sReMark"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="染色单明细">
                            <!--  子表1  -->
                            <table id="ProPlanD" tablename="ProPlanD">
                            </table>
                        </div>
                        <div data-options="fit:true" title="染色要求">
                            <!--  子表1  -->
                            <table id="Table2" tablename="ProPlanDColor">
                            </table>
                        </div>
                        <div data-options="fit:true" title="备注">
                            <!--  子表1  -->
                            <table id="Table1" tablename="ProPlanDRemark">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div title="已完成染色单的订单">
            <table id="SDOrderMFinish">
            </table>
        </div>
</asp:Content>
