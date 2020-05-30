<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="js/MMStockCheckM.js" type="text/javascript"></script>
    <style type="text/css">
        .style1
        {
            width: 90%;
        }
      
    </style>
     <script language="javascript" type="text/javascript">
         Page.Children.onAfterEdit = function (tableid, index, row, changes) {
             if (tableid == "SCustomComplainD") {
                 if (datagridOp.currentColumnName == "fQty1" && changes.fQty1) {
                     var fSumQty = row.fQty1;
                     var fPrice = row.fPrice;
                     $("#SCustomComplainD").datagrid("updateRow", { index: index, row: { fTotal: Number(fSumQty) * Number(fPrice)} });
                 }
                 if (datagridOp.currentColumnName == "fPrice" && changes.fPrice) {
                     var fSumQty = row.fQty1;
                     var fPrice = row.fPrice;
                     $("#SCustomComplainD").datagrid("updateRow", { index: index, row: { fTotal: Number(fSumQty) * Number(fPrice)} });
                 }
             }
             if (tableid == "SCustomComplainD") {
                 if (datagridOp.currentColumnName == "fPrice" || datagridOp.currentColumnName == "fQty1" || datagridOp.currentColumnName == "fTotal") {
                     calcTotal();
                 }
             }
         }
         function calcTotal() {
             var rows = $("#SCustomComplainD").datagrid("getRows");
             var total = 0;
             for (var i = 0; i < rows.length; i++) {
                 var fTotal = isNaN(parseFloat(rows[i].fTotal)) ? 0 : parseFloat(rows[i].fTotal);
                 total += fTotal;
             }
             Page.setFieldValue("fMoney", total);
         }
    </script>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
         <div style="display: none;">
                <%-- <cc1:ExtTextBox2 ID="ExtTextBox14"   runat="server"  Z_FieldID="sUserID"    />--%>
                 <cc1:ExtTextBox2 ID="ExtTextBox15"   runat="server"  Z_FieldID="dInputDate"    />
                 <cc1:ExtTextBox2 ID="ExtTextBox30" Z_FieldID="sInputUserName" runat="server" />
        </div>
         <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        投诉单号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true"  />
                    </td>
                    <td>
                        投诉日期
                    </td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox5"  runat="server" Z_FieldID="dDate"  Z_FieldType="日期"  />
                    </td>
                     <td>
                        <span>客户</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox2"  runat="server"  Z_FieldID="iBscDataCustomer" 
                             />
                    </td>
                    <td>
                        <span>制单人</span></td>
                    <td>
                         <cc1:ExtTextBox2 ID="ExtTextBox4"  runat="server"  Z_FieldID="sUserID" 
                             Z_disabled="True" />
                    </td>
                </tr>
              
                 <tr>
                     <td>
                        承担部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sDeptID" />
                    </td>
                   
                     <td>
                       承担金额
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="fMoney" Z_FieldType="数值"/>

                </tr>
                   <tr  class="style1" >
                <td>
                    客诉原因
                </td>
                <td colspan="6">
                                <cc1:ExtTextArea2 ID="ExtTextArea12" runat="server" Z_FieldID="sReason" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
            </tr>
             
            <tr  class="style1">
                <td>
                    原因分析
                </td>
               <td colspan="6">
                                <cc1:ExtTextArea2 ID="ExtTextArea14" runat="server" Z_FieldID="sAnalyse" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
            </tr>
             <tr  class="style1">
                <td>
                    处理意见
                </td>
                <td colspan="6">
                                <cc1:ExtTextArea2 ID="ExtTextArea15" runat="server" Z_FieldID="sDispose" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
            </tr>
            <tr  class="style1">
                <td>
                    核示
                </td>
                <td colspan="6">
                                <cc1:ExtTextArea2 ID="ExtTextArea13" runat="server" Z_FieldID="sShenHe" Width="90%"
                                    Style="font-family: 宋体" />
                            </td>
            </tr>
            </table>
          
        </div>
          <div data-options="region:'center',border:false ">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <!--  子表1  -->
                    <table id="SCustomComplainD" tablename="SCustomComplainD">
                    </table>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>

