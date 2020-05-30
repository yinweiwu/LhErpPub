<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var lastSelectedPurOrderDRecNo = undefined;
        var showPurOrderDRecNo = undefined;
        $(function () {
            if (Page.usetype == "add" || Page.usetype == "modify") {
                $("#tabPurOrderD").datagrid(
            {
                fit: true,
                border: false,
                remoteSort: false,
                singleSelect: true,
                columns: [[
                        { title: "采购订单号", field: "sBillNo", width: 110, sortable: true },
                        { title: "入库", field: "btnIn", width: 80, align: "center", formatter: function (value, row, index) {
                            var str = JSON2.stringify(row);
                            var btnStr = "<input id='btn" + index + "' type='button' onclick='btnIn(" + str + ", " + index + ")' value='入库' />";
                            return btnStr;
                        }
                        },
                        { title: "存货编码", field: "sCode", width: 120, sortable: true },
                        { title: "存货名称", field: "sName", width: 120, sortable: true },
                        { title: "色号", field: "sColorID", width: 80, sortable: true },
                        { title: "颜色", field: "sColorName", width: 80, sortable: true },
                        { title: "总数量", field: "fQty", width: 80, sortable: true },
                        { title: "总金额", field: "fTotal", width: 80, sortable: true },
                        { title: "未入库数量", field: "fNotInQty", width: 80, sortable: true },
                        { title: "未入库金额", field: "fNotInTotal", width: 80, sortable: true },
                        { title: "已入库数量", field: "fInQty", width: 80, sortable: true },
                        { title: "已入库金额", field: "fInTotal", width: 80, sortable: true },
                        { title: "计量单位", field: "sUnitName", width: 80, sortable: true },
                        { title: "日期", field: "dDate1", width: 120, sortable: true },
                        { title: "供应商", field: "sCustShortName", width: 120, sortable: true },
                        { title: "采购员", field: "sPurPersonName", width: 80, sortable: true },
                        { field: "iRecNo", hidden: true },
                        { field: "iBscDataCustomerRecNo", hidden: true },
                        { field: "sBscDataPersonID", hidden: true },
                        { field: "iSdOrderMRecNo", hidden: true },
                        { field: "fProductWidth", hidden: true },
                        { field: "fProductWeight", hidden: true }
                    ]],
                onSelect: function (index, row) {
                    lastSelectedPurOrderDRecNo = row.iRecNo;
                },
                onDblClickRow: function (index, row) {
                    btnIn(row, index);
                }
            });
                searchPurOrderMD();
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
        function btnIn(row, index) {
            lastSelectedPurOrderDRecNo = row.iRecNo;
            showPurOrderDRecNo = row.iRecNo;
            var sqlObjPurOrderMD = {
                TableName: "vwPurOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                            {
                                Field: "iRecNo",
                                ComOprt: "=",
                                Value: "'" + row.iRecNo + "'"
                            }
                ]
            };
            var resultPurOrderMD = SqlGetData(sqlObjPurOrderMD);
            if (resultPurOrderMD.length > 0) {
                $("#tabTop").tabs("select", "采购入库单");
                Page.setFieldValue("iBscDataCustomerRecNo", resultPurOrderMD[0].iBscDataCustomerRecNo);
                Page.setFieldValue("iPurOrderDRecNo", resultPurOrderMD[0].iRecNo);
                Page.setFieldValue("sCode", resultPurOrderMD[0].sCode);
                Page.setFieldValue("sName", resultPurOrderMD[0].sName);
                Page.setFieldValue("fProductWidth", resultPurOrderMD[0].fProductWidth);
                Page.setFieldValue("fProductWeight", resultPurOrderMD[0].fProductWeight);
                Page.setFieldValue("sColorID", resultPurOrderMD[0].sColorID);
                Page.setFieldValue("sColorName", resultPurOrderMD[0].sColorName);
                //Page.setFieldValue("sUnitName", resultPurOrderMD[0].sUnitName);
                Page.setFieldValue("sPurUnitName", resultPurOrderMD[0].sPurUnitName);
                Page.setFieldValue("fPrice", resultPurOrderMD[0].fPrice);
                Page.setFieldValue("iSdOrderMRecNo", resultPurOrderMD[0].iSdOrderMRecNo);
                //                Page.setFieldValue("sPurUnitName", resultPurOrderMD[0].sPurUnitName);
                //                Page.setFieldValue("sPurUnitName", resultPurOrderMD[0].sPurUnitName);
            }
            $("#MMStockProductInD").datagrid("loadData", []);
        }
        function searchPurOrderMD() {
            var sqlObjPurOrderMD = {
                TableName: "vwPurOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                            {
                                Field: "ISNULL(fQty,0)",
                                ComOprt: ">",
                                Value: "ISNULL(fInQty,0)",
                                LinkOprt: "and"
                            },
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
                        SortOrder: "asc"
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
            var rows = $("#" + tableid).datagrid("getRows");
            var row = rows[rows.length - 1];
            var iBscDataStockDRecNo = Page.getFieldValue("iBscDataStockDRecNo");
            var sBerChID = Page.getFieldText("iBscDataStockDRecNo");
            $("#" + tableid).datagrid("updateRow", { index: rows.length - 1, row: { iBscDataStockDRecNo: iBscDataStockDRecNo, sBerChID: sBerChID} });
        }

        Page.Children.onEndEdit = function (tableid, index, row, changes) {
            if (tableid == "MMStockProductInD") {
                var iCalc = Page.getFieldValue("iCalc");
                if (iCalc == "1") {
                    if (datagridOp.currentColumnName == "fPurQty" && changes.fPurQty != undefined && changes.fPurQty != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var fPurQty = isNaN(parseFloat(row.fPurQty)) ? 0 : parseFloat(row.fPurQty);
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fQty: fQty} });
                    }
                }
                var iCalc2 = Page.getFieldValue("iCalc2");
                if (iCalc2 == "1") {
                    if (datagridOp.currentColumnName == "sLetCode" && changes.sLetCode != undefined && changes.sLetCode != null) {
                        var fProductWidth = isNaN(parseFloat(Page.getFieldValue("fProductWidth"))) ? 0 : parseFloat(Page.getFieldValue("fProductWidth"));
                        var fProductWeight = isNaN(parseFloat(Page.getFieldValue("fProductWeight"))) ? 0 : parseFloat(Page.getFieldValue("fProductWeight"));
                        var sLetCode = isNaN(parseFloat(row.sLetCode)) ? 0 : parseFloat(row.sLetCode);
                        var fPurQty = sLetCode * 0.9144;
                        var fQty = fPurQty * fProductWidth / 100 * fProductWeight / 1000;
                        $("#MMStockProductInD").datagrid("updateRow", { index: index, row: { fQty: fQty, fPurQty: fPurQty} });
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true">
        <div title="未入库采购订单明细">
            <table id="tabPurOrderD">
            </table>
        </div>
        <div title="采购入库单">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden;">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtHidden2 ID="ExtHidden1" Z_FieldID="iBillType" Z_Value="1" runat="server" />
                        <cc1:ExtHidden2 ID="ExtHidden2" Z_FieldID="iSdOrderMRecNo" runat="server" />
                        <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
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
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iPurOrderDRecNo" Style="width: 150px;" />
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
                                存货编码
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iBscDataMatRecNo" Style="width: 150px;" />
                            </td>
                            <td>
                                存货名称
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sName" Z_NoSave="True"
                                    Z_readOnly="True" Style="width: 150px;" />
                            </td>
                            <td>
                                色号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="iBscDataColorRecNo"
                                    Style="width: 150px;" />
                            </td>
                            <td>
                                颜色
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sColorName" Z_NoSave="True"
                                    Z_readOnly="True" Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                幅宽
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox219" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" />
                            </td>
                            <td>
                                克重
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox220" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" />
                            </td>
                            <td>
                                单价
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox215" runat="server" Z_FieldID="fPrice" Z_readOnly="True"
                                    Width="150px" Z_NoSave="True" />
                            </td>
                            <td>
                                入库数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="fQty" Z_readOnly="True"
                                    Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                入库金额
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox217" runat="server" Z_FieldID="fTotal" Z_readOnly="True"
                                    Width="150px" />
                            </td>
                            <td>
                                缸号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox218" runat="server" Z_FieldID="sBatchNo" />
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
                                    码换算重量</label>
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
