<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>打印数据集设置</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/SqlOp.js" type="text/javascript"></script>
    <script src="JS/SysPrintDataSet.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function loadJS(path) {
            if (!path || path.length === 0) {
                throw new Error('argument "path" is required !');
            }
            var head = document.getElementsByTagName('head')[0];
            var script = document.createElement('script');
            script.src = path;
            script.type = 'text/javascript';
            head.appendChild(script);
        }
        function loadCSS(path) {
            if (!path || path.length === 0) {
                throw new Error('argument "path" is required !');
            }
            var head = document.getElementsByTagName('head')[0];
            var link = document.createElement('link');
            link.href = path;
            link.rel = 'stylesheet';
            head.appendChild(link);
        }
        function myBrowser() {
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            var isOpera = userAgent.indexOf("Opera") > -1;
            if (isOpera) {
                return "Opera"
            }; //判断是否Opera浏览器
            if (userAgent.indexOf("Firefox") > -1) {
                return "FF";
            } //判断是否Firefox浏览器
            if (userAgent.indexOf("Chrome") > -1) {
                return "Chrome";
            }
            if (userAgent.indexOf("Safari") > -1) {
                return "Safari";
            } //判断是否Safari浏览器
            if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
                return "IE";
            }; //判断是否IE浏览器
        }
        //if (myBrowser() != "IE") {
        //    loadCSS("/Base/js/StimulsoftReport2016.2/css/stimulsoft.viewer.office2013.whiteblue.css");
        //    loadCSS("/Base/js/StimulsoftReport2016.2/css/stimulsoft.designer.office2013.whiteblue.css");
        //    loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.reports.js");
        //    //            loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.viewer.js");
        //    //            loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.designer.js");
        //    setTimeout(function () { loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.viewer.js"); }, 2000);
        //    setTimeout(function () { loadJS("/Base/js/StimulsoftReport2016.2/JS/stimulsoft.designer.js"); }, 2000);
        //    setTimeout(function () { loadJS("/Base/JS2/StimulsoftReport.js?r="+Math.random()); }, 3000);

        //}
    </script>
    <style type="text/css">
        body {
            font-family: Arial;
            font-size: 12px;
        }

        .tab {
        }

            .tab tr td {
                height: 25px;
                padding: 5px;
            }

        textarea {
            border: none;
            overflow: hidden;
        }

        .input {
            border: none;
            width: 99%;
        }

        .divchild {
            border: solid 1px #dfdfdf;
            width: 100%;
            border-collapse: collapse;
        }

            .divchild tr th {
                height: 25px;
                text-align: center;
                font-weight: bold;
                border: solid 1px #dfdfdf;
                background-color: #f1f1f1;
            }

            .divchild tr td {
                height: 30px;
                text-align: center;
                border: solid 1px #dfdfdf;
            }

        .inputnoborder {
            border: none;
            width: 99%;
        }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <form id="form1" runat="server">
        <div data-options="region:'north'" id="divup" style="width: 100%; overflow-x: hidden">
            <div id="divtool" style="height: 30px; line-height: 30px; background-color: #efefef;">
                <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="itemclick('增加行')">增加行</a>&nbsp;&nbsp; <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
                    onclick="itemclick('删除行')">删除行</a>&nbsp;&nbsp;&nbsp;<a class="easyui-linkbutton"
                        data-options="iconCls:'icon-save'" onclick="itemclick('保存')"> 保存</a>
            </div>
            <div>
                <asp:HiddenField ID="HiddenField1" runat="server" />
                <table>
                    <tr>
                        <td style="width: 70px; height: 30px">FormID
                        </td>
                        <td>
                            <input id="Text1" readonly="readonly" class="input" type="text" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div data-options="region:'center',border:false" id="divdown">
            <%--<div id="divchildtool" style="height: 30px; line-height: 30px; background-color: #efefef;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="itemclick('增加行')">
                增加行</a>&nbsp;&nbsp; <a class="easyui-linkbutton" data-options="iconCls:'icon-remove'"
                    onclick="itemclick('删除行')">删除行</a>&nbsp;&nbsp;
        </div>--%>
            <div style="width: 100%">
                <table id="tab" class="divchild" style="width: 100%">
                    <tr>
                        <th style="width: 20px;">
                            <input id="Checkbox1" style="width: 12px; height: 12px;" onclick="selectall(this, 'tab')"
                                type="checkbox" />
                        </th>
                        <th style="width: 30px">序号
                        </th>
                        <th style="width: 40px">主键
                        </th>
                        <th style="width: 100px">报表名称
                        </th>
                        <th style="width: 200px">数据集名称及SQL语句
                        </th>
                        <th style="width: 60px">分组
                        </th>
                        <th style="width: 100px">使用其他<br />
                            表单模板
                        </th>
                        <th style="width: 60px">其他表单<br />
                            主键字段
                        </th>
                        <th style="width: 40px">隐藏
                        </th>
                        <th style="width: 80px">打印后存储过程
                        </th>
                        <th style="width: 40px">含列表<br />
                            数据
                        </th>
                        <th style="width: 40px">是否<br />
                            子表
                        </th>
                        <th style="width: 100px">图片设置
                        </th>
                        <th style="width: 60px">报表类型
                        </th>
                        <th style="width: 40px">设计
                        </th>
                        <%--<th style="width: 60px">
                        设计1
                    </th>--%>
                    </tr>
                </table>
                <div style="display: none;">
                    <iframe width="0" height="0" name="ifrpb" id="ifrpb"></iframe>
                </div>
            </div>
        </div>
        <%--<div id="winReport" class="easyui-window" title="设计" data-options="closed:true,modal:true,maximized:true,collapsible:false,minimizable:false,maximizable:false">
        <div id="designerContent">
        </div>
    </div>--%>
        <div id="designerContent">
        </div>
    </form>
    <div id="divPbSelect" class="easyui-dialog" style="width: 550px; height: 400px;" data-options="title:'选择打印报表',closed:true,resizable:true,modal:true,buttons:[{text:'保存',handler:saveSelectPb},{text:'取消',handler:function(){ $('#divPbSelect').dialog('close'); }}]">
        <table id="tbFormPb">
        </table>
    </div>
    <div id="divMenu">
        <table>
            <tr>
                <td>iFormID</td>
                <td>
                    <input id="txbPbFormID" type="text" class="easyui-textbox" style="width: 80px;" />
                </td>
                <td>表单名称</td>
                <td>
                    <input id="txbPbMenuName" type="text" class="easyui-textbox" style="width: 80px;" /></td>
                <td>报表名称</td>
                <td>
                    <input id="txbPbFormIDPbName" type="text" class="easyui-textbox" style="width: 80px;" /></td>
                <td><a class="easyui-linkbutton" onclick="doPbSearch()">查询</a></td>
            </tr>
        </table>
    </div>
</body>
</html>
