<%@ Page Language="C#" AutoEventWireup="true" Inherits="SysLience.hxLienceBuild" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        table tr td
        {
            padding: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 100%; text-align: center; font-size:14px;">
        <table style="margin: auto;">
            <tr>
                <td style="text-align: center;" colspan="2">
                    <h2>
                        证书生成</h2>
                </td>
            </tr>
            <tr>
                <td style="text-align: left;">
                    公司名称
                </td>
                <td style="text-align: left;">
                    <asp:TextBox ID="txbCompany" runat="server" Width="200px" Height="25px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: left;">
                    到期日期
                </td>
                <td style="text-align: left;">
                    <asp:TextBox ID="txbExpireDate" runat="server" Width="200px" Height="25px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: left;">
                    手机App用户数
                </td>
                <td style="text-align: left;">
                    <asp:TextBox ID="txbAppUserCount" runat="server" Width="200px" Height="25px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <asp:Button ID="btnBuild" runat="server" Text="生成证书" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
