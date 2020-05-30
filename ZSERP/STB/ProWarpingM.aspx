<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#tabSDContractD").datagrid({
                fit: true,
                border: false,
                columns: [
                    [
                        { field: "__ck", width: 40, checkbox: true },
                        { field: "sIden", title: "标识", align: "center", width: 40 },
                        { field: "sOrderNo", title: "生产单号", align: "center", width: 100 },
                        { field: "sCode", title: "产品编号", align: "center", width: 80 },
                        { field: "sFlowerCode", title: "花本型号", align: "center", width: 80 },
                        { field: "fProductWidth", title: "幅宽", align: "center", width: 50 },
                        { field: "fProductWeight", title: "克重", align: "center", width: 50 },
                        { field: "fWarpingPlanQty", title: "计划生产米数", align: "center", width: 60 },
                        { field: "fWarpingArrQty", title: "已排米数", align: "center", width: 60 },
                        { field: "fNotWarpingArrQty", title: "未排米数", align: "center", width: 80 },
                        { field: "sWarpingArrFinish", title: "安排完成", align: "center", width: 80 },
                        { field: "sWarpStatus", title: "经线状态", align: "center", width: 50 },
                        {
                            field: "__stock", title: "经线库存", align: "center", width: "80", formatter: function (value, row, index) {
                                return "<a href='#' onclick='showStock(" + index + ")'>查看库存</a>";
                            }
                        },
                        { field: "iBscDataMatRecNo", hidden: true },
                        { field: "iBscDataColorRecNo", hidden: true },
                        { field: "iRecNo", hidden: true }
                    ]
                ],
                toolbar: "#divOrderMenu",
                rownumbers: true,
                pagination: true,
                pageSize: 50,
                pageList: [50, 100, 200, 500],
                remoteSort: false,
                loadFilter: pagerFilter
            });
            if (Page.usetype != "add") {
                $("#divTab").tabs("select", 1);
            }
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table1", "copy");

            var sqlObjIden = {
                TableName: "BscDataListD",
                Fields: "sName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "sClassID",
                        ComOprt: "=",
                        Value: "'productIden'"
                    }
                ]
            }
            var resultIden = SqlGetData(sqlObjIden);
            $("#txbMenuIden").combobox("loadData", resultIden);

            $("#tabYarnStock").datagrid({
                fit: true,
                border: false,
                columns: [
                    [
                        { field: "sYarnCode", title: "纱线编号", align: "center", width: 100 },
                        { field: "sYarnName", title: "纱线名称", align: "center", width: 80 },
                        { field: "sYarnElements", title: "规格型号", align: "center", width: 80 },
                        { field: "sColorID", title: "色号", align: "center", width: 80 },
                        { field: "sColorName", title: "颜色", align: "center", width: 80 },
                        { field: "sTypeName", title: "类型", align: "center", width: 60 },
                        {
                            field: "fNeedQty", title: "需求量", align: "center", width: 80, styler: function (value, row, index) {
                                return "color:blue;font-weight:bold;";
                            }
                        },
                        {
                            field: "fStockQty", title: "库存量", align: "center", width: 80, styler: function (value, row, index) {
                                if (isNaN(row.fStockQty)) {
                                    return "color:red;font-weight:bold;";
                                } else if (Number(row.fStockQty) >= Number(row.fNeedQty)) {
                                    return "color:green;font-weight:bold;";
                                } else if (Number(row.fStockQty) < Number(row.fNeedQty)) {
                                    return "color:red;font-weight:bold;";
                                }
                            }
                        }
                    ]
                ],
                rownumbers: true,
                remoteSort: false
            })
        })
        function loadNotice() {
            var sIden = $("#txbMenuIden").textbox("getValue");
            var sOrderNo = $("#txbMenuOrderNo").textbox("getValue");
            var sCode = $("#txbMenuCode").textbox("getValue");
            var sFlowerCode = $("#txbMenuFlowerCode").textbox("getValue");
            var Filters = [
                {
                    Field: "iStatus",
                    ComOprt: "=",
                    Value: "4",
                    LinkOprt: "and"
                },
                {
                    Field: "isnull(dReceiveDate,'2299-12-31')",
                    ComOprt: "<>",
                    Value: "'2299-12-31'",
                    LinkOprt: "and"
                },
                {
                    Field: "iOrderType",
                    ComOprt: "=",
                    Value: "2"
                }
            ]
            var checked = $("#ckbFinish")[0].checked;
            if (checked == false) {
                Filters[Filters.length - 1].LinkOprt = "and",
                Filters.push({
                    Field: "isnull(iWarpingArrFinish,0)",
                    ComOprt: "=",
                    Value: "0"
                })
            }

            if (sIden != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sIden",
                    ComOprt: "=",
                    Value: "'" + sIden + "'"
                })
            }
            if (sOrderNo != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sOrderNo",
                    ComOprt: "like",
                    Value: "'%" + sOrderNo + "%'"
                })
            }
            if (sCode != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sCode",
                    ComOprt: "like",
                    Value: "'%" + sCode + "%'"
                })
            }
            if (sFlowerCode != "") {
                Filters[Filters.length - 1].LinkOprt = "and";
                Filters.push({
                    Field: "sFlowerCode",
                    ComOprt: "like",
                    Value: "'%" + sFlowerCode + "%'"
                })
            }
            var sqlObj = {
                TableName: "vwSDContractMD",
                Fields: "iRecNo,sOrderNo,sIden,iBscDataMatRecNo,iBscDataColorRecNo,sCode,sFlowerCode,fProductWidth,fProductWeight,fProduceQty,fWarpingPlanQty,fWarpingArrQty,fNotWarpingArrQty,sWarpStatus,sWarpingArrFinish",
                SelectAll: "True",
                Filters: Filters,
                Sorts: [
                    {
                        SortName: "sIden",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sCode",
                        SortOrder: "asc"
                    },
                    {
                        SortName: "sProductDate",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabSDContractD").datagrid("loadData", result);
        }

        function TurnTo() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                var isIdenSame = true;
                var sIden = checkedRows[0].sIden;
                $.each(checkedRows, function (index, o) {
                    if (o.sIden != sIden) {
                        isIdenSame = false;
                        return false;
                    }
                });
                if (isIdenSame == false) {
                    Page.MessageShow("只能转入标识相同的明细", "只能转入标识相同的明细");
                }
                else {
                    $("#table1").datagrid("loadData", []);
                    $.each(checkedRows, function (index, o) {
                        var appendRow = {
                            iBscDataMatRecNo: o.iBscDataMatRecNo,
                            iBscDataColorRecNo: o.iBscDataColorRecNo,
                            iSDContractDRecNo: o.iRecNo,
                            fNotWarpingArrQty: o.fNotWarpingArrQty,
                            sOrderNo: o.sOrderNo,
                            sCode: o.sCode,
                            sFlowerCode: o.sFlowerCode,
                            fProductWidth: o.fProductWidth,
                            fProductWeight: o.fProductWeight
                        }
                        Page.tableToolbarClick("add", "table1", appendRow);
                    });
                    Page.setFieldValue("sIden", sIden);
                    $("#divTab").tabs("select", 1);
                }
            }
            else {
                Page.MessageShow("请选择行", "请选择行");
            }
        }

        function doFinish() {
            var checkedRows = $("#tabSDContractD").datagrid("getChecked");
            if (checkedRows.length > 0) {
                $.messager.confirm("您确认标记完成吗?", "您确认标记所选生产明细整经安排完成吗?", function (r) {
                    if (r) {
                        var RecNoStr = "";
                        $.each(checkedRows, function (index, o) {
                            RecNoStr += o.iRecNo + ","
                        })
                        RecNoStr = RecNoStr.substr(0, RecNoStr.length - 1);
                        var jsonobj = {
                            StoreProName: "SpSDContractDArrFinish",
                            StoreParms: [{
                                ParmName: "@sRecNoStr",
                                Value: RecNoStr,
                                Size: -1
                            }, {
                                ParmName: "@iType",
                                Value: 0
                            }
                            ]
                        }
                        var result = SqlStoreProce(jsonobj);
                        if (result != "1") {
                            Page.MessageShow("错误", result);
                        }
                        else {
                            Page.MessageShow("成功", "标记成功");
                            loadNotice();
                        }

                    }
                })
            }
        }

        function showStock(index) {
            var iRecNo = $("#tabSDContractD").datagrid("getRows")[index].iRecNo;
            var sqlObj = {
                TableName: "vwSDContractDMatWasteD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + iRecNo + "'"
                    }
                ],
                Sorts: [
                    {
                        SortName: "iRecNo",
                        SortOrder: "asc"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            $("#tabYarnStock").datagrid("loadData", result);
            $("#divYarnStock").window("open");
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
    <div id="divTab" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="生产通知单" data-options="border:false">
            <table id="tabSDContractD"></table>
        </div>
        <div title="整经单" data-options="border:false">
            <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
                <div data-options="region:'north',border:false" style="overflow: hidden;">
                    <!—如果只有一个主表，这里的north要变为center-->
                    <div id="divHiden" style="display: none;">
                        <!--隐藏字段位置-->
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sIden" />
                    </div>
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>整经单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                            </td>
                            <td>日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期" />
                            </td>
                            <td>整经工
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPersonID" />
                            </td>
                            <td>机台
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sMachineID" />
                            </td>
                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>米数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" />
                            </td>
                            <td>计划开始日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="dPlanBeginDate" Z_FieldType="日期" />
                            </td>
                            <td>计划截止日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dPlanEndDate" Z_FieldType="日期" />
                            </td>
                            <td>外加工商
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="iBscDataCustomerRecNo" />
                            </td>
                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>匹长
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fRollLength" Z_FieldType="数值" />
                            </td>
                            <td>数量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iQty" Z_FieldType="数值" />
                            </td>
                            <td>门幅
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fProductWidth" Z_FieldType="数值" />
                            </td>
                            
                            <td>备注
                            </td>
                            <td>
                                <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Style="width: 99%" Z_FieldID="sRemark" />
                            </td>
                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sUserID" Z_readOnly="true" />
                            </td>
                            <td>制单日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dInputDate" Z_readOnly="true" Z_FieldType="时间" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center',border:false">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="整经明细">
                            <!--子表1  -->
                            <table id="table1" tablename="ProWarpingD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divOrderMenu" style="display: none;">
        <table>
            <tr>
                <td>标识
                </td>
                <td>
                    <input id="txbMenuIden" class="easyui-combobox" data-options="valueField:'sName',textField:'sName'" style="width: 100px;" type="text" />
                </td>
                <td>生产单号
                </td>
                <td>
                    <input id="txbMenuOrderNo" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>产品编号
                </td>
                <td>
                    <input id="txbMenuCode" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>花本型号
                </td>
                <td>
                    <input id="txbMenuFlowerCode" class="easyui-textbox" style="width: 100px;" type="text" />
                </td>
                <td>
                    <input type="checkbox" id="ckbFinish" />
                    <label for="ckbFinish">包含已完成</label>
                </td>
                <td>
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-ok'" href="#" onclick="doFinish()">标记完成</a>
                </td>
                <td style="width: 30px;"></td>
                <td>
                    <a class="button orange" data-options="iconCls:'icon-search'" href="#" onclick="loadNotice()">查询</a>
                </td>
                <td style="width: 5px;"></td>
                <td style="padding-left: 10px;">
                    <a class="button orange" href="#" onclick="TurnTo()">转入</a>
                </td>
            </tr>
        </table>
    </div>
    <div id="divYarnStock" class="easyui-window" data-options="title:'纱线库存',width:700,height:400,closed:true,collapsible:false,minimizable:false,maximizable:false">
        <table id="tabYarnStock">
        </table>
    </div>
</asp:Content>

