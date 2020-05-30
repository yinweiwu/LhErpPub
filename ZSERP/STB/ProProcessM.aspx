<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="iBillType" />
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>加工单号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>日期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="dDate" Z_FieldType="日期" />
                    </td>
                    <td>加工厂家
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="iBscDataCustomerRecNo" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>数量
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="fQty" Z_readOnly="true" Z_FieldType="数值" />
                    </td>
                    <td>金额
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox5" runat="server" z_fieldid="fTotal" Z_readOnly="true" Z_FieldType="数值" />
                    </td>
                    <td>加工类型
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox6" runat="server" z_fieldid="sSerial" Z_Required="true"/>
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>制单人
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox7" runat="server" z_fieldid="sUserID" Z_readOnly="true" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox8" runat="server" z_fieldid="dInputDate" Z_FieldType="时间" Z_readOnly="true" />
                    </td>                    
                </tr>
                <tr>
                    <td>备注
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sRemark" style="width:99%" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="加工明细">
                    <!--子表1  -->
                    <table id="table1" tablename="ProProcessD">
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

