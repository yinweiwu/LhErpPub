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
            <table class="tabmain">
                <tr>
                    <td colspan="8" style="text-align: center">
                        <h4>
                            客户信息
                        </h4>
                    </td>
                </tr>
                <tr>
                    <td>
                        客户编号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="sCustID" Z_Required="True"
                            Z_RequiredTip="客户编号不能为空" />
                    </td>
                    <td>
                        组织机构号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox24" CssClass="txbbottomfill" runat="server" Z_FieldID="sOrganizationNo"
                            Z_RequiredTip="组织机构号不能为空" />
                    </td>
                    <td>
                        客户分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sClassID" Z_FieldType="空"
                            Z_Required="true" Z_RequiredTip="未设置分类" />
                    </td>
                    <td>
                        助记符
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox214" runat="server" Z_FieldID="sZjCode" Z_FieldType="空" />
                    </td>
                </tr>
                <tr>
                    <td>
                        客户名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sCustName" Z_Required="true"
                            Z_RequiredTip="客户名称不能为空" />
                    </td>
                    <td>
                        客户简称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sCustShortName" Z_Required="true"
                            Z_RequiredTip="客户名称不能为空" />
                    </td>
                    <td>
                        &nbsp;法人代表
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox213" runat="server" Z_FieldID="sMainPerson" />
                    </td>
                    <td>
                        企业类型
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox218" runat="server" Z_FieldID="sComType" Z_LookUpName="companyType" />
                    </td>
                </tr>
                <tr>
                    <td>
                        所属行业
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox219" runat="server" Z_FieldID="sIndustryType" Z_LookUpName="industryType" />
                    </td>
                    <td>
                        地区分类
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox222" runat="server" Z_FieldID="sClassIDOfArea" Z_FieldType="空" />
                    </td>
                    <td>
                        公司人数
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox220" runat="server" Z_FieldID="iComPersonCount" Z_FieldType="整数" />
                    </td>
                    <td>
                        厂房面积
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox221" runat="server" Z_FieldID="iArea" Z_FieldType="数值"
                            Z_decimalDigits="1" />
                    </td>
                </tr>
                <tr>
                    <td>
                        资信等级
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox223" runat="server" Z_FieldID="sCreditLevel" />
                    </td>
                    <td>
                        电话
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="sTel" />
                    </td>
                    <td>
                        传真
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox224" runat="server" Z_FieldID="sFax" />
                    </td>
                    <td>
                        注册资金
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox225" runat="server" Z_FieldID="fLogonTotal" Z_FieldType="数值"
                            Z_decimalDigits="2" />
                    </td>
                </tr>
                <tr>
                    <td>
                        网址
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox210" runat="server" Z_FieldID="sHomepage" />
                    </td>
                    <td>
                        单位地址
                    </td>
                    <td colspan="5">
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Width="562px" Z_FieldID="sChnAddr" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="iCustType" Z_FieldType="数值"
                            Z_Value="1" />
                        Email
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sEmail" />
                    </td>
                    <td>
                        停用时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox212" runat="server" Z_FieldID="dStopDate" Z_FieldType="日期" />
                    </td>
                </tr>
                <tr>
                    <td>
                        主营业务
                    </td>
                    <td colspan="7">
                        <cc1:ExtTextArea2 ID="ExtTextArea2" runat="server" Z_FieldID="sMainBusiness" Width="717px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox216" runat="server" Z_FieldID="sUserID" Z_readOnly="True"
                            Z_Required="False" />
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                        制单日期
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox217" runat="server" Z_FieldID="dInputDate" Z_FieldType="日期"
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
                <div data-options="fit:true" title="客户银行">
                    <table tablename="bscDataCustomerD_Bank">
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
