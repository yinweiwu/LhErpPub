<%@ page language="C#" autoeventwireup="true" inherits="ExcelExport, App_Web_excelexport.aspx.fca1e55" validaterequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <%--<asp:Button ID="Button2" runat="server" Text="Button" onclick="Button1_Click" />--%>
        <input type="hidden" id="tableData" name="tableData" />
        <input type="hidden" id="titles" name="titles" />
    </div>
    </form>
</body>
</html>
