//如果isNotCheckMessage=true,则不需要定时检测待办事项
var isNotCheckMessage = false;

var menuFirst = []; //存放一级菜单
var menuSecond = [];  //存放二级菜单
var menuThird = [];  //存放三级菜单

var __todoList = []; //待办事项
var __noticeList = []; //公告信息

$(function () {

    //通知公告滚动
    Marquee_notice();

    //导航栏下拉位置
    $(".main_nav li").each(function () {
        var li_W = $(this).width();
        $(this).find("b").css("left", (li_W - 16) / 2 + "px");
        $(this).find("s").css("left", (li_W - 12) / 2 + "px");
    })

    //检测是否开启不检测新消息
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: false,
        cache: false,
        data: { Command: "getIsNotCheckMessage" },
        success: function (data) {
            if (data.success == true) {
                if (data.message == "1") {
                    isNotCheckMessage = true;
                }
            }
        },
        dataType: "json"
    });
    //获取首页流程图
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: true,
        cache: false,
        data: { Command: "getFirstFlow" },
        success: function (data) {
            if (data.success == true) {
                graphLoad(document.getElementById("divFlow"), data.message);
            }
            else {

            }
        },
        error: function (data) {
            var aa = "11";
        },
        dataType: "json"
    });
})

function getFirstFlowXml() {
    var xmlStr="";
    //获取首页流程图
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: false,
        cache: false,
        data: { Command: "getFirstFlow" },
        success: function (data) {
            if (data.success == true) {
                xmlStr = data.message;
            }
            else {

            }
        },
        error: function (data) {
            var aa = "11";
        },
        dataType: "json"
    });
    return xmlStr;
}

function Marquee_notice() {
    var speed = 80;
    var tab = $(".notice_item");
    // console.log(tab);
    var tab1 = $(".notice1");
    var tab2 = $(".notice2");
    var notice_item_H = tab.height();
    var notice_H = tab1.height();
    //console.log(notice_item_H,notice_H);
    if (notice_H > notice_item_H) {
        tab2.html(tab1.html());
        function Marquee() {
            //console.log(tab2.height(), tab.scrollTop());
            if (tab2.height() - tab.scrollTop() <= 0) {
                tab.scrollTop(0);
            } else {
                var tabScrollTop = tab.scrollTop();
                tabScrollTop++;
                tab.scrollTop(tabScrollTop);
            }
        }
        var MyMar = setInterval(Marquee, speed);
        //tab.onmouseover = function () { clearInterval(MyMar) };
        //tab.onmouseout = function () { MyMar = setInterval(Marquee, speed) };
        tab.hover(function () {
            clearInterval(MyMar);
        }, function () {
            MyMar = setInterval(Marquee, speed)
        })
    }
}

/*获取一级菜单
返回数组
[{"iMenuID":2,"sMenuName":"系统平台","iParentMenuId":1,
"sFilePath":"/Base/SysConfig/SystemPlatForm.aspx","iSerial":0,
"sUserID":"master","dinputDate":"2014-07-28T00:00:00",
"iFormID":1001,"sOpenSql":null,"iHidden":null,
"sIcon":null,"iQueryFirst":null,"sParms":null,"sFileName":null,
"sAppStyle":null}]
*/
function GetMainMenu(isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    var returnData;
    $.ajax({
        url: "/MainPage.request",
        type: "post",
        async: isAsync,
        cache: false,
        data: { Command: "getMainMenu", parentMenuID: "0" },
        success: function (data) {
            if (isAsync == true) {
                fun(data);
            }
            else {
                returnData=data;
                //return data;
            }
        },
        error: function (data) {

        },
        dataType: "json"
    });
    return returnData;
}
/*获取二三级菜单
返回json,ds是二级菜单，ds1是三级菜单
{"ds":[{"iMenuID":96,"sMenuName":"客户订单",
"iParentMenuId":95,"sFilePath":"/Base/FormList.aspx",
"iSerial":0,"sUserID":null,"dinputDate":null,"iFormID":2002,
"sOpenSql":"iOrderType=0","iHidden":0,"sIcon":"icon-order","iQueryFirst":0,"sParms":"&amp;iColorOnly='1'&amp;iOrderType='0'","sFileName":null,
"sAppStyle":"表格"}],
"ds1":[{}]}
*/
function GetSubMenu(parentID, isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    var resultData;
    $.ajax({
        url: "/MainPage.request",
        type: "post",
        async: isAsync,
        cache: false,
        data: { Command: "getSubMenu", parentMenuID: parentID },
        success: function (data) {
            if (isAsync == true) {
                fun(data);
            }
            else {
                resultData = data;
                //return data;
            }
        },
        error: function (data) {

        },
        dataType: "json"
    });
    return resultData;
}
/*{菜单点击
text:"",//sMenuName
sFilePath:"",//sFilePath
iconCls:"",//sIcon
sParms:"",//sParms
id:"",//iMenuID
iFormID:""//iFormID
}*/
function MenuClick(node, isCommon) {
    if (!$("#tt").tabs("exists", node.text)) {
        if (node.attributes.sFilePath != "") {
            var icon = node.iconCls == undefined || node.iconCls == "" || node.iconCls == null ? "icon-job" : node.iconCls;
            var sparms = node.attributes.sParms ? node.attributes.sParms.replace(/&amp;/g, "&").replace(/'/g, "") : "";
            var src = node.attributes.sFilePath ? node.attributes.sFilePath + "?MenuTitle=" + escape(node.text) + "&MenuID=" + node.id + "&FormID=" + node.attributes.iFormID + sparms : "";
            $("#tt").tabs("add", {
                title: node.text,
                //href: node.attributes.sFilePath + "&MenuID="+node.id+"&FormID=" + node.attributes.iFormID+node.attributes.sParms,
                closable: true,
                iconCls: icon,
                content: "<iframe width='100%' height='100%' frameborder='0'  src='" + src + "' style='width:100%;height:100%;'></iframe>"
            })
        }
        if (isCommon != true) {
            if (node.state) {
                if (node.state == "closed") {
                    $(this).tree("expand", node.target);
                }
                else {
                    $(this).tree("collapse", node.target);
                }
            }
        }
    }
    else {
        $("#tt").tabs("select", node.text);
    }
}

//获取待办事项数据结构
/*
{
    iRecNo:0,
    iFormid:0,
    sSendUserID,
    sReceiveUserid,
    sContent:"",
    dinputDate,
    sDetailPage,
    itype
}
*/
function GetTodo(isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    //加载消息
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: isAsync,
        cache: false,
        data: { Command: "getCheckedMessage" },
        success: function (sqlcheckdata) {
            for (var i = 0; i < sqlcheckdata.length; i++) {
                RemindTip(0, sqlcheckdata[i].sContent);
                var iRecNo = sqlcheckdata[i].iRecNo;
                $.ajax({
                    url: "/MainPage.request",
                    type: "get",
                    async: true,
                    cache: false,
                    data: { Command: "getCheckedMessage", oprate: "1", iRecNo: iRecNo }
                })
            }
        },
        dataType: "json"
    })

    $.ajax(
        {
            url: "/MainPage.request",
            type: "get",
            async: isAsync,
            cache: false,
            data: { Command: "getTodo" },
            success: function (data) {
                if (isAsync == true) {
                    fun(data);
                }
                else {
                    return data;
                }
            },
            dataType: "json"
        }
    )
}
//打开待办事项界面
function OpenCheckPage(irecno, iformid, tid) {
    $("#divWin").show();
    $("#divWin").window({
        maximized: true,
        title: '单据审批',
        height: 610,
        width: 1000,
        content: "<iframe width='100%' height='100%' frameborder='0' src='/Base/ApprovalPage.aspx?iformid=" + iformid + "&irecno=" + irecno + "'></iframe>",
        modal: true,
        collapsible: false,
        minimizable: false
    });
}
//获取公告
/*
{iRecNo,sTitle,iSerial,dInputDate}
*/
function GetNotice(isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: isAsync,
        cache: false,
        data: { Command: "getNotice" },
        success: function (noticeData) {
            if (isAsync == true) {
                fun(noticeData);
            }
            else {
                return noticeData;
            }
        },
        dataType: "json"
    });
}
//公告点击打开
function openNoticeDetail(iRecNo, title) {
    var result = callpostback("/Base/Handler/PublicHandler.ashx", "otype=getTheNotice&iRecNo=" + iRecNo, false, true);
    if (result.indexOf("error:") > -1) {
        $.messager.alert("错误", result.substr(6, result.length - 6));
        return;
    }
    else {
        var height = window.screen.availHeight - 30 - 100 - 50;
        $("#divNoticeDetail").show();
        $("#divNoticeDetail").window({
            title: "公告：" + title,
            collapsible: false,
            minimizable: false,
            maximizable: false,
            closable: true,
            modal: false,
            content: result,
            cache: false,
            inline: false,
            width: '60%',
            //top:50,
            height: height
        });
    }
}

function RemindTip(newCount, message) {
    if (message == undefined) {
        $.messager.show({
            title: '小助手',
            msg: '您有' + newCount + '条新任务。',
            timeout: 0,
            showType: 'slide'
        });
    }
    else {
        $.messager.show({
            title: '小助手',
            msg: message,
            timeout: 0,
            showType: 'slide'
        });
    }
    $(".panel-tool-close").attr("href", "#");
    PlayVoice("/sound/newMessage.mp3");
}

var __remindList = [];
//获取提醒事项
/*
{sTitle:,iMenuID:,sMenuName:,iFormID:,sFilePath:,sFilters:}
*/
function GetRemind(isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: isAsync,
        cache: false,
        data: { Command: "getWarningList" },
        success: function (returnObj) {
            if (returnObj.success == true) {
                var objList = JSON2.parse(returnObj.message);
                if (isAsync == true) {
                    fun(returnObj);
                }
                else {
                    __remindList = objList;
                    return objList;
                }
            }
            else {
                //$.messager.alert("出错", returnObj.message);
            }
            //setTimeout("loadRemind()", 20000);
        },
        error: function (data) {

        },
        dataType: "json"
    });
}
//提醒事项点击
function remindClick(i) {
    turntoTab(__remindList[i].iMenuID, __remindList[i].iFormID, __remindList[i].sMenuName, __remindList[i].sFilters, __remindList[i].sFilePath);
}
//获取用户日常工作
function GetUserCommWork(isAsync, fun) {
    isAsync = isAsync != true ? false : true;
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: isAsync,
        cache: false,
        data: { Command: "getUserCommonMenu" },
        success: function (noticeData) {
            if (isAsync == true) {
                fun(noticeData);
            }
            else {
                return noticeData;
            }
        },
        dataType: "json"
    });
}

function closeTab() {
    var tab = $('#tab').tabs('getSelected');
    $("#tab").tabs("close", $("#tab").tabs('getTabIndex', tab));

}

function turntoTab(id, formid, name, parmvalue, filepath, icon) {
    var iconCls = icon == "" ? "icon-job" : icon;
    if ($("#tt").tabs("exists", name)) {
        $("#tt").tabs("close", name);
    }
    if (filepath != "") {
        filepath = filepath.replace(/'/g, "");
        var evalue = getEnCodeStr(parmvalue);
        //var src = filepath + "MenuTitle=" + escape(node.text) + "&MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue;
        var src = filepath + "MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue + "&isAss=1";
        $("#tt").tabs("add", {
            title: name,
            //href: node.attributes.sFilePath + "&MenuID="+node.id+"&FormID=" + node.attributes.iFormID+node.attributes.sParms,
            closable: true,
            iconCls: iconCls,
            content: "<iframe width='100%' height='100%' frameborder='0'  src='" + src + "' style='width:100%;height:100%;'></iframe>"
        })
    }
}
function getEnCodeStr(str) {
    str = str.replace(/\+/g, "%2B").replace(/\//g, "%2F").replace(/\?/g, "%3F").replace(/%/g, "%25").replace(/#/g, "%23").replace(/&/g, "%26").replace(/=/g, "%3D").replace(/\'/g, "%27");
    return str;
}
function getCurtUserName() {
    var url = "ashx/LoginHandler.ashx?otype=getcurtusername";
    var parms = "";
    var async = false;
    var ispost = false;
    var result = callpostback(url, parms, async, ispost);
    //alert(result);
    return result;
}
function loginout() {
    if (confirm("确认注销？")) {
        isLoginOut = true;
        var url = "Login.request";
        var parms = "otype=loginOut";
        var async = false;
        var ispost = false;
        var result = callpostback(url, parms, async, ispost);
        window.location.href = "loginV.htm";
    }
}

function tabChange(title, index) {
    if (index == 1) {
        $.ajax({
            url: "/Base/Handler/PublicHandler.ashx",
            type: "post",
            async: true,
            cache: false,
            data: { otype: "getChart", pid: "divChart" },
            success: function (resultObj) {
                if (resultObj.success == true) {
                    eval(resultObj.result);
                }
                else {
                    $.messager.alert("错误", resultObj.message);
                }
            },
            dataType: "json"
        });
    }
}

FusionCharts.ready(function () {
    
})