<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/MMStockOutM.js?<%=Guid.NewGuid() %>" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        出库单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"  />
                    </td>
                   
                    <td>出库仓库</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo" Z_Required="true"   />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBerCh" Z_NoSave="true" style=" display:none"   />
                    </td>
                    <td>
                        出库日期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5" Z_FieldType="日期" runat="server" Z_FieldID="dDate"    />
                    </td>
                    <td>
                        出库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sTypeName" Z_Required="true"  />
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <fieldset>
                            <table>
                               <tr>
                                    <td>
                                        领用部门
                                    </td>
                                    <td>
                                         <cc1:ExtTextBox2 ID="ExtTextBox12"  runat="server" Z_FieldID="sDeptID"    />
                                    </td>
                                    <td>领用人</td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPersonID"   />
                                    </td>
                               </tr> 
                               <tr>
                                     <td>生产厂家</td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                             />
                                    </td>
                               </tr>
                               <tr>
                                    <td>
                                        红冲
                        
                                    </td>
                                    <td>
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                                    </td>
                                    <td>
                                        备注
                                    </td>
                                    <td>
                                         <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark"
                                             />
                                    </td>
                               </tr>
                            </table>
                        </fieldset>
                    </td>
                    <td colspan="4">
                        <fieldset>
                            <table>
                                <tr>
                                    <td>
                                        订单号
                                    </td>
                                    <td>
                                         <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sWholeOrderNo" Z_disabled="true"
                                             />
                                    </td>
                                </tr>
                                <tr>
                                     <td>
                                        款号
                                    </td>
                                    <td>
                                         <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sWholeStyleNo" Z_disabled="true"
                                             />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                            会计月份
                                        </td>
                                        <td>
                                             <cc1:ExtTextBox2 ID="ExtTextBox11"  runat="server" Z_FieldID="sYearMonth"  Z_disabled="true" Z_Required="true"   />
                                        </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    
                    
                     
                    
                </tr>
                <tr>
                    <td>
                        出库数量
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true"
                             />
                    </td>
                    <td>
                        出库金额
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                             />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                </tr>                
            </table>
            <hr />
            <table class="tabmain">
                 <tr>
                    <td>
                        条码
                    </td>
                    <td >
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="sBarCode" Z_NoSave="true"
                            Font-Bold="True"  style=" border:0px; border-bottom:1px solid black;"/>
                    </td>
                        <td colspan="2">
                            <textarea id="sbarcoderemark"  style=" border:0px; border-bottom:1px solid black;"></textarea>
                        </td>
                   <%-- <td>
                        仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
                    </td>--%>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="出库明细">
                    <div class="easyui-layout" data-options="fit:true">
                        <div title="明细" data-options="region:'west',collapsible:false,split:true" style=" width:100%">
                            <table id="MMStockOutD" tablename="MMStockOutD"> </table>
                        </div>
                        <%--<div title="库存" data-options="region:'center'">
                            <table id="MMStockQty" style="height:100%" > </table>
                        </div>
                    --%>
                    </div>

                    <!--  子表1  -->
                    
                   
                </div>
               <%-- <div data-options="fit:true" title="生产明细">
                    <!--  子表2  -->
                    <table id="SDContractDProduce" tablename="SDContractDProduce">
                    </table>
                </div>--%>
            </div>
    </div>
    </div>
</asp:Content>

