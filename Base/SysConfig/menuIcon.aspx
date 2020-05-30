<%@ page language="C#" autoeventwireup="true" inherits="Base_SysConfig_menuIcon, App_Web_menuicon.aspx.28739da1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>上传菜单图片</title>
    <style type="text/css">
        body
        {
            margin: 0px;
            padding: 0px;
            font-size:12px;
            font-family:Verdana;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td id="tdIcon">
                    <asp:Image ID="Image1" Width="70px" Height="70px" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:FileUpload ID="FileUpload1" runat="server" Width="108px" />
                    <asp:Button ID="Button1" runat="server" Text="上传" OnClick="Button1_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
