<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script language="javascript" type="text/javascript">
        $(function () {
            if (Page.usetype == "add") {
                var sNextRecNo = Page.getChildID("bscDataCustomerD");
                var iSerial = $("#tableChild").datagrid("getRows").length + 1;
                $("#tableChild").datagrid("appendRow", {
                    iRecNo: sNextRecNo,
                    iSerial: iSerial,
                    sCompanyUserCode: Page.userid,
                    sCompanyUserName: Page.username,
                    sCompany: Page.companyid
                });
            }
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <td colspan="8" style="text-align: center">
                        <h4>
                            供应商信息
                        </h4>
                    </td>
                </tr>
                <tr>
                    <td>
                        供应商编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sCustID" Z_Required="True"
                            Z_RequiredTip="供应商编号不能为空" />
                    </td>
                    <td>
                        组织机构号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sOrganizationNo" />
                    </td>
                    <td>
                        供应商分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sClassID" Z_Required="true"
                            Z_RequiredTip="未设置分类" />
                    </td>
                    <td>
                        &nbsp;助记符
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox14" runat="server" Z_FieldID="sZjCode" />
                    </td>
                </tr>
                <tr>
                    <td>
                        供应商名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="sCustName" Z_Required="true"
                            Z_RequiredTip="供应商名称不能为空" />
                    </td>
                    <td>
                        供应商简称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" runat="server" Z_FieldID="sCustShortName" Z_Required="true"
                            Z_RequiredTip="供应商名称不能为空" />
                    </td>
                    <td>
                        法人代表
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox13" runat="server" Z_FieldID="sMainPerson" />
                    </td>
                    <td>
                        企业类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox18" runat="server" Z_FieldID="sComType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        所属行业
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox19" runat="server" Z_FieldID="sIndustryType" />
                    </td>
                    <td>
                        地区分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sClassIDOfArea" />
                    </td>
                    <td>
                        公司人数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox20" runat="server" Z_FieldID="iComPersonCount" Z_FieldType="整数" />
                    </td>
                    <td>
                        厂房面积
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iArea" Z_FieldType="数值"
                            Z_decimalDigits="1" />
                    </td>
                </tr>
                <tr>
                    <td>
                        资信等级
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sCreditLevel" />
                    </td>
                    <td>
                        电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox9" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        传真
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sFax" />
                    </td>
                    <td>
                        注册资金
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="fLogonTotal" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td>
                        网址
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox10" runat="server" Z_FieldID="sHomepage" />
                    </td>
                    <td>
                        单位地址
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Width="573px" Z_FieldID="sChnAddr" />
                    </td>
                </tr>
                <tr>
                    <td>
                        Email
                        <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iCustType" Z_FieldType="数值"
                            Z_Value="2" />
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="sEmail" />
                    </td>
                    <td>
                        停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox12" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        主营业务
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sMainBusiness" Height="48px"
                            Width="766px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox16" runat="server" Z_FieldID="sUserID" Z_readOnly="True" />
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox17" runat="server" Z_FieldID="dInputDate" Z_FieldType="时间"
                            Z_readOnly="True" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="子表联系人">
                    <table id="tableChild" tablename="bscDataCustomerD">
                    </table>
                </div>
                <div data-options="fit:true" title="供应商银行">
                    <table tablename="bscDataCustomerD_Bank">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
