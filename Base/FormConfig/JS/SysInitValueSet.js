var tablename;
var detailtablename;
var maintablefields;
var detailtablefields;
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
    getTableInfo();
    //初始化初始值设置
    document.getElementById("Text1").value = getQueryString("iformid");
    var jsonfilter1 = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": getQueryString("iformid"),
        "LinkOprt": "and"
    },
    {
        "Field": "isnull(iFlag,0)",
        "ComOprt": "=",
        "Value": "0"
    }
    ]
    var jsonsort = [{
        "SortName": "dInputDate",
        "SortOrder": "asc"
    }]
    var jsonobj1 = {
        "TableName": "BscDataInit",
        "Fields": "*",
        "SelectAll": "True",
        "Filters": jsonfilter1,
        "Sorts": jsonsort
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj1));
    var async = false;
    var ispost = true;
    var result1 = callpostback(url, parms, async, ispost)
    if (result1.length > 0) {
        try {
            var jsonresultobj1 = eval("(" + result1 + ")");
            if (jsonresultobj1.Rows.length > 0) {
                pageinitchild1("tabvalue", jsonresultobj1.Rows);
            }
        }
        catch (e) {
            //alert(result1);
        }
    }
    //初始化必填值设置
    var jsonfilter2 = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": getQueryString("iformid"),
        "LinkOprt": "and"
    },
    {
        "Field": "isnull(iFlag,0)",
        "ComOprt": "=",
        "Value": "1"
    }
    ]
    var jsonsort = [{
        "SortName": "dInputDate",
        "SortOrder": "asc"
    }]
    var jsonobj2 = {
        "TableName": "BscDataInit",
        "Fields": "*",
        "SelectAll": "True",
        "Filters": jsonfilter2,
        "Sorts": jsonsort
    }
    //var url = "/Base/Handler/DataBuilder.ashx";
    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj2));
    //var async = false;
    //var ispost = true;
    var result2 = callpostback(url, parms, async, ispost)
    if (result2.length > 0) {
        try {
            var jsonresultobj2 = eval("(" + result2 + ")");
            if (jsonresultobj2.Rows.length > 0) {
                pageinitchild2("tabpro", jsonresultobj2.Rows);
            }
        }
        catch (e) {
            alert(result2);
        }
    }

    //LookUp设置
    var jsonfilter3 = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": getQueryString("iformid"),
        "LinkOprt": "and"
    },
    {
        "Field": "isnull(iFlag,0)",
        "ComOprt": "=",
        "Value": "2"
    }
    ]
    var jsonobj3 = {
        "TableName": "BscDataInit",
        "Fields": "*",
        "SelectAll": "True",
        "Filters": jsonfilter3,
        "Sorts": jsonsort
    }
    //var url = "/Base/Handler/DataBuilder.ashx";
    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj3));
    //var async = false;
    //var ispost = true;
    var result3 = callpostback(url, parms, async, ispost)
    if (result3.length > 0) {
        try {
            var jsonresultobj3 = eval("(" + result3 + ")");
            if (jsonresultobj3.Rows.length > 0) {
                pageinitchild3("tablookup", jsonresultobj3.Rows);
            }
        }
        catch (e) {
            alert(result3);
        }
    }

}

var jsonfilter4 = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": getQueryString("iformid"),
        "LinkOprt": "and"
    },
    {
        "Field": "isnull(iFlag,0)",
        "ComOprt": "=",
        "Value": "3"
    }
    ]
var jsonobj4 = {
    "TableName": "BscDataInit",
    "Fields": "*",
    "SelectAll": "True",
    "Filters": jsonfilter4,
    "Sorts": jsonsort
}
//var url = "/Base/Handler/DataBuilder.ashx";
parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj4));
//var async = false;
//var ispost = true;
var result4 = callpostback(url, parms, async, ispost)
if (result4.length > 0) {
    try {
        var jsonresultobj4 = eval("(" + result4 + ")");
        if (jsonresultobj4.Rows.length > 0) {
            pageinitchild4("tabbgcolor", jsonresultobj4.Rows);
        }
    }
    catch (e) {
        alert(result4);
    }
}

//$("#navtab1").ligerTab();
//$("#divtool1").ligerToolBar({
//    items: [
//        {
//            text: '增加行', click: itemclick1, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
//        },
//        { line: true },
//        {
//            text: '删除行', click: itemclick1, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
//        },
//        {
//            text: '保存', click: itemclick1, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
//        }
//        ]
//});
//$("#divtool2").ligerToolBar({
//    items: [
//        {
//            text: '增加行', click: itemclick2, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
//        },
//        { line: true },
//        {
//            text: '删除行', click: itemclick2, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
//        },
//        {
//            text: '保存', click: itemclick2, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
//        }
//    ]
//});
//$("#divtool3").ligerToolBar({
//    items: [
//        {
//            text: '增加行', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
//        },
//        { line: true },
//        {
//            text: '删除行', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
//        },
//        {
//            text: '保存', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
//        }
//    ]
//});

//$("#divtool4").ligerToolBar({
//    items: [
//        {
//            text: '增加行', click: itemclick4, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
//        },
//        { line: true },
//        {
//            text: '删除行', click: itemclick4, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
//        },
//        {
//            text: '保存', click: itemclick4, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
//        }
//    ]
//});
})
function getTableInfo() {
    var jsonfiltertabledata = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": "'" + getQueryString("iformid") + "'"
    }
    ]
    var jsonobjtabledata = {
        "TableName": "bscDataBill",
        "Fields": "sTableName,sDetailTableName",
        "SelectAll": "True",
        "Filters": jsonfiltertabledata
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobjtabledata));
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    var forminfo = eval("(" + resultstr + ")").Rows[0];
    if (forminfo) {
        tablename = forminfo.sTableName;
        detailtablename = forminfo.sDetailTableName;
    }
    //主表所有字段
    var jsonfilter1 = [{
        "Field": "id",
        "ComOprt": "=",
        "Value": "Object_Id('" + tablename + "')"
    }]
    var jsonobjsqlsort1 =
    [{
        "SortName": "Name",
        "SortOrder": "asc"
    }];
    var jsonobj1 = {
        "TableName": "SysColumns",
        "Fields": "Name",
        "SelectAll": "True",
        "Filters": jsonfilter1,
        "Sorts": jsonobjsqlsort1
    }
    //parms = { Rnd: Math.random(), plugintype: 'grid', sqlqueryobj: encodeURIComponent(JSON.stringify(jsonobj1)) };
    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj1));
    var mainfieldstr = callpostback(url, parms, async, ispost);
    try {
        maintablefields = eval("(" + mainfieldstr + ")").Rows;
    }
    catch (e) {

    }
    //子表所有字段
    var jsonfilter2 = [{
        "Field": "id",
        "ComOprt": "=",
        "Value": "Object_Id('" + detailtablename + "')"
    }]
    var jsonobjsqlsort2 =
    [{
        "SortName": "Name",
        "SortOrder": "asc"
    }];
    var jsonobj2 = {
        "TableName": "SysColumns",
        "Fields": "Name",
        "SelectAll": "True",
        "Filters": jsonfilter2,
        "Sorts": jsonobjsqlsort2
    }
    //jsonfilter1.Value = "Object_Id('" + detailtablename + "')";
    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj2));
    var detailfieldstr = callpostback(url, parms, async, ispost);
    try {
        detailtablefields = eval("(" + detailfieldstr + ")").Rows;
    }
    catch (e) {

    }
}

//function itemclick1(item) {
//    if (item.text == "增加行") {
//        addrow1("tabvalue");
//    }
//    else if (item.text == "删除行") {
//        deleterow("tabvalue");
//    }
//    else if (item.text == "保存") {
//        var result = operate("tabvalue", "from=sysinitvalueset");
//        if (result.indexOf("error") > -1) {
//            alert(result);
//        }
//        else {
//            alert("保存成功！");
//        }
//    }
//}
//function itemclick2(item) {
//    if (item.text == "增加行") {
//        addrow2("tabpro");
//    }
//    else if (item.text == "删除行") {
//        deleterow("tabpro");
//    }
//    else if (item.text == "保存") {
//        var result = operate("tabpro", "from=sysmustvalueset");
//        if (result.indexOf("error") > -1) {
//            alert(result);
//        }
//        else {
//            alert("保存成功！");
//        }
//    }
//}
//function itemclick3(item) {
//    if (item.text == "增加行") {
//        addrow3("tablookup");
//    }
//    else if (item.text == "删除行") {
//        deleterow("tablookup");
//    }
//    else if (item.text == "保存") {
//        var result = operate("tablookup", "from=sysinitlookupset");
//        if (result.indexOf("error") > -1) {
//            alert(result);
//        }
//        else {
//            alert("保存成功！");
//        }
//    }
//}
function itemclick4(text) {
    if (text == "增加行") {
        addrow4("tabbgcolor");
    }
    else if (text == "删除行") {
        deleterow("tabbgcolor");
    }
    else if (text == "保存") {
        var result = operate("tabbgcolor", "from=sysinitbgcolorset");
        if (result.indexOf("error") > -1) {
            alert(result);
        }
        else {
            alert("保存成功！");
        }
    }
}

function pageinitchild1(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit1(childid, jsonobj[i]);
    }
}
function pageinitchild2(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit2(childid, jsonobj[i]);
    }
}
function pageinitchild3(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit3(childid, jsonobj[i]);
    }
}
function pageinitchild4(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit4(childid, jsonobj[i]);
    }
}
//var selectstr = "<select id='' onchange='tabselchange(this,"+tr.rowIndex+")' fieldid='sTableName' fieldtype='char'><option value='" + tablename + "'>" + tablename + "</option>"+
//"<option value='" + detailtablename + "'>" + detailtablename + "</option><select>";
function tabselchange(obj, rowindex, i) {
    var combox = $("#input" + i + rowindex).ligerComboBox();
    if (obj.selectedIndex == 0) {
        combox.set('data', maintablefields);
    }
    else {
        combox.set('data', detailtablefields);
    }
}
var rowcount1 = 0;
function addrowinit1(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    /*var td1 = tr.insertCell(-1);
    "<input type='text' fieldid='sTableName' fieldtype='char' class='inputnoborder' value='" + obj.sTableName + "' />
    /*td1.innerHTML = "<select id='select1" + rowcount1 + "' onchange='tabselchange(this," + rowcount1 + ",1)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    "<option value='" + detailtablename + "'>" + detailtablename + "</option><select>"
    + "<input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    setSelectValue("select1" + rowcount1, obj.sTableName);*/
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' id='input1" + rowcount1 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char' value='" + obj.sFieldName + "'/><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    /*var td3 = tr.insertCell(-1);
    td3.innerHTML = "<select id='select" + rowcount1.toString() + "' fieldid='sFieldType' fieldtype='char'><option value ='S'>S</option><option value ='F'>F</option><option value ='D'>D</option></select>";
    setSelectValue("select" + rowcount1.toString(), obj.sFieldType);*/
    var td4 = tr.insertCell(-1);
    //td4.style.verticalAlign = "middle";
    td4.innerHTML = "<input type='text' id='inputvalue" + rowcount1.toString() + "' class='inputnoborder' style='width:100px;margin-top:-6px;POSITION: absolute;' fieldid='sFieldValue' fieldtype='char' value='" + obj.sFieldValue + "' />" +
    "<select id='choose" + rowcount1 + "' onchange='selectDefultVale(this," + rowcount1 + ")' style='margin-top:-6px;width:120px;CLIP: rect(auto auto auto 100px); POSITION: absolute'>" +
    "<option value='UserID'>UserID</option>" +
    "<option value='UserGUID'>UserGUID</option>" +
    "<option value='UserName'>UserName</option>" +
    "<option value='CurrentDate'>CurrentDate</option>" +
    "<option value='CurrentDateTime'>CurrentDateTime</option>" +
    "<option value='Departid'>Departid</option>" +
    "<option value='NewGUID'>NewGUID</option><input type='hidden' fieldid='iFlag' fieldtype='int' value='" + obj.iFlag + "' />" +
    "</select>";
    var data = obj.sTableName == tablename ? maintablefields : detailtablefields;
    LiguiComboxLoadLocal("input1" + rowcount1, data, "Name", "Name", false, false, 150, 140, 140);
    rowcount1++;
}
function addrow1(childid) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + NewGuid() + "'/>";
    /*var td1 = tr.insertCell(-1);
    td1.innerHTML = "<select id='select1" + rowcount1 + "' onchange='tabselchange(this," + rowcount1 + ",1)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    //"<option value='" + detailtablename + "'>" + detailtablename + "</option>
    "<select>"
    + "<input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    //setSelectValue("select1" + rowcount1, obj.sTableName);*/
    //"<input type='text' fieldid='sTableName' fieldtype='char' class='inputnoborder' /><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />"
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' id='input1" + rowcount1 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char'/><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    /*var td3 = tr.insertCell(-1);
    td3.innerHTML = "<select id='select" + rowcount1.toString() + "' fieldid='sFieldType' fieldtype='char'><option value ='S'>S</option><option value ='F'>F</option><option value ='D'>D</option></select>";
    //setSelectValue("select" + rowcount1.toString(), obj.sFieldType);*/
    var td4 = tr.insertCell(-1);
    td4.innerHTML = "<input type='text' id='inputvalue" + rowcount1.toString() + "' class='inputnoborder' style='width:100px; POSITION: absolute; margin-top:-6px;' fieldid='sFieldValue' fieldtype='char'/>" +
    "<select id='choose" + rowcount1 + "' onchange='selectDefultVale(this," + rowcount1 + ")' style='margin-top:-6px;width:120px;CLIP: rect(auto auto auto 100px); POSITION: absolute;'>" +
    "<option value='UserID'>UserID</option>" +
    "<option value='UserGUID'>UserGUID</option>" +
    "<option value='UserName'>UserName</option>" +
    "<option value='CurrentDate'>CurrentDate</option>" +
    "<option value='CurrentDateTime'>CurrentDateTime</option>" +
    "<option value='Departid'>Departid</option>" +
    "<option value='NewGUID'>NewGUID</option><input type='hidden' fieldid='iFlag' fieldtype='int' value='0' />" +
    "</select>";
    //var data = obj.sTableName == tablename ? maintablefields : detailtablefields;
    LiguiComboxLoadLocal("input1" + rowcount1, maintablefields, "Name", "Name", false, false, 150, 140, 140);
    rowcount1++;
}
function selectDefultVale(obj, rowcount) {
    var input = document.getElementById("inputvalue" + rowcount);
    input.value = obj.options[obj.selectedIndex].value;
}
var rowcount2 = 0;
function addrowinit2(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    var td01 = tr.insertCell(-1);
    td01.innerHTML = "<select id='select2" + rowcount2 + "' onchange='tabselchange(this," + rowcount2 + ",2)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    "<option value='" + detailtablename + "'>" + detailtablename + "</option><select>";
    setSelectValue("select2" + rowcount2, obj.sTableName);
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' id='input2" + rowcount2 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char' value='" + obj.sFieldName + "'/>";
    var td2 = tr.insertCell(-1);
    var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<input type='checkbox' fieldid='iMust' fieldtype='int' style='width:12px; height:12px;' " + checkstr + " /><input type='hidden' fieldid='iFlag' fieldtype='int' value='" + obj.iFlag + "' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    var td21 = tr.insertCell(-1);
    td21.innerHTML = "<input type='text' fieldid='nulltip' fieldtype='char' class='inputnoborder' value='" + obj.nulltip + "' style='width:200px;' >"
    var td3 = tr.insertCell(-1);
    checkstr = obj.iNotCopy == "1" ? "checked='checked'" : "";
    td3.innerHTML = "<input type='checkbox' fieldid='iNotCopy' fieldtype='int' style='width:12px; height:12px;' " + checkstr + " /><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    var data = obj.sTableName == tablename ? maintablefields : detailtablefields;
    LiguiComboxLoadLocal("input2" + rowcount2, data, "Name", "Name", false, false, 150, 140, 140);
    rowcount2++;
}
function addrow2(childid) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + NewGuid() + "'/>";
    var td01 = tr.insertCell(-1);
    td01.innerHTML = "<select id='select2" + rowcount2 + "' onchange='tabselchange(this," + rowcount2 + ",2)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    "<option value='" + detailtablename + "'>" + detailtablename + "</option><select>";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' id='input2" + rowcount2 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char'/>";
    var td2 = tr.insertCell(-1);
    //var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<input type='checkbox' fieldid='iMust' fieldtype='int' style='width:12px; height:12px;' /><input type='hidden' fieldid='iFlag' fieldtype='int' value='1'><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    var td21 = tr.insertCell(-1);
    td21.innerHTML = "<input type='text' fieldid='nulltip' fieldtype='char' class='inputnoborder' style='width:200px;' />"
    var td3 = tr.insertCell(-1);
    //checkstr = obj.iNotCopy == "1" ? "checked='checked'" : "";
    td3.innerHTML = "<input type='checkbox' fieldid='iNotCopy' fieldtype='int' style='width:12px; height:12px;' /><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    LiguiComboxLoadLocal("input2" + rowcount2, maintablefields, "Name", "Name", false, false, 150, 140, 140);
    rowcount2++;
}

var rowcount3 = 0;
function addrowinit3(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    var td01 = tr.insertCell(-1);
    td01.innerHTML = "<select id='select3" + rowcount3 + "' onchange='tabselchange(this," + rowcount3 + ",3)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    "<option value='" + detailtablename + "'>" + detailtablename + "</option><select>";
    setSelectValue("select3" + rowcount3, obj.sTableName);
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' id='input3" + rowcount3 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char' value='" + obj.sFieldName + "'/><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    var td2 = tr.insertCell(-1);
    //var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<input type='text' fieldid='lookupname' fieldtype='char' class='inputnoborder' value='" + obj.lookupname + "' /><input type='hidden' fieldid='iFlag' fieldtype='int' value='" + obj.iFlag + "' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";

    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea fieldid='lookupname' fieldtype='char' style='width:100%; height:50px;' />" + obj.lookupparms + "</textarea>";

    var data = obj.sTableName == tablename ? maintablefields : detailtablefields;
    LiguiComboxLoadLocal("input3" + rowcount3, data, "Name", "Name", false, false, 150, 140, 140);
    rowcount3++;
}

var rowcount4 = 0;
function addrowinit4(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";

    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea fieldid='sJsCode' fieldtype='char' style='width:98%; height:50px;'>" + obj.sJsCode + "</textarea><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";

    var td2 = tr.insertCell(-1);
    //var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<textarea fieldid='sBkColor' fieldtype='char' style='width:98%; height:50px;'>" + obj.sBkColor + "</textarea><input type='hidden' fieldid='iFlag' fieldtype='int' value='" + obj.iFlag + "' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    rowcount4++;
}


function addrow3(childid) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + NewGuid() + "'/>";
    var td01 = tr.insertCell(-1);
    td01.innerHTML = "<select id='select3" + rowcount3 + "' onchange='tabselchange(this," + rowcount3 + ",3)' fieldid='sTableName' fieldtype='char'>" +
    "<option value='" + tablename + "'>" + tablename + "</option>" +
    "<option value='" + detailtablename + "'>" + detailtablename + "</option><select>";
    //setSelectValue("select3" + rowcount3, obj.sTableName);
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' id='input3" + rowcount3 + "' class='inputnoborder' fieldid='sFieldName' fieldtype='char'/><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";
    var td2 = tr.insertCell(-1);
    //var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<input type='text' fieldid='lookupname' fieldtype='char' class='inputnoborder' /><input type='hidden' fieldid='iFlag' fieldtype='int' value='2' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";

    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea fieldid='lookupname' fieldtype='char' style='width:100%; height:50px;' /></textarea>";

    //var data = obj.sTableName == tablename ? maintablefields : detailtablefields;
    LiguiComboxLoadLocal("input3" + rowcount3, maintablefields, "Name", "Name", false, false, 150, 140, 140);
    rowcount3++;
}
function addrow4(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + NewGuid() + "'/>";

    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea fieldid='sJsCode' fieldtype='char' style='width:98%; height:50px;' /></textarea><input type='hidden' fieldid='dInputDate' fieldtype='datetime' value='" + getNowTime() + "' />";

    var td2 = tr.insertCell(-1);
    //var checkstr = obj.iMust == "1" ? "checked='checked'" : "";
    td2.innerHTML = "<textarea fieldid='sBkColor' fieldtype='char' style='width:98%; height:50px;'></textarea><input type='hidden' fieldid='iFlag' fieldtype='int' value='3' /><input type='hidden' fieldid='sUserID' fieldtype='char' value='" + document.getElementById("HiddenField1").value + "' />";
    rowcount4++;
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
    if (value.length > 0) {
        setTimeout("setComboxValue('" + eid + "','" + value + "')", 100);
    }
}
function setComboxValue(eid, value) {
    var obj = $("#" + eid).ligerComboBox();
    obj.setValue(value);
}


function setSelectValue(selectid, value) {
    document.getElementById(selectid).value = value;
}
function S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function NewGuid() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
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
                        if (document.getElementById(c.id + "_val")) {
                            value = document.getElementById(c.id + "_val").value;
                        }
                        jsonstr += "\"" + field + "\":" + "\"" + value + "\",";
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
                    jsonstr += "\"" + field + "\":" + "\"" + value + "\",";
                }
            }
            var select = td.getElementsByTagName("SELECT");
            for (var k = 0; k < select.length; k++) {
                if (select[k].attributes["fieldid"] != undefined && select[k].attributes["fieldid"] != null) {
                    var c = select[k];
                    var field = c.attributes["fieldid"].nodeValue;
                    //var fieldtype = c.attributes["fieldtype"].nodeValue;
                    jsonstr += "\"" + field + "\":" + "\"" + c.options[c.selectedIndex].value + "\",";
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
        i
        jsonstr = "[]";
    }
    return jsonstr;
}

function operate(tab, from) {
    var jsonstr = tabgetdata(tab);
    var json = {
        "TableName": "BscDataInit",
        "FieldKeysValues": document.getElementById("Text1").value
    }
    var url = "/Base/Handler/DataOperatorForSys.ashx";
    var parms = from + "&mainquery=" + encodeURIComponent(JSON.stringify(json)) + "&detaildata=" + encodeURIComponent(jsonstr.replace(/%/g, "%25"));
    var async = false;
    var ispost = true;
    var result = callpostback(url, parms, async, ispost)
    return result;
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
