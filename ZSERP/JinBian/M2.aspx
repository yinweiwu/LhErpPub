<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 843px;
        }
        .style2
        {
            width: 72px;
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
                        订单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"  />
                    </td>
                    <td>
                        客户订单号
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5"  runat="server" Z_FieldID="sBillNo"    />
                    </td>
                    <td>订单类型</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"   />
                        
                    </td>
                    <td>客户</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" 
                     />
                    </td>
                </tr>
                <tr>
                    <td>签订日期</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server"  Z_FieldType="日期" Z_FieldID="sBscDataPerson"   />
                    </td>
                     <td>
                        产品编码
                    </td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox12"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    
                     <td>
                         <span>产品名称</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox11"  runat="server" Z_FieldID="sBillNo" />
                    </td>
                    <td>
                        <span >客户品号</span>
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" 
                             />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td><span>幅宽（cm）</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" 
                            Z_FieldID="sBillNo"    />
                    </td>
                     <td>
                         <span>克重（g/㎡）</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox21"  runat="server" 
                                Z_FieldID="sBillNo"    />
                    </td>
                    
                     <td>
                         <span>坯布编号</span></td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox24"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    <td>
                        <span>订单类型</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox23"  runat="server" 
                             Z_FieldID="dDate"    />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td>
                        寄样类型
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true"
                             />
                    </td>
                    <td>
                        币种
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                             />
                    </td>
                     <td>
                        汇率
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    
                </tr>
                 <tr>
                 <td>
                        订单交期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sBillNo" Z_FieldType="日期"/>
       
                    
                    </td>
                    <td>
                      生产交期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_FieldType="日期"
                             />
                    </td>
                   
                </tr>
            </table>
            <table class="tabmain">
              
                 <tr>
                    <td class="style2">
                        备注
                    </td>
                  
                        <td class="style1">
                            <textarea id="sbarcoderemark"  
                                style=" border-bottom:1px solid black; width: 839px; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px;"></textarea>
                        </td>
                   
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="订单明细">
                    <!--  子表1  -->
                    <table id="MMStockCheckD" tablename="MMStockCheckD">
                    </table>
                </div>
               <div data-options="fit:true" title="订单条款">
                    <!--  子表2  -->
                    <table id="MMStockCheckDd" tablename="MMStockCheckDd">
                    </table>
                </div>
                <div data-options="fit:true" title="坯布要求">
                    <!--  子表2  -->
                    <table id="MMStockCheckDdd" tablename="MMStockCheckDdd">
                    </table>
                </div>
                <div data-options="fit:true" title="染色要求">
                    <!--  子表2  -->
                    <table id="MMStockCheckDddd" tablename="MMStockCheckDddd">
                    </table>
                </div>
            </div>
    </div>
    </div>
</asp:Content>

