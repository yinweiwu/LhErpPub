<%@ page language="C#" autoeventwireup="true" inherits="BaseSet_ChangePsd, App_Web_changepsd.aspx.fca1e55" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>修改密码</title>
    <base target="_self" />
</head>
<body style=" font-size:12px; font-family:Arial">
    <form id="form1" runat="server">
    <div style="text-align:center;" >
        <table style="width:300px; margin:auto;">
            <tr>
                <td>原密码</td>
                <td align="left">
                    <asp:TextBox ID="TxbOldPsd" runat="server" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>现密码</td>
                <td align="left">
                    <asp:TextBox ID="TxbNowPsd" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ErrorMessage="必填*" ControlToValidate="TxbNowPsd" Display="Static"
                        ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>确认密码</td>
                <td align="left">
                    <asp:TextBox ID="TxbCPsd" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ErrorMessage="必填*" ControlToValidate="TxbCPsd" Display="Static" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Button ID="BtnConfirm" runat="server" Text="确认" 
                        onclick="BtnConfirm_Click" />
                    &nbsp;&nbsp;&nbsp;   
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
