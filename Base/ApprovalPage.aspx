<%@ page language="C#" autoeventwireup="true" inherits="ApprovalPage, App_Web_approvalpage.aspx.fca1e55" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>审批界面</title>
    <link href="/Base/JS/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui/themes/color.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui/jquery.min.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script src="JS/SqlOp.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/approval.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
    <script src="JS/json2.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-size: 12px;
            font-family: Arial;
        }
        #TextArea1
        {
            height: 70px;
            width: 250px;
            border: solid 1px #95B8E7;
        }
        .grid
        {
            border-collapse: collapse;
            border: solid 1px #e0e0e0;
        }
        .grid tr th
        {
            height: 20px;
        }
        .grid tr td
        {
            padding: 5px;
            text-align: left;
            height: 25px;
            border: solid 1px #e0e0e0;
        }
        .btn
        {
            width: 80px;
            line-height: 22px;
            font-size: 12px;
            background: url("CSS/img/bg2.jpg") no-repeat left top;
            padding-bottom: 4px;
        }
        .ul
        {
            margin: 0px;
            padding: 0px;
            list-style: none;
        }
        .li
        {
            float: left;
        }
        .lisplit
        {
            width: 1px;
            background-color: Black;
            float: left;
            height: 14px;
            margin-top: 2px;
            margin-left: 5px;
            margin-right: 5px;
        }
        .tabBtn tr td
        {
            padding-right: 5px;
        }
    </style>
    <script language="javascript" type="text/javascript">
        var iBillRecNo;
        var iformid;
        var sProGUID;
        var billUrl;
        var sCheckType;
        var itype;
        var isError = false;
        var urlParms = "";
        //获取当前日期
        function getNowDate() {
            var nowdate = new Date();
            var year = nowdate.getFullYear();
            var month = nowdate.getMonth();
            var date = nowdate.getDate();
            var monthstr = (month + 1).toString();
            var datestr = date.toString();
            if (month < 9) {
                monthstr = '0' + (month + 1).toString();
            }
            if (date < 10) {
                datestr = '0' + date.toString();
            }
            return year.toString() + "-" + monthstr + "-" + datestr;
        }
        //获取当前时间
        function getNowTime() {
            var nowdate = new Date();
            var hour = nowdate.getHours();      //获取当前小时数(0-23)
            var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
            var second = nowdate.getSeconds();
            return hour + ":" + minute + ":" + second;
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
        function agree(obj) {
            if (document.getElementById("div1").style.display == "block") {//表示会签
                if (confirm("确定" + $(obj).linkbutton("options").text + "吗？") == true) {
                    if (getQueryString("from") == "center") {

                        var result = parent.frames["down"].Page.toolBarClick({ id: "__save" });
                        if (result == false) {
                            return false;
                        }
                    }
                    else {
                        var ifr = document.getElementById('ifrUp');
                        var win = ifr.window || ifr.contentWindow;
                        var result = win.Page.toolBarClick({ id: "__save" });
                        if (result == false) {
                            return false;
                        }
                    }

                    var messirecno = getQueryString("irecno");
                    approval.check(messirecno, document.getElementById("Select1").value + "：" + document.getElementById("TextArea1").value, function (checkResult) {
                        if (getQueryString("from") == null) {
                            if (checkResult == true) {
                                alert("提交成功！");
                                parent.loaddatatodo();
                                parent.checkWinClose();
                            }
                            else {
                                alert("提交失败！");
                            }
                        }
                    });

                }
            }
            else {
                if (confirm("确定" + $(obj).linkbutton("options").text + "吗？") == true) {
                    if (getQueryString("from") == "center") {
                        var result = parent.frames["down"].Page.toolBarClick({ id: "__save" });
                        if (result == false) {
                            return false;
                        }
                    }
                    else {
                        var ifr = document.getElementById('ifrUp');
                        var win = ifr.window || ifr.contentWindow;
                        //var ff = parent.frames["up"];
                        var result = win.Page.toolBarClick({ id: "__save" });
                        if (result == false) {
                            return false;
                        }
                    }

                    var messirecno = getQueryString("irecno");
                    approval.check(messirecno, document.getElementById("TextArea1").value, function (checkResult) {
                        if (getQueryString("from") == null) {
                            if (checkResult == true) {
                                //$.messager.alert("成功", obj.value + "成功！", "info", function () {
                                parent.loaddatatodo();
                                parent.checkWinClose();
                                //});
                            }
                        }
                        else {
                            if (checkResult == true) {
                                var ifr = document.getElementById('ifrUp');
                                var win = ifr.window || ifr.contentWindow;
                                $.messager.alert("成功", "审批成功！", "info");
                                win.location.reload();
                            }
                        }
                    });
                }
            }

        }
        function returnback() {
            if (confirm("确认退回吗？") == true) {
                var messirecno = getQueryString("irecno");
                var result = approval.back(messirecno, document.getElementById("TextArea1").value);
                if (result == true) {
                    $.messager.alert("成功", "退回成功！");
                    parent.loaddatatodo();
                    parent.checkWinClose();
                }
            }
        }
        function exit() {
            parent.checkWinClose();
        }
        function pageInit() {
            if (isError) {
                $("#tt").hide();
                return;
            }

            var upUrl = billUrl + "?usetype=modify&key=" + iBillRecNo + "&iformid=" + iformid + "&from=proc&ProcGUID=" + sProGUID + "&itype=" + itype + "&" + urlParms + "&random=" + Math.random();
            if (myBrowser() == "IE") {
                document.getElementById("ifrUp").src = upUrl;
            }
            else {
                setTimeout(function () { document.getElementById('ifrUp').src = upUrl; }, 500);
            }
            //up.location.href = billdata[0].sDetailPage + "?usetype=modify&key=" + messdata[0].iBillRecNo + "&iformid=" + iformid + "&random=" + Math.random() + "&from=proc&ProcGUID=" + messdata[0].sProGUID;
            //down.location.href = "ApprovalPage.aspx?irecno=" + messrecno + "&key=" + messdata[0].iBillRecNo + "&iformid=" + iformid + "&random=" + Math.random();
            if (getQueryString("from") == "center") {
                document.getElementById("Button3").style.display = "none";
            }
            //            if (getQueryString("itype") == "checked") {
            //                document.getElementById("Button4").style.display = "block";
            //                document.getElementById("Button1").style.display = "none";
            //                document.getElementById("Button2").style.display = "none";
            //                document.getElementById("Button3").style.display = "none";

            //            }
            if (sCheckType == "会签") {
                $("#div1").show();
                //$("#Button1").val("提交意见");
                $("#Button1").linkbutton({ text: "提交意见" });
                //$("#tdAgree").hide();
                //$("#tdBack").hide();
                $("#tdCancelCheck").hide();
                $("#tdStop").hide();
                $("#tdDisagree").hide();
                //$("#tdExit").hide();
            }
            if (itype == "1") {
                //$("#Button1").val("提交");
                $("#Button1").linkbutton({ text: "提交" });
                //$("#tdAgree").hide();
                $("#tdBack").hide();
                $("#tdCancelCheck").hide();
                //$("#tdStop").hide();
                $("#tdDisagree").hide();
                //$("#tdExit").hide();
            }
            else if (itype == "3") {
                $("#tdAgree").hide();
                $("#tdBack").hide();
                //$("#tdCancelCheck").hide();
                //$("#Button4").val("同意申请");
                $("#Button4").linkbutton({ text: "同意申请" });
                $("#tdStop").hide();
                //$("#tdDisagree").hide();
                //$("#tdExit").hide();
                $("#tdAskReason").show();
            }
            else {
                //$("#tdAgree").hide();
                //$("#tdBack").hide();
                $("#tdCancelCheck").hide();
                //$("#tdStop").hide();
                $("#tdDisagree").hide();
                //$("#tdExit").hide();
            }
            setTimeout(function () { $("#panel").layout("resize"); }, 800);
        }
        function getChildNodes(obj) {
            var childnodes = new Array();
            var childS = obj.childNodes;
            for (var i = 0; i < childS.length; i++) {
                if (childS[i].nodeType == 1)
                    childnodes.push(childS[i]);
            }
            return childnodes;
        }
        function checkcancel() {
            if (confirm("确认撤销审批？") == true) {
                var messirecno = getQueryString("irecno");
                var result = approval.checkCancelFromFirst(messirecno, document.getElementById("TextArea1").value);
                if (result == true) {
                    parent.loaddatatodo();
                    parent.checkWinClose();
                }
                else {
                    return false;
                }
            }
        }
        function abandon() {
            if (confirm("确认中止吗？")) {
                var messirecno = getQueryString("irecno");
                var result = approval.abandon(messirecno, document.getElementById("TextArea1").value);
                if (result == true) {
                    parent.loaddatatodo();
                    parent.checkWinClose();
                }
            }
        }
        function disagree() {
            if (confirm("确认不同意吗？") == true) {
                var messirecno = getQueryString("irecno");
                var result = approval.checkCancelAskDisagree(messirecno, document.getElementById("TextArea1").value);
                if (result == true) {
                    parent.loaddatatodo();
                    parent.checkWinClose();
                }
                else {
                    return false;
                }
            }
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
    </script>
</head>
<body id="panel" class="easyui-layout" data-options="border:false" onload="pageInit()">
    <form id="form1" runat="server">
    <div data-options="region:'center',split:true,border:false">
        <iframe id="ifrUp" name="ifrUp" frameborder="0" scrolling="auto" style="overflow: scroll;"
            width="100%" height="99%"></iframe>
    </div>
    <div data-options="region:'south',split:true,border:false" style="height: 120px">
        <table>
            <tr>
                <td>
                    <div id="div1" style="display: none;">
                        会签结论：<select id="Select1">
                            <option value="同意">同意</option>
                            <option value="不同意">不同意</option>
                        </select>
                    </div>
                    <textarea id="TextArea1"></textarea>
                </td>
                <td valign="top">
                    <table class="tabBtn">
                        <tr>
                            <td id="tdAgree">
                                <%--<input id="Button1" type="button" value="同意" class="btn26" onclick="agree(this)"
                                    onmouseover="this.style.backgroundPosition='left -36px'" onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button1" class="easyui-linkbutton c7" data-options="iconCls:'icon-ok'" onclick="agree(this)"
                                    style="width: 80px; height: 30px;">同意</a>
                            </td>
                            <td id="tdBack">
                                <%--<input id="Button2" type="button" value="退回" class="btn26" onclick="returnback()"
                                    onmouseover="this.style.backgroundPosition='left -36px'" onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button2" class="easyui-linkbutton c7" data-options="iconCls:'icon-back'" onclick="returnback()"
                                    style="width: 80px; height: 30px;">退回</a>
                            </td>
                            <td id="tdCancelCheck">
                                <%--<input id="Button4" type="button" value="撤销审批" class="btn26" onclick="checkcancel()"
                                    onmouseover="this.style.backgroundPosition='left -36px'" onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button4" class="easyui-linkbutton c7" data-options="iconCls:'icon-checkcancel'"
                                    onclick="checkcancel()" style="width: 80px; height: 30px;">撤销审批</a>
                            </td>
                            <td id="tdStop">
                                <%--<input id="Button5" type="button" value="中止" class="btn26" onclick="abandon()" onmouseover="this.style.backgroundPosition='left -36px'"
                                    onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button5" class="easyui-linkbutton c7" data-options="iconCls:'icon-stop'" onclick="abandon()"
                                    style="width: 80px; height: 30px;">中止</a>
                            </td>
                            <td id="tdDisagree">
                                <%--<input id="Button6" type="button" value="不同意" class="btn26" onclick="disagree()"
                                    onmouseover="this.style.backgroundPosition='left -36px'" onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button6" class="easyui-linkbutton c7" data-options="iconCls:'icon-forbidden'"
                                    onclick="disagree()" style="width: 80px; height: 30px;">不同意</a>
                            </td>
                            <td id="td1">
                                <%--<a href="javascript:void(0)" onclick="$('#divOp').window('open');" style=" text-decoration:none; color:Blue;">已审意见</a>--%>
                                <%--<input id="Button7" type="button" value="已审意见" class="btn26" onclick="$('#divOp').window('open');"
                                    onmouseover="this.style.backgroundPosition='left -36px'" onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button7" class="easyui-linkbutton c7" data-options="iconCls:'icon-job'" onclick="$('#divOp').window('open');"
                                    style="width: 80px; height: 30px;">已审意见</a>
                            </td>
                            <td id="tdExit">
                                <%--<input id="Button3" type="button" value="退出" class="btn26" onclick="exit()" onmouseover="this.style.backgroundPosition='left -36px'"
                                    onmouseout="this.style.backgroundPosition='left top'" />--%>
                                <a id="Button3" class="easyui-linkbutton c7" data-options="iconCls:'icon-logout'" onclick="exit()"
                                    style="width: 80px; height: 30px;">退出</a>
                            </td>
                        </tr>
                        <tr>
                            <td id="tdOp" style="height: 30px; padding-left: 10px;">
                                <a href="javascript:void(0)" onclick="$('#divOp').window('open');" style="text-decoration: none;
                                    color: Blue;">已审意见</a>
                                <%--<input id="Button7" type="button" value="已审意见" class="btn" onclick="$('#divOp').window('open');" />--%>
                            </td>
                        </tr>
                    </table>
                </td>
                <td id="tdAskReason" style="vertical-align: top; display: none;">
                    <table>
                        <tr>
                            <td>
                                申请撤销审批原因:
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txbReason" runat="server" Height="45px" TextMode="MultiLine" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div id="divPushConfirm" style="display: none;">
        </div>
    </div>
    <div id="divOp" class="easyui-window" data-options="width:500,height:600,closed:true,title:'已审意见',minimizable:false,collapsible:false,resizable:true">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="grid"
            DataKeyNames="iRecNo" Width="100%" ShowHeader="False">
            <Columns>
                <asp:TemplateField HeaderText="处理人" SortExpression="sName" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("sName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="100px" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="处理意见" SortExpression="sCheckIdeal1">
                    <ItemTemplate>
                        <table style="width: 99%;">
                            <tr>
                                <td style="height: 50px; border: none; font-weight: bold;">
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("messtype") %>'></asp:Label>
                                    <br />
                                    <br />
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("sCheckIdeal") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 20px; border: none; text-align: right;">
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("dDealDate1") %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div>
                    暂无...
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
    </form>
</body>
</html>
