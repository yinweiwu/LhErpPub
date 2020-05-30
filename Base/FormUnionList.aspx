<%@ Page Language="C#" Inherits="sysBaseBll.FormUnionList" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>联合报表</title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=3" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css?r=3" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/datagrid-detailview.js?r=3" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js?r=3" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="/Base/JS/approval.js" type="text/javascript"></script>
    <script src="JS2/lookUp.js" type="text/javascript"></script>
    <script src="JS/datagridExtend.js" type="text/javascript"></script>
    <script src="JS2/datagridOp.js" type="text/javascript"></script>
    <script src="/Base/Lodop/LodopFuncs.js?r=1" type="text/javascript"></script>
    <script src="/Base/JS2/hxLodop.js?r=1" type="text/javascript"></script>
    <script src="JS2/FormUnionList.js"></script>
    <style type="text/css">
        .main {
            width: 100%;
            height: 100%;
            position: absolute;
            margin: 0px;
            padding: 0px;
        }

        .quarter-div-four {
            width: 50%;
            height: 50%;
            float: left;
            margin: 0px;
            padding: 0px;
        }

        .button {
            display: inline-block;
            outline: none;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            /*font: 14px/100% 'Microsoft yahei' ,Arial, Helvetica, sans-serif;*/
            font-size: 14px;
            padding: .5em 2em .50em;
            text-shadow: 0 1px 1px rgba(0,0,0,.3);
            -webkit-border-radius: .5em;
            -moz-border-radius: .5em;
            border-radius: .5em;
            -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            -moz-box-shadow: 0 1px 2px rgba(0,0,0,.2);
            box-shadow: 0 1px 2px rgba(0,0,0,.2);
            font-weight: bold;
        }

            .button:hover {
                text-decoration: none;
            }

            .button:active {
                position: relative;
                top: 1px;
            }

        /* orange */
        .orange {
            /*color: #fef4e9;*/
            color: #ffffff;
            border: solid 1px #da7c0c;
            background: #f78d1d;
            background: -webkit-gradient(linear, left top, left bottom, from(#faa51a), to(#f47a20));
            background: -moz-linear-gradient(top, #faa51a, #f47a20);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#faa51a', endColorstr='#f47a20');
        }

            .orange:hover {
                background: #f47c20;
                background: -webkit-gradient(linear, left top, left bottom, from(#f88e11), to(#f06015));
                background: -moz-linear-gradient(top, #f88e11, #f06015);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f88e11', endColorstr='#f06015');
            }

            .orange:active {
                /*color: #fcd3a5;*/
                color: #ffffff;
                background: -webkit-gradient(linear, left top, left bottom, from(#f47a20), to(#faa51a));
                background: -moz-linear-gradient(top, #f47a20, #faa51a);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f47a20', endColorstr='#faa51a');
            }

        .btn-separator {
            height: 30px;
            border-left: 1px solid #a0a0a0;
            border-right: 1px solid #a0a0a0;
            margin: 1px 20px;
            display: inline;
        }
        .tabprint {
            width: 100%;
        }

            .tabprint tr td {
                height: 25px;
                /*padding: 3px;*/
                font-weight: bold;
            }
    </style>
</head>
<body class="easyui-layout" data-options="border:false">
    <form id="form1" runat="server">
        <div id="divTopCondition" data-options="region:'north',border:false" style="height: 110px;">
            <%--<asp:HiddenField ID="HidMainDefined" runat="server" />
            <asp:HiddenField ID="HidChildDefined" runat="server" />
            <asp:HiddenField ID="HidSelfCondition" runat="server" />
            <asp:HiddenField ID="HidPerson" runat="server" />
            <asp:HiddenField ID="HidDynLookupDefine" runat="server" />
            <asp:HiddenField ID="HidDynData" runat="server" />
            <asp:HiddenField ID="HidColumnDefined" runat="server" />
            <asp:HiddenField ID="HidChartDefined" runat="server" />
            <asp:HiddenField ID="HidDynConditionGUID" runat="server" />
            <asp:HiddenField ID="HidButtonRight" runat="server" />
            <asp:HiddenField ID="HidWindowParam" runat="server" />
            <asp:HiddenField ID="HidPbPrint" runat="server" />
            <asp:HiddenField ID="HidAss" runat="server" />--%>
            <div style="vertical-align: middle">
                <img alt="" src="JS/easyui/themes/icons/search.png" />查询条件
                <hr />
            </div>
            <div style="float: left;">
                <table id="tabConditions" style="margin-left: 35px;">
                </table>
            </div>
        </div>
        <div id="divContent" data-options="region:'center',border:false">
        </div>
        <div id="divlookUp" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="closed:true,title: '选择数据',bodyCls: 'ifrcss',modal: true, cache: false,
     maximizable: true,resizable: true,onBeforeOpen:lookUp.onBeforeOpen,onBeforeClose:lookUp.onBeforeClose,onBeforeDestroy:lookUp.onBeforeDestroy">
            <iframe style='margin: 0; padding: 0' id='ifrlookup' name='ifrlookup' width='100%'
                height='99%' frameborder='0'></iframe>
        </div>
        <div id="divFormBill" style="display: none;">
        </div>
        <div id="divPb" style="display: none;">
            <iframe name="ifrpb" id="ifrpb" width='0' height='0'></iframe>
        </div>
        <div id="divExport" style="display: none;">
        </div>
        <div id="divImport" class="easyui-dialog" style="padding: 0px; margin: 0px;" data-options="top:100,width:500,height:250,closed:true,title: '导入数据',modal: true, cache: false">
            <iframe style='margin: 0; padding: 0' id='ifrImport' name='ifrImport' width='100%'
                height='99%' frameborder='0'></iframe>
        </div>
        <div id="divlogin" style="width: 250px; text-align: center;" class="easyui-window"
            data-options="title:'重新登录',minimizable:false,maximizable:false,modal:true,closed:true">
            <table style="margin: auto;">
                <tr>
                    <td style="text-align: left; height: 30px;">用户名：
                    </td>
                    <td>
                        <input id="txbReLoginUserID" type="text" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: left; height: 30px;">密码：
                    </td>
                    <td>
                        <input id="txbReLoginPsd" type="password" style="width: 120px; height: 22px; border: solid 1px #d0d0d0;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="height: 40px">
                        <input id="Button1" type="button" value="确定" onclick="FormUnionList.ReLogin()" style="width: 50px; height: 25px;" />
                    </td>
                </tr>
            </table>
        </div>
        <div id="divFj" style="display: none; margin: 0px; padding: 0px;">
            <iframe id="ifrFj" width="100%" height="98%" frameborder="0"></iframe>
        </div>
    </form>
</body>
</html>
