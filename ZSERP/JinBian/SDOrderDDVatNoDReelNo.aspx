<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        var isProduct = false;
        $(function () {
            if (Page.usetype == "modify") {
                Page.setFieldDisabled("sVatNo");
                Page.setFieldDisabled("iReelNo");
                Page.setFieldDisabled("sReelNo");
                Page.setFieldDisabled("sBarcode");
                Page.setFieldDisabled("sCheckPersonID");
                Page.setFieldDisabled("sMachineID");
                if (Page.getFieldValue("iCutSample") == "0") { 
                    isProduct = true;
                    Page.setFieldValue("iCutSample","成品");
                    Page.setFieldDisabled("iCutSample");
                }
            }
            if (Page.usetype == "add") {
                Page.setFieldDisabled("sBarcode");
            }
        })
        Page.Formula = function (field) {
            if (Page.isInited == true) {
                if (field == "fQty") {
                    var fQty = isNaN(Number(Page.getFieldValue("fQty"))) ? 0 : Number(Page.getFieldValue("fQty"));
                    var fDeductQty = isNaN(Number(Page.getFieldValue("fDeductQty"))) ? 0 : Number(Page.getFieldValue("fDeductQty"));
                    Page.setFieldValue("fRealQty", fQty - fDeductQty);
                }
            }
            if (field == "fDeductQty") {
                var fQty = isNaN(Number(Page.getFieldValue("fQty"))) ? 0 : Number(Page.getFieldValue("fQty"));
                var fDeductQty = isNaN(Number(Page.getFieldValue("fDeductQty"))) ? 0 : Number(Page.getFieldValue("fDeductQty"));
                Page.setFieldValue("fRealQty", fQty - fDeductQty);
            }
        }
        Page.Children.onAfterEdit = function () {
            var allRows = $("#table1").datagrid("getRows");
            var sumQty = 0;
            for (var i = 0; i < allRows.length; i++) {
                if (allRows[i].sReason == null || allRows[i].sReason == undefined || allRows[i].sReason == "" || allRows[i].sReason.substr(0, 2) != "11") {
                    sumQty += (isNaN(Number(allRows[i].fDeductQty)) ? 0 : Number(allRows[i].fDeductQty));
                }
            }
            Page.setFieldValue("fDeductQty", sumQty);
        }
        Page.Children.onAfterAddRow = function () {
            var allRows = $("#table1").datagrid("getRows");
            var sumQty = 0;
            for (var i = 0; i < allRows.length; i++) {
                if (allRows[i].sReason == null || allRows[i].sReason == undefined || allRows[i].sReason == "" || allRows[i].sReason.substr(0, 2) != "11") {
                    sumQty += (isNaN(Number(allRows[i].fDeductQty)) ? 0 : Number(allRows[i].fDeductQty));
                }
            }
            Page.setFieldValue("fDeductQty", sumQty);
        }
        Page.beforeSave = function () {
            if ($("#form1").form("validate") != true) {
                return false;
            }


            var jsonobj = {
                StoreProName: "SpSDOrderDDVatNoModify",
                StoreParms: [{
                    ParmName: "@iSDOrderMRecNo",
                    Value: Page.getFieldValue("iSDOrderMRecNo")
                },
                {
                    ParmName: "@iSDOrderDRecNo",
                    Value: Page.getFieldValue("iSDOrderDRecNo")
                },
                {
                    ParmName: "@iSDOrderDDRecNo",
                    Value: Page.getFieldValue("iSDOrderDDRecNo")
                },
                {
                    ParmName: "@iReelNo",
                    Value: Page.getFieldValue("iReelNo")
                },
                {
                    ParmName: "@usetype",
                    Value: Page.usetype
                }
            ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                alert(result+"【友情提醒，修改时卷序和卷号要同时调整】");
                return false
            }

            if (isProduct) { 
                Page.setFieldValue("iCutSample", "0");
            }
        }
        Page.afterSave=function()
        {
            var jsonobj = {
                StoreProName: "SpSDOrderDDVatNoBuildBarcode",
                StoreParms: [{
                    ParmName: "@iRecNo",
                    Value: Page.key
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                
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
                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="iSDOrderMRecNo" />
                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iSDOrderDRecNo" />
                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="dInputDate" />
                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sVatNo" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        缸号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iSDOrderDDRecNo" />
                    </td>
                    <td>
                        原米数/码数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        扣米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fDeductQty" Z_FieldType="数值"
                            Z_decimalDigits="2" Z_readOnly="true" />
                    </td>
                    <td>
                        净米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="fRealQty" Z_FieldType="数值"
                            Z_decimalDigits="2" Z_readOnly="true" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        重量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="fWeight" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                    <td>
                        卷序
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="iReelNo" Z_FieldType="数值"
                            Z_decimalDigits="0" />
                    </td>
                    <td>
                        卷号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sReelNo" />
                    </td>
                    <td>
                        条码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sBarcode" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        验布人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sCheckPersonID" />
                    </td>
                    <td>
                        机台
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sMachineID" />
                    </td>
                    <td>
                        类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iCutSample" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="疵点明细">
                    <!--  子表1  -->
                    <table id="table1" tablename="SDOrderDDVatNoDReelNoFlawD">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
