document.write("<script src='/Base/JS2/Form.js?r=1'></script>");
var tdTxbHeight = 25;
var Page = {
    //表单的打开类型：add增加，modify修改，view或空浏览
    usetype: getQueryString("usetype") == null ? "view" : getQueryString("usetype"),
    //表单formid
    iformid: getQueryString("iformid"),
    //表单对应主表tablename
    tablename: undefined,
    //主键标识
    serialTablename: undefined,
    //表单主表主键字段
    fieldkey: undefined,
    //表单主表主键值
    key: undefined,
    //当前用户id
    userid: undefined,
    //当前用户名
    username: undefined,
    //当前用户部门号
    deptid: undefined,
    //当前公司号
    companyid: undefined,
    //系统设置参数
    sysParms: undefined,
    //页面工具栏当前点击的按钮，为了能在重新登录后直接进行操作
    clickedToolBtn: undefined,
    //流程中的子表可编辑字段
    pageProcModifyChildrenFields: [],
    //流程是否是退出的
    isProcBack: false,
    isInited: undefined,
    Rights: undefined,
    //页面初始化前
    beforeInit: undefined,
    //页面属性、控件初始化，包括主表的lookup
    init: function () {
        this.Rights = $("#HidFieldRight").val();
        //var sqlsystext = "select * from SysParam";
        this.tablename = $("#TableName").val();
        this.serialTablename = $("#SerialTableName").val() == "" ? this.tablename : $("#SerialTableName").val();
        this.fieldkey = $("#FieldKey").val();
        this.key = $("#FieldKeyValue").val();
        this.userid = $("#UserID").val();
        this.username = $("#UserName").val();
        this.deptid = $("#DeptID") ? $("#DeptID").val() : "";
        if (this.Rights.indexOf("submit") == -1) {
            $("#__saveAndSubmit").hide();
        }

        try {
            //var sqlObj = {
            //    TableName: "SysParam",
            //    Fields: "*",
            //    SelectAll: "True"
            //};
            //this.sysParms = SqlGetData(sqlObj)[0];
            this.sysParms = JSON2.parse($("#HidSysParam").val())[0];
            //            sqlObj = {
            //                TableName: "bscDataClass",
            //                Fields: "left(sClassID,2) as sClassID",
            //                SelectAll: "True",
            //                Filters: [{
            //                    Field: "stype",
            //                    ComOprt: "=",
            //                    Value: "'depart'"
            //                }
            //            ]
            //            };
            //            this.companyid = SqlGetData(sqlObj).length > 0 ? SqlGetData(sqlObj)[0].sClassID : this.deptid;
            //this.companyid = this.deptid.length > 0 ? this.deptid.substr(0, 2) : "";
            this.companyid = this.deptid.substr(0, 2);
            //sqlObj = {
            //    TableName: "bscDataBillD",
            //    Fields: "count(*) as c",
            //    SelectAll: "True",
            //    Filters: [{
            //        Field: "iformid",
            //        ComOprt: "=",
            //        Value: "'" + this.iformid + "'"
            //    }]
            //};
            //var resultObj = SqlGetData(sqlObj);
            //var countdata = resultObj.length > 0 ? resultObj[0].c : 0;
            var countdata = isNaN(Number($("#HidBscDataBillDCount").val())) ? 0 : Number($("#HidBscDataBillDCount").val());
            if (countdata == 0) {
                $("#__process").hide();
                if (this.Rights.indexOf("submit") > -1) {
                    if (Page.beforeSubmit) {
                    } else {
                        $("#__saveAndSubmit").hide();
                    }
                }
            }

            //主表初始化
            //var parmsMain = "otype=main&iformid=" + this.iformid + "&usetype=" + this.usetype + "&key=" + this.key;
            //var resultMain = callpostback("/Base/Handler/tableExplain.ashx", parmsMain, false, true);
            //if (resultMain.length > 0) {
            //    if (resultMain.indexOf("error:") > -1) {
            //        $.messager.alert("错误", resultMain.substr(6, resultMain.length - 6));
            //        return false;
            //    }
            //    else {
            //        try {
            //            new Function(resultMain)();
            //        }
            //        catch (e) {
            //            $.messager.alert("错误", e.message);
            //            return false;
            //        }
            //    }
            //}
            //else {
            //    $.messager.alert("错误", "主表解析时发生错误！");
            //    return false;
            //}
            var mainExpStr = $("#HidTableMainExplainStr").val();
            if (mainExpStr.length == "") {
                //$.messager.alert("错误", "主表解析时发生错误！");
                //return false;
            } else {
                new Function(mainExpStr)();
            }

            //初始化控件，包括：是否为空，是否为数字，小数位数,日期，时间,只读,可用。普通输入框将被转成textbox
            //lookUp.initFrame();

            //对制单人，审批人，还有制单日期，默认
            var inputUserID = $("input[FieldID='sUserID']");
            if (inputUserID) {
                $.each(inputUserID, function (index, o) {
                    $(o).attr('lookupoptions', '[{lookupName:"bscDataperson2",fixFilters:"1=1",isMulti:false,editable:true,fields:"*",searchFields:"*",targetID:"' + o.id + '"}]');
                });
            }

            var inputCheckUserID = $("input[FieldID='sCheckUserID']");
            if (inputCheckUserID) {
                $.each(inputCheckUserID, function (index, o) {
                    $(o).attr('lookupoptions', '[{lookupName:"bscDataperson2",fixFilters:"1=1",isMulti:false,editable:true,fields:"*",searchFields:"*",targetID:"' + o.id + '"}]');
                });
            }
            var inputDate = $("input[FieldID='dInputDate']");
            if (inputDate) {
                $.each(inputDate, function (index, o) {
                    $(o).val(Page.getNowDate() + " " + Page.getNowTime());
                });
            }

            lookUp.initHead();
            $("textarea[FieldID]").addClass("textarea");
            $("textarea[readonly='readonly']").addClass("txareadonly");
            //var textareaArr = $("textarea[FieldID]");
            //for (var i = 0; i < textareaArr.length; i++) {
            //    $(textareaArr[i]).addClass("textarea");
            //}
            dataForm.init();

            //控件公式定义初始化
            var brower = myBrowser();
            var elements = $("[noEasyui='true']");
            for (var i = 0; i < elements.length; i++) {
                if (brower == "IE") {
                    elements[i].attachEvent('onpropertychange', function () {
                        if (Page.FormulaBack) {
                            Page.FormulaBack($(elements[i]).attr("FieldID"));
                        }
                        if (Page.Formula) {
                            Page.Formula($(elements[i]).attr("FieldID"));
                        }
                    });
                }
                else {
                    if (elements[i].tagName.toLowerCase() != "input") {
                        $(elements[i]).bind('input propertychange', function () {
                            if (Page.FormulaBack) {
                                Page.FormulaBack($(elements[i]).attr("FieldID"));
                            }
                            if (Page.Formula) {
                                Page.Formula($(elements[i]).attr("FieldID"));
                            }
                        });
                    }
                    else {
                        var etype = elements[i].type;
                        if (etype.toLowerCase() == "checkbox") {
                            $(elements[i]).bind("change", function () {
                                if (Page.FormulaBack) {
                                    Page.FormulaBack($(elements[i]).attr("FieldID"));
                                }
                                if (Page.Formula) {
                                    Page.Formula($(elements[i]).attr("FieldID"));
                                }
                            });
                        }
                        else {
                            $(elements[i]).bind('input propertychange', function () {
                                if (Page.FormulaBack) {
                                    Page.FormulaBack($(elements[i]).attr("FieldID"));
                                }
                                if (Page.Formula) {
                                    Page.Formula($(elements[i]).attr("FieldID"));
                                }
                            });
                        }
                    }
                }
            }


            var iframeFiles = $("iframe[FileType]");

            if (this.usetype == "add") {
                //$("#__process").hide();
                var tablename = document.getElementById("TableName").value;
                var result = Page.getChildID(Page.serialTablename);
                if (result && result.length > 0 && result != "-1") {
                    $("#FieldKeyValue").val(result);
                    this.key = result;
                }
                else {
                    $.messager.alert("错误", "对不起,获取主键值失败，不可操作！");
                    return;
                }
            }
            else if (this.usetype == "modify") {
                $("#__saveAndContinue").hide();
                $("#FieldKeyValue").val(getQueryString("key"));
                this.key = getQueryString("key");
            }
            else {
                $("#__save").hide();
                $("#__saveAndContinue").hide();
                $("#__saveAndSubmit").hide();
                $("#FieldKeyValue").val(getQueryString("key"));
                this.key = getQueryString("key");

            }
            //附件和图片控件的初始化
            for (var i = 0; i < iframeFiles.length; i++) {
                var sourceFormID = $(iframeFiles[i]).attr("SourceFormID") == "" ? this.iformid : $(iframeFiles[i]).attr("SourceFormID");
                var sourceTableName = $(iframeFiles[i]).attr("SourceTableName") == "" ? this.tablename : $(iframeFiles[i]).attr("SourceTableName");
                var sourceRecNo = $(iframeFiles[i]).attr("SourceRecNo") == "" ? this.key : $(iframeFiles[i]).attr("SourceRecNo");
                var fileSize = $(iframeFiles[i]).attr("FileSize") == "" ? "4" : $(iframeFiles[i]).attr("FileSize");
                var width = $(iframeFiles[i]).attr("ImageWidth");
                var height = $(iframeFiles[i]).attr("ImageHeight");
                if ($(iframeFiles[i]).attr("FileType") == "图片") {
                    var sourceImageID = $(iframeFiles[i]).attr("SourceImageID") == "" ? $(iframeFiles[i]).attr("id") : $(iframeFiles[i]).attr("SourceImageID");
                    $(iframeFiles[i]).attr("src", "/Base/imageUpload/imagesShow.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&imageid=" + sourceImageID + "&width=" + width + "&height=" + height + "&random=" + Math.random());
                }
                else if ($(iframeFiles[i]).attr("FileType") == "附件") {
                    $(iframeFiles[i]).attr("src", "/Base/FileUpload/FileUpload.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&fileType=acc&random=" + Math.random());
                }
                else if ($(iframeFiles[i]).attr("FileType") == "图片列表") {
                    $(iframeFiles[i]).attr("src", "/Base/FileUpload/FileUpload.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&fileType=image&width=" + width + "&height=" + height + "&random=" + Math.random());
                }
                else if ($(iframeFiles[i]).attr("FileType") == "多图片") {
                    $(iframeFiles[i]).attr("src", "/Base/imageUpload/imageMultiShow.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&fileType=image&width=" + width + "&height=" + height + "&random=" + Math.random());
                }
            }
            Page.Children.init();
        }
        catch (e) {
            $.messager.alert("错误", e.message);
            return false;
        }
    },
    //明细页面的加载,在init事件之后，在pageinit之前
    beforeLoad: undefined,
    //页面数据初始化，包括lookup的初始化和lookup的数据初始化，以及datagridOp的初始化
    loading: function () {
        if (this.usetype == "add") {
            Page.setFieldValue("sUserID", Page.userid);
            Page.setFieldValue("dInputDate", Page.getNowDate() + " " + Page.getNowTime());

            for (var key in Page.DefaultValues) {
                Page.setFieldValue(key, Page.DefaultValues[key]);
            }
            setTimeout(function () { Page.comboDataInit(Page.DefaultValues, 0) }, 1000);
            setTimeout(function () { Page.comboDataInit(Page.DefaultValues, 0) }, 1000);
            //如果是复制
            if (getQueryString("copyKey") != null) {
                var copyKey = getQueryString("copyKey");
                $.ajax({
                    url: "/Base/Handler/tableExplain.ashx",
                    type: "post",
                    async: false,
                    cache: false,
                    data: { otype: "getCopyData", copyKey: copyKey, iformid: Page.iformid },
                    success: function (data) {
                        var resultObj = JSON2.parse(data);
                        if (resultObj.success == true) {
                            var tableNames = resultObj.message;
                            var tableNamesArr = tableNames.split(",");
                            var mainData = resultObj.tables[0][0];
                            try {
                                for (var key in mainData) {
                                    if (mainData[key] == null) {
                                        delete mainData[key];
                                    }
                                }
                                $("#form1").form("load", mainData);
                            }
                            catch (e) {

                            }
                            lookUp.load();
                            for (var i = 1; i < tableNamesArr.length; i++) {
                                if (resultObj.tables[i].length > 0) {
                                    var tableNameD = tableNamesArr[i];
                                    var tableD = $("[tablename='" + tableNameD + "']");
                                    if (tableD.length > 0) {
                                        var tableid = $(tableD[0]).attr("id");
                                        for (var j = 0; j < resultObj.tables[i].length; j++) {
                                            Page.tableToolbarClick("add", tableid, resultObj.tables[i][j]);
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            Page.MessageShow("复制失败", "复制失败：" + resultObj.message);
                            return false;
                        }
                    },
                    error: function (data) {
                        Page.MessageShow("复制失败", "复制失败：" + data.responseText);
                        return false;
                    }
                });
            }
            lookUp.initBody();
            datagridOp.init();
        }
        else {
            if (this.usetype == "modify") {
                Page.loadData();
                lookUp.initBody();
                lookUp.load();
                dataForm.load();
                datagridOp.init();
            }
            else {
                Page.loadData();
                lookUp.initBody();
                lookUp.load();
                dataForm.load();
            }
        }
    },
    //加载数据后执行，在dataInit之后
    afterLoad: undefined,
    //当前页面数据
    pageData: undefined,
    //初始值
    DefaultValues: {},
    //加载页面数据
    loadData: function () {
        var jsonfilter = [{
            "Field": this.fieldkey,
            "ComOprt": "=",
            "Value": "'" + this.key + "'"
        }];
        var jsonobj = {
            "TableName": this.tablename,
            "Fields": "*",
            "SelectAll": "True",
            "Filters": jsonfilter
        }
        var data = SqlGetData(jsonobj);
        if (data.length > 0) {
            try {
                //var jsontable = JSON2.parse(jsonstr);
                var jsonobj = data[0];
                for (var key in jsonobj) {
                    if (jsonobj[key] == null || jsonobj[key] == undefined) {
                        delete jsonobj[key];
                    }
                }
                Page.pageData = jsonobj;

                try {
                    $("#form1").form('load', jsonobj);
                }
                catch (e) {
                    for (var key in jsonobj) {
                        Page.setFieldValue(key, jsonobj[key]);
                    }
                }

                //日期数据去除后面的时间部分
                if (getQueryString("usetype") == "view" || getQueryString("usetype") == null || getQueryString("usetype") == "modify") {
                    var inputs_date = $("input[FieldType2='日期']");
                    for (var i = 0; i < inputs_date.length; i++) {
                        var dateStrOr = Page.pageData[($(inputs_date[i]).attr("FieldID"))];
                        if (dateStrOr) {
                            dateStrOr = dateStrOr.replace(/\//g, "-");
                            var indexBlank = dateStrOr.indexOf(" ");
                            dateStrT = indexBlank > -1 ? dateStrOr.substr(0, indexBlank) : dateStrOr;
                            dateStrT = dateStrT.replace("T", " ");
                            if ($(inputs_date[i]).hasClass("txbreadonly")) {
                                try {
                                    $(inputs_date[i]).datebox("setValue", dateStrT);
                                }
                                catch (e) {
                                    $(inputs_date[i]).val(dateStrT);
                                }
                            }
                            else {
                                $(inputs_date[i]).datebox("setValue", dateStrT);
                            }
                        }
                    }
                    var inputs_datetime = $("input[FieldType2='时间']");
                    for (var i = 0; i < inputs_datetime.length; i++) {
                        var datetimeStrOr = Page.pageData[($(inputs_datetime[i]).attr("FieldID"))];
                        if (datetimeStrOr) {
                            datetimeStrOr = datetimeStrOr.replace(/\//g, "-");
                            var indexBlank = datetimeStrOr.indexOf(" ");
                            datetimeStrT = indexBlank > -1 ? datetimeStrOr.substr(0, indexBlank) : datetimeStrOr;
                            datetimeStrT = datetimeStrT.replace("T", " ");
                            if ($(inputs_datetime[i]).hasClass("txbreadonly")) {
                                try {
                                    $(inputs_datetime[i]).datetimebox("setValue", datetimeStrT);
                                }
                                catch (e) {
                                    $(inputs_datetime[i]).val(datetimeStrT);
                                }
                            }
                            else {
                                $(inputs_datetime[i]).datetimebox("setValue", datetimeStrT);
                            }
                            //$(inputs_datetime[i]).datetimebox("setValue", datetimeStrT);
                        }
                    }
                }

                //下拉要延后加载
                setTimeout(function () { Page.comboDataInit(jsonobj, 0) }, 1000);
                setTimeout(function () { Page.comboDataInit(jsonobj, 1) }, 1000);

                //select控件初始化
                var textareas = $("textarea[FieldID]");
                for (var i = 0; i < textareas.length; i++) {
                    $(textareas[i]).val(jsonobj[($(textareas[i]).attr("FieldID"))]);
                }
                var selects = $("select[FieldID]");
                for (var i = 0; i < selects.length; i++) {
                    selects[i].value = jsonobj[($(selects[i]).attr("FieldID"))];
                }
                var inputs = $("input[FieldID]");
                for (var i = 0; i < inputs.length; i++) {
                    if (inputs[i].type == "checkbox") {
                        var value = jsonobj[($(inputs[i]).attr("FieldID"))];
                        inputs[i].checked = value == "1" || value == true ? true : false;
                    }
                }

                //默认小数位数
                var inputs_number = $("input[FieldType2='数值']");
                if (inputs_number.length > 0) {
                    var sqlobj1 = {
                        TableName: "SysParam",
                        Fields: "iDigit",
                        SelectAll: "True"
                    }
                    var data1 = SqlGetData(sqlobj1);
                    if (parseInt(data1[0].iDigit) >= 0) {
                        for (var i = 0; i < inputs_number.length; i++) {
                            if ($(inputs_number[i]).numberbox("options").precision == 0) {
                                $(inputs_number[i]).numberbox({ precision: data1[0].iDigit });
                            }
                        }
                    }
                }
            }
            catch (e) {
                $.messager.alert("错误", e.message + "; 页面数据初始化失败");
            }
        }
        else {
            $.messager.alert("错误", "表单数据已不存在！", "error", function () {
                if (getQueryString("from") == "proc") {
                    top.checkWinClose();
                }
            });
            return false;
        }
    },
    //获取主表字段值
    getFieldValue: function (field) {
        if (field.toUpperCase() == Page.fieldkey.toUpperCase()) {
            return Page.key;
        }
        var c = $("[FieldID='" + field + "']")[0];
        //var c = $(":contains(\"FieldID='" + field + "'\")");
        var value = "";
        if (c) {
            var tagName = c.tagName;
            switch (tagName) {
                case "TEXTAREA":
                    {
                        value = c.value;
                    } break;
                case "INPUT":
                    {
                        if (c.type == "text" || c.type == "hidden" || c.type == "password") {
                            //var plugin = c.attributes["plugin"].nodeValue;
                            var plugin = $(c).attr("plugin");
                            if (plugin) {
                                switch (plugin) {
                                    case "textbox":
                                        {
                                            try {
                                                value = $(c).textbox("getValue");
                                            }
                                            catch (e) {
                                                //value = $("#" + c.id).textbox("getValue");
                                                value = $(c).val();
                                            }

                                            if (value != "") {
                                                var lookUpObj = lookUp.getLookUpObjByID(c.id);
                                                if (lookUpObj /*&& lookUpObj.lookupName !== ""*/) {
                                                    value = $("#" + c.id + "_val").val();
                                                }
                                                else {
                                                    var dataFormObj = dataForm.getObjByID(c.id);
                                                    if (dataFormObj) {
                                                        value = $("#" + c.id + "_val").val();
                                                    }
                                                }
                                            }
                                        }; break;
                                    case "numberbox": value = $("#" + c.id).numberbox("getValue"); break;
                                    case "datebox": value = $("#" + c.id).datebox("getValue"); break;
                                    case "datetimebox": value = $("#" + c.id).datetimebox("getValue"); break;
                                    case "combobox":
                                        {
                                            var valueArr = $("#" + c.id).combobox("getValues");
                                            value = valueArr.join(",");
                                            if (value == "") {
                                                value = $("#" + c.id).combobox("getText");
                                            }
                                            return value;
                                        } break;
                                    case "combotree":
                                        {
                                            var valueArr = $("#" + c.id).combotree("getValues");
                                            value = valueArr.join(",");
                                            if (value == "") {
                                                value = $("#" + c.id).combotree("getText");
                                            }
                                            return value;
                                        } break;
                                }
                            }
                            else {
                                value = c.value;
                            }
                        }
                        else if (c.type == "checkbox") {
                            value = c.checked == true ? 1 : 0;
                        }
                    } break;
                case "SELECT":
                    {
                        value = $("#" + c.id).datetimebox("getValue");
                    }
            }
        }
        return value;
    },
    //获取主表字段显示值
    getFieldText: function (field) {
        if (field.toUpperCase() == Page.fieldkey.toUpperCase()) {
            return Page.key;
        }
        var c = $("[FieldID='" + field + "']")[0];
        var value = "";
        if (c) {
            var tagName = c.tagName;
            switch (tagName) {
                case "TEXTAREA":
                    {
                        value = c.value;
                    } break;
                case "INPUT":
                    {
                        if (c.type == "text" || c.type == "hidden" || c.type == "password") {
                            //var c1 = $("[name='" + field + "']")[0];
                            var plugin = $(c).attr("plugin");
                            if (plugin) {
                                switch (plugin) {
                                    case "textbox":
                                        {
                                            if ($("#" + c.id).hasClass("textbox-f")) {
                                                value = $("#" + c.id).textbox("getText");
                                            }
                                        }; break;
                                    case "numberbox": value = $("#" + c.id).numberbox("getValue"); break;
                                    case "datebox": value = $("#" + c.id).datebox("getValue"); break;
                                    case "datetimebox": value = $("#" + c.id).datetimebox("getValue"); break;
                                    case "combobox":
                                        {
                                            value = $("#" + c.id).combobox("getText");
                                        } break;
                                    case "combotree":
                                        {
                                            value = $("#" + c.id).combotree("getText");
                                        } break;
                                }
                            }
                            else {
                                value = c.value;
                            }
                        }
                        else if (c.type == "checkbox") {
                            value = c.checked == true ? 1 : 0;
                        }
                    } break;
                case "SELECT":
                    {
                        value = $("#" + c.id).datetimebox("getValue");
                    }
            }
        }
        return value;
    },
    //设置主表字段值
    setFieldValue: function (field, value) {
        if (field.toUpperCase() == Page.fieldkey.toUpperCase()) {
            Page.key = value;
        }
        var c = $("[FieldID='" + field + "']");
        var valueArr;
        if (typeof (value) == "string") {
            valueArr = value.split(",");
        }
        else {
            valueArr = value != null && value != undefined ? value.toString() : "";
        }
        if (c && c.length > 0) {
            $(c).each(function (index, element) {
                if (c[index].tagName.toLowerCase() == "textarea") {
                    c[index].value = value;
                }
                else if (c[index].tagName.toLowerCase() == "select") {
                    $(c[index]).combobox("setValues", valueArr);
                }
                else if (c[index].tagName.toLowerCase() == "input") {
                    if (c[index].type == "checkbox") {
                        c[index].checked = value == "1" || value == true ? true : false;
                    }
                    else if (c[index].type == "text" || c[index].type == "hidden" || c[index].type == "password") {
                        var plugin = $(c[index]).attr("plugin");
                        if (plugin) {
                            switch (plugin) {
                                case "textbox":
                                    {
                                        try {
                                            $(c[index]).textbox("setValue", value);
                                        }
                                        catch (e) {
                                            $(c[index]).val(value);
                                        }
                                        var lookUpObj = lookUp.getLookUpObjByID(c[index].id);
                                        if (lookUpObj) {
                                            lookUp.setElementValueHead(c[index], value);
                                        }
                                        else {
                                            var dataFormObj = dataForm.getObjByID(c[index].id);
                                            if (dataFormObj) {
                                                dataForm.setElementValue(c[index], value);
                                            }
                                        }
                                    } break;
                                case "numberbox": $(c[index]).numberbox("setValue", value); break;
                                case "datebox": $(c[index]).datebox("setValue", value); break;
                                case "datetimebox": $(c[index]).datetimebox("setValue", value); break;
                                case "combobox": $(c[index]).combobox("setValues", valueArr); break;
                                case "combotree": $(c[index]).combotree("setValues", valueArr); break;
                            }
                        }
                        else {
                            c[index].value = value;
                        }
                    }
                }
            })
        }
    },
    //主表公式事件,参数field
    Formula: undefined,
    //数据集成中定义的公式
    FormulaBack: undefined,
    //定义是否在保存后不关闭页面
    DoNotCloseWinWhenSave: undefined,
    //初始化主表字段值，只能在beforeLoad中使用
    initFieldValue: function (field, value) {
        var c = $("[FieldID='" + field + "']"); C
        if (c && c.length > 0) {
            if (c[0].tagName.toLowerCase() == "textarea") {
                c[0].value = value;
            }
            else if (c[0].tagName.toLowerCase() == "select") {
                c[0].value = value;
            }
            else if (c[0].tagName.toLowerCase() == "input") {
                if (c[0].type == "checkbox") {
                    c[0].checked = value == "1" || value == true ? true : false;
                }
                else if (c[0].type == "text" || c[0].type == "hidden" || c[0].type == "password") {
                    c[0].value = value;
                }
            }
        }
    },
    //解析语句中的其他（非本字段，本字段在onBeforLoad事件中替换）字段（主表）
    parseMainField: function (str, startIndex) {
        str = str.replace(/{userid}/g, Page.userid);
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
                this.parseMainField(str, startIndex + 1);
            }
            var fieldValue = this.getFieldValue(field.replace("m.", ""));
            str = str.replace("#" + field + "#", fieldValue);
        }
        return str;
    },
    //解析语句中其他（非本字段，本字段在lookUp.open中替换）字段（子表）
    parseChildField: function (str, tableid, rowIndex, startIndex) {
        //先解析主表字段，形如{m.sCode}
        str = str.replace(/{userid}/g, Page.userid);
        if (startIndex == undefined || startIndex == null) {
            startIndex = 0;
        }
        while (str.indexOf("#m.") > -1) {
            var index = str.indexOf("#m.");
            var indexME = str.indexOf("#", index + 1);
            var mainField = str.substr(index, indexME - index + 1);
            var field = mainField.replace("m.", "");
            var parseMainField = Page.parseMainField(field);
            str = str.replace(mainField, parseMainField);
            if (str == false) {
                break;
            }
        }
        var dataAll = $("#" + tableid).datagrid("getRows");
        if (rowIndex != undefined && rowIndex < dataAll.length) {
            while (str.indexOf("#", startIndex) > -1) {
                var indexStart = str.indexOf("#", startIndex);
                var indexEnd = str.indexOf("#", indexStart + 1);
                if (indexEnd == -1) {
                    $.messager.alert("错误", "解析子表语句时错误：'#'未成对出现！");
                    return false;
                }
                var field = str.substr(indexStart + 1, indexEnd - indexStart - 1);
                if (field.indexOf("#") > -1) {
                    this.parseChildField(str, tableid, rowIndex, indexStart + 1);
                }
                var fieldValue = dataAll[rowIndex][(field)];
                str = str.replace("#" + field + "#", fieldValue);
            }
        }
        else {
            $.messager.alert("错误", "行号超出行数！");
        }
        return str;
    },
    //获取今天日期：格式2015-01-01
    getNowDate: function () {
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
    },
    //获取当前时时
    getNowTime: function () {
        var nowdate = new Date();
        var hour = nowdate.getHours();      //获取当前小时数(0-23)
        var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
        var second = nowdate.getSeconds();
        return hour + ":" + minute + ":" + second;
    },
    //获取tablename下一个iRecNo
    getChildID: function (tablename) {
        var jsonobj = {
            StoreProName: "SpGetIden",
            StoreParms: [{
                ParmName: "@sTableName",
                Value: tablename
            }]
        }
        var result = SqlStoreProce(jsonobj);
        if (result && result.length > 0 && result != "-1") {
            return result;
        }
        else {
            return "-1";
        }
    },
    //字段公式
    fieldExp: undefined,
    //不自动编号
    DoNotAutoSerial: undefined,
    //保存单据
    formSave: function () {
        var url;
        var parms;
        var async;
        var ispost;
        //var usetype = getQueryString("usetype");
        var usetype = Page.usetype;
        //结束编辑行
        var children = $("table[isson = 'true'][tablename][tablename != '']");
        for (var i = 0; i < children.length; i++) {
            var data = $("#" + children[i].id).datagrid("getRows");
            for (var z = 0; z < data.length; z++) {
                $("#" + children[i].id).datagrid("endEdit", z);
            }
        }
        if (usetype == "add") {
            if (Page.DoNotAutoSerial != true) {
                //有设置单据编号的生成编号
                var sqlObj = {
                    TableName: "bscDataBill",
                    Fields: "sFieldName,sDateType",
                    SelectAll: "True",
                    Filters: [{
                        Field: "iFormID",
                        ComOprt: "=",
                        Value: getQueryString("iformid")
                    }]
                }

                //var sqltext = "select sFieldName from bscDataBill where iFormID=" + getQueryString("iformid");
                //var table = SqlGetDataComm(sqltext);
                var table = SqlGetData(sqlObj);
                if (table && table.length > 0 && table[0].sFieldName != null && table[0].sFieldName.length > 0 && table[0].sDateType != null && table[0].sDateType != undefined && table[0].sDateType != '' && table[0].sDateType.length > 0) {
                    var sfiledname = table[0].sFieldName;
                    var sDataType = table[0].sDateType;

                    var sqlStoreObj = {
                        StoreProName: "Yww_FormBillNoBulid",
                        StoreParms: [{
                            ParmName: "@formid",
                            Value: getQueryString("iformid")
                        }
                        ]
                    };
                    //var result = SqlExecStore("Yww_FormBillNoBulid", getQueryString("iformid"), false);
                    var result = SqlStoreProce(sqlStoreObj);
                    if (result.length > 0) {
                        var c = $("[FieldID=" + sfiledname + "]")[0];
                        try {
                            $(c).textbox("setValue", result);
                        }
                        catch (e) {
                            $(c).val(result);
                        }
                    }
                }
            }
            if (Page.beforeSave != undefined) {
                var bresult = Page.beforeSave();
                if (bresult == false) {
                    return false;
                }
                if (Page.onBeforeSave) {
                    var rreuslt = Page.onBeforeSave();
                    if (rreuslt == false) {
                        return false;
                    }
                }
            }
            Page.summaryCheck();
            var checkerror = Page.formValidate();
            if (checkerror == false) {
                Page.MessageShow("存在必填项未录入", "存在必填项未录入");
                return false;
            }

            var result = Form.__add("/Base/Handler/DataOperatorNew.ashx?otype=1");
            if (result.indexOf("error") > -1) {
                $.messager.alert("错误", result);
                return false;
            }
            if (Page.afterSave != undefined) {
                var fresult = Page.afterSave();
                if (fresult == false) {
                    return false;
                }
            }
            if (Page.onAfterSave) {
                var rreuslt = Page.onAfterSave();
                if (rreuslt == false) {
                    return false;
                }
            }
            return true;
        }
        else if (usetype == "modify") {
            var from = getQueryString("from")
            if (from != "proc") {
                //不走流程的要先判断是否可修改
                var sqlStoreObj = {
                    StoreProName: "SpDeleteOrModify",
                    StoreParms: [{
                        ParmName: "@iformid",
                        Value: getQueryString("iformid")
                    },
                    {
                        ParmName: "@tablename",
                        Value: Page.tablename
                    },
                    {
                        ParmName: "@fieldkey",
                        Value: Page.fieldkey
                    },
                    {
                        ParmName: "@keys",
                        Value: Page.key
                    },
                    {
                        ParmName: "@userid",
                        Value: Page.userid
                    },
                    {
                        ParmName: "@itype",
                        Value: 2
                    }
                    ]
                };
                //var pdresult = SqlExecStore("SpDeleteOrModify", "" + getQueryString("iformid") + ",'" + document.getElementById("TableName").value + "','" + document.getElementById("FieldKey").value + "','" + document.getElementById("FieldKeyValue").value + "','" + document.getElementById("UserID").value + "',2");
                var pdresult = SqlStoreProce(sqlStoreObj);
                if (pdresult != "1") {
                    $.messager.alert("错误", pdresult);
                    return false;
                }
            }
            if (Page.beforeSave != undefined) {
                var bresult = Page.beforeSave();
                if (bresult == false) {
                    return false;
                }
                if (Page.onBeforeSave) {
                    var rreuslt = Page.onBeforeSave();
                    if (rreuslt == false) {
                        return false;
                    }
                }
            }
            Page.summaryCheck();
            var checkerror = Page.formValidate();
            if (checkerror == false) {
                //                $("#spanTip").html("");
                //                $("#spanTip").show();
                //                $("#spanTip").html("存在必填项为空值！");
                //                setTimeout("$('#spanTip').hide()", 2000);
                //                $.messager.show({
                //                    timeout: 2000,
                //                    title: '存在必填项为空值',
                //                    msg: '存在必填项为空值！',
                //                    showType: 'show',
                //                    style: {
                //                        right: '',
                //                        top: document.body.scrollTop + document.documentElement.scrollTop,
                //                        bottom: ''
                //                    }
                //                });
                return false;
            }

            var result = Form.__update(Page.key, "/Base/Handler/DataOperatorNew.ashx?otype=1");
            if (result.indexOf("error") > -1) {
                $.messager.alert("错误", result);
                return false;
            }
            if (Page.afterSave != undefined) {
                var fresult = Page.afterSave();
                if (fresult == false) {
                    return false;
                }
            }
            if (Page.onAfterSave) {
                var rreuslt = Page.onAfterSave();
                if (rreuslt == false) {
                    return false;
                }
            }
            return true;
        }
    },
    summaryCheck: function () {
        //检测主子表合计
        // {TableName:\"" + htmlId + "\",Type:\"min\",Field:\"" + rowsMin[fi]["sFieldName"].ToString() + "\",MainField:\"" + rowsMin[fi]["sMinMainField"].ToString() + "\"},
        var summaryFields = Page.Children.SummaryFields;
        if (Page.Children.HasDynColumns) {
            var tabWithTableName = $("table [tablename]");
            for (var i = 0; i < tabWithTableName[i]; i++) {
                var dynField = Page.Children.GetDynSummryFields(tabWithTableName[i].id);
                summaryFields = summaryFields.concat(dynField);
            }
        }
        if (summaryFields) {
            for (var i = 0; i < summaryFields.length; i++) {
                if (summaryFields[i].Type == "sum" || summaryFields[i].Type == "avg") {
                    var cField = summaryFields[i].Field;
                    var mField = summaryFields[i].MainField;
                    var theAllData = $("#" + summaryFields[i].TableName).datagrid("getRows");
                    var sumTotal = 0;
                    for (var j = 0; j < theAllData.length; j++) {
                        var theValue = isNaN(Number(theAllData[j][(cField)])) ? 0 : Number(theAllData[j][(cField)]);
                        sumTotal += theValue;
                    }
                    if (theAllData.length > 0) {
                        if (summaryFields[i].Type == "avg") {
                            sumTotal = sumTotal / theAllData.length;
                        }
                    }
                    if (summaryFields[i].iDigit != "") {
                        var iDigit = isNaN(Number(summaryFields[i].iDigit)) ? 0 : Number(summaryFields[i].iDigit);
                        sumTotal = sumTotal.toFixed(iDigit);
                    }
                    Page.setFieldValue(mField, sumTotal);
                }
            }
        }
        
    },
    //重新登录
    relogin: function () {
        var userid = document.getElementById("TextUser").value;
        var psd = document.getElementById("TextPsd").value;
        if (userid.length == 0) {
            $.messager.alert("错误", "用户名不能为空！");
            return;
        }
        /*if (psd.length == 0) {
        alert("密码不能为空！");
        }*/
        var url = "/ashx/LoginHandler.ashx";
        var parms = "userid=" + encodeURIComponent(userid) + "&password=" + encodeURIComponent(psd);
        var async = false;
        var ispost = true;
        var result = callpostback(url, parms, async, ispost);
        if (result.indexOf("warn") > -1 || result.indexOf("error") > -1) {
            $.messager.alert("错误", result);
        }
        else {
            $("#divlogin").dialog("close");
            if (Page.clickedToolBtn.id == "__save") {
                var doresult = Page.FormSave();
                if (doresult != true) {
                    $.messager.alert("错误", doresult);
                }
                else {
                    window.returnValue = "1";
                    alert("保存成功！");
                    window.close();
                }
            }
            else if (Page.clickedToolBtn.id == "__saveAndContinue") {
                var doresult = Page.FormSave();
                if (doresult != true) {
                    alert(doresult);
                }
                else {
                    window.returnValue = "1";
                    alert("保存成功！");
                    var reload = document.getElementById("reload");
                    var pagehref = window.location.href;
                    reload.href = pagehref + "&random=" + Math.random();
                    reload.click();
                }
            }
        }
    },
    //列表中有树的并选择节点后，打开表单初始化相应字段
    treeinit: function () {
        var sqlObj = {
            TableName: "bscDataBill",
            Fields: "[iHasTree],[sPfield],[sCfield],[sDfield],[sTreeSql],[sTreeLinkFields]",
            SelectAll: "True",
            Filters: [{
                Field: "iFormID",
                ComOprt: "=",
                Value: getQueryString("iformid")
            }]
        };
        var jsonresult = SqlGetData(sqlObj);
        if (jsonresult && jsonresult.length > 0) {
            if (jsonresult[0].iHasTree == "1") {
                var c = $("[FieldID='" + jsonresult[0].sTreeLinkFields.split("=")[0] + "']")[0];
                if (c) {
                    var treeValue = getQueryString("treeid");
                    if (treeValue) {
                        var plugin = $(c).attr("plugin");
                        if (plugin) {
                            /*var combox = $.ligerui.get(c.id);
                            if (combox != null && combox.type == "ComboBox") {
                            combox.setValue(getQueryString("treeid"));
                            }*/
                            switch (plugin) {
                                case "combobox": $(c).combobox("setValue", getQueryString("treeid")); break;
                                case "combotree": $(c).combotree("setValue", getQueryString("treeid")); break;
                                case "textbox":
                                    {
                                        try {
                                            $(c).textbox("setValue", getQueryString("treeid"));
                                        }
                                        catch (e) {
                                            $(c).val(getQueryString("treeid"));
                                        }
                                    }
                                    break;
                            }
                            /*if (plugin == "combobox" || plugin == "combotree" || plugin == "textbox") {
                            $(c).combobox("setValue", getQueryString("treeid"));
                            }*/
                        }
                        else {
                            if (c.tagName == "INPUT" || c.tagName == "TEXTAREA") {
                                c.value = getQueryString("treeid");
                            }
                            else if (c.tagName == "SELECT") {
                                c.value = getQueryString("treeid");
                            }
                        }
                    }
                }
            }
        }
    },
    //主表必填字段
    MainRequiredFields: undefined,
    //验证表单
    formValidate: function () {
        var result = $("#form1").form("validate");
        if (result) {
            var v = true;
            if (Page.validateNullMain) {
                v = Page.validateNullMain();
            }
            if (v == false) {
                return v;
            }
            var tables = $("table[isson = 'true'][tablename][tablename != '']");
            for (var i = 0; i < tables.length; i++) {
                var dataRows = $(tables[i]).datagrid("getRows");
                for (var j = 0; j < dataRows.length; j++) {
                    if ($(tables[i]).datagrid("validateRow", j) != true) {
                        alert("子表验证不通过！");
                        return false;
                    }
                }
            }
            if (Page.validateNullChild) {
                return Page.validateNullChild();
            }
            return true;
        }
        else {
            return false;
        }
    },
    //表单设置为只读，在浏览、流程时用到
    mainDisabled: function () {
        //主表
        var inputs = $("input[FieldID]");
        var textareas = $("textarea[FieldID]");
        var selects = $("select[FieldID]");
        for (var i = 0; i < inputs.length; i++) {
            var type = $(inputs[i]).attr("type").toLowerCase();
            if (type == "text") {
                var plugin = $(inputs[i]).attr("plugin");
                switch (plugin) {
                    case "textbox":
                        {
                            if ($(inputs[i]).hasClass("textbox-f")) {
                                $(inputs[i]).textbox("disable");
                            }
                            else {
                                $(inputs[i]).attr("disabled", true);
                            }
                        }; break;
                    case "combobox": $(inputs[i]).combobox("disable"); break;
                    case "combotree": $(inputs[i]).combotree("disable"); break;
                    case "numberbox": $(inputs[i]).numberbox("disable"); break;
                        //datebox和datetimebox在设置只读时，用textbox来渲染                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                    case "datebox": $(inputs[i]).textbox("disable"); break;
                    case "datetimebox": $(inputs[i]).textbox("disable"); break;
                        //case "datetimebox": $(inputs[i]).datetimebox({ disabled: true }); break;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                }
            }
            if (type == "checkbox") {
                $(inputs[i]).attr("disabled", true);
            }
        }
        for (var i = 0; i < textareas.length; i++) {
            textareas[i].disabled = true;
        }
        for (var i = 0; i < selects.length; i++) {
            selects[i].disabled = true;
        }

    },
    //子表不可编辑
    childrenDisabled: function () {
        //子表
        var children = $("table[tablename]");
        for (var i = 0; i < children.length; i++) {
            var canEdit = false;
            for (var j = 0; j < Page.pageProcModifyChildrenFields.length; j++) {
                if ($(children[i]).attr("tablename") == Page.pageProcModifyChildrenFields[j].split(".")[0]) {
                    canEdit = true;
                    break;
                }
            }
            if (canEdit == false) {
                $($(children[i]).datagrid("options").toolbar).hide();
            }
        }
        Page.isChildrenDisabled = true;
    },
    isChildrenDisabled: false,
    //设置主表字段不可用
    setFieldDisabled: function (field) {
        var c = $("[FieldID='" + field + "']")[0];
        if (c) {
            switch (c.tagName.toLowerCase()) {
                case "input":
                    {
                        var type = $(c).attr("type").toLowerCase();
                        if (type == "text") {
                            var plugin = $(c).attr("plugin");
                            switch (plugin) {
                                case "textbox":
                                    {
                                        if ($(c).hasClass("textbox-f")) {
                                            $(c).textbox("disable");
                                        }
                                        else {
                                            $(c).attr("disabled", true);
                                        }
                                    }; break;
                                case "combobox": $(c).combobox("disable"); break;
                                case "combotree": $(c).combotree("disable"); break;
                                case "numberbox": $(c).numberbox("disable"); break;
                                case "datebox": $(c).datebox("disable"); break;
                                case "datetimebox": $(c).datetimebox("disable"); break;
                            }
                        }
                        if (type == "checkbox") {
                            $(c).attr("disabled", true);
                        }
                    } break;
                case "textarea": c.disabled = true; break;
                case "select": c.disabled = true; break;
            }
        }
    },
    //设置主表字段可用
    setFieldEnabled: function (field) {
        var c = $("[FieldID='" + field + "']")[0];
        if (c) {
            switch (c.tagName.toLowerCase()) {
                case "input":
                    {
                        var type = $(c).attr("type").toLowerCase();
                        if (type == "text") {
                            var plugin = $(c).attr("plugin");
                            switch (plugin) {
                                case "textbox":
                                    {
                                        if ($(c).hasClass("textbox-f")) {
                                            $(c).textbox("enable");
                                        }
                                        else {
                                            $(c).removeAttr("disabled");
                                        }
                                    }; break;
                                case "combobox": $(c).combobox("enable"); break;
                                case "combotree": $(c).combotree("enable"); break;
                                case "numberbox": $(c).numberbox("enable"); break;
                                case "datebox": $(c).datebox("enable"); break;
                                case "datetimebox": $(c).datetimebox("enable"); break;
                            }
                        }
                        if (type == "checkbox") {
                            $(c).attr("disabled", false);
                        }
                    } break;
                case "textarea": c.disabled = false; break;
                case "select": c.disabled = false; break;
            }
        }
    },
    //图片、附件重载
    fileReload: function (fileid, usetype) {
        usetype = usetype == undefined ? "view" : usetype;
        var file = $("iframe[id='" + fileid + "']");
        var iframe = undefined;
        for (var i = 0; i < file.length; i++) {
            if (file[i].tagName.toLowerCase() == "iframe") {
                iframe = file[i];
            }
        }
        var sourceFormID = $(iframe).attr("SourceFormID") == "" ? Page.iformid : $(iframe).attr("SourceFormID");
        var sourceTableName = $(iframe).attr("SourceTableName") == "" ? Page.tablename : $(iframe).attr("SourceTableName");
        var sourceRecNo = $(iframe).attr("SourceRecNo") == "" ? Page.key : $(iframe).attr("SourceRecNo");
        if ($(iframe).attr("FileType") == "图片") {
            var width = $(iframe).attr("ImageWidth");
            var height = $(iframe).attr("ImageHeight");
            var sourceImageID = $(iframe).attr("SourceImageID") == "" ? $(iframe).attr("id") : $(iframe).attr("SourceImageID");
            $(iframe).attr("src", "/Base/imageUpload/imagesShow.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&usetype=" + usetype + "&imageid=" + sourceImageID + "&width=" + width + "&height=" + height + "&random=" + Math.random());
        }
        else if ($(iframe).attr("FileType") == "附件") {
            $(iframe).attr("src", "/Base/FileUpload/FileUpload.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&usetype=" + usetype + "&fileType=acc&random=" + Math.random());
        }
        else {
            $(iframe).attr("src", "/Base/FileUpload/FileUpload.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&usetype=" + usetype + "&fileType=image&width=" + width + "&height=" + height + "&random=" + Math.random());
        }
    },
    //流程中打开时初始化
    procPageInit: function () {
        var from = getQueryString("from");
        if (from == "proc") {
            $("#__save").hide();
            $("#__saveAndContinue").hide();
            $("#__cancel").hide();
            //var childtablegrid = $("table[tablename]");
            var sqlObj = {
                TableName: "bscDataBillD",
                Fields: "sModifyFields",
                SelectAll: "True",
                Filters: [{
                    Field: "iFormID",
                    ComOprt: "=",
                    Value: getQueryString("iformid"),
                    LinkOprt: "and"
                },
                {
                    Field: "GUID",
                    ComOprt: "=",
                    Value: "'" + getQueryString("ProcGUID") + "'"
                }]
            };
            //var sqlcomm = "select a.sModifyFields from bscDataBillD as a where a.iFormID=" + getQueryString("iformid") + " and a.GUID='" + getQueryString("ProcGUID") + "'";
            //var sqldata = SqlGetDataComm(sqlcomm);
            var sqldata = SqlGetData(sqlObj);
            if (sqldata.length > 0) {
                if (getQueryString("itype") != "1") {//不为1表示，不是退回的节点。需要设置不可编辑字段
                    Page.mainDisabled();

                    var fields = sqldata[0].sModifyFields;
                    if (fields) {
                        var fieldsArr = fields.split(",");
                        var maintablename = document.getElementById("TableName").value;

                        for (var i = 0; i < fieldsArr.length; i++) {

                            if (fieldsArr[i].indexOf(".") > -1) {
                                Page.pageProcModifyChildrenFields.push(fieldsArr[i]);
                                if (fieldsArr[i].split(".")[0].toUpperCase() == maintablename.toUpperCase()) {
                                    Page.setFieldEnabled(fieldsArr[i].split(".")[1]);
                                }
                            }
                            else {
                                Page.setFieldEnabled(fieldsArr[i]);
                            }
                        }
                    }
                    Page.childrenDisabled();
                }
                else {
                    Page.isProcBack = true;
                }
            }
        }
    },
    //获取url传值
    getQueryString: function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    },
    //根据text选中select
    selectItemByText: function (objSelect, objItemText) {
        for (var i = 0; i < objSelect.options.length; i++) {
            if (objSelect.options[i].text == objItemText) {
                objSelect.options[i].selected = true;
                break;
            }
        }
    },
    //工具栏按钮事件
    toolBarClick: function (obj) {
        //debugger;
        Page.clickedToolBtn = obj;
        if (obj.id == "__save" || obj.id == "__saveAndContinue" || obj.id == "__saveAndSubmit") {
            //登录超时，要重新登录
            var resultlogin = callpostback("/ashx/LoginHandler.ashx?otype=islogin", "", false, false);
            if (resultlogin == "0") {
                $("#divlogin").dialog("open");
                $("#btn_relogin").click(Page.relogin);
                /*$("#divlogin").dialog({
                    title: '登录信息丢失，重新登录',
                    width: 260,
                    height: 150,
                    modal: true
                });*/
            }
            else {
                if (obj.id == "__save") {
                    var from = getQueryString("from");
                    if (from == "proc") {//如果是审批，则先看看此单据是否为退回，如果是，则保存数据；否则 获取可修改字段，有可修改字段，则保存数据，没有则不修改
                        var flag = 0;
                        if (getQueryString("itype") == 1) {
                            flag = 1;
                        }
                        else {
                            var sqlObj = {
                                TableName: "bscDataBillD",
                                Fields: "sModifyFields",
                                SelectAll: "True",
                                Filters: [{
                                    Field: "iFormID",
                                    ComOprt: "=",
                                    Value: getQueryString("iformid"),
                                    LinkOprt: "and"
                                },
                            {
                                Field: "GUID",
                                ComOprt: "=",
                                Value: "'" + getQueryString("ProcGUID") + "'"
                            }
                                ]
                            }
                            //var sqlcomm = "select sModifyFields from bscDataBillD where iFormID=" + getQueryString("iformid") + " and GUID='" + getQueryString("ProcGUID") + "'";
                            //var sqldata = SqlGetDataComm(sqlcomm);
                            var sqldata = SqlGetData(sqlObj);
                            if (sqldata.length > 0) {
                                var fields = sqldata[0].sModifyFields;
                                if (fields && fields.length > 0) {
                                    flag = 1;
                                }
                            }
                        }
                        if (flag == 1) {
                            var doresult = Page.formSave();
                            if (doresult == true) {
                                return true;
                            }
                            else {
                                return false;
                            }
                        }
                        else {
                            return true;
                        }
                    }
                    else {
                        var doresult = Page.formSave();
                        if (doresult == true) {
                            alert("保存成功！");
                            if (window.opener) {
                                window.opener.GridRefresh();
                                if (Page.DoNotCloseWinWhenSave != true) {
                                    window.close();
                                }
                                else {
                                    Page.usetype = "modify";
                                }
                            }
                            else if (window.parent && window.parent.FormList) {
                                window.parent.FormList.NeedSelectedKey = Page.key;
                                if (Page.usetype == "add") {
                                    window.parent.FormList.ReloadTheRow(Page.key, true);
                                } else if (Page.usetype == "modify") {
                                    window.parent.FormList.ReloadTheRow(Page.key);
                                }
                                //window.parent.GridRefresh();
                                if (Page.DoNotCloseWinWhenSave != true) {
                                    window.parent.CloseBillWindow();
                                    //window.parent.FormList.SelectRow(Page.key);
                                }
                                else {
                                    Page.usetype = "modify";
                                }
                            } else if (window.parent && window.parent.FormUnionList) {
                                window.parent.FormUnionList.NeedSelectedKey = Page.key;
                                if (Page.usetype == "add") {
                                    window.parent.FormUnionList.ReloadTheRow(Page.iformid, Page.key, true);
                                } else if (Page.usetype == "modify") {
                                    window.parent.FormUnionList.ReloadTheRow(Page.iformid, Page.key);
                                }
                                if (Page.DoNotCloseWinWhenSave != true) {
                                    window.parent.CloseBillWindow();
                                }
                                else {
                                    Page.usetype = "modify";
                                }
                            }
                            else {
                                window.returnValue = "1";
                                if (Page.DoNotCloseWinWhenSave != true) {
                                    window.close();
                                }
                                else {
                                    Page.usetype = "modify";
                                }
                            }
                        }
                        else {
                            return false;
                        }
                    }
                }
                else if (obj.id == "__saveAndContinue") {
                    var doresult = Page.formSave();
                    if (doresult == true) {
                        window.returnValue = "1";
                        alert("保存成功！");
                        if (window.parent.FormList) {
                            //window.parent.GridRefresh();
                            if (Page.usetype == "add") {
                                window.parent.FormList.ReloadTheRow(Page.key, true);
                            } else if (Page.usetype == "modify") {
                                window.parent.FormList.ReloadTheRow(Page.key);
                            }
                        }
                        var reload = document.getElementById("reload");
                        var pagehref = window.location.href;
                        reload.href = pagehref + "&random=" + Math.random();
                        reload.click();
                    }
                    else {
                        return false;
                    }
                }
                else if (obj.id == "__saveAndSubmit") {
                    var doresult = Page.formSave();
                    if (doresult == true) {
                        //提交
                        var submitSuccess = false;
                        var statusobj = approval.formStatus(Page.iformid, Page.key)
                        if ((parseInt(statusobj.iStatus) > 1 && parseInt(statusobj.iStatus) != 99) || parseInt(statusobj.iStatus) == -1) {
                            Page.MessageShow('提交失败', '单据状态：[' + statusobj.sStatusName + ']，不可提交！');
                            Page.usetype = "modify";
                            return false;
                        }
                        else if (parseInt(statusobj.iStatus) == 99) {
                            if (Page.beforeSubmit) {
                                var result = Page.beforeSubmit();
                                if (result != false) {
                                    submitSuccess = true;
                                }
                            } else {
                                alert("未定义提交事件");
                                submitSuccess = true;
                            }
                        }
                        else {
                            if (approval.submit(Page.iformid, Page.key)) {
                                submitSuccess = true;
                            }
                            else {
                                submitSuccess = false;
                            }
                        }
                        if (submitSuccess == false) {
                            Page.usetype = "modify";
                            return false;
                        }
                        alert("保存提交成功！");
                        if (window.opener) {
                            window.opener.GridRefresh();
                            if (Page.DoNotCloseWinWhenSave != true) {
                                window.close();
                            }
                            else {
                                Page.usetype = "modify";
                            }
                        }
                        else if (window.parent && window.parent.FormList) {
                            window.parent.FormList.NeedSelectedKey = Page.key;
                            //window.parent.GridRefresh();
                            if (Page.usetype == "add") {
                                window.parent.FormList.ReloadTheRow(Page.key, true);
                            } else if (Page.usetype == "modify") {
                                window.parent.FormList.ReloadTheRow(Page.key);
                            }
                            if (Page.DoNotCloseWinWhenSave != true) {
                                window.parent.CloseBillWindow();
                            }
                            else {
                                Page.usetype = "modify";
                            }
                        }
                        else {
                            window.returnValue = "1";
                            if (Page.DoNotCloseWinWhenSave != true) {
                                window.close();
                            }
                            else {
                                Page.usetype = "modify";
                            }
                        }
                    }
                    else {
                        return false;
                    }
                }
            }
        }
        else if (obj.id == "__cancel") {
            if (window.parent && (window.parent.FormList || window.parent.FormUnionList)) {
                //window.parent.GridRefresh();
                window.parent.CloseBillWindow();
            }
            else {
                window.close();
            }
        }
        else if (obj.id == "__process") {
            //var key = Page.key;
            //$.ligerDialog.open({ url: "/Base/ProcProgress.aspx?iformid=" + getQueryString("iformid") + "&irecno=" + getQueryString("key"), height: 500, width: 400, isResize: true, title: "查看流程" });
            $("#divProcess").dialog({
                title: '查看流程',
                top: 20,
                //left:100,
                width: 400,
                height: 500,
                closed: true,
                resizable: true,
                //cache: false,
                content: "<iframe style='margin:0;padding:0' id='ifrProcess' name='ifrProcess' width='100%' height='100%' frameborder='0' src='/Base/ProcProgress.aspx?iformid=" + Page.iformid + "&irecno=" + Page.key + "&random=" + Math.random + "'></iframe>"
            });
            $("#divProcess").dialog("open");
        }
    },
    IconCls: function (icon) {
        var iconCls = "";
        switch (icon) {
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
            case "barcode": iconCls = "icon-barcode"; break;
            case "export": iconCls = "icon-export"; break;
            default: iconCls = "icon-default"; break;
        }
        return iconCls
    },
    toolBarBtnAdd: function (id, text, icon, fun) {
        var iconCls = "icon-default";
        if (icon) {
            iconCls = Page.IconCls(icon);
        }
        var newBtn = $("<a id='" + id + "' class='easyui-linkbutton' data-options='iconCls:&#39" + iconCls + "&#39'>" + text + "</a>");
        $(newBtn).bind("click", fun);
        $("#tdTool").append(newBtn);
        $.parser.parse('#tdTool');
    },
    toolBarHide: function () {
        $("#divtool").hide();
        $("#pageBody").layout("remove", "north");
    },
    //在修改和浏览时初始化树，树和下拉框需延迟加载
    comboDataInit: function (jsonData, type) {//type=0表示下拉，1表示树
        if (type == 1) {
            var inputs_tree = $("input[plugin='combotree']");
            for (var i = 0; i < inputs_tree.length; i++) {
                var value = jsonData[($(inputs_tree[i]).attr("FieldID"))];
                var multiple = $(inputs_tree[i]).combotree("options").multiple;
                if (multiple) {
                    if (value != null && value != undefined) {
                        var arrValues = [];
                        if (typeof (value) == "string") {
                            arrValues = value.split(",");
                        }
                        else {
                            arrValues.push(value);
                        }
                        $(inputs_tree[i]).combotree("setValues", arrValues);
                    }
                }
                else {
                    $(inputs_tree[i]).combotree("setValue", value);
                }
            }
        }
        else {
            var inputs_combobox = $("input[plugin='combobox']");
            for (var i = 0; i < inputs_combobox.length; i++) {
                var value = jsonData[($(inputs_combobox[i]).attr("FieldID"))];
                var multiple = $(inputs_combobox[i]).combobox("options").multiple;
                if (multiple) {
                    if (value != null && value != undefined) {
                        var arrValues = [];
                        if (typeof (value) == "string") {
                            arrValues = value.split(",");
                        }
                        else {
                            arrValues.push(value);
                        }
                        $(inputs_combobox[i]).combobox("setValues", arrValues);
                    }
                } else {
                    $(inputs_combobox[i]).combobox("setValue", value);
                }
            }
        }
    },
    //保存前事件
    beforeSave: undefined,
    //保存后事件
    afterSave: undefined,
    //主表验证空值
    validateNullMain: undefined,
    //保存子表验证空值
    validateNullChild: undefined,
    //获取元素第一个子节点
    getFirstChild: function (n) {
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
    },
    //获取元素所有子节点
    getChildNodes: function (obj) {
        var childnodes = new Array();
        var childS = obj.childNodes;
        for (var i = 0; i < childS.length; i++) {
            if (childS[i].nodeType == 1)
                childnodes.push(childS[i]);
        }
        return childnodes;
    },
    NewGuid_S4: function () {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    },
    NewGuid: function () {
        return (this.NewGuid_S4() + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + "-" + this.NewGuid_S4() + this.NewGuid_S4() + this.NewGuid_S4());
    },
    //子表工具条创建
    tableToolbarCreate: function (tableid) {
        var tableToolbar = document.createElement("div"); //
        tableToolbar.setAttribute("id", "toolbar_" + tableid);
        tableToolbar.setAttribute("style", "margin:0px;padding:0px");



        var btnAdd = document.createElement("a");
        btnAdd.setAttribute("id", "btn_" + tableid + "_add");
        btnAdd.setAttribute("href", "javascript:void(0)");
        btnAdd.setAttribute("class", "easyui-linkbutton");
        if (Page.usetype == "add" || Page.usetype == "modify") {
            btnAdd.setAttribute("data-options", "iconCls:'icon-add',plain:'true'");
        }
        else {
            btnAdd.setAttribute("data-options", "iconCls:'icon-add',plain:'true',disabled:true");
        }
        btnAdd.setAttribute("onclick", "Page.tableToolbarClick('add','" + tableid + "')");
        btnAdd.innerHTML = "增加行";
        tableToolbar.appendChild(btnAdd);

        var btnRemove = document.createElement("a");
        btnRemove.setAttribute("id", "btn_" + tableid + "_delete");
        btnRemove.setAttribute("href", "javascript:void(0)");
        btnRemove.setAttribute("class", "easyui-linkbutton");
        if (Page.usetype == "add" || Page.usetype == "modify" || getQueryString("from") == "proc") {
            btnRemove.setAttribute("data-options", "iconCls:'icon-remove',plain:'true'");
        }
        else {
            btnRemove.setAttribute("data-options", "iconCls:'icon-remove',plain:'true',disabled:true");
        }
        btnRemove.setAttribute("onclick", "Page.tableToolbarClick('delete','" + tableid + "')");
        btnRemove.innerHTML = "删除";
        tableToolbar.appendChild(btnRemove);


        var btnRemove = document.createElement("a");
        btnRemove.setAttribute("id", "btn_" + tableid + "_copy");
        btnRemove.setAttribute("href", "javascript:void(0)");
        btnRemove.setAttribute("class", "easyui-linkbutton");
        if (Page.usetype == "add" || Page.usetype == "modify") {
            btnRemove.setAttribute("data-options", "iconCls:'icon-copy',plain:'true'");
        }
        else {
            btnRemove.setAttribute("data-options", "iconCls:'icon-copy',plain:'true',disabled:true");
        }
        btnRemove.setAttribute("onclick", "Page.Children.Copy('" + tableid + "')");
        btnRemove.innerHTML = "复制";
        tableToolbar.appendChild(btnRemove);

        var btnRemove = document.createElement("a");
        btnRemove.setAttribute("id", "btn_" + tableid + "_export");
        btnRemove.setAttribute("href", "javascript:void(0)");
        btnRemove.setAttribute("class", "easyui-linkbutton");
        btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true'");

        var btnRemove = document.createElement("a");
        btnRemove.setAttribute("id", "btn_" + tableid + "_export");
        btnRemove.setAttribute("href", "javascript:void(0)");
        btnRemove.setAttribute("class", "easyui-linkbutton");
        btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true'");

        //        if (Page.usetype != "add") {
        //            btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true'");
        //        }
        //        else {
        //            btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true',disabled:true");
        //        }
        //        if (Page.usetype == "add" || Page.usetype == "modify") {
        //            btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true'");
        //        }
        //        else {
        //            btnRemove.setAttribute("data-options", "iconCls:'icon-export',plain:'true',disabled:true");
        //        }

        btnRemove.setAttribute("onclick", "Page.Children.ExportExcel('" + tableid + "')");
        btnRemove.innerHTML = "导出EXCEL";
        tableToolbar.appendChild(btnRemove);

        if (Page.Rights.indexOf("fcolumnset") > -1) {
            //列定义配置按钮
            var btnColumnSet = document.createElement("a");
            btnColumnSet.setAttribute("id", "btn_" + tableid + "_columnset");
            btnColumnSet.setAttribute("href", "javascript:void(0)");
            btnColumnSet.setAttribute("class", "easyui-linkbutton");
            if (Page.usetype == "add" || Page.usetype == "modify") {
                btnColumnSet.setAttribute("data-options", "iconCls:'icon-config',plain:'true'");
            }
            else {
                btnColumnSet.setAttribute("data-options", "iconCls:'icon-copy',plain:'true',disabled:true");
            }
            btnColumnSet.setAttribute("onclick", "Page.Children.openColumnDefined('" + tableid + "')");
            btnColumnSet.innerHTML = "列配置";
            tableToolbar.appendChild(btnColumnSet);
        }

        var sPbRecNos = "";
        var tableName = $("#" + tableid).attr("tablename");
        $.each(Page.Children.PbRecNos, function (index, o) {
            if (o.TableName == tableName) {
                sPbRecNos = o.PbRecNos;
            }
        });
        if (sPbRecNos != "") {
            //打印按钮
            var sqlObj = {
                TableName: "pbReportData",
                Fields: "*",
                SelectAll: "True",
                Filters: [
                    {
                        Field: "iRecNo",
                        ComOprt: "in",
                        Value: "(" + sPbRecNos + ")"
                    }
                ],
                Sorts: [
                    {
                        SortName: "iSerial",
                        SortOrder: "asc"
                    }
                ]
            }
            var resultPb = SqlGetData(sqlObj);
            if (resultPb.length > 0) {
                var btnPrint = document.createElement("a");
                btnPrint.setAttribute("id", "btn_" + tableid + "_print");
                btnPrint.setAttribute("href", "javascript:void(0)");
                btnPrint.setAttribute("class", "easyui-linkbutton");
                btnPrint.setAttribute("data-options", "iconCls:'icon-print',plain:'true'");
                //btnPrint.setAttribute("onclick", "Page.Children.ExportExcel('" + tableid + "')");

                btnPrint.innerHTML = "打印";
                tableToolbar.appendChild(btnPrint);
                var divTablePrint = '<div id="divPrint' + tableid + '" style="width:350px; height:150px;">' +
                                    '<div id="divPrintAcc' + tableid + '" class="easyui-accordion" data-options="border:false,fit:true" style="display:none;">' +
                                    '</div>' +
                                    '</div>';
                $("body").append(divTablePrint);
                $.parser.parse("#divPrint" + tableid);
                var pbReportArr = [];

                $.each(resultPb, function (index, o) {
                    pbReportArr.push({ iRecNo: o.iRecNo, sPbName: o.sPbName, sReportType: o.sReportType, iDataSourceFromList: o.iDataSourceFromList, sGroup: o.sGroup });
                })
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
                        $("#divPrintAcc" + tableid + "").accordion("add", {
                            title: o,
                            collapsed: (o == "" ? false : true),
                            collapsible: (o == "" ? false : true),
                            selected: (hasNoGroup == true ? (index == 1 ? true : false) : (index == 0 ? true : false)),
                            content: '<table id="tabPrint' + tableid + index + '" class="tabprint"></table>'
                        });
                        $.each(pbReportArr, function (index1, o1) {
                            if ((o1.sGroup == null ? "" : o1.sGroup) == o) {
                                //FormList.AddAccPrintRow("tabPrint" + index, o1.sPbName, o1.iRecNo, o1.sReportType, o1.iDataSourceFromList);
                                var tab = document.getElementById("tabPrint" + tableid + index);
                                var tr = $("<tr></tr>");
                                $(tab).append(tr);
                                $(tr).append("<td>" + o1.sPbName + "</td>");
                                $(tr).append("<td style='width:60px;'><a href='#' onclick=Page.PrintClick('" + tableid + "',this," + o1.iRecNo + ",'print','" + o1.sReportType + "'," + o1.iDataSourceFromList + ")>直接打印</a></td>");
                                $(tr).append("<td style='width:30px;'><a href='#' style='width:50px;' onclick=Page.PrintClick('" + tableid + "',this," + o1.iRecNo + ",'show','" + o1.sReportType + "'," + o1.iDataSourceFromList + ")>预览</a></td>");
                                if (Page.userid.toLowerCase() == "master") {
                                    $(tr).append("<td style='width:30px;'><a href='#' onclick=Page.PrintClick('" + tableid + "',this," + o1.iRecNo + ",'design','" + o1.sReportType + "'," + o1.iDataSourceFromList + ")>设计</a></td>");
                                }
                            }
                        });
                    })
                }
            }
        }
        document.body.appendChild(tableToolbar);
        $.parser.parse("#toolbar_" + tableid);
        if (sPbRecNos != "") {
            $("#btn_" + tableid + "_print").tooltip({
                hideEvent: 'none',
                content: $('#divPrint' + tableid + ''),
                showEvent: 'click', onShow: function () {
                    $('#divPrintAcc' + tableid).show();
                    $('#divPrintAcc' + tableid).accordion({ fit: true, border: false });
                    var t = $(this);
                    t.tooltip('tip').unbind().bind('mouseenter', function () {
                        t.tooltip('show'); t.tooltip('reposition');
                    }).bind('mouseleave', function () {
                        t.tooltip('hide');
                    });
                }
            });
        }
    },
    PrintClick: function (tableid, obj, irecno, otype, reportType, iDataSourceFromList) {
        var selectedkey = "";
        var selectedRows = $("#" + tableid).datagrid("getChecked");
        if (selectedRows.length > 0) {
            $.each(selectedRows, function (index, o) {
                selectedkey += o.iRecNo + ",";
            })
        }
        if (selectedkey != "") {
            selectedkey = selectedkey.substr(0, selectedkey.length - 1);
        }
        else {
            alert("请选择一行！");
            return;
        }
        if (selectedkey.length == 0) {
            Page.MessageShow('未选择数据', '未选择任务行！');
            obj.href = "#";
            obj.target = "";
            return;
        }
        else {
            var fileName = "";
            if (iDataSourceFromList == "1") {
                $.messager.progress({ title: "正在准备打印数据，请稍等..." });
                var data = $("#" + tableid).datagrid("getData");
                var url = '/Base/Handler/DataGridToJson.ashx'; //如果为asp注意修改后缀
                $.ajax({
                    url: url,
                    data: { data: JSON2.stringify(data.rows), title: Page.iformid, pbRecNo: irecno },
                    type: 'POST',
                    dataType: 'text',
                    async: false,
                    success: function (fn) {
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
            obj.target = "ifrImport";

            var url = "";
            if (reportType == "fastreport") {
                url = "/Base/PbPage.aspx?otype=" + otype + "&iformid=" + Page.iformid + "&irecno=" + irecno + "&key=" + selectedkey + "&FormListFileName=" + fileName;
                obj.href = url;
            }
            else if (reportType == "lodop") {
                var title = $(obj).parent().parent().children("td:first-child").html();
                url = "/Base/PbLodop.aspx?otype=" + otype + "&iformid=" + Page.iformid + "&irecno=" + irecno + "&key=" + selectedkey + "&FormListFileName=" + fileName + "&title=" + escape(title);
                if (otype == "design") {
                    window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                }
                else {
                    //window.open(url, '', 'width=' + (window.screen.availWidth - 10) + ',height=' + (window.screen.availHeight - 30) + ',top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=yes,location=no, status=yes');
                    obj.href = url;
                }
            }
        }
    },
    isTabAdd: false,
    //子表工具条引入按钮创建
    tableToolbarImportCreate: function (tableid, btnListOptions, i) {
        //非tab的
        var openWindowFun = function (btnListOptions) {
            //没有分组的
            for (var i = 0; i < btnListOptions.length; i++) {
                if (btnListOptions[i].sStyle == "tab") {
                    continue;
                }
                if (btnListOptions[i].sGroup == "") {
                    var import1 = document.createElement("a");
                    import1.innerHTML = btnListOptions[i].options[0].text;

                    var importClick = function () {
                        var id = this.id;
                        var plugtype = $(this).attr("plugtype");
                        if (plugtype == "dataForm") {
                            dataForm.currentID = id;
                            dataForm.open();
                        }
                        else if (plugtype == "lookUp") {
                            var lookupOjb = lookUp.getObjByID(id);
                            lookUp.current = lookupOjb;
                            lookUp.open();
                        }
                    }

                    import1.setAttribute("class", "easyui-linkbutton");
                    import1.setAttribute("data-options", "iconCls:'icon-import',plain:true");
                    if (btnListOptions[i].options) {
                        if (btnListOptions[i].type == "dataForm") {
                            //import1.setAttribute("dataFormOptions", btnListOptions[i].options);
                            //用name标记是dataForm
                            import1.setAttribute("plugtype", "dataForm");
                            //用id标记是dataForm的唯一符
                            import1.setAttribute("id", btnListOptions[i].options[0].id);
                            //import1.setAttribute("onclick", "aa()");
                            var object = {
                                id: btnListOptions[i].options[0].id,
                                dataFormObjs: btnListOptions[i].options
                            };
                            $(import1).bind('click', importClick);
                            dataForm.createNew(object);
                        }
                        else if (btnListOptions[i].type == "lookUp") {
                            //import1.setAttribute("lookUpOptions", btnListOptions[i].options);
                            //用name标记是dataForm
                            import1.setAttribute("plugtype", "lookUp");
                            //用id标记是dataForm的唯一符
                            import1.setAttribute("id", btnListOptions[i].options[0].targetID);
                            $(import1).bind('click', importClick);
                            //import1.setAttribute("onclick", "aa()");
                            var object = {
                                id: btnListOptions[i].options[0].targetID,
                                options: btnListOptions[i].options
                            };
                            lookUp.createNew(object);
                        }
                    }
                    //document.getElementById("toolbar_" + tableid).appendChild(importDiv);
                    $("#toolbar_" + tableid).append(import1);
                    //importDiv.appendChild(import1);
                }
            }
            //有分组的
            var groupArr = [];
            for (var i = 0; i < btnListOptions.length; i++) {
                if (btnListOptions[i].sGroup != "") {
                    var sGroup = btnListOptions[i].sGroup;
                    if ($.inArray(sGroup, groupArr) > -1) {
                        continue;
                    }
                    groupArr.push(sGroup);
                    var btnImport = document.createElement("a");
                    btnImport.setAttribute("href", "javascript:void(0)");
                    btnImport.setAttribute("class", "easyui-menubutton");
                    btnImport.setAttribute("id", "toolbar_import_" + tableid + "_" + sGroup);
                    btnImport.setAttribute("data-options", "iconCls:'icon-import',plain:'true',menu:'#toolbar_import_div_" + tableid + "_" + sGroup + "'");
                    btnImport.innerHTML = sGroup;
                    document.getElementById("toolbar_" + tableid).appendChild(btnImport);
                    var importDiv = document.createElement("div");
                    importDiv.setAttribute("id", "toolbar_import_div_" + tableid + "_" + sGroup);
                    document.getElementById("toolbar_" + tableid).appendChild(importDiv);
                    for (var j = 0; j < btnListOptions.length; j++) {
                        if (sGroup == btnListOptions[j].sGroup) {
                            var import1 = document.createElement("div");
                            import1.setAttribute("class", "importButton");
                            import1.innerHTML = btnListOptions[j].options[0].text;
                            if (btnListOptions[j].options) {
                                if (btnListOptions[j].type == "dataForm") {
                                    import1.setAttribute("dataFormOptions", btnListOptions[j].options);
                                    //用name标记是dataForm
                                    import1.setAttribute("name", "dataForm");
                                    //用id标记是dataForm的唯一符
                                    import1.setAttribute("id", btnListOptions[j].options[0].id);
                                    //import1.setAttribute("onclick", "aa()");
                                    var object = {
                                        id: btnListOptions[j].options[0].id,
                                        dataFormObjs: btnListOptions[j].options
                                    };
                                    dataForm.createNew(object);
                                }
                                else if (btnListOptions[j].type == "lookUp") {
                                    import1.setAttribute("lookUpOptions", btnListOptions[j].options);
                                    //用name标记是dataForm
                                    import1.setAttribute("name", "lookUp");
                                    //用id标记是dataForm的唯一符
                                    import1.setAttribute("id", btnListOptions[j].options[0].targetID);
                                    //import1.setAttribute("onclick", "aa()");
                                    var object = {
                                        id: btnListOptions[j].options[0].targetID,
                                        options: btnListOptions[j].options
                                    };
                                    lookUp.createNew(object);
                                }
                            }
                            importDiv.appendChild(import1);
                        }
                    }
                    $("#toolbar_import_div_" + tableid + "_" + sGroup).menu({
                        onClick: function (item) {
                            if (item.name == "dataForm") {
                                dataForm.currentID = item.id;
                                dataForm.open();
                            }
                            else if (item.name == "lookUp") {
                                var lookupOjb = lookUp.getObjByID(item.id);
                                lookUp.current = lookupOjb;
                                lookUp.open();
                                //$("#div1").dialog("open");
                            }
                        }
                    });
                }
            }
            $.parser.parse("#toolbar_" + tableid);
        };
        var tabFun = function (btnListOptions) {
            for (var i = 0; i < btnListOptions.length; i++) {
                if (btnListOptions[i].sStyle != "tab") {
                    continue;
                }
                var type = btnListOptions[i].type;
                btnListOptions[i].options[0].isTopImport = 1;
                if (type == "lookUp") {
                    var object = {
                        id: btnListOptions[i].options[0].targetID,
                        options: btnListOptions[i].options
                    };
                    lookUp.createNew(object);
                    var lookupName = btnListOptions[i].options[0].lookupName;
                    var isMulti = btnListOptions[i].options[0].isMulti == true ? 1 : 0;
                    var fields = btnListOptions[i].options[0].fields;
                    var searchFields = btnListOptions[i].options[0].searchFields;
                    var params = "id=" + btnListOptions[i].options[0].targetID + "&lookupname=" + lookupName + "&isMulti=" + isMulti + "&fields=" + fields + "&searchFields=" + searchFields + "&isTopImport=1&tabid=__divTabs&tabWhich=1";
                    var src = "/Base/PopUpPage.aspx?" + params;
                    $("#divTabImport").tabs("add", { border: false, title: btnListOptions[i].options[0].text, content: "<iframe src='" + src + "' style='margin: 0; padding: 0' frameborder='0' width='100%' height='99.5%' />" });
                } else if (type == "dataForm") {
                    var object = {
                        id: btnListOptions[i].options[0].id,
                        dataFormObjs: btnListOptions[i].options
                    };
                    dataForm.createNew(object);
                    var formid = btnListOptions[i].options[0].formid;
                    var menuid = btnListOptions[i].options[0].menuid;
                    var fixFilters = btnListOptions[i].options[0].fixFilters;
                    var nofixFilters = btnListOptions[i].options[0].nofixFilters;
                    var url = "/Base/FormList.aspx?FormID=" + formid + "&MenuID=" + menuid + "&popup=1&returnFn=dataForm.setValue&multi=1&isTopImport=1&dataFormID=" + btnListOptions[i].options[0].id + "&tabid=__divTabs&tabWhich=1";
                    if (fixFilters) {
                        url += "&fixFilters=" + escape(Page.parseMainField(fixFilters));
                    }
                    if (nofixFilters) {
                        url += "&nofixFilters=" + escape(Page.parseMainField(nofixFilters));
                    }
                    $("#divTabImport").tabs("add", { border: false, title: btnListOptions[i].options[0].text, content: "<iframe src='" + url + "' style='margin: 0; padding: 0' frameborder='0' width='100%' height='99.5%' />" });
                }
            }
            if (btnListOptions.length > 0) {
                $("#divTabImport").tabs("select", 0);
            }
        }

        //如果i=0则表示是第一个子表，导入放在上面
        if (i == 0) {
            var hasTabStyle = false;
            if (btnListOptions.length > 0) {
                var tabImport = btnListOptions.filter(function (p) {
                    return p.sStyle == "tab";
                })
                if (tabImport.length > 0) {
                    hasTabStyle = true;
                }
                if (hasTabStyle) {
                    if (Page.isTabAdd == false) {
                        $("#__divTabs").tabs("showHeader");
                        var title = $("#lblTitle").html();
                        var formTab = $("#__divTabs").tabs("getTab", $("#__divTabs").tabs("tabs").length - 1);
                        $("#__divTabs").tabs("update", {
                            tab: formTab, options: { title: title }
                        });
                        $("#__divTabs").tabs("add", {
                            title: '数据转入',
                            index: 0,
                            content: "<div id='divTabImport' class='easyui-tabs' data-options='fit:true,border:false,tabPosition:&quot;left&quot;,headerWidth:100,showHeader:false'></div>"
                        });
                        //$("#bodyContent").layout("add", { region: "north", height: "30%", split: true, content: "<div id=\"divTabImport\" class=\"easyui-tabs\" data-options=\"tabPosition:'left',fit:true,border:false,headerWidth:100,narrow:true\"></div>" });
                        Page.isTabAdd = true;
                    }
                    if (btnListOptions.length > 1) {
                        $("#divTabImport").tabs("showHeader");
                    }
                    if (btnListOptions.length == 1) {
                        var tab = $('#__divTabs').tabs('getTab', 0);
                        $("#__divTabs").tabs("update", {
                            tab: tab, options: {
                                title: btnListOptions[0].options[0].text
                            }
                        });
                    }
                    tabFun(btnListOptions);
                    if (Page.usetype == "modify") {
                        $("#__divTabs").tabs("select", 1);
                    }
                }
                openWindowFun(btnListOptions);
            }
        } else {
            openWindowFun(btnListOptions)
        }
    },
    //子表工具栏事件
    tableToolbarClick: undefined,
    //子表附件、图片
    tableToolFj: function (type, tablename, obj) {
        var irecno = obj.id;
        var divFj;
        var divFjs = $("#divFj");
        if (divFjs.length == 0) {
            var div = document.createElement("div");
            div.setAttribute("style", "display:none;width:500px;height:300px;");
            document.body.appendChild(div);
            divFj = div;
        }
        else {
            divFj = divFjs[0];

        }
        $(divFj).show();

        var usetype = Page.usetype == null ? "view" : Page.usetype;
        if (type == "fj") {
            var fileSize = 4;
            $(divFj).window(
                    {
                        modal: true, minimizable: false, maximizable: false, collapsible: false, title: '附件列表', width: 600, height: 300,
                        content: "<iframe id='ifrFile' name='ifrFile' frameborder='0' width='100%' height='99%' src='/Base/FileUpload/FileUpload.aspx?usetype=" + usetype + "&irecno=" + irecno + "&iformid=" + Page.iformid + "&tablename=" + tablename + "&filesize=" + fileSize + "&fileType=acc&random=" + Math.random() + "'></iframe>"
                    }
                 );
        }
        else if (type == "pic") {
            var imageid = $(obj).attr("imageid");
            $(divFj).window(
                    {
                        modal: true, minimizable: false, maximizable: false, collapsible: false, title: '图片', width: 600, height: 300,
                        content: "<iframe id='ifrFile' name='ifrFile' frameborder='0' width='100%' height='100%' src='/Base/imageUpload/imagesShow.aspx?usetype=" + usetype + "&irecno=" + irecno + "&iformid=" + Page.iformid + "&tablename=" + tablename + "&imageid=" + imageid + "&random=" + Math.random() + "'></iframe>"
                    }
                 );
        }
        else if (type == "multiPic") {
            var iframeFiles = $("iframe[FileType='多图片']");
            if (iframeFiles.length == 0) {
                Page.MessageShow("没有多图片控件", "请放置一个多图片控件");
            }
            else {
                var sourceFormID = $(iframeFiles[0]).attr("SourceFormID") == "" ? this.iformid : $(iframeFiles[0]).attr("SourceFormID");
                var sourceTableName = tablename;
                var sourceRecNo = irecno;
                var fileSize = $(iframeFiles[0]).attr("FileSize") == "" ? "4" : $(iframeFiles[0]).attr("FileSize");
                var width = $(iframeFiles[0]).attr("ImageWidth");
                var height = $(iframeFiles[0]).attr("ImageHeight");
                $(iframeFiles[0]).attr("src", "/Base/imageUpload/imageMultiShow.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&fileType=image&width=" + width + "&height=" + height + "&random=" + Math.random());

            }
        }
    },
    //自增列删除、修改、新增时计算
    autoAddFieldCalc: undefined,
    //获取子表脚数据
    getChildFootData: function (tableid, objArr, dataInit, isInit, appendRow, otype) {
        if (objArr.length == 0) {
            return [];
        }
        var allData = [];
        var data = [];
        if (dataInit) {
            data = dataInit.rows;
        }
        else {
            data = $('#' + tableid).datagrid('getRows');
        }
        //        if (data.length == 0) {
        //            
        //            return [];
        //        }
        //1、求和
        var sumData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].TableName != tableid) {
                continue;
            }
            if (objArr[i].Type == "sum") {
                if (sumData == undefined) {
                    sumData = {};
                }
                var calcResult = 0;
                if (appendRow) {
                    var appendFieldValue = 0;
                    if (otype == "add") {
                        appendFieldValue = isNaN(Number(appendRow[(objArr[i].Field)])) ? 0 : Number(appendRow[(objArr[i].Field)]);
                    }
                    else if (otype == "delete") {
                        $.each(appendRow, function (index, o) {
                            appendFieldValue += isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                        });
                    }
                    var footValue = 0;
                    var footData = $("#" + tableid).datagrid("getFooterRows");
                    if (footData) {
                        $.each(footData, function (index, o) {
                            if (o.__type == "sum") {
                                footValue = isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                            }
                        })
                    }
                    if (otype == "add") {
                        calcResult = footValue + appendFieldValue;
                    }
                    else if (otype == "delete") {
                        calcResult = footValue - appendFieldValue;
                    }
                    if (objArr[i].iDigit != "") {
                        //calcResult = Number(calcResult.toFixed(parseInt(objArr[i].iDigit)));
                        calcResult = calcResult.toFixed(parseInt(objArr[i].iDigit));
                    }
                } else {
                    calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "sum", objArr[i].iDigit);
                    if (objArr[i].iDigit != "") {
                        //calcResult = Number(calcResult.toFixed(parseInt(objArr[i].iDigit)));
                        calcResult = calcResult.toFixed(parseInt(objArr[i].iDigit));
                    }
                }

                sumData[(objArr[i].Field)] = calcResult == 0 ? "" : calcResult;
                if (isInit != true) {
                    if (objArr[i].MainField && objArr[i].MainField != "") {
                        //var precision = 2;
                        //try {
                        //    precision = $("[FieldID='" + objArr[i].MainField + "']").numberbox("options").precision
                        //}
                        //catch (e) {

                        //}
                        //precision = precision == null || precision == undefined || precision == "" ? 2 : precision;
                        //Page.setFieldValue(objArr[i].MainField, parseFloat(calcResult.toFixed(precision)));
                        Page.setFieldValue(objArr[i].MainField, calcResult);
                    }
                }
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
            if (objArr[i].TableName != tableid) {
                continue;
            }
            if (objArr[i].Type == "avg") {
                if (avgData == undefined) {
                    avgData = {};
                }
                var calcResult = 0;
                if (appendRow) {
                    //var appendFieldValue = isNaN(Number(appendRow[(objArr[i].Field)])) ? 0 : Number(appendRow[(objArr[i].Field)]);
                    if (otype == "add") {
                        appendFieldValue = isNaN(Number(appendRow[(objArr[i].Field)])) ? 0 : Number(appendRow[(objArr[i].Field)]);
                    }
                    else if (otype == "delete") {
                        $.each(appendRow, function (index, o) {
                            appendFieldValue += isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                        });
                    }
                    var footValue = 0;
                    var footData = $("#" + tableid).datagrid("getFooterRows");
                    if (footData) {
                        $.each(footData, function (index, o) {
                            if (o.__type == "avg") {
                                footValue = isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                            }
                        })
                    }
                    var rowCount = $("#" + tableid).datagrid("getRows").length;
                    if (otype == "add") {
                        calcResult = (footValue * (rowCount - 1) + appendFieldValue) / rowCount;
                    }
                    else if (otype == "delete") {
                        calcResult = (footValue * (rowCount + appendRow.length) - appendFieldValue) / rowCount;
                    }
                    if (objArr[i].iDigit != "") {
                        calcResult = calcResult.toFixed(parseInt(objArr[i].iDigit));
                    }
                }
                else {
                    calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "avg", objArr[i].iDigit);
                    if (objArr[i].iDigit != "") {
                        //calcResult = Number(calcResult.toFixed(parseInt(objArr[i].iDigit)));
                        calcResult = calcResult.toFixed(parseInt(objArr[i].iDigit));
                    }
                }
                avgData[(objArr[i].Field)] = calcResult == 0 ? "" : calcResult;
                if (isInit != true) {
                    if (objArr[i].MainField && objArr[i].MainField != "") {
                        //var precision = $("[FieldID='" + objArr[i].MainField + "']").attr("precision");
                        //precision = precision == null || precision == undefined || precision == "" ? 2 : precision;
                        //Page.setFieldValue(objArr[i].MainField, parseFloat(calcResult.toFixed(precision)));
                        Page.setFieldValue(objArr[i].MainField, calcResult);
                    }
                }
            }
        }
        if (avgData != undefined) {
            avgData.__isFoot = true;
            avgData.__type = "avg";
            allData.push(avgData);
        }
        //3、求个数
        var countData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].TableName != tableid) {
                continue;
            }
            if (objArr[i].Type == "count") {
                if (countData == undefined) {
                    countData = {};
                }
                var calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "count");
                countData[(objArr[i].Field)] = calcResult == 0 ? "" : calcResult;
                if (isInit != true) {
                    if (objArr[i].MainField && objArr[i].MainField != "") {
                        //var precision = $("[FieldID='" + objArr[i].MainField + "']").attr("precision");
                        //precision = precision == null || precision == undefined || precision == "" ? 2 : precision;
                        Page.setFieldValue(objArr[i].MainField, calcResult);
                    }
                }
            }
        }
        if (countData != undefined) {
            countData.__isFoot = true;
            countData.__type = "count";
            allData.push(countData);
        }
        //4、求最大值
        var maxData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].TableName != tableid) {
                continue;
            }
            if (objArr[i].Type == "max") {
                if (maxData == undefined) {
                    maxData = {};
                }
                var calcResult;
                if (appendRow) {
                    var footValue = 0;
                    var footData = $("#" + tableid).datagrid("getFooterRows");
                    if (footData) {
                        $.each(footData, function (index, o) {
                            if (o.__type == "max") {
                                footValue = isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                            }
                        });
                    }
                    if (otype == "add") {
                        var appendFieldValue = isNaN(Number(appendRow[(objArr[i].Field)])) ? 0 : Number(appendRow[(objArr[i].Field)]);
                        calcResult = appendFieldValue > footValue ? appendFieldValue : footValue;
                        if (objArr[i].iDigit != "") {
                            calcResult = Number(calcResult.toFixed(parseInt(objArr[i].iDigit)));
                        }
                    }
                        //calcResult = appendFieldValue > footValue ? appendFieldValue : footValue;
                    else {
                        calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "max");
                    }
                }
                else {
                    calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "max");
                }
                maxData[(objArr[i].Field)] = calcResult == 0 ? "" : calcResult;
                if (isInit != true) {
                    if (objArr[i].MainField && objArr[i].MainField != "") {
                        //var precision = $("[FieldID='" + objArr[i].MainField + "']").attr("precision");
                        //precision = precision == null || precision == undefined || precision == "" ? 2 : precision;
                        Page.setFieldValue(objArr[i].MainField, calcResult);
                    }
                }
            }
        }
        if (maxData != undefined) {
            maxData.__isFoot = true;
            maxData.__type = "max";
            allData.push(maxData);
        }
        //5、求最小值
        var minData = undefined;
        for (var i = 0; i < objArr.length; i++) {
            if (objArr[i].TableName != tableid) {
                continue;
            }
            if (objArr[i].Type == "min") {
                if (minData == undefined) {
                    minData = {};
                }

                var calcResult;
                if (appendRow) {
                    var appendFieldValue = isNaN(Number(appendRow[(objArr[i].Field)])) ? 0 : Number(appendRow[(objArr[i].Field)]);
                    var footValue = 0;
                    var footData = $("#" + tableid).datagrid("getFooterRows");
                    if (footData) {
                        $.each(footData, function (index, o) {
                            if (o.__type == "min") {
                                footValue = isNaN(Number(o[(objArr[i].Field)])) ? 0 : Number(o[(objArr[i].Field)]);
                            }
                        })
                    }
                    if (otype == "add") {
                        calcResult = appendFieldValue < footValue ? appendFieldValue : footValue;
                        if (objArr[i].iDigit != "") {
                            calcResult = Number(calcResult.toFixed(parseInt(objArr[i].iDigit)));
                        }
                    }
                    else if (otype == "delete") {
                        calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "min");
                    }
                }
                else {
                    calcResult = Page.Children.CalcFootData(data, objArr[i].Field, "min");
                }
                minData[(objArr[i].Field)] = calcResult == 0 ? "" : calcResult;
                if (isInit != true) {
                    if (objArr[i].MainField && objArr[i].MainField != "") {
                        //var precision = $("[FieldID='" + objArr[i].MainField + "']").attr("precision");
                        //precision = precision == null || precision == undefined || precision == "" ? 2 : precision;
                        Page.setFieldValue(objArr[i].MainField, calcResult);
                    }
                }
            }
        }
        if (minData != undefined) {
            minData.__isFoot = true;
            minData.__type = "min";
            allData.push(minData);
        }
        if (Page.isHJShow == false) {
            if (allData.length > 0) {
                var allColumns = $("#" + tableid).datagrid("options").columns;
                var i = 1;
                //var formatter = allColumns[0][i];
                //while (formatter) {
                //    i++;
                //    formatter = allColumns[0][i];
                //}
                var firstColumn = allColumns[0][i].field;
                allData[0][(firstColumn)] = "合计";
                Page.isHJShow = true;
            }
        }
        return allData;
        /*var data = $('#' + tableid).datagrid('getRows');
        var footData = {};
        for (var i = 0; i < sSumFields.split(',').length; i++) {
        footData[(sSumFields.split(',')[i])] = Page.autoAddFieldCalc(data, sSumFields.split(',')[i]);
        }
        return [footData];*/
    },
    isHJShow: false,
    setReadonlyTxbBackColor: function () {
        var all = $("input.txbreadonly");
        for (var i = 0; i < all.length; i++) {
            var FieldType = $(all[i]).attr("FieldType2");
            var plugin = $(all[i]).attr("plugin");
            //var nosave = $(all[i]).attr("NoSave");
            try {
                //if (FieldType != "空" && FieldType != undefined && FieldType != "") {
                switch (plugin) {
                    case "textbox":
                        {
                            $($(all[i]).textbox("textbox")).addClass("txbreadonly");
                        } break;
                    case "numberbox":
                        {
                            $($(all[i]).numberbox("textbox")).addClass("txbreadonly");
                        } break;
                    case "combobox":
                        {
                            $($(all[i]).combobox("textbox")).addClass("txbreadonly");
                        } break;
                    case "combotree":
                        {
                            $($(all[i]).combotree("textbox")).addClass("txbreadonly");
                        } break;
                    case "datebox":
                        {
                            $($(all[i]).datebox("textbox")).addClass("txbreadonly");
                        } break;
                    case "datetimebox":
                        {
                            $($(all[i]).datetimebox("textbox")).addClass("txbreadonly");
                        } break;
                }
                //}
            }
            catch (e) {
                var mess = e.message;
            }
        }

        //$(".easyui-textbox:hidden").parent().hide();
    },

    Children: {
        init: function () {
            //子表初始化
            var tables = $("table[tablename]");
            var tableBackStr = "";
            if (tables.length > 0) {
                if (Page.Children.DoNotHideTabTitle != true) {
                    if (tables.length == 1) {
                        $($(tables[0]).parents(".easyui-tabs")[0]).tabs("hideHeader");
                        //$("#divTableTab").tabs("hideHeader");
                    }
                }

                for (var i = 0; i < tables.length; i++) {
                    if (tables[i].id == "" || tables[i].id == undefined) {
                        tables[i].id = $(tables[i]).attr("tablename") + i.toString();
                    }
                    tableBackStr += tables[i].id + "=" + $(tables[i]).attr("tablename") + ",";
                }
                if (tableBackStr.length > 0) {
                    tableBackStr = tableBackStr.substr(0, tableBackStr.length - 1);
                }
                var parms = "otype=child&iformid=" + Page.iformid + "&usetype=" + Page.usetype + "&tables=" + tableBackStr + "&key=" + Page.key;
                var result = callpostback("/Base/Handler/tableExplain.ashx", parms, false, true);
                if (result.length > 0) {
                    if (result.indexOf("error:") > -1) {
                        $.messager.alert("错误", result.substr(6, result.length - 6));
                        return false;
                    }
                    else {
                        try {
                            //var now = new Date().getTime();
                            //eval(result);
                            new Function(result)();
                            //var now1 = new Date().getTime();
                            //alert("时间为：" + (now1 - now) + "<br/>");
                        }
                        catch (e) {
                            $.messager.alert("错误", e.message);
                            return false;
                        }
                    }
                }
            }

        },
        DoNotHideTabTitle: undefined,
        fit: true,
        //需要汇总的字段
        SummaryFields: undefined,
        onBeforeAddRow: undefined,
        onAfterAddRow: undefined,
        onBeforeDeleteRow: undefined,
        onAfterDeleteRow: undefined,
        onBeforeEdit: undefined,
        onBeginEdit: undefined,
        onEndEdit: undefined,
        onAfterEdit: undefined,
        onClickRow: undefined,
        onDblClickRow: undefined,
        onClickCell: undefined,
        onDblClickCell: undefined,
        onLoadSuccess: undefined,
        btnImport: function (tableid) {
            var tableName = $("#" + tableid).attr("tablename");
            $("#ifrImport").attr("src", "/Base/FileUpload/ImportExcel2.aspx?&iFormID=" + Page.iformid + "&isDetail=1&tableName=" + tableName + "&userParam=" + tableid + "&r=" + Math.random);
            $("#divImport").dialog("open");
        },
        getFieldValue: function (tableid, rowIndex, columnName) {
            var dataRows = $("#" + tableid).datagrid("getRows");
            if (dataRows.length < rowIndex + 1) {
                $.messager.alert("错误", "第" + rowIndex + "行不存在！");
                return undefined;
            }
            return dataRows[rowIndex][(columnName)];
        },
        toolBarBtnDisabled: function (tableid, btnid) {
            var btnfullid = "btn_" + tableid + "_" + btnid;
            $("#" + btnfullid).linkbutton("disable");
        },
        toolBarBtnRemove: function (tableid, btnid) {
            var btnfullid = "btn_" + tableid + "_" + btnid;
            $("#" + btnfullid).remove();
        },
        toolBarBtnEnabled: function (tableid, btnid) {
            var btnfullid = "btn_" + tableid + "_" + btnid;
            $("#" + btnfullid).linkbutton("enable");
        },
        toolBarBtnAdd: function (tableid, btnid, btnText, icon, fun) {
            var toolBar = $("#toolbar_" + tableid);
            var children = $(toolBar).children();
            var last = children[children.length - 1];
            var btnA = document.createElement("a");
            $(btnA).attr("id", "btn_" + tableid + "_" + btnid);
            btnA.innerHTML = btnText;
            btnA.setAttribute("href", "javascript:void(0)");
            btnA.setAttribute("class", "easyui-linkbutton");
            var iconCls = "icon-default";
            if (icon) {
                iconCls = Page.IconCls(icon);
            }
            btnA.setAttribute("data-options", "iconCls:'" + iconCls + "',plain:'true'");
            btnA.onclick = function () {
                fun();
            };
            $(last).after(btnA);
            $.parser.parse("#toolbar_" + tableid);
        },
        CalcFootData: function (data, field, otype, iDigit) {
            var result = 0;
            if (iDigit == undefined || iDigit == null) {
                iDigit = "";
            }
            switch (otype) {
                case "sum":
                    {
                        for (var i = 0; i < data.length; i++) {
                            result += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                        }
                        if (iDigit != "") {
                            var theR = parseFloat(result.toFixed(parseInt(iDigit)));
                            if (theR < 0.0000001)
                                result = 0;
                            //result = isNaN(theR) ? 0 : theR;
                        }
                    } break;
                case "avg":
                    {
                        var total = 0;
                        for (var i = 0; i < data.length; i++) {
                            total += isNaN(parseFloat(data[i][(field)])) ? 0 : parseFloat(data[i][(field)]);
                        }
                        result = total / data.length;
                        if (iDigit != "") {
                            var theR = parseFloat(result.toFixed(parseInt(iDigit)));
                            if (theR < 0.0000001)
                                result = 0;
                        }
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
        hideColumns: [],
        HasDynColumns: false,
        /*{tableName子表表名，columnIndex列序，triggerField主表触发字段，columnMatchField列名对应字段，columnValueMatchField：列值对应字段，tableNameD：对应表名，
        iSummary是否合计，sSummaryFieldM：主表合计字段，sSummaryFieldD：子表合计字段,iWidth:列宽}*/
        DynColumnsDefined: [],
        GetDynColumns: function (tableid) {
            if (Page.Children.DynColumnsDefined && Page.Children.DynColumnsDefined.length > 0) {
                var tableName = $("#" + tableid).attr("tablename");
                for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
                    if (tableName == Page.Children.DynColumnsDefined[i].tableName) {
                        if (Page.Children.DynColumnsDefined[i].columns && Page.Children.DynColumnsDefined[i].columns.length > 0) {
                            var key = "";
                            for (var o in Page.Children.DynColumnsDefined[i].columns[0]) {
                                key = o;
                                break;
                            }
                            var columns = [];
                            for (var j = 0; j < Page.Children.DynColumnsDefined[i].columns.length; j++) {
                                columns.push(Page.Children.DynColumnsDefined[i].columns[j][(key)]);
                            }
                            return columns;
                        }
                        return [];
                    }
                }
            }
            return [];
        },
        OriginalColumns: {},
        NoCopyColumns: [],
        loadedDynTableID: [],
        ShowDynColumns: function (tableName, value) {
            //var flag = 1;
            $.ajax({
                url: "/Base/Handler/tableExplain.ashx",
                type: "post",
                async: false,
                cache: false,
                data: { otype: "getDynColumns", iformid: Page.iformid, tableName: tableName, value: value },
                success: function (data) {
                    var resultObj = JSON2.parse(data);
                    if (resultObj.success == true) {
                        var tableElementArr = $("[tablename='" + tableName + "']");
                        if (tableElementArr.length > 0) {
                            var tableElement = tableElementArr[0];
                            var isMultiColumn = $.inArray(tableElement.id, Page.Children.multiColumnTable) > -1 ? true : false;
                            var options = $(tableElement).datagrid("options");
                            options.columns = DeepCopy(Page.Children.OriginalColumns[(tableName)]);
                            //deepCopy(options.columns, Page.Children.OriginalColumns[(tableName)]);
                            var queryParm = options.queryParams;
                            queryParm.dynCndnValue = value;
                            var isFound = false;
                            for (var i = 0; i < Page.Children.loadedDynTableID.length; i++) {
                                if (Page.Children.loadedDynTableID[i] == tableName) {
                                    //queryParm.__isLoadStop = 1;
                                    delete options.url;
                                    isFound = true;
                                    break;
                                }
                            }

                            var dynColumns = resultObj.tables[0];
                            if (dynColumns.length > 0) {
                                var fieldColumn = "";
                                for (var o in dynColumns[0]) {
                                    fieldColumn = o;
                                    break;
                                }
                                var summaryFieldD = "";
                                var iSummary = "";
                                var iWidth = "50";
                                for (var i = dynColumns.length; i > 0; i--) {
                                    if (options.columns.length > 0) {
                                        //将列放入DynColumnsDefined中
                                        var columnIndex = 0;
                                        for (var j = 0; j < Page.Children.DynColumnsDefined.length; j++) {
                                            if (Page.Children.DynColumnsDefined[j].tableName == tableName) {
                                                Page.Children.DynColumnsDefined[j].columns = dynColumns;
                                                columnIndex = parseInt(Page.Children.DynColumnsDefined[j].columnIndex);
                                                summaryFieldD = Page.Children.DynColumnsDefined[j].sSummaryFieldD;
                                                iSummary = Page.Children.DynColumnsDefined[j].iSummary;
                                                iWidth = Page.Children.DynColumnsDefined[j].iWidth == "" || Page.Children.DynColumnsDefined[j].iWidth == "0" ? "50" : Page.Children.DynColumnsDefined[j].iWidth;
                                                break;
                                            }
                                        }
                                        //var columnIndex = Page.Children.DynColumnsDefined[definedIndex].columnIndex;
                                        if (Page.usetype == "add" || Page.usetype == "modify") {
                                            options.columns[0].splice(columnIndex, 0, {
                                                field: dynColumns[i - 1][(fieldColumn)],
                                                title: dynColumns[i - 1][(fieldColumn)],
                                                rowspan: isMultiColumn ? 2 : 1,
                                                width: iWidth,
                                                align: 'center',
                                                halign: 'center',
                                                editor: { type: "textbox", options: { height: tdTxbHeight } }
                                            });
                                        }
                                        else {
                                            options.columns[0].splice(columnIndex, 0, {
                                                field: dynColumns[i - 1][(fieldColumn)],
                                                title: dynColumns[i - 1][(fieldColumn)],
                                                rowspan: isMultiColumn ? 2 : 1,
                                                width: iWidth,
                                                align: 'center',
                                                halign: 'center'
                                            });
                                        }
                                    }
                                }
                                var originalData;
                                if (Page.usetype == "view") {
                                    //originalData = $(tableElement).datagrid("getData");
                                    $(tableElement).datagrid(options);
                                    if (isFound == false) {
                                        Page.Children.loadedDynTableID.push(tableName);
                                    }
                                }
                                else {
                                    originalData = $(tableElement).datagrid("getRows");
                                    $(tableElement).datagrid(options);
                                    if (isFound == false) {
                                        Page.Children.loadedDynTableID.push(tableName);
                                    }
                                    if (Page.isInited == true) {
                                        $(tableElement).datagrid("loadData", originalData);
                                    }
                                }
                                for (var io = 0; io < Page.Children.hideColumns.length; io++) {
                                    if (Page.Children.hideColumns[io].tableID == tableElement.id) {
                                        $("#" + tableElement.id).datagrid("hideColumn", Page.Children.hideColumns[io].field);
                                    }
                                }
                                if (typeof (lookUp) != "undefined") {
                                    lookUp.initBody();
                                }
                                //                                if (iSummary == "1") {
                                //                                    Page.Children.ReloadDynFooter(tableElement.id);
                                //                                }
                            }
                            else {
                                $.messager.alert("没有对应的动态列！", "没有对应的动态列！");
                            }

                        }
                        flag = 1;
                    }
                    else {
                        $.messager.alert("错误", resultObj.message);
                    }
                    //return flag;
                },
                error: function (data) {
                    $.message.alert("错误", data);
                }
            });
        },
        //动态列编辑后执行，参数tableid, index当前行号, row行数据, changes
        DynFieldAfterEdit: undefined,
        //重新计算除动态列之外的页脚数据
        ReloadFooter: function (tableid) {
            $("#" + tableid).datagrid("reloadFooter", Page.getChildFootData(tableid, Page.Children.SummaryFields));
        },
        GetDynSummryFields: function (tableid) {
            var objArr = [];
            if (Page.Children.DynColumnsDefined && Page.Children.DynColumnsDefined.length > 0) {
                var tableName = $("#" + tableid).attr("tablename");
                for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
                    if (tableName == Page.Children.DynColumnsDefined[i].tableName) {
                        if (Page.Children.DynColumnsDefined[i].columns && Page.Children.DynColumnsDefined[i].columns.length > 0) {
                            var key = "";
                            for (var o in Page.Children.DynColumnsDefined[i].columns[0]) {
                                key = o;
                                break;
                            }
                            for (var j = 0; j < Page.Children.DynColumnsDefined[i].columns.length; j++) {
                                objArr.push({
                                    TableName: tableid,
                                    Type: "sum",
                                    Field: Page.Children.DynColumnsDefined[i].columns[j][(key)]/*,
                                    MainField: Page.Children.DynColumnsDefined[i].sSummaryFieldM == undefined || Page.Children.DynColumnsDefined[i].sSummaryFieldM == null ? "" : Page.Children.DynColumnsDefined[i].sSummaryFieldM*/
                                });
                            }
                        }
                        break;
                    }
                }
            }
            //if (objArr.length > 0) {
            //}
            return objArr;
        },
        //重新计算页脚数据
        ReloadDynFooter: function (tableid, dataInit, isInit, appendRow, otype) {
            var objArr = Page.Children.GetDynSummryFields(tableid);
            //if (Page.Children.DynColumnsDefined && Page.Children.DynColumnsDefined.length > 0) {
            //    var tableName = $("#" + tableid).attr("tablename");
            //    for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
            //        if (tableName == Page.Children.DynColumnsDefined[i].tableName) {
            //            if (Page.Children.DynColumnsDefined[i].columns && Page.Children.DynColumnsDefined[i].columns.length > 0) {
            //                var key = "";
            //                for (var o in Page.Children.DynColumnsDefined[i].columns[0]) {
            //                    key = o;
            //                    break;
            //                }
            //                for (var j = 0; j < Page.Children.DynColumnsDefined[i].columns.length; j++) {
            //                    objArr.push({
            //                        TableName: tableid,
            //                        Type: "sum",
            //                        Field: Page.Children.DynColumnsDefined[i].columns[j][(key)]/*,
            //                        MainField: Page.Children.DynColumnsDefined[i].sSummaryFieldM == undefined || Page.Children.DynColumnsDefined[i].sSummaryFieldM == null ? "" : Page.Children.DynColumnsDefined[i].sSummaryFieldM*/
            //                    });
            //                }
            //            }
            //            break;
            //        }
            //    }
            //}
            if (objArr.length > 0) {
                var footData = Page.getChildFootData(tableid, objArr, dataInit, isInit, appendRow, otype);

                var oldfootData = $("#" + tableid).datagrid("getFooterRows");
                if (oldfootData) {
                    for (var i = 0; i < oldfootData.length; i++) {
                        if (oldfootData[i].__type == "sum") {
                            for (var o in footData[0]) {
                                oldfootData[i][(o)] = footData[0][(o)];
                            }
                        }
                        break;
                    }
                    $("#" + tableid).datagrid("reloadFooter", oldfootData);
                }
                else {
                    $("#" + tableid).datagrid("reloadFooter", footData);
                }
            }
        },
        //手动计算动态列某行的合计字段
        DynFieldRowSummary: function (tableid, index) {
            var tableName = $("#" + tableid).attr("tableName");
            var sumFieldD = "";
            var sumFieldM = "";
            for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
                if (tableName == Page.Children.DynColumnsDefined[i].tableName) {
                    sumFieldD = Page.Children.DynColumnsDefined[i].sSummaryFieldD;
                    sumFieldM = Page.Children.DynColumnsDefined[i].sSummaryFieldM;
                }
            }
            var dynColumn = Page.Children.GetDynColumns(tableid);
            if (dynColumn.length > 0) {
                var iSumQty = 0;
                var row = $("#" + tableid).datagrid("getRows")[index];
                for (var j = 0; j < dynColumn.length; j++) {
                    iSumQty += row[(dynColumn[j])] ? parseInt(row[(dynColumn[j])]) : 0;
                }
                var updateRow = {};
                updateRow[(sumFieldD)] = iSumQty;
                $('#' + tableid).datagrid('updateRow', { index: index, row: updateRow });
                /*if (sumFieldM != "") {
                var oldValue = isNaN(parseInt(Page.getFieldValue(sumFieldM))) ? 0 : parseInt(Page.getFieldValue(sumFieldM));
                var newValue = oldValue + iSumQty;
                Page.setFieldValue(sumFieldM, newValue);
                }*/
            }
        },
        ExportExcel: function (tableid) {
            //            var tablename = $("#" + tableid).attr("tablename");
            //            var dynColumnValue = "";
            //            for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
            //                if (tablename == Page.Children.DynColumnsDefined[i].tableName) {
            //                    dynColumnValue = Page.getFieldValue(Page.Children.DynColumnsDefined[i].triggerField);
            //                    break;
            //                }
            //            }
            //            var url = "/Base/ExcelExport.aspx?otype=childTable&iformid=" + Page.iformid + "&tableName=" + tablename + "&key=" + Page.key + "&formid=" + Page.iformid + "&isChild=1&dynCndnValue=" + dynColumnValue + "&random=" + Math.random();
            //            $("#ifrExprotExcel").attr("src", url);
            $.messager.progress({ title: "正在准备导出数据，请稍等..." });
            //getExcelXML有一个JSON对象的配置，配置项看了下只有title配置，为excel文档的标题
            var data = $('#' + tableid).datagrid('getExcelXml', { title: 'Sheet1' }); //获取datagrid数据对应的excel需要的xml格式的内容
            //用ajax发动到动态页动态写入xls文件中
            var url = '/Base/Handler/DataGridToExcel.ashx'; //如果为asp注意修改后缀
            $.ajax({
                url: url, data: { data: data, title: $("#lblTitle").html() + "明细" }, type: 'POST', dataType: 'text',
                success: function (fn) {
                    //alert('导出excel成功！');
                    $("#ifrExprotExcel").attr("src", fn) //执行下载操作
                    $.messager.progress("close");
                },
                error: function (xhr) {
                    alert('动态页有问题\nstatus：' + xhr.status + '\nresponseText：' + xhr.responseText);
                    $.messager.progress("close");
                }
            });
            return false;
        },
        Copy: function (tableid) {
            var selectedRows = $("#" + tableid).datagrid("getChecked");
            if (selectedRows.length == 0) {
                Page.MessageShow("请选择行", "请选择要复制的数据行！");
                return false;
            }
            for (var i = 0; i < selectedRows.length; i++) {
                var theRow = {};
                deepCopy1(theRow, selectedRows[i]);

                for (var j = 0; j < Page.Children.NoCopyColumns.length; j++) {
                    delete theRow[(Page.Children.NoCopyColumns[j])];
                }
                Page.tableToolbarClick("add", tableid, theRow);
            }
        },
        GetData: function (tablename, dynColumnValue, filters) {
            dynColumnValue = dynColumnValue == undefined ? "" : dynColumnValue;
            filters = filters == undefined ? "" : filters;
            var returndata = [];
            $.ajax({
                url: "/Base/Handler/getDataList2.ashx",
                type: "post",
                async: false,
                cache: false,
                data: { otype: "childTable", iformid: Page.iformid, tableName: tablename, key: Page.key, dynCndnValue: dynColumnValue, filters: filters },
                success: function (data) {
                    try {
                        returndata = JSON2.parse(data);
                    }
                    catch (e) {
                    }
                },
                error: function (data) {
                }
            });
            return returndata;
        },
        PbRecNos: [],
        multiColumnTable: [],
        currentEditRowIndex: undefined,
        MoveUp: function (tableid) {
            var rows = $("#" + tableid).datagrid('getChecked');
            for (var i = 0; i < rows.length; i++) {
                var index = $("#" + tableid).datagrid('getRowIndex', rows[i]);
                $("#" + tableid).datagrid("endEdit", index);
                Page.Children.mysort(index, 'up', tableid);
            }
        },
        //下移
        MoveDown: function (tableid) {
            var rows = $("#" + tableid).datagrid('getChecked');
            for (var i = rows.length - 1; i >= 0; i--) {
                var index = $("#" + tableid).datagrid('getRowIndex', rows[i]);
                $("#" + tableid).datagrid("endEdit", index);
                Page.Children.mysort(index, 'down', tableid);
            }
        },
        mysort: function (index, type, gridname) {
            if ("up" == type) {
                if (index != 0) {
                    var toup = $('#' + gridname).datagrid('getData').rows[index];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    $('#' + gridname).datagrid('getData').rows[index] = todown;
                    $('#' + gridname).datagrid('getData').rows[index - 1] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index - 1);
                    $('#' + gridname).datagrid('checkRow', index - 1);
                    $('#' + gridname).datagrid('uncheckRow', index);
                }
            }
            else if ("down" == type) {
                var rows = $('#' + gridname).datagrid('getRows').length;
                if (index != rows - 1) {
                    var todown = $('#' + gridname).datagrid('getData').rows[index];
                    todown.iShowOrder = parseInt(todown.iShowOrder) + 1;
                    var toup = $('#' + gridname).datagrid('getData').rows[index + 1];
                    toup.iShowOrder = parseInt(toup.iShowOrder) - 1;
                    $('#' + gridname).datagrid('getData').rows[index + 1] = todown;
                    $('#' + gridname).datagrid('getData').rows[index] = toup;
                    $('#' + gridname).datagrid('refreshRow', index);
                    $('#' + gridname).datagrid('refreshRow', index + 1);
                    $('#' + gridname).datagrid('checkRow', index + 1);
                    $('#' + gridname).datagrid('uncheckRow', index);
                }
            }
        },
        openColumnDefined: function (tableid) {
            var tableName = $("#" + tableid).attr("tablename");
            var divColumnDefined = $("#divColumnDefined");
            var columnsData = undefined;
            var iBscDataQueryMRecNo;
            $.ajax({
                url: "/Base/Handler/sysHandler.ashx",
                type: "get",
                async: false,
                cache: false,
                data: { otype: "getChildColumnsDefine", iformid: Page.iformid, tableName: tableName },
                success: function (result) {
                    if (result.success == true) {
                        columnsData = result.tables[0];
                    }
                },
                error: function () {

                }, dataType: "json"
            });
            if (divColumnDefined.length == 0) {
                var divCD = $("<div id='divColumnDefined'><table id='tabColumnDefined'></table></div>");
                $("body").append(divCD);
                $("#divColumnDefined").dialog({
                    title: "列定义设置",
                    width: 800,
                    height: 500,
                    modal: true,
                });
                $("#tabColumnDefined").datagrid({
                    fit: true,
                    border: false,
                    columns: [[
                        { field: "__cb", width: 40, checkbox: true },
                        { field: "iSerial", title: "列序", align: "center", width: 40, editor: { type: "numberspinner", options: { height: tdTxbHeight } } },
                        { field: "sTitle", title: "列名", align: "left", width: 100, editor: { type: "textbox", options: { height: tdTxbHeight } } },
                        {
                            field: "sType", title: "类型", align: "center", width: 70, editor: {
                                type: "combobox", options: {
                                    height: tdTxbHeight,
                                    data: [{ t: "字符" }, { t: "整数" }, { t: "数据" }, { t: "日期" },
                                        { t: "时间" }, { t: "逻辑" }, { t: "备注" }, { t: "图片" }, { t: "多图片" }, { t: "附件" }],
                                    valueField: "t", textField: "t"
                                }
                            }
                        },
                        { field: "iDigit", title: "小数<br />位数", align: "center", width: 40, editor: { type: "numberspinner", options: { height: tdTxbHeight } } },
                        {
                            field: "sDefaultValue", title: "默认值", align: "center", width: 80,
                            editor: {
                                type: "combobox", options: {
                                    height: tdTxbHeight,
                                    data: [{ i: "UserID", t: "登录用户编号" }, { i: "UserName", t: "登录用户名" }, { i: "CurrentDate", t: "现在日期" },
                                        { i: "CurrentDateTime", t: "现在时间" }, { i: "Departid", t: "部门编号" }],
                                    valueField: "i", textField: "t"
                                }
                            }
                        },
                        { field: "fWidth", title: "宽度", align: "center", width: 60, editor: { type: "numberbox", options: { height: tdTxbHeight, precision: 0 } } },
                        {
                            field: "iSum", title: "求和", align: "center", width: 50, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iSum == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            field: "iAvg", title: "平均值", align: "center", width: 50, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iAvg == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            field: "iCount", title: "求个数", align: "center", width: 50, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iCount == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            field: "iMax", title: "最大值", align: "center", width: 50, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iMax == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            field: "iMin", title: "最小值", align: "center", width: 50, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iMin == "1") {
                                    return "√";
                                }
                            }
                        },
                        {
                            field: "iSummryDigit", title: "汇总<br />小数位", align: "center", width: 60, editor: {
                                type: "numberspinner", options: { height: tdTxbHeight }
                            }
                        },
                        {
                            field: "iHidden", title: "隐藏", align: "center", width: 40, editor: { type: "checkbox", options: { on: 1, off: 0 } },
                            formatter: function (value, row, index) {
                                if (row.iHidden == "1") {
                                    return "√";
                                }
                            }
                        }
                    ]],
                    data: columnsData,
                    remoteSort: false,
                    onClickRow: function (index, row) { Page.Children.currentEditRowIndex = index; },
                    onClickCell: function (index, row) { Page.Children.currentEditRowIndex = index; datagridOp.cellClick("tabColumnDefined", index, row); },
                    onBeforeEdit: function (index, row) { datagridOp.beforeEditor("tabColumnDefined", index, row); },
                    onBeginEdit: function (index, row) { datagridOp.beginEditor("tabColumnDefined", index, row); },
                    onEndEdit: function (index, row, changes) { datagridOp.endEditor("tabColumnDefined", index, row, changes); },
                    onAfterEdit: function (index, row, changes) { datagridOp.afterEditor("tabColumnDefined", index, row, changes); },
                    toolbar: [{
                        iconCls: 'icon-preview',
                        text: "上移",
                        handler: function () {
                            Page.Children.MoveUp("tabColumnDefined");
                        }
                    }, '-', {
                        iconCls: 'icon-next',
                        text: "下移",
                        handler: function () {
                            Page.Children.MoveDown("tabColumnDefined");
                        }
                    }, '-',
                    {
                        iconCls: 'icon-save',
                        text: "保存",
                        handler: function () {
                            if (Page.Children.currentEditRowIndex != undefined) {
                                $("#tabColumnDefined").datagrid("endEdit", Page.Children.currentEditRowIndex);
                            }
                            var rows = $("#tabColumnDefined").datagrid("getRows");
                            var str = "";
                            for (var i = 0; i < rows.length; i++) {
                                str += rows[i].iRecNo + "," + rows[i].iSerial + "," + (rows[i].sTitle ? rows[i].sTitle : "NULL") + "," + (rows[i].sType ? rows[i].sType : "NULL") + "," +
                                    (rows[i].iDigit ? rows[i].iDigit : "NULL") + "," + (rows[i].sDefaultValue ? rows[i].sDefaultValue : "NULL") + "," +
                                    (rows[i].fWidth ? rows[i].fWidth : "100") + "," + (rows[i].iSum ? rows[i].iSum : "0") + "," + (rows[i].iAvg ? rows[i].iAvg : "0") + "," +
                                    (rows[i].iCount ? rows[i].iCount : "0") + "," + (rows[i].iMax ? rows[i].iMax : "0") + "," + (rows[i].iMin ? rows[i].iMin : "0") + "," +
                                    (rows[i].iSummryDigit ? rows[i].iSummryDigit : "NULL") + "," + (rows[i].iHidden ? rows[i].iHidden : "0") + "`";
                            }
                            if (str != "") {
                                str = str.substr(0, str.length - 1);
                            }
                            var jsonobj = {
                                StoreProName: "SpBscChildTablesDColumnsSave",
                                StoreParms: [{
                                    ParmName: "@iMainRecNo",
                                    Value: rows[0].iMainRecNo
                                },
                                {
                                    ParmName: "@sStr",
                                    Value: str,
                                    Size: -1
                                }
                                ]
                            }
                            var result = SqlStoreProce(jsonobj);
                            if (result != "1") {
                                Page.MessageShow("错误", result);
                            }
                            else {
                                Page.MessageShow("成功", "保存成功");
                                //$("#divColumnDefined").dialog("close");
                            }
                        }
                    }, '-',
                    {
                        iconCls: 'icon-undo',
                        text: "关闭",
                        handler: function () {
                            $("#divColumnDefined").dialog("close");
                        }
                    }
                    ]
                })
            } else {
                $("#tabColumnDefined").datagrid("loadData", columnsData);
            }
            $("#divColumnDefined").dialog("open");
        },
        DeleteRow: function (tableid, index) {
            var theRow = $("#" + tableid).datagrid("getRows")[index];
            if (theRow) {
                var fieldKey = $("#" + tableid).attr("fieldkey");
                var deleteKey = $('#' + tableid).attr('deleteKey');
                if (deleteKey) {
                    deleteKey += theRow[(fieldKey)] + ',';
                    $('#' + tableid).attr('deleteKey', deleteKey);
                } else {
                    $('#' + tableid).attr('deleteKey', theRow[(fieldKey)] + ',');
                }
                $("#" + tableid).datagrid("deleteRow", index);
            }
        }
    },
    MessageShow: function (title, message) {
        $.messager.show({
            timeout: 2000,
            title: title,
            msg: "<span style='color:red;font-weight:bold;'>" + message + "</span>",
            showType: 'show',
            style: {
                right: '',
                top: document.body.scrollTop + document.documentElement.scrollTop,
                bottom: ''
            }
        });
    },
    ShowAttachmentWindow: function (btnA) {
        //按钮的附件、图片
        var fileGuid = $(btnA).attr("fileGuid");
        var theDiv = $("div[fileGuid='" + fileGuid + "']");
        //$(theDiv).slideToggle("show");
        $(theDiv).window("open");
    },
    showMainImage: function (guid) {
        var iframeFiles = $("#iframe" + guid);
        var sourceFormID = $(iframeFiles[0]).attr("SourceFormID") == "" ? Page.iformid : $(iframeFiles[0]).attr("SourceFormID");
        var sourceTableName = $(iframeFiles[0]).attr("SourceTableName") == "" ? Page.tablename : $(iframeFiles[0]).attr("SourceTableName");
        var sourceRecNo = $(iframeFiles[0]).attr("SourceRecNo") == "" ? Page.key : $(iframeFiles[0]).attr("SourceRecNo");
        var fileSize = $(iframeFiles[0]).attr("FileSize") == "" ? "4" : $(iframeFiles[0]).attr("FileSize");
        var width = $(iframeFiles[0]).attr("ImageWidth");
        var height = $(iframeFiles[0]).attr("ImageHeight");
        //if ($(iframeFiles[i]).attr("FileType") == "多图片") {
        $(iframeFiles[0]).attr("src", "/Base/imageUpload/imageMultiShow.aspx?iformid=" + sourceFormID + "&tablename=" + sourceTableName + "&irecno=" + sourceRecNo + "&filesize=" + fileSize + "&usetype=" + getQueryString("usetype") + "&fileType=image&width=" + width + "&height=" + height + "&random=" + Math.random());
        //}
    }
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

//获取url中传值
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
//回调方法
//url处理页面，parms回传的参数，async是否异步，ispost是否是post方式，functionnamew异步时完成后调用的方法
function callpostback(url, parms, async, ispost, functionname) {
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
                functionname(xmlhttp.responseText);
            }
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
function myBrowser() {
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera"
    }; //判断是否Opera浏览器
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //判断是否Firefox浏览器
    if (userAgent.indexOf("Chrome") > -1) {
        return "Chrome";
    }
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //判断是否Safari浏览器
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
        return "IE";
    }; //判断是否IE浏览器
}
function isArray(obj) {
    return Object.prototype.toString.call(obj) === '[object Array]';
}
function jsonStrReplace(str) {
    return str.replace(/\\n/g, "\\n")
                                      .replace(/\\'/g, "\\'")
                                      .replace(/\\"/g, "\\\"")
                                      .replace(/\\&/g, "\\&")
                                      .replace(/\\r/g, "\\r")
                                      .replace(/\\t/g, "\\t")
                                      .replace(/\\b/g, "\\b")
                                      .replace(/\\f/g, "\\f");
}
function getType(o) {
    var _t;
    return ((_t = typeof (o)) == "object" ? o == null && "null" || Object.prototype.toString.call(o).slice(8, -1) : _t).toLowerCase();
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

function deepCopy1(destination, source) {
    for (var p in source) {
        if (getType(source[p]) == "array" || getType(source[p]) == "object") {
            destination[p] = getType(source[p]) == "array" ? [] : {};
            arguments.callee(destination[p], source[p]);
        }
        else {
            destination[p] = source[p] == null || source[p] == undefined ? source[p] : source[p].toString();
        }
    }
}

Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1,                 //月份 
        "d+": this.getDate(),                    //日 
        "h+": this.getHours(),                   //小时 
        "m+": this.getMinutes(),                 //分 
        "s+": this.getSeconds(),                 //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds()             //毫秒 
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
//处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
function banBackSpace(e) {
    var ev = e || window.event; //获取event对象
    var obj = ev.target || ev.srcElement; //获取事件源
    var t = obj.type || obj.getAttribute('type'); //获取事件源类型
    //获取作为判断条件的事件类型
    var vReadOnly = obj.readOnly;
    var vDisabled = obj.disabled;
    //处理undefined值情况
    vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
    vDisabled = (vDisabled == undefined) ? true : vDisabled;
    //当敲Backspace键时，事件源类型为密码或单行、多行文本的，
    //并且readOnly属性为true或disabled属性为true的，则退格键失效
    var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);
    //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
    var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";
    //判断
    if (flag2 || flag1) return false;
}

function __goToNext() {
    var event = window.event || arguments.callee.caller.arguments[0]; // 获取event对象
    var iKeyCode = event.keyCode || event.which; //获取按钮代码
    if (iKeyCode == 13 || iKeyCode == 9) {
        var elementTarget = event.srcElement || event.target; // 获取触发事件的源对象
        if (elementTarget.tagName.toLowerCase() != "textarea") {
            if (datagridOp.currentIsEdit == true) {
                //如果正在弹窗选择，则不跳到下一个
                if (typeof (lookUp) != "undefined") {
                    if (lookUp.isPopupOpen == false && datagridOp.isEidtorTextarea == undefined) {
                        datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex, datagridOp.currentColumnName);
                    }
                }
            }
            else {
                var isie = (document.all) ? true : false;
                if (isie) {
                    event.keyCode = 9;
                    //getNextVisableElement(elementTarget.nextSibling).focus();
                }
                else {
                    var el = getNextElement(event.target);
                    if (el.type != 'hidden')
                        ;   //nothing to do here.
                    else
                        while (el.type == 'hidden')
                            el = getNextElement(el);
                    if (!el)
                        return false;
                    else
                        el.focus();
                    //把提交按钮retrun 为false
                    return false;
                }
            }
        }
    }
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

function getCursortPosition(textDom) {
    var cursorPos = 0;
    if (document.selection) {
        // IE Support
        textDom.focus();
        var selectRange = document.selection.createRange();
        selectRange.moveStart('character', -textDom.value.length);
        cursorPos = selectRange.text.length;
    } else if (textDom.selectionStart || textDom.selectionStart == '0') {
        // Firefox support
        cursorPos = textDom.selectionStart;
    }
    return cursorPos;
}

$(function () {
    if ($("#HidNoForm").val() != "1") {
        Page.isInited = false;
        if (Page.beforeInit) {
            Page.beforeInit();
        }
        if (Page.init() != false) {
            if (Page.beforeLoad != undefined) {
                Page.beforeLoad();
            }
            if (Page.onBeforeLoad != undefined) {
                Page.onBeforeLoad();
            }
            Page.loading();
            if (Page.afterLoad != undefined) {
                Page.afterLoad();
            }
            if (Page.onAfterLoad != undefined) {
                Page.onAfterLoad();
            }

            if (getQueryString("usetype") == "add") {
                setTimeout("Page.treeinit();", 1000);
            }
            if (getQueryString("usetype") == null || getQueryString("usetype") == "view") {
                Page.mainDisabled();
                Page.childrenDisabled();
            }
            Page.procPageInit();
        }
        Page.setReadonlyTxbBackColor();
        Page.isInited = true;
    }
    else {
        //初始化控件，包括：是否为空，是否为数字，小数位数,日期，时间,只读,可用。普通输入框将被转成textbox
        Page.tablename = $("#TableName").val();
        Page.fieldkey = $("#FieldKey").val();
        Page.key = $("#FieldKeyValue").val();
        Page.userid = $("#UserID").val();
        Page.username = $("#UserName").val();
        Page.deptid = $("#DeptID") ? $("#DeptID").val() : "";
        lookUp.initFrame();
        lookUp.initHead();
        var textareaArr = $("textarea[FieldID]");
        for (var i = 0; i < textareaArr.length; i++) {
            $(textareaArr[i]).addClass("textarea");
        }
        dataForm.init();
        Page.isInited = true;
    }
    var inputText = $("input[type='text']");
    for (var i = 0; i < inputText.length; i++) {
        if (inputText[i].style.display != "none") {
            inputText[i].click();
            break;
        }
    }

    $('input:text:first').focus();
    $('input:text').bind("keydown", function (e) {
        if (e.which == 13) {   //Enter key
            e.preventDefault(); //to skip default behaviour of enter key
            var nextinput = $('input:text')[$('input:text').index(this) + 1];
            if (nextinput != undefined) {
                nextinput.focus();
            } else {
                //alert("没有下一个输入框！");
            }
        }
    });

    $(document).click(function (event) {
        if (datagridOp.currentIsEdit && lookUp.isPopupOpen != true) {
            //            var srcObj = ((event.srcElement) ? event.srcElement : event.target);
            //            var value = $(srcObj).attr("isDetailColumnEditting");
            //            if (value != "true") {
            //                if (datagridOp.current) {
            //                    $(datagridOp.current).datagrid("endEdit", datagridOp.currentRowIndex);
            //                }
            //            }
            if (datagridOp.current) {
                var obj = event.srcElement ? event.srcElement : event.target;
                var className = obj.className;
                if (className.indexOf("calendar") < 0) {
                    $(datagridOp.current).datagrid("endEdit", datagridOp.currentRowIndex);
                }
            }
        }
        //        try {
        //            var srcObj = ((event.srcElement) ? event.srcElement : event.target);
        //            if (!$(srcObj).hasClass("menu-text")) {
        //                $("#divlookUp").dialog("close");
        //            }
        //        }
        //        catch (e) {

        //        }
    });

    //禁止退格键 作用于Firefox、Opera
    //document.onkeypress = banBackSpace;
    //禁止退格键 作用于IE、Chrome
    //document.onkeydown = banBackSpace;

    //所有输入框控件按回车转Tab
    var formElement = $("[FieldID]");
    for (var i = 0; i < formElement.length; i++) {
        var theTagName = formElement[i].tagName;
        switch (theTagName.toLowerCase()) {
            case "input":
                {
                    var theType = $(formElement[i]).attr("type");
                    switch (theType) {
                        case "text":
                            {
                                var plugin = $(formElement[i]).attr("plugin");
                                switch (plugin) {
                                    case "textbox":
                                        {
                                            try {
                                                $("#" + formElement[i].id).textbox("textbox").keydown(function () {
                                                    __goToNext();
                                                });
                                            }
                                            catch (e) {
                                                $(formElement[i]).keydown(function () {
                                                    __goToNext();
                                                });
                                            }
                                        } break;
                                    case "numberbox":
                                        {
                                            $("#" + formElement[i].id).numberbox("textbox").keydown(function () {
                                                __goToNext();
                                            });
                                        } break;
                                    case "datebox":
                                        {
                                            $("#" + formElement[i].id).datebox("textbox").keydown(function () {
                                                __goToNext();
                                            });
                                        } break;
                                    case "datetimebox":
                                        {
                                            $("#" + formElement[i].id).datetimebox("textbox").keydown(function () {
                                                __goToNext();
                                            });
                                        } break;
                                }
                            } break;
                        case "checkbox":
                            {
                                $(formElement[i]).keydown(function () {
                                    __goToNext();
                                });
                            } break;
                    }
                } break;
            case "select":
                {
                    $(formElement[i]).keydown(function () {
                        __goToNext();
                    });
                } break;
        }
    }

    document.onkeydown = function () {
        banBackSpace();
        //__goToNext();
        var event = window.event || arguments.callee.caller.arguments[0]; // 获取event对象
        var elementTarget = event.srcElement || event.target;
        var iKeyCode = event.keyCode || event.which; //获取按钮代码
        if (iKeyCode == 13 || iKeyCode == 9) {
            if (elementTarget.tagName.toLowerCase() != "textarea") {
                if (datagridOp.currentIsEdit == true) {
                    //如果正在弹窗选择，则不跳到下一个
                    if (typeof (lookUp) != "undefined") {
                        if (lookUp.isPopupOpen == false && datagridOp.isEidtorTextarea == undefined) {
                            datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex, datagridOp.currentColumnName);
                        }
                    }
                }
            }
        }

        var doFoucus = function (ed) {
            if (ed) {
                if (ed.type == "textbox") {
                    $(ed.target).textbox("textbox").focus();
                    $(ed.target).textbox("textbox").select();
                }
                else if (ed.type == "numberbox") {
                    $(ed.target).numberbox("textbox").focus();
                    $(ed.target).numberbox("textbox").select();
                }
                else if (ed.type == "combobox") {
                    $(ed.target).combobox("textbox").focus();
                    $(ed.target).combobox("textbox").select();
                }
                else if (ed.type == "combotree") {
                    $(ed.target).combotree("textbox").focus();
                    $(ed.target).combotree("textbox").select();
                }
                else if (ed.type == "numberspinner") {
                    $(ed.target).numberspinner("textbox").focus();
                    $(ed.target).numberspinner("textbox").select();
                }
                else if (ed.type == "datebox") {
                    $(ed.target).datebox("textbox").focus();
                    $(ed.target).datebox("textbox").select();
                }
                else if (ed.type == "datetimebox") {
                    $(ed.target).datetimebox("textbox").focus();
                    $(ed.target).datetimebox("textbox").select();
                }
                else {
                    $(ed.target).focus();
                    $(ed.target).select();
                }
                if (ed.target[0].tagName.toLowerCase() == "textarea") {
                    datagridOp.isEidtorTextarea = true;
                }
                else {
                    datagridOp.isEidtorTextarea = undefined;
                }
            }
        }
        var bindMouseup = function (ed) {
            if (ed) {
                if (ed.type == "textbox") {
                    $(ed.target).textbox("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else if (ed.type == "numberbox") {
                    $(ed.target).numberbox("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else if (ed.type == "combobox") {
                    $(ed.target).combobox("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });

                }
                else if (ed.type == "combotree") {
                    $(ed.target).combotree("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else if (ed.type == "numberspinner") {
                    $(ed.target).numberspinner("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else if (ed.type == "datebox") {
                    $(ed.target).datebox("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else if (ed.type == "datetimebox") {
                    $(ed.target).datetimebox("textbox").bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
                else {
                    $(ed.target).bind("mouseup", function (eventTag) {
                        var event = eventTag || window.event;
                        event.preventDefault();
                    });
                }
            }
        }
        if (event.keyCode == 40) {
            if (datagridOp.currentIsEdit == true) {
                if (typeof (lookUp) != "undefined") {
                    if (lookUp.isPopupOpen == false) {
                        var rowCount = $("#" + datagridOp.current.id).datagrid("getRows").length;
                        if (rowCount - 1 == datagridOp.currentRowIndex) {
                            Page.tableToolbarClick("add", datagridOp.current.id, {});
                            var rowCount1 = $("#" + datagridOp.current.id).datagrid("getRows").length;
                            if (rowCount1 <= rowCount) {
                                return false;
                            }
                        }
                        var curtIndex = datagridOp.currentRowIndex;
                        datagridOp.lookUpNotOpen = true;
                        $("#" + datagridOp.current.id).datagrid("endEdit", curtIndex);
                        datagridOp.lookUpNotOpen = undefined;
                        $("#" + datagridOp.current.id).datagrid("editCell", { index: curtIndex + 1, field: datagridOp.currentColumnName });
                        var ed = $("#" + datagridOp.current.id).datagrid('getEditor', { index: curtIndex + 1, field: datagridOp.currentColumnName });
                        //bindMouseup(ed);
                        doFoucus(ed);
                        //datagridOp.currentColumnName = r.field;
                        //datagridOp.currentColumnIndex = r.index;
                        datagridOp.currentRowIndex = curtIndex + 1;
                        event.preventDefault();
                    }
                }
            }
        }
        if (event.keyCode == 38) {
            if (datagridOp.currentIsEdit == true) {
                if (typeof (lookUp) != "undefined") {
                    if (lookUp.isPopupOpen == false) {
                        if (datagridOp.currentRowIndex != 0) {
                            //var rowCount = $("#" + datagridOp.current.id).datagrid("getRows").length;
                            var curtIndex = datagridOp.currentRowIndex;
                            datagridOp.lookUpNotOpen = true;
                            $("#" + datagridOp.current.id).datagrid("endEdit", curtIndex);
                            datagridOp.lookUpNotOpen = undefined;
                            $("#" + datagridOp.current.id).datagrid("editCell", { index: curtIndex - 1, field: datagridOp.currentColumnName });

                            var ed = $("#" + datagridOp.current.id).datagrid('getEditor', { index: curtIndex - 1, field: datagridOp.currentColumnName });
                            doFoucus(ed);
                            datagridOp.currentRowIndex = curtIndex - 1;
                            event.preventDefault();
                        }
                    }
                }
            }
        }
        if (event.keyCode == 37) {
            if (datagridOp.currentIsEdit == true) {
                if (datagridOp.currentColumnIndex > 0) {
                    if (typeof (lookUp) != "undefined") {
                        if (lookUp.isPopupOpen == false) {
                            event = event ? event : window.event;
                            var obj = event.srcElement ? event.srcElement : event.target;
                            var cursortPosition = getCursortPosition(obj);
                            if (cursortPosition == 0) {
                                datagridOp.gotoPreviousEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex);
                                event.preventDefault();
                            }

                        }
                    }
                }

            }
        }
        if (event.keyCode == 39) {
            if (datagridOp.currentIsEdit == true) {
                //if (datagridOp.currentColumnIndex > 0) {
                if (typeof (lookUp) != "undefined") {
                    if (lookUp.isPopupOpen == false) {
                        event = event ? event : window.event;
                        var obj = event.srcElement ? event.srcElement : event.target;
                        var cursortPosition = getCursortPosition(obj);
                        if (cursortPosition == obj.value.length) {
                            datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex);
                            event.preventDefault();
                        }
                    }
                }
                //}

            }
        }
    }
    $("textarea").addClass("textarea");
})


Number.prototype.toFixed = function (d) {
    var s = this + "";
    if (!d) d = 0;
    if (s.indexOf(".") == -1) s += ".";
    s += new Array(d + 1).join("0");
    if (new RegExp("^(-|\\+)?(\\d+(\\.\\d{0," + (d + 1) + "})?)\\d*$").test(s)) {
        var s = "0" + RegExp.$2, pm = RegExp.$1, a = RegExp.$3.length, b = true;
        if (a == d + 2) {
            a = s.match(/\d/g);
            if (parseInt(a[a.length - 1]) > 4) {
                for (var i = a.length - 2; i >= 0; i--) {
                    a[i] = parseInt(a[i]) + 1;
                    if (a[i] == 10) {
                        a[i] = 0;
                        b = i != 1;
                    } else break;
                }
            }
            s = a.join("").replace(new RegExp("(\\d+)(\\d{" + d + "})\\d$"), "$1.$2");

        } if (b) s = s.substr(1);
        return (pm + s).replace(/\.$/, "");
    } return this + "";
};
