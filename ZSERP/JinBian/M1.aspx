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
                        报价单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"  />
                    </td>
                    <td>
                        报价日期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5"  runat="server" Z_FieldID="sBillNo"    />
                    </td>
                    <td>产品编号</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockMRecNo"   />
                        
                    </td>
                    <td>产品名称</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox19" Z_FieldType="日期" runat="server" 
                     />
                    </td>
                </tr>
                <tr>
                    <td>坯布编号</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sBscDataPerson"   />
                    </td>
                     <td>
                        宽幅
                    </td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox12"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    
                     <td>
                         <span>克重</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox11"  runat="server" Z_FieldID="sBillNo"  Z_FieldType="日期"/>
                    </td>
                    <td>
                        <span >物料成本</span>
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sReMark" Z_FieldType="日期"
                             />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td><span>坯布加工成本</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" 
                            Z_FieldID="sBillNo"    />
                    </td>
                     <td>
                         <span>管理费（%）</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox21"  runat="server" 
                                Z_FieldID="sBillNo"    />
                    </td>
                    
                     <td>
                         <span>税费（%）</span></td>
                    <td>
                            <cc1:ExtTextBox2 ID="ExtTextBox24"  runat="server" Z_FieldID="sDeptID"    />
                    </td>
                    <td>
                        <span>最低利润</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox23"  runat="server" 
                             Z_FieldID="dDate"    />
                    </td>
                    
                    
                </tr>
                <tr>
                    <td>
                        最低报价
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="fQty" Z_disabled="true"
                             />
                    </td>
                    <td>
                        报价 
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="fTotal" Z_disabled="true"
                             />
                    </td>
                     <td>
                        报价利润率
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    
                </tr>
            </table>
          
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="物料成本">
                    <!--  子表1  -->
                    <table id="MMStockCheckD" tablename="MMStockCheckD">
                    </table>
                </div>
               <div data-options="fit:true" title="其它费用">
                    <!--  子表2  -->
                    <table id="MMStockCheck" tablename="MMStockCheck">
                    </table>
                </div>
            </div>
    </div>
    </div>
</asp:Content>

