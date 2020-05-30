var usetype;

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
            "TableName": "pbReportData",
            "Fields": "iRecNo,iFormID,iSerial,sSql,sRemark,sPbName,sParms,sLinkField,sImg,iDataSourceFromList,sReportType,sImageFields,sGroup,isChild,iHide,sAfterPrintStoredProcedure",
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

        $("#tbFormPb").datagrid({
            fit: true,
            border: false,
            columns: [
                [
                    { title: "表单号", field: "iFormID", width: 80 },
                    { title: "表单名", field: "sMenuName", width: 100 },
                    { title: "报表名称", field: "sPbName", width: 100 },
                    { title: "唯一号", field: "iRecNo", width: 80 },
                    { title: "序号", field: "iSerial", width: 80 }
                ]
            ],
            singleSelect: true,
            onSelect: function (index, row) {
                selectPbRow = row;
            },
            onDblClickRow: function (index, row) {
                saveSelectPb();
            },
            toolbar: "#divMenu"
        });
        doPbSearch();
        
    }
    
});

function itemclick(text) {
    if (text == "保存") {
        var resuslt = operate();
        if (resuslt.indexOf("error") > -1) {
            alert(resuslt);
        }
        else {
            alert("保存成功！");
        }
    }
    if (text == "增加行") {
        addrow("tab");
    }
    if (text == "删除行") {
        deleterow('tab');
    }
}
function operate() {
    var jsonstr = tabgetdata("tab").replace(/%/g, "%25");
    var json = {
        "TableName": "pbReportData",
        "FieldKeysValues": document.getElementById("Text1").value
    }
    var url = "/Base/Handler/DataOperatorForSys.ashx";
    var parms = "from=sysprintdataset&mainquery=" + encodeURIComponent(JSON.stringify(json)) + "&detaildata=" + encodeURIComponent(jsonstr);
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
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px'><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + obj.iFormID + "' />";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' fieldid='iSerial' fieldtype='int' class='inputnoborder' value='" + obj.iSerial + "' style='text-align:center' />" +
    "<input type='hidden' value='" + document.getElementById("HiddenField1").value + "' fieldid='sUserID' fieldtype='char' />" +
    "<input type='hidden' value='" + getNowTime() + "' fieldid='dInputDate' fieldtype='datetime' />"
    var td21 = tr.insertCell(-1);
    td21.innerHTML = "<input type='text' class='inputnoborder' fieldid='iRecNo' style='width:40px;height:30px;' fieldtype='char' readonly='readonly' value='" + obj.iRecNo + "' />";
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' class='inputnoborder' fieldid='sPbName' style='width:150px;height:70px;' fieldtype='char' value='" + obj.sPbName + "'/>";

    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea  fieldid='sSql' fieldtype='char' style='width:98%;height:100px;overflow:auto;'>" + obj.sSql + "</textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea  fieldid='sGroup' fieldtype='char' style='width:98%;height:60px;'>" + obj.sGroup + "</textarea>";

    var td7 = tr.insertCell(-1);
    td7.innerHTML = "<textarea readonly='readonly' fieldid='sLinkField' style='width:90px;height:70px;' fieldtype='char' >" + obj.sLinkField + "</textarea><a href='javascript:void(0)' onclick='openFormPb(this)'>选择</a>";
    //var checked = obj.iDataSourceFromList == "1" ? "checked='checked'" : "";
    //td7.innerHTML = "<input type='checkbox' style='width:15px; height:15px' fieldid='iDataSourceFromList' " + checked + " />";
    var td71 = tr.insertCell(-1);
    td71.innerHTML = "<textarea fieldid='sParms' style='width:80px;height:70px;' >" + obj.sParms + "</textarea>";

    var td4 = tr.insertCell(-1);
    var checkedHide = obj.iHide == "1" ? "checked='checked'" : "";
    td4.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='iHide' " + checkedHide + " />";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<textarea  fieldid='sAfterPrintStoredProcedure' fieldtype='char' style='width:98%;height:80px;'>" + obj.sAfterPrintStoredProcedure + "</textarea>";
    var td10 = tr.insertCell(-1);
    var checked = obj.iDataSourceFromList == "1" ? "checked='checked'" : "";
    td10.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='iDataSourceFromList' " + checked + " />";
    var td13 = tr.insertCell(-1);
    var checked1 = obj.isChild == "1" ? "checked='checked'" : "";
    td13.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='isChild' " + checked1 + " />";

    var td101 = tr.insertCell(-1);
    td101.innerHTML = "<textarea  fieldid='sImageFields' fieldtype='char' style='width:98%;height:100px;'>" + obj.sImageFields + "</textarea>";

    var td11 = tr.insertCell(-1);
    var innerHtml = "<select name='sReportType' fieldid='sReportType'><option value='fastreport'>fastreport</option><option value='stimulsoftreport'>stimulsoftreport</option><option value='lodop'>lodop</option></select>";
    if (obj.sReportType == "fastreport") {
        innerHtml = "<select name='sReportType' fieldid='sReportType'><option value='fastreport' selected='selected'>fastreport</option><option value='lodop'>lodop</option></select>";
    }
        //else if (obj.sReportType == "stimulsoftreport") {
        //    innerHtml = "<select name='sReportType' fieldid='sReportType'><option value='fastreport'>fastreport</option><option value='lodop'>lodop</option></select>";
        //}
    else if (obj.sReportType == "lodop") {
        innerHtml = "<select name='sReportType' fieldid='sReportType'><option value='fastreport'>fastreport</option><option value='lodop' selected='selected'>lodop</option></select>";
    }
    td11.innerHTML = innerHtml;
    /*var td5 = tr.insertCell(-1);
    td5.innerHTML = "<textarea  fieldid='sRemark' fieldtype='char' style='width:100%;height:100px;'>" + obj.sRemark + "</textarea>";*/
    var td6 = tr.insertCell(-1);
    //td6.innerHTML = "<a href='/Base/PbPage.aspx?otype=design&iformid=" + obj.iFormID + "&irecno=" + obj.iRecNo + "' target='ifrpb'>设计</a>";
    td6.innerHTML = "<a href='#' onclick='doDesign(this," + obj.iRecNo + ")'>设计</a>";
    //    var td9 = tr.insertCell(-1);
    //    td9.innerHTML = "<a href='javascript:void(0)' onclick='designStimulsoftReport(this)' >设计1</a>";
    rowcount++;
}
function setSelectValue(selectid, value) {
    document.getElementById(selectid).value = value;
}

function addrow(childid) {
    var table = document.getElementById(childid);
    var tr = table.insertRow(table.rows.length);
    var td0 = tr.insertCell(-1);
    var maxirecno = getChildID("pbReportData");
    td0.innerHTML = "<input type='checkbox' style='width:12px; height:12px'><input type='hidden' fieldid='iFormID' fieldtype='int' value='" + getQueryString("iformid") + "' />";
    var td1 = tr.insertCell(-1);
    td1.innerHTML = "<input type='text' fieldid='iSerial' fieldtype='int' class='inputnoborder' style='text-align:center' value='" + (rowcount + 1).toString() + "' />" +
    "<input type='hidden' value='" + document.getElementById("HiddenField1").value + "' fieldid='sUserID' fieldtype='char' />" +
    "<input type='hidden' value='" + getNowTime() + "' fieldid='dInputDate' fieldtype='datetime' />"
    var td21 = tr.insertCell(-1);
    td21.innerHTML = "<input type='text' class='inputnoborder' fieldid='iRecNo' style='width:40px;height:30px;' readonly='readonly' value='" + maxirecno + "' fieldtype='char' />";
    var td2 = tr.insertCell(-1);
    td2.innerHTML = "<input type='text' class='inputnoborder' fieldid='sPbName' style='width:150px;height:70px;' fieldtype='char' />";
    var td3 = tr.insertCell(-1);
    td3.innerHTML = "<textarea  fieldid='sSql' fieldtype='char' style='width:98%;height:100px;overflow:auto;'></textarea>";
    var td12 = tr.insertCell(-1);
    td12.innerHTML = "<textarea  fieldid='sGroup' fieldtype='char' style='width:98%;height:60px;'></textarea>";

    var td7 = tr.insertCell(-1);
    td7.innerHTML = "<textarea readonly='readonly' fieldid='sLinkField'  style='width:90px;height:70px;' ></textarea><a href='javascript:void(0)' onclick='openFormPb(this)'>选择</a>";
    //td7.innerHTML = "<input type='checkbox' style='width:15px; height:15px' fieldid='iDataSourceFromList' />";
    var td71 = tr.insertCell(-1);
    td71.innerHTML = "<textarea fieldid='sParms' style='width:80px;height:70px;' ></textarea>";

    var td4 = tr.insertCell(-1);
    //var checkedHide = obj.iHide == "1" ? "checked='checked'" : "";
    td4.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='iHide' />";
    var td8 = tr.insertCell(-1);
    td8.innerHTML = "<textarea  fieldid='sAfterPrintStoredProcedure' fieldtype='char' style='width:98%;height:80px;'></textarea>";
    var td10 = tr.insertCell(-1);
    td10.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='iDataSourceFromList' />";
    var td13 = tr.insertCell(-1);
    //var checked1 = obj.isChild == "1" ? "checked='checked'" : "";
    td13.innerHTML = "<input type='checkbox' style='width:18px; height:18px' fieldid='isChild' />";

    var td101 = tr.insertCell(-1);
    td101.innerHTML = "<textarea  fieldid='sImageFields' fieldtype='char' style='width:98%;height:100px;'></textarea>";
    var td11 = tr.insertCell(-1);
    var innerHtml = "<select name='sReportType' fieldid='sReportType'><option value='fastreport'>fastreport</option><option value='lodop'>lodop</option></select>";
    td11.innerHTML = innerHtml;
    /*var td5 = tr.insertCell(-1);
    td5.innerHTML = "<textarea  fieldid='sRemark' fieldtype='char' style='width:100%;height:100px;'></textarea>";*/
    var td6 = tr.insertCell(-1);
    //td6.innerHTML = "<a href='/Base/PbPage.aspx?otype=design&iformid=" + getQueryString("iformid") + "&irecno=" + maxirecno + "' target='ifrpb'>设计</a>";
    td6.innerHTML = "<a href='#' onclick='doDesign(this," + maxirecno + ")'>设计</a>";
    //    var td9 = tr.insertCell(-1);
    //    td9.innerHTML = "<a href='javascript:void(0)' onclick='designStimulsoftReport(this)' >设计1</a>";
    rowcount++;
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
        jsonstr = "[]";
    }
    return jsonstr;
}

//获取子表主键值
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

function getChildNodes(obj) {
    var childnodes = new Array();
    var childS = obj.childNodes;
    for (var i = 0; i < childS.length; i++) {
        if (childS[i].nodeType == 1)
            childnodes.push(childS[i]);
    }
    return childnodes;
}
//StimulsoftReport
function designStimulsoftReport(obj) {
    var tr = obj.parentNode.parentNode;
    var td = getChildNodes(tr)[4];
    //var check = get_firstchild(td);
    var c = true;
    if (c) {
        var td0 = getChildNodes(tr)[0];
        var iRecNo = getChildNodes(td0)[1].value;
        lastRecNo = iRecNo;

        //window.open('/Base/PbPageNew.aspx?otype=design&iformid=' + getQueryString('iformid') + '&irecno=' + lastRecNo, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
        hxStimulsoftReport.showDesinger(true, lastRecNo, getQueryString('iformid'), null, null);

    }
}

function doDesign(obj, irecno) {
    var tr = obj.parentNode.parentNode;
    var reportTypeTd = getChildNodes(tr)[12];
    var select = get_firstchild(reportTypeTd);
    var reportType = select.value;
    var titleTd = getChildNodes(tr)[3];
    var title = get_firstchild(titleTd).value;
    if (reportType == "fastreport") {
        $("#ifrpb").attr("src", "");
        var url = "/Base/PbPage.aspx?otype=design&iformid=" + getQueryString("iformid") + "&irecno=" + irecno;
        $("#ifrpb").attr("src", url);
    }
    else if (reportType == "stimulsoftreport") {
        hxStimulsoftReport.showDesinger(true, irecno, getQueryString('iformid'), null);
    }
    else if (reportType == "lodop") {
        window.open('/Base/PbLodop.aspx?iformid=' + getQueryString('iformid') + '&irecno=' + irecno + "&title=" + escape(title), '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
    }
}
var theBtn = undefined;
function openFormPb(obj) {
    $("#divPbSelect").dialog("open");
    theBtn = obj;
}
var selectPbRow = undefined;
function saveSelectPb() {
    var showText = selectPbRow.iRecNo + "," + selectPbRow.iFormID + "," + selectPbRow.sPbName;    
    $(theBtn).prev().val(showText);
    $("#divPbSelect").dialog("close");
}

function doPbSearch() {
    var iFormID = $("#txbPbFormID").textbox("getValue");
    var sMenuName = $("#txbPbMenuName").textbox("getValue");
    var PbName = $("#txbPbFormIDPbName").textbox("getValue");
    var filters = [
        //{ Field: "a.iFormID", ComOprt: "<>", Value: getQueryString("iformid"),LinkOprt:"and" },
        { Field: "isnull(a.sLinkField,'')", ComOprt: "=", Value: "''" }
    ];
    if (iFormID != "") {
        if (filters.length > 0) {
            filters[filters.length - 1].LinkOprt = "and";
        }
        filters.push({
            Field: "a.iFormID", ComOprt: "like", Value: "'%" + iFormID + "%'"
        })
    }
    if (sMenuName != "") {
        if (filters.length > 0) {
            filters[filters.length - 1].LinkOprt = "and";
        }
        filters.push({
            Field: "b.sMenuName", ComOprt: "like", Value: "'%" + sMenuName + "%'"
        })
    }
    if (PbName != "") {
        if (filters.length > 0) {
            filters[filters.length - 1].LinkOprt = "and";
        }
        filters.push({
            Field: "a.sPbName", ComOprt: "like", Value: "'%" + PbName + "%'"
        })
    }
    var pbObj = {
        TableName: "pbReportData as a left join FSysMainMenu as b on a.iFormID=b.iFormID",
        Fields: "a.iRecNo,a.iFormID,a.iSerial,a.sPbName,b.sMenuName",
        SelectAll: "True",
        Filters: filters,
        Sorts: [
            {
                SortName: "a.iFormID", SortOrder: "asc"
            }, {
                SortName: "a.iSerial", SortOrder: "asc"
            }
        ]
    }
    var otherPbObj = SqlGetData(pbObj);
    $("#tbFormPb").datagrid("loadData", otherPbObj);
}