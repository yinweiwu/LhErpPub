<%@ page language="C#" autoeventwireup="true" inherits="ZSERP_BaseData_ThisCompanyLogo, App_Web_thiscompanylogo.aspx.ec40b2f1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-size:14px; 
            }
        .img
        {
            width: 300px;
            height: 200px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td>
                    <div>
                        <asp:Image ID="Image1" CssClass="img" runat="server" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:FileUpload ID="FileUpload1" runat="server" />
                    <asp:Button ID="Button1" runat="server" Text="上传" OnClick="Button1_Click" />
                    <asp:Button ID="Button5" runat="server" Text="删除" OnClick="Button5_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
