//var tokenStr = getTokenFull();
//if (tokenStr == null || tokenStr == undefined || tokenStr == "") {
//    var returnUrl = window.location.pathname;
//    if (typeof (LoginUrl) == "undefined") {
//        window.location.href = "/pages/login.html?returnurl=" + returnUrl;
//    }
//    else {
//        window.location.href = LoginUrl + "?returnurl=" + returnUrl;
//    }
//}
//var jwtToken = JSON.parse(tokenStr);
////获取过期的时间戳
//var expireTime = jwtToken.AccessTokenExpired;
////获取刷新的时间戳
//var refreshExpireTime = jwtToken.RefreshTokenExpired;
////获取当前的时间戳
//var timestampNow = (new Date()).valueOf();
////如果过期了，在判断刷新token是否也过期了
//if (timestampNow >= expireTime) {
//    if (timestampNow >= refreshExpireTime) {
//        //都过期了则跳转到登录界面
//        var returnUrl = window.location.pathname;
//        window.location.href = "/pages/login.html?returnurl=" + returnUrl;
//    } else {
//        //刷新token
//        refreshToken();
//    }
//}
//tokenStr = null;
//jwtToken = null;
//expireTime = null;
//timestampNow = null;

function getTokenFull() {
    var tokenStr = localStorage.getItem("jwtToken");
    if (tokenStr == null || tokenStr == undefined || tokenStr == "") {
        tokenStr = sessionStorage.getItem("jwtToken");
        //var accessToken = tokenObj.accessToken;
    }
    return tokenStr;
}

function getToken() {
    var tokenStr = getTokenFull();//localStorage.getItem("accessToken");
    if (tokenStr) {
        return JSON.parse(tokenStr).AccessToken;
    }
    return tokenStr;
}
function refreshToken() {
    var tokenFullStr = getTokenFull();
    if (tokenFullStr) {
        var jwtToken = JSON.parse(tokenFullStr);
        var refreshToken = { RefreshToken: jwtToken.RefreshToken, AccessToken: jwtToken.AccessToken };
        var result1 = false;
        requestAjax("/api/refreshToken", "post", false, refreshToken,
            function (result) {
                result1 = true;
                //刷新请求只会保存在sessionStorage,关闭后必须重新登录
                sessionStorage.setItem("jwtToken", JSON.stringify(result));
                localStorage.removeItem("jwtToken");
                localStorage.removeItem("rememberMe");
                //var isRememberMe = localStorage.getItem("rememberMe") == "1" ? true : false;
                //if (isRememberMe) {
                //    localStorage.setItem("jwtToken", JSON.stringify(result));
                //    localStorage.setItem("rememberMe", "1");

                //    sessionStorage.removeItem("jwtToken");
                //} else {
                //    sessionStorage.setItem("jwtToken", JSON.stringify(result));
                //    localStorage.removeItem("jwtToken");
                //    localStorage.removeItem("rememberMe");
                //}
            }, false, null, false);
        return result1;
    }
    return false;
}

function getUserName() {
    var userName = localStorage.getItem("userName");//localStorage.getItem("accessToken");
    if (userName == null) {
        userName = sessionStorage.getItem("userName");
    }
    return userName;
}
function getUserInfo() {
    var userInfo = localStorage.getItem("userInfo");//localStorage.getItem("accessToken");
    if (userInfo == null) {
        userInfo = sessionStorage.getItem("userInfo");
    }
    return userInfo;
}


$(function () {
    $("body").bind("click", function (event) {
        // if($(event.target).hasClass("datagrid-row-selected")||$(event.target).hasClass("datagrid-cell")){
        //     return;
        // }
        // try {
        //     $(".datagrid-f").each(function(index,el){
        //         var edittingCell= $(el).datagrid("cell");
        //         if(edittingCell){
        //             $(el).datagrid("endEdit",edittingCell.index);
        //         }
        //     });
        // }catch(e){
        //
        // }

    });
});

$.fn.serializeObject = function (arrayToStr, arraySplit) {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
        if (o[this.name]) {
            if (arrayToStr) {
                split = arraySplit ? arraySplit : ",";
                o[this.name] = o[this.name] + split + (this.value || '');
            } else {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            }
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

function message(title, message, isRed, autohide) {
    if (autohide) {
        $.messager.show({
            title: title,
            msg: (isRed ? "<span style='color: red;font-weight: bold;'>" + message + "</span>" : "<span style='color:#00BFFF;font-size:18px;font-weight:bold;'>" + message + "</span>"),
            showType: 'slide',
            style: {
                right: '',
                bottom: ''
            }
        });
    } else {
        $.messager.alert(title, (isRed ? "<span style='color: red;font-weight: bold;'>" + message + "</span>" : "<span style='color:#00BFFF;font-size:18px;font-weight:bold;'>" + message + "</span>"));
    }
}

/*将一般的JSON格式转为EasyUI TreeGrid树控件的JSON格式
* @param rows:json数据对象
* @param idFieldName:表id的字段名
* @param pidFieldName:表父级id的字段名
* @param fileds:要显示的字段,多个字段用逗号分隔
* 
*/
function ConvertToTreeJson(rows, idFieldName, pidFieldName, fileds) {
    function exists(rows, ParentId) {
        for (var i = 0; i < rows.length; i++) {
            if (rows[i][idFieldName] == ParentId)
                return true;
        }
        return false;
    }
    var nodes = [];
    // get the top level nodes
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (!exists(rows, row[pidFieldName])) {
            var data = {
                id: row[idFieldName]
            };
            var arrFiled = fileds.split(",");
            for (var j = 0; j < arrFiled.length; j++) {
                if (arrFiled[j] != idFieldName)
                    data[arrFiled[j]] = row[arrFiled[j]];
            }
            nodes.push(data);
        }
    }
    // console.info("根目录nodes："+JSON.stringify(nodes));

    var toDo = [];
    for (var i = 0; i < nodes.length; i++) {
        toDo.push(nodes[i]);
    }

    while (toDo.length) {
        var node = toDo.shift(); // the parent node
        // get the children nodes
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            if (row[pidFieldName] == node.id) {
                var child = {
                    id: row[idFieldName]
                };
                var arrFiled = fileds.split(",");
                for (var j = 0; j < arrFiled.length; j++) {
                    if (arrFiled[j] != idFieldName) {
                        child[arrFiled[j]] = row[arrFiled[j]];
                    }
                }
                if (node.children) {
                    node.children.push(child);
                } else {
                    node.children = [child];
                }
                toDo.push(child);
            }
        }
    }
    return nodes;
}
/*将一般的json数组转为easyui tree控件的格式
* @param data：原数组
* @param pField:父字段
* @param cField:子字段
 * 必须按照pidFieldName，排序字段 排序好
 * */
function JsonArrayToTreeData(data, pField, cField) {
    var dataProcess = data.filter(function () {
        return 1 == 1;
    });

    for (var i = 0; i < dataProcess.length;) {
        var theValue = dataProcess[i][(cField)];
        var returnObj = GetChildrenData(dataProcess, pField, cField, theValue, i);
        if (returnObj.dataC.length > 0) {
            //这时dataProcess数组已经改变了，下标i也不一样了
            dataProcess[returnObj.index].children = returnObj.dataC;
            i = returnObj.index;
        }
        i++;
    }
    return dataProcess;
}

function GetChildrenData(data, pField, cFiled, value, theIndex) {
    var returnResult = { index: theIndex, dataC: [] };//index是变化后的下标，dataC是所有子元素
    for (var i = 0; i < data.length; i++) {
        if (data[i][(pField)] == value) {
            returnResult.dataC.push(data[i]);
            data.splice(i, 1);
            if (returnResult.index > i) {//如果原下标在i之前，则不用改变；如果在之后，则要相应减1
                returnResult.index--;
            }
            i--;
        }
    }
    if (returnResult.dataC.length > 0) {
        for (var i = 0; i < returnResult.dataC.length; i++) {
            var theValue = returnResult.dataC[i][(cFiled)];
            var returnObj = GetChildrenData(data, pField, cFiled, theValue, i);
            if (returnObj.dataC.length > 0) {
                returnResult.dataC[returnObj.index].children = returnObj.dataC;
                i = returnObj.index;
            }
            i++;
        }
    }
    return returnResult;
}

function JsonArrayToTreeData1(data, pField, cField) {
    var dataRoot = data.filter(function (p) {
        return p[pField] == null || p[pField] == 0;
    });
    for (var i = 0; i < dataRoot.length; i++) {
        var theValue = dataRoot[i][cField];
        var children = GetChildrenData1(data, pField, cField, theValue, i);
        if (children && children.length > 0) {
            dataRoot[i].children = children;
        }
    }
    return dataRoot;
    //for (var i = 0; i < dataProcess.length;) {
    //    var theValue = dataProcess[i][(cFiled)];
    //    var returnObj = GetChildrenData(dataProcess, pField, cFiled, theValue, i);
    //    if (returnObj.dataC.length > 0) {
    //        //这时dataProcess数组已经改变了，下标i也不一样了
    //        dataProcess[returnObj.index].children = returnObj.dataC;
    //        i = returnObj.index;
    //    }
    //    i++;
    //}
    //return dataProcess;
}
function GetChildrenData1(data, pField, cField, parentValue) {
    var dataChildren = data.filter(function (p) {
        return p[pField] == parentValue;
    });
    for (var i = 0; i < dataChildren.length; i++) {
        var theValue = dataChildren[i][cField];
        var children = GetChildrenData1(data, pField, cField, theValue, i);
        if (children && children.length > 0) {
            dataChildren[i].children = children;
        }
    }
    return dataChildren;
}

//后台请求返回对象
var RequestRuest = {
    createNew: function () {
        var requestResult = {
            success: null,
            message: ""
        };
        return requestResult;
    }
};

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

function getType(obj) {
    //tostring会返回对应不同的标签的构造函数
    var toString = Object.prototype.toString;
    var map = {
        '[object Boolean]': 'boolean',
        '[object Number]': 'number',
        '[object String]': 'string',
        '[object Function]': 'function',
        '[object Array]': 'array',
        '[object Date]': 'date',
        '[object RegExp]': 'regExp',
        '[object Undefined]': 'undefined',
        '[object Null]': 'null',
        '[object Object]': 'object'
    };
    if (obj instanceof Element) {
        return 'element';
    }
    return map[toString.call(obj)];
}

function deepClone(data) {
    var type = getType(data);
    var obj;
    if (type === 'array') {
        obj = [];
    } else if (type === 'object') {
        obj = {};
    } else {
        //不再具有下一层次
        return data;
    }
    if (type === 'array') {
        for (var i = 0, len = data.length; i < len; i++) {
            obj.push(deepClone(data[i]));
        }
    } else if (type === 'object') {
        for (var key in data) {
            obj[key] = deepClone(data[key]);
        }
    }
    return obj;
}
// 下划线转换驼峰
function linetoCame(name) {
    return name.replace(/\_(\w)/g, function (all, letter) {
        return letter.toUpperCase();
    });
}
// 驼峰转换下划线
function cametoLine(name) {
    return name.replace(/([A-Z])/g, "_$1").toLowerCase();
}

//获取今天日期：格式2015-01-01
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
//获取当前时时
function getNowTime() {
    var nowdate = new Date();
    var hour = nowdate.getHours();      //获取当前小时数(0-23)
    hour = hour < 10 ? ("0" + hour) : hour;
    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
    minute = minute < 10 ? ("0" + minute) : minute;
    var second = nowdate.getSeconds();
    second = second < 10 ? ("0" + second) : second;
    return hour + ":" + minute + ":" + second;
}

if ($.messager) {
    $.extend($.fn.treegrid.methods, {
        //iscontains是否包含父节点（即子节点被选中时是否也取父节点）
        getAllChecked: function (jq, iscontains) {
            var keyValues = [];
            /*
              tree-checkbox2 有子节点被选中的css
              tree-checkbox1 节点被选中的css
              tree-checkbox0 节点未选中的css
            */
            var checkNodes = jq.treegrid("getPanel").find(".tree-checkbox1");
            for (var i = 0; i < checkNodes.length; i++) {
                var keyValue1 = $($(checkNodes[i]).closest('tr')[0]).attr("node-id");
                keyValues.push(keyValue1);
            }

            if (iscontains) {
                var childCheckNodes = jq.treegrid("getPanel").find(".tree-checkbox2");
                for (var i = 0; i < childCheckNodes.length; i++) {
                    var keyValue2 = $($(childCheckNodes[i]).closest('tr')[0]).attr("node-id");
                    keyValues.push(keyValue2);
                }
            }
            return keyValues;
        }
    });
}

function getEasyuiObj(formid, name) {
    try {
        var obj = $("#" + formid + " input[name='" + name + "']").parent().prev();
        return obj;
    } catch (e) {
        return null;
    }
}
function getEasyuiObjValue(formid, name, isArray) {
    var value = null;
    var obj = getEasyuiObj(formid, name);
    if (obj) {
        var className = obj.attr("class");
        if (className) {
            className = className.toLocaleLowerCase();
            if (className.indexOf("textbox-f") > -1 || className.indexOf("easyui-textbox") > -1) {
                value = obj.textbox("getValue");
            } else if (
                className.indexOf("combobox-f") > -1
                || className.indexOf("easyui-combobox") > -1
                || className.indexOf("combotree-f") > -1
                || className.indexOf("easyui-combotree") > -1
                || className.indexOf("combogrid-f") > -1
                || className.indexOf("easyui-combogrid") > -1) {
                if (isArray) {
                    value = obj.combobox("getValues");
                } else {
                    value = obj.combobox("getValue");
                }
            } else if (className.indexOf("numberbox-f") > -1 || className.indexOf("easyui-numberbox") > -1) {
                value = obj.numberbox("getValue");
            } else if (className.indexOf("datebox-f") > -1 || className.indexOf("easyui-datebox") > -1) {
                value = obj.datebox("getValue");
            } else if (className.indexOf("datetimebox-f") > -1 || className.indexOf("easyui-datetimebox") > -1) {
                value = obj.datetimebox("getValue");
            } else if (className.indexOf("numberspinner-f") > -1 || className.indexOf("easyui-numberspinner") > -1) {
                value = obj.numberspinner("getValue");
            } else if (className.indexOf("checkbox-f") > -1 || className.indexOf("easyui-checkbox") > -1) {
                //obj = $("input[name='" + name + "']")[0].checked;
                value = $("input[name='" + name + "']")[0].checked;
            } else if (className.indexOf("radiobutton-f") > -1 || className.indexOf("easyui-radiobutton") > -1) {
                value = $("input[name='" + name + "']:checked").val();
            } else {
                value = $("input[name='" + name + "']").val();
            }
        } else {
            value = $("input[name='" + name + "']").val();
        }
    }
    return value;
}

function setEasyuiObjValue(formid, name, value, isArray) {
    var obj = getEasyuiObj(formid, name);
    if (obj) {
        var className = obj.attr("class");
        if (className) {
            className = className.toLocaleLowerCase();
            if (className.indexOf("textbox-f") > -1 || className.indexOf("easyui-textbox") > -1) {
                value = obj.textbox("setValue", value);
            } else if (className.indexOf("combobox-f") > -1 || className.indexOf("easyui-combobox") > -1) {
                if (isArray) {
                    obj.combobox("setValues", value);
                } else {
                    obj.combobox("setValue", value);
                }
            } else if (className.indexOf("combotree-f") > -1 || className.indexOf("easyui-combotree") > -1) {
                if (isArray) {
                    obj.combobox("setValues", value);
                } else {
                    obj.combobox("setValue", value);
                }
            }
            else if (className.indexOf("combogrid-f") > -1 || className.indexOf("easyui-combogrid") > -1) {
                if (isArray) {
                    obj.combobox("setValues", value);
                } else {
                    obj.combobox("getValues", value);
                }
            } else if (className.indexOf("numberbox-f") > -1 || className.indexOf("easyui-numberbox") > -1) {
                obj.numberbox("setValue", value);
            } else if (className.indexOf("datebox-f") > -1 || className.indexOf("easyui-datebox") > -1) {
                obj.datebox("setValue", value);
            } else if (className.indexOf("datetimebox-f") > -1 || className.indexOf("easyui-datetimebox") > -1) {
                obj.datetimebox("setValue", value);
            } else if (className.indexOf("numberspinner-f") > -1 || className.indexOf("easyui-numberspinner") > -1) {
                obj.numberspinner("setValue", value);
            } else if (className.indexOf("checkbox-f") > -1 || className.indexOf("easyui-checkbox") > -1) {
                //obj = $("input[name='" + name + "']")[0].checked;
                obj.checkbox("setValue", value);
            } else if (className.indexOf("radiobutton-f") > -1 || className.indexOf("easyui-radiobutton") > -1) {
                obj.radiobutton("setValue", value);
            } else {
                $("input[name='" + name + "']").val(value);
            }
        }
    }
}

function newGuid() {
    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function requestAjax(url, type, isAsync, param, successFun, isRedirectToLogin, errorFun, withToken) {
    withToken = withToken ? withToken : true;
    if (typeof (ServerUrl) != "undefined") {
        url = ServerUrl + (url[0] == "/" ? url : "/" + url);
    }
    type = type ? type : "get";
    isAsync = isAsync ? isAsync : false;
    var accessToken = getToken();
    $.ajax({
        headers: withToken ? {
            Authorization: "Bearer " + accessToken
        } : null,
        url: url,
        type: type,
        contentType: type == "patch" ? "application/json-patch+json" : "application/json",
        async: isAsync,
        data: type == "post" || type == "patch" ? (typeof param == "object" ? JSON.stringify(param) : param) : param,
        dataType: "json",
        success: function (result, status, xhr) {
            if (successFun) {
                successFun(result, status, xhr);
            }
        },
        error: function (xhr) {
            if (errorFun) {
                var errorMessage = xhr.responseJSON ? JSON.stringify(xhr.responseJSON.errors) : xhr.responseText;
                errorMessage = errorMessage ? errorMessage : xhr.statusText;
                errorFun(xhr, errorMessage);
            } else {
                if (xhr.status == 401) {
                    if (xhr.getResponseHeader('act') == 'expired') {
                        if (refreshToken()) {
                            requestAjax(url, type, isAsync, param, successFun, isRedirectToLogin, errorFun, withToken);
                            return;
                        }
                    }
                    if (isRedirectToLogin) {
                        if (typeof (LoginUrl) == "undefined") {
                            window.location.href = "/pages/login.html?returnurl=" + window.location.pathname;
                        } else {
                            window.location.href = LoginUrl;
                        }
                    }
                }
                var errorMessage = xhr.responseJSON ? JSON.stringify(xhr.responseJSON.errors) : xhr.responseText;
                errorMessage = errorMessage ? errorMessage : xhr.statusText;
                if ($.messager) {
                    message(xhr.status + " " + xhr.statusText, errorMessage, true);
                } else {
                    document.write(xhr.status + " " + xhr.statusText + ":" + errorMessage);
                }
            }
        }
    });
}
function requestAjaxCustom(options, withToken) {
    if (withToken) {
        var accessToken = getToken();
        options.headers = withToken ? {
            Authorization: "Bearer " + accessToken
        } : null
    }
    $.ajax(options);
}

function execStoredProcedure(sysbillid, storedproceducrename, parameter, isAsync, successFn, errorFn) {
    var result = null;
    requestAjax("/api/bill/" + sysbillid + "/storedprocedure/" + storedproceducrename, "post", isAsync ? true : false, { parameter: parameter },
        function (requResult) {
            result = requResult;
            if (successFn) {
                successFun(result);
            }
        }, false, function (xhr, errorMsg) {
            if (errorFn) {
                errorFn(xhr, errorMsg);
            }
        });
    return result;
}

//function getQueryString(name) {
//    var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
//    var r = window.location.search.substr(1).match(reg);
//    if (r != null) {
//        return unescape(r[2]);
//    }
//    return null;
//}

//字段类型数组，与后台枚举一致
var fieldTypeData = [
    { value: 1, text: "字符串" },
    { value: 2, text: "整数" },
    { value: 3, text: "数据" },
    { value: 4, text: "日期" },
    { value: 5, text: "日期时间" },
    { value: 6, text: "时间" },
    { value: 7, text: "布尔" },
    { value: 8, text: "附件" },
    { value: 9, text: "图片" },
    { value: 10, text: "备注" }
];
//字段类型枚举
var FieldTypeEnum = { 字符串: 1, 整数: 2, 数据: 3, 日期: 4, 日期时间: 5, 时间: 6, 布尔: 7, 附件: 8, 图片: 9, 备注: 10 };
$.each(fieldTypeData, function (index, e) {
    FieldTypeEnum[(e.text)] = e.value;
});
//汇总类型数组
var summaryTypeData = [
    { text: "无", value: 1, short: '无' },
    { text: "求和", value: 2, short: 'Σ' },
    { text: "求平均", value: 3, short: '平' },
    { text: "最大值", value: 4, short: '大' },
    { text: "最小值", value: 5, short: '小' },
    { text: "求个数", value: 6, short: '个' }
];
//汇总类型枚举
var SummaryTypeEnum = {};
$.each(summaryTypeData, function (index, e) {
    SummaryTypeEnum[(e.text)] = e.value;
});
//列对齐方式数组
var columnAlign = [
    { value: 1, text: "居中", code: "center" },
    { value: 2, text: "左对齐", code: "left" },
    { value: 3, text: "右对齐", code: "right" }
];
//列对齐方式枚举
var ColumnAlignEnum = {};
$.each(columnAlign, function (index, e) {
    ColumnAlignEnum[(e.text)] = e.value;
});
//菜单单元形式
var menuClaimType = [
    { value: 1, text: "按钮" },
    { value: 2, text: "功能" },
    { value: 3, text: "输入框" }
];
//菜单单元形式枚举
var MenuClaimTypeEnum = { 按钮: 1, 功能: 2, 输入框: 3 };
$.each(menuClaimType, function (index, e) {
    MenuClaimTypeEnum[(e.text)] = e.value;
});
//请求方式数组
var requestMethod = [
    { value: 1, text: "get" },
    { value: 2, text: "post" },
    { value: 3, text: "patch" },
    { value: 4, text: "delete" },
    { value: 5, text: "put" },
    { value: 6, text: "options" },
    { value: 7, text: "head" }
];
//请求方式枚举
var RequestMethodEnum = {};
$.each(requestMethod, function (index, e) {
    RequestMethodEnum[(e.text)] = e.value;
});
//lookup类型
var lookupType = [
    { value: 1, text: "弹窗" },
    { value: 2, text: "下拉值" },
    { value: 3, text: "下拉参照" },
    { value: 4, text: "下拉树" },
    { value: 5, text: "下拉表格" }
];
var lookupTypeEnum = { 弹窗: 1, 下拉值: 2, 下拉参照: 3, 下拉树: 4, 下拉表格: 5 };
$.each(lookupType, function (index, e) {
    lookupTypeEnum[(e.text)] = e.value;
});
//公式触发时间类型
var triggerType = [
    { value: 1, text: "修改时" },
    { value: 2, text: "增加保存前" },
    { value: 3, text: "增加保存后" },
    { value: 4, text: "修改保存前" },
    { value: 5, text: "修改保存后" },
    { value: 6, text: "保存前" },
    { value: 7, text: "保存后" }
];
var triggerTypeEnum = { 修改时: 1, 保存前: 2, 保存后: 3 };
$.each(triggerType, function (index, e) {
    triggerTypeEnum[(e.text)] = e.value;
});
var categoryType = [
    { value: 1, text: "单据" },
    { value: 2, text: "查询" }
];
var categoryTypeEnum = { 单据: 1, 查询: 2 };
$.each(categoryType, function (index, e) {
    categoryTypeEnum[(e.text)] = e.value;
});
var objectType = [
    { value: 1, text: "视图" },
    { value: 2, text: "表" },
    { value: 3, text: "存储过程" }
];
var objectTypeEnum = {};
$.each(objectType, function (index, e) {
    objectTypeEnum[(e.text)] = e.value;
});
var calcType = [
    { value: 1, text: "表达式" },
    { value: 2, text: "SQL语句" }
    //,
    //{ value: 3, text: "存储过程" }
];
var calcTypeEnum = {
    表达式: 1,
    SQL语句: 2,
    存储过程: 3
}
var opTypeEnum = {
    增加: "add",
    修改: "edit",
    浏览: "view"
}
var EditType = [{
    value: 1, text: "表单"
}, {
    value: 2, text: "表格"
}];
var EditTypeEnum = {
    表单: 1,
    表格: 2
};
var RelatedType = [{
    value: 1, text: "一对多"
}, {
    value: 2, text: "一对一"
}];
var RelatedTypeEnum = {
    一对多: 1,
    一对一: 2
};
var buttonPosion = [
    { value: 1, text: "工具栏" },
    { value: 2, text: "行尾" },
    { value: 3, text: "行首" },
    { value: 4, text: "字段上" }
];
var buttonPosionEnum = {
    工具栏: 1,
    行尾: 2,
    行首: 3,
    字段上: 4
};
var environmentVars = [
    { value: "$USERNAME$", text: "用户名" },
    { value: "$REALNAME$", text: "实际名" },
    { value: "$ROLES$", text: "用户角色" },
    { value: "$DATE$", text: "日期" },
    { value: "$DATETIME$", text: "日期时间" }
];
var environmentVarEnum = {
    用户名: "$USERNAME$",
    实际名: "$REALNAME$",
    用户角色: "$ROLES$"
};
var pluginType = [
    { value: "1", text: "功能型" },
    { value: "2", text: "服务型" }
];
var pluginTypeEnum = {
    功能型: 1,
    服务型: 2
};
var PageFieldStyle = [
    { value: 1, text: "一行1列" },
    { value: 2, text: "一行2列" },
    { value: 3, text: "一行3列" },
    { value: 4, text: "一行4列" }
];
var PageFieldStyleEnum = {
    一行1列: 1,
    一行2列: 2,
    一行3列: 3,
    一行4列: 4
};
var PageFieldStyle = [
    { value: 1, text: "一行1列" },
    { value: 2, text: "一行2列" },
    { value: 3, text: "一行3列" },
    { value: 4, text: "一行4列" }
];
var ShortcutTypeEnum = {
    共享: 1,
    FTP: 2,
    Web系统: 3,
    远程连接: 4,
    本地应用: 5
};

//计算表达式的值
function myeval(fn) {
    var Fn = Function;  //一个变量指向Function，防止有些前端编译工具报错
    return new Fn('return ' + fn)();
}
function myevalbody(fn) {
    var Fn = Function;  //一个变量指向Function，防止有些前端编译工具报错
    return new Fn(fn + "")();
}

function getFieldsFromStr(str) {
    var fields = [];
    var bindex = str.indexOf("{");
    while (bindex > -1) {
        var eindex = str.indexOf("}", bindex + 1);
        if (eindex > bindex) {
            var field = str.substr(bindex + 1, eindex - bindex - 1);
            if (field.indexOf(" ") > -1 || field.indexOf("\n") || field.indexOf(",") || field.indexOf(";") > -1) {
                bindex = str.indexOf("{", eindex + 1);
                //eindex = str.indexOf("}", bindex + 1);
            } else {
                fields.push(field);
                bindex = str.indexOf("{", eindex + 1);
                //eindex = str.indexOf("}", bindex + 1);
            }
        }
    }
    return fields;
}

function replaceFieldValue(str, data) {
    var bindex = str.indexOf("{");
    while (bindex > -1) {
        var eindex = str.indexOf("}", bindex + 1);
        if (eindex > bindex) {
            var field = str.substr(bindex + 1, eindex - bindex - 1);
            if (field.indexOf(" ") > -1 || field.indexOf("\n") > -1 || field.indexOf(",") > -1 || field.indexOf(";") > -1) {
                bindex = str.indexOf("{", eindex + 1);
            } else {
                var reg = new RegExp("{" + field + "}", "g");
                var value = data[(field)] == null || data[(field)] == undefined ? "" : data[(field)];
                str = str.replace(reg, value);
                bindex = str.indexOf("{");
                //eindex = str.indexOf("}", bindex + 1);
            }
        }
    }
    return str;
}

//获得输入框中字符长度
function getByteLength(val) {
    var str = new String(val);
    var bytesCount = 0;
    for (var i = 0, n = str.length; i < n; i++) {
        var c = str.charCodeAt(i);
        if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
            bytesCount += 1;
        } else {
            bytesCount += 2;
        }
    }
    return bytesCount;
}