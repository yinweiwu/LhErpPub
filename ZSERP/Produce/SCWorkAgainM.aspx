<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        
        Page.beforeSave = function () {
            if (Page.usetype == "add" && !Page.getFieldValue("sBillNo")) {
                if (Page.getFieldValue("iSCTouChanMRecNo")) {
                    var jsonobj = {
                        StoreProName: "lzw_FormBillNoBulid2",
                        StoreParms: [{
                            ParmName: "@formid",
                            Value: 1127
                        }, {
                            ParmName: "@pre",
                            Value: Page.getFieldText("iSCTouChanMRecNo")
                        }, {
                            ParmName: "@iNum",
                            Value: 3
                        }]
                    }
                    var result = SqlStoreProce(jsonobj);
                    if (result) {
                        Page.setFieldValue("sBillNo", result);
                    }

                }
                else {
                    alert("请填写工艺卡号");
                    return false;
                }
            }
        }

        function playAA() {
            PlayVoiceTTS("这是测试用的苦苦椅套地工顶替基本原则载顶替基本原则堪工顶替苛夺基本原则载顶替");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="tabTop" class="easyui-tabs" data-options="fit:true,border:false">
        <div title="返工卡">
            <div id="divContent" class="easyui-layout" data-options="fit:true">
                <div data-options="region:'north'" style="overflow: hidden;">
                    <!--主表部分-->
                    <table class="tabmain">
                        <tr>
                             <td>
                                  <cc1:ExtCheckbox2 ID="ExtCheckbox3" runat="server" Z_FieldID="bRepair" />
                                 <input id="Button1" type="button" value="播放声音" onclick="playAA()" />
                             </td>
                             <td>
                                  <label for="__ExtCheckbox3">
                                      返修</label>
                                  </td>
                             <td>
                                  <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="bSpecial" />
                             </td>
                             <td>
                                  <label for="__ExtCheckbox2">
                                       特殊</label>
                             </td>
                        </tr>
                        <tr>
                            <!--这里是主表字段摆放位置-->
                            <td>
                                返工日期
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate" />
                            </td>
                            <td>
                                返工单号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                             <td>
                                工艺卡号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iSCTouChanMRecNo" Width="150px" />
                            </td>
                            <td>
                                生产车间
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sSCClassID" Z_disabled="true"/>
                            </td>
                           
                            <td>
                                钢种
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sMatName" Z_disabled="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                销售合同号
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="iSdOrderDRecNo" Z_disabled="true" />
                                <%--<cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iSdOrderDRecNo" Z_Value="0" />--%>
                            </td>
                              <td>
                                炉号
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
                                成品标准
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sExecStandard" Z_disabled="true" />
                            </td>
                            <td>
                                技术要求
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sTechnicalRequirement" Z_disabled="true" />
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
                                当前外径
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fCurOutDiameter" />
                            </td>
                            <td>
                                当前壁厚
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fCurWallHeight" />
                            </td>
                        </tr>
                        <tr>
                             <td>
                                当前支数
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="fPurQty" />
                            </td>
                           <%-- <td>
                                当前重量
                            </td>
                            <td>
                                <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="fCurQty" />
                            </td>--%>
                        </tr>
                        <tr>
                            <td>
                                不合格说明及处置
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
                            <table id="SCWorkAgainD" tablename="SCWorkAgainD">
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
