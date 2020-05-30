<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>单据号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sBillNo" Z_readOnly="true" />
                    </td>
                    <td>单据如期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="dDate" Z_FieldType="日期" />
                    </td>
                    <td>发票号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="sInvoiceNo" />
                    </td>
                    <td>发票日期
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="dInvoceDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>客户
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox5" runat="server" z_fieldid="iBscDataCustomerRecNo" />
                    </td>
                    <td>客户地址
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sCustAddress" style="width:99%" />
                    </td>
                    <td>总米数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="fQty" Z_readOnly="true" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>总件数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="iQty" Z_readOnly="true" Z_FieldType="整数" />
                    </td> 
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>毛重
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox10" runat="server" z_fieldid="fGrossWeight" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>净重
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox15" runat="server" z_fieldid="fNetWeight" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>体积
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox11" runat="server" Z_FieldID="fVolume" Z_FieldType="数值" Z_decimalDigits="2" />
                    </td>
                    <td>备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea2" style="width:99%;" Z_FieldID="sRemark" runat="server" />
                    </td> 
                </tr>
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>起运港
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox6" runat="server" z_fieldid="sStartPort" />
                    </td>
                    <td>目的港
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox7" runat="server" z_fieldid="sDestPort" />
                    </td>
                    <td>制单人
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox13" runat="server" z_fieldid="sUserID" Z_readOnly="true" />
                    </td>
                    <td>制单时间
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox14" runat="server" z_fieldid="dInputDate" Z_readOnly="true" Z_FieldType="时间" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="明细">
                    <!--子表1  -->
                    <table id="table1" tablename="DCPackListD">
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

