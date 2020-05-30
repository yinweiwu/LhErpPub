var loadedids = [];

var todoRecNoArr = [];
var isremind = false;
var selectedDate = undefined;
var isJobShow = false;
var editRowIndex = undefined;
var dateFinishData = [];
var isLoginOut = false;
var isNotCheckMessage = false;
if (window.navigator.appName == "Microsoft Internet Explorer") {
    if (!document.documentMode || document.documentMode < 8) {
        alert("请使用IE8以上版本！如果您启用了IE8的兼容模式，请您关闭它，以免不能正常使用系统!");
    }
}
//离开时记录信息
/*window.onbeforeunload = function () {
    if (isLoginOut == false) {
        if (confirm("您确认离开系统(刷新也会导致离开系统)？") == true) {
            $.ajax({
                url: "/ashx/LoginOut.ashx",
                type: "get",
                async: false,
                cache: false,
                success: function (data) {
                    window.location.href = data;
                }
            });
        }
    }
}*/

$(function () {
    //记录登录信息
    $.ajax({
        url: "/ashx/LoginHandler.ashx",
        type: "get",
        async: false,
        cache: false,
        data: { otype: "loginLog" },
        success: function (data) {

        }
    });

    $.ajax(
    {
        url: "/Base/Handler/PublicHandler.ashx",
        type: "get",
        data: { otype: "sendSMSBirthday" },
        cache: false,
        async: true,
        success: function () { },
        error: function () { }
    }
    );

    $("#spanUserName").html(getCurtUserName());
    callpostback("/Base/Handler/SysMainMenu.ashx", "Command=getMainMenu&parentMenuID=0", true, true, function (responseText) {
        if (responseText) {
            try {

                //setTimeout(function () {
                var data = eval("(" + responseText + ")");
                for (var i = 0; i < data.length; i++) {
                    if (data[i].sIcon == "") {
                        data[i].sIcon = "icon-list";
                    }
                    if (i == 0) {
                        $("#accordion1").accordion("add", {
                            title: data[i].sMenuName,
                            id: data[i].iMenuID,
                            iconCls: data[i].sIcon,
                            content: "<ul id='" + data[i].iMenuID + "'></ul>"
                            //iconCls: "a" + (parseInt(data[i].iSerial) + 1).toString()
                        }
                            );
                    }
                    else {
                        $("#accordion1").accordion("add", {
                            title: data[i].sMenuName,
                            selected: false,
                            id: data[i].iMenuID,
                            iconCls: data[i].sIcon,
                            content: "<ul id='" + data[i].iMenuID + "'></ul>"
                            //iconCls: "a" + (parseInt(data[i].iSerial) + 1).toString()
                        }
                            )
                    }
                }
                //$.messager.progress("close");
                //}
                //, 500);
            }
            catch (e) {
                $.messager.alert("错误", "获取用户权限失败！");
                //$.messager.progress("close");
            }
        }
    });
    $('#tab').tabs({
        onContextMenu: function (e, title, index) {
            e.preventDefault();
            if (index > 0) {
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

    $.ajax({
        url: "/Base/Handler/GetMenuTree.ashx",
        type: "post",
        async: true,
        cache: false,
        data: { itype: "getUserCommonMenu" },
        success: function (data) {
            var userCommMenu = JSON2.parse(data);
            $("#treeUserCommonMenu").tree({
                data: userCommMenu,
                onSelect: function (node) {
                    if ($("#treeUserCommonMenu").tree("getChildren", node.target).length == 0) {
                        f_treeSelect(node, true);
                    }
                }
            });
        }
    });

    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: true,
        cache: false,
        data: { otype: "getChineseDate" },
        success: function (data) {
            $("#spanTime").html(data);
        }
    });

    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: false,
        cache: false,
        data: { otype: "getIsNotCheckMessage" },
        success: function (data) {
            if (data.success == true) {
                if (data.message == "1") {
                    isNotCheckMessage = true;
                }
            }
        },
        dataType: "json"
    });

    isJobShow = false;
    loaddatatodo();
    loadNotice();
    //    setTimeout("loaddatatodo();", 1000);
    //    setInterval("hasNewTask();", 30000);
    //    setInterval("loadNotice();", 31000);

});

function refreshDateFinish() {
    var result = callpostback("/Base/Handler/PublicHandler.ashx", "otype=getTopDateJob", false, true);
    if (result) {
        dateFinishData = eval("(" + result + ")");
    }
}
function searchDate(date) {
    var low = 0;
    var high = dateFinishData.length - 1;
    while (low <= high) {
        var middle = Math.floor((low + high) / 2);
        if (dateFinishData[middle].sDate == date) {
            if (parseInt(dateFinishData[middle].count) > parseInt(dateFinishData[middle].total)) {
                return 1; //红色
            }
            else if (parseInt(dateFinishData[middle].count) == parseInt(dateFinishData[middle].total)) {
                return 2; //灰色
            }
            else {
                return 0;
            }
        }
        else if (dateFinishData[middle].sDate > date) {
            high = middle - 1;
        }
        else {
            low = middle + 1;
        }
    }
    return 0;
}

function linkClick(iMenuID) {
    var result = callpostback("/Base/Handler/PublicHandler.ashx", "otype=getMenuInfo&iMenuID=" + iMenuID, false, true);
    if (result) {
        var data = eval("(" + result + ")");
        var node = { attributes: {} };
        node.text = data[0].sMenuName;
        node.attributes.sFilePath = data[0].sFilePath;
        node.attributes.sParms = data[0].sParms;
        node.attributes.iFormID = data[0].iFormID;
        node.id = data[0].iMenuID;
        f_treeSelect(node);
    }
}
function saveJob(obj) {
    if (editRowIndex != undefined) {
        if ($("#tableJob").datagrid("validateRow", editRowIndex)) {
            $("#tableJob").datagrid("endEdit", editRowIndex);
            var row = $("#tableJob").datagrid("getRows")[editRowIndex];
            if (row.dTime == "" || row.dTime == undefined || row.dTime == null) {
                //$.messager.alert("不可空", "任务时间不能为空！");
                editRowIndex = undefined;
                return "任务时间不能为空！";
            }
            if (row.sContent == "" || row.sContent == undefined || row.sContent == null) {
                //$.messager.alert("不可空", "任务内容不能为空！");
                editRowIndex = undefined;
                return "任务内容不能为空！";
            }
            if (row.iFinish == "1") {
                editRowIndex = undefined;
                return "已经完成的任务不可修改！";
            }
            var iFinish = row.iFinish == undefined ? "0" : row.iFinish;
            var parms = "otype=updateDateJob&iRecNo=" + row.iRecNo + "&iSerial=" + row.iSerial + "&sDate=" + selectedDate + "&dTime=" + row.dTime + "&sContent=" + row.sContent + "&iFinish=" + iFinish;
            var result = callpostback("/Base/Handler/PublicHandler.ashx", parms, false, true);
            if (result != "1") {
                return result;
            }
            else {
                editRowIndex = undefined;
                return "1";
            }
        }
    }
    return "1";
}
function finishJob(obj) {
    var index = obj.id;
    if ($("#tableJob").datagrid("validateRow", index)) {
        $("#tableJob").datagrid("endEdit", index);
        var row = $("#tableJob").datagrid("getRows")[index];
        if (row.dTime == "" || row.dTime == undefined || row.dTime == null) {
            $.messager.alert("不可空", "任务时间不能为空！");
            editRowIndex = undefined;
            return;
        }
        if (row.sContent == "" || row.sContent == undefined || row.sContent == null) {
            $.messager.alert("不可空", "任务内容不能为空！");
            editRowIndex = undefined;
            return;
        }

        var iRecNo = row.iRecNo;
        var iFinish = row.iFinish;
        if (iFinish == "1") {
            iFinish = "0";
        }
        else {
            iFinish = "1";
        }
        var parms = "otype=updateDateJob&iRecNo=" + row.iRecNo + "&iSerial=" + row.iSerial + "&sDate=" + selectedDate + "&dTime=" + row.dTime + "&sContent=" + row.sContent + "&iFinish=" + iFinish;

        var result = callpostback("/Base/Handler/PublicHandler.ashx", parms, false, true);
        if (result == "1") {
            $("#tableJob").datagrid("updateRow", { index: index, row: {
                iFinish: iFinish
            }
            });
            editRowIndex = undefined;
            refreshDateFinish();
            $("#div_calendar").calendar();
        }
        else {
            $.messager.alert("错误", result);
        }
    }
}
function f_AccSelect(title, index) {
    var p = $(this).accordion("getSelected");
    for (var i = 0; i < loadedids.length; i++) {
        if (loadedids[i] == p[0].id) {
            return false;
        }
    }
    $("#" + p[0].id).tree({
        url: '/Base/Handler/GetMenuTree.ashx?itype=getSubMenu&parentMenuID=' + p[0].id,
        onSelect: f_treeSelect
    });
    //$("#" + p[0].id).tree("collapseAll",this);
    loadedids.push(p[0].id);
}
function f_treeSelect(node, isCommon) {
    if (!$("#tab").tabs("exists", node.text)) {
        if (node.attributes.sFilePath != "") {
            var icon = node.iconCls == undefined || node.iconCls == "" || node.iconCls == null ? "icon-job" : node.iconCls;
            var sparms = node.attributes.sParms.replace(/&amp;/g, "&").replace(/'/g, "");
            var src = node.attributes.sFilePath + "?MenuTitle=" + escape(node.text) + "&MenuID=" + node.id + "&FormID=" + node.attributes.iFormID + sparms;
            $("#tab").tabs("add", {
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
        $("#tab").tabs("select", node.text);
    }
}
function closeTab() {
    var tab = $('#tab').tabs('getSelected');
    $("#tab").tabs("close", $("#tab").tabs('getTabIndex', tab));

}
function turntoTab(id, formid, name, parmvalue, filepath, icon) {
    var iconCls = icon == "" ? "icon-job" : icon;
    if ($("#tab").tabs("exists", name)) {
        $("#tab").tabs("close", name);
    }
    if (filepath != "") {
        filepath = filepath.replace(/'/g, "");
        var evalue = getEnCodeStr(parmvalue);
        //var src = filepath + "MenuTitle=" + escape(node.text) + "&MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue;
        var src = filepath + "MenuID=" + id + "&FormID=" + formid + "&filters=" + evalue + "&isAss=1";
        $("#tab").tabs("add", {
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
        window.location.href = "login.htm";
    }
}
function abrout() {
    if (confirm("确认退出？")) {
        isLoginOut = true;
        isLoginOut = true;
        var url = "Login.request";
        var parms = "otype=loginOut";
        var async = false;
        var ispost = false;
        callpostback(url, parms, async, ispost, function () {

        });
        window.close();
    }
}
function remaidtip(newCount, message) {
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
//删除Tabs
function closeTab1(menu, type) {
    var allTabs = $("#tab").tabs('tabs');
    var allTabtitle = [];
    $.each(allTabs, function (i, n) {
        var opt = $(n).panel('options');
        if (opt.closable)
            allTabtitle.push(opt.title);
    });
    var curTabTitle = $(menu).data("tabTitle");
    var curTabIndex = $("#tab").tabs("getTabIndex", $("#tab").tabs("getTab", curTabTitle));

    var currentTab = $('#tab').tabs('getSelected');
    switch (type) {
        case "1": //关闭当前
            $("#tab").tabs("close", curTabTitle);
            return false;
            break;
        case "2": //全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                $('#tab').tabs('close', allTabtitle[i]);
            }
            break;
        case "3": //除此之外全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                if (curTabTitle != allTabtitle[i])
                    $('#tab').tabs('close', allTabtitle[i]);
            }
            $('#tab').tabs('select', curTabTitle);
            break;
        case "4": //当前侧面右边
            for (var i = curTabIndex; i < allTabtitle.length; i++) {
                $('#tab').tabs('close', allTabtitle[i]);
            }
            $('#tab').tabs('select', curTabTitle);
            break;
        case "5": //当前侧面左边
            for (var i = 0; i < curTabIndex - 1; i++) {
                $('#tab').tabs('close', allTabtitle[i]);
            }
            $('#tab').tabs('select', curTabTitle);
            break;
        case "6": //刷新
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
            $('#tab').tabs('update', {
                tab: currentTab,
                options: {
                    content: createFrame(src)
                }
            })
            break;
        //$("#tab").tabs("getTab", curTabTitle).panel("refresh");                                             
        //break;                                             
    }

}
function openwindow(url, iWidth, iHeight) {
    return showModalDialog(url, "", "minimize:yes;maximize:yes;location=no;toolbar=no;status:yes;scroll:yes;resizable:yes;center:yes;dialogWidth=" + iWidth + ";dialogHeight=" + iHeight);
}
function createFrame(url) {
    var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
    return s;
}


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
function OpenCheckPage2(irecno, tid) {
    $("#divWin").show();
    $("#divWin").window({
        title: '单据审批',
        height: 610,
        width: 1000,
        content: "<iframe width='100%' height='100%' frameborder='0' src='/Base/SysWarnDetail.aspx?irecno=" + irecno + "'></iframe>",
        modal: true,
        collapsible: false,
        minimizable: false
    });
    $("#divWin").window("maximize");
    //window.open("SysWarnDetail.aspx?irecno=" + irecno, 'newwindow', 'height=610,width=1000,top=50,left=200,toolbar=no,resizable=yes,location=no,status=no')
}
function loaddatatodo() {
    var table = document.getElementById("tabletodo");
    while (table.rows.length > 0) {
        table.deleteRow(0);
    }
    while (todoRecNoArr.length > 0) {
        todoRecNoArr.splice(0, 1);
    }

    $.ajax(
        {
            url: "/Base/Handler/PublicHandler.ashx",
            type: "get",
            async: true, cache: false, data: { otype: "getTodo" },
            success: function (responsText) {
                var data = JSON2.parse(responsText);
                if (data) {
                    for (var i = 0; i < data.length; i++) {
                        addrow1(data[i]);
                        todoRecNoArr.push(data[i].iRecNo);
                    }
                    if (todoRecNoArr.length > 0) {
                        if (isremind == false) {
                            remaidtip(todoRecNoArr.length);
                            isremind = true;
                        }
                    }
                }
            }
        }
    )
    //加载消息
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: true,
        cache: false,
        data: { otype: "getCheckedMessage" },
        success: function (data) {
            var sqlcheckdata = JSON2.parse(data);
            for (var i = 0; i < sqlcheckdata.length; i++) {
                remaidtip(0, sqlcheckdata[i].sContent);
                var iRecNo = sqlcheckdata[i].iRecNo;
                $.ajax({
                    url: "/Base/Handler/PublicHandler.ashx",
                    type: "post",
                    async: true,
                    cache: false,
                    data: { otype: "getCheckedMessage", oprate: "1", iRecNo: iRecNo }
                })
            }
        }
    })
    if (isNotCheckMessage == false) {
        setTimeout("hasNewTask()", 30000);
    }
}

function loadNotice() {
    var table = document.getElementById("tableNotice");
    while (table.rows.length > 0) {
        table.deleteRow(0);
    }
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "get",
        async: true, cache: false, data: { otype: "getNotice" },
        success: function (responseText) {
            if (responseText) {
                try {
                    var noticeData = JSON2.parse(responseText);
                    for (var i = 0; i < noticeData.length; i++) {
                        addNoticerow(noticeData[i]);
                    }
                }
                catch (e) {
                    //$.messager.alert("错误", "加载公告时发生错误！");
                }
            }
        }
    });
    if (isNotCheckMessage == false) {
        setTimeout("loadNotice()", 30000);
    }
}
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
function addNoticerow(obj) {
    var table = document.getElementById("tableNotice");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='hidden' value='" + obj.iRecNo + "'></input><a href='#' style='text-decoration:none;' onclick=openNoticeDetail('" + obj.iRecNo + "',\"" + obj.sTitle + "\")>" + obj.sTitle + "</a>";
    var td1 = tr.insertCell(-1);
    td1.style.width = "200px";
    td1.innerHTML = obj.dInputDate;
}
function addrow1(obj) {
    var table = document.getElementById("tabletodo");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='hidden' value='" + obj.iRecNo + "'></input><a href='#' style='text-decoration:none;' onclick=OpenCheckPage('" + obj.iRecNo + "','" + obj.iFormid + "','tabletodo')>" + obj.sContent + "</a>";
    var td1 = tr.insertCell(-1);
    td1.style.width = "200px";
    td1.innerHTML = obj.dinputDate;
}

function deleteRow(iRecNo) {
    var table = document.getElementById("tabletodo");
    if (iRecNo) {
        for (var i = 0; i < table.rows.length; i++) {
            if (get_firstchild(table.rows[i].cells[0]).value == iRecNo) {
                table.deleteRow(i);
            }
        }
    }
    else {
        while (table.rows.length > 0) {
            table.deleteRow(0);
        }
    }
}

function addrow2(obj) {
    var table = document.getElementById("tablereminddiv");
    var tr = table.insertRow(table.rows.length);
    var td2 = tr.insertCell(-1);
    td2.innerHTML = obj.type + ":    " + " <a href='#' style='text-decoration:none;' onclick=OpenCheckPage2('" + obj.iRecNo + "')>" + obj.title + "</a>";
}

function hasNewTask() {
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: true, cache: false, data: { otype: "getTodo" },
        success: function (responsText) {
            try {
                var data = JSON2.parse(responsText);
                if (data) {
                    var newCount = 0;
                    //添加新任务
                    for (var i = 0; i < data.length; i++) {
                        var isin = false;
                        for (var j = 0; j < todoRecNoArr.length; j++) {
                            if (data[i].iRecNo == todoRecNoArr[j]) {
                                isin = true;
                                break;
                            }
                        }
                        if (isin == false) {
                            addrow1(data[i]);
                            todoRecNoArr.push(data[i].iRecNo);
                            newCount++;
                        }
                    }
                    //删除取消的任务
                    for (var i = 0; i < todoRecNoArr.length; i++) {
                        var isin = false;
                        for (var j = 0; j < data.length; j++) {
                            if (todoRecNoArr[i] == data[j].iRecNo) {
                                isin = true;
                                break;
                            }
                        }
                        if (isin == false) {
                            deleteRow(todoRecNoArr[i]);
                            //todoRecNoArr.splice(i, 1);
                            delete todoRecNoArr[i];
                        }
                    }
                    if (newCount > 0) {
                        remaidtip(newCount);
                    }

                    //加载消息
                    $.ajax({
                        url: "/Base/Handler/PublicHandler.ashx",
                        type: "post",
                        async: true,
                        cache: false,
                        data: { otype: "getCheckedMessage" },
                        success: function (data) {
                            var sqlcheckdata = JSON2.parse(data);
                            for (var i = 0; i < sqlcheckdata.length; i++) {
                                remaidtip(0, sqlcheckdata[i].sContent);
                                var iRecNo = sqlcheckdata[i].iRecNo;
                                $.ajax({
                                    url: "/Base/Handler/PublicHandler.ashx",
                                    type: "post",
                                    async: true,
                                    cache: false,
                                    data: { otype: "getCheckedMessage", oprate: "1", iRecNo: iRecNo }
                                })
                            }
                        }
                    })

                }
            }
            catch (e) {

            }
        },
        error: function (data) {
            var data1 = data;
        }
    });

    setTimeout("hasNewTask()", 30000);
}
function get_firstchild(n) {
    var x = n.firstChild;
    if (x != null) {
        while (x.nodeType != 1) {
            x = x.nextSibling;
        }
        return x;
    }
    else {
        return null;
    }
}
function checkWinClose() {
    $("#divWin").window("close");
}
function getChildID(tablename) {
    var jsonobj = {
        StoreProName: "SpGetIden",
        StoreParms: [{
            ParmName: "@sTableName",
            Value: tablename
        }]
    }
    var result = SqlStoreProce(jsonobj);
    if (result && result.length > 0 && result != "-1") {
        return result;
    }
    else {
        return "-1";
    }
}

FusionCharts.ready(function () {
    //    callpostback("/Base/Handler/PublicHandler.ashx", "otype=getChart&pid=divChart", true, true, function (responseText) {
    //        if (responseText) {
    //            try {
    //                var result = eval("(" + responseText + ")");
    //                if (result.success == true) {
    //                    eval(result.result);
    //                }
    //                else {
    //                    $.messager.alert("错误", result.message);
    //                }
    //            }
    //            catch (e) {
    //                $.messager.alert("错误", e.message);
    //            }
    //        }
    //    });
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
})
function charZoomIn() {
    $("#divZoomInChar").window("open");
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: true,
        cache: false,
        data: { otype: "getChart", pid: "divZoomInChar" },
        success: function (resultObj) {
            if (resultObj.success == true) {                
                eval(resultObj.result);
                //eval(resultObj.result);
                //                var divTabChart = document.createElement('div');
                //                divTabChart.setAttribute('id', 'divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a');
                //                $('#divZoomInChar')[0].appendChild(divTabChart);
                //                $('#divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a').tabs({ fit: true, border: false, plain: true, tabPosition: 'bottom' });
                //                var pWidth = $('#divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a').tabs('options').width;
                //                var pHeight = $('#divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a').tabs('options').height;
                //                alert(pWidth + " " + pHeight);
                //                $('#divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a').tabs('add', { id: 'chartGroup008d376ed-cfdc-4f7d-9f7a-19f05c45ed61', title: '销售图表', selected: false }); var divChart00 = document.createElement('div'); divChart00.setAttribute('id', 'divChart008099583e-07c5-4cbc-b89f-44c1116bf4de'); divChart00.setAttribute('style', 'float:left;'); $('#chartGroup008d376ed-cfdc-4f7d-9f7a-19f05c45ed61')[0].appendChild(divChart00); var chart00 = new FusionCharts({ "type": "mscolumn2d", "renderAt": "divChart008099583e-07c5-4cbc-b89f-44c1116bf4de", "dataFormat": "json", "width": pWidth - 10, "height": pHeight - 35, "dataSource": { "chart": { "showLegend": "1", "caption": "销售统计", "subCaption": "业务员", "xAxisName": "月份", "formatNumberScale": "1", "numberScaleUnit": "万", "numberScaleValue": "10000", "useroundedges": "1", "yAxisName": "金额", "theme": "fint", "baseFontSize ": "14", "outCnvBaseFontSize ": "12", "baseFont": "新宋体" }, "showValues": "0", "categories": [{ "category": [{ "label": "2016-01" }, { "label": "2016-02" }, { "label": "2016-03" }, { "label": "2016-04" }, { "label": "2016-05" }, { "label": "2016-06" }, { "label": "2016-07" }, { "label": "2016-08" }, { "label": "2016-09" }, { "label": "2016-10" }, { "label": "2016-11" }, { "label": "2016-12"}]}], "dataset": [{ "seriesname": "红兵", "data": [{ "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "3000000" }, { "value": "4000000" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": ""}] }, { "seriesname": "李四", "data": [{ "value": "2000000" }, { "value": "3000000" }, { "value": "" }, { "value": "" }, { "value": "2000000" }, { "value": "3000000" }, { "value": "" }, { "value": "2000000" }, { "value": "2000000" }, { "value": "3000000" }, { "value": "" }, { "value": ""}] }, { "seriesname": "李五", "data": [{ "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "3000000" }, { "value": "1000000" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": ""}] }, { "seriesname": "申爷", "data": [{ "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": ""}] }, { "seriesname": "张三", "data": [{ "value": "1000000" }, { "value": "2000000" }, { "value": "1000000" }, { "value": "2000000" }, { "value": "" }, { "value": "" }, { "value": "1000000" }, { "value": "2000000" }, { "value": "" }, { "value": "" }, { "value": "1000000" }, { "value": "2000000"}] }, { "seriesname": "张岳", "data": [{ "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": "" }, { "value": ""}]}]} }); chart00.render(); $('#divTabChart3662a7e8-b74e-48da-9ab7-8da9640dfa5a').tabs('select', '销售图表');
            }
            else {
                $.messager.alert("错误", resultObj.message);
            }
        },
        dataType: "json"
    });
    $(".panel-tool-close").attr("href", "#");
}

//处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
function banBackSpace(e) {
    var ev = e || window.event; //获取event对象
    var obj = ev.target || ev.srcElement; //获取事件源
    var t = obj.type || obj.getAttribute('type'); //获取事件源类型
    //获取作为判断条件的事件类型
    var vReadOnly = obj.readOnly;
    var vDisabled = obj.disabled;
    //处理undefined值情况
    vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
    vDisabled = (vDisabled == undefined) ? true : vDisabled;
    //当敲Backspace键时，事件源类型为密码或单行、多行文本的，
    //并且readOnly属性为true或disabled属性为true的，则退格键失效
    var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);
    //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
    var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";
    //判断
    if (flag2 || flag1) return false;
}
//禁止退格键 作用于Firefox、Opera
document.onkeypress = banBackSpace;
//禁止退格键 作用于IE、Chrome
document.onkeydown = banBackSpace;