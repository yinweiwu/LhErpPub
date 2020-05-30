var usetype;
var s3;
var s4;
var s5;

//扩展一个 多行文本框 的编辑器
$.ligerDefaults.Grid.editors['textarea'] = {
    create: function (container, editParm) {
        var input = $("<textarea class='l-textarea' />");
        container.append(input);
        return input;
    },
    getValue: function (input, editParm) {
        return input.val();
    },
    setValue: function (input, value, editParm) {
        input.val(value);
    },
    resize: function (input, width, height, editParm) {
        var column = editParm.column;
        if (column.editor.width) input.width(column.editor.width);
        else input.width(width);
        if (column.editor.height) input.height(column.editor.height);
        else input.height(height);
    }
};

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

var tablename;
$(function () {
    $("#divup").ligerTab({ onAfterSelectTabItem: f_tabselected });
    $("#divmain").ligerTab();
    var zd;
    var mainzd;
    var zddata = [];
    var selectedtablename;
    var detailmainzd;

    var tablenames;
    //表名字段
    var jsontablenamefilter = [{
        "Field": "XType",
        "ComOprt": "=",
        "Value": "'U'"
    }]
    var jsonsort = [{
        "SortName": "Name",
        "SortOrder": "asc"
    }]
    var jsontablename = {
        "TableName": "SysObjects",
        "Fields": "Name",
        "SelectAll": "True",
        "Filters": jsontablenamefilter,
        "Sorts": jsonsort
    }
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsontablename));
    var result = callpostback("/Base/Handler/DataBuilder.ashx", parms, false, true);
    if (result && result.length > 0) {
        try {
            var jsonresult = eval("(" + result + ")");
            tablenames = jsonresult.Rows;
        }
        catch (e) {
            tablenames = [];
            alert(e.Message);
        }
    }
    else {
        tablenames = [];
    }

    var s1 = new InputSelect({ tid: "divs1", width: 120, valuearr: tablenames, name: "Name", fieldid: "fieldid", fieldtype: "", onchange: "mselectChg(this)" });
    var s2 = new InputSelect({ tid: "divs2", width: 120, valuearr: tablenames, name: "Name", fieldid: "fieldid", fieldtype: "", onchange: "cselectChg(this)" });

    s3 = new InputSelect({ tid: "divs3", width: 120, valuearr: [], name: "Name", fieldid: "fieldid", fieldtype: "" });
    s4 = new InputSelect({ tid: "divs4", width: 120, valuearr: [], name: "Name", fieldid: "fieldid", fieldtype: "" });
    s5 = new InputSelect({ tid: "divs5", width: 120, valuearr: [], name: "Name", fieldid: "fieldid", fieldtype: "" });

    //日期格式字段
    var jsondatetypefilter = [{
        "Field": "sClassID",
        "ComOprt": "=",
        "Value": "'typeBillNo'"
    }]
    var jsondatetype = {
        "TableName": "BscDataListD",
        "Fields": "sCode",
        "SelectAll": "True",
        "Filters": jsondatetypefilter
    }
    $("#Text4").ligerComboBox(
    {
        url: '/Base/Handler/DataBuilder.ashx',
        parms: { Rnd: Math.random(), plugintype: 'combobox', sqlqueryobj: encodeURIComponent(JSON.stringify(jsondatetype)) },
        valueField: 'sCode',
        textField: 'sCode',
        cancelable: true
    }
    );
    if (getQueryString("iformid") != null) {
        var iformid = getQueryString("iformid");
        iformid = iformid == "null" ? 0 : iformid;
        document.getElementById("fieldkeyvalue").value = iformid;
        var jsonfiltertabledata = [
    {
        "Field": "iFormID",
        "ComOprt": "=",
        "Value": "'" + iformid + "'"
    }
    ]
        var jsonobjtabledata = {
            "TableName": "bscDataBill",
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

                    s1.setValue(initjsonstr.Rows[0].sTableName);
                    s2.setValue(initjsonstr.Rows[0].sDetailTableName);
                    //document.getElementById("Select1").value = initjsonstr.Rows[0].sTableName;
                    //document.getElementById("Select4").value = initjsonstr.Rows[0].sDetailTableName;

                    var selvalue = initjsonstr.Rows[0].sTableName;
                    var selvalue2 = initjsonstr.Rows[0].sDetailTableName;
                    var jsonfieldfilter = [{
                        "Field": "id",
                        "ComOprt": "=",
                        "Value": "Object_Id('" + selvalue + "')"
                    }]

                    var jsonfieldfilter2 = [{
                        "Field": "id",
                        "ComOprt": "=",
                        "Value": "Object_Id('" + selvalue2 + "')"
                    }]

                    var jsonfield = {
                        "TableName": "SysColumns",
                        "Fields": "Name",
                        "SelectAll": "True",
                        "Filters": jsonfieldfilter
                    }

                    var jsonfield2 = {
                        "TableName": "SysColumns",
                        "Fields": "Name",
                        "SelectAll": "True",
                        "Filters": jsonfieldfilter2
                    }

                    var url = "/Base/Handler/DataBuilder.ashx";
                    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonfield));
                    var async = false;
                    var ispost = true;
                    var resultstr = callpostback(url, parms, async, ispost);
                    var parms2 = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonfield2));
                    var resultstr2 = callpostback(url, parms2, async, ispost);
                    try {
                        if (resultstr.length > 0) {
                            var jsonresult = eval("(" + resultstr + ")");
                            s3 = new InputSelect({ tid: "divs3", width: 120, valuearr: jsonresult.Rows, name: "Name", fieldid: "fieldid", fieldtype: "" });
                            s4 = new InputSelect({ tid: "divs4", width: 120, valuearr: jsonresult.Rows, name: "Name", fieldid: "fieldid", fieldtype: "" });
                        }
                    }
                    catch (e) {
                        alert(e.Message);
                    }

                    try {
                        if (resultstr2.length > 0) {
                            var jsonresult = eval("(" + resultstr2 + ")");
                            s5 = new InputSelect({ tid: "divs5", width: 120, valuearr: jsonresult.Rows, name: "Name", fieldid: "fieldid", fieldtype: "" });
                        }
                    }
                    catch (e) {
                        alert(e.Message);
                    }
                    s3.setValue(initjsonstr.Rows[0].sFieldKey);
                    s4.setValue(initjsonstr.Rows[0].sFieldName);
                    s5.setValue(initjsonstr.Rows[0].sDeitailFieldKey);

                }
                else {
                    var jsonnewfilter = [{
                        "Field": "iFormID",
                        "ComOprt": "=",
                        "Value": iformid
                    }]
                    var jsonnewobj = {
                        "TableName": "FSysMainMenu",
                        "Fields": "iFormID,sMenuName,NewID() as newguid",
                        "SelectAll": "True",
                        "Filters": jsonnewfilter
                    }
                    parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonnewobj));
                    var resultnewstr = callpostback(url, parms, async, ispost);
                    if (resultnewstr.length > 0) {
                        var jsonnewobj = eval("(" + resultnewstr + ")");
                        document.getElementById("Text2").value = jsonnewobj.Rows[0].iFormID;
                        //document.getElementById("Text7").value = "{" + jsonnewobj.Rows[0].newguid + "}";
                        document.getElementById("Text8").value = jsonnewobj.Rows[0].sMenuName;
                    }
                }
            }
        }
        catch (e) {
            //alert(e.Message);
        }

        //第一个子表初始化
        var sqlcomm1 = "select * from bscDataBillD where iFormID=" + iformid + " order by iSerial asc,dinputDate asc ";
        var jsonobjpro = SqlGetDataComm(sqlcomm1);
        for (var i1 = 0; i1 < jsonobjpro.length; i1++) {
            addrowinit1(jsonobjpro[i1]);
        }
        //第三个子表初始化
        var jsonfilter = [
        {
            Field: "iFormID",
            ComOprt: "=",
            Value: getQueryString("iformid")
        }
        ];
        var jsonobj = {
            TableName: "bscDataBillDUser",
            Fields: "*",
            SelectAll: "True",
            Filters: jsonfilter
        }
        var sqldata = SqlGetDataGrid(jsonobj);
        if (sqldata.Rows) {
            for (var i2 = 0; i2 < sqldata.Rows.length; i2++) {
                addrowinit3(sqldata.Rows[i2]);
            }
        }
    }

    $("#divtool").ligerToolBar({
        items: [
        {
            text: '保存', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif'
        }
    ]
    });

    $("#divtool1").ligerToolBar({
        items: [
        {
            id: 'add', text: '增加行', click: itemclick1, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            id: 'delete', text: '删除行', click: itemclick1, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
        }
    ]
    });
    $("#divtool3").ligerToolBar({
        items: [
        {
            id: 'add', text: '增加行', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif'
        },
        { line: true },
        {
            id: 'delete', text: '删除行', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif'
        }
    ]
    });
    $("#divtab").ligerTab({
        onAfterSelectTabItem: f_tabselected
    });
    storeswitch();
});
function itemclick(item) {
    if (item.text == "保存") {
        if (beforePageSave() == true) {
            if (usetype == "add") {
                var resuslt = oprateadd("/Base/Handler/DataOperatorForSys.ashx", "from=sysbillnocheck");
                if (resuslt.indexOf("error") > -1) {
                    alert(resuslt);
                }
                else {
                    alert("保存成功！");
                }
            }
            else {
                var resuslt = operateupdate("/Base/Handler/DataOperatorForSys.ashx", "from=sysbillnocheck");
                if (resuslt.indexOf("error") > -1) {
                    alert(resuslt);
                }
                else {
                    alert("保存成功！");
                }
            }
        }
    }
}
function itemclick1(item) {
    if (item.id == "add") {
        addrow1();
    }
    else if (item.id == "delete") {
        deleterow("tabcheckpro");
    }
}
function itemclick2(item) {
    if (item.id == "add") {
        var popup = new PopupWin({
            type: "import", //类型，有form和import
            width: 800, //打开的宽度
            height: 500, //高度
            toTable: //针对子表
            {
            ttid: "songrid1",
            matchfield: ["iMenuID=iMenuID", "sMenuName=sMenuName", "sFilePath=sFilePath", "iAssFormID=iFormID"],
            iscover: false,
            //tablename: "SdOrderD",
            //fieldkey: "iRecNo",
            //以下是对import
            sqlobj:
			    {
			        TableName: "View_Yww_FSysMainMenu",
			        Fields: "iMenuID,sMenuName,sFilePath=case when len(isnull(sParms,''))>0 then sFilePath+'?'+substring(isnull(sParms,''),6,len(sParms)-5)+'&' else sFilePath+'?' end,iFormID",
			        SelectAll: "True",
			        FieldKeys: "iMenuID"/*,
			        Filters: [
                    {
                        Field: "isnull(sFilePath,'')",
                        ComOprt:"<>",
                        Value:"''"
                    }
                    ]*/
			    },
            columns: [
                    { display: "菜单ID", name: "iMenuID" },
                    { display: "单据名称", name: "sMenuName", type: "string" },
                    { display: "路径", name: "sFilePath",width:300 },
                    { display: "FORMID", name: "iFormID" }
                ],
            pagesize: 30,
            title: "选择数据"
        }
    });
    popup.PopupOpen();
}
else if (item.id == "delete") {
    var songrid = $.ligerui.get('songrid1');
    if (songrid.getSelectedRows().length > 0) {
        if (confirm("确认删除所选数据?")) {
            songrid.deleteRange(songrid.getSelectedRows());
        }
    }
}
}
function itemclick3(item) {
    if (item.id == "add") {
        addrow3();
    }
    else if (item.id == "delete") {
        deleterow("tableuser");
    }
}
var thisloaded1 = false;
var thisloaded2 = false;
function f_tabselected(item) {
    if (item == "tabitem3") {
        if (thisloaded1 == true) {
            return;
        }
        var jfdata = [
            { text: '是', value: '1' },
            { text: '否', value: '0' }
        ];

        var jsonfilter = [
        {
            Field: "iFormid",
            ComOprt: "=",
            Value: getQueryString("iformid")
        }
        ];
        var jsonsort = [{
            SortName: "iSerial",
            SortOrder: "asc"
        }]
        var jsonobj = {
            TableName: "VwbscDataBillDForm",
            Fields: "*",
            SelectAll: "True",
            Filters: jsonfilter,
            Sorts: jsonsort
        }

        $("#songrid1").ligerGrid({
            columns: [
            { display: "序号", name: "iSerial", width: 50, editor: { type: "int"} },
            { display: "关联单据FORMID", name: 'iAssFormID', width: 120 },
            { display: "关联单据菜单ID", name: 'iMenuID', width: 120 },
            { display: '关联单据名', name: 'sMenuName', width: 150, editor: { type: "text"} },
            { display: "路径", name: 'sFilePath', width: 120 },
            { display: "关联参数", name: "sParamValue", width: 300, editor: { type: "textarea", width: 300, height: 50} },
            { display: '双击打开', name: 'iClick', width: 80, editor: { type: "select", data: jfdata, valueField: 'value', textField: 'text' },
                render: function (item) {
                    for (var i = 0; i < jfdata.length; i++) {
                        if (item.iClick == jfdata[i].value) {
                            return jfdata[i].text;
                        }
                    }
                    return item.iClick;
                }
            },
    { display: "备注", name: "sReMark", width: 150, editor: { type: "textarea", width: 150, height: 50} }
    ],
            usePager: false,
            checkbox: true,
            enabledEdit: true,
            rowHeight: 25,
            //onBeforeEdit: f_gridOprt_onBeforeEdit,
            //onAfterEdit: f_gridOprt_onAfterEdit,
            onAfterAddRow: f_afteraddrow1,
            columnWidth: 100,
            isScroll: true,
            selectRowButtonOnly: true,
            enabledSort: false,
            height: '98%',
            inWindow: true,
            parms: { plugintype: "grid", sqlqueryobj: encodeURIComponent(JSON.stringify(jsonobj)) },
            url: "/Base/Handler/DataBuilder.ashx",
            toolbar:
                { items: [
                    { id: 'add', text: '增加', click: itemclick2, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif' },
                    { line: true },
    { id: 'delete', text: '删除行', click: itemclick2, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif' }
    ]
                }
        });
        thisloaded1 = true;
    }
    else if (item == "tabitem4") {
        if (thisloaded2 == true) {
            return;
        }
        var jsonfilter = [
        {
            Field: "bu.iFormID",
            ComOprt: "=",
            Value: getQueryString("iformid"),
            LinkOprt: "and"
        },
        {
            Field: "bu.sUserID",
            ComOprt: "=",
            Value: "bp.sCode"
        }
        ];
        var jsonobj = {
            TableName: "bscDataBillDUser as bu,bscDataPerson as bp",
            Fields: "bu.sUserID,bu.GUID,bu.iFormID,bp.sName",
            SelectAll: "True",
            Filters: jsonfilter
        }

        $("#songrid2").ligerGrid({
            columns: [
            { display: "工号", name: "sUserID", width: 100 },
            { display: "姓名", name: 'sName', width: 150 }
            ],
            usePager: false,
            checkbox: true,
            enabledEdit: true,
            rowHeight: 25,
            //onBeforeEdit: f_gridOprt_onBeforeEdit,
            //onAfterEdit: f_gridOprt_onAfterEdit,
            onAfterAddRow: f_afteraddrow2,
            columnWidth: 100,
            isScroll: true,
            selectRowButtonOnly: true,
            enabledSort: false,
            height: 250,
            inWindow: true,
            parms: { plugintype: "grid", sqlqueryobj: encodeURIComponent(JSON.stringify(jsonobj)) },
            url: "/Base/Handler/DataBuilder.ashx",
            toolbar:
    { items: [
    { id: 'add', text: '增加', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif' },
    { line: true },
    { id: 'delete', text: '删除行', click: itemclick3, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif' }
    ]
    }
        });
        thisloaded2 = true;
    }

}

function f_afteraddrow1(rowdata) {
    var songrid = $.ligerui.get('songrid1');
    songrid.updateRow(songrid.rows[songrid.rows.length - 1], {
        GUID: NewGuid(),
        sUserID: document.getElementById("Hidden3").value,
        dInputDate: getNowDate() + ' ' + getNowTime(),
        iSerial: songrid.rows.length
    });
}
function f_afteraddrow2(rowdata) {
    var songrid = $.ligerui.get('songrid2');
    songrid.updateRow(songrid.rows[songrid.rows.length - 1], {
        GUID: NewGuid(),
        dInputDate: getNowDate() + ' ' + getNowTime()
    });
}

var rowcount1 = 0;
function addrowinit1(obj) {
    var table = document.getElementById("tabcheckpro");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea class='textareac' fieldid='iSerial' required='true' style='text-align:center; vertical-align:middle;'>" + obj.iSerial + "</textarea>";
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<textarea class='textareac' fieldid='sCheckName' >" + obj.sCheckName + "</textarea><input type='hidden' fieldid='dinputDate' value='" + obj.dinputDate + "' />";
    var td21 = tr.insertCell(-1);
    var sCheckType = obj.sCheckType;
    if (sCheckType == "单人审批" || sCheckType=="") {
        td21.innerHTML = "<select fieldid='sCheckType'><option value='单人审批' selected='selected'>单人审批</option><option value='会签'>会签</option><select>";
    }
    else {
        td21.innerHTML = "<select fieldid='sCheckType'><option value='单人审批' selected='selected'>单人审批</option><option value='会签' selected='selected'>会签</option><select>";
    }
    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea id='textarea" + rowcount1 + "' class='textareac' style='width:130px;' readonly='readonly' fieldid='sCheckPersonShow'>" + obj.sCheckPersonShow + "</textarea><input type='button' onclick=onOpenCheckManPage('" + rowcount1 + "') value='...' /><input type='hidden' id='hidden" + rowcount1 + "' fieldid='sCheckPerson' value=\"" + obj.sCheckPerson + "\" />";
    var td4 = tr.insertCell(-1);
    td4.innerHTML = "<textarea class='textareac' fieldid='sContion' >" + obj.sContion + "</textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea class='textareac' fieldid='sNextPushInform' >" + obj.sNextPushInform + "</textarea>";
    var td13 = tr.insertCell(-1);
    td13.innerHTML = "<textarea class='textareac' fieldid='iPushSerial' >" + obj.iPushSerial + "</textarea>";
    var td14 = tr.insertCell(-1);
    td14.innerHTML = "<textarea class='textareac' fieldid='iNoPushSerial' >" + obj.iNoPushSerial + "</textarea>";
    var td5 = tr.insertCell(-1);
    var checkstr1 = obj.iFinish == "1" ? "checked='checked'" : "";
    td5.innerHTML = "<input type='checkbox' fieldid='iFinish' " + checkstr1 + " ></textarea>";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<textarea class='textareac' fieldid='sFinishCondition' >" + obj.sFinishCondition + "</textarea>";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<textarea class='textareac' fieldid='sActionAgree' >" + obj.sActionAgree + "</textarea>";
    var td7 = tr.insertCell(-1);
    td7.innerHTML = "<textarea class='textareac' fieldid='sActionReturn' >" + obj.sActionReturn + "</textarea>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<textarea class='textareac' fieldid='sReturnContion' >" + obj.sReturnContion + "</textarea>";
    var td16 = tr.insertCell(-1);
    td16.innerHTML = "<textarea class='textareac' fieldid='sActionCancel' >" + obj.sActionCancel + "</textarea>";
    var td9 = tr.insertCell(-1);
    td9.innerHTML = "<textarea class='textareac' fieldid='sBeforeAgree' >" + obj.sBeforeAgree + "</textarea>";
    /*var td10 = tr.insertCell(-1);
    td10.innerHTML = "<textarea class='textareac' fieldid='sBeforeAgree' >" + obj.sBeforeAgree + "</textarea>";*/
    var td11 = tr.insertCell(-1);
    td11.innerHTML = "<textarea class='textareac' fieldid='sBeforeReturn' >" + obj.sBeforeReturn + "</textarea>";
    var td15 = tr.insertCell(-1);
    td15.innerHTML = "<textarea class='textareac' fieldid='sModifyFields' >" + obj.sModifyFields + "</textarea>";
    rowcount1++;
}
var rowcount3 = 0;
function addrowinit3(obj) {
    var table = document.getElementById("tableuser");
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + obj.GUID + "'/>";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea id='usertextarea" + rowcount3 + "' class='textareac' style='width:175px' readonly='readonly' fieldid='sUserShow'>" + obj.sUserShow + "</textarea><input type='button' style='width:20px;' onclick=onOpenCheckManPage3('" + rowcount3 + "') value='...' /><input type='hidden' id='userhidden" + rowcount3 + "' value=\"" + obj.sUserID + "\" fieldid='sUserID' />";
    rowcount3++;
}
function addrow1() {
    var table = document.getElementById("tabcheckpro");
    var tr = table.insertRow(table.rows.length);
    var nguid = NewGuid();
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + nguid + "'/>";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea class='textareac' required='true' fieldid='iSerial' style='text-align:center; vertical-align:middle;' ></textarea>";
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<textarea class='textareac' fieldid='sCheckName' ></textarea><input type='hidden' fieldid='dinputDate' value='" + getNowDate() + " " + getNowTime() + "' />";
    var td21 = tr.insertCell(-1);
    td21.innerHTML = "<select fieldid='sCheckType'><option value='单人审批' selected='selected'>单人审批</option><option value='会签'>会签</option><select>";
    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea id='textarea" + rowcount1 + "' class='textareac' style='width:130px' readonly='readonly' fieldid='sCheckPersonShow'></textarea><input type='button' onclick=onOpenCheckManPage('" + rowcount1 + "') value='...' /><input type='hidden' id='hidden" + rowcount1 + "' fieldid='sCheckPerson' />";
    var td4 = tr.insertCell(-1);
    td4.innerHTML = "<textarea class='textareac' fieldid='sContion' ></textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea class='textareac' fieldid='sNextPushInform' ></textarea>";
    var td13 = tr.insertCell(-1);
    td13.innerHTML = "<textarea class='textareac' fieldid='iPushSerial' ></textarea>";
    var td14 = tr.insertCell(-1);
    td14.innerHTML = "<textarea class='textareac' fieldid='iNoPushSerial' ></textarea>";
    var td5 = tr.insertCell(-1);    
    //var checkstr1 = obj.iFinish == "1" ? "checked='checked'" : "";
    td5.innerHTML = "<input type='checkbox' fieldid='iFinish' />";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<textarea class='textareac' fieldid='sFinishCondition' ></textarea>";
    var td6 = tr.insertCell(-1);
    td6.innerHTML = "<textarea class='textareac' fieldid='sActionAgree' ></textarea>";
    var td7 = tr.insertCell(-1);
    td7.innerHTML = "<textarea class='textareac' fieldid='sActionReturn' ></textarea>";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<textarea class='textareac' fieldid='sReturnContion'></textarea>";
    var td16 = tr.insertCell(-1);
    td16.innerHTML = "<textarea class='textareac' fieldid='sActionCancel' ></textarea>";
    var td9 = tr.insertCell(-1);
    td9.innerHTML = "<textarea class='textareac' fieldid='sBeforeAgree'></textarea>";
    /*var td10 = tr.insertCell(-1);
    td10.innerHTML = "<textarea class='textareac' fieldid='sBeforeAgree'></textarea>";*/
    var td11 = tr.insertCell(-1);
    td11.innerHTML = "<textarea class='textareac' fieldid='sBeforeReturn'></textarea>";
    var td15 = tr.insertCell(-1);
    td15.innerHTML = "<textarea class='textareac' fieldid='sModifyFields'></textarea>";
    rowcount1++;
}

function addrow3() {
    var table = document.getElementById("tableuser");
    var tr = table.insertRow(table.rows.length);
    var nguid = NewGuid();
    var td0 = tr.insertCell(-1);
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px' /><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' /><input type='hidden' fieldid='GUID' fieldtype='char' value='" + nguid + "'/>";    
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<textarea id='usertextarea" + rowcount3 + "' class='textareac' style='width:175px' readonly='readonly' fieldid='sUserShow'></textarea><input type='button' style='width:20px;' onclick=onOpenCheckManPage3('" + rowcount3 + "') value='...' /><input type='hidden' id='userhidden" + rowcount3 + "' fieldid='sUserID' />";
    rowcount3++;
}
function onOpenCheckManPage(cid) {
    var value = document.getElementById("hidden" + cid).value;
    var value = value.replace(/%/g, "%25");
    var value = escape(value);
    var url = "SelectCheckMan.htm?svalue=" + value;
    var reuslt = OpenModelPage(url, "500px", "280px");
    if (reuslt != undefined && reuslt != null) {
        var showtext = "";
        var otype = reuslt.split(";")[0];
        var sp = reuslt.split(";")[1]; ;
        var sindex;
        var svalue;
        if (parseInt(otype) < 3) {
            sindex = sp.split(":")[0];
            svalue = sp.split(":")[1];
        }
        else {
            svalue = reuslt.substr(reuslt.indexOf(";") + 1, reuslt.length - reuslt.indexOf(";") - 1);
        }
        switch (otype) {
            case "0":
                {
                    //document.getElementById("Radio1").checked = true;
                    showtext = "部门主管：";
                    if (sindex == "0") {
                        var sqltext = "select sclassname from bscdataclass where sclassid='" + svalue + "' and itype='07'";
                        var sqldata = SqlGetDataComm(sqltext);
                        if (sqldata.length > 0) {
                            showtext += sqldata[0].sclassname;
                        }
                        else {
                            showtext += "[未知部门]";
                        }
                    }
                    else if (sindex == "1") {
                        showtext += "表单域[" + svalue + "]";
                    }
                } break;
            case "1":
                {
                    //document.getElementById("Radio2").checked = true;
                    showtext += "角色："
                    if (sindex == "0") {
                        showtext += svalue ;
                    }
                } break;
            case "2":
                {
                    showtext = "人员："
                    if (sindex == "0") {
                        var sqltext = "select sname from bscdataperson where scode='" + svalue + "'";
                        var sqldata = SqlGetDataComm(sqltext);
                        if (sqldata.length > 0) {
                            showtext += sqldata[0].sname;
                        }
                        else {
                            showtext += "[未知人员]";
                        }
                    }
                    else if (sindex == "1") {
                        showtext += "表单域[" + svalue + "]";
                    }
                } break;
            case "3":
                {
                    showtext = "自定义：" + svalue;
                } break;
        }
        document.getElementById("textarea" + cid).value = showtext;
        document.getElementById("hidden" + cid).value = reuslt;
    }
}

function onOpenCheckManPage3(cid) {
    var value = document.getElementById("userhidden" + cid).value;
    var value = value.replace(/%/g, "%25");
    var value = escape(value);
    var url = "SelectCheckMan.htm?svalue=" + value;
    var reuslt = OpenModelPage(url, "500px", "280px");
    if (reuslt != undefined && reuslt != null) {
        var showtext = "";
        var otype = reuslt.split(";")[0];
        var sp = reuslt.split(";")[1]; ;
        var sindex;
        var svalue;
        if (parseInt(otype) < 3) {
            sindex = sp.split(":")[0];
            svalue = sp.split(":")[1];
        }
        else {
            svalue = sp;
        }
        switch (otype) {
            case "0":
                {
                    //document.getElementById("Radio1").checked = true;
                    showtext = "部门主管：";
                    if (sindex == "0") {
                        var sqltext = "select sclassname from bscdataclass where sclassid='" + svalue + "' and itype='07'";
                        var sqldata = SqlGetDataComm(sqltext);
                        if (sqldata.length > 0) {
                            showtext += sqldata[0].sclassname;
                        }
                        else {
                            showtext += "[未知部门]";
                        }
                    }
                    else if (sindex == "1") {
                        showtext += "表单域[" + svalue + "]";
                    }
                } break;
            case "1":
                {
                    //document.getElementById("Radio2").checked = true;
                    showtext += "角色："
                    if (sindex == "0") {
                        showtext += svalue;
                    }
                } break;
            case "2":
                {
                    showtext = "人员："
                    if (sindex == "0") {
                        var sqltext = "select sname from bscdataperson where scode='" + svalue + "'";
                        var sqldata = SqlGetDataComm(sqltext);
                        if (sqldata.length > 0) {
                            showtext += sqldata[0].sname;
                        }
                        else {
                            showtext += "[未知人员]";
                        }
                    }
                    else if (sindex == "1") {
                        showtext += "表单域[" + svalue + "]";
                    }
                } break;
            case "3":
                {
                    showtext = "自定义：" + svalue;
                } break;
        }
        document.getElementById("usertextarea" + cid).value = showtext;
        document.getElementById("userhidden" + cid).value = reuslt;
    }
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

function beforePageSave() {
    var iformid = getQueryString("iformid");
    var jsonfilter = [{
        "Field": "iFormid",
        "ComOprt": "=",
        "Value": "'" + iformid + "'"
    }];
    var josnobj = {
        "TableName": "bscDataBill",
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
function OpenModelPage(url, sWidth, sHeight) {
    return showModalDialog(url, "", "minimize:yes;maximize:yes;location=no;toolbar=no;status:yes;scroll:yes;resizable:yes;center:yes;dialogWidth=" + sWidth + ";dialogHeight=" + sHeight);
}

function SqlGetDataComm(sqltext, p_async, p_ispost) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
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
            return [];
        }
    }
    else {
        return [];
    }
}

function SqlGetDataGridComm(sqltext, p_async, p_ispost) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "ctype=text&rowcount=1&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
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
            return {};
        }
    }
    else {
        return {};
    }
}

//获取当前日期
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
//获取当前时间
function getNowTime() {
    var nowdate = new Date();
    var hour = nowdate.getHours();      //获取当前小时数(0-23)
    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
    var second = nowdate.getSeconds();
    return hour + ":" + minute + ":" + second;
}
function S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function NewGuid() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

//url处理页面，parms回传的参数，async是否异步，ispost是否是post方式
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

function mselectChg(obj) {
    var selvalue = obj.options[obj.selectedIndex].value;
    var jsonfieldfilter = [{
        "Field": "id",
        "ComOprt": "=",
        "Value": "Object_Id('" + selvalue + "')"
    }]

    var jsonfield = {
        "TableName": "SysColumns",
        "Fields": "Name",
        "SelectAll": "True",
        "Filters": jsonfieldfilter
    }

    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonfield));
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    try {
        if (resultstr.length > 0) {
            var jsonresult = eval("(" + resultstr + ")");
            s3.setOptions(jsonresult.Rows, "Name");
            //s3.setValue("");
            s4.setOptions(jsonresult.Rows, "Name");
            
        }
    }
    catch (e) {
        alert(e.Message);
    }
}

function cselectChg(obj) {
    var selvalue = obj.options[obj.selectedIndex].value;
    var jsonfieldfilter = [{
        "Field": "id",
        "ComOprt": "=",
        "Value": "Object_Id('" + selvalue + "')"
    }]

    var jsonfield = {
        "TableName": "SysColumns",
        "Fields": "Name",
        "SelectAll": "True",
        "Filters": jsonfieldfilter
    }

    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonfield));
    var async = false;
    var ispost = true;
    var resultstr = callpostback(url, parms, async, ispost);
    try {
        if (resultstr.length > 0) {
            var jsonresult = eval("(" + resultstr + ")");
            s5.setOptions(jsonresult.Rows, "Name");
            
        }
    }
    catch (e) {
        alert(e.Message);
    }
}
function storeswitch() {
    var obj = document.getElementById("Checkbox8");
    if (obj.checked == true) {
        document.getElementById("Checkbox3").disabled = false;
        document.getElementById("divform").style.display = "none";
        document.getElementById("divquery").style.display = "block";
        document.getElementById("TextArea1").removeAttribute("fieldid");
        document.getElementById("TextArea4").setAttribute("fieldid", "sShowSql");
    }
    else {
        document.getElementById("Checkbox3").checked = false;
        document.getElementById("Checkbox3").disabled = true;
        var divform = document.getElementById("divform");
        var divquery = document.getElementById("divquery");
        divform.style.display = "block";
        divquery.style.display = "none";
        document.getElementById("TextArea1").setAttribute("fieldid", "sShowSql");
        document.getElementById("TextArea4").removeAttribute("fieldid");
    }
}