<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/MMStockOutM.js?<%=Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (getQueryString("iBillType") == "2" || getQueryString("iType") == "2") {
                $("#tdBscDataCustomerRecNoLabel").html("客户");
            }
            if (getQueryString("iBillType") == "1" || getQueryString("iType") == "1") {
                $("#tdSaleTotalLabel").hide();
                $("#tdSaleTotal").hide();
            }
        })
    </script>
    <style type="text/css">
        .style1
        {
            width: 156px;
        }
    </style>
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
                    <td class="style1">
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo" Z_Required="true"   />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="iBerCh" Z_NoSave="true" style=" display:none"   />
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sMatClass" Z_NoSave="true" style=" display:none"   />
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="iBillType" Z_NoSave="false" style=" display:none"   />
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
                    <td colspan="6">
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
                                    <td colspan="2">
                                        <cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iRed"  />
                                        <label for="__ExtCheckbox2">红冲</label>
                                    </td>
                               </tr> 
                               <tr>
                                     <td id="tdBscDataCustomerRecNoLabel">生产厂家</td>
                                    <td>
                                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                             />
                                    </td>
                                     <td>
                                            会计月份
                                        </td>
                                        <td>
                                             <cc1:ExtTextBox2 ID="ExtTextBox11"  runat="server" Z_FieldID="sYearMonth"  Z_disabled="true" Z_Required="true"   />
                                        </td>
                                        <td>
                                             备注</td>
                                        <td>
                                             <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark"
                                             /></td>
                               </tr>
                            </table>
                        </fieldset>
                    </td>
                    <td id="tdSaleTotalLabel" style="vertical-align:bottom">
                        销售金额
                    </td>
                    <td id="tdSaleTotal" style="vertical-align:bottom">
                        <cc1:ExtTextBox2 ID="ExtTextBox14" Z_FieldID="fSaleTotal" runat="server" 
                            Z_readOnly="True" />
                    </td>
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
                    <td class="style1">
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
                            <textarea id="sbarcoderemark"  
                                style=" border-bottom:1px solid black; height: 20px; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
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

