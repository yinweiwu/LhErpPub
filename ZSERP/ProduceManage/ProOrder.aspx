<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            var sqlObj = {
                TableName: "vwProOrderM",
                Fields: "sOrderNo,sStyleNo,sproOrderNo,sCustShortName,sSaleName,sStatusName,iQty,iProOrderPlanMRecNo,sSizeGroupID",
                SelectAll: "True",
                Filters: [{
                    Field: "iRecNo",
                    ComOprt: "=",
                    Value: "'" + Page.key + "'"
                }]
            }
            var result = SqlGetData(sqlObj);
            if (result && result.length > 0) {
                Page.setFieldValue("sOrderNo", result[0].sOrderNo);
                Page.setFieldValue("sStyleNo", result[0].sStyleNo);
                Page.setFieldValue("sProOrderNo", result[0].sProOrderNo);
                Page.setFieldValue("sSaleName", result[0].sSaleName);
                Page.setFieldValue("sStatusName", result[0].sStatusName);
                Page.setFieldValue("iQty", result[0].iQty);
                Page.setFieldValue("iProOrderPlanMRecNo", result[0].iProOrderPlanMRecNo);
            }

            Page.Children.toolBarBtnDisabled("table1", "add");
            Page.Children.toolBarBtnDisabled("table1", "delete");
            Page.Children.toolBarBtnDisabled("table2", "add");
            //Page.Children.toolBarBtnDisabled("table2", "delete");
            Page.Children.toolBarBtnDisabled("table3", "add");
            Page.Children.toolBarBtnDisabled("table3", "delete");
            Page.Children.toolBarBtnDisabled("table4", "add");
            Page.Children.toolBarBtnDisabled("table4", "delete");

            var queryParams = $("#table1").datagrid("options").queryParams;
            var linkField = $("#table1").attr("linkfield");
            var linkField0 = linkField.split("=")[0];
            var linkField0Value = Page.getFieldValue(linkField0);
            queryParams.key = linkField0Value;
            queryParams.filters = "sStyleNo='" + Page.getFieldValue("sStyleNo") + "'";
            $('#table1').datagrid('reload', queryParams);

            Page.Children.ShowDynColumns("ProOrderPlanD", result[0].sSizeGroupID);

//            Page.Children.toolBarBtnAdd("table3", "export", "导出Excel", "export", function () {
//                Page.Children.ExportExcel("table3");
//            });
            //$('#table1').datagrid('reload');
        });
        lookUp.beforeSetValue = function (uniqueid, data) {
            var rows = $("#table2").datagrid("getRows");
            for (var i = 0; i < data.length; i++) {
                for (var j = 0; j < rows.length; j++) {
                    if (data[i].sSerialID == rows[j].sSerialID) {
                        delete data[i];
                        break;
                    }
                }
            }
            return data;
        }
        Page.beforeSave = function () {
            $("#table1").removeAttr("tablename");
            $("#table3").removeAttr("tablename");
            $("#table4").removeAttr("tablename");
        }
        Page.afterSave = function () {
            var jsonobj = {
                StoreProName: "SpProGetBarCodeSerial",
                StoreParms: [
                {
                    ParmName: "@iProOrderMRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "") {
                Page.MessageShow("生成工票时发生错误", result);
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center'" style="overflow: hidden;">
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div title="基本信息">
                    <div class="easyui-layout" data-options="fit:true,border:false">
                        <div data-options="region:'north'" style="height: 100px;">
                            <!—如果只有一个主表，这里的north要变为center-->
                            <div id="divHiden" style="display: none;">
                                <!--隐藏字段位置-->
                                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iProOrderPlanMRecNo" />
                            </div>
                            <!--主表部分-->
                            <div>
                                <table class="tabmain">
                                    <tr>
                                        <!--这里是主表字段摆放位置-->
                                        <td>
                                            订单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                        <td>
                                            生产单号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sProOrderNo" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                        <td>
                                            客户
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sCustShortName" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            款号
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sStyleNo" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                        <td>
                                            业务员
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sSaleName" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                        <td>
                                            生产状态
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sStatusName" Z_NoSave="True"
                                                Z_readOnly="True" />
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            生产数量
                                        </td>
                                        <td>
                                            <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iQty" Z_NoSave="False"
                                                Z_readOnly="True" />
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
                        </div>
                        <div data-options="region:'center'">
                            <table id="table1" tablename="ProOrderPlanD">
                            </table>
                        </div>
                    </div>
                </div>
                <div title="工时工价表">
                    <table id="table2" tablename="ProOrderDSerial">
                    </table>
                </div>
                <div title="条码清单">
                            <table id="table3" tablename="ProOrderDBarCode">
                            </table>
                        </div>
                <%--<div title="工票管理">
                    <div class="easyui-tabs" data-options="fit:true">
                        
                        <div title="工票列表">
                            <table id="table4" tablename="ProOrderDBarCodeSerial">
                            </table>
                        </div>
                    </div>
                </div>--%>
            </div>
        </div>
    </div>
</asp:Content>
