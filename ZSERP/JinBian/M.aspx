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
                        坯布编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"  />
                    </td>
                    <td>
                        坯布名称
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5"  runat="server" Z_FieldID="sBillNo"    />
                    </td>
                    <td>来样编号</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"   />
                        
                    </td>
                    <td>来样时间</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox19" Z_FieldType="日期" runat="server" 
                     />
                    </td>
                </tr>
                <tr>
                    <td>客户名称</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPerson"   />
                    </td>
                     <td>
                        客户规格
                    </td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox12"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    
                     <td>
                         <span>开发时间</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox11"  runat="server" Z_FieldID="sBillNo"  Z_FieldType="日期"/>
                    </td>
                    <td>
                        <span >出样日期</span>
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" Z_FieldType="日期"
                             />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td><span>报价成本</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" 
                            Z_FieldID="sBillNo"    />
                    </td>
                     <td>
                         <span>机台型号</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox21"  runat="server" 
                                Z_FieldID="sBillNo"    />
                    </td>
                    
                     <td>
                         <span>总针数</span></td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox24"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    <td>
                        <span>进沙路数</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox23"  runat="server" 
                             Z_FieldID="dDate"    />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td>
                        样品幅宽(cm) 
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true"
                             />
                    </td>
                    <td>
                        样品克重(g/㎡) 
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                             />
                    </td>
                     <td>
                        坯布幅宽(cm)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        坯布克重(g/㎡)
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
       
                    
                    </td>
                </tr>
                 <tr>
                    <td>
                      成品幅宽(cm)  
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="fQty" Z_disabled="true"
                             />
                    </td>
                    <td>
                        成品克重(g/㎡) 
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                             />
                    </td>
                     <td>
                        转速
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                    <td>
                        产量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox15" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sMatClass" Z_NoSave="true" style=" display:none;"   />
                    
                    </td>
                </tr>
            </table>
            <table class="tabmain">
                 <tr>
                    <td class="style2">
                        上机工艺（及其它）</td>
                  
                        <td class="style1">
                            <textarea id="sbarcoderemark0"  
                                
                                style=" border-bottom:1px solid black; width: 839px; border-left-style: none; border-left-color: inherit; border-left-width: 0px; border-right-style: none; border-right-color: inherit; border-right-width: 0px; border-top-style: none; border-top-color: inherit; border-top-width: 0px; height: 30px;" 
                                cols="20" name="S1"></textarea></td>
                   
                </tr>
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
                <div data-options="fit:true" title="规格用料">
                    <!--  子表1  -->
                    <table id="MMStockCheckD" tablename="MMStockCheckD">
                    </table>
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

