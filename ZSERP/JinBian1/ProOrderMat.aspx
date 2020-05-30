<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table1", "copy");
        })

        lookUp.afterSelected = function (uniqueid, data) {
            if (uniqueid == "1447") {
                $("#table1").datagrid("loadData", []);
                var iRecNo = data.iRecNo;
                var sqlObj = {
                    TableName: "vwSDOrderDPro",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                    {
                        Field: "iMainRecNo",
                        ComOprt: "=",
                        Value: "'" + iRecNo + "'"
                    }
                ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    for (var i = 0; i < result.length; i++) {
                        var approw = result[i];
                        approw.fMatGetQty = result[i].fSrate;
                        approw.iSDOrderDProRecNo = result[i].iRecNo;
                        delete approw.iMainRecNo;
                        Page.tableToolbarClick("add", "table1", result[i]);
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
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        机台号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sMachine" Z_Required="False" />
                    </td>
                    <td>
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iSDOrderMRecNo" />
                    </td>
                    <td>
                        生产编号
                    </td>
                    <td>
                        <%--<cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" style="display:none;" Z_readOnly="true" Z_FieldID="iSDOrderMRecNo" />--%>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sProOrderNo" Z_NoSave="true"
                            Z_readOnly="true" />
                    </td>
                    <td>
                        机型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataFabName" Z_readOnly="True"
                            Z_NoSave="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        订单数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_decimalDigits="2" Z_FieldID="fQty"
                            Z_FieldType="数值" Z_readOnly="True" Z_NoSave="True" />
                    </td>
                    <td>
                        机台转速
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_decimalDigits="2" Z_FieldID="sRev"
                            Z_FieldType="数值" Z_readOnly="True" Z_NoSave="True" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
                            Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td>
                        单据号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>
                        调机时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dDebugTime" Z_FieldType="日期" />
                    </td>
                    <td colspan="2">
                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iFinish" />
                        <label for="__ExtCheckbox1">
                            分配完成</label>
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
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="用料明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="ProOrderMatD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
