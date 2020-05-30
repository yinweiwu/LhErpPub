var usetype;
var maintablefields;
var detailtablefields;

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
$(function () {
    if (getQueryString("iformid") != null) {
        var iformid = getQueryString("iformid");
        iformid = iformid == "null" ? 0 : iformid;
        getTableInfo(iformid);
        var jsonfiltertabledata = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": "'" + iformid + "'"
    }
    ]
        var jsonobjtabledata = {
            "TableName": "bscDataQueryM",
            "Fields": "*",
            "SelectAll": "True",
            "Filters": jsonfiltertabledata
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
                    pageinit();
                    document.getElementById("fieldkeyvalue").value = initjsonstr.Rows[0].iRecNo;
                    var jsonchildfilter1 = [{
                        "Field": "iMainRecNo",
                        "ComOprt": "=",
                        "Value": initjsonstr.Rows[0].iRecNo
                    }]
                    var jsonchildsort1 = [
                    {
                        SortName: "iHide",
                        SortOrder: "asc"
                    },
                    {
                        "SortName": "iShowOrder",
                        "SortOrder": "asc"
                    }

                    ]
                    var jsonchild1 = {
                        "TableName": "bscDataQueryD",
                        "Fields": "*",
                        "SelectAll": "True",
                        "Filters": jsonchildfilter1,
                        "Sorts": jsonchildsort1
                    }
                    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonchild1));
                    callpostback(url, parms, true, ispost, backFunction);
                    /*var resultchildstr1 = callpostback(url, parms, async, ispost);
                    if (resultchildstr1.length > 0) {
                    var jsonchild1 = eval("(" + resultchildstr1 + ")");
                    if (jsonchild1.Rows.length > 0) {
                    pageinitchild("tablechild1", jsonchild1.Rows);
                    }
                    }*/
                }
                else {
                    document.getElementById("Text1").value = iformid;
                }
            }
        }
        catch (e) {
            //alert(e.Message);
        }
    }
    $("#Text2").ligerTextBox({ digits: true, width: 70 });
    $("#Text3").ligerTextBox({ digits: true, width: 70 });
    $("#Text4").ligerTextBox({ digits: true, width: 70 });
    $("#Text7").ligerTextBox({ digits: true, width: 70 });
    $("#Text8").ligerTextBox({ digits: true, width: 70 });
    $("#Text9").ligerTextBox({ digits: true, width: 70 });
    $("#divtool").ligerToolBar({
        items: [
        {
            text: '增加行', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            text: '加入全部主表子段', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            text: '加入全部子表子段', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            text: '删除行', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/busy.gif'
        },
        { line: true },
        {
            text: '上移', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/arrow_up.png'
        },
        { line: true },
        {
            text: '下移', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/arrow_down.png'
        },
        { line: true },
        {
            text: "从...复制", click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/copy.gif'
        },
        { line: true },

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
            text: '加入全部主表子段', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            text: '加入全部子表子段', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
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
        if (beforePageSave() == true) {
            if (usetype == "add") {
                document.getElementById("fieldkeyvalue").value = getChildID("bscDataQueryM");
                var resuslt = oprateadd("/Base/Handler/DataOperatorForSys.ashx", "from=sysquerywincnfig");
                if (resuslt.indexOf("error") > -1) {
                    alert(resuslt);
                }
                else {
                    document.getElementById("fieldkeyvalue").value = resuslt;
                    alert("保存成功！");
                }
            }
            else {
                var resuslt = operateupdate("/Base/Handler/DataOperatorForSys.ashx", "from=sysquerywincnfig");
                if (resuslt.indexOf("error") > -1) {
                    alert(resuslt);
                }
                else {
                    alert("保存成功！");
                }
            }
        }
    }
    if (item.text == "从...复制") {
        $.ligerDialog.prompt('请输入要复制的FormID',
        function (yes, value) {
            if (yes) {
                var url = "/Base/Handler/sysHandler.ashx";
                var parms = "otype=columnsDefineCopy&toformid=" + getQueryString("iformid") + "&fromformid=" + value;
                var async = false;
                var ispost = true;
                var resultstr = callpostback(url, parms, async, ispost);
                if (resultstr == "1") {
                    alert("复制成功!");
                    window.location.reload();
                }
                else {
                    alert(resultstr);
                }
            }
        });
    }
    if (item.text == "增加行") {
        addrow();
    }
    if (item.text == "删除行") {
        deleterow('tablechild1');
    }
    if (item.text == "加入全部主表子段") {
        for (var i = 0; i < maintablefields.length; i++) {
            addrowwithfield(true, maintablefields[i],1);
        }
    }
    if (item.text == "加入全部子表子段") {
        for (var i = 0; i < detailtablefields.length; i++) {
            addrowwithfield(false, detailtablefields[i],1);
        }
    }
    if (item.text == "上移") {
        var selectindex = 0;
        var table = document.getElementById("tablechild1");
        for (var i = 1; i < table.rows.length; i++) {
            if (get_firstchild(table.rows[i].cells[0])) {
                if (get_firstchild(table.rows[i].cells[0]).checked == true) {
                    selectindex = i;
                    break;
                }
            }
        }
        if (selectindex > 0) {
            if (selectindex == 1) {
                alert("已经到顶了！");
            }
            else {
                moveUp(table.rows[selectindex]);
            }
        }
        else {
            alert("请选择一行！");
        }
    }
    if (item.text == "下移") {
        var selectindex = 0;
        var table = document.getElementById("tablechild1");
        for (var i = 1; i < table.rows.length; i++) {
            if (get_firstchild(table.rows[i].cells[0])) {
                if (get_firstchild(table.rows[i].cells[0]).checked == true) {
                    selectindex = i;
                    break;
                }
            }
        }
        if (selectindex > 0) {
            moveDown(table.rows[selectindex]);
        }
        else {
            alert("请选择一行！");
        }
    }
}
//var initjsonchild;
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
        alert(resultstr);
    }
    parms = "otype=getdetailsqlfield&iformid=" + iformid;
    resultstr = callpostback(url, parms, async, ispost);
    try {
        //子表字段
        var childtablejson = eval("(" + resultstr + ")");
        detailtablefields = childtablejson;
    }
    catch (e) {
        alert(resultstr);
    }
}
function backFunction(resText) {
    if (resText.length > 0) {
        var jsonchild1 = eval("(" + resText + ")");
        if (jsonchild1.Rows.length > 0) {
            pageinitchild("tablechild1", jsonchild1.Rows);
        }
    }
}
function pageinitchild(childid, jsonobj) {
    for (var i = 0; i < jsonobj.length; i++) {
        addrowinit(childid, jsonobj[i]);
    }
}
var rowcount = 0;

function selectRow(obj) {
    var tr = obj.parentNode.parentNode;
    if (obj.checked == true) {
        tr.style.backgroundColor = "#efefef";
    }
    else {
        tr.style.backgroundColor = "#ffffff";
    }
    //var table = tr.parentNode;
    /*for (var i = 1; i < table.rows.length; i++) {
        if (table.rows[i] != tr) {
            table.rows[i].style.backgroundColor = "#ffffff";
        }
    }*/
}
function addrowinit(childid, obj) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(0);
    td0.innerHTML = "<input type='checkbox' onclick='selectRow(this)' style='width:16px; height:16px'><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    var td1 = tr.insertCell(1);
    td1.innerHTML = "<input type='text' fieldid='iShowOrder' fieldtype='int' class='inputnoborder' value='" + (table.rows.length - 1) + "' style='text-align:center; width:30px;' />"
    var td5 = tr.insertCell(2);
    var check = obj.isChild == "True"||obj.isChild ==true ? "checked='checked'" : "";
    td5.innerHTML = "<input type='checkbox' fieldid='isChild' onclick='setComboxData(" + rowcount + ",this)' fieldtype='bit' " + check + " />";
    var td2 = tr.insertCell(3);
    td2.innerHTML = "<input type='text' class='inputnoborder' onblur='setExpre(" + tr.rowIndex + "," + td2.cellIndex + ",this)' id='row" + rowcount + "' fieldid='sFieldsName' fieldtype='char' value='" + obj.sFieldsName + "'/>";
    var td21 = tr.insertCell(4);
    td21.innerHTML = "<Textarea fieldid='sExpression' style='width:100%;height:40px;' fieldtype='char'>" + obj.sExpression + "</Textarea>";
    var td3 = tr.insertCell(5);
    td3.innerHTML = "<Textarea fieldid='sFieldsdisplayName' fieldtype='char' style='width:100%;height:40px;'>" + obj.sFieldsdisplayName + "</textarea>";
    var td4 = tr.insertCell(6);
    td4.innerHTML = "<select id='select" + rowcount.toString() + "' fieldid='sFieldsType' fieldtype='char'><option value ='string'>string</option><option value ='date'>date</option><option value='datetime'>datetime</option><option value ='number'>number</option><option value ='bool'>bool</option><option value ='imageData'>imageData</option><option value ='imageUrl'>imageUrl</option><option value ='附件'>附件</option></select>";
    setSelectValue("select" + rowcount.toString(), obj.sFieldsType);
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<input type='text' class='inputnoborder' fieldid='iWidth' fieldtype='int' value='" + obj.iWidth + "' style='width:70px;'>";
    var td7 = tr.insertCell(-1);
    var checkstr = obj.iHide == "1" || obj.iHide == "True"||obj.iHide==true ? "checked='checked'" : "";
    td7.innerHTML = "<input type='checkbox' fieldid='iHide' " + checkstr + " fieldtype='int'>";
    var td11 = tr.insertCell(-1);
    var checkEditStr = obj.iEdit == "1" || obj.iEdit == "True"||obj.iEdit==true ? "checked='checked'" : "";
    td11.innerHTML = "<input type='checkbox' fieldid='iEdit' " + checkEditStr + " fieldtype='int'>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<Textarea fieldid='sSummary' fieldtype='char' style='width:100%;height:40px;'>" + obj.sSummary + "</Textarea>";
    var td9 = tr.insertCell(-1);
    var ifix = obj.ifix == "True" || obj.ifix == "1"||obj.ifix==true ? "checked='checked'" : "";
    td9.innerHTML = "<input type='checkbox' " + ifix + " fieldid='ifix'></input>";

    var td13 = tr.insertCell(-1);
    var iGroup = obj.iGroup == "True" || obj.iGroup == "1" || obj.iGroup == true ? "checked='checked'" : "";
    td13.innerHTML = "<input type='checkbox' " + iGroup + " fieldid='iGroup'></input>";

    var td10 = tr.insertCell(-1);
    var iApp = obj.iApp == "True" || obj.iApp == "1"||obj.iApp==true ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' " + iApp + " fieldid='iApp'></input>";

    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<Textarea fieldid='sStyle' fieldtype='char' style='width:100%;height:40px;'>" + obj.sStyle + "</Textarea>";
    /*var td9 = tr.insertCell(-1);
    td9.innerHTML = "<a href='javascript:void(0)' onclick='moveUp(this)'>上移</a>";
    var td10 = tr.insertCell(-1);
    td10.innerHTML = "<a href='javascript:void(0)' onclick='moveDown(this)'>下移</a>";*/

    //字段名初始化
    var eid = "row" + rowcount.toString();
    var valueid = "Name";
    var textid = "Name";
    var autocomplete = true;
    var readonly = false;
    var height = 150;
    var width = 150;
    var bwidth = 120;
    var data = obj.isChild == "True"||obj.isChild==true ? detailtablefields : maintablefields;
    LiguiComboxLoadLocal(eid, data, valueid, textid, autocomplete, readonly, height, width, bwidth);
    rowcount++;
}
function setExpre(rowindex, cellindex, obj) {
    //var nexttd = obj.parentNode.parentNode.parentNode.cells[obj.parentNode.parentNode.cellIndex + 1];
    var table = document.getElementById("tablechild1");
    var td = table.rows[rowindex].cells[cellindex + 1];
    var cntr = get_firstchild(td);
    if (cntr.value.length == 0) {
        cntr.value = obj.value;
    }
}
function setSelectValue(selectid, value) {
    document.getElementById(selectid).value = value;
}
function setComboxData(rowcount, obj) {
    var combox = $("#row" + rowcount).ligerComboBox();
    if (obj.checked == true) {
        combox.set('data', detailtablefields);
    }
    else {
        combox.set('data', maintablefields);
    }
}
function addrow() {
    var table = document.getElementById("tablechild1");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(0);
    td0.innerHTML = "<input type='checkbox' onclick='selectRow(this)' style='width:16px; height:16px'><input type='hidden' fieldid='GUID' value='" + NewGuid() + "' fieldtype='char'/>"
    var td1 = tr.insertCell(1);
    td1.innerHTML = "<input type='text' fieldid='iShowOrder' fieldtype='int' class='inputnoborder' value='" + (table.rows.length - 1) + "' style='text-align:center; width:30px;' />"
    var td5 = tr.insertCell(2);
    //var check = obj.isChild == "True" ? "checked='checked'" : "";
    td5.innerHTML = "<input type='checkbox' fieldid='isChild' onclick='setComboxData(" + rowcount + ",this)' fieldtype='bit' />";
    var td2 = tr.insertCell(3);
    td2.innerHTML = "<input type='text' class='inputnoborder' onblur='setExpre(" + tr.rowIndex + "," + td2.cellIndex + ",this)' id='row" + rowcount + "' fieldid='sFieldsName' fieldtype='char'/>";
    var td21 = tr.insertCell(4);
    td21.innerHTML = "<Textarea fieldid='sExpression' style='width:100%; height:40px;' fieldtype='char'></Textarea>";
    var td3 = tr.insertCell(5);
    td3.innerHTML = "<Textarea fieldid='sFieldsdisplayName' fieldtype='char' style='width:100%;height:40px;'></textarea>";
    var td4 = tr.insertCell(6);
    td4.innerHTML = "<select fieldid='sFieldsType' fieldtype='char'><option value ='string'>string</option><option value ='date'>date</option><option value='datetime'>datetime</option><option value ='number'>number</option><option value ='bool'>bool</option><option value ='imageData'>imageData</option><option value ='imageUrl'>imageUrl</option><option value ='附件'>附件</option></select>";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<input type='text' class='inputnoborder' fieldid='iWidth' fieldtype='int' style='width:70px;'>";
    var td7 = tr.insertCell(-1);
    //var checkstr = obj.iHide == "1" || obj.iHide == "True" ? "checked='checked'" : "";
    td7.innerHTML = "<input type='checkbox' fieldid='iHide' fieldtype='int'>";
    var td11 = tr.insertCell(-1);
    //var checkEditStr = obj.iEdit == "1" || obj.iEdit == "True" ? "checked='checked'" : "";
    td11.innerHTML = "<input type='checkbox' fieldid='iEdit' fieldtype='int'>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<Textarea fieldid='sSummary' fieldtype='char' style='width:100%;height:40px;'></Textarea>";
    var td9 = tr.insertCell(-1);
    //var ifix = obj.ifix == "True" || obj.ifix == "1" ? "checked='checked'" : "";
    td9.innerHTML = "<input type='checkbox' fieldid='ifix'></input>";

    var td13 = tr.insertCell(-1);
    //var iGroup = obj.iGroup == "True" || obj.iGroup == "1" || obj.iGroup == true ? "checked='checked'" : "";
    td13.innerHTML = "<input type='checkbox' fieldid='iGroup'></input>";

    var td10 = tr.insertCell(-1);
    //var iApp = obj.iApp == "True" || obj.iApp == "1" ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' fieldid='iApp'></input>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<Textarea fieldid='sStyle' fieldtype='char' style='width:100%;height:40px;'></Textarea>";
    /*var td9 = tr.insertCell(-1);
    td9.innerHTML = "<a href='javascript:void(0)' onclick='moveUp(this)'>上移</a>";
    var td10 = tr.insertCell(-1);
    td10.innerHTML = "<a href='javascript:void(0)' onclick='moveDown(this)'>下移</a>";*/
    //字段名初始化
    var eid = "row" + rowcount.toString();
    var valueid = "Name";
    var textid = "Name";
    var autocomplete = true;
    var readonly = false;
    var height = 150;
    var width = 150;
    var bwidth = 120;
    var data = maintablefields;
    LiguiComboxLoadLocal(eid, data, valueid, textid, autocomplete, readonly, height, width, bwidth);
    rowcount++;
}
function addrowwithfield(ismain, fieldname) {
    var table = document.getElementById("tablechild1");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(0);

    td0.innerHTML = "<input type='checkbox' onclick='selectRow(this)' style='width:16px; height:16px'><input type='hidden' fieldid='GUID' value='" + NewGuid() + "' fieldtype='char'/>"
    var td1 = tr.insertCell(1);
    td1.innerHTML = "<input type='text' fieldid='iShowOrder' fieldtype='int' class='inputnoborder' value='" + (table.rows.length - 1) + "' style='text-align:center; width:30px;' />"
    var td5 = tr.insertCell(2);
    var ischecked = ismain == true ? "" : "checked='checked'";
    td5.innerHTML = "<input type='checkbox' fieldid='isChild' " + ischecked + " onclick='setComboxData(" + rowcount + ",this)' fieldtype='bit' />";
    var td2 = tr.insertCell(3);
    td2.innerHTML = "<input type='text' value='" + fieldname.Name + "' class='inputnoborder' onblur='setExpre(" + tr.rowIndex + "," + td2.cellIndex + ",this)' id='row" + rowcount + "' fieldid='sFieldsName' fieldtype='char'/>";
    var td21 = tr.insertCell(4);
    td21.innerHTML = "<Textarea fieldid='sExpression' style='width:100%; height:40px;' fieldtype='char'>" + fieldname.Name + "</Textarea>";
    var td3 = tr.insertCell(5);
    td3.innerHTML = "<Textarea fieldid='sFieldsdisplayName' fieldtype='char' style='width:100%;height:40px;'></textarea>";
    var td4 = tr.insertCell(6);
    td4.innerHTML = "<select fieldid='sFieldsType' fieldtype='char'><option value ='string'>string</option><option value ='date'>date</option><option value='datetime'>datetime</option><option value ='number'>number</option><option value ='imageData'>imageData</option><option value ='imageUrl'>imageUrl</option><option value ='附件'>附件</option></select>";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<input type='text' class='inputnoborder' fieldid='iWidth' fieldtype='int' style='width:70px;'>";
    var td7 = tr.insertCell(-1);
    //var checkstr = obj.iHide == "1" || obj.iHide == "True" ? "checked='checked'" : "";
    td7.innerHTML = "<input type='checkbox' fieldid='iHide' fieldtype='int'>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<Textarea fieldid='sSummary' fieldtype='char' style='width:100%;height:40px;'></Textarea>";
    var td9 = tr.insertCell(-1);
    //var ifix = obj.ifix == "True" || obj.ifix == "1" ? "checked='checked'" : "";
    td9.innerHTML = "<input type='checkbox' fieldid='ifix'></input>";
    var td10 = tr.insertCell(-1);
    //var ifix = obj.ifix == "True" || obj.ifix == "1" ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' fieldid='iApp'></input>";
    /*var td9 = tr.insertCell(-1);
    td9.innerHTML = "<a href='javascript:void(0)' onclick='moveUp(this)'>上移</a>";
    var td10 = tr.insertCell(-1);
    td10.innerHTML = "<a href='javascript:void(0)' onclick='moveDown(this)'>下移</a>";*/
    //字段名初始化
    var eid = "row" + rowcount.toString();
    var valueid = "Name";
    var textid = "Name";
    var autocomplete = true;
    var readonly = false;
    var height = 150;
    var width = 150;
    var bwidth = 120;
    var data = maintablefields;
    LiguiComboxLoadLocal(eid, data, valueid, textid, autocomplete, readonly, height, width, bwidth);
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
                      //valueFieldID:eid
                  }
             );
    /*if (value.length > 0) {
    setTimeout("setComboxValue('" + eid + "','" + value + "')", 500);
    }*/
}
function setComboxValue(eid, value) {
    var obj = $("#" + eid).ligerComboBox();
    obj.setValue(value);
}

function LiguiComboxLoad(eid, url, valueid, textid, autocomplete, parms, readonly, height, width, bwidth) {
    var obj = $("#" + eid).ligerComboBox(
                  {
                      url: url,
                      parms: parms,
                      valueField: valueid,
                      textField: textid,
                      autocomplete: autocomplete,
                      selectBoxHeight: height,
                      selectBoxWidth: width,
                      width: bwidth,
                      readonly: readonly
                  }
             );
    if (document.getElementById(eid).value.length > 0) {
        var value = document.getElementById(eid).value;
        setTimeout("setComboxValue('" + eid + "','" + value + "')", 500);
    }
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
            table.rows[i].style.backgroundColor = obj.checked == true ? "#efefef" : "#ffffff";
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
        /*if (falg) {
        for (var i = 1; i < table.rows.length; i++) {
        table.rows[i].cells[1].innerHTML = i;
        }
        }*/
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
        "TableName": "bscDataQueryM",
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

function moveUp(obj) {
    //先找到行
    //找到父结点用DOM中的parentNode
    var tr_one = obj; //.parentNode.parentNode;
    //再找到父结点
    var tr_parent = tr_one.parentNode;
    //找到这一行的前一行用到DOM中的previousSibling
    var tr_two = tr_one.previousSibling;
    //再把这一行放到找到的前一行的前面;用到DOM中的insertBefore(new_node,existing_node)这一切在父结点中进行insertBefore(new_node,existing_node)
    //当移到顶部时会返回一个空值。
    //alert(tr_two)
    if (tr_two != null) {
        tr_parent.insertBefore(tr_one, tr_two);
        get_firstchild(tr_one.cells[1]).value = parseInt(get_firstchild(tr_one.cells[1]).value) - 1;
        get_firstchild(tr_two.cells[1]).value = parseInt(get_firstchild(tr_two.cells[1]).value) + 1;
    } else {
        alert("已经到顶了！");
    }
}

function moveDown(obj) {
    var tr_one = obj; //.parentNode.parentNode;
    var tr_parent = tr_one.parentNode;
    //这时应该找到这一行的下一行用到nextSibling
    var tr_two = tr_one.nextSibling;
    if (tr_two != null) {
        tr_parent.insertBefore(tr_two, tr_one);
        get_firstchild(tr_one.cells[1]).value = parseInt(get_firstchild(tr_one.cells[1]).value) + 1;
        get_firstchild(tr_two.cells[1]).value = parseInt(get_firstchild(tr_two.cells[1]).value) - 1;
    } else {
        alert("已经到底了！");
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


