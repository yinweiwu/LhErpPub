<%@ page language="C#" autoeventwireup="true" inherits="Default3, App_Web_default4.aspx.cdcab7d2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        function aaaa() {
            for (var i = 0; i < 5; i++) {
                $("body").append("<div id='div" + i + "'>" + i + "</div>");
                $("#div"+i).dialog({
                    title: 'My Dialog'+i,
                    width: 400,
                    height: 200,
                    closed: false,
                    cache: false
                })
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input type="button" value="开始" onclick="aaaa()" />
    </div>
        <div id="div">
            aaaaa
        </div>
    </form>
</body>
</html>
