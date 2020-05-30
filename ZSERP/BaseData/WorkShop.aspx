<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            //1
            var queryParams = $("#table1").datagrid("options").queryParams;
            var linkField = $("#table1").attr("linkfield");
            var linkField0 = linkField.split("=")[0];
            var linkField0Value = Page.getFieldValue(linkField0);
            queryParams.key = linkField0Value;
            //加入其他的关联字段查询条件
            queryParams.filters = "sClassID='" + Page.getFieldValue("sClassID") + "'";
            $('#table1').datagrid('reload', queryParams);
            queryParams.key = "iRecNo";
            //2
            var queryParams = $("#table2").datagrid("options").queryParams;
            var linkField = $("#table2").attr("linkfield");
            var linkField0 = linkField.split("=")[0];
            var linkField0Value = Page.getFieldValue(linkField0);
            queryParams.key = linkField0Value;
            //加入其他的关联字段查询条件
            queryParams.filters = "sClassID='" + Page.getFieldValue("sClassID") + "'";
            $('#table2').datagrid('reload', queryParams);
            //3
            var queryParams = $("#table3").datagrid("options").queryParams;
            var linkField = $("#table3").attr("linkfield");
            var linkField0 = linkField.split("=")[0];
            var linkField0Value = Page.getFieldValue(linkField0);
            queryParams.key = linkField0Value;
            //加入其他的关联字段查询条件
            queryParams.filters = "sClassID='" + Page.getFieldValue("sClassID") + "'";
            $('#table3').datagrid('reload', queryParams);
            //
            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
        })
//        Page.beforeSave = function () {
//            // 伪正常保存，只保存子表数据
//            var rows = $('#table1').datagrid('getRows');

//            var sqlString = "";

//            for (var i = 0; i < rows.length; i++) {
//                sqlString += "" + rows[i]['iRecNo'] + "," + rows[i]['iMainRecNo'] + "," + rows[i]['sSizeName'] + "," + rows[i]['iFinishedUseQty'] + "," + rows[i]['iSemiFinishedUseQty'] + "|";
//            }
//            sqlString += "";
//            var s = Page.getFieldValue('iRecNo');
//            var jsonobj = {
//                StoreProName: "SpSaveContractYL",
//                StoreParms: [{
//                    ParmName: "@sqlString",
//                    Size: -1,
//                    Value: sqlString
//                },
//                {
//                    ParmName: "@key",
//                    Value: Page.getFieldValue('iRecNo')
//                }]
//            }
//            var result = SqlStoreProce(jsonobj);
//            if (result != "1") {
//                alert(result);
//                return false;
//            }


//            alert("保存成功！");
//            window.parent.FormList.NeedSelectedKey = Page.key;
//            window.parent.GridRefresh();
//            window.parent.CloseBillWindow();
//            return false;
//        }
        Page.Children.onAfterAddRow = function (tableid) {
            if (tableid == "BscSCWorkshopPosts" || tableid == "BscSCWorkshopProcess") {
                var rows = $("#" + tableid).datagrid("getRows");
                var row = rows[rows.length - 1];
                var sClassID = Page.getFieldValue("sClassID");
                $("#" + tableid).datagrid("updateRow", { index: rows.length - 1, row: { sClassID: sClassID} });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <table class="tabmain">
                <tr>
                    <td>
                        部门编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sClassID" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        部门名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sClassName" Z_NoSave="True"
                            Z_readOnly="True" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="车间人员">
                    <table id="table1" tablename="bscDataPerson">
                    </table>
                </div>
                <div data-options="fit:true" title="车间岗位">
                    <table id="table2" tablename="BscSCWorkshopPosts">
                    </table>
                </div>
                <div data-options="fit:true" title="车间工序">
                    <table id="table3" tablename="BscSCWorkshopProcess">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
