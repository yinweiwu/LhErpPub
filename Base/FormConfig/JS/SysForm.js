var initjsonstr;
//新增
function oprateadd(url, parmsother) {
    if (checkvalue() != "1") {
        //document.getElementById("operatresult").value = checkvalue();
        return "error:" + checkvalue();
    }
    //主表
    //var querystr = "";
    //主表
    var mainData = {};
    var tablename = document.getElementById("tablename").value;
    var fieldkeys = document.getElementById("fieldkey").value;
    //var fieldkeysvalues = getQueryString("lsh");
    var queryaddpart1 = "";
    var queryaddpart2 = "";
    var queryupdatepart1 = "";
    var queryupdatepart2 = "";
    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    var select = document.getElementById("divmain").getElementsByTagName("SELECT");

    for (var i = 0; i < textarea.length; i++) {
        if (textarea[i].attributes["fieldid"] != undefined && textarea[i].attributes["fieldid"] != null && textarea[i].attributes["fieldid"].nodeValue.toUpperCase() != fieldkeys.toUpperCase() && textarea[i].id != "fieldkey") {
            //var objtype = textarea[i].type;
            var fieldid = textarea[i].attributes["fieldid"].nodeValue;
            //var fieldtype = textarea[i].attributes["fieldtype"].nodeValue;
            if (queryaddpart1.indexOf(fieldid) < 0) {
                queryaddpart1 += fieldid + ",";
                var value = textarea[i].value;
                //queryaddpart2 += value.replace(/%/g, "%25") + "<|>";
                mainData[(fieldid)] = value;
            }
        }
    }
    for (var i = 0; i < input.length; i++) {
        if (input[i].attributes["fieldid"] != undefined && input[i].attributes["fieldid"] != null && input[i].attributes["fieldid"].nodeValue.toUpperCase() != fieldkeys.toUpperCase() && input[i].id != "fieldkey") {
            var objtype = input[i].type;
            var fieldid = input[i].attributes["fieldid"].nodeValue;
            var value = "";
            queryaddpart1 += fieldid + ",";
            if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                value = input[i].value;
            }
            if (objtype == "checkbox") {
                value = input[i].checked == true ? "1" : "0";
                queryaddpart2 += value + "<|>";
            }
            mainData[(fieldid)] = value;
        }
    }
    for (var i = 0; i < select.length; i++) {
        if (select[i].attributes["fieldid"] != undefined && select[i].attributes["fieldid"] != null && select[i].attributes["fieldid"].nodeValue.length > 0 && select[i].id != "fieldkey") {
            var fieldid = select[i].attributes["fieldid"].nodeValue;
            queryaddpart1 += fieldid + ",";
            var value = select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
            if (document.getElementById(select[i].id + "_val")) {
                value = document.getElementById(select[i].id + "_val").value;
            }
            queryaddpart2 += value.replace(/%/g, "%25") + "<|>";
            mainData[(fieldid)] = value;
        }
    }
    if (queryaddpart1.length > 0) {
        queryaddpart1 = queryaddpart1.substr(0, queryaddpart1.length - 1);
        queryaddpart2 = queryaddpart2.substr(0, queryaddpart2.length - 3);
    }
    var operate = "add";
//    querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"add\",\"Fields\":\"" + queryaddpart1 + "\",\"FieldsValues\":\"" + queryaddpart2 + "\"," +
//                "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + document.getElementById("fieldkeyvalue").value + "\"}";
    var querystr = {
        TableName: tablename,
        Operatortype: "add",
        Data: mainData,
        FieldKeys: fieldkeys,
        FieldKeysValues: document.getElementById("fieldkeyvalue").value
    };
    //子表、孙子表
    var jsonchildren = [];
    var children = $("[isson='true']");
    for (var i = 0; i < children.length; i++) {
        var jsonobj = {};
        var tablename = children[i].attributes["tablename"].nodeValue;
        var linkfield = children[i].attributes["linkfield"].nodeValue;
        var fieldkey = children[i].attributes["fieldkey"].nodeValue;
        jsonobj.childtype = "son";
        jsonobj.tablename = tablename;
        jsonobj.linkfield = linkfield;
        jsonobj.fieldkey = fieldkey;
        var data;
        if (children[i].tagName == "DIV") {
            var grid = $("#" + children[i].id + "").ligerGrid();
            for (var r in grid.records) {
                grid.endEdit(r);
            }
            data = grid.getData();
            //只保存表中的列
            var sqltext = "SELECT Name from SysColumns WHERE id=Object_Id('" + tablename + "')";
            var tablefields = SqlGetDataComm(sqltext);
            for (var ic = 0; ic < data.length; ic++) {
                for (var key in data[ic]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                        }
                    }
                    if (exists == false) {
                        delete data[ic][key];
                    }
                }
            }

        }
        else if (children[i].tagName == "TABLE") {
            data = eval("(" + tabgetdata(children[i].id) + ")");
        }
        jsonobj.data = data;
        jsonchildren.push(jsonobj);
    }
    //var jsonchildren = [];
    //grandsondata存放孙子表数据
    var children = $("[isgrandson='true']");
    for (var i = 0; i < children.length; i++) {
        GrandsonEndEdit(children[i].id);
    }
    if (children.length > 0) {
        if (grandsondata.length > 0) {
            //var totaljson = [];
            jsonchildren = jsonchildren.concat(grandsondata);
            //jsonchildren = totaljson;
        }
    }
//    var parms = parmsother + "&mainquery=" + encodeURIComponent(querystr) + "&children=" + encodeURIComponent(JSON.stringify(jsonchildren));
//    var result = callpostback(url, parms, false, true);
//    return result;
    $.ajax({
        url: url,
        data: { mainquery: JSON2.stringify(querystr), children: JSON2.stringify(jsonchildren), from: "sysbillnocheck" },
        cache: false,
        type: "POST",
        async: false,
        success: function (data) {
            result = data;
        },
        error: function (data) {
            alert("与服务器连接失败！");
        }

    });
    return result;
}
//修改
function operateupdate(url, parmsother) {
    if (checkvalue() != "1") {
        //document.getElementById("operatresult").value = checkvalue();
        return "error:" + checkvalue();
    }
    var queryupdatepart1 = "";
    var queryupdatepart2 = "";
    //主表
    var mainData = {};
    var tablename = document.getElementById("tablename").value;
    var fieldkeys = document.getElementById("fieldkey").value;

    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    var select = document.getElementById("divmain").getElementsByTagName("SELECT");
    for (var i = 0; i < textarea.length; i++) {
        if (textarea[i].attributes["fieldid"] != undefined && textarea[i].attributes["fieldid"] != null && textarea[i].attributes["fieldid"].nodeValue.toUpperCase() != fieldkeys.toUpperCase() && textarea[i].id != "fieldkey") {
            var fieldid = textarea[i].attributes["fieldid"].nodeValue;
            queryupdatepart1 += fieldid + ",";
            var value = textarea[i].value;
            mainData[(fieldid)] = value;
        }
    }
    for (var i = 0; i < input.length; i++) {
        if (input[i].attributes["fieldid"] != undefined && input[i].attributes["fieldid"] != null && input[i].attributes["fieldid"].nodeValue.toUpperCase() != fieldkeys.toUpperCase() && input[i].id != "fieldkey") {
            var objtype = input[i].type;
            var fieldid = input[i].attributes["fieldid"].nodeValue;
            var value = "";
            queryupdatepart1 += fieldid + ",";
            if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                value = input[i].value;
                queryupdatepart2 += value + "<|>";
            }
            if (objtype == "checkbox") {
                value = input[i].checked == true ? "1" : "0";
                queryupdatepart2 += value + "<|>";
            }
            mainData[(fieldid)] = value;
        }
    }
    for (var i = 0; i < select.length; i++) {
        if (select[i].attributes["fieldid"] != undefined && select[i].attributes["fieldid"] != null && select[i].attributes["fieldid"].nodeValue.length > 0 && select[i].id != "fieldkey") {
            var fieldid = select[i].attributes["fieldid"].nodeValue;
            queryupdatepart1 += fieldid + ",";
            var value = select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
            if (document.getElementById(select[i].id + "_val")) {
                value = document.getElementById(select[i].id + "_val").value;
            }
            mainData[(fieldid)] = value;
        }
    }
    if (queryupdatepart1.length > 0) {
        queryupdatepart1 = queryupdatepart1.substr(0, queryupdatepart1.length - 1);
        queryupdatepart2 = queryupdatepart2.substr(0, queryupdatepart2.length - 3);
    }
//    var operate = "update";
//    querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"" + operate + "\",\"Fields\":\"" + queryupdatepart1 + "\",\"FieldsValues\":\"" + queryupdatepart2 + "\"," +
//    "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + document.getElementById("fieldkeyvalue").value + "\",\"FilterFields\":\"" + fieldkeys + "\",\"FilterComOprts\":\"=\",\"FilterValues\":\"" + document.getElementById("fieldkeyvalue").value + "\"}";
    var querystr = {
        TableName: tablename,
        Operatortype: "update",
        Data: mainData,
        FieldKeys: fieldkeys,
        FieldKeysValues: document.getElementById("fieldkeyvalue").value,
        FilterFields: fieldkeys,
        FilterComOprts: "=",
        FilterValues: document.getElementById("fieldkeyvalue").value
    };
    //子表、孙子表
    var jsonchildren = [];
    var children = $("[isson='true']");
    for (var i = 0; i < children.length; i++) {
        var jsonobj = {};
        var tablename = children[i].attributes["tablename"].nodeValue;
        var linkfield = children[i].attributes["linkfield"].nodeValue;
        var fieldkey = children[i].attributes["fieldkey"].nodeValue;
        jsonobj.childtype = "son";
        jsonobj.tablename = tablename;
        jsonobj.linkfield = linkfield;
        jsonobj.fieldkey = fieldkey;
        var data;
        if (children[i].tagName == "DIV") {
            var grid = $("#" + children[i].id + "").ligerGrid();
            for (var r in grid.records) {
                grid.endEdit(r);
            }
            data = grid.getData();

            //只保存表中的列
            var sqltext = "SELECT Name from SysColumns WHERE id=Object_Id('" + tablename + "')";
            var tablefields = SqlGetDataComm(sqltext);
            for (var ic = 0; ic < data.length; ic++) {
                for (var key in data[ic]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                        }
                    }
                    if (exists == false) {
                        delete data[ic][key];
                    }
                }
            }

        }
        else if (children[i].tagName == "TABLE") {
            //var tabledata = tabgetdata(children[i].id);
            data = eval("(" + tabgetdata(children[i].id) + ")");
        }
        jsonobj.data = data;
        jsonchildren.push(jsonobj);
    }
    //var jsonchildren = [];
    //grandsondata存放孙子表数据
    var children = $("[isgrandson='true']");
    for (var i = 0; i < children.length; i++) {
        GrandsonEndEdit(children[i].id);
    }
    if (children.length > 0) {
        if (grandsondata.length > 0) {
            //var totaljson = [];
            jsonchildren = jsonchildren.concat(grandsondata);
            //jsonchildren = totaljson;
        }
    }
    $.ajax({
        url: url,
        type: "POST",
        data: { mainquery: JSON2.stringify(querystr), children: JSON2.stringify(jsonchildren), from: "sysbillnocheck" },
        cache: false,
        async: false,
        success: function (data) {
            result = data;
        },
        error: function (data) {
            alert("与服务器连接失败！");
        }
    });
    return result;
}
//如果子表是table，获取table数据，返回json字符串
function tabgetdata(tableid) {
    var jsonstr;
    var table = document.getElementById(tableid);
    jsonstr = "[";
    for (var i = 0; i < table.rows.length; i++) {
        var tr = table.rows[i];
        var obj = get_firstchild(tr);
        if (obj.tagName == "TH") {
            continue;
        }
        jsonstr += "{"
        for (var j = 0; j < tr.cells.length; j++) {
            var td = tr.cells[j];
            var input = td.getElementsByTagName("INPUT");
            for (var k = 0; k < input.length; k++) {
                if (input[k].attributes["fieldid"] != undefined && input[k].attributes["fieldid"] != null) {
                    var c = input[k];
                    var field = c.attributes["fieldid"].nodeValue;
                    //var fieldtype = c.attributes["fieldtype"].nodeValue;

                    if (c.type == "text" || c.type == "password" || c.type == "hidden") {
                        var value = c.value;
                        /*if (document.getElementById(c.id + "_val")) {
                        value = document.getElementById(c.id + "_val").value;
                        }*/
                        jsonstr += "\"" + field + "\":" + "\"" + value.replace(/%/g, "%25") + "\",";
                    }
                    if (c.type == "checkbox") {
                        value = c.checked == true ? 1 : 0;
                        jsonstr += "\"" + field + "\":" + "\"" + value + "\",";
                    }
                }
            }
            var textarea = td.getElementsByTagName("TEXTAREA");
            for (var k = 0; k < textarea.length; k++) {
                if (textarea[k].attributes["fieldid"] != undefined && textarea[k].attributes["fieldid"] != null) {
                    var c = textarea[k];
                    var value = c.value;
                    if (document.getElementById(c.id + "_val")) {
                        value = document.getElementById(c.id + "_val").value;
                    }
                    var field = c.attributes["fieldid"].nodeValue;
                    //var fieldtype = c.attributes["fieldtype"].nodeValue;
                    jsonstr += "\"" + field + "\":" + "\"" + value.replace(/%/g, "%25") + "\",";
                }
            }
            var select = td.getElementsByTagName("SELECT");
            for (var k = 0; k < select.length; k++) {
                if (select[k].attributes["fieldid"] != undefined && select[k].attributes["fieldid"] != null) {
                    var c = select[k];
                    var field = c.attributes["fieldid"].nodeValue;
                    //var fieldtype = c.attributes["fieldtype"].nodeValue;
                    var sindex = c.selectedIndex == -1 ? 0 : c.selectedIndex;
                    jsonstr += "\"" + field + "\":" + "\"" + c.options[sindex].value.replace(/%/g, "%25") + "\",";
                }
            }
        }
        if (jsonstr.length > 1) {
            jsonstr = jsonstr.substr(0, jsonstr.length - 1);
            jsonstr += "},";
        }
    }
    if (jsonstr.length > 1) {
        jsonstr = jsonstr.substr(0, jsonstr.length - 1);
        jsonstr += ']';
    }
    else {
        jsonstr = "[]";
    }
    return jsonstr.replace(/\r\n/g, "\\r\\n").replace(/\n/g, "\\n");
}
//获取第一个子节点
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
//获取所有子节点
function getChildNodes(obj) {
    var childnodes = new Array();
    var childS = obj.childNodes;
    for (var i = 0; i < childS.length; i++) {
        if (childS[i].nodeType == 1)
            childnodes.push(childS[i]);
    }
    return childnodes;
}
//检查必填项
function checkvalue() {
    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    for (var i = 0; i < input.length; i++) {
        if (input[i].attributes["required"] != undefined && input[i].attributes["fieldid"] != null) {
            if (input[i].attributes["required"].nodeValue.toLowerCase() == "true") {
                if (input[i].value.length == 0 && (input[i].type == "text" || input[i].type == "password")) {
                    var bkcolor = input[i].currentStyle.backgroundColor;
                    input[i].style.backgroundColor = "#ff0000";
                    if (input[i].attributes["requiredtip"] != undefined && input[i].attributes["requiredtip"] != null) {
                        //alert(input[i].attributes["requiredtip"].nodeValue);
                        input[i].style.backgroundColor = bkcolor;
                        return input[i].attributes["requiredtip"].nodeValue;
                    }
                    else {
                        //alert(input[i].attributes["fieldid"].nodeValue + "不能为空");
                        input[i].style.backgroundColor = bkcolor;
                        return input[i].attributes["fieldid"].nodeValue + "不能为空"
                    }
                    //return false;
                }
            }
        }
    }
    for (var i = 0; i < textarea.length; i++) {
        if (textarea[i].attributes["required"] != undefined && textarea[i].attributes["fieldid"] != null) {
            if (textarea[i].attributes["required"].nodeValue.toLowerCase() == "true") {
                if (textarea[i].value.length == 0 && (textarea[i].type == "text" || textarea[i].type == "password")) {
                    var bkcolor = textarea[i].currentStyle.backgroundColor;
                    textarea[i].style.backgroundColor = "#ff0000";
                    if (textarea[i].attributes["requiredtip"] != undefined && textarea[i].attributes["requiredtip"] != null) {
                        //alert(textarea[i].attributes["requiredtip"].nodeValue);
                        textarea[i].style.backgroundColor = bkcolor;
                        return textarea[i].attributes["requiredtip"].nodeValue
                    }
                    else {
                        //alert(textarea[i].attributes["fieldid"].nodeValue + "不能为空");
                        textarea[i].style.backgroundColor = bkcolor;
                        return (textarea[i].attributes["fieldid"].nodeValue + "不能为空");
                    }
                    //return false;
                }
            }
        }
    }
    return "1";
}
//页面初始化
function pageinit() {
    //var jsonstr = decodeURIComponent(initjsonstr);
    //if (jsonstr.length > 0) {
    //var jsontable = eval("(" + decodeURIComponent(jsonstr) + ")");
    var jsonobj = initjsonstr.Rows[0];
    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    var select = document.getElementById("divmain").getElementsByTagName("SELECT");
    for (var i = 0; i < textarea.length; i++) {
        if (textarea[i].attributes["fieldid"] && textarea[i].attributes["fieldid"] != null) {
            var field = textarea[i].attributes["fieldid"].nodeValue;
            for (var key in jsonobj) {
                if (key == field) {
                    textarea[i].value = jsonobj[key];
                    if (document.getElementById(textarea[i].id + "_val")) {
                        document.getElementById(textarea[i].id + "_val").value = jsonobj[key];
                    }
                    break;
                }
            }
        }
    }
    for (var i = 0; i < input.length; i++) {
        if (input[i].attributes["fieldid"] != undefined && input[i].attributes["fieldid"] != null && input[i].id != "fieldkeys") {
            var objtype = input[i].type;
            var field = input[i].attributes["fieldid"].nodeValue;
            var fieldtype = input[i].attributes["fieldtype"] == null ? "char" : input[i].attributes["fieldtype"].nodeValue;
            for (var key in jsonobj) {
                if (key == field) {
                    if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                        if (fieldtype == "datetime" || fieldtype == "date") {
                            if (jsonobj[key].indexOf("1900") < 0) {
                                if (jsonobj[key].length > 10) {
                                    if (jsonobj[key].indexOf("/") > -1) {
                                        if (jsonobj[key].indexOf(" ") == 8) {
                                            input[i].value = jsonobj[key].substr(0, 8);
                                            if (document.getElementById(input[i].id + "_val")) {
                                                document.getElementById(input[i].id + "_val").value = jsonobj[key].substr(0, 8);
                                            }
                                        }
                                        else {
                                            input[i].value = jsonobj[key].substr(0, 10);
                                            if (document.getElementById(input[i].id + "_val")) {
                                                document.getElementById(input[i].id + "_val").value = jsonobj[key].substr(0, 10);
                                            }
                                        }
                                    }
                                    else {
                                        input[i].value = jsonobj[key].substr(0, 10);
                                        if (document.getElementById(input[i].id + "_val")) {
                                            document.getElementById(input[i].id + "_val").value = jsonobj[key].substr(0, 10);
                                        }
                                    }
                                }
                                else {
                                    input[i].value = jsonobj[key].substr(0, 10);
                                    if (document.getElementById(input[i].id + "_val")) {
                                        document.getElementById(input[i].id + "_val").value = jsonobj[key].substr(0, 10);
                                    }
                                }
                            }
                        }
                        else {
                            input[i].value = jsonobj[key];
                            if (document.getElementById(input[i].id + "_val")) {
                                document.getElementById(input[i].id + "_val").value = jsonobj[key];
                            }
                        }
                        break;
                    }
                    if (objtype == "checkbox") {
                        var value = jsonobj[key];
                        if (jsonobj[key] == "True" || jsonobj[key] == "1") {
                            input[i].checked = true;
                            if (document.getElementById(input[i].id + "_val")) {
                                document.getElementById(input[i].id + "_val").checked = true;
                            }
                        }
                        else {
                            input[i].checked = false;
                            if (document.getElementById(input[i].id + "_val")) {
                                document.getElementById(input[i].id + "_val").checked = false;
                            }
                        }
                    }
                }
            }
        }
    }
    for (var i = 0; i < select.length; i++) {
        if (select[i].attributes["fieldid"] && select[i].attributes["fieldid"] != null) {
            var field = select[i].attributes["fieldid"].nodeValue;
            var noinit = select[i].attributes["noinit"] == null ? "" : select[i].attributes["noinit"].nodeValue;
            if (noinit == "true") {
                continue;
            }
            for (var key in jsonobj) {
                if (key.toUpperCase() == field.toUpperCase()) {
                    SelectItemByText(select[i], jsonobj[key]);
                    select[i].value = jsonobj[key];
                    //select[i].value = jsonobj[key];
                    if (document.getElementById(select[i].id + "_val")) {
                        SelectItemByText(document.getElementById(select[i].id + "_val"), jsonobj[key]);
                    }
                    break;
                }
            }
        }
    }
    lookupinit();
}
//有lookup设置的初始化
function lookupinit() {
    var elementwithlookup = $("[lookup]");
    for (var i = 0; i < elementwithlookup.length; i++) {
        if (elementwithlookup[i].attributes["lookup"].nodeValue == "true") {
            if ($(elementwithlookup[i].id).ligerComboBox) {
                var em = $("#" + elementwithlookup[i].id).ligerComboBox();
                var value = elementwithlookup[i].value;
                em.setValue(value.toLowerCase());
                em.setText(value.toLowerCase());
            }
        }
    }
}

//回调方法
//url处理页面，parms回传的参数，async是否异步，ispost是否是post方式,funcname是异步回调后执行的方法
function callpostback(url, parms, async, ispost, funcname) {
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
                funcname(xmlhttp.responseText);
                //return
            }
            //document.getElementById("operatresult").value = xmlhttp.responseText;
            //$("#operatresult").value = xmlhttp.responseText;
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
function SelectItemByText(objSelect, objItemText) {
    for (var i = 0; i < objSelect.options.length; i++) {
        if (objSelect.options[i].text == objItemText) {
            objSelect.options[i].selected = true;
            break;
        }
    }
}