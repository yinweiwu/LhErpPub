<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            //            $("#table1").datagrid({
            //                fit: true,
            //                toolbar: "",
            //                rownumbers: true,
            //                remoteSort: false,
            //                columns: [[
            //                { title: "序号", field: "iSerial", width: 30 },
            //                { title: "存货编码", field: "iSerial", width: 100 },
            //                { title: "存货名称", field: "iSerial", width: 80 },
            //                { title: "规格", field: "iSerial", width: 80 },
            //                { title: "供应商/客户", field: "iSerial", width: 80 },
            //                { title: "单价", field: "iSerial", width: 60 },
            //                { title: "换算系数", field: "iSerial", width: 60 },

            //                { title: "上期结存件数", field: "iSerial", width: 60 },
            //                { title: "上期结存数量", field: "iSerial", width: 60 },
            //                { title: "上期结存金额", field: "iSerial", width: 60 },
            //                { title: "本期入库件数", field: "iSerial", width: 60 },
            //                { title: "本期入库数量", field: "iSerial", width: 60 },
            //                { title: "本期入库金额", field: "iSerial", width: 60 },
            //                { title: "本期出库件数", field: "iSerial", width: 60 },
            //                { title: "本期出库数量", field: "iSerial", width: 60 },
            //                { title: "本期出库金额", field: "iSerial", width: 60 },

            //                { title: "调拨件数", field: "iSerial", width: 60 },
            //                { title: "调拨数量", field: "iSerial", width: 60 },
            //                { title: "调拨金额", field: "iSerial", width: 60 },

            //                { title: "盘点盈亏件数", field: "iSerial", width: 60 },
            //                { title: "盘点盈亏数量", field: "iSerial", width: 60 },
            //                { title: "盘点盈亏金额", field: "iSerial", width: 60 },

            //                { title: "本期结存件数", field: "iSerial", width: 60 },
            //                { title: "本期结存数量", field: "iSerial", width: 60 },
            //                { title: "本期结存金额", field: "iSerial", width: 60 }

            //            ]]
            //            })
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            //Page.Children.toolBarBtnDisabled("table1", "begin");
            Page.Children.toolBarBtnDisabled("table1", "copy");
            Page.Children.toolBarBtnAdd("table1", "begin", "开始月结", "edit", function () {
                var sYearMoth = Page.getFieldValue("sYearMonth");
                if (sYearMoth == "") {
                    alert("请先选择会计月份");
                    return false;
                }
                var stockRecNo = Page.getFieldValue("iBscDataStockMRecNo");
                if (stockRecNo == "") {
                    alert("请先选择仓库");
                    return false;
                }
                $.messager.progress({ title: "正在处理，请稍候..." });
                var jsonobj = {
                    StoreProName: "SpStockMonthly",
                    StoreParms: [
                    {
                        ParmName: "@iBscDataStoreMRecno",
                        Value: stockRecNo
                    },
                    {
                        ParmName: "@sYearMonth",
                        Value: sYearMoth
                    },
                    {
                        ParmName: "@iRecNo",
                        Value: Page.key
                    },
                    {
                        ParmName: "@sErrMsg",
                        Direction: "OUTPUT"
                    }
                    ]
                }
                var result = SqlStoreProce(jsonobj, true, true, true, function (responseText) {
                    try {
                        var resultObj = JSON2.parse(responseText);
                        if (resultObj.success == true) {
                            var result = resultObj.tables[0];
                            if (result.length > 0) {
                                $("#table1").datagrid("loadData", result);
                            }
                        }
                        else {
                            alert(resultObj.message);
                        }
                        $.messager.progress('close');
                        //var allRows = $("#table1").datagrid("getData");
                        //alert(allRows.length);
                    }
                    catch (e) {
                        alert(e.message);
                        $.messager.progress('close');
                    }
                });

            });

            if (Page.usetype == "add") {
                //设置会计月份
                var SqlObjYearMonth = {
                    TableName: "bscDataPeriod",
                    Fields: "sYearMonth",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "dBeginDate",
                    ComOprt: "<=",
                    Value: "getdate()",
                    LinkOprt: "and"
                },
                {
                    Field: "dEndDate",
                    ComOprt: ">=",
                    Value: "getdate()"
                }
            ]
                }
                var resultYearMonth = SqlGetData(SqlObjYearMonth);
                if (resultYearMonth.length > 0) {
                    setTimeout(function () {
                        Page.setFieldValue('sYearMonth', resultYearMonth[0].sYearMonth);
                    }, 1500);
                }

                //Page.setFieldValue('sPerson', Page.userid);
                $("#table1").datagrid({
                    pagination: true,
                    pageSize: 50,
                    pageList: [50, 200, 500, 1000],
                    loadFilter: pagerFilter
                });
            }
            if (Page.usetype == "view") {
                Page.Children.toolBarBtnDisabled("table1", "begin");
            }
        })

        Page.Children.onBeforeEdit = function (tableid, index, row) {
            return false;
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
            if (checkMonth == false) {
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        月结单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_readOnly="True" />
                    </td>
                    <td>
                        月结日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Z_Required="False" />
                    </td>
                    <td>
                        仓库
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Z_Required="False" />
                    </td>
                    <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sYearMonth" Z_Required="False" />
                    </td>
                </tr>
                <tr>
                    <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sPerson" />
                    </td>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_Required="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="月结明细">
                    <!--  子表1  -->
                    <table id="table1" tablename='MMStockMonthD'>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
