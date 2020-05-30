<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>整经单</title>
    <style type="text/css">
        .ifm {
            width: 70px;
            height: 22px;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/lookUp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            $('#start').window('close');
            $('#end').window('close');

        });
        function StartWarping() {
            $('#start').window('open');
        }
        function EndWarping() {
            $('#end').window('open');
        }
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',split:true,collapsible:true,border:false" style="width: 100%;height:100%" class="easyui-resizable">
        <div class="easyui-layout" data-options="border:false,fit:true,border:false">
            <div data-options="region:'north'" style="height: 100%">
 
                            <input type="button" value="开始整经" onclick="StartWarping()"  style="width:600px;height:150px;font-size: 30px;margin:130px auto 100px;display:block;font-weight:bold"/>

                            <input type="button" value="结束整经" onclick="EndWarping()" style="width:600px;height:150px;font-size: 30px;margin:0 auto;display:block;font-weight:bold"/>

            </div>
        </div>
    </div>

 <div id="start" class="easyui-window" title="开始整经" style="width: 800px; height: 500px"
            data-options="modal:true,collapsible:false,minimizable:false,maximizable:false">
            <table align="center" style="margin-top:100px;margin-left:150px;width:600px;height:300px">
                <tr style="height:45px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="1">
                        条码
                    </td>
                    <td>
                        <input type="text" id="6" style="border-left-width:0px;border-top-width:0px;border-right-width:0px;border-bottom-color:black;width:250px"/>
                    </td>
                </tr>
                <tr style="height:45px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="1">
                        整经单号
                    </td>
                    <td>
                        <input type="text" id="5"  disabled="disabled"/>
                    </td>
                </tr>
                <tr style="height:45px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="1">
                        衬子
                    </td>
                    <td>
                       <input type="text" id="4" disabled="disabled"/>
                    </td>
                </tr>
                <tr style="height:45px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="1">
                        机台号
                    </td>
                    <td>
                        <input type="text" id="3" disabled="disabled"/>
                    </td>
                </tr>
                <tr align="center">
                    <td colspan="3">
                        <br />
                        <br />
                        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 150px; height: 70px"
                            onclick="Start()"><span style="font-size: 16px">确定</span></a>
                    </td>
                </tr>
                </table>
        </div>
 <div id="end" class="easyui-window" title="结束整经" style="width: 800px; height: 500px"
            data-options="modal:true,collapsible:false,minimizable:false,maximizable:false">
            <table align="center" style="margin-top:100px;margin-left:150px;width:600px;height:300px">
                <tr style="height:50px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="2">
                        机台号
                    </td>
                    <td>
                       <input type="text" id="1"style="border-left-width:0px;border-top-width:0px;border-right-width:0px;border-bottom-color:black"/>
                    </td>
                </tr>
                <tr style="height:50px">
                    <td style="font-family: 微软雅黑; font-size: 20px;" colspan="2">
                        整经实际米数
                    </td>
                    <td>
                        <input type="text" id="2" style="border-left-width:0px;border-top-width:0px;border-right-width:0px;border-bottom-color:black"/>
                    </td>
                </tr>
                <tr align="center">
                    <td colspan="3">
                        <br />
                        <br />
                        <a href="javascript:void(0)" class="easyui-linkbutton" style="width: 150px; height: 70px"
                            onclick="End()"><span style="font-size: 16px">确定</span></a>
                    </td>
                </tr>
                </table>
        </div>
</body>
</html>
