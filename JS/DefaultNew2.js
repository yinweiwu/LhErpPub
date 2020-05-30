var firstMenu=[];
var allMenu = [];
$(function () {
    firstMenu = GetMainMenu(false);
    for (var i = 0; i < firstMenu.length; i++) {
        allMenu.push(firstMenu[i]);
        var sIcon = firstMenu[i].sIcon ? firstMenu[i].sIcon : "";
        var li = $('<li class=""></li>');
        $(".page-sidebar-menu").append(li);
        li.append('<a href="javascript:;"><i class="' + sIcon + '"></i><span class="title">' + firstMenu[i].sMenuName + '</span><span class="arrow "></span></a>');
        var subTwoMenuData = GetSubMenu(firstMenu[i].iMenuID, false);
        var subTwoMenu = subTwoMenuData.ds;
        if (subTwoMenu.length > 0) {
            var ulSubTwo = $('<ul class="sub-menu"></ul>');
            li.append(ulSubTwo);
            for (var j = 0; j < subTwoMenu.length; j++) {
                allMenu.push(subTwoMenu[j]);
                var liTwo = $("<li></li>");
                ulSubTwo.append(liTwo);
                var subThreeMenuData = GetSubMenu(subTwoMenu[j].iMenuID, false);
                var subThreeMenu = subThreeMenuData.ds;
                var hasChild=false;
                if (subThreeMenu.length > 0) {
                    hasChild=true;
                }
                if (hasChild) {
                    liTwo.append('<a href="javascript:;">' + subTwoMenu[j].sMenuName + '<span class="arrow"></span></a>');
                    var ulSubThree = $('<ul class="sub-menu"></ul>');
                    liTwo.append(ulSubThree);
                    for (var k = 0; k < subThreeMenu.length; k++) {
                        allMenu.push(subThreeMenu[k]);
                        ulSubThree.append('<li><a href="javascript:;" onclick="MenuClickOne(' + subThreeMenu[k].iMenuID + ')">' + subThreeMenu[k].sMenuName + '</a></li>');
                    }

                } else {
                    liTwo.append('<a href="javascript:;" onclick="MenuClickOne(' + subTwoMenu[j].iMenuID + ')">' + subTwoMenu[j].sMenuName + '</a>');
                }
            }
        }
    }
})

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

function MenuClickOne(id) {
    for (var i = 0; i < allMenu.length; i++) {
        if (allMenu[i].iMenuID == id) {
            var _node = { attributes: {} };
            _node.text = allMenu[i].sMenuName;
            _node.attributes.sFilePath = allMenu[i].sFilePath;
            _node.iconCls = allMenu[i].sIcon;
            _node.attributes.sParms = allMenu[i].sParms == null || allMenu[i].sParms == undefined ? "" : allMenu[i].sParms;
            _node.id = allMenu[i].iMenuID;
            _node.attributes.iFormID = allMenu[i].iFormID;
            //console.log(_node);
            MenuClick(_node);
            break;
        }
    }
}
function MenuClick(node, isCommon) {
    if (!$("#divTabs").tabs("exists", node.text)) {
        if (node.attributes.sFilePath != "") {
            var icon = node.iconCls == undefined || node.iconCls == "" || node.iconCls == null ? "icon-job" : node.iconCls;
            var sparms = node.attributes.sParms.replace(/&amp;/g, "&").replace(/'/g, "");
            var src = node.attributes.sFilePath + "?MenuTitle=" + escape(node.text) + "&MenuID=" + node.id + "&FormID=" + node.attributes.iFormID + sparms;
            $("#divTabs").tabs("add", {
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
        $("#divTabs").tabs("select", node.text);
    }
}