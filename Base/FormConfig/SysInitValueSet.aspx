<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>背景色设置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js" type="text/javascript"></script>
    <script src="JS/SysInitValueSet.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 12px;
        }
        .tab
        {
        }
        .tab tr td
        {
            height: 25px;
            padding: 5px;
        }
        textarea
        {
            border: none;
            overflow: hidden;
        }
        .input
        {
            border: none;
            width: 99%;
        }
        .divchild
        {
            border: solid 1px #dfdfdf;
            border-collapse:collapse;
        }
        .divchild tr th
        {
            height: 25px;
            text-align: center;
            font-weight: bold;
            border: solid 1px #dfdfdf;
            background-color: #f1f1f1;
        }
        .divchild tr td
        {
            height: 30px;
            text-align: center;
            border: solid 1px #dfdfdf;
        }
        .inputnoborder
        {
            border: none;
            width: 98%;
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <form id="form1" runat="server">
    <div data-options="region:'north',border:false" style="height:30px;">
        <table>
            <tr>
                <td style="width: 20px">
                </td>
                <td style="width: 70px; height: 30px;">
                    FormID
                </td>
                <td>
                    <input id="Text1" style="border: none; border-bottom: solid 1px #d1d1d1" type="text" />
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div data-options="region:'center',border:false">
        <div id="navtab1" class="easyui-tabs" data-options="fit:true,border:false">
            <div title="背景色设置">
                <div id="divtool4" style="height: 30px;background-color: #efefef;">
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="itemclick4('增加行')">增加行</a>&nbsp;&nbsp;
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="itemclick4('删除行')">删除行</a>&nbsp;&nbsp;
                    <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="itemclick4('保存')">保存</a>&nbsp;&nbsp;
                </div>
                <div>
                    <table class="divchild" id="tabbgcolor">
                        <tr>
                            <th style="width: 25px">
                                <input id="Checkbox4" style="width: 15px; height: 15px;" onclick="selectall(this,'tabbgcolor')"
                                    type="checkbox" />
                            </th>
                            <th style="width: 400px">
                                JS代码
                            </th>
                            <th style="width: 150px">
                                背景色
                            </th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
