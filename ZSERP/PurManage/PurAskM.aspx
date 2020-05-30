<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>
<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/PurAskM.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        申购单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"   />
                    </td>
                    <td>
                        申购日期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate"      />
                    </td>
                    <td>申购人</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID"    />
                    </td>
                </tr>
                <tr>
                   
                    <td>
                        申购部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sDeptID"  />
                    </td>
                     <td>
                        申购用途
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sPurTypeID"  />
                    </td>
                    <td>
                        物料类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sMatTypeID" Z_Required="true"  />
                    </td>
                    
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" Width="334px"
                             />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    
                </tr>
                <tr>
                    <td>
                        申购数量
                    </td>
                    <td><cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="fQty"  Z_disabled="true" /></td>
                    <td>
                        申购金额
                    </td>
                    <td><cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fTotal"  Z_disabled="true"  /></td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="申购明细">
                    <!--  子表1  -->
                    <table id="PurAskD" tablename="PurAskD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
            </div>--%>
       </div>
    </div>
    </div>
</asp:Content>

