<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style2
        {
            width: 100px;
            height: 40px;
        }
        .style3
        {
            /*height: 25px;尹威武2016-08-27注释*/
            height: 40px;
        }
        .style4
        {
            width: 100px;
            height: 40px;
        }
        .style5
        {
            /*height: 25px;尹威武2016-08-27注释*/
            height: 40px;
        }
        
        .style6
        {
            width: 100px;
            height: 40px;
        }
        .style7
        {
            /*height: 25px;尹威武2016-08-27注释*/
            height: 40px;
        }
        .style8
        {
            width: 100px;
            height: 45px;
        }
        .style9
        {
            /*height: 25px;尹威武2016-08-27注释*/
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
            <%--<table class="tabmain" style="margin: auto" >--%>
            <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block; margin-left: 20px" >
                <span style=" color: #FF6600; margin-left: 20px" >第一步：</span>商铺信息输入</span>
            <table border="0" style="border: 1px solid #B4CDCD; width: 93%; height: 120px; margin-left: 50px;"
                cellpadding="0" cellspacing="1">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td class="style2">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商铺号
                    </td>
                    <td class="style3">
                        <cc1:ExtTextBox2 ID="ExtTextBox21" runat="server" Z_FieldID="iBscShopRecNo" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营者
                    </td>
                    <td class="style5">
                        <cc1:ExtTextBox2 ID="ExtTextBox22" runat="server" Z_FieldID="sManagerName" Width="260px"
                            Height="30px" Z_readOnly="True" />
                    </td>
                </tr>
                <tr>
                    <td class="style2">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身份证号
                    </td>
                    <td class="style3">
                        <cc1:ExtTextBox2 ID="ExtTextBox23" runat="server" Z_FieldID="sCard" Width="260px"
                            Height="30px" Z_readOnly="True" />
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="style8">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;联系电话
                    </td>
                    <td class="style9">
                        <cc1:ExtTextBox2 ID="ExtTextBox24" runat="server" Z_FieldID="sTel" Width="260px"
                            Height="30px" Z_readOnly="True" />
                    </td>
                </tr>
            </table>
            <span style="font-size: 16px; width: 300px; height: 60px; line-height: 80px; display: block;margin-left: 20px">
                <span style=" color: #FF6600;margin-left: 20px" >第二步：</span>填写抵押时间 </span>
            <table border="0" style="border: 1px solid #B4CDCD; width: 93%; height: 150px; margin-left: 50px;"
                cellpadding="0" cellspacing="1">
                <tr>
                    <td class="style2">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;抵押时间
                    </td>
                    <td class="style3">
                        <cc1:ExtTextBox2 ID="ExtTextBox26" runat="server" Z_FieldID="dDate" Z_FieldType="日期"
                            Width="260px" Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style6">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注
                    </td>
                    <td class="style7">
                        <cc1:ExtTextArea2 ID="ExtTextArea22" runat="server" Z_FieldID="sRemarks" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style2">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;撤销抵押时间
                    </td>
                    <td class="style3">
                        <cc1:ExtTextBox2 ID="ExtTextBox25" runat="server" Z_FieldID="dCancelDate" Z_FieldType="日期"
                            Width="260px" Height="30px" />
                    </td>
                </tr>
                <tr>
                    <td class="style8">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;撤销抵押备注
                    </td>
                    <td class="style9">
                        <cc1:ExtTextArea2 ID="ExtTextArea23" runat="server" Z_FieldID="sCancelRemarks" Width="260px"
                            Height="30px" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
</asp:Content>
