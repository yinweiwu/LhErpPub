var usetype;
var tablename;
var maintablefields;
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
$(function () {
    $.ajax({
        url: "/ashx/LoginHandler.ashx",
        async: false,
        cache: false,
        data: { otype: "getcurtuserid" },
        success: function (data) {
            $("#HiddenField1").val(data);
        },
        error: {

    }
});

if (getQueryString("iformid") != null) {
    var iformid = getQueryString("iformid");
    getTableInfo(iformid);
    iformid = iformid == "null" ? 0 : iformid;
    document.getElementById("Text1").value = iformid;
    var jsonfiltertabledata = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": "'" + iformid + "'"
    }
    ]
    var jsonsorttabledata = [{
        "SortName": "iSerial",
        "SortOrder": "asc"
    }]
    var jsonobjtabledata = {
        "TableName": "bscDataSearch",
        "Fields": "*",
        "SelectAll": "True",
        "Filters": jsonfiltertabledata,
        "Sorts": jsonsorttabledata
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobjtabledata));
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    try {
        if (resultstr.length > 0) {
            initjsonstr = eval("(" + resultstr + ")");
            if (initjsonstr.Rows.length > 0) {
                pageinitchild("tab", initjsonstr.Rows);
            }
        }
    }
    catch (e) {
        //alert(e.Message);
    }
}
$("#divtool").ligerToolBar({
    items: [
        {
            text: '保存', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
        }
    ]
});

$("#divchildtool").ligerToolBar({
    items: [
        {
            text: '增加行', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            text: '删除行', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/busy.gif'
        }
    ]
});
});

function itemclick(item) {
    if (item.text == "保存") {
        var resuslt = operate();
        if (resuslt.indexOf("error") > -1) {
            alert(resuslt);
        }
        else {
            alert("保存成功！");
        }
    }
    if (item.text == "增加行") {
        addrow("tab");
    }
    if (item.text == "删除行") {
        deleterow('tab');
    }
}

function getTableInfo(iformid) {
    //var iformid = getQueryString("iformid");
    var url = "/Base/Handler/sysHandler.ashx";
    var parms = "otype=getmainsqlfield&iformid=" + iformid;
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    try {
        //主表字段
        var maintablejson = eval("(" + resultstr + ")");
        maintablefields = maintablejson;
    }
    catch (e) {
        //alert(resultstr);
    }
}

function operate() {
    var jsonstr = tabgetdata("tab");
    var json = {
        "TableName": "bscDataSearch",
        "FieldKeysValues": document.getElementById("Text1").value
    }
    var url = "/Base/Handler/DataOperatorForSys.ashx";
    var parms = "from=sysquerycnditn&mainquery=" + encodeURIComponent(JSON.stringify(json)) + "&detaildata=" + encodeURIComponent(jsonstr);
    var async = false;
    var ispost = true;
    var result = callpostback(url, parms, async, ispost)
    return result;
}

function getNowTime() {
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

//var initjsonchild;
function pageinitchild(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit(childid, jsonobj[i]);
    }
}
var rowcount = 0;
function addrowinit(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:20px; height:20px'><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' />";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' fieldid='iSerial' fieldtype='int' class='inputnoborder' value='" + obj.iSerial + "' style='text-align:center' />"
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' class='inputnoborder' id='input" + rowcount + "' fieldid='sFieldName' fieldtype='char' value='" + obj.sFieldName + "'/>";
    var td3 = tr.insertCell(-1);
    //td3.innerHTML = "<input type='text' class='inputnoborder' fieldid='sCaption' fieldtype='char' value='" + obj.sCaption + "' />";
    td3.innerHTML = "<textarea fieldid='sCaption' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;'>" + obj.sCaption + "</textarea>"
    var td4 = tr.insertCell(-1);
    td4.innerHTML = "<select id='select" + rowcount.toString() + "' fieldid='sFieldType' fieldtype='char' style='width:40px'><option value ='S'>S</option><option value ='F'>F</option><option value ='D'>D</option><option value ='DT'>DT</option><option value ='B'>B</option></select>";
    setSelectValue("select" + rowcount.toString(), obj.sFieldType);

    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<input type='text' class='inputnoborder' fieldid='sOpTion' fieldtype='char' value='" + obj.sOpTion + "' style='width:50px;border:solid 1px #a0a0a0;' /><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    var td9 = tr.insertCell(-1);
    td9.innerHTML = "<input type='text' id='input2" + rowcount + "' class='inputnoborder' fieldid='sValue' fieldtype='char' value='" + obj.sValue + "' style='width:60px;' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    var td10 = tr.insertCell(-1);
    var checked10 = obj.iRequired == "1" ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' " + checked10 + " style='width:15px; height:15px' fieldid='iRequired' fieldtype='int'/>";
    var td14 = tr.insertCell(-1);
    var checked14 = obj.iMulti == "1" ? "checked='checked'" : "";
    td14.innerHTML = "<input type='checkbox' " + checked14 + " style='width:15px; height:15px' fieldid='iMulti' fieldtype='int'/>";
    var td11 = tr.insertCell(-1);
    var checked11 = obj.iHidden == "1" ? "checked='checked'" : "";
    td11.innerHTML = "<input type='checkbox' " + checked11 + " style='width:15px; height:15px' fieldid='iHidden' fieldtype='int'/>";
    //    var td5 = tr.insertCell(-1);
    //    var checked1 = obj.bWindow == "True" ? "checked='checked'" : "";
    //    td5.innerHTML = "<input type='checkbox' "+checked1+" style='width:12px; height:12px' fieldid='bWindow' fieldtype='bit' />";
    var td6 = tr.insertCell(-1);
    checked1 = obj.bQuery == "True" ? "checked='checked'" : "";
    td6.innerHTML = "<input type='checkbox' " + checked1 + " style='width:15px; height:15px' fieldid='bQuery' fieldtype='bit'/>";

    //    var td11 = tr.insertCell(-1);
    //    td11.innerHTML = "<textarea fieldid='sConditonSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人'>" + obj.sConditonSource + "</textarea>";
    var td13 = tr.insertCell(-1);
    td13.innerHTML = "<textarea fieldid='sColumnSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人,{this}表示当前选择的值'>" + obj.sColumnSource + "</textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea fieldid='sColumnDataSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人，{column}表示当前的列名'>" + obj.sColumnDataSource + "</textarea>";


    var td7 = tr.insertCell(-1);
    //td7.innerHTML = "<input type='text' class='inputnoborder' fieldid='sLookUpName' fieldtype='char' value='" + obj.sLookUpName + "' />";
    td7.innerHTML = "<textarea fieldid='sLookUpName' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;'>" + obj.sLookUpName + "</textarea>"
    

    //    var td10 = tr.insertCell(-1);
    //    td10.innerHTML = "<textarea fieldid='sReMark' fieldtype='char'>" + obj.sReMark + "</textarea>";
    LiguiComboxLoadLocal("input" + rowcount, maintablefields, "Name", "Name", true, false, 150, 90, 90);
    LiguiComboxLoadLocal("input2" + rowcount, defaultValue, "id", "id", true, false, 150, 90, 90);
    rowcount++;
}
function setSelectValue(selectid, value) {
    document.getElementById(selectid).value = value;
}

var defaultValue = [
    { id: "UserID" }, { id: "UserName" }, { id: "CurrentDate" }, { id: "CurrentDateTime" }, { id: "Departid" }, { id: "NewGUID" }
];

function addrow(tabid) {
    var table = document.getElementById(tabid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:15px; height:15px'><input type='hidden' fieldid='GUID' fieldtype='char' value='" + NewGuid() + "'/><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' />";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' fieldid='iSerial' fieldtype='int' class='input' value='" + (rowcount + 1).toString() + "' style='text-align:center' />"
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' class='input' id='input" + rowcount + "' fieldid='sFieldName' fieldtype='char'/>";
    var td3 = tr.insertCell(-1);
    //td3.innerHTML = "<input type='text' class='input' fieldid='sCaption' fieldtype='char' />";
    td3.innerHTML = "<textarea fieldid='sCaption' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;'></textarea>"
    var td4 = tr.insertCell(-1);
    td4.innerHTML = "<select id='select" + rowcount.toString() + "' fieldid='sFieldType' fieldtype='char' style='width:40px'><option value ='S'>S</option><option value ='F'>F</option><option value ='D'>D</option><option value ='DT'>DT</option><option value ='B'>B</option></select>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<input type='text' class='input' fieldid='sOpTion' fieldtype='char' value='like' style='width:50px;border:solid 1px #a0a0a0;'/><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    var td9 = tr.insertCell(-1);
    td9.innerHTML = "<input type='text' id='input2" + rowcount + "' class='input' fieldid='sValue' fieldtype='char' style='width:60px;'/><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    var td10 = tr.insertCell(-1);
    //var checked10 = obj.iRequired == "True" ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' style='width:15px; height:15px' fieldid='iRequired' fieldtype='int'/>";
    var td14 = tr.insertCell(-1);
    td14.innerHTML = "<input type=' style='width:15px; height:15px' fieldid='iMulti' fieldtype='int'/>";

    var td11 = tr.insertCell(-1);
    //var checked11 = obj.iHidden == "1" ? "checked='checked'" : "";
    td11.innerHTML = "<input type='checkbox' style='width:15px; height:15px' fieldid='iHidden' fieldtype='int'/>";
    
    //setSelectValue("select" + rowcount.toString(), obj.sFieldsType);
    //var td5 = tr.insertCell(-1);
    //var checked1 = obj.bWindow == "1" ? "checked" : "";
    //    td5.innerHTML = "<input type='checkbox'  style='width:12px; height:12px' fieldid='bWindow' fieldtype='bit' />";
    var td6 = tr.insertCell(-1);
    //checked1 = obj.bQuery == "1" ? "checked" : "";
    td6.innerHTML = "<input type='checkbox' style='width:20px; height:20px' fieldid='bQuery' fieldtype='bit'/>";
    //    var td11 = tr.insertCell(-1);
    //    td11.innerHTML = "<textarea fieldid='sConditonSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人'></textarea>";
    var td13 = tr.insertCell(-1);
    td13.innerHTML = "<textarea fieldid='sColumnSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人,{this}表示当前选择的值'></textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea fieldid='sColumnDataSource' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;' title='{userid}表示当前登录人，{column}表示当前的列名'></textarea>";

    var td7 = tr.insertCell(-1);
    //td7.innerHTML = "<input type='text' class='input' fieldid='sLookUpName' fieldtype='char' />";
    td7.innerHTML = "<textarea fieldid='sLookUpName' fieldtype='char' style='width:200px;height:80px;font-family:Verdana;'></textarea>"
    //    var td10 = tr.insertCell(-1);
    //    td10.innerHTML = "<textarea fieldid='sReMark' fieldtype='char'></textarea>";
    LiguiComboxLoadLocal("input" + rowcount, maintablefields, "Name", "Name", true, false, 150, 90, 90);
    LiguiComboxLoadLocal("input2" + rowcount, defaultValue, "id", "id", true, false, 150, 90, 90);
    rowcount++;
}

function LiguiComboxLoadLocal(eid, data, valueid, textid, autocomplete, readonly, height, width, bwidth) {
    var value = document.getElementById(eid).value;
    var obj = $("#" + eid).ligerComboBox(
                  {
                      valueField: valueid,
                      textField: textid,
                      autocomplete: autocomplete,
                      selectBoxHeight: height,
                      selectBoxWidth: width,
                      width: bwidth,
                      readonly: readonly,
                      data: data
                      //valueFieldID: eid
                  }
             );
    /*if (value.length > 0) {
    setTimeout("setComboxValue('" + eid + "','" + value + "')", 100);
    }*/
}
function setComboxValue(eid, value) {
    var obj = $("#" + eid).ligerComboBox();
    obj.setValue(value);
}

function selectall(obj, tabid) {
    var table = document.getElementById(tabid);
    for (var i = 1; i < table.rows.length; i++) {
        if (get_firstchild(table.rows[i].cells[0])) {
            get_firstchild(table.rows[i].cells[0]).checked = obj.checked;
        }
    }
}
function deleterow(tabid) {
    var falg = false;
    if (confirm('确认删除选择的行？')) {
        var table = document.getElementById(tabid);
        for (var i = 1; i < table.rows.length; i++) {
            if (get_firstchild(table.rows[i].cells[0])) {
                if (get_firstchild(table.rows[i].cells[0]).checked == true) {
                    table.deleteRow(table.rows[i].rowIndex);
                    i--;
                    falg = true;
                }
            }
        }
    }
}

function S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function NewGuid() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function beforePageSave() {
    var iformid = getQueryString("iformid");
    var jsonfilter = [{
        "Field": "iFormid",
        "ComOprt": "=",
        "Value": "'" + iformid + "'"
    }];
    var josnobj = {
        "TableName": "bscDataSearch",
        "Fields": "iFormid",
        "SelectAll": "True",
        "Filters": jsonfilter
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(josnobj));
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    try {
        var jsonreult = eval("(" + resultstr + ")");
        if (jsonreult.Rows.length > 0) {
            usetype = "update";
        }
        else {
            usetype = "add";
        }
        return true;
    }
    catch (e) {
        //alert(e.Message);
        alert(e.Message);
        return false;
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
    return jsonstr;
}