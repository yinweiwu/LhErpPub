//如果isNotCheckMessage=true,则不需要定时检测待办事项
var isNotCheckMessage = false;

var menuFirst = []; //存放一级菜单
var menuSecond = [];  //存放二级菜单
var menuThird = [];  //存放三级菜单

var __todoList = []; //待办事项
var __noticeList = []; //公告信息

var userid = "";

//获取数据库服务器时间
var severtime = null, year = null, month = null, date = null, hour = null, minu = null, seco = null, week = null, tUpdateCurrentTime=null;

$(function () {
    $("#userName").html(getCurtUserName());

    //获取服务器时间
    getServerTime();
    //定时矫正一次时间
    window.setInterval(getServerTime, 60000);
    
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
        }
    });
    $.ajax({
        url: "/ashx/LoginHandler.ashx",
        type: "get",
        async: false,
        cache: false,
        data: { otype: "getcurtuserid" },
        success: function (data) {
            userid = data;
        },
        dataType: "json"
    });


    //获取菜单
    GetMainMenu(true, function (data) {
        //console.log(data);

        //添加一级菜单
        for (var i = 0; i < data.length; i++) {
            //console.log(data[i].sMenuName);
            var main_nav_li = '<li><a class="main_nav_tit" href="javascript:;">' + data[i].sMenuName + '</a><b></b></li>';
            $(".main_nav").append(main_nav_li);
            menuFirst.push(data[i]);
        }

        //导航栏变动
        var mainLogo_W = $(".main_logo").width();
        //var logoImg_W = $(".main_logo_img").width();  //图片宽度有时获取为0，暂定位267；
        var mainR_W = $(".main_logo_r").width();

        var mainL_W = $(".main_logo").width() - $(".main_logo_r").width() - 60 - 216;
        $(".main_logo_l").css("width", mainL_W + "px");
        $(".main_nav").css("width", mainL_W + "px");

        var lis_W = 0;
        $(".main_nav li").each(function () {
            lis_W += $(this).width();
        })
        if (lis_W >= mainL_W) {
            //$(".main_logo img").css({ "height": "40px", "margin-top": "6px" });
            //$(".main_work li a").css("font-size", "14px");
            //mainL_W = $(".main_logo").width() - $(".main_logo_r").width() - 60 - 216;
            $(".main_logo_l").css("width", mainL_W + "px");
            $(".main_nav").css("width", mainL_W + "px");
            var lis = $(".main_nav li")
            var main_nav_tit_W = mainL_W / ($(".main_nav li").length);
            $(".main_nav li a.main_nav_tit").css({ "font-size": "14px", "padding": "0", "width": main_nav_tit_W + "px" })
        }

        //$(".main_left_item h3.left_item_tit").css("width", $(".left_item_content").width());

        //公告图片
        var noticeImgUrl = "images/001.jpg";
        $(".notice_content").find("img").attr("src", noticeImgUrl);


        //获取二级菜单
        $(".main_nav li a.main_nav_tit").mouseover(function () {
            var li_index = $(this).parent().index();
            var me = $(this).parent();
            //添加二级菜单
            var findSecond = false;
            var firstId = menuFirst[li_index].iMenuID;
            for (var i = 0; i < menuSecond.length; i++) {
                if (menuSecond[i].iParentMenuId == firstId) {
                    findSecond = true;
                    break;
                }
            }
            if (findSecond == false) {
                GetSubMenu(data[li_index].iMenuID, true, function (data2) {
                    //console.log(data2);
                    me.find("div.main_nav_item").remove();
                    me.find("s").remove();
                    me.append('<div class="main_nav_item"></div><s></s>');
                    for (var i = 0; i < data2.ds.length; i++) {
                        var _icon = data2.ds[i].sIcon == undefined || data2.ds[i].sIcon == "" || data2.ds[i].sIcon == null ? "" : data2.ds[i].sIcon;
                        if (data2.ds[i].iComm == 1) {
                            if (data2.ds[i].iParentMenuId == 0) {
                                var main_nav_item_dl = '<dl data-id="' + data2.ds[i].iMenuID + '"><dt><span><a class="' + _icon + '" href="javascript:;">' + data2.ds[i].sMenuName + '</a></span></dt><dd></dd></dl>';
                                me.find(".main_nav_item").append(main_nav_item_dl);
                                menuSecond.push(data2.ds[i]);
                            } else {
                                var main_nav_item_dd = "<span class='" + _icon + "'><a href='javascript:;' onclick='menuThirdClick(" + data2.ds[i].iMenuID + ")'>" + data2.ds[i].sMenuName + "</a></span>";
                                me.find(".main_nav_item").find("dl[data-id='" + data2.ds[i].iParentMenuId + "'] dd").append(main_nav_item_dd);
                            }
                        } else {
                            var main_nav_item_dl = '<dl data-getThird="1" data-id="' + data2.ds[i].iMenuID + '"><dt><span><a class="' + _icon + '" href="javascript:;">' + data2.ds[i].sMenuName + '</a></span></dt><dd></dd></dl>';
                            me.find(".main_nav_item").append(main_nav_item_dl);
                            menuSecond.push(data2.ds[i]);
                        }
                    }
                    me.find(".main_nav_item dl[data-getThird='1']").each(function () {
                        //var dl_index = $(this).index();
                        //var menuThree = GetSubMenu(data2.ds[dl_index].iMenuID);
                        var menuThree = GetSubMenu($(this).attr("data-id"));
                        //console.log(menuThree);
                        for (var k = 0; k < menuThree.ds.length; k++) {
                            menuThird.push(menuThree.ds[k]);
                            var _icon = menuThree.ds[k].sIcon == undefined || menuThree.ds[k].sIcon == "" || menuThree.ds[k].sIcon == null ? "" : menuThree.ds[k].sIcon;
                            var main_nav_item_dd = "<span class='" + _icon + "'><a href='javascript:;' onclick='menuThirdClick(" + menuThree.ds[k].iMenuID + ")'>" + menuThree.ds[k].sMenuName + "</a></span>";
                            $(this).find("dd").append(main_nav_item_dd);

                        }
                    })



                    //导航栏下拉位置
                    $(".main_nav li").each(function () {
                        var li_W = $(this).width();
                        $(this).find("b").css("left", (li_W - 16) / 2 + "px");
                        $(this).find("s").css("left", (li_W - 12) / 2 + "px");
                    })

                    $(".main_nav_item dd span a").click(function () {
                        $(this).parent().parent().parent().parent(".main_nav_item").hide();
                    })
                    $(".main_nav li").hover(function () {
                        $(this).find(".main_nav_item").show();
                    }, function () {
                        $(this).find(".main_nav_item").hide();
                    })

                })
            }
        })


    })


    //获取待办事项
    /*
    GetTodo(true, function (data) {
    //console.log(data);
    data = [{ "iRecNo": 0, "iFormid": 0, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项1", "dinputDate": "", "sDetailPage": "", "itype": "" }, { "iRecNo": 1, "iFormid": 1, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项2", "dinputDate": "", "sDetailPage": "", "itype": "" }];
    for (var i = 0; i < data.length; i++) {
    __todoList.push(data[i])
    }
    //console.log(__todoList);
    $(".todoList").html("");
    for (var n = 0; n < __todoList.length; n++) {
    $(".todoList").append('<li><a href="javascript:void(0);" onclick="OpenCheckPage(' + __todoList[n].iRecNo + ',' + __todoList[n].iFormid + ')">' + __todoList[n].sContent + '</a></li>');
    }

    setInterval(getTodoList,30000);
    function getTodoList() {
    GetTodo(true, function (data) {
    __todoList = [];
    data = [{ "iRecNo": 2, "iFormid": 2, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项3", "dinputDate": "", "sDetailPage": "", "itype": "" }, { "iRecNo": 3, "iFormid": 3, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项4", "dinputDate": "", "sDetailPage": "", "itype": "" }];
    for (var i = 0; i < data.length; i++) {
    __todoList.push(data[i])
    }
    $(".todoList").html("");
    for (var n = 0; n < __todoList.length; n++) {
    $(".todoList").append('<li><a href="javascript:void(0);" onclick="OpenCheckPage(' + __todoList[n].iRecNo + ',' + __todoList[n].iFormid + ')">' + __todoList[n].sContent + '</a></li>');
    }
    })

    }
    })
    */
    GetTodo(true, ToDoFun);
    //获取公告
    GetNotice(true, function (data) {
        //console.log(data);
        __noticeList = [];
        //data = [{ "iRecNo": 2, "sTitle": "公告信息3", "iSerial": "", "dInputDate": "Fri Mar 17 2017 16:44:01 GMT+0800 (中国标准时间)" }, { "iRecNo": 3, "sTitle": "公告信息4", "iSerial": 0, "dInputDate": "Fri Mar 17 2017 17:44:01 GMT+0800 (中国标准时间)"}];
        for (var i = 0; i < data.length; i++) {
            __noticeList.push(data[i])
        }
        $(".notice1").html("");
        for (var n = 0; n < __noticeList.length; n++) {
            $(".notice1").append('<li><a href="javascript:void(0);" onclick="openNoticeDetail(' + __noticeList[n].iRecNo + ',&quot;' + __noticeList[n].sTitle + '&quot;)"><span>' + convertTime(__noticeList[n].dInputDate) + '</span>' + __noticeList[n].sTitle + '</a></li>');
        }
    })
    //获取提醒事项
    GetRemind(true, function (data) {
        //console.log(__remindList);
        $(".remindList").html("");
        if (__remindList) {
            for (var i = 0; i < __remindList.length; i++) {
                //console.log(__remindList);
                //$(".remindList").append('<li><a href="javascript:void(0);" onclick="remindClick(' + i + ')">' + __remindList[i].sTitle + '</a></li>');
                $(".remindList").append("<li onclick='remindClick(" + i + ")'><img src='/Base/imageUpload/images/" + __remindList[i].sImageUrl + "'/><span>" + __remindList[i].sTitleSimple + "</span><b>" + __remindList[i].iCount + "</b></li>");
            }
        }        
        //for (var i = 0; i < 10; i++) {
        //    $(".remindList").append("<li><img src='/images/remindDefault.png'/><span>测试添加</span><b>10</b></li>");
        //}
    })
    //获取首页流程图
    $.ajax({
        url: "/MainPage.request",
        type: "get",
        async: false,
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

    $('#tt').tabs({
        onContextMenu: function (e, title, index) {
            e.preventDefault();
            if (index > 1) {
                $('#mm').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                }).data("tabTitle", title);
            }
        }
    });
    //右键菜单click
    $("#mm").menu({
        onClick: function (item) {
            closeTab1(this, item.name);
        }
    });
})
var ToDoFun=function(data) {
    //console.log(data);
    __todoList = [];
    //data = [{ "iRecNo": 0, "iFormid": 0, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项1", "dinputDate": "", "sDetailPage": "", "itype": "" }, { "iRecNo": 1, "iFormid": 1, "sSendUserID": 0, "sReceiveUserid": "", "sContent": "待办事项2", "dinputDate": "", "sDetailPage": "", "itype": ""}];
    for (var i = 0; i < data.length; i++) {
        __todoList.push(data[i])
    }
    //console.log(__todoList);
    $(".todoList").html("");
    for (var n = 0; n < __todoList.length; n++) {
        $(".todoList").append('<li><a href="javascript:void(0);" onclick="OpenCheckPage(' + __todoList[n].iRecNo + ',' + __todoList[n].iFormid + ')">' + __todoList[n].sContent + '</a></li>');
    }
}
function getFirstFlowXml() {
    var xmlStr = "";
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

//日期格式转换
function convertTime(time) {
    var _time = new Date(time);
    var _year = _time.getFullYear();
    var _month = _time.getMonth() + 1;
    if (_month >= 1 && _month <= 9) { _month = "0" + _month; }
    var _date = _time.getDate();
    if (_date >= 1 && _date <= 9) { _date = "0" + _date; }
    var _houer = _time.getHours();
    if (_houer >= 0 && _houer <= 9) { _houer = "0" + _houer; }
    var _minute = _time.getMinutes();
    if (_minute >= 0 && _minute <= 9) { _minute = "0" + _minute; }
    var _second = _time.getSeconds();
    if (_second >= 0 && _second <= 9) { _second = "0" + _second; }
    //    var return_time = _year + "-" + _month + "-" + _date + " " + _houer + ":" + _minute + ":" + _second;
    var return_time = _year + "-" + _month + "-" + _date;
    return return_time;
}

function menuThirdClick(id) {
    for (var i = 0; i < menuThird.length; i++) {
        if (menuThird[i].iMenuID == id) {
            var _node = { attributes: {} };
            _node.text = menuThird[i].sMenuName;
            _node.attributes.sFilePath = menuThird[i].sFilePath;
            _node.iconCls = menuThird[i].sIcon;
            _node.attributes.sParms = menuThird[i].sParms == null || menuThird[i].sParms == undefined ? "" : menuThird[i].sParms;
            _node.id = menuThird[i].iMenuID;
            _node.attributes.iFormID = menuThird[i].iFormID;
            //console.log(_node);
            MenuClick(_node);
            break;
        }
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
    var mainMenuData;
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
                mainMenuData = data;
                //return data;
            }
        },
        error: function (data) {
            var aa = 1;
        },
        dataType: "json"
    });
    return mainMenuData;
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
    var subMenuData;
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
                subMenuData = data;
                //return data;
            }
        },
        error: function (data) {
            var errorData = data;
        },
        dataType: "json"
    });
    return subMenuData;
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
            var sparms = node.attributes.sParms.replace(/&amp;/g, "&").replace(/'/g, "");
            var src = node.attributes.sFilePath + "?MenuTitle=" + escape(node.text) + "&MenuID=" + node.id + "&FormID=" + node.attributes.iFormID + sparms;
            $("#tt").tabs("add", {
                id: node.id,
                title: node.text,
                //href: node.attributes.sFilePath + "&MenuID="+node.id+"&FormID=" + node.attributes.iFormID+node.attributes.sParms,
                closable: true,
                iconCls: icon,
                content: "<iframe id='ifr" + node.id + "' name='ifr" + node.id + "' width='100%' height='100%' frameborder='0'  src='" + src + "' style='width:100%;height:100%;'></iframe>"
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

//获取待办事项
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
                    setTimeout('GetTodo(' + isAsync + ',' + fun + ') ', 30000);
                }
                else {
                    return data;
                }
            },
            dataType: "json"
        }
    )
}

function loaddatatodo() {
    GetTodo(true, ToDoFun);
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
                setTimeout('GetNotice(' + isAsync + ',' + fun + ') ', 60000);
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
//获取提醒事项
/*
{sTitle:,iMenuID:,sMenuName:,iFormID:,sFilePath:,sFilters:}
*/
var __remindList = [];
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
                    __remindList = objList;
                    fun(returnObj);
                    setTimeout('GetRemind(' + isAsync + ',' + fun + ') ', 60000);
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
    var tab = $('#tt').tabs('getSelected');
    //增加退出日志
    var sqlObj = {
        TableName: "FSysMainMenu",
        Fields: "iFormID,sMenuName",
        SelectAll: "True",
        Filters: [
            {
                Field: "iMenuID",
                ComOprt: "=",
                Value: "'" + tab.id + "'"
            }
        ]
    }
    var result = SqlGetData(sqlObj);
    if (result.length > 0) {
        var iformid = result[0].iFormID;
        var sMenuName = result[0].sMenuName;
        SysOpreateAddLog("退出表单", iformid, "", sMenuName);
    }
    $("#tt").tabs("close", $("#tt").tabs('getTabIndex', tab));

}

function turntoTab(id, formid, name, parmvalue, filepath, icon, isNewWindow) {
    //console.log("lianjie success");
    //console.log(id, formid, name, parmvalue, filepath, icon);
    var iconCls = icon == "" ? "icon-job" : icon;
    if ($("#tt").tabs("exists", name)) {
        if (isNewWindow != true) {
            $("#tt").tabs("close", name);
        }
        else {
            var count = 0;
            var tabs = $("#tt").tabs("tabs");
            for (var i = 0; i < tabs.length; i++) {
                if ($(tabs[i]).panel("options").title.indexOf(name) == 0) {
                    count++;
                }
            }
            name = name + count;
        }
    }
    if (filepath != "") {
        filepath = filepath.replace(/'/g, "");
        var evalue = getEnCodeStr(parmvalue);
        //var src = filepath + "MenuTitle=" + escape(node.text) + "&MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue;
        var src = filepath + "MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue + "&isAss=1";
        $("#tt").tabs("add", {
            id: id,
            title: name,
            //href: node.attributes.sFilePath + "&MenuID="+node.id+"&FormID=" + node.attributes.iFormID+node.attributes.sParms,
            closable: true,
            iconCls: iconCls,
            content: "<iframe id='ifr" + id + "' name='ifr" + id + "' width='100%' height='100%' frameborder='0'  src='" + src + "' style='width:100%;height:100%;'></iframe>"
        })
    }
}
function getEnCodeStr(str) {
    str = str.replace(/\+/g, "%2B").replace(/\//g, "%2F").replace(/\?/g, "%3F").replace(/%/g, "%25").replace(/#/g, "%23").replace(/&/g, "%26").replace(/=/g, "%3D").replace(/\'/g, "%27");
    return str;
}
function getCurtUserName() {
    var userName = "";
    $.ajax(
        {
            url: "/Login.request",
            type: "get",
            data: { otype: "getcurtusername" },
            cache: false,
            async: false,
            success: function (data) {
                userName = data;
            }
        }
    )
    return userName;
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


function checkWinClose() {
    $("#divWin").window("close");
}

function closeTab() {
    var tab = $('#tt').tabs('getSelected');
    //增加退出日志
    var sqlObj = {
        TableName: "FSysMainMenu",
        Fields: "iFormID,sMenuName",
        SelectAll: "True",
        Filters: [
            {
                Field: "iMenuID",
                ComOprt: "=",
                Value: "'" + $(tab).panel("options").id + "'"
            }
        ]
    }
    var result = SqlGetData(sqlObj);
    if (result.length > 0) {
        var iformid = result[0].iFormID;
        var sMenuName = result[0].sMenuName;
        SysOpreateAddLog("退出表单", iformid, "", sMenuName);
    }
    $("#tt").tabs("close", $("#tt").tabs('getTabIndex', tab));
}
//删除Tabs
function closeTab1(menu, type) {
    var allTabs = $("#tt").tabs('tabs');
    var allTabtitle = [];
    $.each(allTabs, function (i, n) {
        var opt = $(n).panel('options');
        if (opt.closable)
            allTabtitle.push(opt.title);
    });
    var curTabTitle = $(menu).data("tabTitle");
    var curTabIndex = $("#tt").tabs("getTabIndex", $("#tt").tabs("getTab", curTabTitle));

    var currentTab = $('#tt').tabs('getSelected');
    switch (type) {
        case "1": //关闭当前
            $("#tt").tabs("close", curTabTitle);
            //增加退出日志
            var sqlObj = {
                TableName: "FSysMainMenu",
                Fields: "iFormID,sMenuName",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iMenuID",
                        ComOprt: "=",
                        Value: "'" + $(currentTab).panel("options").id + "'"
                    }
                ]
            }
            var result = SqlGetData(sqlObj);
            if (result.length > 0) {
                var iformid = result[0].iFormID;
                var sMenuName = result[0].sMenuName;
                SysOpreateAddLog("退出表单", iformid, "", sMenuName);
            }
            return false;
            break;
        case "2": //全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                $('#tt').tabs('close', allTabtitle[i]);
            }
            for (var i = 0; i < allTabs.length; i++) {
                //增加退出日志
                var sqlObj = {
                    TableName: "FSysMainMenu",
                    Fields: "iFormID,sMenuName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMenuID",
                            ComOprt: "=",
                            Value: "'" + $(allTabs[i]).panel("options").id + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    var iformid = result[0].iFormID;
                    var sMenuName = result[0].sMenuName;
                    SysOpreateAddLog("退出表单", iformid, "", sMenuName);
                }
            }
            break;
        case "3": //除此之外全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                if (curTabTitle != allTabtitle[i])
                    $('#tt').tabs('close', allTabtitle[i]);
            }
            for (var i = 0; i < allTabs.length; i++) {
                if (allTabs[i].title != curTabTitle) {
                    //增加退出日志
                    var sqlObj = {
                        TableName: "FSysMainMenu",
                        Fields: "iFormID,sMenuName",
                        SelectAll: "True",
                        Filters: [
                            {
                                Field: "iMenuID",
                                ComOprt: "=",
                                Value: "'" + $(allTabs[i]).panel("options").id + "'"
                            }
                        ]
                    }
                    var result = SqlGetData(sqlObj);
                    if (result.length > 0) {
                        var iformid = result[0].iFormID;
                        var sMenuName = result[0].sMenuName;
                        SysOpreateAddLog("退出表单", iformid, "", sMenuName);
                    }
                }                
            }
            $('#tt').tabs('select', curTabTitle);
            break;
        case "4": //当前侧面右边
            for (var i = curTabIndex; i < allTabtitle.length; i++) {
                $('#tt').tabs('close', allTabtitle[i]);
            }
            for (var i = curTabIndex; i < allTabs.length; i++) {
                //增加退出日志
                var sqlObj = {
                    TableName: "FSysMainMenu",
                    Fields: "iFormID,sMenuName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMenuID",
                            ComOprt: "=",
                            Value: "'" + $(allTabs[i]).panel("options").id + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    var iformid = result[0].iFormID;
                    var sMenuName = result[0].sMenuName;
                    SysOpreateAddLog("退出表单", iformid, "", sMenuName);
                }
            }
            $('#tt').tabs('select', curTabTitle);
            break;
        case "5": //当前侧面左边
            for (var i = 0; i < curTabIndex - 1; i++) {
                $('#tt').tabs('close', allTabtitle[i]);
            }
            for (var i = 0; i < curTabIndex-1; i++) {
                //增加退出日志
                var sqlObj = {
                    TableName: "FSysMainMenu",
                    Fields: "iFormID,sMenuName",
                    SelectAll: "True",
                    Filters: [
                        {
                            Field: "iMenuID",
                            ComOprt: "=",
                            Value: "'" + $(allTabs[i]).panel("options").id + "'"
                        }
                    ]
                }
                var result = SqlGetData(sqlObj);
                if (result.length > 0) {
                    var iformid = result[0].iFormID;
                    var sMenuName = result[0].sMenuName;
                    SysOpreateAddLog("退出表单", iformid, "", sMenuName);
                }
            }
            $('#tt').tabs('select', curTabTitle);
            break;
        case "6": //刷新
            var iframe = $(currentTab.panel('options').content);
            if (iframe) {
                var id;
                var iframeID = iframe.attr("id");
                if (iframeID && iframeID.startWith("ifr")) {
                    id = iframeID.substr(3, iframeID.length - 3);
                    for (var i = 0; i < openMenuID.length; i++) {
                        if (id == openMenuID[i]) {
                            openMenuID.splice(i, 1);
                            i--;
                        }
                    }
                }
                var src = iframe.attr('src');
                $('#tt').tabs('update', {
                    tab: currentTab,
                    options: {
                        content: createFrame(src,"ifr"+id)
                    }
                })
            } else {

            }
            break;
            //$("#tab").tabs("getTab", curTabTitle).panel("refresh");                                               
            //break;                                               
    }

}
String.prototype.startWith = function (str) {
    var reg = new RegExp("^" + str);
    return reg.test(this);
}
function createFrame(url,id) {
    var s = '<iframe id="'+id+'" name="'+id+'" scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
    return s;
}
//var isOpenForm = false;
//function tabBeforeClose(title, index) {
//    if (isOpenForm == true) {
//        var tab = $("#tab").tabs("getTab", index);
//        var id = tab.id;
//        window.frames["ifr" + id].CloseBillWindow();
//        isOpenForm = false;
//        return false;
//    }

//}
//function formOpen() {
//    isOpenForm = true;
//}

var isOpenForm = 0;
var openMenuID = [];
function tabBeforeClose(title, index) {
    var id = $("#tt").tabs("getTab", index).panel("options").id;
    for (var i = 0; i < openMenuID.length; i++) {
        if (id == openMenuID[i]) {
            try{
                window.frames["ifr" + id].CloseBillWindow();
                //isOpenForm--;
                return false;
            }
            catch (e) {

            }
        }
    }
}
function formOpen(iMenuID) {
    //isOpenForm++;
    openMenuID.push(iMenuID);
}

function SqlGetDataComm(sqltext, p_async, p_ispost, functionName) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "ctype=text&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost, functionName);
    if (async == false) {
        if (result && result.length > 0) {
            try {
                var jsonobj = eval("(" + result + ")");
                return jsonobj;
            }
            catch (e) {
                return [];
            }
        }
        else {
            return [];
        }
    }
}

//获取服务器时间
function getServerTime() {
    window.clearTimeout(tUpdateCurrentTime);
    //alert(severtime);
    var result = SqlGetDataComm("select CONVERT(varchar(100), GETDATE(), 111)+' '+CONVERT(varchar(100), GETDATE(), 108) as currentTime ");
    severtime = new Date(result[0].currentTime);
    //获取服务器日期
    year = severtime.getFullYear();
    month = severtime.getMonth() + 1;
    date = severtime.getDate();
    //获取服务器时间
    hour = severtime.getHours();
    minu = severtime.getMinutes();
    seco = severtime.getSeconds();
    week = ' 星期' + '日一二三四五六'.charAt(severtime.getDay());
    updateCurrentTime();
}

//实时更新显示时间
function updateCurrentTime() {
    seco++;
    if (seco == 60) {
        minu += 1;
        seco = 0;
    }
    if (minu == 60) {
        hour += 1;
        minu = 0;
    }
    if (hour == 24) {
        date += 1;
        hour = 0;
    }
    //日期处理
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        if (date == 32) {
            date = 1;
            month += 1;
        }
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        if (date == 31) {
            date = 1;
            month += 1;
        }
    } else if (month == 2) {
        if (year % 4 == 0 && year % 100 != 0) {//闰年处理
            if (date == 29) {
                date = 1;
                month += 1;
            }
        } else {
            if (date == 28) {
                date = 1;
                month += 1;
            }
        }
    }
    if (month == 13) {
        year += 1;
        month = 1;
    }
    sseco = addZero(seco);
    sminu = addZero(minu);
    shour = addZero(hour);
    sdate = addZero(date);
    smonth = addZero(month);
    syear = year;

    $("#serverTime").html(syear + "-" + smonth + "-" + sdate + " " + shour + ":" + sminu + ":" + sseco + " " + week);
    tUpdateCurrentTime = setTimeout("updateCurrentTime()", 1000);
}

function addZero(num) {
    num = Math.floor(num);
    return ((num <= 9) ? ("0" + num) : num);
}
