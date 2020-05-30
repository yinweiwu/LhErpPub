<%@ page language="C#" autoeventwireup="true" inherits="SysRegister, App_Web_sysregister.aspx.cdcab7d2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="font-size: 14px;">
    <form id="form1" runat="server">
    <div>
        <fieldset style="padding: 10px;">
            <legend>系统注册</legend>
            <table>
                <tr>
                    <td>
                        请选择证书文件
                    </td>
                    <td>
                        <asp:FileUpload ID="FileUpload1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <asp:Button ID="Button1" runat="server" Text="注册" Height="30px" OnClick="Button1_Click"
                            Width="60px" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="height:20px;"></div>
        <fieldset style="padding: 10px;">
            <legend>系统到期日期</legend>
            <table cellpadding="5px" cellspacing="5px">
                <tr>
                    <td>
                        公司名称
                    </td>
                    <td>
                        <asp:TextBox ID="txbCompany" runat="server" Height="25px" Width="200px" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        到期日期
                    </td>
                    <td>
                        <asp:TextBox ID="txbExDate" runat="server" Height="25px" Width="200px" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
    </form>
</body>
</html>
