<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>公司信息</title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 12px;
        }
        .txb
        {
            border: solid 1px #95b8e7;
            height: 18px;
            border-radius: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var sFileServerName = "";
        $(function () {
            var myDate = new Date();
            var aa = "";
            var bb = "";
            if (myDate.getMonth() < 9) {
                aa = "0";
            }
            if (myDate.getDate() < 10) {
                bb = "0";
            }
            var time = myDate.getFullYear() + "-" + aa + (myDate.getMonth() + 1) + "-" + bb + myDate.getDate();
            $('#dinputDate').val(time);
            $.ajax({
                url: "/ashx/LoginHandler.ashx",
                type: "post",
                cache: false,
                data: { otype: "getcurtuserid" },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.messager.alert("错误", textStatus);
                },
                success: function (data, textStatus) {
                    $('#sUserID').val(data);
                }
            });

            var sqlobj = {
                TableName: "bscDataThisCompanyInfo",
                Fields: "*",
                SelectAll: "True"
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                $("#ff").form("load", data[0]);
            }
        })

        function save() {
            if ($("#sFullName").val() == "")
            {
                $.messager.alert("错误！", "全称不能为空！");
                return;
            }
            $('#TableName').val("bscDataThisCompanyInfo");
            $('#FieldKey').val("iRecNo");
            $('#FieldKeyValue').val("1");
            var bb = Form.__update("1", "/Base/Handler/DataOperatorNew.ashx");
            var jsonobj = {
                StoreProName: "SpGetIden",
                StoreParms: [{
                    ParmName: "@sTableName",
                    Value: "bscDataThisCompanyInfo"
                }]
            }
            var Result = SqlStoreProce(jsonobj);
            if (bb.indexOf('error') > 0) {
                {
                    $.messager.show({
                        title: '错误',
                        msg: "保存失败！",
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                }
            }
            else if (Result == "1") {
                var aa = Form.__add("/Base/Handler/DataOperatorNew.ashx");
                if (aa.indexOf('error') > 0) {
                    {
                        $.messager.show({
                            title: '错误',
                            msg: "保存失败！",
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                    }
                }
                else if (aa == "1") {
                    {
                        $.messager.show({
                            title: 'OK!',
                            msg: "保存成功!",
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                    }
                }
            }
            else if (bb == "1" && Result != "1") {
                {
                    $.messager.show({
                        title: 'OK!',
                        msg: "保存成功!",
                        timeout: 1000,
                        showType: 'show',
                        style: {
                            right: '',
                            top: document.body.scrollTop + document.documentElement.scrollTop,
                            bottom: ''
                        }
                    });
                }
            }
        }

        function back() {
            window.parent.closeTab();
        }

    </script>
</head>
<body class="easyui-layout">
    <form id="ff" method="post" runat="server">
    <asp:HiddenField ID="TableName" runat="server" />
    <!--要保存的表名-->
    <asp:HiddenField ID="FieldKey" runat="server" />
    <!--表的主键字段-->
    <asp:HiddenField ID="FieldKeyValue" runat="server" />
    <!--表的主键值-->
    <div data-options="region:'north',title:''" style="height: 30px; background: #efefef;
        padding: 0px;">
        <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'"
            onclick='save()'>保存</a>&nbsp;|&nbsp;<a href='javascript:void(0)' class="easyui-linkbutton"
                data-options="plain:true,iconCls:'icon-undo'" onclick='back()'>退出</a>
    </div>
    <div data-options="region:'west',title:''" style="padding-left: 20px;width: 600px;">
        <br />
        <div class="easyui-panel" data-options="title:'主要信息'" style="padding: 5px; width: 550px;
            vertical-align: middle;">
            <table>
                <tr>
                    <td>
                        全称
                        <input id="sFullName" type="text" fieldid="sFullName" name="sFullName" style="width:200px;" />
                    </td>
                    <td>
                        简称
                        <input id="sShotName" type="text" fieldid="sShotName" name="sShotName" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <br />
        <div class="easyui-panel" data-options="title:'其他信息'" style="padding: 5px; width: 550px;
            vertical-align: middle;">
            <table>
                <tr>
                    <td colspan="2">
                        标语
                        <input id="sSlogan" type="text" fieldid="sSlogan" name="sSlogan" style="width:90%" />
                    </td>
                    
                </tr>
                <tr>
                    <td colspan="2">
                        地址
                        <input id="sAddress" type="text" fieldid="sAddress" name="sAddress" style="width:90%" />
                    </td>
                </tr>
                <tr>
                    <td>
                        网址
                        <input id="sHomepage" type="text" fieldid="sHomepage" name="sShotName" />
                    </td>
                    <td>
                        电话
                        <input id="sTel" type="text" fieldid="sTel" name="sTel" />
                    </td>    
                </tr>
                <tr>
                    <td>
                        传真
                        <input id="sFax" type="text" fieldid="sFax" name="sFax" />
                    </td>
                    <td>
                        邮编
                        <input id="sZip" type="text" fieldid="sZip" name="sZip" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div style="display: none;">
            <input id="sUserID" type="text" runat="server" fieldid="sUserID" name="sUserID" />
            <input id="dinputDate" type="text" runat="server" fieldid="dinputDate" name="dinputDate" />

        </div>
    </div>
    <div data-options="region:'center',title:'LOGO图片'" style="padding-left: 20px; width: 300px;">
        <iframe frameborder="0" height="3" src="ThisCompanyLogo.aspx" style="width: 100%;
            height: 300px;"></iframe>
    </div>
    </form>
</body>
</html>
