<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'center',border:false" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">

                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        会员卡号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCardNumber"  Z_Required="true"/>
                    </td>

                    <td>
                        会员名
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2"   runat="server" Z_FieldID="sName" 
                            Z_Required="true" />
                    </td>
                    <td>
                        会员类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="iMemberType" Z_Required="true" />
                    </td>
                    
                </tr>
                <tr>
                    <td>
                        
                        出生日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dBirtyday"
                             Z_FieldType="日期" />
                    </td>
                    <td>
                        押金
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6"  Z_FieldType="整数" runat="server" Z_FieldID="iDeposit"
                              />
                    </td>
                    <td>
                        性别
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sSex"
                             />
                             
                    </td>
                </tr>
                <tr>
                    <td>
                        
                        身高cm
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" Z_FieldType="整数" runat="server" Z_FieldID="iPersonHeight"
                             />
                            
                    </td>
                    <td>
                        体重kg
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11"  Z_FieldType="整数" runat="server" Z_FieldID="iBodyWeight"
                             />
                            
                    </td>
                    <td>三围
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iBWH"  Z_FieldType="整数"
                            />
                    </td>
                </tr>
                <tr>
                    <td>
                        身份证号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sIDNumber" 
                            />
                    </td>
                    <td>
                        导购员
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sPersonCode"   />
                    </td>
                     <td>
                        发卡门店
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="ibscDataStockMRecNo"
                             />
                    </td>
                </tr>
                <tr>
                    <td>
                        介绍人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sSponsor"
                             />
                    </td>
                    <td>
                        生效日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" Z_FieldType="日期" runat="server" Z_FieldID="dActivationDate"
                             />
                    </td>
                    <td>
                        结束日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" Z_FieldType="日期" runat="server" Z_FieldID="dEndDate"
                             />
                    </td>
                </tr>
                <tr>
                    <td>
                        旺旺号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="sWangWang"
                             />
                    </td>
                    <td>
                        流水提成
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" Z_FieldType="数值" runat="server" Z_FieldID="fWafterRate"
                             />
                    </td>
                    <td>
                        金额提成
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" Z_FieldType="数值" runat="server" Z_FieldID="fTotalRate"
                             />
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sReMark"
                             />
                    </td>
                    <td>
                        车牌号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25"  runat="server" Z_FieldID="sTaxNumber"
                             />
                    </td>
                    <td>
                        物理卡号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26"   runat="server" Z_FieldID="sPhisicalNumber"
                             />
                    </td>
                </tr>
                <tr>
                    <td>
                        手机号码
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sPhone"
                             />
                    </td>
                    <td>
                        固话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox28"  runat="server" Z_FieldID="sFixedPhone"
                             />
                    </td>
                    <td>
                        传真
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29"   runat="server" Z_FieldID="sPortraiture"
                             />
                    </td>
                </tr>
                <tr>
                    <td>
                        Email
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox30" runat="server" Z_FieldID="sEmail"
                             />
                    </td>
                    <td>
                        ZIP
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox31"  runat="server" Z_FieldID="sZIPCode"
                             />
                    </td>
                    <td>
                        家庭地址
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox32"   runat="server" Z_FieldID="sAddress"
                             />
                    </td>
                </tr>                
                <tr>
                    <td colspan="6">
                        <table>
                            <tr>
                                <td>储值金额
                    </td>
                                <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="数值" runat="server" Z_FieldID="fStoredMoney"
                             Z_readOnly="True" Z_NoSave="True" Width="80px" />
                                </td>
                                <td>积分
                    </td>
                                <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="iIntegral" Z_disabled="true" 
                                        Z_NoSave="true" Width="80px" Z_readOnly="True" />
                                </td>
                                <td>储值金额总额</td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Width="80px" 
                                        Z_FieldID="fStoredMoneySum" Z_NoSave="True" Z_readOnly="True" />
                                </td>
                                <td>积分总额</td>
                                <td>
                                    <cc1:ExtTextBox2 ID="ExtTextBox211" runat="server" Width="80px" 
                                        Z_FieldID="iIntegralSum" Z_NoSave="True" Z_readOnly="True" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
        </div>
<%--        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="调拔明细">
                    <!--  子表1  -->
                    <table id="MMProductDbD" tablename="MMProductDbD">
                    </table>
                </div>
                <div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <table id="table2" tablename="bscDataBuildDUnit">
                    </table>
                </div>
            </div>
    </div>--%>
</asp:Content>

