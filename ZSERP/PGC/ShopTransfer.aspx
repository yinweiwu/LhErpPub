<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
        Page.beforeSave = function () {
            var sTelNew = Page.getFieldValue("sTelNew");
            var sCardNew = Page.getFieldValue("sCardNew");
            //var sshopid = Page.getFieldValue("sShopID");
            if (!/^\d{17}(\d|x)$/i.test(sCardNew)) {
                Page.MessageShow("身份证有误", "新所有者身份证长度或格式错误，请重填");
                return false;
            }
            if (!(/^1[3|4|5|7|8]\d{9}$/.test(sTelNew))) {
                Page.MessageShow("手机号有误", "新所有者手机号码有误，请重填");
                return false;
            }
        }
    </script>
    <style type="text/css">
        .style3
        {
            width: 100px;
            height: 40px;
        }
        .style4
        {
            height: 40px;
        }
        
        .style5
        {
            width: 100px;
            height: 45px;
        }
        .style6
        {
            height: 45px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false" style="text-align: center;">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->
                <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                <cc1:ExtHidden2 ID="ExtHidden3" runat="server" Z_FieldID="sDeptID" />
                <cc1:ExtHidden2 ID="ExtHidden4" runat="server" Z_FieldID="sShopID" />
            </div>
            <!--主表部分-->
            <%--<table class="tabmain"  style="margin: auto">--%>
            <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block;
                margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第一步：</span>商铺信息导入
            </span>
            <table border="0" style="border: 1px solid #B4CDCD; width: 93%; height: 120px; margin-left: 50px"
                cellpadding="0" cellspacing="1">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商铺号
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="iBscShopRecNo" Width="260px"
                            Height="30px" />
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;原所有者
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sManagerNameOld" Width="260px"
                            Height="30px" Z_readOnly="True" />
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身份证号
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sCardOld" Width="260px"
                            Height="30px" Z_readOnly="True" />
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="style5">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号
                    </td>
                    <td class="style6">
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="sTelOld" Width="260px"
                            Height="30px" Z_readOnly="True" />
                        &nbsp;
                    </td>
                </tr>
            </table>
            <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block;
                margin-left: 20px"><span style="color: #FF6600; margin-left: 20px">第二步：</span>填写新经营者
            </span>
            <table border="0" style="border: 1px solid #B4CDCD; width: 93%; height: 150px; margin-left: 50px"
                cellpadding="0" cellspacing="1">
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新所有者
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="sManagerNameNew" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身份证号
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox27" runat="server" Z_FieldID="sCardNew" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox28" runat="server" Z_FieldID="sTelNew" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style3">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;转让时间
                    </td>
                    <td class="style4">
                        <cc1:ExtTextBox2 ID="ExtTextBox29" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="260px" Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style5">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注
                    </td>
                    <td class="style6">
                        <cc1:ExtTextArea2 ID="ExtTextArea21" runat="server" Z_FieldID="sRemark" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
</asp:Content>
