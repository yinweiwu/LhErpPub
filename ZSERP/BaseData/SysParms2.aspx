<%@ Page Language="C#" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>系统参数</title>
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/color.css" />
    <link rel="stylesheet" type="text/css" href="/Base/JS/easyui/themes/icon.css" />
    <script type="text/javascript" src="/Base/JS/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="/Base/JS/easyui/jquery.easyui.min.js"></script>
    <script src="/Base/JS/json2.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS2/Form.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/DataInterface.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <style type="text/css">
        body {
            font-family: Arial;
            font-size: 12px;
        }

        .txb {
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
            $.ajax(
                {
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
            $.ajax(
                {
                    url: "/ashx/LoginHandler.ashx",
                    type: "post",
                    cache: false,
                    data: { otype: "getServerUrl" },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.messager.alert("错误", textStatus);
                    },
                    success: function (data, textStatus) {
                        if (data != "") {
                            sFileServerName = data;
                        }
                        else {
                            $.messager.show({
                                title: '提示',
                                msg: "获取当前服务器地址失败！",
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
                });
            var sqlobj = {
                TableName: "SysParam",
                Fields: "*",
                SelectAll: "True"
            };
            var data = SqlGetData(sqlobj);
            if (data.length > 0) {
                $("#ff").form("load", data[0]);
                document.getElementById('iHiddenShotcut').checked = data[0].iHiddenShotcut == "1" ? true : false;
                document.getElementById('iTimerStart').checked = data[0].iTimerStart == "1" ? true : false;
                //document.getElementById('iMustOrderPrice').checked = data[0].iMustOrderPrice == "1" ? true : false;
                //document.getElementById('iColorFrom').checked = data[0].iColorFrom == "1" ? true : false;
                //document.getElementById('iMustProductOutPrice').checked = data[0].iMustProductOutPrice == "1" ? true : false;
                //document.getElementById('iMustSendPrice').checked = data[0].iMustSendPrice == "1" ? true : false;
                //document.getElementById('iMustOutTotal').checked = data[0].iMustOutTotal == "1" ? true : false;
                //document.getElementById('iSendTwo').checked = data[0].iSendTwo == "1" ? true : false;
                //document.getElementById('iCustomerOut').checked = data[0].iCustomerOut == "1" ? true : false;
                //document.getElementById('iYesMoveShop').checked = data[0].iYesMoveShop == "1" ? true : false;
                //document.getElementById('iYesInStock').checked = data[0].iYesInStock == "1" ? true : false;
                document.getElementById('iNotChecKMessage').checked = data[0].iNotChecKMessage == "1" ? true : false;
                document.getElementById('iMobileLoginCheck').checked = data[0].iMobileLoginCheck == "1" ? true : false;
                document.getElementById('iWeiXinMessage').checked = data[0].iWeiXinMessage == "1" ? true : false;
                document.getElementById('iDisableLoginIdenCode').checked = data[0].iDisableLoginIdenCode == "1" ? true : false;
                document.getElementById('iTimerStart').checked = data[0].iTimerStart == "1" ? true : false;
                //                $('#fManager').val(data[0].fManager);
                //                $('#fTaxRate').val(data[0].fTaxRate);
                //                $('#fReturnRate').val(data[0].fReturnRate);
                //                $('#fLowSrate').val(data[0].fLowSrate);
                //                $('#iProduceDays').val(data[0].fLowSrate);

            }


            $("#TabWeiXinTemplet").datagrid(
            {
                fit: true,
                border: false,
                rownumbers: true,
                singleSelect: true,
                columns:
                [
                    [
                        {
                            title: "查看样式", width: 70, field: "__aa", formatter: function (value, row, index) {
                                return "<a href='javascript:void(0)' onclick='view(" + index + ")'>查看样式</a>";
                            }
                        },
                        { title: "模板ID", field: "template_id", width: 150 },
                        { title: "模板标题", field: "title", width: 100 },
                        { title: "一级行业", field: "primary_industry", width: 100 },
                        { title: "二级行业", field: "deputy_industry", width: 100 },
                        { title: "模板内容", field: "content", width: 400 },
                        { title: "模板示例", field: "example", width: 400 }

                    ]
                ],
                remoteSort: false,
                onDblClickRow: function (index, row) {
                    $("#Text8").val(row.template_id);
                    $("#divTemplet").dialog("close");
                }
            }
            )
        })

        function save() {
            $('#sFileServerName').val(sFileServerName);
            $('#TableName').val("SysParam");
            $('#FieldKey').val("iRecNo");
            $('#FieldKeyValue').val("1");
            var bb = Form.__update("1", "/Base/Handler/DataOperatorNew.ashx")
            var jsonobj = {
                StoreProName: "SpGetIden",
                StoreParms: [{
                    ParmName: "@sTableName",
                    Value: "SysParam"
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
                var aa = Form.__add("/Base/Handler/DataOperatorNew.ashx")
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
        function downLoadTemplet() {
            $.messager.progress({ title: "正在下载中。。。" });
            $.ajax(
                {
                    url: "/Base/Handler/PublicHandler.ashx",
                    type: "get",
                    cache: false,
                    async: true,
                    data: { otype: "GetWeiXinAllTemplet" },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        $.messager.alert("错误", textStatus);
                        $.messager.progress("close");
                    },
                    success: function (data, textStatus) {
                        $.messager.show({
                            title: 'OK!',
                            msg: "下载成功!",
                            timeout: 1000,
                            showType: 'show',
                            style: {
                                right: '',
                                top: document.body.scrollTop + document.documentElement.scrollTop,
                                bottom: ''
                            }
                        });
                        $.messager.progress("close");
                    }
                });
        }
        function openTempletWindow() {
            var sqlObj = {
                TableName: "WeiXinTemplet",
                Fields: "*",
                SelectAll: "True",
                Sorts: [
                    {
                        SortName: "title",
                        SortOrder: "asc"
                    }
                ]
            }
            var data = SqlGetData(sqlObj);
            $("#TabWeiXinTemplet").datagrid("loadData", data);
            $("#divTemplet").dialog("open");
        }
        function view(index) {
            var allRows = $("#TabWeiXinTemplet").datagrid("getRows");
            var example = allRows[index].example.replace(/\n/g, "<br />");
            $("#pview").html(example);
            $("#divView").dialog("open");
        }
        function checkTimerProExists(obj) {
            var checked = obj.checked;
            if (checked) {
                $.ajax({
                    url: "/Base/Handler/PublicHandler.ashx",
                    type: "get",
                    cache: false,
                    async: true,
                    data: { otype: "checkTimerProcedureExists" },
                    success: function (data) {
                        if (data != "1") {
                            $.messager.alert("错误", "检测到定时任务存储过程SpSysTimerTask不存在，请先创建");
                            obj.checked = false;
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {

                    }
                });
            }
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
        <div data-options="region:'north',title:''" style="height: 30px; background: #efefef; padding: 0px;">
            <a href='javascript:void(0)' class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'"
                onclick='save()'>保存</a>&nbsp;|&nbsp;<a href='javascript:void(0)' class="easyui-linkbutton"
                    data-options="plain:true,iconCls:'icon-undo'" onclick='back()'>退出</a>
        </div>
        <div data-options="region:'west',title:''" style="padding-left: 20px; width: 600px;">
            <br />
            <div class="easyui-panel" data-options="title:'页面设置'" style="padding: 5px; width: 550px; vertical-align: middle;">
                <table>
                    <tr>
                        <td>
                            <input id="iHiddenShotcut" type="checkbox" runat="server" fieldid="iHiddenShotcut"
                                name="iHiddenShotcut" />
                            <label for="iHiddenShotcut">
                                首页不显示快捷入口</label>
                        </td>
                        <td>
                            <input id="iNotChecKMessage" type="checkbox" runat="server" fieldid="iNotChecKMessage"
                                name="iNotChecKMessage" />
                            <label for="iNotChecKMessage">
                                取消定时检测消息</label>
                        </td>
                        <td>首页流程图
                        <input id="sFirstFlowID" type="text" fieldid="sFirstFlowID" name="sFirstFlowID" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input id="iDisableLoginIdenCode" type="checkbox" runat="server" fieldid="iDisableLoginIdenCode"
                                name="iDisableLoginIdenCode" />
                            <label for="iDisableLoginIdenCode">
                                登录界面关闭验证码</label>
                        </td>

                    </tr>
                </table>
            </div>
            <br />
            <%--<div class="easyui-panel" data-options="title:'仓库管理'" style="padding: 5px; width: 550px;
            vertical-align: middle;">
            <table>
                <tr>
                    <td>
                        <input id="iCommonBarCode" type="checkbox" runat="server" fieldid="iCommonBarCode"
                            name="iCommonBarCode" />
                        <label for="iCommonBarCode">
                            是否通用条码</label>
                    </td>
                    <td>
                        <input id="iCustomerOut" type="checkbox" runat="server" fieldid="iCustomerOut" name="iCustomerOut" />
                        <label for="iCustomerOut">
                            是否可按库存客户出库</label>
                    </td>
                    <td>
                        <input id="iYesMoveShop" type="checkbox" runat="server" fieldid="iYesMoveShop" name="iYesMoveShop" />
                        <label for="iYesMoveShop">
                            是否车间交接逐条确认</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input id="iYesInStock" type="checkbox" runat="server" fieldid="iYesInStock" name="iYesInStock" />
                        <label for="iYesInStock">
                            是否生产入库逐条确认</label>
                    </td>
                    <td>
                        <input id="iYesDbStock" type="checkbox" runat="server" fieldid="iYesDbStock" name="iYesDbStock" />
                        <label for="iYesDbStock">
                            是否成品调拨逐条确认</label>
                    </td>
                </tr>
            </table>
        </div>--%>
            <br />
            <%--<div class="easyui-panel" data-options="title:'价格设置'" style="padding: 5px; width: 550px;
            vertical-align: middle;">
            <table>
                <tr>
                    <td>
                        <input id="iMustOrderPrice" type="checkbox" runat="server" fieldid="iMustOrderPrice"
                            name="iMustOrderPrice" />
                        <label for="iMustOrderPrice">
                            是否订单必须填写价格</label>
                    </td>
                    <td>
                        <input id="iMustProductOutPrice" type="checkbox" runat="server" fieldid="iMustProductOutPrice"
                            name="iMustProductOutPrice" />
                        <label for="iMustProductOutPrice">
                            是否成品出库必须有价格</label>
                    </td>
                    <td>
                        <input id="iSendTwo" type="checkbox" runat="server" fieldid="iSendTwo" name="iSendTwo" />
                        <label for="iSendTwo">
                            是否发货单可多次发货</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input id="iMustSendPrice" type="checkbox" runat="server" fieldid="iMustSendPrice"
                            name="iMustSendPrice" />
                        <label for="iMustSendPrice">
                            是否发货通知单必须有价格</label>
                    </td>
                    <td>
                        <input id="iMustOutTotal" type="checkbox" runat="server" fieldid="iMustOutTotal"
                            name="iMustOutTotal" />
                        <label for="iMustOutTotal">
                            是否出库金额不能大于发货单金额</label>
                    </td>
                </tr>
            </table>
        </div>--%>
            <br />
            <%--<div class="easyui-panel" data-options="title:'报价设置'" style="padding: 5px; width: 550px;
            vertical-align: middle;">
            <table>
                <tr>
                    <td>
                        税 率
                    </td>
                    <td>
                        <input id="fTaxRate" type="text" runat="server" fieldid="fTaxRate" name="fTaxRate"
                            class="txb" style="width: 60px" /><em style="color: Blue">%</em>
                    </td>
                    <td>
                        退 税 率
                    </td>
                    <td>
                        <input id="fReturnRate" type="text" runat="server" fieldid="fReturnRate" name="fReturnRate"
                            class="txb" style="width: 60px" /><em style="color: Blue">%</em>
                    </td>
                </tr>
                <tr>
                    <td>
                        管理费率
                    </td>
                    <td>
                        <input id="fManager" type="text" runat="server" fieldid="fManager" name="fManager"
                            class="txb" style="width: 60px" /><em style="color: Blue">%</em>
                    </td>
                    <td>
                        最低利润率
                    </td>
                    <td>
                        <input id="fLowSrate" type="text" runat="server" fieldid="fLowSrate" name="fLowSrate"
                            class="txb" style="width: 60px" /><em style="color: Blue">%</em>
                    </td>
                </tr>
            </table>
        </div>--%>
            <br />
            <div class="easyui-panel" data-options="title:'其他设置'" style="padding: 5px; width: 550px; vertical-align: middle;">
                <table>
                    <tr>
                        <td>小数位数
                        <input id="iDigit" type="text" runat="server" fieldid="iDigit" name="iDigit"
                            style="width: 60px" class="txb" />
                        </td>
                        <td>
                            <label>
                                <input id="iTimerStart" type="checkbox" runat="server" fieldid="iTimerStart"
                                    name="iTimerStart" onclick="checkTimerProExists(this)" />
                                开启定时任务
                            </label>
                        </td>
                        <%--<td>
                        生产提前天数
                        <input id="iProduceDays" type="text" runat="server" fieldid="iProduceDays" name="iProduceDays"
                            style="width: 60px" class="txb" />
                    </td>
                    <td>
                        <input id="iColorFrom" type="checkbox" runat="server" fieldid="iColorFrom" name="iColorFrom" />
                        <label for="iColorFrom">
                            是否款式颜色确定</label>
                    </td>--%>
                    </tr>
                </table>
            </div>
            <br />
            <div class="easyui-panel" data-options="title:'短信发送'" style="padding: 5px; width: 550px; vertical-align: middle;">
                <table>
                    <tr>
                        <td>账号
                        </td>
                        <td>
                            <input id="Text1" type="text" fieldid="sSMSAccount" name="sSMSAccount" style="width: 300px"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>密钥
                        </td>
                        <td>
                            <input id="Text2" type="text" fieldid="sSMSPassword" name="sSMSPassword" style="width: 300px"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>通道组
                        </td>
                        <td>
                            <input id="Text3" type="text" fieldid="iChannelGroup" name="iChannelGroup" style="width: 60px"
                                class="txb" />
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            <div class="easyui-panel" data-options="title:'手机APP'" style="padding: 5px; width: 550px; vertical-align: middle;">
                <table>
                    <tr>
                        <td>服务器地址
                        </td>
                        <td>
                            <input id="Text4" type="text" fieldid="sAppServerAddr" name="sAppServerAddr" style="width: 300px"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>服务器图片地址
                        </td>
                        <td>
                            <input id="Text5" type="text" fieldid="sAppServerImageAddr" name="sAppServerImageAddr"
                                style="width: 300px" class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>登录手机验证
                        </td>
                        <td>
                            <input id="iMobileLoginCheck" type="checkbox" runat="server" fieldid="iMobileLoginCheck"
                                name="iMobileLoginCheck" />
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            <div class="easyui-panel" data-options="title:'微信公众号'" style="padding: 5px; width: 550px; vertical-align: middle;">
                <table>
                    <tr>
                        <td>appid
                        </td>
                        <td>
                            <input id="Text6" type="text" fieldid="sWeiXinAppID" name="sWeiXinAppID" style="width: 300px"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>secret
                        </td>
                        <td>
                            <input id="Text7" type="text" fieldid="sWeiXinSecret" name="sWeiXinSecret" style="width: 300px"
                                class="txb" />
                        </td>
                    </tr>
                    <tr>
                        <td>模板号
                        </td>
                        <td>
                            <input id="Text8" type="text" fieldid="sWeiXinTemplet" name="sWeiXinTemplet" style="width: 300px"
                                class="txb" />
                            <input type="button" value="..." onclick="openTempletWindow()" />
                            <a href="javascript:void(0)" onclick="downLoadTemplet()">下载所有模板</a>
                        </td>
                    </tr>
                    <tr>
                        <td>开启微信公众号提醒
                        </td>
                        <td>
                            <input id="iWeiXinMessage" type="checkbox" runat="server" fieldid="iWeiXinMessage"
                                name="iWeiXinMessage" />
                        </td>
                    </tr>
                </table>
            </div>
            <br />
            <div style="display: none;">
                <fieldset style="border: solid 1px #d0d0d0; width: 530px;">
                    <legend style="margin: 5px; padding: 5px;"></legend>
                    <table class="tab">
                        <tr>
                            <td>
                                <input id="sUserID" type="text" runat="server" fieldid="sUserID" name="sUserID" class="txb" />
                            </td>
                            <td>
                                <input id="dinputDate" type="text" runat="server" fieldid="dinputDate" name="dinputDate"
                                    class="txb" />
                            </td>
                            <td>
                                <input id="sFileServerName" type="text" runat="server" fieldid="sFileServerName"
                                    name="sFileServerName" class="txb" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </div>
        </div>
        <div data-options="region:'center',title:'登录界面轮播图'" style="padding-left: 20px; width: 600px;">
            <iframe frameborder="0" height="3" src="loginCarouselImages.aspx" style="width: 100%; height: 800px;"></iframe>
        </div>
        <div id="divTemplet" class="easyui-dialog" data-options="width:860,height:400,closed:true,title: '选择模板',modal: true, cache: false">
            <table id="TabWeiXinTemplet">
            </table>
        </div>
        <div id="divView" class="easyui-dialog" data-options="width:400,height:250,closed:true,title: '模板样式',modal: true, cache: false">
            <p id="pview" style="font-size: 14px; padding: 10px;">
            </p>
        </div>
    </form>
</body>
</html>
