//是否有帐户信息，没有的话获取一次
//var userInfoStr = getUserInfo("userInfo");
//if (userInfoStr == null || userInfoStr=="undefined") {
//requestAjax("/api/sysaccount/getbyname/" + getUserName() +"?fields=Id,UserName,FullName,Roles", "get", false,
//    null,
//    function (result, status, xhr) {
//        if (xhr.status == 200) {
//            userInfo = result;
//            var isRememberMe = localStorage.getItem("rememberMe");
//            if (isRememberMe == "1") {
//                localStorage.setItem("userInfo", JSON.stringify(userInfo));
//            } else {
//                sessionStorage.setItem("userInfo", JSON.stringify(userInfo));
//            }
//        } else {
//            document.write(xhr.status + " " + xhr.statusText);
//        }
//    },true
//);

//alert(result);
//return result;

//}
//userInfoStr = null;

var menuData;
var userMenuList;
$(function () {
    var url = "/ashx/LoginHandler.ashx?otype=getcurtusername";
    var parms = "";
    var async = false;
    var ispost = false;
    $.ajax({
        url: "/ashx/LoginHandler.ashx?otype=getcurtusername",
        type: "get",
        async: false,
        success: function (result) {
            $("#btnUserName").linkbutton({ text: result });
        }
    });

    //var userInfoStr = getUserInfo("userInfo");
    //var userInfo = JSON.parse(userInfoStr);
    //$("#btnUserName").linkbutton({ text: userInfo.FullName });
    getUserMenu(0, function (result) {
        //menuData = result;
        userMenuList = result;
        menuData = formatMenuData(userMenuList);
        $("#divMenu").sidemenu({
            data: menuData,
            multiple: false,
            border: false,
            onSelect: selectMenu
        });
        loadTopMenu(menuData);
    });
});
function getUserMenu(pid, successFun) {
    $.ajax({
        url: "/Base/Handler/GetMenuTree.ashx",
        type: "get",
        async: true,
        data: { itype: "getUserMenu1" },
        dataType: "json",
        success: function (resultObj) {
            if (resultObj) {
                successFun(resultObj)
            }
        }
    });
    //requestAjax("/api/sysaccountmenu?userid=" + userId + "&fields=Id,Name,ParentSysMenuId,OrderNum,Url,SysBillId,IsHideToNum", "get", true,
    //    null,
    //    function (result, status, xhr) {
    //        if (successFun) {
    //            result = result.filter(function (p) {
    //                return p.IsHideToNum != 1;
    //            });
    //            successFun(result);
    //        }
    //    },
    //    true
    //);
}
function loadTopMenu(menudata) {
    var tds = $("#tabTopMenu tr:first").find("td");
    tds.remove();
    for (var i = 0; i < menudata.length; i++) {
        var tdBtn = $('<td><a id="btn' + menudata[i].iMenuID + '">' + menudata[i].sMenuName + '</a></td>');
        $("#tabTopMenu tr:first-child").append(tdBtn);
        var htmlMenu = buildChildrenMenu(menudata[i].iMenuID, userMenuList);
        if (htmlMenu != "") {
            htmlMenu = "<div id='mm" + menudata[i].iMenuID + "' class='easyui-menu'>" + htmlMenu + "</div>";
            $("#theBody").append(htmlMenu);
            $("#mm" + menudata[i].iMenuID).menu({
                onClick: function (item) {
                    if (item.sFilePath) {
                        selectMenu(item);
                    }
                }
            });
        }
        $("#btn" + menudata[i].iMenuID).menubutton({
            menu: htmlMenu == "" ? "" : "#mm" + menudata[i].iMenuID,
            iconCls: htmlMenu == "" ? "icon-link" : "icon-dire",
            hasDownArrow: false
        });
    }
    //$.parser.parse('#divMenu');
}
function topMenuClick() {
    var id = this.id;
    var menuId = this.id.substr(3);
    for (var i = 0; i < menuData.length; i++) {
        if (menuData[i].Id == menuId) {
            menuData[i].state = "open";
        } else {
            menuData[i].state = "close";
        }
    }
    $("#divMenu").sidemenu({ data: menuData });
    /*var theMenu=menuData.filter(function (p) {
        return p.id==menuId;
    });*/
    /*if(theMenu.length>0){
        $("#divMenu").sidemenu("collapse");
        $("#divMenu").sidemenu("expand");
    }*/
}

function selectMenu(node) {
    var menuName = node.sMenuName;
    var menuUrl = node.sFilePath;
    var menuId = node.iMenuID;
    var billId = node.iFormID;
    if (!$("#divTab").tabs("exists", menuName)) {
        if (menuUrl) {
            //var icon = node.iconCls == undefined || node.iconCls == "" || node.iconCls == null ? "icon-job" : node.iconCls;
            var sparms = node.sParms ? node.sParms.replace(/&amp;/g, "&").replace(/'/g, "") : "";
            var src = node.sFilePath + "?r=" + Math.random() + "&MenuTitle=" + escape(node.sMenuName) + "&MenuID=" + node.iMenuID + "&FormID=" + node.iFormID + sparms;
            $("#divTab").tabs("add", {
                id: node.menuId,
                title: node.text,
                //href: node.attributes.sFilePath + "&MenuID="+node.id+"&FormID=" + node.attributes.iFormID+node.attributes.sParms,
                closable: true,
                iconCls: "icon-job",
                content: "<iframe id='ifr" + node.iMenuID + "' name='ifr" + node.iMenuID + "' width='100%' height='100%' frameborder='0'  src='" + src + "' style='width:100%;height:100%;vertical-align:top;'></iframe>"
            })
        }
        //if (node.state) {
        //    if (node.state == "closed") {
        //        $(this).tree("expand", node.target);
        //    }
        //    else {
        //        $(this).tree("collapse", node.target);
        //    }
        //}
    }
    else {
        $("#divTab").tabs("select", menuName);
    }
    //menuUrl = menuUrl + "?menuid=" + menuId + "&billid=" + billId;
    //if ($("#divTab").tabs("exists", menuName)) {
    //    $("#divTab").tabs("select", menuName);
    //} else {
    //    $("#divTab").tabs("add", {
    //        title: menuName,
    //        content: "<iframe width='100%' height='100%' style='vertical-align:top;' frameborder='0' src='" + menuUrl + "' />",
    //        selected: true,
    //        border: false,
    //        closable: true
    //    });
    //}
}
function reloadMenu() {
    var userInfoStr = getUserInfo("userInfo");
    var userInfo = JSON.parse(userInfoStr);
    getUserMenu(userInfo.Id, function (result) {
        menuData = formatMenuData(result);
        $("#divMenu").sidemenu({ data: menuData });
        loadTopMenu(menuData);
    });
}
function formatMenuData(userMenuData) {
    for (var i = 0; i < userMenuData.length; i++) {
        userMenuData[i].text = userMenuData[i].sMenuName;
        userMenuData[i].state = "close";
    }
    var menuData = JsonArrayToTreeData1(userMenuData, "iParentMenuId", "iMenuID");
    var funcIcon = function (theMenuData) {
        for (var i = 0; i < theMenuData.length; i++) {
            if (theMenuData[i].children && theMenuData[i].children.length > 0) {
                theMenuData[i].iconCls = 'icon-dire';
                for (var j = 0; j < theMenuData[i].children.length; j++) {
                    funcIcon(theMenuData[i].children);
                }
            } else if (theMenuData[i].sFilePath) {
                theMenuData[i].iconCls = 'icon-link';
            }
        }
    };
    funcIcon(menuData);
    return menuData;
}
function signout() {
    //PlayVoiceTTS("这是测试看看行不行的广开言路。");
    if (confirm("确认注销？")) {
        $.ajax({
            url: "ashx/LoginOut.ashx",
            type: "get",
            async: false,
            success: function (result) {
                window.location.href = result;
            }
        });
    }
}

/*兼容处理 低版本IE*/
//
Array.prototype.find || (Array.prototype.find = function (predicate) {
    if (this == null) {
        throw new TypeError('Array.prototype.find called on null or undefined');
    }
    if (typeof predicate !== 'function') {
        throw new TypeError('predicate must be a function');
    }
    var list = Object(this);
    var length = list.length || 0;
    var thisArg = arguments[1];
    var value;

    for (var i = 0; i < length; i++) {
        value = list[i];
        if (predicate.call(thisArg, value, i, list)) {
            return value;
        }
    }
    return null;
})

function buildChildrenMenu(menuid, usermenus) {
    var childrenMenus = usermenus.filter(function (p) {
        return p.iParentMenuId == menuid;
    });
    var result = "";
    if (childrenMenus.length > 0) {
        for (var i = 0; i < childrenMenus.length; i++) {
            result += "<div";
            var iconCls = "icon-dire";
            var cmenuid = childrenMenus[i].iMenuID;
            var theGrandSon = usermenus.find(function (p) {
                return p.iParentMenuId == cmenuid;
            });
            if (theGrandSon) {
                result += " data-options='iconCls:\"" + iconCls + "\"'>";
                //result += ">";
                result += "<span>" + childrenMenus[i].sMenuName + "</span>";
                result += "<div>";
                result += buildChildrenMenu(cmenuid, usermenus);
                result += "</div>";
                result += "</div>";
            } else {
                //if (childrenMenus[i].Url) {
                iconCls = "icon-link";
                //}
                result += " data-options='iconCls:&quot;" + iconCls + "&quot;,Id:" + childrenMenus[i].iMenuID + ",ParentSysMenuId:" + childrenMenus[i].iParentMenuId + ",Url:&quot;" + childrenMenus[i].sFilePath + "&quot;,SysBillId:" + childrenMenus[i].iFormID + ",Name:&quot;" + childrenMenus[i].sMenuName + "&quot;'>" + childrenMenus[i].sMenuName + "</div>";
            }
        }
    }
    return result;
}
function changepwd() {
    if ($("#formChangePwd").form("validate")) {
        var oldPwd = $("#txtPassword1").passwordbox("getValue");
        var newPwd = $("#txtPassword2").passwordbox("getValue");
        var confirmPwd = $("#txtPassword3").passwordbox("getValue");
        if (newPwd != confirmPwd) {
            message("错误", "新密码与确认密码不一致", true);
            return;
        }
        var data = { oldPwd: oldPwd, newPwd: newPwd };
        $.ajax({
            url: "/Base/ChangePsd.aspx?otype=changepw&oldpsd=" + oldPwd + "&newpsd=" + newPwd,
            type: "get",
            async: false,
            success: function (result) {
                if (result == "1") {
                    message("成功", "修改成功", false, true);
                    $("#divChangePwd").window("close");
                } else {
                    message("失败", result, true);
                }
            },
            error: function (xhr) {
                var errorMessage = xhr.responseJSON ? JSON.stringify(xhr.responseJSON.errors) : xhr.responseText;
                errorMessage = errorMessage ? errorMessage : xhr.statusText;
                message("失败", errorMessage, true);
            }
        })
    }
}
function closeTab() {
    var tab = $("#divTab").tabs("getSelected");
    if (tab) {
        var index = $('#divTab').tabs('getTabIndex', tab);
        $("#divTab").tabs("close", index);
    }
}

function showTabMenu(e, title, index) {
    e.preventDefault();
    if (index > 0) {
        $('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        }).data("tabTitle", title);
    }
}
function tabMenuClick(item) {
    tabMenuItemClick(this, item.name);
}
function tabMenuItemClick(menu, type) {
    var allTabs = $("#divTab").tabs('tabs');
    var allTabtitle = [];
    $.each(allTabs, function (i, n) {
        var opt = $(n).panel('options');
        if (opt.closable)
            allTabtitle.push(opt.title);
    });
    var curTabTitle = $(menu).data("tabTitle");
    var curTabIndex = $("#divTab").tabs("getTabIndex", $("#divTab").tabs("getTab", curTabTitle));

    var currentTab = $('#divTab').tabs('getSelected');
    switch (type) {
        case "1": //关闭当前
            $("#divTab").tabs("close", curTabTitle);
            return false;
            break;
        case "2": //全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                $('#divTab').tabs('close', allTabtitle[i]);
            }
            break;
        case "3": //除此之外全部关闭
            for (var i = 0; i < allTabtitle.length; i++) {
                if (curTabTitle != allTabtitle[i])
                    $('#divTab').tabs('close', allTabtitle[i]);
            }
            $('#divTab').tabs('select', curTabTitle);
            break;
        case "4": //当前侧面右边
            for (var i = curTabIndex; i < allTabtitle.length; i++) {
                $('#divTab').tabs('close', allTabtitle[i]);
            }
            $('#divTab').tabs('select', curTabTitle);
            break;
        case "5": //当前侧面左边
            for (var i = 0; i < curTabIndex - 1; i++) {
                $('#divTab').tabs('close', allTabtitle[i]);
            }
            $('#divTab').tabs('select', curTabTitle);
            break;
        case "6": //刷新
            var iframe = $(currentTab.panel('options').content);
            if (iframe) {
                var iframeID = iframe.attr("id");
                var id;
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
                $('#divTab').tabs('update', {
                    tab: currentTab,
                    options: {
                        content: createFrame(src, "ifr" + id)
                    }
                })
            } else {

            }
            break;
    }
}