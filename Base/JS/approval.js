var approval = {
    submit: function (iformid, key) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=isNeedPushWhenSubmit&iformid=" + iformid + "&key=" + key + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success && result.success == true) {
                var type = result.message[0];
                if (type != "2") {
                    var isPush = type == "1" ? "1" : "0";
                    var pushGUID = type == "1" ? result.message.substr(2, result.message.length - 2) : "";
                    var doSubmit = function (iformid, key, isPush, pushGUID, url) {
                        var parms = "otype=submit&iformid=" + iformid + "&key=" + key + "&isPush=" + isPush + "&pushGUID=" + pushGUID + "&random=" + Math.random();
                        var resultDo = JSON2.parse(callpostback(url, parms, false, true));
                        if (resultDo) {
                            if (resultDo.success == true) {
                                if (resultDo.result && resultDo.result != "") {
                                    approval.check(resultDo.result);
                                }
                                return true;
                            }
                            else {
                                alert(resultDo.message);
                                return false;
                            }
                        }
                        else {
                            return false;
                        }
                    }
                    if (isPush == "1") {
                        if (typeof (FormList) != "undefined") {
                            //$("#divPushConfirm").show();
                            $("#divPushConfirm").dialog({
                                title: '确认推送吗？',
                                width: 250,
                                height: 130,
                                closed: false,
                                cache: false,
                                content: "<span style='font-size:14px; font-weight:bold;'>" + result.result + "</span>",
                                modal: true,
                                buttons: [
                                {
                                    text: '推送',
                                    handler: function () {
                                        $("#divPushConfirm").dialog("close");
                                        $.messager.progress({ title: "正在处理，请稍候..." });
                                        var success = doSubmit(iformid, key, isPush, pushGUID, url);
                                        $.messager.progress("close");
                                        return success;
                                    }
                                },
                                {
                                    text: '不推送',
                                    handler: function () {
                                        $("#divPushConfirm").dialog("close");
                                        $.messager.progress({ title: "正在处理，请稍候..." });
                                        var success = doSubmit(iformid, key, "0", pushGUID, url);
                                        $.messager.progress("close");
                                        return success;
                                    }
                                },
                                {
                                    text: '取消',
                                    handler: function () {
                                        $("#divPushConfirm").dialog("close");
                                    }
                                }
                                ]
                            });
                        }
                        else {
                            $.ligerDialog.confirm(result.result, function (yes) {
                                if (yes == true) {
                                    if (doSubmit(iformid, key, isPush, pushGUID, url) == true) {
                                        alert("提交成功");
                                        GridRefresh();
                                    }
                                }
                                else if (yes == false) {
                                    if (doSubmit(iformid, key, "0", pushGUID, url) == true) {
                                        alert("提交成功");
                                        GridRefresh();
                                    }
                                }
                            });
                        }
                    }
                    else {
                        return doSubmit(iformid, key, isPush, pushGUID, url);
                    }
                }
                else {
                    $.messager.alert("错误", result.message.substr(2, result.message.length - 2));
                    return false;
                }
            }
            else {
                $.messager.alert(result.message);
                return false;
            }
        }
        else {
            $.messager.alert("连接服务器时发生错误！");
            return false;
        }

    },
    check: function (iRecNo, message, backFun) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=isNeedPush&iRecNo=" + iRecNo + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success && result.success == true) {
                if (result.message && result.message != "") {
                    if (isJsInclude("jquery.easyui.min.js")) {
                        $("#divPushConfirm").show();
                        $("#divPushConfirm").dialog({
                            title: '确认推送吗？',
                            width: 250,
                            height: 130,
                            closed: false,
                            cache: false,
                            content: "<span style='font-size:14px; font-weight:bold;'>" + result.message + "</span>",
                            modal: true,
                            buttons: [
                            {
                                text: '推送',
                                handler: function () {
                                    $("#divPushConfirm").dialog("close");
                                    $.messager.progress({ title: "正在处理，请稍候..." });
                                    var checkRusult = approval.checkFunction(true, iRecNo, message, backFun);
                                    $.messager.progress("close");
                                    //return checkRusult;
                                    if (backFun) {
                                        backFun(checkRusult);
                                    }
                                }
                            },
                            {
                                text: '不推送',
                                handler: function () {
                                    $("#divPushConfirm").dialog("close");
                                    $.messager.progress({ title: "正在处理，请稍候..." });
                                    var checkRusult = approval.checkFunction(false, iRecNo, message, backFun);
                                    $.messager.progress("close");
                                    if (backFun) {
                                        backFun(checkRusult);
                                    }
                                }
                            },
                            {
                                text: '取消',
                                handler: function () {
                                    $("#divPushConfirm").dialog("close");
                                    //return -1;
                                }
                            }
                        ]
                        });
                    }
                    else {
                        $.ligerDialog.confirm(result.message, function (yes) {
                            if (yes == true) {
                                //$("#divPushConfirm").dialog("close");
                                //$.messager.progress({ title: "正在处理，请稍候..." });
                                var checkRusult = approval.checkFunction(true, iRecNo, message, backFun);
                                //$.messager.progress("close");
                                //return checkRusult;
                                if (backFun) {
                                    backFun(checkRusult);
                                }
                            }
                            else if (yes == false) {
                                //$("#divPushConfirm").dialog("close");
                                //$.messager.progress({ title: "正在处理，请稍候..." });
                                var checkRusult = approval.checkFunction(false, iRecNo, message, backFun);
                                //$.messager.progress("close");
                                if (backFun) {
                                    backFun(checkRusult);
                                }
                            }
                        });
                    }
                }
                else {
                    try {
                        $.messager.progress({ title: "正在处理，请稍候..." });
                    }
                    catch (e) {

                    }
                    var checkRusult = approval.checkFunction(false, iRecNo, message, backFun);
                    try {
                        $.messager.progress("close");
                    }
                    catch (e) {

                    }
                    //return checkRusult;
                    if (backFun) {
                        backFun(checkRusult);
                    }
                }
            }
            else {
                alert(result.message);
                return false;
            }
        }
        else {
            alert("未知错误");
            return false;
        }
    },
    checkFunction: function (needPush, iRecNo, message, backFun) {
        var isNeedPush = needPush == true ? "true" : "false";
        var url = "/Base/Handler/approvalHandler.ashx";
        parms = "otype=check&iRecNo=" + iRecNo + "&message=" + message + "&needPush=" + isNeedPush + "&random=" + Math.random();
        var checkResult = JSON2.parse(callpostback(url, parms, false, true));
        if (checkResult) {
            if (checkResult.success && checkResult.success == true) {
                if (checkResult.result && checkResult.result != "") {
                    approval.check(checkResult.result, "", backFun);
                }
                else {
                    return true;
                }
            }
            else {
                $.messager.alert("错误", checkResult.message, "error");
                return false;
            }
        }
        else {
            alert("未知错误");
            return false;
        }
    },
    back: function (iRecNo, message) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=back&iRecNo=" + iRecNo + "&message=" + message + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success == true) {
                return true;
            }
            else {
                alert(result.message);
                return false;
            }
        }
        else {
            return false;
        }
    },
    submitCancel: function (iformid, key) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=cancelSubmit&iformid=" + iformid + "&key=" + key + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success == true) {
                return true;
            }
            else {
                alert(result.message);
                return false;
            }
        }
        else {
            return false;
        }
    },
    checkCancel: function (iRecNo, message) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=cancelCheck&iRecNo=" + iRecNo + "&message=" + message + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success == true) {
                return true;
            }
            else {
                alert(result.message);
                return false;
            }
        }
        else {
            return false;
        }
    },
    //撤销审批新
    checkCancel1: function (iformid, key) {
        var result = false;
        $.ajax({
            url: "/Base/Handler/approvalHandler.ashx",
            async: false,
            cache: false,
            type: "post",
            data: { otype: "cancelCheck1", iformid: iformid, key: key },
            success: function (data) {
                var resultObj = JSON2.parse(data);
                if (resultObj.success == true) {
                    result = true;
                }
                else {
                    $.messager.alert("错误", resultObj.message);
                    result = false;
                }
            },
            error: function (data) {
                $.messager.alert("错误", "发生未知错误！");
                result = false;
            }
        });
        return result;
    },
    formStatus: function (iformid, key) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=formStatus&iformid=" + iformid + "&key=" + key + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success == true) {
                var status = {};
                if (result.message == "-1") {
                    status.iStatus = "99";
                    status.sStatusName = "未走流程";
                }
                else {
                    status.iStatus = result.result.split(',')[0];
                    status.sStatusName = result.result.split(',')[1];
                }
                return status;
            }
            else {
                alert(result.message);
                return undefined;
            }
        }
        else {
            return undefined;
        }
    },
    abandon: function (iRecNo, message) {
        var url = "/Base/Handler/approvalHandler.ashx";
        var parms = "otype=abandon&iRecNo=" + iRecNo + "&message=" + message + "&random=" + Math.random();
        var result = JSON2.parse(callpostback(url, parms, false, true));
        if (result) {
            if (result.success == true) {
                return true;
            }
            else {
                alert(result.message);
                return false;
            }
        }
        else {
            return false;
        }
    },
    checkCancelAsk: function (iformid, key, message) {
        var result = undefined;
        var url = "/Base/Handler/approvalHandler.ashx";
        //var parms = "otype=checkCancelAsk&iRecNo=" + iRecNo + "&iformid=" + iformid + "&random=" + Math.random();
        $.ajax(
            {
                url: url,
                type: "post",
                async: false,
                cache: false,
                data: { otype: "checkCancelAsk", key: key, iformid: iformid, message: message },
                success: function (data) {
                    var resultObj = JSON2.parse(data);
                    if (resultObj.success == true) {
                        result = true;
                    }
                    else {
                        $.messager.alert("失败", resultObj.message);
                        result = false;
                    }
                },
                error: function (data) {
                    $.messager.alert("失败", data.responseText);
                    result = false;
                }
            }
        )
        return result;
    },
    //撤销审批首页
    checkCancelFromFirst: function (iRecNo, message) {
        var result = undefined;
        var url = "/Base/Handler/approvalHandler.ashx";
        //var parms = "otype=checkCancelFromFirst&iRecNo=" + iRecNo + "&iformid=" + iformid + "&random=" + Math.random();
        $.ajax(
            {
                url: url,
                type: "post",
                async: false,
                cache: false,
                data: { otype: "checkCancelFromFirst", iRecNo: iRecNo, message: message },
                success: function (data) {
                    var resultObj = JSON2.parse(data);
                    if (resultObj.success == true) {
                        result = true;
                    }
                    else {
                        $.messager.alert("失败", resultObj.message);
                        result = false;
                    }
                },
                error: function (data) {
                    $.messager.alert("失败", data.responseText);
                    result = false;
                }
            }
        )
        return result;
    },
    //撤销审批不同意首页
    checkCancelAskDisagree: function (iRecNo, message) {
        var result = undefined;
        var url = "/Base/Handler/approvalHandler.ashx";
        //var parms = "otype=checkCancelFromFirst&iRecNo=" + iRecNo + "&iformid=" + iformid + "&random=" + Math.random();
        $.ajax(
            {
                url: url,
                type: "post",
                async: false,
                cache: false,
                data: { otype: "checkCancelAskDisagree", iRecNo: iRecNo, message: message },
                success: function (data) {
                    var resultObj = JSON2.parse(data);
                    if (resultObj.success == true) {
                        result = true;
                    }
                    else {
                        $.messager.alert("失败", resultObj.message);
                        result = false;
                    }
                },
                error: function (data) {
                    $.messager.alert("失败", data.responseText);
                    result = false;
                }
            }
        )
        return result;
    }
}
function callpostback(url, parms, async, ispost, functionname) {
    var xmlhttp;
    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    if (async) {
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                functionname(xmlhttp.responseText);
            }
        }
        xmlhttp.open("post", url, async);
        if (ispost) {
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        }
        xmlhttp.send(parms);
    }
    else {
        xmlhttp.open("post", url, async);
        if (ispost) {
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        }
        xmlhttp.send(parms);
        var result = xmlhttp.status;
        if (result == 200) {
            return xmlhttp.responseText;
        }
    }
}

function isJsInclude(name) {
    var js = /js$/i.test(name);
    var es = document.getElementsByTagName(js ? 'script' : 'link');
    for (var i = 0; i < es.length; i++)
        if (es[i][js ? 'src' : 'href'].indexOf(name) != -1) return true;
    return false;
}