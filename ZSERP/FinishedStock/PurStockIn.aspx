<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="JS/PurStockIn.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script type="text/javascript">
        Page.afterSave = function () {
            if (Page.sysParms.iCommonBarCode == 1) {//通用码管理时,保证码不为空

                var jsonobj = {
                    StoreProName: "SpStockInCreateSBarCode",
                    StoreParms: [{
                        ParmName: "@iMRecNo",
                        Value: Page.key
                    }]
                }
                var result = SqlStoreProce(jsonobj);

            }
        }
        Page.beforeSave = function () {
            var sType = getQueryString("sType");
            if (sType == "0" || sType == "4") {
                if (!Page.getFieldValue("iBscDataCustomerRecNo")) {
                    alert("供应商或客户不能为空");
                    return false;
                }
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        单号<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sBillNo" Z_disabled="true" />
                    </td>
                    <td>
                        日期<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="日期" runat="server" Z_FieldID="dDate"
                            Z_Required="true" />
                    </td>
                    <td>
                        仓库<em style="color: Red">*</em>
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataStockMRecNo"
                            Z_Required="true" />
                    </td>
                     <td>
                        
                        <span id="sp_gys">供应商</span>
                    </td>
                    <td>
                        <div id="div_gys">
                            <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="iBscDataCustomerRecNo"
                                />
                        </div>
                    </td>
                   
                </tr>
                <tr>
                    <td>
                        入库类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sTypeName" />
                    </td>
                     <td>
                        经办人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="sPersonName" />
                    </td>
                    <td>
                        入库部门
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sDeptID" />
                    </td>
                    <td>
                         <span id="sp_hc">红冲</span>
                        
                    </td>
                    <td>
                        <div id="div_iRed">
                            <cc1:ExtCheckbox2 ID="ExtCheckbox1" runat="server" Z_FieldID="iRed" />
                        </div>
                        <div style="display: none">
                            仓位管理<cc1:ExtCheckbox2 ID="ExtCheckbox2" runat="server" Z_FieldID="iBerCh" Z_NoSave="true" />
                        </div>
                    </td>
                    
                   
                   
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark" Width="349px" />
                    </td>
                     <td>
                        会计月份
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sYearMonth"  Z_readOnly="true"
                            Z_Required="true" />
                    </td>
                    
                </tr>
                
                
            </table>
            <hr />
            <table  class="tabmain">
                <tr>
                    <td>
                        数量
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="iQty" Z_disabled="true" />
                    </td>
                   <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                        <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iType" Z_Value="0" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                    </td>
                </tr>
            </table>
            <hr />
            <table  class="tabmain">
                <tr>
                    <td>
                        仓位
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iBscDataStockDRecNo"
                            Z_NoSave="true" />
                    </td>
                    <td>
                        条码
                    </td>
                    <td >
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sBarCode" Z_NoSave="true"
                             />
                    </td>
                    <td colspan="2">
                        <textarea id="sbarcoderemark"></textarea>
                    </td>
                    
                </tr>
            </table>

        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="入库明细">
                    <!--  子表1  -->
                    <table id="MMProductInD" tablename="MMProductInD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <%--<table id="table2" tablename="bscDataBuildDUnit">
                    </table>--%>
                </div>--%>
            </div>
    </div>
</asp:Content>
