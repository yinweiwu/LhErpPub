<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        Page.afterLoad = function () {
            //alert(Page.getFieldValue("iSdOrderDRecNo"))
            var sqlObjPurOrderMD = {
                TableName: "vwSDOrderD",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                             {
                                 Field: "iRecNo",
                                 ComOprt: "=",
                                 Value: Page.getFieldValue("iSdOrderDRecNo")
                             }
                ]
            };
            var resultPurOrderMD = SqlGetData(sqlObjPurOrderMD);
            if (resultPurOrderMD.length > 0) {
                Page.setFieldValue('sOrderCode', resultPurOrderMD[0].sCode);
                var sqlObj = {
                    TableName: "SCTouChanM",
                    Fields: "*",
                    SelectAll: "True",
                    Filters: [
                             {
                                 Field: "iRecNo",
                                 ComOprt: "=",
                                 Value: Page.key
                             }
                    ]
                };
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    Page.setFieldValue('sMatBatchNo', result[0].sMatBatchNo);
                    Page.setFieldValue('fSCPurQty', result[0].fSCPurQty);
                    Page.setFieldValue('dSCDate', result[0].dSCDate);
                    Page.setFieldValue('fMatOutDiameter', result[0].fMatOutDiameter);
                    Page.setFieldValue('fMatWallHeight', result[0].fMatWallHeight);
                    Page.setFieldValue('fMatPurQty', result[0].fMatPurQty);
                    Page.setFieldValue('fMatQty', result[0].fMatQty);
                }
            }
        }
        $(function () {
            Page.Children.toolBarBtnAdd("SCTouChanD", "mybtn1", "复制行数据", "tool", function () {
                var getRows1 = $('#SCTouChanD').datagrid('getSelections');
                if (getRows1 != null) {
                    for (var i = 0; i < getRows1.length; i++) {
                        var iDaoCi = getRows1[i].iDaoCi;
                        var fLength = getRows1[i].fLength;
                        var fOutDiameter = getRows1[i].fOutDiameter;
                        var fWallHeight = getRows1[i].fWallHeight;
                        var fInnerMo = getRows1[i].fInnerMo;
                        doCopy(iDaoCi, fLength, fOutDiameter, fWallHeight, fInnerMo);
                    }
                }
                else {
                    alert("未选中行");
                }
            })
            Page.Children.toolBarBtnAdd("SCTouChanD", "up", "上移", "preview", function () {
                MoveUp();
            });
            Page.Children.toolBarBtnAdd("SCTouChanD", "down", "下移", "next", function () {
                MoveDown();
            });
        })

        //上移
        function MoveUp() {
            var rows = $("#SCTouChanD").datagrid('getSelections');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#SCTouChanD").datagrid('getRowIndex', rows[i]);
                //$("#tableColumn").datagrid("endEdit", index);
                mysort(index, 'up', 'SCTouChanD');
            }
        }
        //下移
        function MoveDown() {
            var rows = $("#SCTouChanD").datagrid('getSelections');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#SCTouChanD").datagrid('getRowIndex', rows[i]);
                //$("#tableColumn").datagrid("endEdit", index);
                mysort(index, 'down', 'SCTouChanD');
            }
        }
        function mysort(index, type, gridname) {

            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datagrid('getData').rows[index];
                    var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
                    var theSerial = toup.iSerial;
                    toup.iSerial = todown.iSerial;
                    todown.iSerial = theSerial;
                    $('#' + gridname).datagrid('getData').rows[index] = todown;
                    $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index - 1);
                    $('#' + gridname).datagrid('selectRow', index - 1);
                    $('#' + gridname).datagrid('unselectRow', index);
                }
            } else if ("down" == type) {
                var rows = $('#' + gridname).datagrid('getRows').length;
                if (index != rows - 1) {
                    var todown = $('#' + gridname).datagrid('getData').rows[index];
                    var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
                    var theSerial = todown.iSerial;
                    todown.iSerial = toup.iSerial;
                    toup.iSerial = theSerial;
                    $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
                    $('#' + gridname).datagrid('getData').rows[index] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index + 1);
                    $('#' + gridname).datagrid('selectRow', index + 1);
                    $('#' + gridname).datagrid('unselectRow', index);
                }
            }
        }
        function doCopy(iDaoCi, fLength, fOutDiameter, fWallHeight, fInnerMo) {
            var rows = $("#SCTouChanD").datagrid("getRows"); //这段代码是获取当前页的所有行。
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].iDaoCi == iDaoCi) {
                    rows[i].fLength = fLength;
                    rows[i].fOutDiameter = fOutDiameter;
                    rows[i].fWallHeight = fWallHeight;
                    rows[i].fInnerMo = fInnerMo;
                    $("#SCTouChanD").datagrid("updateRow", { index: i, row: { fLength: rows[i].fLength, fOutDiameter: rows[i].fOutDiameter, fWallHeight: rows[i].fWallHeight, fInnerMo: rows[i].fInnerMo} });
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="生产工艺卡">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                投料日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                工艺卡号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                生产车间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSCClassID" />
                            </td>
                            <td>
                                工艺卡类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sType" Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="height: 1px; border-top: 1px solid black">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                销售合同号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sOrderNo" Z_disabled="true"
                                    Z_NoSave="True" />
                                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iSdOrderDRecNo" Z_Value="0" />
                            </td>
                            <td>
                                成品标准
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sOrderExecStandard" Z_disabled="true"
                                    Z_NoSave="True" />
                            </td>
                            <td>
                                技术要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sOrdersTechnicalRequirement"
                                    Z_disabled="true" Z_NoSave="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                钢种
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOrderCode" Z_NoSave="True" />
                            </td>
                            <td>
                                成品规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sOrderElements" Z_disabled="true"
                                    Z_NoSave="True" />
                            </td>
                            <td>
                                成品单支长度(m)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sOrderOneLength" Z_disabled="true"
                                    Z_NoSave="True" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                合同投产支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fSCPurQty" />
                            </td>
                            <td>
                                生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dSCDate" Z_FieldType="日期" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                成品允许外径偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOutDiameterOffset" />
                            </td>
                            <td>
                                成品允许壁厚偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sWallHeightOffset" />
                            </td>
                            <td>
                                成品允许长度偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sLengthOffset" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                荒管炉号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sMatBatchNo" />
                            </td>
                            <td>
                                炉批号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sMatLuBatchNo" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                荒管外径
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fMatOutDiameter" />
                            </td>
                            <td>
                                荒管壁厚
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fMatWallHeight" />
                            </td>
                            <td>
                                荒管支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fMatPurQty" />
                            </td>
                            <td>
                                荒管重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="fMatQty" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="height: 1px; border-top: 1px solid black">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                当前道次
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iCurDaoCi" />
                            </td>
                            <td>
                                当前工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sCurProcessNo" />
                            </td>
                            <td>
                                当前支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fCurPurQty" />
                            </td>
                            <td>
                                当前重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fCurQty" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                备注
                            </td>
                            <td colspan="3">
                                <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="sReMark" Width="338px" />
                            </td>
                            <td>
                                制单人
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                            </td>
                            <td>
                                制单时间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div data-options="fit:true" title="明细">
                            <!--  子表1  -->
                            <table id="SCTouChanD" tablename="SCTouChanD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
