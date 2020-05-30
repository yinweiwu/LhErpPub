<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script language="javascript" type="text/javascript">
    $(function () {
        // Page.DoNotCloseWinWhenSave = true;
        //Page.Children.toolBarBtnDisabled("table1","add");
        //主表赋值
        if (Page.usetype == "modify") {
            var sqlObj = {
                TableName: "vwSDOrderMD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "=",
                        Value: "'" + Page.key + "'"
                    }
                ]
            }

            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                Page.setFieldValue("sCode", result[0].sCode);
                Page.setFieldValue("sName", result[0].sName);
                Page.setFieldValue("sColorID", result[0].sColorID);
                Page.setFieldValue("sColorName", result[0].sColorName);
                Page.setFieldValue("fProductWeight", result[0].fProductWeight);
                Page.setFieldValue("fProductWidth", result[0].fProductWidth);
                Page.setFieldValue("fQty", result[0].fSumQty);
                Page.setFieldValue("sUnitSaleName", result[0].sUnitSaleName);
            }

            //子表赋值
            //判断是否有行，没有行增加行的例子
            $("#table1").datagrid({
                onLoadSuccess: function (data) {
                    var rows = $("#table1").datagrid("getRows");
                    if (rows.length == 0) {
                        var sqlObj = {
                            TableName: "vwSDOrderDPart_Waste",
                            Fields: "*",
                            SelectAll: "True",
                            Filters: [{
                                Field: "iRecNo",
                                ComOprt: "=",
                                Value: "'" + Page.key + "'"
                            }]
                        }

                        var result = SqlGetData(sqlObj);
                        if (result.length > 0) {
                            for (var i = 0; i < result.length; i++) {
                                var approw = {};
                                approw.sCode = result[i].sCode;
                                approw.sName = result[i].sName;
                                approw.fProductWeight = result[i].fProductWeight;
                                approw.fProductWidth = result[i].fProductWidth;
                                approw.iBscDataMatRecNo = result[i].iBscDataMatRecNo;
                                Page.tableToolbarClick("add", "table1", approw);
                            }
                        }

                    }
                }
            });
        }
    })


    Page.Children.onAfterEdit = function (tableid, index, row, changes) {
        if (tableid == "table1") {
            if ((datagridOp.currentColumnName == "fQty" && changes.fQty) || (datagridOp.currentColumnName == "sUnitID" && changes.sUnitID)) {
                var fProductWidth = row.fProductWidth;
                var fProductWeight = row.fProductWeight;
                var iUnitID = row.sUnitID;
                var fSumQty = row.fQty;
                var fWeight = 0;
                if (iUnitID == "1") {
                    fWeight = Number(fProductWidth) / 100 * Number(fSumQty) * Number(fProductWeight) / 1000
                }
                else if (iUnitID == "2") {
                    fWeight = Number(fProductWidth) / 100 * Number(fSumQty) * 0.9144 * Number(fProductWeight) / 1000
                }
                else if (iUnitID == "0") {
                    fWeight = Number(fSumQty);
                }

                $('#table1').datagrid('updateRow', {
                    index: index,
                    row: { fWeight: fWeight}
                });
            }
        }
    }
    Page.beforeSave = function () {
        var rows = $("#table1").datagrid("getRows");
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].iOrderType == "0") {
                if (rows[i].fFabPrice == "" || rows[i].fFabPrice == null || rows[i].fFabPrice == undefined) {
                    alert("坯布自制请输入坯布单价！");
                    return false;
                }
            }
        }
    }

    Page.afterSave = function () {
        window.opener = null;
        window.close();
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        成品编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCode" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        成品名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sName" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        色号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sColorID" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        颜色
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sColorName" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        幅度
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fProductWidth" Z_FieldType="整数" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        克重
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fProductWeight" Z_FieldType="整数" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        单位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sUnitSaleName" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fQty" Z_FieldType="数值" Z_decimalDigits="2" Z_readOnly="true" Z_NoSave="true" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDOrderDPart">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
