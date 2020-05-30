<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">

//        lookUp.afterSelected = function (uniqueid, data) {
//            if (uniqueid == "1381") {
//               // alert(Page.getFieldValue("iNewSdOrderDRecNo"));
//            }
//        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="拆框单">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                拆框日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                拆框单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                        </tr>
                         <tr>
                            <td colspan="8" style="height: 1px; border-top: 1px solid black">
                            
                            </td>
                        </tr>
                        <tr>
                            <td>
                                原工艺卡号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="iOldSCProcessLiuZhuanRecNo"  />
                            </td>
                            <td>
                                生产车间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sOldSCClassID" Z_disabled="true"/>
                            </td>
                            <td>
                                工艺卡类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sOldType" Width="150px" Z_disabled="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                销售合同号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iOldSdOrderDRecNo" Z_disabled="true" />
                                <%--<cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iSdOrderDRecNo" Z_Value="0" />--%>
                            </td>
                            <td>
                                成品标准
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sOldExecStandard" Z_disabled="true" />
                            </td>
                            <td>
                                技术要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sOldTechnicalRequirement" Z_disabled="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                钢种
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sOldMatName" Z_disabled="true" />
                            </td>
                            <td>
                                成品规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sOldMatSpec" Z_disabled="true" />
                            </td>
                            <td>
                                成品单支长度(m)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fOldOneLength" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                合同投产支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="fOldSCPurQty" Z_disabled="true"/>
                            </td>
                            <td>
                                荒管炉号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sOldMatBatchNo" Z_disabled="true"/>
                            </td>
                            <td>
                                炉批号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sOldMatLuBatchNo" Z_disabled="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                成品允许外径偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sOldOutDiameterOffset" Z_disabled="true"/>
                            </td>
                            <td>
                                成品允许壁厚偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sOldWallHeightOffset" Z_disabled="true"/>
                            </td>
                            <td>
                                成品允许长度偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sOldLengthOffset" Z_disabled="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                当前道次
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="iOldCurDaoCi" Z_disabled="true"/>
                            </td>
                            <td>
                                当前工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sOldCurProcessNo" Z_disabled="true"/>
                            </td>
                            <td>
                                当前外径
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="fOldCurOutDiameter" Z_disabled="true"/>
                            </td>
                            <td>
                                当前壁厚
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="fOldCurWallHeight" Z_disabled="true"/>
                            </td>
                        </tr>
                        
                        <tr>
                            
                            
                            <td>
                                当前支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fOldCurPurQty" Z_disabled="true"/>
                            </td>
                            <td>
                                当前重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fOldCurQty" Z_disabled="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" style="height: 1px; border-top: 1px solid black">
                            </td>
                        </tr>
                            <tr>
                            <td>
                                新工艺卡号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="iNewSCProcessLiuZhuanRecNo" Z_disabled="true" />
                            </td>
                            <td>
                                新生产车间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox31" runat="server" Z_FieldID="sNewSCClassID" />
                            </td>
                            <td>
                                新工艺卡类型
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox32" runat="server" Z_FieldID="sNewType" Width="150px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                新销售合同号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox33" runat="server" Z_FieldID="iNewSdOrderDRecNo" Z_disabled="true" />
                                <%--<cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iSdOrderDRecNo" Z_Value="0" />--%>
                            </td>
                            <td>
                                新成品标准
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox34" runat="server" Z_FieldID="sNewExecStandard" Z_disabled="true" />
                            </td>
                            <td>
                                新技术要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox35" runat="server" Z_FieldID="sNewTechnicalRequirement" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                新钢种
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox36" runat="server" Z_FieldID="sNewMatName"  />
                            </td>
                            <td>
                                新成品规格
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox37" runat="server" Z_FieldID="sNewMatSpec" Z_disabled="true" />
                            </td>
                            <td>
                                新成品单支长度(m)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox38" runat="server" Z_FieldID="fNewOneLength" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                新合同投产支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox39" runat="server" Z_FieldID="fNewSCPurQty" />
                            </td>
                           <%-- <td>
                                新生产交期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox40" runat="server" Z_FieldID="dSCDate" Z_FieldType="日期" />
                            </td>--%>
                             <td>
                                新荒管炉号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox44" runat="server" Z_FieldID="sNewMatBatchNo" />
                            </td>
                            <td>
                                新炉批号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox45" runat="server" Z_FieldID="sNewMatLuBatchNo" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                新成品允许外径偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox41" runat="server" Z_FieldID="sNewOutDiameterOffset" />
                            </td>
                            <td>
                                新成品允许壁厚偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox42" runat="server" Z_FieldID="sNewWallHeightOffset" />
                            </td>
                            <td>
                                新成品允许长度偏差(mm)
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox43" runat="server" Z_FieldID="sNewLengthOffset" />
                            </td>
                        </tr>
                     <%--   <tr>
                            <td>
                                新荒管外径
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox46" runat="server" Z_FieldID="fMatOutDiameter" />
                            </td>
                            <td>
                                新荒管壁厚
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox47" runat="server" Z_FieldID="fMatWallHeight" />
                            </td>
                            <td>
                                新荒管支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox48" runat="server" Z_FieldID="fMatPurQty" />
                            </td>
                            <td>
                                新荒管重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox49" runat="server" Z_FieldID="fMatQty" />
                            </td>
                        </tr>--%>
                       
                        <tr>
                            <td>
                                新当前道次
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox50" runat="server" Z_FieldID="iNewCurDaoCi" />
                            </td>
                            <td>
                                新当前工序
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox51" runat="server" Z_FieldID="sNewCurProcessNo" />
                            </td>
                           <td>
                                新当前外径
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="fNewCurOutDiameter" />
                            </td>
                            <td>
                                新当前壁厚
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="fNewCurWallHeight" />
                            </td>
                        </tr>
                            
                        <tr>
                             <td>
                                新当前支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox52" runat="server" Z_FieldID="fNewCurPurQty" />
                            </td>
                            <td>
                                新当前重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox53" runat="server" Z_FieldID="fNewCurQty" />
                            </td>
                        </tr>
                         <tr>
                            <td colspan="8" style="height: 1px; border-top: 1px solid black">
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
               
            </div>
        </div>
    </div>
</asp:Content>
