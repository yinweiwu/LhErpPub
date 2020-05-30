document.write("<script src='/JS/JsonArrSort.js'></script>");
var userid = "";
$.ajax({
    url: "/ashx/LoginHandler.ashx",
    type: "get",
    async: false,
    cache: false,
    data: { otype: "getcurtuserid" },
    success: function (data) {
        userid = data;
    },
    error: function () {

    }
});
var dynLookupData;
var isMultiColumn = false;
var dynConditionGUID = undefined;
var dynConditionValue = undefined;
$(function () {
    FormUnionList.Render();
})

var FormUnionList = {
    mainDefined: undefined,
    childDefined: undefined,
    conditions: undefined,
    allButtonRight: undefined,
    Render: function () {
        //var mainDefined = JSON2.parse($("#HidMainDefined").val());
        FormUnionList.mainDefined = mainDefined;
        //var childDefined = JSON2.parse($("#HidChildDefined").val());
        FormUnionList.childDefined = childDefined;
        //var selfConditions = JSON2.parse($("#HidSelfCondition").val());
        FormUnionList.conditions = selfConditions;
        var iUseZoneCondition = mainDefined[0].iUseZoneCondition;
        //if ($("#HidDynData").val() != "") {
        //    dynLookupData = JSON2.parse($("#HidDynData").val());
        //}
        //条件
        FormUnionList.RenderCondition(selfConditions);
        //看看是什么型的
        var iShowType = mainDefined[0].iShowType;
        switch (iShowType) {
            case 1: {//上下型
                var upHeight = childDefined[0].iHeight;
                var downHeight = childDefined[1].iHeight;
                if (isNullOrDefinedOrZero(upHeight)) {
                    if (isNullOrDefinedOrZero(downHeight)) {
                        upHeight = 50; downHeight = 50;
                    } else {
                        upHeight = 100 - downHeight;
                    }
                }
                $("#divContent").append("<div class='easyui-layout' data-options='fit:true,border:false'><div id='div1' data-options='region:&apos;north&apos;,split:true,border:false' style='height:"+upHeight+"%'></div><div id='div2' data-options='region:&apos;center&apos;,border:false'></div></div>");
            } break;//左右型
            case 2: {
                var leftHeight = childDefined[0].iWidth;
                var rightHeight = childDefined[1].iWidth;
                if (isNullOrDefinedOrZero(leftHeight)) {
                    if (isNullOrDefinedOrZero(rightHeight)) {
                        leftHeight = 50; rightHeight = 50;
                    } else {
                        leftHeight = 100 - rightHeight;
                    }
                }
                $("#divContent").append("<div class='easyui-layout' data-options='fit:true,border:false'><div id='div1' data-options='region:&apos;west&apos;,split:true,border:false' style='width:" + leftHeight + "%'></div><div id='div2' data-options='region:&apos;center&apos;,border:false'></div></div>");
            } break;
            case 3: {//四象限
                var upHeight = childDefined[0].iHeight;
                var upLeftWidth = childDefined[0].iWidth;
                var upRightWidth = childDefined[1].iWidth;
                var downHeight = childDefined[2].iHeight;
                var downLeftWidth = childDefined[2].iWidth;
                var downRightWidth = childDefined[3].iWidth;

                if (isNullOrDefinedOrZero(upHeight)) {
                    if (isNullOrDefinedOrZero(downHeight)) {
                        upHeight = 50; downHeight = 50;
                    } else {
                        upHeight = 100 - downHeight;
                    }
                }
                if (isNullOrDefinedOrZero(upLeftWidth)) {
                    if (isNullOrDefinedOrZero(upRightWidth)) {
                        upLeftWidth = 50; upRightWidth = 50;
                    } else {
                        upLeftWidth = 100 - upRightWidth;
                    }
                }
                if (isNullOrDefinedOrZero(downLeftWidth)) {
                    if (isNullOrDefinedOrZero(downRightWidth)) {
                        downLeftWidth = 50; downRightWidth = 50;
                    } else {
                        downLeftWidth = 100 - downRightWidth;
                    }
                }
                var str = "<div class='easyui-layout' data-options='fit:true,border:false'>";

                str += "<div data-options='region:&apos;north&apos;,border:false,split:true' style='height:" + upHeight + "%'>";
                str += "<div class='easyui-layout' data-options='fit:true,border:false'><div id='div1' data-options='region:&apos;west&apos;,border:false,split:true' style='width:" + upLeftWidth + "%'></div><div id='div2' data-options='region:&apos;center&apos;,border:false'></div></div>";
                str += "</div>";

                str += "<div data-options='region:&apos;center&apos;,border:false'>";
                str += "<div class='easyui-layout' data-options='fit:true,border:false'><div id='div3' data-options='region:&apos;west&apos;,border:false,split:true' style='width:" + downLeftWidth + "%'></div><div id='div4' data-options='region:&apos;center&apos;,border:false'></div></div>";
                str += "</div>";

                str += "</div>";
                $("#divContent").append(str);
            } break;
            case 4: {//上一下多型
                var upHeight = childDefined[0].iHeight;
                var downHeight = childDefined[1].iHeight;
                if (isNullOrDefinedOrZero(upHeight)) {
                    if (isNullOrDefinedOrZero(downHeight)) {
                        upHeight = 50; downHeight = 50;
                    } else {
                        upHeight = 100 - downHeight;
                    }
                }
                var str = "<div class='easyui-layout' data-options='fit:true,border:false'><div id='div1' data-options='region:&apos;north&apos;,border:false,split:true' style='height:" + upHeight + "%'></div><div data-options='region:&apos;center&apos;,border:false'>";
                var zoneCount = childDefined.length - 1;
                var index = 2;
                var divHZ = 0;
                while (zoneCount > 0) {
                    if (zoneCount == 2) {
                        str += "<div class='easyui-layout' data-options='fit:true,border:false'>";
                        str += "<div id='div" + index + "' data-options='region:&apos;west&apos;,border:false,split:true' style='width:50%'></div><div id='div" + (index + 1) + "' data-options='region:&apos;center&apos;,border:false'></div></div>";
                        while (divHZ > 0) {
                            str += "</div></div>";
                            divHZ--;
                        }
                        zoneCount = 0;
                    }
                    else {
                        var percent = Math.floor(100 / zoneCount);
                        str += "<div class='easyui-layout' data-options='fit:true,border:false'>";
                        str += "<div id='div" + index + "' data-options='region:&apos;west&apos;,border:false,split:true' style='width:" + percent + "%'></div><div data-options='region:&apos;center&apos;,border:false'>";
                        divHZ++;
                        index++;
                        zoneCount--;
                    }
                }
                str += "</div></div>";
                $("#divContent").append(str);
            } break;
            case 5: {//上一下tab型
                var str = "<div class='easyui-layout' data-options='fit:true,border:false'><div id='div1' data-options='region:&apos;north&apos;,border:false,split:true' style='height:50%'></div><div data-options='region:&apos;center&apos;,border:false'>";
                str += "<div class='easyui-tabs' data-options='fit:true,border:false'>";
                for (var i = 1; i < childDefined.length; i++) {
                    str += "<div id='div" + (i + 1).toString() + "' title='" + childDefined[i].sBillType + "'></div>";
                }
                str += "</div>";
                str += "</div></div>";
                $("#divContent").append(str);
            } break;
        }
        $.parser.parse('#divContent');
        //区域元素
        //var allColumns = JSON2.parse($("#HidColumnDefined").val());
        for (var i = 0; i < childDefined.length; i++) {
            var iChartOnly = childDefined[i].iChartOnly;
            var iQuery = childDefined[i].iQuery;
            var pageSize = childDefined[i].pPageCount ? childDefined[i].pPageCount : 30;
            var iZoneFormID = childDefined[i].iZoneForm;
            if (iChartOnly != "1") {
                $("#div" + (i + 1)).append("<table id='tbGrid" + (i + 1) + "' class='easyui-datagrid'></table>");

                //列
                var theNoFrozenColumns = [];
                var theFrozenColumns = [];
                var theNoFrozenColumnsChild = [];
                var theFrozenColumnsChild = [];
                var columns = [];
                var frozenColumns = [];
                var isBegin = false;
                for (var j = 0; j < allColumns.length; j++) {
                    if (allColumns[j].iFormID == childDefined[i].iZoneForm) {
                        isBegin = true;
                        if (allColumns[j].ifix != 1) {
                            if (allColumns[j].isChild == 1) {
                                theNoFrozenColumnsChild.push(allColumns[j]);
                            } else {
                                theNoFrozenColumns.push(allColumns[j]);
                            }
                        } else {
                            if (allColumns[j].isChild == 1) {
                                theFrozenColumnsChild.push(allColumns[j]);
                            } else {
                                theFrozenColumns.push(allColumns[j]);
                            }

                        }

                    }
                    else {
                        if (isBegin == true) {
                            break;
                        }
                    }
                }
                var theColumnsAll = theNoFrozenColumns.concat(theFrozenColumns);
                var theColumnsAllChild = theNoFrozenColumnsChild.concat(theFrozenColumnsChild);
                //var theColumnsAllChild = [];
                var hasMulti = false;
                var hasSummary = false;
                var theSummaryArr = [];
                var theSummaryArrChild = [];
                for (var j = 0; j < theColumnsAll.length; j++) {
                    if (theColumnsAll[j].isChild == true) {
                        theColumnsAllChild.push(theColumnsAll[j]);
                    }
                    if (theColumnsAll[j].sFieldsdisplayName) {
                        if (theColumnsAll[j].sFieldsdisplayName.indexOf("|") > -1) {
                            hasMulti = true;
                            isMultiColumn = true;
                            break;
                        }
                    }
                    if (theColumnsAll[j].sSummary && theColumnsAll[j].sFieldsType != "imageUrl" && theColumnsAll[j].sFieldsType != "附件") {
                        hasSummary = true;
                        if (iQuery == 1) {
                            var sumArr = theColumnsAll[j].sSummary.split(',');
                            for (var k = 0; k < sumArr.length; k++) {
                                var iSummryDigit = "3";
                                if (theColumnsAll[j].iSummryDigit != null && theColumnsAll[j].iSummryDigit != undefined) {
                                    iSummryDigit = theColumnsAll[j].iSummryDigit;
                                }
                                var theSummary = { Field: theColumnsAll[j].sFieldsName, iDigit: iSummryDigit };
                                switch (sumArr[k]) {
                                    case "sum":
                                        {
                                            theSummary.Type = "sum";
                                        } break;
                                    case "avg":
                                        {
                                            theSummary.Type = "avg";
                                        } break;
                                    case "count":
                                        {
                                            theSummary.Type = "count";
                                        } break;
                                    case "max":
                                        {
                                            theSummary.Type = "max";
                                        } break;
                                    case "min":
                                        {
                                            theSummary.Type = "min";
                                        } break;
                                }
                                theSummaryArr.push(theSummary);
                            }
                        }
                    }
                }
                childDefined[i].summaryField = theSummaryArr;
                theColumnsAll = null;
                var functionColumnProcess = function (theColumns) {
                    var firstColumns = [];
                    var twiceColumns = [];
                    var lastFirstTitle = "";
                    for (var j = 0; j < theColumns.length; j++) {
                        var width = theColumns[j].iWidth ? theColumns[j].iWidth : 80;
                        var align = theColumns[j].sAlign ? theColumns[j].sAlign : "center";
                        var hidden = theColumns[j].iHide == 1 ? true : false;
                        var title = theColumns[j].sFieldsdisplayName ? theColumns[j].sFieldsdisplayName : theColumns[j].sFieldsName;
                        var sort = theColumns[j].iSort == 1 ? true : false;
                        var sFieldsType = theColumns[j].sFieldsType;
                        var formatter = undefined;
                        switch (sFieldsType) {
                            case "imageUrl": {
                                var imageid = theColumns[j].sExpression;
                                var sSummary = theColumns[j].sSummary;
                                if (sSummary == null || sSummary == undefined) {
                                    MessageShow("错误", "图片或附件请在汇总列中指定表单号，表名及主表字段！");
                                    return false;
                                }
                                var imageArr = sSummary.split(",");
                                formatter = function (value, row, index) {
                                    if (row.__isFoot == true)
                                        return '';
                                    var ahtml = "<a class='btnImageShow' id='image_" + imageArr[1] + "_" + row[(imageArr[2])] + "_" + imageid + "_" + index + "' href='javascript:void(0)' style='border:none;' ><img style='width:25px;height:25px;' src='/Base/Handler/imageHandler.ashx?iformid=" + iZoneFormID + "&tablename=" + imageArr[1] + "&irecno=" + row[(imageArr[2])] + "&imageid=" + imageid + "&isThum=1&r=" + Math.random() + "'></a>";
                                    return ahtml;
                                }
                            } break;
                            case "附件": {
                                var sSummary = theColumns[j].sSummary;
                                if (sSummary == null || sSummary == undefined) {
                                    MessageShow("错误", "图片或附件请在汇总列中指定表单号，表名及主表字段！");
                                    return false;
                                }
                                var imageArr = sSummary.split(",");
                                formatter = function (value, row, index) {
                                    if (row.__isFoot == true)
                                        return '';
                                    return "<a id='" + row[(imageArr[2])] + "' href='javascript:void(0)' onclick='FormUnionList.ShowFj(\"" + imageArr[0] + "\",\"" + imageArr[1] + "\",this)'>附件</a>";
                                }
                            } break;
                            case "bool": {
                                formatter = function (value, row, index) {
                                    if (value == '1') {
                                        return '√';
                                    }
                                }
                            }
                        }

                        if (hasMulti == false) {
                            var theField = {
                                title: title,
                                field: theColumns[j].sFieldsName ? theColumns[j].sFieldsName : "null_" + j,
                                width: width,
                                align: align,
                                hidden: hidden,
                                sortable: sort,
                                datatype: sFieldsType,
                                formatter: formatter
                            }
                            if (theColumns[j].sStyle) {
                                theField.style = function (value, row, index) {
                                    eval(theColumns[j].sStyle);
                                }
                            }
                            firstColumns.push(theField);
                        } else {
                            if (theColumns[j].sFieldsdisplayName) {
                                if (theColumns[j].sFieldsdisplayName.indexOf("|") > -1) {
                                    var index = theColumns[j].sFieldsdisplayName.indexOf("|");
                                    var firstTitle = theColumns[j].sFieldsdisplayName.substr(0, theColumns[j].sFieldsdisplayName.indexOf("|"));
                                    title = theColumns[j].sFieldsdisplayName.substr(index + 1, theColumns[j].sFieldsdisplayName.length - index - 1);
                                    var colspan = 1;
                                    if (lastFirstTitle == "" || firstTitle != lastFirstTitle) {
                                        if (j < theColumns.length - 1) {
                                            for (var k = j + 1; k < theColumns.length; k++) {
                                                var nextDisplayName = theColumns[k].sFieldsdisplayName;
                                                if (nextDisplayName) {
                                                    var nextIndex = nextDisplayName.indexOf("|");
                                                    var nextFirstName = nextDisplayName.substr(0, nextIndex);
                                                    if (nextFirstName != firstTitle) {
                                                        break;
                                                    }
                                                    else {
                                                        colspan++;
                                                    }
                                                } else {
                                                    break;
                                                }
                                            }
                                        }
                                        var theField = {
                                            title: firstTitle,
                                            align: align,
                                            colspan: colspan
                                        }
                                        firstColumns.push(theField);
                                        lastFirstTitle = firstTitle;
                                    }
                                    var theField1 = {
                                        title: title,
                                        field: theColumns[j].sFieldsName ? theColumns[j].sFieldsName : "null_" + j,
                                        width: width,
                                        align: align,
                                        hidden: hidden,
                                        sortable: sort,
                                        datatype: sFieldsType,
                                        formatter: formatter
                                    }
                                    twiceColumns.push(theField1);
                                } else {
                                    title = theColumns[j].sFieldsdisplayName;
                                    var theField = {
                                        title: title,
                                        field: theColumns[j].sFieldsName ? theColumns[j].sFieldsName : "null_" + j,
                                        width: width,
                                        align: align,
                                        hidden: hidden,
                                        rowspan: 2,
                                        sortable: sort,
                                        datatype: sFieldsType,
                                        formatter: formatter
                                    }
                                    firstColumns.push(theField);
                                }
                            } else {
                                var theField = {
                                    title: title,
                                    field: theColumns[j].sFieldsName ? theColumns[j].sFieldsName : "null_" + j,
                                    width: width,
                                    align: align,
                                    hidden: hidden,
                                    rowspan: 2,
                                    sortable: sort,
                                    datatype: sFieldsType,
                                    formatter: formatter
                                }
                                firstColumns.push(theField);
                            }
                        }
                    }
                    if (twiceColumns.length > 0) {
                        return [firstColumns, twiceColumns];
                    }
                    else {
                        return [firstColumns];
                    }
                }
                var columns = functionColumnProcess(theNoFrozenColumns);
                var frozenColumns = functionColumnProcess(theFrozenColumns);

                //按钮
                //var allButtons = JSON2.parse($("#HidButtonRight").val());
                FormUnionList.allButtonRight = allButtons;
                var theButtons = [];
                for (var j = 0; j < allButtons.length; j++) {
                    if (allButtons[j].iFormID == FormUnionList.childDefined[i].iZoneForm) {
                        theButtons.push(allButtons[j]);
                    }
                }
                if (theButtons.length > 0) {
                    var tbGridToolbarDiv = $("#tbGrid" + (i + 1) + "_toolbar");
                    if (tbGridToolbarDiv.length == 0) {
                        $("#div" + (i + 1)).append("<div id='tbGrid" + (i + 1) + "_toolbar'></div>");
                    }
                }
                var hasToolbar = false;
                var btnHtml = function (btnObj) {
                    var abtnHtml = "";
                    var buttonID = btnObj.sRightName;
                    var buttonTitle = btnObj.sRightDetail;
                    var iHidden = btnObj.iHidden;
                    var sType = btnObj.sType;
                    var sIcon = btnObj.sIcon;
                    if (iHidden != 1) {
                        if (sType == null || sType == "按钮") {
                            switch (buttonID) {
                                case "fadd": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-add&quot;,plain:true">' + buttonTitle + '</a>';
                                    //$("#tbGrid" + (i + 1) + "_toolbar").append(btnAdd);
                                } break;
                                case "fmodify": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-edit&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnModify = $(abtnHtml);
                                } break;
                                case "fcopy": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-copy&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnCopy = $(abtnHtml);
                                } break;
                                case "fdelete": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-remove&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "submit": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-submit&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "submitcancel": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-submitcancel&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "checkcancel": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-submitcancel&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "checkcancelAsk": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-submitcancel&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "fprint": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:&quot;icon-print&quot;,plain:true">' + buttonTitle + '</a>';
                                    //onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')"
                                    //var pbPrintArr = JSON2.parse($("#HidPbPrint").val());
                                    var thePbPrintArr = [];
                                    for (var i = 0; i < pbPrintArr.length; i++) {
                                        if (pbPrintArr[i].iFormID == btnObj.iFormID) {
                                            thePbPrintArr.push(pbPrintArr[i]);
                                        }
                                    }
                                    FormUnionList.BuildPrintList(btnObj.iFormID, thePbPrintArr);
                                } break;
                                case "fexport": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-export&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "fimport": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-import&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                case "associate": {
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;icon-associate&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                                default: {
                                    var iconCls = "icon-default";
                                    switch (sIcon) {
                                        case "add": iconCls = "icon-add"; break;
                                        case "edit": iconCls = "icon-edit"; break;
                                        case "remove": iconCls = "icon-remove"; break;
                                        case "copy": iconCls = "icon-copy"; break;
                                        case "save": iconCls = "icon-save"; break;
                                        case "ok": iconCls = "icon-ok"; break;
                                        case "cut": iconCls = "icon-cut"; break;
                                        case "reload": iconCls = "icon-reload"; break;
                                        case "search": iconCls = "icon-search"; break;
                                        case "print": iconCls = "icon-print"; break;
                                        case "preview": iconCls = "icon-preview"; break;
                                        case "next": iconCls = "icon-next"; break;
                                        case "import": iconCls = "icon-import"; break;
                                    }
                                    abtnHtml = '<a id="btn_' + btnObj.iFormID + '_' + buttonID + '" href="javascript:void(0)" onclick="FormUnionList.BtnClick(' + btnObj.iFormID + ',' + JSON2.stringify(btnObj).replace(/"/g, "&quot;") + ')" class="easyui-linkbutton" data-options="iconCls:&quot;' + iconCls + '&quot;,plain:true">' + buttonTitle + '</a>';
                                    //var btnRemove = $(abtnHtml);
                                } break;
                            }
                        }
                    }
                    return abtnHtml;
                }
                var hasOneZoneBtn = false;
                //增加按钮
                var btnObjAdd = theButtons.filter(function (p) { return p.sRightName == "fadd" });
                if (btnObjAdd.length > 0 && btnObjAdd[0].iHidden != 1) {
                    hasToolbar = true;
                    hasOneZoneBtn = true;
                    var ahtml = btnHtml(btnObjAdd[0]);
                    var btnAdd = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btnAdd);
                }
                //修改按钮
                var btnObjEdit = theButtons.filter(function (p) { return p.sRightName == "fmodify" });
                if (btnObjEdit.length > 0 && btnObjEdit[0].iHidden != 1) {
                    hasToolbar = true;
                    hasOneZoneBtn = true;
                    var ahtml = btnHtml(btnObjEdit[0]);
                    var btnEdit = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btnEdit);
                }
                //复制按钮
                var btnObjCopy = theButtons.filter(function (p) { return p.sRightName == "fcopy" });
                if (btnObjCopy.length > 0 && btnObjCopy[0].iHidden != 1) {
                    hasToolbar = true;
                    hasOneZoneBtn = true;
                    var ahtml = btnHtml(btnObjCopy[0]);
                    var btnCopy = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btnCopy);
                }
                //删除按钮
                var btnObjRemove = theButtons.filter(function (p) { return p.sRightName == "fdelete" });
                if (btnObjRemove.length > 0 && btnObjRemove[0].iHidden != 1) {
                    hasToolbar = true;
                    hasOneZoneBtn = true;
                    var ahtml = btnHtml(btnObjRemove[0]);
                    var btnRemove = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btnRemove);
                }
                if (hasOneZoneBtn) {
                    $("#tbGrid" + (i + 1) + "_toolbar").append("<div class='btn-separator'></div>");
                }
                var hasTwoZoneBtn = false;
                for (var j = 0; j < theButtons.length; j++) {
                    if (theButtons[j].sRightName.startWith("f") || theButtons[j].sRightName.startWith("b")) {
                        continue;
                    }
                    //var buttonID = theButtons[j].sRightName;
                    var iHidden = theButtons[j].iHidden;
                    if (iHidden != 1) {
                        hasToolbar = true;
                        hasTwoZoneBtn = true;
                        var ahtml = btnHtml(theButtons[j]);
                        var btnTwo = $(ahtml);
                        $("#tbGrid" + (i + 1) + "_toolbar").append(btnTwo);
                    }
                }
                if (hasTwoZoneBtn) {
                    $("#tbGrid" + (i + 1) + "_toolbar").append("<div class='btn-separator'></div>");
                }
                var hasThreeZoneBtn = false;
                //关联按钮
                //var assArr = JSON2.parse($("#HidAss").val());
                var theAssArr = [];
                if (theAssArr.length > 0) {
                    for (var j = 0; j < assArr.length; j++) {
                        if (assArr[j].iFormid == FormUnionList.childDefined[i].iZoneForm) {
                            var divAssociated = $("#divAssociated_" + assArr[j].iFormid);
                            if (divAssociated.length == 0) {
                                $("body").append("<div id='divAssociated_" + assArr[j].iFormid + "'><table id='tabAssociated_" + assArr[j].iFormid + "' class='tabprint'></table></div>");
                            }
                            FormUnionList.AddAssociatedRow(assArr[j].iMenuID, assArr[j].iFormid, assArr[j].iAssFormID, assArr[j].sMenuName, parmValue, assArr[j].sFilePath, assArr[j].sIcon);
                        }
                    }
                }

                //打印按钮
                var btnObjPrint = theButtons.filter(function (p) { return p.sRightName == "fprint" });
                if (btnObjPrint.length > 0 && btnObjPrint[0].iHidden != 1) {
                    hasToolbar = true;
                    hasThreeZoneBtn = true;
                    var ahtml = btnHtml(btnObjPrint[0]);
                    var btn = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btn);
                }
                //导入按钮
                var btnObjImport = theButtons.filter(function (p) { return p.sRightName == "fimport" });
                if (btnObjImport.length > 0 && btnObjImport[0].iHidden != 1) {
                    hasToolbar = true;
                    hasThreeZoneBtn = true;
                    var ahtml = btnHtml(btnObjImport[0]);
                    var btn = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btn);
                }
                //导出按钮
                var btnObjExport = theButtons.filter(function (p) { return p.sRightName == "fexport" });
                if (btnObjExport.length > 0 && btnObjExport[0].iHidden != 1) {
                    hasToolbar = true;
                    hasThreeZoneBtn = true;
                    var ahtml = btnHtml(btnObjExport[0]);
                    var btn = $(ahtml);
                    $("#tbGrid" + (i + 1) + "_toolbar").append(btn);
                }
                if (hasThreeZoneBtn) {
                    $("#tbGrid" + (i + 1) + "_toolbar").append("<div class='btn-separator'></div>");
                }
                $("#tbGrid" + (i + 1) + "_toolbar").append("<a id='btn_" + FormUnionList.childDefined[i].iZoneForm + "_exit' style='margin:1px;' class='easyui-linkbutton hxtoolbar' data-options='iconCls:&quot;icon-undo&quot;,plain:true' style='margin:1px;' onclick='FormUnionList.BtnExit()'>退出</a>");

                if (hasToolbar) {
                    $.parser.parse("#tbGrid" + (i + 1) + "_toolbar");
                    if ($("#btn_" + FormUnionList.childDefined[i].iZoneForm + "_fprint").length > 0) {
                        $("#btn_" + FormUnionList.childDefined[i].iZoneForm + "_fprint").tooltip({
                            ideEvent: 'none',
                            content: $('#divPrint_' + FormUnionList.childDefined[i].iZoneForm),
                            showEvent: 'click',
                            onShow: function () {
                                var ddd = $(this);
                                var id = ddd[0].id;
                                var index1 = id.indexOf("_");
                                var index2 = id.lastIndexOf("_");
                                var theFormid = id.substr(index1 + 1, index2 - index1 - 1);
                                $('#divPrintAcc_' + theFormid).show();
                                $('#divPrintAcc_' + theFormid).accordion({ fit: true, border: false });
                                var t = $(this);
                                t.tooltip('tip').unbind().bind('mouseenter', function () {
                                    t.tooltip('show'); t.tooltip('reposition');
                                }).bind('mouseleave', function () {
                                    t.tooltip('hide');
                                });
                            }
                        });
                    }
                }

                var dataGridOption = {
                    fit: true,
                    columns: columns,
                    frozenColumns: theFrozenColumns.length > 0 ? frozenColumns : null,
                    pagination: true,
                    rownumbers: true,
                    pageSize: pageSize,
                    pageList: [pageSize, pageSize * 2, pageSize * 5, pageSize * 10, pageSize * 20, pageSize * 50, pageSize * 100],
                    //singleSelect: true,
                    ctrlSelect: true,
                    remoteSort: iQuery == 1 ? true : false,
                    showFooter: hasSummary,
                    toolbar: (hasToolbar ? "#tbGrid" + (i + 1) + "_toolbar" : ""),
                    onLoadSuccess: function (data) {
                        var id = this.id;
                        var index = id.substr(6);
                        var iformid = 0;
                        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
                            if (i + 1 == index) {
                                iformid = FormUnionList.childDefined[i].iZoneForm;
                            }
                        }
                        showBigImage();
                        var options = $(this).datagrid("options");
                        var queryParams = options.queryParams;
                        var filters = queryParams.filters;
                        var iQuery = options.url ? 0 : 1;
                        FormUnionList.ShowFooterData(iQuery, iformid, filters);
                    }
                }

                //子表
                var hasChild = false;
                if (FormUnionList.childDefined[i].sDetailTableName && FormUnionList.childDefined[i].sLinkField && FormUnionList.childDefined[i].sDeitailFieldKey && theColumnsAllChild.length > 0) {
                    hasChild = true;
                    dataGridOption.view = detailview;
                    dataGridOption.detailFormatter = function (index, row) {
                        var theIndex = this.id.substr(6);
                        return "<div style='padding:2px;position:relative;'><table id='tbGridChild" + theIndex + "' class='ddv'></table></div>";
                    };
                    var hasMultiChild = false;
                    var isMultiColumnChild = false;
                    var hasSummaryChild = false;
                    for (var j = 0; j < theColumnsAllChild.length; j++) {
                        if (theColumnsAllChild[j].sFieldsdisplayName) {
                            if (theColumnsAllChild[j].sFieldsdisplayName.indexOf("|") > -1) {
                                hasMultiChild = true;
                                isMultiColumnChild = true;
                                break;
                            }
                        }
                        if (theColumnsAllChild[j].sSummary && theColumnsAllChild[j].sFieldsType != "imageUrl" && theColumnsAllChild[j].sFieldsType != "附件") {
                            hasSummaryChild = true;
                        }
                    }
                    var columnsChild = [];
                    var frozenColumnsChild = [];
                    var columnsChild = functionColumnProcess(theNoFrozenColumnsChild);
                    var frozenColumnsChild = functionColumnProcess(theFrozenColumnsChild);
                    FormUnionList.childDefined[i].columnsChild = columnsChild;
                    FormUnionList.childDefined[i].frozenColumnsChild = frozenColumnsChild;
                    FormUnionList.childDefined[i].hasSummaryChild = hasSummaryChild;
                    dataGridOption.onExpandRow = function (index, row) {
                        FormUnionList.currentExpandRowIndex = index;
                        var id = this.id;
                        var theIndex = id.substr(6);
                        var iformid = FormUnionList.childDefined[theIndex - 1].iZoneForm;
                        var sFieldKey = FormUnionList.childDefined[theIndex - 1].sFieldKey;
                        var ddv = $(this).datagrid("getRowDetail", index).find("table.ddv");
                        ddv.datagrid({
                            url: '/Base/Handler/FormListHandler.ashx',
                            queryParams: { Rnd: Math.random(), otype: 'GetFormListData', iformid: iformid, isChild: 1, iMainRecNo: row[(sFieldKey)] },
                            singleSelect: true,
                            rownumbers: true,
                            loadMsg: '正在加载...',
                            height: 'auto',
                            columns: FormUnionList.childDefined[theIndex - 1].columnsChild,
                            frozenColumns: FormUnionList.childDefined[theIndex - 1].frozenColumnsChild.length > 0 ? FormUnionList.childDefined[theIndex - 1].frozenColumnsChild : null,
                            showFooter: FormUnionList.childDefined[theIndex - 1].hasSummaryChild,
                            onLoadSuccess: function (data) {
                                var id = this.id;
                                var indexEle = id.substr(11);
                                setTimeout(function () {
                                    $('#tbGrid' + indexEle).datagrid('fixDetailRowHeight', index);
                                }, 0);
                                var iformid = FormUnionList.childDefined[indexEle - 1].iZoneForm;
                                showBigImage();
                                var options = $(this).datagrid("options");
                                var queryParams = options.queryParams;
                                var filters = queryParams.filters ? queryParams.filters : "1=1";
                                var iQuery = options.url ? 0 : 1;
                                $.ajax({
                                    url: "/Base/Handler/FormListHandler.ashx",
                                    data: { otype: "FormListSummary", iformid: iformid, filters: filters, isChild: "1" },
                                    async: false,
                                    cache: false,
                                    success: function (data) {
                                        try {
                                            if (data) {
                                                $("#tbGridChild" + index).datagrid('reloadFooter', data);
                                            }
                                        }
                                        catch (e) {
                                            MessageShow("发生错误", e.message);
                                        }

                                    },
                                    error: function () {
                                        MessageShow("错误", "访问服务器时发生错误");
                                    },
                                    dataType: "json"
                                })

                            },
                            striped: true,
                            onResize: function () {
                                var tableid = "tbGrid" + theIndex;
                                $('#' + tableid).datagrid('fixDetailRowHeight', index);
                            },
                        });
                        $('#tbGrid' + theIndex).datagrid('fixDetailRowHeight', index);
                    }

                }

                childDefined[i].originalDataGridColumns = dataGridOption.columns;
                childDefined[i].originalDataGridFrozenColumns = [];
                if (iQuery == 1) {
                    //dataGridOption.loadFilter = pagerFilter;
                    dataGridOption.onSortColumn = DataGridLocalSort;
                } else {
                    dataGridOption.url = "/Base/Handler/FormListHandler.ashx";
                    dataGridOption.queryParams = { otype: "GetFormListData", isChild: "0", iformid: iZoneFormID, conditionGUID: "", conditionValue: "", dynCndnValue: "", p: false };
                    dataGridOption.onBeforeLoad = function (param) {
                        if (!param.p) {
                            return false;
                        }
                    }
                }
                $("#tbGrid" + (i + 1)).datagrid(dataGridOption);
            } else {

            }
        }
    },
    DynCdnSelect: function (newValue) {
        var rowspan = 1;
        if (isMultiColumn == true) {
            rowspan = 2;
        }
        for (var z = 0; z < FormUnionList.childDefined.length; z++) {
            if (FormUnionList.childDefined[z].iDynColumnShow != 1) {
                continue;
            }
            var dynColumns = FormUnionList.childDefined[z].dynColumns;
            var options = $("#tbGrid" + (z + 1)).datagrid("options");
            options.columns = DeepCopy(FormUnionList.childDefined[z].originalDataGridColumns);
            options.frozenColumns = DeepCopy(FormUnionList.childDefined[z].originalDataGridFrozenColumns);
            var queryParm = options.queryParams;

            var conditionGUID = FormUnionList.childDefined[z].conditionGUID;
            if (conditionGUID == undefined || conditionGUID == null) {
                //var childrenConditionGUID = JSON2.parse($("#HidDynConditionGUID").val());
                for (var y = 0; y < childrenConditionGUID.length; y++) {
                    if (childrenConditionGUID[y].iFormID == FormUnionList.childDefined[z].iZoneForm) {
                        conditionGUID = childrenConditionGUID[y].GUID;
                        FormUnionList.childDefined[z].conditionGUID = childrenConditionGUID[y].GUID;
                        break;
                    }
                }
            }

            queryParm.dynCndnValue = newValue;
            queryParm.conditionGUID = conditionGUID;
            options.queryParams = queryParm;
            var dynColumnIndex = FormUnionList.childDefined[z].iDynColumnIndex;
            var iUseConditoinZone = FormUnionList.mainDefined[0].iUseZoneCondition;
            var dynFormID = iUseConditoinZone == 0 ? getQueryString("FormID") : FormUnionList.childDefined[iUseConditoinZone - 1].iZoneForm;
            var theChildDeifned = FormUnionList.childDefined[z];
            var hasError = false;
            var datagridHtmlID = "tbGrid" + (z + 1);
            $.ajax(
            {
                url: "/Base/Handler/FormListHandler.ashx",
                data: { otype: "GetDynColumns", formid: dynFormID, conditionGUID: $("#" + this.id).attr("conditionID"), conditionValue: newValue },
                async: false,
                cache: false,
                type: "POST",
                success: function (resultObj) {
                    if (resultObj.success == true) {
                        if (dynColumns) {
                            for (var i = 0; i < dynColumns.length; i++) {
                                for (var o in dynColumns[0]) {
                                    fieldColumn = o;
                                    break;
                                }
                                for (var j = 0; j < options.columns[0].length; j++) {
                                    if (options.columns[0][j].field == dynColumns[i][(o)]) {
                                        options.columns[0].splice(j, 1);
                                        j--;
                                        break;
                                    }
                                }
                            }
                        }
                        dynColumns = resultObj.tables[0];
                        theChildDeifned.dynColumns = resultObj.tables[0];
                    }
                    else {
                        MessageShow(resultObj.message, resultObj.message);
                        return;
                    }
                },
                error: function () {
                    MessageShow("获取动态列失败", "获取动态列失败");
                    hasError = true;
                    return;
                },
                dataType: "json"
            }
            );
            if (hasError == false) {
                $("#" + datagridHtmlID).datagrid("loadData", []);
                if (dynColumns.length > 0) {
                    var fieldColumn = "";
                    for (var o in dynColumns[0]) {
                        fieldColumn = o;
                        break;
                    }

                    if (dynColumnIndex == undefined) {
                        for (var i = 0; i < dynColumns.length; i++) {
                            if (options.columns.length > 0) {
                                options.columns[0].push({
                                    field: dynColumns[i][(fieldColumn)],
                                    title: dynColumns[i][(fieldColumn)],
                                    width: 50,
                                    align: 'center',
                                    halign: 'center',
                                    rowspan: rowspan
                                });
                            }
                        }
                    }
                    else {
                        for (var i = dynColumns.length - 1; i >= 0; i--) {
                            var columnNew = {
                                field: dynColumns[i][(fieldColumn)],
                                title: dynColumns[i][(fieldColumn)],
                                width: 50,
                                align: 'center',
                                halign: 'center',
                                rowspan: rowspan
                            }
                            options.columns[0].splice(dynColumnIndex, 0, columnNew);
                            //dynColumnNews.push(columnNew);
                        }
                    }
                    theChildDeifned.originalDataGridColumns = DeepCopy(options.columns);
                    $("#" + datagridHtmlID).datagrid(options);
                    if (theChildDeifned.iQuery == 1) {
                        //dynConditionGUID = conditionGUID;
                        dynConditionValue = newValue;
                        //将动态列的合计
                        if (theChildDeifned.iDynColumnSummary == 1) {
                            var sDynColumnSummaryType = theChildDeifned.sDynColumnSummaryType ? theChildDeifned.sDynColumnSummaryType : "sum";
                            var theSummaryField = theChildDeifned.summaryField;
                            if (theSummaryField.length > 0) {
                                for (var j = 0; j < dynColumns.length; j++) {
                                    var isFound = false;
                                    for (var k = 0; k < theSummaryField.length; k++) {
                                        if (dynColumns[j][(fieldColumn)] == theSummaryField[k].Field) {
                                            isFound = true;
                                            break;
                                        }
                                    }
                                    if (isFound == false) {
                                        theSummaryField.push({ Type: sDynColumnSummaryType, Field: dynColumns[j][(fieldColumn)], iDigit: 0 })
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    MessageShow("没有对应的动态列！", "没有对应的动态列！");
                }
            }
        }

    },
    RenderCondition: function (dataConditions) {
        var cCount = 0
        //var person = JSON2.parse($("#HidPerson").val());
        for (var i = 0; i < dataConditions.length; i++) {
            if (dataConditions[i].iHidden != 1) {
                cCount++
                var tr;
                if (i % 4 == 0) {
                    tr = $("<tr></tr>");
                    $("#tabConditions").append(tr);
                } else {
                    var trs = $("#tabConditions tr");
                    tr = trs[trs.length - 1];
                }

                var td;
                var isConditionMulti = dataConditions[i].iMulti == 1 ? "true" : "false";
                var name = dataConditions[i].sFieldName.replace(/'/g, "&apos;") + "`" + dataConditions[i].iSerial;
                var fieldid = dataConditions[i].sFieldName.replace(/'/, "&apos;");

                var Required = dataConditions[i].iRequired == 1 ? "true" : "false";
                var opTion = dataConditions[i].sOpTion == "" ? "=" : dataConditions[i].sOpTion;
                var value = dataConditions[i].sValue;
                var lookupOptions = "";
                //如果有LOOKUP
                if (dataConditions[i].sLookUpName) {
                    var lookupName = dataConditions[i].sLookUpName;
                    var lookFilters = dataConditions[i].sLookUpFilters == "" ? "1=1" : dataConditions[i].sLookUpFilters.replace(/{userid}/g, userid).replace(/\r\n/g, " ").replace(/\n/g, " ").replace(/'/g, "&apos;");
                    lookupOptions = "[{lookupName:&quot;" + lookupName + "&quot;,fixFilters:&quot;" + lookFilters + "&quot;,isMulti:" + isConditionMulti + ",editable:true,fields:&quot;*&quot;,searchFields:&quot;*&quot;,targetID:&quot;condition_" + i + "&quot;}]";
                }
                if (lookupOptions != "") {
                    lookupOptions = "lookupOptions='" + lookupOptions + "'";
                }
                if (dataConditions[i].bQuery == true) {
                    if (dataConditions[i].sLookUpName == "") {
                        MessageShow("当有动态列查询条件时，请指定条件的lookup", "当有动态列查询条件时，请指定条件的lookup");
                        return false;
                    }
                    if (dataConditions[i].sColumnSource == "") {
                        MessageShow("当有动态列查询条件时，请指定列源！", "当有动态列查询条件时，请指定列源！");
                        return false;
                    }
                    if (dataConditions[i].sColumnDataSource == "") {
                        MessageShow("当有动态列查询条件时，请指定列数源！", "当有动态列查询条件时，请指定列数源！");
                        return false;
                    }
                }
                switch (value) {
                    case "UserID": {
                        value = userid;
                    } break;
                    case "UserName": {
                        value = person[0].sName;
                    } break;
                    case "CurrentDate": {
                        value = getNowDate();
                    } break;
                    case "CurrentDateTime": {
                        value = getNowDate() + " " + getNowTime();
                    } break;
                    case "Departid": {
                        value = person[0].sClassID;
                    } break;
                    case "NewGUID": {
                        value = NewGuid();
                    } break;
                }
                switch (dataConditions[i].sFieldType) {
                    case "S": case "": {
                        if (dataConditions[i].bQuery == true) {
                            //var lookupDefined = JSON2.parse($("#HidDynLookupDefine").val());
                            var valueField = lookupDefined[0].sReturnField;
                            var textField = lookupDefined[0].sDisplayField;
                            td = $("<td>" + dataConditions[i].sCaption + "</td><td><input isMulti='" + isConditionMulti + "' plugin='combobox' id='condition_" + i + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' style='width:120px;' conditionID='" + dataConditions[i].GUID + "' class='easyui-combobox' data-options='valueField:&apos;" + valueField + "&apos;,textField:&apos;" + textField + "&apos;,data:dynLookupData,onChange:FormUnionList.DynCdnSelect,required:" + Required + "' ></input></td>\");\r\n");
                        } else {
                            td = $("<td>" + dataConditions[i].sCaption + "</td><td><input " + lookupOptions + " isMulti='" + isConditionMulti + "' plugin='textbox' id='condition_" + i + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' value='" + value + "' style='width:120px;' class='easyui-textbox' data-options='required:" + Required + "' ></input></td>");
                        }
                    } break;
                    case "D": {
                        td = $("<td>" + dataConditions[i].sCaption + "</td><td><input plugin='datebox' id='condition_" + i + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' value='" + value + "' style='width:120px;' class='easyui-datebox' data-options='required:" + Required + "' ></input></td>");
                    } break;
                    case "DT": {
                        td = $("<td>" + dataConditions[i].sCaption + "</td><td><input plugin='datetimebox' id='condition_" + i + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' value='" + value + "' style='width:120px;' class='easyui-datetimebox' data-options='required:" + Required + "' ></input></td>");
                    } break;
                    case "F": {
                        td = $("<td>" + dataConditions[i].sCaption + "</td><td><input plugin='numberbox' id='condition_" + i + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' value='" + value + "' style='width:120px;' class='easyui-numberbox' data-options='required:" + Required + "' ></input></td>");
                    } break;
                    case "B": {
                        var checked = value == "1" ? "checked" : "";
                        td = $("<td>" + dataConditions[i].sCaption + "</td><td><input id='condition_" + i.ToString() + "' name='" + name + "' fname='" + name + "' FieldID='" + fieldid + "' ComOprt='" + opTion + "' type='checkbox' checked='" + checked + "' ></input></td>");
                    } break;
                }
                $(tr).append(td);
            }
        }
        if (cCount > 0) {
            $("#tabConditions tr").eq(0).append("<td rowspan=2 style='vertical-align:top;'><a href='javascript:void(0)' onclick='FormUnionList.doSearch()' class='button orange'>查询</a></td>");
        }
        rowCount = Math.ceil(cCount / 4);
        if (rowCount > 2) {
            $("body").layout("panel", "north").panel("resize", { height: rowCount * 25 + 60 });
            $('body').layout('resize', {
                width: '100%',
                height: '100%'
            })
        }
        $.parser.parse('#tabConditions');
        lookUp.initHead();

    },
    doSearch: function () {
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            FormUnionList.childDefined[i].filters = "1=1";
            FormUnionList.childDefined[i].filtersPb = "1=1";
            FormUnionList.childDefined[i].pbCondition = {};
        }
        if ($("#form1").form("validate") != true) {
            return false;
        }

        var element = $("form input[FieldID]");
        $(element).each(function (index, ele) {
            var fieldid = $(ele).attr("FieldID");
            var plugin = $(ele).attr("plugin");
            var lookupOption = $(ele).attr("lookupOptions");
            var value = "";
            var filters = "";
            var filtersO = "";
            var filterPb = "";
            var pbCondition = {};
            switch (plugin) {
                case "textbox": {
                    value = $(ele).textbox("getValue");
                    if (lookupOption) {
                        value = $("#" + ele.id + "_val").val();
                    }
                } break;
                case "combobox": value = $(ele).combobox("getValues").join(","); break;
                case "combotree": value = $(ele).combotree("getValues").join(","); break;
                case "datebox": value = $(ele).datebox("getValue"); break;
                case "datetimebox": value = $(ele).datetimebox("getValue"); break;
                case "numberspinner": value = $(ele).numberspinner("getValue"); break;
            }
            if (element[0].type == "checkbox") {
                value = element[0].checked == true ? 1 : 0;
            }
            if (value == "") {
                return true;
            }
            var conditionID = $(ele).attr("conditionID");
            var comOprt = $(ele).attr("ComOprt");
            if (comOprt == undefined) {
                comOprt = "=";
            }
            var isMulti = $(ele).attr("isMulti");
            if (isMulti != "true") {
                if (fieldid.indexOf("{value}") > -1) {
                    while (fieldid.indexOf("{value}") > -1) {
                        fieldid = fieldid.replace("{value}", value);
                    }
                    filters += " and " + fieldid;
                    filtersO += " and " + fieldid;
                }
                else {
                    if (comOprt.toLowerCase() == "%like%" || comOprt.toLowerCase() == "like") {
                        filters += " and {" + fieldid + "} like " + "'%" + value + "%'";
                        filtersO += " and " + fieldid + " like " + "'%" + value + "%'";
                        filterPb += " and pb_{" + fieldid + "}=" + encodeURI(value);
                        pbCondition["pb_" + fieldid] = value;
                    }
                    else if (comOprt.toLowerCase() == "like%") {
                        filters += " and {" + fieldid + "} like " + "'" + value + "%'";
                        filtersO += " and " + fieldid + " like " + "'" + value + "%'";
                        filterPb += " and pb_{" + fieldid + "}=" + encodeURI(value);
                        pbCondition["pb_" + fieldid] = value;
                    }
                    else if (comOprt.toLowerCase() == "%like") {
                        filters += " and {" + fieldid + "} like " + "'%" + value + "'";
                        filtersO += " and " + fieldid + " like " + "'%" + value + "'";
                        filterPb += " and pb_{" + fieldid + "}=" + encodeURI(value);
                        pbCondition["pb_" + fieldid] = value;
                    }
                    else {
                        filters += " and {" + fieldid + "} " + comOprt + " " + "'" + value + "'";
                        filtersO += " and " + fieldid + " " + comOprt + " " + "'" + value + "'";
                        filterPb += " and pb_{" + fieldid + "}=" + encodeURI(value);
                        pbCondition["pb_" + fieldid] = value;
                    }
                }
            }
            else {
                var valueEx = "";
                var valueArr = value.split(',');
                for (var i = 0; i < valueArr.length; i++) {
                    valueEx += "'" + valueArr[i] + "',";
                }
                if (valueEx.length > 0) {
                    valueEx = valueEx.substr(0, valueEx.length - 1);
                }
                value = valueEx;
                if (fieldid.indexOf("{value}") > -1) {
                    while (fieldid.indexOf("{value}") > -1) {
                        fieldid = fieldid.replace("{value}", value);
                    }
                    filters += " and " + fieldid;
                    filtersO += " and " + fieldid;
                }
                else {
                    filters += " and {" + fieldid + "} " + comOprt + " " + "(" + valueEx + ")";
                    filtersO += " and " + fieldid + " " + comOprt + " " + "(" + valueEx + ")";
                    filterPb += " and pb_{" + fieldid + "}=" + encodeURI(valueEx);
                    pbCondition["pb_" + fieldid] = valueEx;
                }
            }
            for (var i = 0; i < FormUnionList.childDefined.length; i++) {
                if (FormUnionList.childDefined[i].sConditionFields) {
                    var sConditionFieldsArr = FormUnionList.childDefined[i].sConditionFields.split(",");
                    try {
                        var theField = sConditionFieldsArr[index];
                        if (theField && theField != "") {
                            var re = new RegExp("{" + fieldid + "}", "gim");
                            FormUnionList.childDefined[i].filters += filters.replace(re, theField);
                            FormUnionList.childDefined[i].filtersPb += filters.replace(re, theField);
                            FormUnionList.childDefined[i].pbCondition[(theField)] = value;
                        }
                    } catch (e) {

                    }
                } else {
                    FormUnionList.childDefined[i].filters += filtersO;
                    FormUnionList.childDefined[i].filtersPb += filterPb;
                    FormUnionList.childDefined[i].pbCondition[(fieldid)] = value;
                }
            }
        });
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            var sConditionFields = FormUnionList.childDefined[i].sConditionFields;
            var iChartOnly = FormUnionList.childDefined[i].iChartOnly;
            var iQuery = FormUnionList.childDefined[i].iQuery ? FormUnionList.childDefined[i].iQuery : 0;
            var iStore = FormUnionList.childDefined[i].iStore ? FormUnionList.childDefined[i].iStore : 0;
            var iZoneFormID = FormUnionList.childDefined[i].iZoneForm;
            if (iQuery == 1 && iChartOnly != 1) {
                FormUnionList.GetQueryData(FormUnionList.childDefined[i].filters, iZoneFormID, "tbGrid" + (i + 1));
            } else {
                var options = $("#tbGrid" + (i + 1)).datagrid("options");
                var queryOptions = options.queryParams;
                queryOptions.filters = FormUnionList.childDefined[i].filters;
                queryOptions.p = true;
                $("#tbGrid" + (i + 1)).datagrid("load", queryOptions);

            }
        }
    },
    GetQueryData: function (filters, formid, tableid) {
        if (filters == undefined || filters == "") {
            filters = "1=1";
        }
        var resultData;
        for (var y = 0; y < FormUnionList.childDefined.length; y++) {
            if (FormUnionList.childDefined[y].iZoneForm == formid) {
                dynConditionGUID = FormUnionList.childDefined[y].conditionGUID;
                break;
            }
        }
        $.ajax({
            url: "/Base/Handler/FormListHandler.ashx",
            data: { otype: "GetFormListData", isChild: "0", iformid: formid, filters: filters, isQuery: 1, conditionGUID: dynConditionGUID, conditionValue: dynConditionValue, dynCndnValue: dynConditionValue },
            async: false,
            cache: false,
            success: function (resultObj) {
                try {
                    if (resultObj.success == true) {
                        resultData = resultObj.tables[0];
                        var pageSize = 30;
                        for (var i = 0; i < FormUnionList.childDefined[i].length; i++) {
                            if (FormUnionList.childDefined[i].iZoneForm == formid) {
                                pageSize = FormUnionList.childDefined[i].pPageCount ? FormUnionList.childDefined[i].pPageCount : 30;
                            }
                        }
                        FormUnionList[(tableid)] = resultData;
                        $("#" + tableid).datagrid("loadData", resultData.slice(0, pageSize));
                        var pager = $("#" + tableid).datagrid("getPager");
                        pager.pagination({
                            total: resultData.length,
                            onSelectPage: function (pageNo, pageSize) {
                                var start = (pageNo - 1) * pageSize;
                                var end = start + pageSize;
                                $("#" + tableid).datagrid("loadData", resultData.slice(start, end));
                                pager.pagination('refresh', {
                                    total: resultData.length,
                                    pageNumber: pageNo
                                });
                            }
                        });
                    }
                    else {
                        MessageShow("错误", resultObj.message);
                    }
                }
                catch (e) {
                    MessageShow("发生错误", e.message);
                }

            },
            error: function () {
                MessageShow("错误", "访问服务器时发生错误");
            }, dataType: "json"
        });
        if (resultData) {
            return resultData;
        }
    },
    ShowFooterData: function (iQuery, formID, filters) {
        var summaryField;
        var tableid = "";
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            if (FormUnionList.childDefined[i].iZoneForm == formID) {
                summaryField = FormUnionList.childDefined[i].summaryField;
                tableid = "tbGrid" + (i + 1);
                break;
            }
        }
        if (iQuery == 1) {
            var footData = FormUnionList.GetFootData(summaryField, tableid);
            if (footData) {
                $("#" + tableid).datagrid("reloadFooter", footData);
            }
        } else {
            $.ajax({
                url: "/Base/Handler/FormListHandler.ashx",
                data: { otype: "FormListSummary", iformid: formID, filters: filters },
                async: false,
                cache: false,
                success: function (data) {
                    try {
                        if (data) {
                            $("#" + tableid).datagrid('reloadFooter', data);
                        }
                    }
                    catch (e) {
                        MessageShow("发生错误", e.message);
                    }

                },
                error: function () {
                    MessageShow("错误", "访问服务器时发生错误");
                },
                dataType: "json"
            })
        }
    },
    GetFootData: function (objArr, tableid) {
        var allData = [];
        //var data = $('#' + tableid).datagrid('getData').originalRows ? $('#' + tableid).datagrid('getData').originalRows : $('#' + tableid).datagrid('getData').rows;
        var data = FormUnionList[(tableid)];
        if (data == undefined || data == null) {
            return;
        }
        //1、求和
        var sumData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].Type == "sum") {
                if (sumData == undefined) {
                    sumData = {};
                }
                sumData[(objArr[i].Field)] = FormUnionList.CalcFootData(data, objArr[i].Field, "sum", objArr[i].iDigit);
            }
        }
        if (sumData != undefined) {
            sumData.__isFoot = true;
            sumData.__type = "sum";
            allData.push(sumData);

        }
        //2、求平均值
        var avgData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].Type == "avg") {
                if (avgData == undefined) {
                    avgData = {};
                }
                avgData[(objArr[i].Field)] = FormUnionList.CalcFootData(data, objArr[i].Field, "avg", objArr[i].iDigit);
            }
        }
        if (avgData != undefined) {
            avgData.__isFoot = true;
            sumData.__type = "avg";
            allData.push(avgData);
        }
        //3、求个数
        var countData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].Type == "count") {
                if (countData == undefined) {
                    countData = {};
                }
                countData[(objArr[i].Field)] = FormUnionList.CalcFootData(data, objArr[i].Field, "count");
            }
        }
        if (countData != undefined) {
            countData.__isFoot = true;
            sumData.__type = "count";
            allData.push(countData);
        }
        //4、求最大值
        var maxData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].Type == "max") {
                if (maxData == undefined) {
                    maxData = {};
                }
                maxData[(objArr[i].Field)] = FormUnionList.CalcFootData(data, objArr[i].Field, "max");
            }
        }
        if (maxData != undefined) {
            maxData.__isFoot = true;
            sumData.__type = "max";
            allData.push(maxData);
        }
        //5、求最小值
        var minData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].Type == "min") {
                if (minData == undefined) {
                    minData = {};
                }
                minData[(objArr[i].Field)] = FormUnionList.CalcFootData(data, objArr[i].Field, "min");
            }
        }
        if (minData != undefined) {
            minData.__isFoot = true;
            sumData.__type = "min";
            allData.push(minData);
        }
        return allData;
    },
    CalcFootData: function (data, field, otype, iDigit) {
        var result = 0;
        if (iDigit == undefined || iDigit == null) {
            iDigit = 2;
        }
        switch (otype) {
            case "sum":
                {
                    for (var i = 0; i < data.length; i++) {
                        result += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                    }
                    result = result.toFixed(parseInt(iDigit));
                } break;
            case "avg":
                {
                    var total = 0;
                    for (var i = 0; i < data.length; i++) {
                        total += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                    }
                    result = total / data.length;
                    result = result.toFixed(parseInt(iDigit));
                } break;
            case "count": result = data.length; break;
            case "max":
                {
                    if (data.length == 0) {
                        result = 0;
                    }
                    else {
                        result = isNaN(parseFloat(data[0][(field)])) ? 0 : parseFloat(data[0][(field)]);
                    }
                    for (var i = 0; i < data.length; i++) {
                        var value = isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                        if (result < value) {
                            result = value;
                        }
                    }
                } break;
            case "min":
                {
                    if (data.length == 0) {
                        result = 0;
                    }
                    else {
                        result = isNaN(parseFloat(data[0][(field)])) ? 0 : parseFloat(data[0][(field)]);
                    }
                    for (var i = 0; i < data.length; i++) {
                        var value = isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                        if (result > value) {
                            result = value;
                        }
                    }
                } break;
        }
        return result;
    },
    ExecProcedure: function (procedureName, iformid, keys, userid, btnid) {
        var sqlObj = {
            StoreProName: procedureName,
            StoreParms: [
            {
                ParmName: "@iformid",
                Value: iformid
            },
            {
                ParmName: "@keys",
                Value: keys
            },
            {
                ParmName: "@userid",
                Value: userid
            },
            {
                ParmName: "@btnid",
                Value: btnid
            }
            ]
        };
        var result = SqlStoreProce(sqlObj);
        if (result == "1") {
            //FormList.refresh();
            return true;
        }
        else {
            MessageShow("错误", result);
            return false;
        }
    },
    GetSelectedKeys: function (formid) {
        var keys = "";
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            if (formid == FormUnionList.childDefined[i].iZoneForm) {
                var selectedRows = $("#tbGrid" + (i + 1)).datagrid("getSelections");
                var sFieldKey = FormUnionList.childDefined[i].sFieldKey;
                for (var i = 0; i < selectedRows.length; i++) {
                    keys += selectedRows[i][(sFieldKey)] + ",";
                }
                if (keys.length > 0) {
                    keys = keys.substr(0, keys.length - 1);
                }
                return keys;
            }
        }
        return keys;
    },
    BtnClick: function (formid, btnObj) {
        var btnID = btnObj.sRightName;
        var key = FormUnionList.GetSelectedKeys(formid);
        var title = "";
        var theDefined;
        var tableid = "tbGrid";
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            if (formid == FormUnionList.childDefined[i].iZoneForm) {
                title = FormUnionList.childDefined[i].sBillType;
                theDefined = FormUnionList.childDefined[i];
                tableid += (i + 1).toString();
                break;
            }
        }
        var btnPreHandler = function (btnObj) {
            if (btnObj.sStoredProce) {
                var success = FormUnionList.ExecProcedure(btnObj.sStoredProce, formid, key, userid, btnID);
                if (!success) {
                    return success;
                } else {
                    if (btnObj.sJsCode) {
                        var jsCode = btnObj.sJsCode;
                        var re1 = new RegExp("<%userid%>", "g");
                        var re2 = new RegExp("<%selectedkey%>", "g");
                        jsCode = jsCode.replace(re1, "'" + userid + "'").replace(re2, key);
                        eval(jsCode);
                    }
                }
            }
        }

        var iWidth = theDefined.iDetailWidth;
        var iHeight = theDefined.iDetailHeight;
        var parmStr = "";
        var isBegin = false;
        //var widowParam = JSON2.parse($("#HidWindowParam").val());
        for (var i = 0; i < widowParam.length; i++) {
            if (widowParam[i].iFormID == formid) {
                isBegin == true;
                parmStr += "&" + widowParam[i].sParamName + "=" + widowParam[i].sParamValue;
            }
            else {
                if (isBegin == true) {
                    break;
                }
            }
        }
        switch (btnID) {
            case "fadd": {
                if (btnPreHandler(btnObj) == false) {
                    return false;
                }
                FormUnionList.OpenWindow(theDefined.sDetailPage + "?iformid=" + formid + "&usetype=add" + parmStr, iWidth, iHeight, title + '-增加');
            } break;
            case "fmodify": {
                if (key != "" && key.indexOf(",") == -1) {
                    if (theDefined.iModifyNotCheck != 1) {
                        var statusobj = approval.formStatus(formid, FormUnionList.GetSelectedKeys(formid), 'modify');
                        if (parseInt(statusobj.iStatus) > 1 && parseInt(statusobj.iStatus) != 99) {
                            MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可修改！');
                            return false;
                        }
                    }
                    if (btnPreHandler(btnObj) == false) {
                        return false;
                    }
                    FormUnionList.OpenWindow(theDefined.sDetailPage + "?iformid=" + formid + "&key=" + key + "&usetype=modify" + parmStr, iWidth, iHeight, title + '-增加');
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能修改一条数据');
                    return false;
                }
            } break;
            case "fcopy": {
                if (key != "" && key.indexOf(",") == -1) {
                    if (btnPreHandler(btnObj) == false) {
                        return false;
                    }
                    FormUnionList.OpenWindow(theDefined.sDetailPage + "?iformid=" + formid + "&usetype=add&copyKey=" + key + parmStr, iWidth, iHeight, title + '-增加');
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能复制一条数据');
                    return false;
                }
            } break;
            case "fdelete": {
                if (key != "") {
                    $.messager.confirm('确认', '您确认要删除吗，删除后数据不可恢复？', function (r) {
                        if (r) {
                            if (theDefined.iDeleteNotCheck != 1) {
                                var keyArr = key.split(",");
                                for (var j = 0; j < keyArr.length; j++) {
                                    var statusobj = approval.formStatus(formid, keyArr[j], 'delete');
                                    if (parseInt(statusobj.iStatus) > 1 && parseInt(statusobj.iStatus) != 99) {
                                        MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可删除！');
                                        return false;
                                    }
                                }
                            }
                            if (btnPreHandler(btnObj) == false) {
                                return false;
                            }
                            var storeObj = {
                                StoreProName: "SpDeleteOrModify",
                                StoreParms: [
                                    { ParmName: "@iformid", Value: formid },
                                    { ParmName: "@tablename", Value: theDefined.sTableName },
                                    { ParmName: "@fieldkey", Value: theDefined.sFieldKey },
                                    { ParmName: "@keys", Value: key },
                                    { ParmName: "@userid", Value: userid },
                                    { ParmName: "@itype", Value: 1 },
                                ]
                            };
                            var result = SqlStoreProce(storeObj);
                            if (result != "1") {
                                MessageShow('错误', result);
                                return false;
                            } else {
                                var tableid = "";
                                for (var j = 0; j < FormUnionList.childDefined.length; j++) {
                                    if (FormUnionList.childDefined[j].iZoneForm == formid) {
                                        tableid = "tbGrid" + (j + 1);
                                        break;
                                    }
                                }

                                for (var j = 0; j < keyArr.length; j++) {
                                    var thePageData = $("#" + tableid).datagrid("getRows");
                                    var theIndex = 0;
                                    for (var k = 0; k < thePageData.length; k++) {
                                        if (thePageData[k][theDefined.sFieldKey] == keyArr[j]) {
                                            theIndex = k;
                                            $("#" + tableid).datagrid("deleteRow", theIndex);
                                            break;
                                        }
                                    }
                                }
                                MessageShow('删除成功', '删除成功');
                            }
                        }
                    })
                } else {
                    MessageShow('错误', '请至少选择一条数据');
                }

            } break;
            case "submit": {
                if (key != "" && key.indexOf(",") == -1) {
                    $.messager.confirm('确认', '您确认要提交吗？', function (r) {
                        if (r) {
                            var statusobj = approval.formStatus(formid, FormUnionList.GetSelectedKeys(formid), 'modify');
                            if ((parseInt(statusobj.iStatus) > 1 && parseInt(statusobj.iStatus) != 99) || parseInt(statusobj.iStatus) == -1) {
                                MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可提交！');
                                return false;
                            }
                            if (parseInt(statusobj.iStatus) == 99) {
                                if (btnObj.sStoredProce) {
                                    var success = FormUnionList.ExecProcedure(btnObj.sStoredProce, formid, key, userid, btnID);
                                    if (success) {
                                        FormUnionList.AddLog(formid, '提交');
                                        FormUnionList.ReloadTheRow(formid, key, false);
                                        MessageShow('成功', '提交成功！');
                                    } else { return success; }
                                } else {
                                    if (btnObj.sJsCode) {
                                        var jsCode = btnObj.sJsCode;
                                        var re1 = new RegExp("<%userid%>", "g");
                                        var re2 = new RegExp("<%selectedkey%>", "g");
                                        jsCode = jsCode.replace(re1, "'" + userid + "'").replace(re2, key);
                                        eval(jsCode);
                                    }
                                }
                            } else {
                                if (approval.submit(formid, FormUnionList.GetSelectedKeys(formid))) {
                                    FormUnionList.AddLog(formid, '提交');
                                    FormUnionList.ReloadTheRow(formid, key, false);
                                    MessageShow('提交成功', '提交成功');
                                }
                            }
                        }
                    });
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能提交一条数据');
                    return false;
                }
            } break;
            case "submitcancel": {
                if (key != "" && key.indexOf(",") == -1) {
                    $.messager.confirm('确认', '您确认要撤销提交吗？', function (r) {
                        if (r) {
                            var statusobj = approval.formStatus(formid, FormUnionList.GetSelectedKeys(formid), 'modify');
                            if (parseInt(statusobj.iStatus) != 2 && parseInt(statusobj.iStatus) != 99) {
                                MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可撤销提交！');
                                return false;
                            }
                            if (parseInt(statusobj.iStatus) == 99) {
                                if (btnObj.sStoredProce) {
                                    var success = FormUnionList.ExecProcedure(btnObj.sStoredProce, formid, key, userid, btnID);
                                    if (success) {
                                        FormUnionList.AddLog(formid, '撤销提交');
                                        FormUnionList.ReloadTheRow(formid, key, false);
                                        MessageShow('成功', '撤销提交成功！');
                                    } else { return success; }
                                } else {
                                    if (btnObj.sJsCode) {
                                        var jsCode = btnObj.sJsCode;
                                        var re1 = new RegExp("<%userid%>", "g");
                                        var re2 = new RegExp("<%selectedkey%>", "g");
                                        jsCode = jsCode.replace(re1, "'" + userid + "'").replace(re2, key);
                                        eval(jsCode);
                                    }
                                }
                            } else {
                                if (approval.submitCancel(formid, FormUnionList.GetSelectedKeys(formid))) {
                                    FormUnionList.AddLog(formid, '撤销提交');
                                    FormUnionList.ReloadTheRow(formid, key, false);
                                    MessageShow('撤销提交成功', '撤销提交成功');
                                }
                            }
                        }
                    });
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能撤销提交一条数据');
                    return false;
                }
            } break;
            case "checkcancel": {
                if (key != "" && key.indexOf(",") == -1) {
                    $.messager.confirm('确认', '您确认要撤销审批吗？', function (r) {
                        if (r) {
                            var statusobj = approval.formStatus(formid, FormUnionList.GetSelectedKeys(formid), 'modify');
                            if (parseInt(statusobj.iStatus) != 3 && parseInt(statusobj.iStatus) != 4 && parseInt(statusobj.iStatus) != 99) {
                                MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可撤销审批！');
                                return false;
                            }
                            if (parseInt(statusobj.iStatus) == 99) {
                                if (btnObj.sStoredProce) {
                                    var success = FormUnionList.ExecProcedure(btnObj.sStoredProce, formid, key, userid, btnID);
                                    if (success) {
                                        FormUnionList.AddLog(formid, '撤销审批');
                                        FormUnionList.ReloadTheRow(formid, key, false);
                                        MessageShow('成功', '撤销审批成功！');
                                    } else { return success; }
                                } else {
                                    if (btnObj.sJsCode) {
                                        var jsCode = btnObj.sJsCode;
                                        var re1 = new RegExp("<%userid%>", "g");
                                        var re2 = new RegExp("<%selectedkey%>", "g");
                                        jsCode = jsCode.replace(re1, "'" + userid + "'").replace(re2, key);
                                        eval(jsCode);
                                    }
                                }
                            } else {
                                if (approval.checkCancel1(formid, FormUnionList.GetSelectedKeys(formid))) {
                                    FormUnionList.AddLog(formid, '撤销审批');
                                    FormUnionList.ReloadTheRow(formid, key, false);
                                    MessageShow('撤销审批成功', '撤销审批成功');
                                }
                            }
                        }
                    });
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能撤销审批一条数据');
                    return false;
                }
            } break;
            case "fexport": {
                if (btnPreHandler(btnObj) == false) {
                    return false;
                }
                var doExport = function (data) {
                    var url = '/Base/Handler/DataGridToExcel.ashx'; //如果为asp注意修改后缀
                    $.ajax({
                        url: url, data: { data: data, title: theDefined.sBillType }, type: 'POST', dataType: 'text',
                        success: function (fn) {
                            $("#ifrpb").attr("src", fn);
                            $.messager.progress("close");
                        },
                        error: function (xhr) {
                            alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                            $.messager.progress("close");
                        }
                    });
                    return false;
                }
                $.messager.progress({ title: "正在准备导出数据，请稍等..." });
                var data;
                if (theDefined.iQuery != 1) {
                    var options = $("#" + tableid).datagrid("options");
                    var optionsNew = deepClone(options);
                    optionsNew.pageSize = 100000;
                    optionsNew.pageList = [100000, 200000, 300000];
                    optionsNew.fit = false;
                    optionsNew.toolbar = null;
                    optionsNew.onLoadSuccess = function (data) {
                        FormUnionList.ShowFooterData(0, formid, optionsNew.queryParams.filters);
                        var data1 = $("#" + tableid + "_1").datagrid('getExcelXml', { title: 'Sheet1' });
                        doExport(data1);
                    }
                    var tableEle = $("#" + tableid + "_1");
                    if (tableEle.length == 0) {
                        $("#divExport").append("<table id='" + tableid + "_1' class='easyui-datagrid'></table>");
                    }
                    $.parser.parse("#divExport");
                    $("#" + tableid + "_1").datagrid(optionsNew);
                }
                else {
                    data = $("#" + tableid).datagrid('getExcelXml', { title: 'Sheet1' }); //获取datagrid数据对应的excel需要的xml格式的内容
                    doExport(data);
                }
            } break;
            case "fimport": {
                if (btnPreHandler(btnObj) == false) {
                    return false;
                }
                $("#ifrImport").attr("src", "/Base/FileUpload/ImportExcel2.aspx?&iFormID=" + formid + "&r=" + Math.random);
                $("#divImport").dialog("open");
            } break;
            case "checkcancelAsk": {
                if (key != "" && key.indexOf(",") == -1) {
                    var statusobj = approval.formStatus(formid, key, 'modify');
                    if (parseInt(statusobj.iStatus) != 3 && parseInt(statusobj.iStatus) != 4) {
                        MessageShow('错误', '单据状态：[' + statusobj.sStatusName + ']，不可申请撤销审批！');
                        return false;
                    }
                    if (parseInt(statusobj.iStatus) == 99) {
                        if (btnObj.sStoredProce) {
                            var success = FormUnionList.ExecProcedure(btnObj.sStoredProce, formid, key, userid, btnID);
                            if (success) {
                                FormUnionList.ReloadTheRow(formid, key);
                                MessageShow('成功', '申请撤销审批成功！');
                            } else {
                                return success;
                            }
                        } else {
                            if (btnObj.sJsCode) {
                                var jsCode = btnObj.sJsCode;
                                var re1 = new RegExp("<%userid%>", "g");
                                var re2 = new RegExp("<%selectedkey%>", "g");
                                jsCode = jsCode.replace(re1, "'" + userid + "'").replace(re2, key);
                                eval(jsCode);
                            }
                        }
                    } else {
                        $.messager.prompt('撤销原因', '请输入申请撤销原因(必填):', function (r) {
                            if (r != '' && r != undefined && r != null) {
                                if (approval.checkCancelAsk(formid, key, r) == true) {
                                    FormUnionList.ReloadTheRow(formid, key);
                                    MessageShow('成功', '申请撤销审批成功');
                                }
                            } else if (r == '') {
                                MessageShow('未输入原因', '请输入申请撤销原因');
                                return false;
                            } else if (r == undefined || r == null) {

                            }
                        });
                    }
                } else if (key == "") {
                    MessageShow('错误', '请选择一条数据');
                } else {
                    MessageShow('错误', '一次只能申请一条数据');
                    return false;
                }
            } break;
        }
    },
    BtnExit: function () {
        try {
            if (getQueryString("fullScreen") == "1") {
                top.closeFullScreenWindow();
            }
            else {
                top.closeTab();
            }
        }
        catch (e) {
            window.close();
        }
    },
    OpenWindow: function (url, iWidth, iHeight, title) {
        var islogin = FormUnionList.IsLogin();
        if (islogin) {
            $("#divFormBill").show();
            //window.parent.formOpen(getQueryString("MenuID"));
            if (iWidth == "-1" || iHeight == "-1") {
                $("#divFormBill").window({
                    title: title,
                    noheader: true,
                    border: false,
                    maximizable: true,
                    minimizable: false,
                    collapsible: false,
                    closable: true,
                    //closed: true,
                    zIndex: 9999999,
                    modal: true,
                    maximized: true,
                    width: 1000,
                    height: 600,
                    content: "<iframe id='ifrBill' width='100%' height='100%' src=\"" + url + "\" frameborder='0'></iframe>"
                });
                setTimeout("$('#divFormBill').window('maximize');", 1000);
            }
            else {
                $("#divFormBill").window({
                    title: title,
                    noheader: true,
                    border: false,
                    maximizable: true,
                    minimizable: false,
                    collapsible: false,
                    closable: true,
                    zIndex: 9999999,
                    modal: true,
                    width: iWidth,
                    height: iHeight,
                    content: "<iframe id='ifrBill' width='100%' height='100%' src=\"" + url + "\" frameborder='0'></iframe>"
                });
                setTimeout("$('#divFormBill').window('resize',{width:" + iWidth + ",height:" + iHeight + "});", 1000);
            }
        }
    },
    BuildPrintList: function (formid, pbReportArr) {
        var divPrint = $("#divPrint_" + formid);
        if (divPrint.length == 0) {
            $("body").append("<div id='divPrint_" + formid + "' style='width: 350px; height: 300px;'><div id='divPrintAcc_" + formid + "'></div></div>");
            $("#divPrintAcc_" + formid).accordion();
        }
        if (pbReportArr.length > 0) {
            var sGroupArr = [];
            var hasNoGroup = false;
            $.each(pbReportArr, function (index, o) {
                if (o.sGroup == null) {
                    hasNoGroup = true;
                }
                if ($.inArray((o.sGroup == null ? "" : o.sGroup), sGroupArr) == -1) {
                    sGroupArr.push((o.sGroup == null ? "" : o.sGroup));
                }
            });
            sGroupArr.sort();
            $.each(sGroupArr, function (index, o) {
                //if (o == null || o == "") {
                $("#divPrintAcc_" + formid).accordion("add", {
                    title: o,
                    collapsed: (o == "" ? false : true),
                    collapsible: (o == "" ? false : true),
                    selected: (hasNoGroup == true ? (index == 1 ? true : false) : (index == 0 ? true : false)),
                    content: '<table id="tabPrint' + formid + "_" + index + '" class="tabprint"></table>'
                });
                $.each(pbReportArr, function (index1, o1) {
                    if ((o1.sGroup == null ? "" : o1.sGroup) == o) {
                        FormUnionList.AddAccPrintRow(formid, "tabPrint" + formid + "_" + index, o1.sPbName, o1.iRecNo, o1.sReportType, o1.iDataSourceFromList, o1.sParms);
                    }
                });
            })

        }
    },
    AddAccPrintRow: function (formid, tableid, pbname, irecno, reportType, iDataSourceFromList, sParms) {
        sParms = sParms ? "'" + sParms + "'" : null;
        var tab = document.getElementById(tableid);
        var tr = $("<tr></tr>");
        $(tab).append(tr);
        $(tr).append("<td>" + pbname + "</td>");
        $(tr).append("<td style='width:60px;'><a href='#' onclick=FormUnionList.PrintClick(this," + formid + "," + irecno + ",'print','" + reportType + "'," + iDataSourceFromList + "," + sParms + ")>直接打印</a></td>");
        $(tr).append("<td style='width:30px;'><a href='#' style='width:50px;' onclick=FormUnionList.PrintClick(this," + formid + "," + irecno + ",'show','" + reportType + "'," + iDataSourceFromList + "," + sParms + ")>预览</a></td>");
        if (userid.toLowerCase() == "master") {
            $(tr).append("<td style='width:30px;'><a href='#' onclick=FormUnionList.PrintClick(this," + formid + "," + irecno + ",'design','" + reportType + "'," + iDataSourceFromList + "," + sParms + ")>设计</a></td>");
        }
    },
    PrintClick: function (obj, formid, irecno, otype, reportType, iDataSourceFromList, sParms) {
        var selectedkey = FormUnionList.GetSelectedKeys(formid);
        if (selectedkey.length == 0) {
            MessageShow('未选择数据', '未选择任务行！');
            obj.href = "#";
            obj.target = "";
            return;
        }
        else {
            var theDefine;
            var tableid = "";
            for (var i = 0; i < FormUnionList.childDefined.length; i++) {
                if (FormUnionList.childDefined[i].iZoneForm == formid) {
                    theDefine = FormUnionList.childDefined[i];
                    tableid = "tbGrid" + (i + 1);
                    break;
                }
            }

            var fileName = "";
            if (iDataSourceFromList == "1") {
                $.messager.progress({ title: "正在准备打印数据，请稍等..." });
                var data = $("#" + tableid).datagrid("getData");
                var url = '/Base/Handler/DataGridToJson.ashx'; //如果为asp注意修改后缀
                $.ajax({
                    url: url,
                    data: { data: JSON2.stringify(data.rows), title: formid, pbRecNo: irecno },
                    type: 'POST',
                    dataType: 'text',
                    async: false,
                    success: function (fn) {
                        //filters = filters == "" ? "" : "&" + filters;
                        //var fileName = fn;
                        if (fn && fn != "") {
                            fileName = fn.substr(0, fn.lastIndexOf("."));
                        }
                        $.messager.progress("close");
                    },
                    error: function (xhr) {
                        alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                        $.messager.progress("close");
                    }
                });
            }

            obj.target = "ifrpb";

            var urlKeys = "";
            if (sParms == undefined || sParms == null) {
                urlKeys = FormUnionList.GetSelectedKeys(formid)
            }
            else {
                for (var i = 0; i < FormUnionList.childDefined.length; i++) {
                    if (formid == FormUnionList.childDefined[i].iZoneForm) {
                        var selectedRows = $("#tbGrid" + (i + 1)).datagrid("getSelections");
                        for (var i = 0; i < selectedRows.length; i++) {
                            urlKeys += selectedRows[i][(sParms)] + ",";
                        }
                        if (urlKeys.length > 0) {
                            urlKeys = urlKeys.substr(0, urlKeys.length - 1);
                        }
                        return urlKeys;
                    }
                }
            }

            var url = "";
            if (reportType == "fastreport") {
                url = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + formid + "&irecno=" + irecno + "&key=" + urlKeys + "&" + theDefine.filtersPb + "&FormListFileName=" + fileName;
                obj.href = url;
            }
            else if (reportType == "lodop") {
                var title = $(obj).parent().parent().children("td:first-child").html();
                if (otype == "design") {
                    url = "/Base/PbLodop.aspx?otype=" + otype + "&iformid=" + formid + "&irecno=" + irecno + "&key=" + urlKeys + "&" + theDefine.filtersPb + "&FormListFileName=" + fileName + "&title=" + escape(theDefine.sBillType) + "";
                    window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                }
                else {
                    if (otype == "show") {
                        hxLodop.preview(formid, urlKeys, irecno, "", theDefine.pbCondition, fileName);
                    }
                    if (otype == "print") {
                        hxLodop.print(formid, urlKeys, irecno, "", theDefine.pbCondition, fileName);
                    }
                }
            }
            $("#btnPrint_" + formid).tooltip("hide");
        }
    },
    AddAssociatedRow: function (id, sourceFormid, formid, aname, parmvalue, filepath, icon) {
        var tab = document.getElementById("tabAssociated_" + sourceFormid);
        var tr = $("<tr></tr>");
        $(tab).append(tr);
        $(tr).append("<td><a href='#' onclick=FormUnionList.AssociatedClick(\"" + id + "\",\"" + sourceFormid + "\",\"" + formid + "\",\"" + aname + "\",\"" + encodeURIComponent(parmvalue) + "\",\"" + filepath + "\",\"" + icon + "\")>" + aname + "</a></td>");
    },
    AssociatedClick: function (id, sourceFormID, formid, name, parmvalue, filepath, icon) {
        var selectedRow = FormUnionList.GetSelectedKeys(formid);
        parmvalue = decodeURIComponent(parmvalue);
        parmvalue = parmvalue == "" ? "1=1" : parmvalue;
        while (parmvalue.indexOf("{") > -1) {
            if (selectedRow.length > 0) {
                var indexs = parmvalue.indexOf("{");
                var indexe = parmvalue.indexOf("}");
                var fieldname = parmvalue.substr(indexs + 1, indexe - indexs - 1);
                var fieldvalue = selectedRow[0][fieldname];
                if (fieldvalue == undefined || fieldvalue == null) {
                    MessageShow("不存在的参数", "对不起，不存在参数：{" + fieldname + "}");
                    return false;
                }
            }
            else {
                MessageShow("请选择数据", "亲，请选择一条数据");
                return false;
            }
            parmvalue = parmvalue.replace("{" + fieldname + "}", selectedRow[0][fieldname]);
        }
        parent.turntoTab(id, formid, name, parmvalue, filepath, icon, true);
    },
    IsLogin: function () {
        var islogin = false;
        $.ajax({
            url: "/ashx/LoginHandler.ashx",
            data: { otype: "islogin", r: Math.random() },
            async: false,
            cache: false,
            success: function (data) {
                if (data != "1") {
                    $("#divlogin").window("open");
                    islogin = false;
                }
                else {
                    islogin = true;
                }
            },
            error: function () {
                islogin = false;
            }
        });
        return islogin;
    },
    ReLogin: function () {
        var userid = document.getElementById("txbReLoginUserID").value;
        var psd = document.getElementById("txbReLoginPsd").value;
        if (userid.length == 0) {
            MessageShow("不能为空", "用户名不能为空！");
            return false;
        }
        $.ajax(
        {
            url: "/ashx/LoginHandler.ashx",
            async: false,
            success: function (data) {
                if (data.indexOf("warn") > -1 || data.indexOf("error") > -1) {
                    MessageShow("错误", data);
                    return false;
                }
                else {
                    $("#divlogin").window("close");
                }
            }
        });
    },
    NeedSelectedKey: undefined,
    ReloadTheRow: function (formid, key, isAdd) {
        var tableid = "";
        var sFieldKey = "";
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            if (formid == FormUnionList.childDefined[i].iZoneForm) {
                tableid = "tbGrid" + (i + 1);
                sFieldKey = FormUnionList.childDefined[i].sFieldKey;
                break;
            }
        }
        $.ajax({
            url: "/Base/Handler/FormListHandler.ashx",
            type: "post",
            async: false,
            cache: false,
            data: { otype: "GetTheFormListData", iformid: formid, iMenuID: "", key: key },
            success: function (data) {
                if (data.success == true) {
                    if (data.tables[0].length > 0) {
                        if (isAdd) {
                            $("#" + tableid).datagrid("insertRow", {
                                index: 0,
                                row: data.tables[0][0]
                            })
                            $("#" + tableid).datagrid("unselectAll");
                            $("#" + tableid).datagrid("selectRow", 0);
                        }
                        else {
                            var index = -1;
                            var dataRows = $("#" + tableid).datagrid("getRows");
                            for (var i = 0; i < dataRows.length; i++) {
                                if (dataRows[i][(sFieldKey)] == key) {
                                    index = i;
                                    break;
                                }
                            }
                            $("#" + tableid).datagrid("updateRow", {
                                index: index,
                                row: data.tables[0][0]
                            });
                            $("#" + tableid).datagrid("unselectAll");
                            $("#" + tableid).datagrid("selectRow", index);
                        }
                    }
                }
            },
            error: function (data) {
            },
            dataType: "json"
        });
    },
    AddLog: function (formid, oType) {
        var tableid = "";
        var title = "";
        for (var i = 0; i < FormUnionList.childDefined.length; i++) {
            if (FormUnionList.childDefined[i].iZoneForm == formid) {
                tableid = "tbGrid" + (i + 1);
                title = FormUnionList.childDefined[i].sBillType;
                break;
            }
        }
        var selectKeys = $("#" + tableid).datagrid("getSelections");
        for (var i = 0; i < selectKeys.length; i++) {
            SysOpreateAddLog(oType, formid, selectKeys[i], title);
        }
    },
    ShowFj: function (iformid, tablename, obj) {
        var irecno = obj.id;
        $("#divFj").css("display", "");
        $("#ifrFj").attr("src", "/Base/FileUpload/FileUpload.aspx?usetype=view&iformid=" + iformid + "&tablename=" + tablename + "&irecno=" + irecno + "&fileType=acc&random=" + Math.random());
        $("#divFj").window(
            {
                width: 600,
                height: 300,
                minimizable: false,
                maximizable: false,
                collapsible: false,
                modal: true,
                top: 100,
                title: "附件列表"
            });
    }
}
function isNullOrDefined(n) {
    if (n == null || n == undefined) {
        return true;
    }
    return false;
}
function isNullOrDefinedOrZero(n) {
    if (n == null || n == undefined || n == 0) {
        return true;
    }
    return false;
}
var onImportExcelSuccess = undefined;

function setImportFinishInfo(message) {
    $("#pImportFinishInfo").html(message);
}

function showImportFinishInfo() {
    $("#divImportFinishInfo").dialog("open");
}

function hideImport() {
    $("#divImport").dialog("close");
}
function CloseBillWindow() {
    for (var i = 0; i < window.parent.openMenuID.length; i++) {
        if (window.parent.openMenuID[i] == getQueryString("MenuID")) {
            window.parent.openMenuID.splice(i, 1);
            break;
        }
    }
    $("#divFormBill").window("close");
}

function DeepCopy(obj) {
    var out = [], i = 0, len = obj.length;
    for (; i < len; i++) {
        if (obj[i] instanceof Array) {
            out[i] = DeepCopy(obj[i]);
        }
        else out[i] = obj[i];
    }
    return out;
}
function MessageShow(title, message) {
    var iheight = (message.length / 20) * 20;
    iheight = iheight < 100 ? 100 : iheight;
    $.messager.show({
        showSpeed: 100,
        title: title,
        height: iheight,
        msg: message,
        showType: 'slide',
        timeout: 2000,
        style: {
            right: '',
            top: document.body.scrollTop + document.documentElement.scrollTop,
            bottom: ''
        }
    });
}

function pagerFilter(data) {
    if (typeof data.length == 'number' && typeof data.splice == 'function') {    // 判断数据是否是数组
        data = {
            total: data.length,
            rows: data
        }
    }
    var dg = $(this);
    var opts = dg.datagrid('options');
    var pager = dg.datagrid('getPager');
    pager.pagination({
        onSelectPage: function (pageNum, pageSize) {
            opts.pageNumber = pageNum;
            opts.pageSize = pageSize;
            pager.pagination('refresh', {
                pageNumber: pageNum,
                pageSize: pageSize
            });
            dg.datagrid('loadData', data);
        }
    });
    if (!data.originalRows) {
        data.originalRows = (data.rows);
    }
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
    var end = start + parseInt(opts.pageSize);
    data.rows = (data.originalRows.slice(start, end));
    return data;
}
function DataGridLocalSort(sort, order) {
    var pager = $(this).datagrid("getPager");
    var pageSize = $(this).datagrid('options').pageSize;
    var pageNo = $(this).datagrid('options').pageNumber;
    var start = (pageNo - 1) * pageSize;
    var end = start + pageSize;
    var allData = FormUnionList[(this.id)];

    var sort1 = new JsonArrSort(allData, sort, order) //建立对象
    sort1.init(allData, sort, order);//初始化参数更改
    sort1.sort();

    $(this).datagrid("loadData", allData.slice(start, end));
    pager.pagination('refresh', {
        total: allData.length,
        pageNumber: pageNo
    });
}
$.extend($.fn.form.methods, {
    getData: function (jq, params) {
        var formArray = jq.serializeArray();
        var oRet = {};
        for (var i in formArray) {
            if (typeof (oRet[formArray[i].name]) == 'undefined') {
                if (params) {
                    oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                }
                else {
                    oRet[formArray[i].name] = formArray[i].value;
                }
            }
            else {
                if (params) {
                    oRet[formArray[i].name] = (formArray[i].value == "true" || formArray[i].value == "false") ? formArray[i].value == "true" : formArray[i].value;
                }
                else {
                    oRet[formArray[i].name] += "," + formArray[i].value;
                }
            }
        }
        return oRet;
    }
});

function showBigImage() {
    $(".btnImageShow").tooltip(
    {
        content: function () {
            var t = $(this);
            var img = $(t).children("img")[0];
            var src = $(img).attr("src");
            var alt = $(img).attr("alt");
            return $("<div><img src='" + src.replace("&isThum=1", "&isThum=0") + "' alt='" + alt + "' style='width:250px; height:250px;'></div>");
        },
        /*showEvent: 'click',*/
        onShow: function () {
            var t = $(this);
            t.tooltip("tip").unbind().bind("mouseenter",
                function () { t.tooltip("show"); }).bind("mouseleave",
                function () {
                    t.tooltip("hide");
                });
        }
    });
}

function loadJS(path) {
    if (!path || path.length === 0) {
        throw new Error('argument "path" is required !');
    }
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.src = path;
    script.type = 'text/javascript';
    head.appendChild(script);
}
function loadCSS(path) {
    if (!path || path.length === 0) {
        throw new Error('argument "path" is required !');
    }
    var head = document.getElementsByTagName('head')[0];
    var link = document.createElement('link');
    link.href = path;
    link.rel = 'stylesheet';
    head.appendChild(link);
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
    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
    var second = nowdate.getSeconds();
    return hour + ":" + minute + ":" + second;
}

function NewGuid_S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function NewGuid() {
    return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
}

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}

String.prototype.startWith = function (str) {
    var reg = new RegExp("^" + str);
    return reg.test(this);
}
//测试ok，直接使用str.endWith("abc")方式调用即可
String.prototype.endWith = function (str) {
    var reg = new RegExp(str + "$");
    return reg.test(this);
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