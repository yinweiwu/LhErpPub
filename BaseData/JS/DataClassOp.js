function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
function SqlGetData(p_parms, p_async, p_ispost) {
    var json = SqlGetDataGrid(p_parms, p_async, p_ispost);
    if (json.Rows) {
        return json.Rows;
    }
    else {
        return json;
    }
}
function SqlGetDataGrid(p_parms, p_async, p_ispost) {
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(p_parms));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (result && result.length > 0) {
        try {
            var jsonobj = eval("(" + result + ")");
            return jsonobj;
        }
        catch (e) {
            return e.Message;
        }
    }
    else {
        return {};
    }
}
function SqlGetDataComm(sqltext, p_async, p_ispost) {
    var jsonquery = {
        Commtext: sqltext
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "ctype=text&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (result && result.length > 0) {
        try {
            var jsonobj = eval("(" + result + ")");
            return jsonobj;
        }
        catch (e) {
            return e.Message;
        }
    }
    else {
        return [];
    }
}
function callpostback(url, parms, async, ispost) {
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
                return xmlhttp.responseText;
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

function oprateadd(url) {
    if (checkvalue() != "1") {
        //document.getElementById("operatresult").value = checkvalue();
        return "error:" + checkvalue();
    }
    //主表
    var querystr = "";
    var tablename = document.getElementById("TableName").value;
    var fieldkeys = document.getElementById("FieldKey").value;
    var fieldkeyvalue = document.getElementById("FieldKeyValue").value;
    //var fieldkeysvalues = getQueryString("lsh");
    var queryaddpart1 = "";
    var queryaddpart2 = "";
    var queryupdatepart1 = "";
    var queryupdatepart2 = "";
    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    var select = document.getElementById("divmain").getElementsByTagName("SELECT");
    for (var i = 0; i < textarea.length; i++) {
        var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue;
        if (nosave == "TRUE") {
            continue;
        }
        if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
            //var objtype = textarea[i].type;
            var fieldid = textarea[i].attributes["FieldID"].nodeValue;
            var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
            var saveValue = textarea[i].attributes["SaveValue"] == null ? "" : textarea[i].attributes["SaveValue"].nodeValue;
            if (queryaddpart1.indexOf(fieldid) < 0) {
                queryaddpart1 += fieldid + ",";
                var value = textarea[i].value;
                if (document.getElementById(textarea[i].id + "_val") && (saveValue == "" || saveValue == "TRUE")) {
                    value = value.length == 0 ? "" : document.getElementById(textarea[i].id + "_val").value.length == 0 ? value : document.getElementById(textarea[i].id + "_val").value;
                }
                /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype=="空") {
                if (value.length > 0) {
                queryaddpart2 += "'" + value + "'<|>";
                }
                else {
                queryaddpart2 += "null<|>";
                }
                }
                if (fieldtype == "数值" || fieldtype == "逻辑") {
                var fvalue = value.length == 0 ? "null" : value;
                queryaddpart2 += fvalue + "<|>";
                }*/
                queryaddpart2 += value + "<|>";
            }
        }
    }
    for (var i = 0; i < input.length; i++) {
        var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue;
        if (nosave == "TRUE") {
            continue;
        }
        if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
            var objtype = input[i].type;
            var fieldid = input[i].attributes["FieldID"].nodeValue;
            var fieldtype = "空";
            if (input[i].attributes["FieldType"] == null) {
                fieldtype = "空";
            }
            else {
                fieldtype = input[i].attributes["FieldType"].nodeValue;
            }
            var saveValue = input[i].attributes["SaveValue"] == null ? "" : input[i].attributes["SaveValue"].nodeValue;
            if (queryaddpart1.indexOf(fieldid) < 0) {
                queryaddpart1 += fieldid + ",";
                if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                    var value = input[i].value;
                    if (document.getElementById(input[i].id + "_val") && (saveValue == "" || saveValue.toUpperCase() == "TRUE")) {
                        value = value.length == 0 ? "" : document.getElementById(input[i].id + "_val").value.length == 0 ? value : document.getElementById(input[i].id + "_val").value;
                    }
                    /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                    if (value.length > 0) {
                    queryaddpart2 += "'" + value + "'<|>";
                    }
                    else {
                    queryaddpart2 += "null<|>";
                    }
                    }
                    if (fieldtype == "数值" || fieldtype == "逻辑") {
                    var fvalue = value.length == 0 ? "null" : value;
                    queryaddpart2 += fvalue + "<|>";
                    }*/
                    queryaddpart2 += value + "<|>";
                }
                if (objtype == "checkbox") {
                    var value = input[i].checked == true ? "1" : "0";
                    /*if (fieldtype == "字符" || fieldtype == "日期") {
                    if (value.length > 0) {
                    queryaddpart2 += "'" + value + "'<|>";
                    }
                    else {
                    queryaddpart2 += "null<|>";
                    }
                    }
                    if (fieldtype == "数值" || fieldtype == "逻辑") {
                    value = value.length == 0 ? "null" : value;
                    queryaddpart2 += value + "<|>";
                    }*/
                    queryaddpart2 += value + "<|>";
                }
                /*if (objtype == "select") {
                var value = input[i].options[selectedIndex].text;
                if (fieldtype == "字符" || fieldtype == "日期") {
                if (value.length > 0) {
                queryaddpart2 += "'" + value + "'<|>";
                }
                else {
                queryaddpart2 += "null<|>";
                }
                }
                if (fieldtype == "数值" || fieldtype == "逻辑") {
                value = value.length == 0 ? "null" : value;
                queryaddpart2 += value + "<|>";
                }
                }*/
            }
        }
    }
    for (var i = 0; i < select.length; i++) {
        var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
        if (nosave == "TRUE") {
            continue;
        }
        if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
            //var objtype = textarea[i].type;
            var fieldid = select[i].attributes["FieldID"].nodeValue;
            var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
            if (queryaddpart1.indexOf(fieldid) < 0) {
                queryaddpart1 += fieldid + ",";
                var value = select[i].value;  //select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
                var saveValue = select[i].attributes["SaveValue"] == null ? "" : select[i].attributes["SaveValue"].nodeValue;
                if (document.getElementById(select[i].id + "_val") && (saveValue == "" || saveValue.toUpperCase() == "TRUE")) {
                    value = value.length == 0 ? "" : document.getElementById(select[i].id + "_val").value.length == 0 ? value : document.getElementById(select[i].id + "_val").value;
                }
                /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                if (value.length > 0) {
                queryaddpart2 += "'" + value + "'<|>";
                }
                else {
                queryaddpart2 += "null<|>";
                }
                }
                if (fieldtype == "数值" || fieldtype == "逻辑") {
                var fvalue = value.length == 0 ? "null" : value;
                queryaddpart2 += value + "<|>";
                }*/
                queryaddpart2 += value + "<|>";
            }
        }
    }
    if (queryaddpart1.length > 0) {
        queryaddpart1 = queryaddpart1.substr(0, queryaddpart1.length - 1);
        queryaddpart2 = queryaddpart2.substr(0, queryaddpart2.length - 3);
    }
    var operate = "add";
    querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"add\",\"Fields\":\"" + queryaddpart1 + "\",\"FieldsValues\":\"" + queryaddpart2 + "\"," +
                "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + fieldkeyvalue + "\"}";
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
            for (var i = 0; i < data.length; i++) {
                for (var key in data[i]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                        }
                    }
                    if (exists == false) {
                        delete data[i][key];
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
    var parms = "mainquery=" + encodeURIComponent(querystr) + "&children=" + encodeURIComponent(JSON.stringify(jsonchildren));
    var result = callpostback(url, parms, false, true);
    return result;
}
//修改
function operateupdate(irecno, url) {
    if (checkvalue() != "1") {
        //document.getElementById("operatresult").value = checkvalue();
        return "error:" + checkvalue();
    }
    var queryupdatepart1 = "";
    var queryupdatepart2 = "";
    //主表
    var querystr = "";
    var tablename = document.getElementById("TableName").value;
    var fieldkeys = document.getElementById("FieldKey").value;

    var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    var select = document.getElementById("divmain").getElementsByTagName("SELECT");
    for (var i = 0; i < textarea.length; i++) {
        var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue.toUpperCase();
        if (nosave == "TRUE") {
            continue;
        }
        if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
            var fieldid = textarea[i].attributes["FieldID"].nodeValue;
            var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
            if (queryupdatepart1.indexOf(fieldid) < 0) {
                queryupdatepart1 += fieldid + ",";
                var value = textarea[i].value;
                if (document.getElementById(textarea[i].id + "_val")) {
                    value = value.length == 0 ? "" : document.getElementById(textarea[i].id + "_val").value.length == 0 ? value : document.getElementById(textarea[i].id + "_val").value;
                }
                /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                if (value.length > 0) {
                queryupdatepart2 += "'" + value + "'<|>";
                }
                else {
                queryupdatepart2 += "null<|>";
                }
                }
                if (fieldtype == "数值" || fieldtype == "逻辑") {
                var fvalue = value.length == 0 ? "null" : value;
                queryupdatepart2 += value + "<|>";
                }*/
                queryupdatepart2 += value + "<|>";
            }
        }
    }
    for (var i = 0; i < input.length; i++) {
        var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue.toUpperCase();
        if (nosave == "TRUE") {
            continue;
        }
        if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
            var objtype = input[i].type;
            var fieldid = input[i].attributes["FieldID"].nodeValue;
            var fieldtype = input[i].attributes["FieldType"] == null ? "空" : input[i].attributes["FieldType"].nodeValue;
            if (queryupdatepart1.indexOf(fieldid) < 0) {
                queryupdatepart1 += fieldid + ",";
                if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                    var value = input[i].value;
                    if (document.getElementById(input[i].id + "_val")) {
                        value = value.length == 0 ? "" : document.getElementById(input[i].id + "_val").value.length == 0 ? value : document.getElementById(input[i].id + "_val").value;
                    }
                    /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                    if (value.length > 0) {
                    queryupdatepart2 += "'" + value + "'<|>";
                    }
                    else {
                    queryupdatepart2 += "null<|>";
                    }
                    }
                    if (fieldtype == "数值" || fieldtype == "逻辑") {
                    var fvalue = value.length == 0 ? "null" : value;
                    queryupdatepart2 += fvalue + "<|>";
                    }*/
                    queryupdatepart2 += value + "<|>";
                }
                if (objtype == "checkbox") {
                    var value = input[i].checked == true ? "1" : "0";
                    /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                    if (value.length > 0) {
                    queryupdatepart2 += "'" + value + "'<|>";
                    }
                    else {
                    queryupdatepart2 += "null<|>";
                    }
                    }
                    if (fieldtype == "数值" || fieldtype == "逻辑") {
                    value = value.length == 0 ? "null" : value;
                    queryupdatepart2 += value + "<|>";
                    }*/
                    queryupdatepart2 += value + "<|>";
                }
            }
        }
    }
    for (var i = 0; i < select.length; i++) {
        var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
        if (nosave == "TRUE") {
            continue;
        }
        if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
            //var objtype = textarea[i].type;
            var fieldid = select[i].attributes["FieldID"].nodeValue;
            var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
            if (queryupdatepart1.indexOf(fieldid) < 0) {
                queryupdatepart1 += fieldid + ",";
                var value = select[i].value;  //select[i].options[select[i].selectedIndex] == null ? "" : select[i].options[select[i].selectedIndex].value;
                if (document.getElementById(select[i].id + "_val")) {
                    value = value.length == 0 ? "" : document.getElementById(select[i].id + "_val").value.length == 0 ? value : document.getElementById(select[i].id + "_val").value;
                }
                /*if (fieldtype == "字符" || fieldtype == "日期" || fieldtype == "空") {
                if (value.length > 0) {
                queryupdatepart2 += "'" + value + "'<|>";
                }
                else {
                queryupdatepart2 += "null<|>";
                }
                }
                if (fieldtype == "数值" || fieldtype == "逻辑") {
                var fvalue = value.length == 0 ? "null" : value;
                queryupdatepart2 += value + "<|>";
                }*/
                queryupdatepart2 += value + "<|>";
            }
        }
    }
    if (queryupdatepart1.length > 0) {
        queryupdatepart1 = queryupdatepart1.substr(0, queryupdatepart1.length - 1);
        queryupdatepart2 = queryupdatepart2.substr(0, queryupdatepart2.length - 3);
    }
    var operate = "update";
    querystr = "{\"TableName\":\"" + tablename + "\",\"Operatortype\":\"" + operate + "\",\"Fields\":\"" + queryupdatepart1 + "\",\"FieldsValues\":\"" + queryupdatepart2 + "\"," +
    "\"FieldKeys\":\"" + fieldkeys + "\",\"FieldKeysValues\":\"" + irecno + "\",\"FilterFields\":\"" + fieldkeys + "\",\"FilterComOprts\":\"=\",\"FilterValues\":\"" + irecno + "\"}";

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
            for (var i = 0; i < data.length; i++) {
                for (var key in data[i]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                        }
                    }
                    if (exists == false) {
                        delete data[i][key];
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
    var parms = "mainquery=" + encodeURIComponent(querystr) + "&children=" + encodeURIComponent(JSON.stringify(jsonchildren));
    var result = callpostback(url, parms, false, true);
    return result;
}
function checkvalue() {
    //var input = document.getElementById("divmain").getElementsByTagName("INPUT");
    var input = document.getElementsByTagName("INPUT");
    var textarea = document.getElementsByTagName("TEXTAREA");
    //var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
    //var select = document.getElementById("divmain").getElementsByTagName("SELECT");
    for (var i = 0; i < input.length; i++) {
        if (input[i].attributes["Required"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0) {
            if (input[i].attributes["Required"].nodeValue.toLowerCase() == "true") {
                if (input[i].value.length == 0 && (input[i].type == "text" || input[i].type == "password")) {
                    var bkcolor = input[i].currentStyle.backgroundColor;
                    input[i].style.backgroundColor = "#ff0000";
                    if (input[i].attributes["Requiredtip"] != undefined && input[i].attributes["Requiredtip"] != null) {
                        //alert(input[i].attributes["Requiredtip"].nodeValue);
                        input[i].style.backgroundColor = bkcolor;
                        return input[i].attributes["Requiredtip"].nodeValue;
                    }
                    else {
                        //alert(input[i].attributes["FieldID"].nodeValue + "不能为空");
                        input[i].style.backgroundColor = bkcolor;
                        return input[i].attributes["FieldID"].nodeValue + "不能为空"
                    }
                    //return false;
                }
            }
        }
    }
    for (var i = 0; i < textarea.length; i++) {
        if (textarea[i].attributes["Required"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0) {
            if (textarea[i].attributes["Required"].nodeValue.toLowerCase() == "true") {
                if (textarea[i].value.length == 0) {
                    var bkcolor = textarea[i].currentStyle.backgroundColor;
                    textarea[i].style.backgroundColor = "#ff0000";
                    if (textarea[i].attributes["Requiredtip"] != undefined && textarea[i].attributes["Requiredtip"] != null) {
                        //alert(textarea[i].attributes["Requiredtip"].nodeValue);
                        textarea[i].style.backgroundColor = bkcolor;
                        return textarea[i].attributes["Requiredtip"].nodeValue
                    }
                    else {
                        //alert(textarea[i].attributes["FieldID"].nodeValue + "不能为空");
                        textarea[i].style.backgroundColor = bkcolor;
                        return (textarea[i].attributes["FieldID"].nodeValue + "不能为空");
                    }
                    //return false;
                }
            }
        }
    }
    return "1";
}
function getChildID(tablename) {
    var jsonobj = {
        StoreProName: "SpGetIden",
        ParamsStr: "'" + tablename + "'"
    }
    var url = "/Base/Handler/StoreProHandler.ashx";
    var parms = "sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj));
    var async = false;
    var ispost = true;
    var result = callpostback(url, parms, async, ispost);
    if (result && result.length > 0 && result != "-1") {
        return result;
    }
    else {
        return "-1";
    }
}

function pageinit() {
    var jsonfilter = [{
        "Field": document.getElementById("FieldKey").value.toUpperCase(),
        "ComOprt": "=",
        "Value": selectedNode.data.iRecNo
    }]
    var jsonobj = {
        "TableName": document.getElementById("TableName").value,
        "Fields": "*",
        "SelectAll": "True",
        "Filters": jsonfilter
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj));
    var async = false;
    var ispost = true;
    var jsonstr = callpostback(url, parms, async, ispost);
    if (jsonstr && jsonstr.length > 0) {
        try {
            var jsontable = eval("(" + jsonstr + ")");
            var jsonobj = jsontable.Rows[0];
            var input = document.getElementById("divmain").getElementsByTagName("INPUT");
            var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
            var select = document.getElementById("divmain").getElementsByTagName("SELECT");
            for (var i = 0; i < textarea.length; i++) {
                var field = textarea[i].attributes["FieldID"].nodeValue;
                for (var key in jsonobj) {
                    if (key.toUpperCase() == field.toUpperCase()) {
                        textarea[i].value = jsonobj[key];
                        if (document.getElementById(textarea[i].id + "_val")) {
                            document.getElementById(textarea[i].id + "_val").value = jsonobj[key];
                        }
                        break;
                    }
                }
            }
            for (var i = 0; i < input.length; i++) {
                if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].id != "fieldkeys") {
                    var objtype = input[i].type;
                    var field = input[i].attributes["FieldID"].nodeValue;
                    var fieldtype = input[i].attributes["FieldType"] == null ? "" : input[i].attributes["FieldType"].nodeValue;
                    for (var key in jsonobj) {
                        if (key.toUpperCase() == field.toUpperCase()) {
                            if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                                if (fieldtype == "日期") {
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
                                //如果是ligercombobox且没有lookupname，则设置值
                                var lclookupname = input[i].attributes["LookUpName"];
                                var lc = $("#" + input[i].id).ligerGetComboBoxManager();
                                if (lc != null && lc.type == "ComboBox" && lclookupname == undefined) {
                                    lc.setValue(jsonobj[key]);
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
                var field = select[i].attributes["FieldID"].nodeValue;
                for (var key in jsonobj) {
                    if (key.toUpperCase() == field.toUpperCase()) {
                        SelectItemByText(select[i], jsonobj[key]);
                        //select[i].value = jsonobj[key];
                        if (document.getElementById(select[i].id + "_val")) {
                            SelectItemByText(document.getElementById(select[i].id + "_val"), jsonobj[key]);
                        }
                        break;
                    }
                }
            }
            //lookupinit();
        }
        catch (e) {
            alert(e.Message + "; 页面初始化失败！");
        }
    }
}

function EnterToTab(e) {

    var e = event.srcElement

    if (event.keyCode == 13 && e.type == "text") {

        event.keyCode = 9

    }
}
document.onkeydown = EnterToTab;