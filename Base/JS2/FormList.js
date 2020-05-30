var PK = "";
var tablename = "";
var childTablename = "";
var imageFieldArr = [];
var isQuery = false;
var isEditting = false;
var isModify = false;
var dynConditionData = [];
var dynField = "";
var isMultiColumn = false;
var originalDataGridColumns;
//var conditionRowCount = 0;
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
$(function () {
    $("#divlogin").window("close");
    var multi = getQueryString("multi");
    var filters = getQueryString("filters");
    var popup = getQueryString("popup");
    var returnFn = getQueryString("returnFn");
    var FormID = getQueryString("FormID");
    //var filters = getQueryString(filters);
    if (filters == null || filters == "") {
        filters = "1=1";
    }
    $.ajax(
            {
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                url: "/Base/Handler/FormListHandler.ashx",
                data: { otype: "FormListInit", multi: multi, filters: filters, popup: popup, FormID: FormID, returnFn: returnFn },
                async: true,
                cache: false,
                success: function (data, status) {
                    try {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            eval(resultObj.message);
                            lookUp.initFrame();
                            lookUp.initHead();
                            if (isModify) {
                                lookUp.initBody();
                            }
                        }
                        else {
                            MessageShow("", resultObj.message);
                            $("#panel").layout("remove", "north");
                            $("#panel").layout("remove", "west");
                            $("#panel").layout("remove", "center");
                        }
                    }
                    catch (e) {
                        MessageShow("解析时发生错误", e.message);
                    }

                },
                error: function () {
                    MessageShow("错误", "访问服务器时发生错误");
                }
            }
            );

});

var FormList = {
    IsPrintShow: false,
    BtnSave: function () {
        if (datagridOp.currentRowIndex != undefined) {
            $("#dg").datagrid("endEdit", datagridOp.currentRowIndex);
        }
        if (FormList.BeforeSave) {
            if (FormList.BeforeSave() == false) {
                return false;
            }
        }
        var rows = $("#dg").datagrid("getRows");
        //只发送可编辑的数据到后台
        var columns = $("#dg").datagrid('getColumnFields', true).concat($("#dg").datagrid('getColumnFields'));
        for (var i = 0; i < columns.length; i++) {
            var columnOption = $("#dg").datagrid("getColumnOption", columns[i]);
            if (columnOption.editor == undefined && columnOption.field != PK) {
                for (var j = 0; j < rows.length; j++) {
                    delete rows[j][(columns[i])];
                }
            }
        }
        $.ajax({
            url: "/Base/Handler/FormListHandler.ashx",
            data: { otype: "FormListSave", rowsData: JSON2.stringify(rows), formid: getQueryString("FormID") },
            cache: false,
            async: false,
            type: "POST",
            success: function (data) {
                var resultObj = JSON2.parse(data);
                if (resultObj.success == true) {
                    MessageShow("保存成功", "保存成功！");
                    $('.easyui-linkbutton').each(function (i) {
                        if ($('.easyui-linkbutton')[i].id != 'btnEdit' && $('.easyui-linkbutton')[i].id != 'btnSave') {
                            $($('.easyui-linkbutton')[i]).linkbutton('enable');
                        }
                    })
                    $('#btnEdit').linkbutton({ text: '修改' });
                    isEditting = false;
                    FormList.Refresh("1=1");
                }
            },
            error: function (data) {
                MessageShow("保存时错误", "保存时发生错误");
            }
        });
    },
    BtnAdd: undefined,
    BtnEdit: undefined,
    BtnRemove: undefined,
    BtnQuery: undefined,
    BtnRefresh: undefined,
    BtnPrint: undefined,
    BtnSubmit: undefined,
    BtnSubmitCancel: undefined,
    BtnExport: undefined,
    BtnExit: function () {
        try {
            parent.closeTab();
        }
        catch (e) {
            window.close();
        }
    },
    BtnSearch: function () {
        var filters = "1=1";
        var formData = $("#form1").form("getData", true);
        for (var key in formData) {
            if (formData[key] != undefined && formData[key] != "") {
                var element = $("[FieldID='" + key + "']");
                var conditionID = $(element[0]).attr("conditionID");
                if (conditionID == undefined) {
                    var comOprt = $(element[0]).attr("ComOprt");
                    if (comOprt == undefined) {
                        comOprt = "=";
                    }
                    if (comOprt.toLowerCase() == "like") {
                        filters += " and " + key + " " + comOprt + " " + "'%" + formData[key] + "%'";
                    }
                    else {

                        filters += " and " + key + " " + comOprt + " " + "'" + formData[key] + "'";
                    }
                }
            }
        }
        //filters = filters.replace(/%/g, "%25");
        FormList.Refresh(filters);
    },
    BtnSelect: function () {
        var selectedRows;
        if (getQueryString("multi") == "1") {
            selectedRows = $("#dg").datagrid("getChecked");
        }
        else {
            selectedRows = $("#dg").datagrid("getSelections");
        }
        if (selectedRows.length > 0) {
            if (window.opener) {
                var fnStr = FormList.ReturnFn + "(" + JSON2.stringify(selectedRows) + ")"
                eval(fnStr);
            }
            window.close();
        }
        else {
            MessageShow("未选择数据", "亲，您未选择任务数据！");
        }

    },
    ReturnFn: undefined,
    GetSelectedKeys: function () {
        var keys = "";
        var selectedRows = $("#dg").datagrid("getSelections");
        for (var i = 0; i < selectedRows.length; i++) {
            keys += selectedRows[i][PK] + ",";
        }
        if (keys.length > 0) {
            keys = keys.substr(0, keys.length - 1);
        }
        return keys;
    },
    GetFormListQueryData: function (filters, treefilters) {
        if (filters == undefined || filters == "") {
            filters = "1=1";
        }
        if (treefilters == undefined || treefilters == "") {
            treefilters = "1=1";
        }
        var resultData;
        $.ajax({
            url: "/Base/Handler/FormListHandler.ashx",
            data: { otype: "GetFormListData", isChild: "0", iformid: getQueryString("FormID"), filters: filters, treefilters: treefilters },
            async: false,
            cache: false,
            success: function (data, status) {
                try {
                    resultData = JSON2.parse(data);
                }
                catch (e) {
                    MessageShow("发生错误", e.message);
                }

            },
            error: function () {
                MessageShow("错误", "访问服务器时发生错误");
            }
        });
        if (resultData) {
            return resultData;
        }
    },
    GetImage: function (iformid, tablename, irecno, imageid) {
        $.ajax({
            url: "/Base/imageUpload/imagesShow.aspx",
            data: { otype: "getListImageN", iformid: iformid, tablename: tablename, irecno: irecno, imageid: imageid },
            async: true,
            cache: false,
            success: function (data) {
                result = data;
                if (data != "") {
                    var img = $(data);
                    var source = $(img).attr("source");
                    imageFieldArr.push(source);
                    $("#" + source).append(img);
                    $("#" + source).tooltip(
                            {
                                content: function () {
                                    var t = $(this);
                                    var img = $(t).children("img")[0];
                                    var src = $(img).attr("src");
                                    var alt = $(img).attr("alt");
                                    return $("<div><img src='" + src + "' alt='" + alt + "' style='width:250px; height:250px;'></div>");
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
            },
            error: function (data) {
                MessageShow("获取图片时发生错误", data);
            }
        });
    },
    ExecProcedure: function (procedureName, iformid, keys, userid, btnid) {
        var sqlObj = {
            StoreProName: "SpGetIden",
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
                    },
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
    Refresh: function (filters) {
        if (filters == undefined || filters == "") {
            filters = "1=1";
        }

        if (isQuery == true) {
            var data = FormList.GetFormListQueryData(filters);
            $("#dg").datagrid("loadData", data);
        }
        else {
            var queryParam = $("#dg").datagrid("options").queryParams;
            queryParam.filters = filters;
            if (queryParam.treefilters) {
                queryParam.treefilters = "1=1";
            }
            $("#dg").datagrid("load", queryParam);
        }
    },
    OpenWindow: function (url, iWidth, iHeight) {
        var islogin = FormList.IsLogin();
        if (islogin) {
            iWidth = iWidth.indexOf("px") > -1 ? iWidth.substr(0, iWidth.length - 2) : iWidth;
            iHeight = iHeight.indexOf("px") > -1 ? iHeight.substr(0, iHeight.length - 2) : iHeight;
            var iTop = (window.screen.availHeight - 30 - iHeight) / 2;
            var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
            var win = window.open(url, "", "width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
        }
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
    AddPrintRow: function (pbname, irecno) {
        var tab = document.getElementById("tabPrint");
        var tr = $("<tr></tr>");
        $(tab).append(tr)
        $(tr).append("<td>" + pbname + "</td>");
        $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'print')>直接打印</a></td>");
        $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'show')>预览</a></td>");
        $(tr).append("<td><a href='#' onclick=FormList.PrintClick(this," + irecno + ",'design')>设计</a></td>");
    },
    PrintClick: function (obj, irecno, otype) {
        var selectedkey = FormList.GetSelectedKeys();
        if (selectedkey.length == 0) {
            MessageShow('未选择数据', '未选择任务行！');
            obj.href = "#";
            obj.target = "";
            return;
        }
        else {
            if (selectedkey.indexOf(',') > -1) {
                MessageShow("一次只能打印一条", "一次只能打印一条记录！");
                obj.href = "#";
                obj.target = "";
                return;
            }
            else {
                obj.target = "ifrpb";
                obj.href = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + getQueryString("FormID") + "&irecno=" + irecno + "&key=" + FormList.GetSelectedKeys();
            }
        }
    },
    Export: function () {
        var filterstr = "1=1";
        var options = $("#dg").datagrid("options");
        if (options.queryParams.filters) {
            filterstr += " and " + options.queryParams.filters;
        }
        //filterstr = filterstr.replace(/%/g, "%25");
        document.getElementById("ifrpb").src = "/Base/ExcelExport.aspx?formid=" + getQueryString("FormID") + "&filterstr=" + encodeURI(filterstr) + "&random=" + Math.random();
    },
    AddAssociatedRow: function (id, formid, aname, parmvalue, filepath) {
        var tab = document.getElementById("tabAssociated");
        var tr = $("<tr></tr>");
        $(tab).append(tr);
        $(tr).append("<td><a href='#'; onclick=FormList.AssociatedClick('" + id + "','" + formid + "','" + aname + "',\"" + encodeURIComponent(parmvalue) + "\",'" + filepath + "')>" + aname + "</a></td>");
    },
    AssociatedClick: function (id, formid, name, parmvalue, filepath) {
        var selectedRow = $("#dg").datagrid("getSelections");
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
        parent.turntoTab(id, formid, name, parmvalue, filepath);
    },
    ShowFj: function (iformid, tablename, obj) {
        var irecno = obj.id;
        $("#divFj").css("display", "");
        $("#ifrFj").attr("src", "/Base/FileUpload/FileUpload.aspx?usetype=view&iformid=" + iformid + "&tablename=" + tablename + "&irecno=" + irecno + "&random=" + Math.random());
        $("#divFj").window(
                    {
                        width: 400,
                        height: 250,
                        minimizable: false,
                        maximizable: false,
                        collapsible: false,
                        modal: true,
                        top: 100,
                        title: "附件列表"
                    });
    },
    BeforeSave: undefined,
    BeforeEdit: undefined,
    DynCdnSelect: function (record) {
        var rowspan = 1;
        if (isMultiColumn == true) {
            rowspan = 2;
        }
        var options = $("#dg").datagrid("options");
        options.columns = DeepCopy(originalDataGridColumns);
        //options.columns = originalDataGridColumns.concat();
        var queryParm = options.queryParams;
        var conditionGUID = $("#" + this.id).attr("conditionID");
        queryParm.dynCndnValue = record[(dynField)];
        queryParm.conditionGUID = conditionGUID;
        options.queryParams = queryParm;
        var dynColumns = [];
        var hasError = false;
        $.ajax(
                {
                    url: "/Base/Handler/FormListHandler.ashx",
                    data: { otype: "GetDynColumns", formid: getQueryString("FormID"), conditionGUID: $("#" + this.id).attr("conditionID"), conditionValue: record[(dynField)] },
                    async: false,
                    cache: false,
                    type: "POST",
                    success: function (data) {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            dynColumns = resultObj.tables[0];
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
                    }
                }
                );
        if (hasError == false) {
            if (dynColumns.length > 0) {
                var fieldColumn = "";
                for (var o in dynColumns[0]) {
                    fieldColumn = o;
                    break;
                }
                for (var i = 0; i < dynColumns.length; i++) {
                    if (options.columns.length > 0) {
                        options.columns[0].push({
                            field: dynColumns[i][(fieldColumn)],
                            title: dynColumns[i][(fieldColumn)],
                            width: 80,
                            align: 'center',
                            halign: 'center',
                            rowspan: rowspan
                        });
                    }
                }
                $("#dg").datagrid(options);
            }
            else {
                MessageShow("没有对应的动态列！", "没有对应的动态列！");
            }
        }
    }
};
function getAllQueryString() {
    var q = location.search.substr(1);
    var qs = q.split('&');
    var argStr = '';
    if (qs) {
        for (var i = 0; i < qs.length; i++) {
            argStr += qs[i].substring(0, qs[i].indexOf('=')) + '=' + qs[i].substring(qs[i].indexOf('=') + 1) + '&';
        }
    }
    return argStr;
}
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
function MessageShow(title, message) {
    $.messager.show({
        showSpeed: 100,
        title: title,
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
function GridRefresh() {
    FormList.Refresh("1=1");
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