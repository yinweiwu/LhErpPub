<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/SDOrderM.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sOrderNo" Z_disabled="true"  Z_NoSave="true" />
                    </td>
                    <td>客户</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sCustShortName"
                            Z_NoSave="true" Z_disabled="true"/>
                    </td>
                    <td>业务员</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sSaleName"  Z_NoSave="true" Z_disabled="true" />
                    </td>
                    <td>生产数量</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="iProduceQty"  Z_NoSave="true" Z_disabled="true" />
                    </td>
                </tr>
                <tr>
                    <td>
                        款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStyleMRecNo"  Z_NoSave="true" Z_disabled="true" />
                    </td>
                    <td>
                        生产交期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dProduceDate"  Z_NoSave="true" Z_disabled="true" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserName" Z_disabled="true" Z_NoSave="true" />
                        <cc1:ExtHidden2  runat="server" Z_FieldID="iSdContractMRecNo"/>
                    </td>
                    <td>
                        <label style=" background-color:Green">审批完</label><label style=" background-color:Yellow">未设置旧值</label><label style=" background-color:red">与旧值不同</label>
                    </td>
                </tr>
                
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="物料清单">
                    <!--  子表1  -->
                    <table id="SdOrderDBom" tablename="SdOrderDBom">
                    </table>
                </div>
                <div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
                </div>
                <div data-options="fit:true" title="需求汇总">
                    <!--  子表2  -->
                    <table id="PurOrderMatNeedM" tablename="PurOrderMatNeedM">
                    </table>
                </div>
            </div>
    </div>
    </div>
</asp:Content>

