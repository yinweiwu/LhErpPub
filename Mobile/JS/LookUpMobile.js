var lookUpMobile = {
    /*
    lookup数组结构
    {
    targetID: id,
    objs: [lookUpObj]
    });

    lookUpObj数据结构
    {
    uniqueid:"",
    lookUpName:"",
    lookUpFilters:"",//本身的查询条件
    dFilters:"",//动态的查询条件
    matchFields:[],
    modifyOrViewMatchFields:[],
    valueField,
    textField,
    searchConditions:[]
    }
    */
    formid: undefined,
    init: function () {
        $("#divLookUpResultList").datalist(
            {
                fit: true,
                lines: true,
                border: false,
                onClickRow: function (index, row) {
                    var value = row.__lookupid;
                    if (value) {
                        lookUpMobile.setValue(row, lookUpMobile.current.targetID);
                        $.mobile.back();
                        setTimeout(function () {
                            lookUpMobile.reset();
                        }, 500);
                    }
                    else {
                        var tables = lookUpMobile.getLookUpData();
                        var lookupObj = lookUpMobile.getLookUpObjByCurrent();
                        if (tables.length > 0) {
                            var totalOld = lookupObj.total == null || lookupObj.total == undefined ? 0 : lookupObj.total;
                            var rowCountOld = lookupObj.rowCount == null || lookupObj.rowCount == undefined ? 0 : lookupObj.rowCount;
                            var rowsNow = $("#divLookUpResultList").datalist("getRows");
                            if (totalOld > rowCountOld) {
                                $("#divLookUpResultList").datalist("deleteRow", rowsNow.length - 1);
                            }
                            var data = tables[0];
                            var total = tables[1][0].Column1;
                            lookupObj.total = total;
                            var dataNow = $("#divLookUpResultList").datalist("getRows");
                            var dataAll = dataNow.concat(data);
                            lookupObj.rowCount = dataAll.length;
                            $("#divLookUpResultList").datalist("loadData", dataAll);
                            dataNow = data = null;
                            if (total > lookupObj.rowCount) {
                                $("#divLookUpResultList").datalist("appendRow", {});
                            }
                        }
                    }
                }
            }
        )

        var inputLookup = $("input[lookUpOptions]");
        for (var i = 0; i < inputLookup.length; i++) {
            var lookUpOptionsStr = $(inputLookup[i]).attr("lookUpOptions");
            var lookUpOptions = eval("(" + lookUpOptionsStr + ")");

            var li = $(inputLookup[i]).parent().parent();
            var id = $(inputLookup[i]).attr("id");
            var field = $(inputLookup[i]).attr("name")
            var lookUpName = $(inputLookup[i]).attr("lookUpName");
            var lookUpFilters = $(inputLookup[i]).attr("lookUpFilters");
            var title = $(li).text();
            var newhtml = "<a id=\"" + id + "_Link\" href=\"javascript:void(0)\" onclick=\"lookUpMobile.open(this)\">" + title + "</a><input hasLookUp=true id=\"" + id + "_Value\" type=\"hidden\" name=\"" + field + "\" /><div id=\"" + id + "_Text\" class=\"m-right\" style=\"margin-right:12px; margin-top:10px;\"></div>";
            li.html(newhtml);
            for (var j = 0; j < lookUpOptions.length; j++) {
                $.ajax(
                {
                    url: "/Mobile/Handler/MobileHandler.ashx",
                    async: false,
                    cache: false,
                    type: "post",
                    data: { otype: "GetLookUpDefine", lookUpName: lookUpOptions[j].lookUpName },
                    success: function (resText) {
                        var resObj = JSON2.parse(resText);
                        if (resObj.success == true) {
                            tables = resObj.tables;
                            lookUpOptions[j].valueField = tables[0][0].sReturnField;
                            lookUpOptions[j].textField = tables[0][0].sDisplayField;
                        }
                        else {
                            $.messager.alert("获取lookup数据时出错", resObj.message);
                        }

                    },
                    error: function (resText) {
                        $.messager.alert("获取lookup数据时出错", resObj.message);
                    }
                });
            }

            lookUpMobile.lists.push(
            {
                targetID: id,
                objs: lookUpOptions
            });
        }
        if (typeof (pageMobile) == "undefined") {
            lookUpMobile.formid = "form1";
        }
        else {
            lookUpMobile.formid = pageMobile.htmlFormID;
        }

    },
    lists: [],
    current: undefined,
    currentObj: undefined,
    getLookUpByTargetID: function (targetid) {
        for (var i = 0; i < this.lists.length; i++) {
            if (this.lists[i].targetID == targetid) {
                return this.lists[i];
            }
        }
        return undefined;
    },
    getLookUpObjByTargetID: function (targetid) {
        var lookupObj = lookUpMobile.getLookUpByTargetID(targetid);
        if (lookupObj.objs.length == 0) {
            return lookupObj.objs[0];
        }
        else {
            for (var i = 0; i < lookupObj.objs.length; i++) {
                if (lookUpMobile.IsConditionFit) {
                    var resultFit = lookUpMobile.IsConditionFit(lookupObj.objs[i].uniqueid);
                    if (resultFit == true) {
                        return lookupObj.objs[i];
                    }
                }
                else {
                    return lookupObj.objs[i];
                }
            }
        }
    },
    getLookUpObjByCurrent: function () {
        var lookupObj = lookUpMobile.current;
        if (lookupObj.objs.length == 1) {
            return lookupObj.objs[0];
        }
        else {
            for (var i = 0; i < lookupObj.objs.length; i++) {
                if (lookUpMobile.IsConditionFit) {
                    var resultFit = lookUpMobile.IsConditionFit(lookupObj.objs[i].uniqueid);
                    if (resultFit == true) {
                        return lookupObj.objs[i];
                    }
                }
                else {
                    return lookupObj.objs[i];
                }
            }
        }
    },
    parseFieldValue: function (str, startIndex) {
        var formData = $("#" + lookUpMobile.formid).serializeObject(); // GetFormData("form1");
        if (typeof (pageMobile) == "undefined") {
            str = str.replace(/{userid}/g, userid);
        }
        else {
            str = str.replace(/{userid}/g, pageMobile.userid);
        }
        if (startIndex == undefined || startIndex == null) {
            startIndex = 0;
        }
        while (str.indexOf("#", startIndex) > -1) {
            var indexStart = str.indexOf("#", startIndex);
            var indexEnd = str.indexOf("#", indexStart + 1);
            if (indexEnd == -1) {
                $.messager.alert("错误", "解析主表语句中字段时错误：'#'未成对出现！");
                return false;
            }
            var field = str.substr(indexStart + 1, indexEnd - indexStart - 1);
            if (field.indexOf("#") > -1) {
                str = this.parseFieldValue(str, startIndex + 1);
            }
            var fieldValue = formData[(field.replace("m.", ""))];
            str = str.replace("#" + field + "#", fieldValue);
        }
        return str;
    },
    open: function (obj) {
        var objid = obj.id;
        var targetid = objid.substr(0, objid.indexOf("_Link"));
        var lookUp = lookUpMobile.getLookUpByTargetID(targetid);

        var lookupObj = lookUpMobile.getLookUpObjByTargetID(targetid);
        var pageSize = lookupObj.pageSize == null || lookupObj.pageSize == undefined ? 30 : lookupObj.pageSize;
        if (lookUpMobile.beforeOpen) {
            if (lookUpMobile.beforeOpen(lookupObj.uniqueid) == false) {
                return false;
            }
        }
        var filters = lookUpMobile.parseFieldValue(lookupObj.lookUpFilters);
        filters = filters == "" ? "1=1" : filters;
        if (lookUpMobile.current != lookUp || lookUpMobile.currentObj != lookupObj) {
            $("#divLookUpResultList").datalist(
            {
                //valueField: lookupObj.valueField,
                textField: lookupObj.textField,
                textFormatter: function (value, row, index) {
                    if (row.__lookupid) {
                        return row[(lookupObj.textField)];
                    }
                    else {
                        return "点击加载更多...";
                    }
                }
            }

        );
        }
        lookUpMobile.current = lookUp;
        lookUpMobile.currentObj = lookupObj;
        $.ajax(
            {
                url: "/Mobile/Handler/MobileHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { otype: "GetLookUpData", lookUpName: lookupObj.lookUpName, rows: 0, PageSize: 2, filters: filters },
                success: function (resText) {
                    var resObj = JSON2.parse(resText);
                    if (resObj.success == true) {
                        var dataOne = resObj.tables[0];
                        if (dataOne.length == 1) {
                            //lookUpMobile.setValue(dataOne[0]);
                            $("#divLookUpResultList").datalist("loadData", dataOne);
                            $.mobile.go("#divLookUpList", "slide", "up");
                        }
                        else if (dataOne.length > 1) {
                            var tables = lookUpMobile.getLookUpData();
                            if (tables.length > 0) {
                                var totalOld = lookupObj.total == null || lookupObj.total == undefined ? 0 : lookupObj.total;
                                var rowCountOld = lookupObj.rowCount == null || lookupObj.rowCount == undefined ? 0 : lookupObj.rowCount;
                                var dataNow = $("#divLookUpResultList").datalist("getRows");
                                if (totalOld > rowCountOld) {
                                    $("#divLookUpResultList").datalist("deleteRow", dataNow.length - 1);
                                }

                                var data = tables[0];
                                var total = tables[1][0].Column1;
                                lookupObj.total = total;
                                var dataNow = $("#divLookUpResultList").datalist("getRows");
                                var dataAll = dataNow.concat(data);
                                lookupObj.rowCount = dataAll.length;
                                var options = $("#divLookUpResultList").datalist("options");
                                $("#divLookUpResultList").datalist("loadData", dataAll);
                                dataNow = data = null;
                                if (total > lookupObj.rowCount) {
                                    $("#divLookUpResultList").datalist("appendRow", {});
                                }
                                $.mobile.go("#divLookUpList", "slide", "up");
                            }
                        }
                        else {
                            $.messager.alert("没有符合条件的数据", "没有符合条件的数据！");
                        }
                    }
                    else {
                        $.messager.alert("获取lookup数据时出错", resObj.message);
                    }

                },
                error: function (resText) {
                    $.messager.alert("获取lookup数据时出错", resObj.message);
                }
            }
        )
    },
    setValue: function (data, targetid, isInit) {
        var lookUp = lookUpMobile.getLookUpByTargetID(targetid);
        var lookupObj = lookUpMobile.getLookUpObjByTargetID(targetid);
        if (lookUpMobile.beforeSetValue) {
            if (lookUpMobile.beforeSetValue(lookupObj.uniqueid, data) == false) {
                return false;
            }
        }
        if (lookUp && lookupObj) {
            var targetID = lookUp.targetID;
            if (data) {
                $("#" + targetID + "_Value").val(data[(lookupObj.valueField)]);
                $("#" + targetID + "_Text").html(data[(lookupObj.textField)]);
            }
            else {
                $("#" + targetID + "_Value").val("");
                $("#" + targetID + "_Text").html("");
            }
            //如果是页面初始化时，不需要其他匹配字段
            if (isInit != true) {
                if (lookupObj.matchFields && lookupObj.matchFields.length > 0) {
                    var matchData = {};
                    for (var i = 0; i < lookupObj.matchFields.length; i++) {
                        var targetField = lookupObj.matchFields[i].split("=")[0];
                        var returnField = lookupObj.matchFields[i].split("=")[1];
                        var inputTarget = $("#" + lookUpMobile.formid + " input[name='" + targetField + "']");
                        if (inputTarget) {
                            var hasLookUp = $(inputTarget).attr("hasLookUp");
                            if (hasLookUp == "true") {
                                var targetidM = $(inputTarget).attr("id").substr(0, $(inputTarget).attr("id").indexOf("_"));
                                var lookupObjMatch = lookUpMobile.getLookUpObjByTargetID(targetidM);
                                var filtersMatch = lookupObjMatch.valueField + "='" + data[(returnField)] + "'";

                                $.ajax(
                                {
                                    url: "/Mobile/Handler/MobileHandler.ashx",
                                    async: false,
                                    cache: false,
                                    type: "post",
                                    data: { otype: "GetLookUpData", lookUpName: lookupObjMatch.lookUpName, rows: 0, PageSize: 1, filters: filtersMatch },
                                    success: function (resText) {
                                        var resObj = JSON2.parse(resText);
                                        if (resObj.success == true) {
                                            var dataMatch = resObj.tables[0];
                                            lookUpMobile.setValue(dataMatch[0], targetidM);
                                        }
                                        //                                        else {
                                        //                                            $.messager.alert("获取lookup数据时出错", resObj.message);
                                        //                                        }
                                    },
                                    error: function (resText) {
                                        //$.messager.alert("获取lookup数据时出错", resObj.message);
                                    }
                                }
                            )

                                //lookUpMobile.setValue(data, targetidM);
                            }
                            else {
                                var isSwitch = $("#" + lookUpMobile.formid + " input[switchbuttonname='" + targetField + "']");
                                if (isSwitch.length > 0) {
                                    if (data[(returnField)] == "1") {
                                        matchData[(targetField)] = "on";
                                    }
                                    else {
                                        matchData[(targetField)] = "off";
                                    }
                                }
                                else {
                                    matchData[(targetField)] = data[(returnField)];
                                }
                            }
                        }
                        else {
                            matchData[(targetField)] = data[(returnField)];
                        }
                    }
                    $("#" + lookUpMobile.formid).form("load", matchData);
                }
            }
            else {
                if (pageMobile.usetype == "modify" || pageMobile.usetype == "view") {
                    if (lookupObj.modifyOrViewMatchFields && lookupObj.modifyOrViewMatchFields.length > 0) {
                        var matchData = {};
                        for (var i = 0; i < lookupObj.modifyOrViewMatchFields.length; i++) {
                            var targetField = lookupObj.modifyOrViewMatchFields[i].split("=")[0];
                            var returnField = lookupObj.modifyOrViewMatchFields[i].split("=")[1];
                            var inputTarget = $("#" + lookUpMobile.formid + " input[name='" + targetField + "']");
                            if (inputTarget) {
                                var hasLookUp = $(inputTarget).attr("hasLookUp");
                                if (hasLookUp == "true") {
                                    var targetidM = $(inputTarget).attr("id").substr(0, $(inputTarget).attr("id").indexOf("_"));
                                    var lookupObjMatch = lookUpMobile.getLookUpObjByTargetID(targetidM);
                                    var filtersMatch = lookupObjMatch.valueField + "='" + data[(returnField)] + "'";

                                    $.ajax(
                                {
                                    url: "/Mobile/Handler/MobileHandler.ashx",
                                    async: false,
                                    cache: false,
                                    type: "post",
                                    data: { otype: "GetLookUpData", lookUpName: lookupObjMatch.lookUpName, rows: 0, PageSize: 1, filters: filtersMatch },
                                    success: function (resText) {
                                        var resObj = JSON2.parse(resText);
                                        if (resObj.success == true) {
                                            var dataMatch = resObj.tables[0];
                                            lookUpMobile.setValue(dataMatch[0], targetidM);
                                        }
                                        //                                        else {
                                        //                                            $.messager.alert("获取lookup数据时出错", resObj.message);
                                        //                                        }
                                    },
                                    error: function (resText) {
                                        //$.messager.alert("获取lookup数据时出错", resObj.message);
                                    }
                                }
                            )

                                    //lookUpMobile.setValue(data, targetidM);
                                }
                                else {
                                    matchData[(targetField)] = data[(returnField)];
                                }
                            }
                            else {
                                var isSwitch = $("#" + lookUpMobile.formid + " input[switchbuttonname='" + targetField + "']");
                                if (isSwitch.length > 0) {
                                    if (data[(returnField)] == "1") {
                                        matchData[(targetField)] = "on";
                                    }
                                    else {
                                        matchData[(targetField)] = "off";
                                    }
                                }
                                else {
                                    matchData[(targetField)] = data[(returnField)];
                                }
                                //matchData[(targetField)] = data[(returnField)];
                            }
                        }
                        $("#" + lookUpMobile.formid).form("load", matchData);
                    }
                }
            }
            if (lookUpMobile.afterSelected) {
                lookUpMobile.afterSelected(lookupObj.uniqueid, data);
            }


        }

    },
    //页面修改或浏览时加载lookup的数据
    load: function () {
        var inputLookup = $("#" + lookUpMobile.formid + " input[hasLookUp]");
        for (var i = 0; i < inputLookup.length; i++) {
            var value = $(inputLookup[i]).val();
            var targetid1 = $(inputLookup[i]).attr("id").substr(0, $(inputLookup[i]).attr("id").indexOf("_"));
            var lookupObj1 = lookUpMobile.getLookUpObjByTargetID(targetid1);
            var filter1 = lookupObj1.valueField + "='" + value + "'";
            $.ajax(
            {
                url: "/Mobile/Handler/MobileHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { otype: "GetLookUpData", lookUpName: lookupObj1.lookUpName, rows: 0, PageSize: 1, filters: filter1 },
                success: function (resText) {
                    var resObj = JSON2.parse(resText);
                    if (resObj.success == true) {
                        var dataMatch = resObj.tables[0];
                        lookUpMobile.setValue(dataMatch[0], targetid1, true);
                    }
                    else {
                        $.messager.alert("获取lookup数据时出错", resObj.message);
                    }
                },
                error: function (resText) {
                    $.messager.alert("获取lookup数据时出错", resObj.message);
                }
            }
            )
        }
    },
    getLookUpData: function () {
        var lookupObj = lookUpMobile.getLookUpObjByCurrent();
        var pageSize = lookupObj.pageSize == null || lookupObj.pageSize == undefined ? 30 : lookupObj.pageSize;
        var rowCount = lookupObj.rowCount == null || lookupObj.rowCount == undefined ? 0 : lookupObj.rowCount;
        var filters = lookUpMobile.parseFieldValue(lookupObj.lookUpFilters);
        filters = filters == "" ? "1=1" : filters;
        var dFilters = lookupObj.dFilters == undefined || lookupObj.dFilters == null || lookupObj.dFilters == "" ? "1=1" : lookupObj.dFilters;
        filters = filters + " and " + dFilters;
        var tables = [];
        $.ajax(
        {
            url: "/Mobile/Handler/MobileHandler.ashx",
            async: false,
            cache: false,
            type: "post",
            data: { otype: "GetLookUpData", lookUpName: lookupObj.lookUpName, rows: rowCount, PageSize: pageSize, filters: filters },
            success: function (resText) {
                var resObj = JSON2.parse(resText);
                if (resObj.success == true) {
                    tables = resObj.tables;
                }
                else {
                    $.messager.alert("获取lookup数据时出错", resObj.message);
                }

            },
            error: function (resText) {
                $.messager.alert("获取lookup数据时出错", resObj.message);
            }
        });
        return tables;
    },
    reset: function () {
        if (lookUpMobile.current) {
            var lookupObj = lookUpMobile.getLookUpObjByCurrent();
            lookupObj.dFilters = "";
            lookupObj.total = 0;
            lookupObj.rowCount = 0;
            $("#divLookUpResultList").datalist("loadData", []);
        }
    },
    showCondition: function () {
        $("#ulLookUpSearch").html("");
        $.parser.parse("#ulLookUpSearch");
        var lookupObj = lookUpMobile.getLookUpObjByCurrent();
        $.ajax(
            {
                url: "/Mobile/Handler/MobileHandler.ashx",
                async: false,
                cache: false,
                type: "post",
                data: { otype: "GetLookUpCondition", lookUpName: lookupObj.lookUpName },
                success: function (resText) {
                    var resObj = JSON2.parse(resText);
                    if (resObj.success == true) {
                        var data = resObj.tables[0];
                        var lookupObj = lookUpMobile.getLookUpObjByCurrent();
                        lookupObj.searchConditions = data;
                        var GetInput = function (type, fieldid) {
                            type = type == undefined || type == null || type == "" ? "string" : type;
                            var html = "";
                            switch (type) {
                                case "string":
                                    {
                                        html = "<input name=\"" + fieldid + "\" type=\"text\" class=\"easyui-textbox\" data-options=\"width:120\" />";
                                    } break;
                                case "number":
                                    {
                                        html = "<input name=\"" + fieldid + "\" type=\"text\" class=\"easyui-numberbox\" data-options=\"width:120\" />";
                                    } break;
                                case "date":
                                    {
                                        html = "<input name=\"" + fieldid + "\" type=\"text\" class=\"easyui-datebox\" data-options=\"width:120\" />";
                                    } break;
                                case "datetime":
                                    {
                                        html = "<input name=\"" + fieldid + "\" type=\"text\" class=\"easyui-datetimebox\" data-options=\"width:120\" />";
                                    } break;
                                case "bool":
                                    {
                                        html = "<input name=\"" + fieldid + "\" type=\"text\" class=\"easyui-switchbutton\" />";
                                    } break;
                            }
                            return html;
                        }
                        var htmlLi = "";
                        for (var i = 0; i < data.length; i++) {
                            htmlLi += "<li>" + data[i].sDisplayName;
                            htmlLi += "<div class=\"m-right\">";
                            htmlLi += GetInput(data[i].sFieldType, data[i].sFieldName);
                            htmlLi += "</div></li>";
                        }
                        var chtml = $(htmlLi);
                        $("#ulLookUpSearch").append(chtml);
                        $.parser.parse("#ulLookUpSearch");
                        $.mobile.go("#divLookUpSearch", "slide", "up");
                    }
                    else {
                        $.messager.alert("获取查询条件时出错", resObj.message);
                    }
                },
                error: function (resText) {
                    $.messager.alert("获取查询条件时出错", resObj.message);
                }
            }
        )
    },
    search: function () {
        var formDataArr = $("#formLookUpCondition").serializeArray();
        var filters = "1=1";
        var lookupObj = lookUpMobile.getLookUpObjByCurrent();
        var searchCondtions = lookupObj.searchConditions;
        for (var i = 0; i < searchCondtions.length; i++) {
            if (formDataArr[i].value != null && formDataArr[i].value != undefined && formDataArr[i].value != "") {
                var op = searchCondtions[i].sComOprt;
                op = op == "" || op == null || op == undefined ? "like" : op;
                var value = op == "like" ? "'%" + formDataArr[i].value + "%'" : "'" + formDataArr[i].value + "'";
                filters += " and " + formDataArr[i].name + " " + op + " " + value;
            }
        }
        //lookupObj.lookUpFilters = lookupObj.lookUpFilters == "" ? filters : lookupObj.lookUpFilters + " and " + filters;
        lookupObj.dFilters = filters;
        lookupObj.total = 0;
        lookupObj.rowCount = 0;
        $("#divLookUpResultList").datalist("loadData", []);
        var tables = lookUpMobile.getLookUpData();
        if (tables.length > 0) {
            var totalOld = 0;
            var rowCountOld = 0;
            var dataAll = tables[0];
            var total = tables[1][0].Column1;
            lookupObj.total = total;
            //var dataNow = $("#divLookUpResultList").datalist("getRows");
            lookupObj.rowCount = dataAll.length;
            //var options = $("#divLookUpResultList").datalist("options");
            $("#divLookUpResultList").datalist("loadData", dataAll);
            dataNow = data = null;
            if (total > lookupObj.rowCount) {
                $("#divLookUpResultList").datalist("appendRow", {});
            }
            $.mobile.back();
        }
    },
    conditionClear: function () {
        $("#formLookUpCondition").form("clear");
    },
    IsConditionFit: undefined,
    //执行条件是否满足，参数uniqueid
    IsConditionFit: undefined,
    //打开前执行，参数为uniqueid
    beforeOpen: undefined,
    //设置数据之前执行,参数为uniqueid,data
    beforeSetValue: undefined,
    //选择后执行，参数为uniqueid,data
    afterSelected: undefined
}

//function GetFormData(formID) {
//    var data = {};
//    var allNamedElement = $("#" + formID + " [name]");
//    for (var i = 0; i < allNamedElement.length; i++) {
//        data[($(allNamedElement[i]).attr("name"))] = $(allNamedElement[i]).val();
//    }
//    return data;
//}
$.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};  