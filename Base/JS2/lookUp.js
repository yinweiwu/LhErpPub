//document.write("<script src='/Base/JS2/JudgeExists.js'></script>");
var tdTxbHeight = 25;
var lookUp = {
    lists: [],
    current: undefined,
    isPopupOpen: false,
    //初始化，创建一个div用来装lookup弹框
    initFrame: function () {
        //        var divlookup = document.createElement("div"); //创建P标签
        //        divlookup.setAttribute("id", "divlookUp");
        //        divlookup.setAttribute("style", "margin:0px;padding:0px");
        //        document.body.appendChild(divlookup);
        //        $(".panel,.window,.panel-header").click(function (e) {
        //            e.stopPropagation(); //阻止冒泡到body
        //        });
    },
    //初始化主表lookup,在Page.init中调用
    initHead: function () {
        var inputs = $("input[lookupOptions]");
        var mainLookupNameStr = ""; //lookupName字段串，提供查询.这样做的好处是只查询一次数据库，增加效率
        var mainObject = []; //lookup-option数组
        for (var i = 0; i < inputs.length; i++) {
            if ($("#" + inputs[i].id).attr("lookupOptions")) {
                var str = $("#" + inputs[i].id).attr("lookupOptions");
                var option = eval("(" + str + ")");
                var object = {
                    id: undefined,
                    options: undefined
                };
                object.id = inputs[i].id;
                for (var j = 0; j < option.length; j++) {
                    option[j].targetID = inputs[i].id;
                    mainLookupNameStr += "'" + option[j].lookupName + "',";
                }
                object.options = option;
                //option.targetID = inputs[i].id;
                mainObject.push(object);
            }
        }
        if (mainLookupNameStr.length > 0) {
            mainLookupNameStr = mainLookupNameStr.substr(0, mainLookupNameStr.length - 1);
        }
        var lookDefine
        try {
            lookDefine = JSON2.parse($("#HidMainLookupDefined").val());
        }
        catch (e) {
            if (mainLookupNameStr.length > 0) {
                lookDefine = SqlGetData({
                    TableName: "bscInitLookup",
                    Fields: "sOrgionName,sReturnField,sDisplayField,iHeight,iWidth,sSQL,sReturnField,sPageField,iWindow,iTree,iExtend,sRootValue,iLeaf,sParentField,sChildField,sTreeDisplayField,sFilters",
                    SelectAll: "True",
                    Filters: [
                {
                    Field: "sOrgionName",
                    ComOprt: "in",
                    Value: "(" + mainLookupNameStr + ")"
                }]
                });
            }
        }
        for (var i = 0; i < mainObject.length; i++) {
            if (mainObject[i].options.length == 1) {
                var option = mainObject[i].options[0];
                for (var k = 0; k < lookDefine.length; k++) {
                    if (option.lookupName == lookDefine[k].sOrgionName) {
                        $("#" + option.targetID).removeAttr("noEasyui");
                        var required = false;
                        var reqMess = "不可空!";
                        if (typeof (Page) != "undefined") {
                            var theField = $("#" + option.targetID).attr("FieldID");
                            for (var il = 0; il < Page.MainRequiredFields.length; il++) {
                                if (theField == Page.MainRequiredFields[il].field) {
                                    required = true;
                                    break;
                                }
                            }
                        }
                        var requiredStr = $("#" + option.targetID).attr("isRequired");
                        if (requiredStr == "true") {
                            required = true;
                        }
                        var requiredStr1 = $("#" + option.targetID).attr("notNull");
                        if (requiredStr1 == "true") {
                            required = true;
                        }

                        if (lookDefine[k].iWindow != "1") {//是弹窗选择
                            var isReadOnly = false;
                            var isDisabled = false;
                            if ($("#" + option.targetID).attr("readonly") == "readonly") {
                                isReadOnly = true;
                                $("#" + option.targetID).removeAttr("readonly");
                            }
                            try {
                                if ($("#" + option.targetID).textbox("options").readonly == true) {
                                    isReadOnly = true;
                                    //$("#" + option.targetID).removeAttr("readonly");
                                }
                            }
                            catch (e) {

                            }
                            if ($("#" + option.targetID).attr("disabled") == "disabled") {
                                isDisabled = true;
                                $("#" + option.targetID).removeAttr("disabled");
                            }
                            try {
                                if ($("#" + option.targetID).textbox("options").disabled == true) {
                                    isDisabled = true;
                                }
                            }
                            catch (e) {

                            }
                            var cc = $("#" + option.targetID + "_val");
                            if (cc.length == 0) {
                                //创建一个hidden，用来保存value,因为textbox会丢失value
                                var inputHidden = document.createElement("input");
                                inputHidden.type = "hidden";
                                inputHidden.id = option.targetID + "_val";
                                document.body.appendChild(inputHidden);
                            }

                            option.width = option.width == undefined ? lookDefine[k].iWidth == "" ? 900 : parseInt(lookDefine[k].iWidth) < 900 ? 900 : lookDefine[k].iWidth : option.width;
                            option.height = option.height == undefined ? lookDefine[k].iHeight == "" ? 400 : lookDefine[k].iHeight : 400;
                            option.textField = lookDefine[k].sDisplayField;
                            option.valueField = lookDefine[k].sReturnField;
                            option.pageKey = lookDefine[k].sPageField == "" || lookDefine[k].sPageField == null || lookDefine[k].sPageField == undefined ? lookDefine[k].sReturnField : lookDefine[k].sDisplayField;
                            option.lookupCat = "popup";
                            option.fixFilters1 = lookDefine[k].sFilters;
                            var isEdit = option.editable == undefined || option.editable == false ? false : true;
                            this.createNew(mainObject[i]);

                            $("#" + option.targetID).textbox({
                                required: required,
                                missingMessage: reqMess,
                                invalidMessage: reqMess,
                                readonly: isReadOnly,
                                disabled: isDisabled,
                                icons: [
                                    {
                                        iconCls: 'icon-clear1',
                                        handler: function (e) {
                                            var oldValue = $("#" + e.data.target.id + "_val").val();
                                            if (oldValue != "" && oldValue != undefined && oldValue != null) {
                                                $(e.data.target).textbox("clear");
                                                $(e.data.target.id + "_val").val("");
                                                if (typeof (Page) != "undefined") {
                                                    if (Page.Formula) {
                                                        Page.Formula($(e.data.target).attr("FieldID"));
                                                    }
                                                }
                                            }
                                        }

                                    }
                                ],
                                buttonText: "...",
                                editable: isEdit,
                                targetID: option.targetID,
                                onClickButton: function () {
                                    var targetid = $(this).textbox("options").targetID;
                                    var text = $(this).textbox("textbox").val();
                                    var object = lookUp.getObjByID(targetid);
                                    lookUp.current = object;
                                    lookUp.open(text, "button");
                                }
                            });
                            //$("#" + mainLookupOptions[j].targetID).attr("plugin", "textbox");
                            var target = option.targetID;
                            $("#" + option.targetID).textbox("textbox").attr("targetID", target);
                            $("#" + option.targetID).textbox("textbox").bind("keydown", function (e) {
                                if (e.keyCode == 13) {
                                    var target = $(this).attr("targetID");
                                    $("#" + target).textbox("button").click();
                                    //return false;
                                }
                            });
                            $("#" + option.targetID).textbox("textbox").bind("dblclick", function (e) {
                                var target = $(this).attr("targetID");
                                $("#" + target).textbox("button").click();
                            });
                            //                            if (required == true) {
                            //                                $($("#" + option.targetID).textbox("textbox")).addClass("txbrequired");
                            //                            }
                            if (typeof (Page) != "undefined") {
                                //                                var theFieldID = $("#" + option.targetID).attr("FieldID");
                                //                                if (Page.MainRequiredFields && Page.MainRequiredFields.length > 0 && required == false) {
                                //                                    for (var ii = 0; ii < Page.MainRequiredFields.length; ii++) {
                                //                                        if (Page.MainRequiredFields[ii].field == theFieldID) {
                                //                                            $($("#" + option.targetID).textbox("textbox")).addClass("txbrequired");
                                //                                            break;
                                //                                        }
                                //                                    }
                                //                                }
                                //                                if (Page.usetype == "add") {
                                //                                    if (Page.DefaultValues[(theFieldID)]) {
                                //                                        lookUp.setElementValueHead($("#" + option.targetID)[0], Page.DefaultValues[(theFieldID)]);
                                //                                    }

                                //                                }
                            }
                        }
                        else {//不是弹窗选择
                            if (option.width == 600) {
                                option.width = undefined;
                            }
                            if (option.height == 400) {
                                option.height = undefined;
                            }

                            var ExpFun = undefined;
                            if (typeof (Page) != "undefined" && $("#HidNoForm").val() != "1") {
                                for (var l = 0; l < Page.fieldExp.length; l++) {
                                    if ($("#" + mainObject[i].id).attr("FieldID") == Page.fieldExp[l].field) {
                                        ExpFun = Page.fieldExp[l].exp;
                                    }
                                }
                            }

                            if (lookDefine[k].iTree != "1") {//不是树
                                $("#" + option.targetID).combobox({
                                    required: required,
                                    invalidMessage: reqMess,
                                    multiple: option.isMulti == undefined ? false : option.isMulti,
                                    formatter: function (row) {
                                        var opts = $(this).combobox('options');
                                        if (opts.multiple == true) {
                                            return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField];
                                        }
                                        else {
                                            return row[opts.textField];
                                        }
                                    },
                                    editable: option.editable == undefined || option.editable == false ? false : option.editable,
                                    panelWidth: option.width == undefined ? lookDefine[k].width == "" ? null : lookDefine[k].width : option.width,
                                    panelHeight: option.height == undefined ? lookDefine[k].height == "" ? null : lookDefine[k].height : option.height,
                                    valueField: lookDefine[k].sReturnField,
                                    textField: lookDefine[k].sDisplayField,
                                    icons: [
                                    {
                                        iconCls: 'icon-clear1',
                                        handler: function (e) {
                                            var oldValue = $(e.data.target).combobox("getValue");
                                            if (oldValue != "" && oldValue != undefined && oldValue != null) {
                                                $(e.data.target).combobox("clear");
                                                if (typeof (Page) != "undefined") {
                                                    if (Page.Formula) {
                                                        Page.Formula($(e.data.target).attr("FieldID"));
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    ],
                                    groupField: option.groupField == undefined ? null : option.groupField,
                                    groupFormatter: function (group) {
                                        return '<span style="font-weight:bold;">' + group + '</span>';
                                    },
                                    //onSelect: ExpFun,
                                    url: "/Base/Handler/getDataList2.ashx",
                                    //lookupOptions:option,
                                    onBeforeLoad: function (param) {
                                        param.otype = "lookup";
                                        var lookupOptions = $(this).attr("lookupOptions");
                                        var lookupOptionsStr = $(this).attr("lookupOptions");
                                        var lookupOptions = eval("(" + lookupOptionsStr + ")")[0];
                                        param.lookupname = lookupOptions.lookupName;
                                        var fixFilters = lookupOptions.fixFilters;
                                        fixFilters = fixFilters ? fixFilters.replace(/&apos;/g, "'") : "";
                                        if (fixFilters && fixFilters != "" && fixFilters != "1=1") {
                                            if (typeof (Page) != "undefined") {
                                                //                                                if (Page.isInited == true) {
                                                //                                                    param.filters = encodeURIComponent(Page.parseMainField(fixFilters));
                                                //                                                }
                                                param.filters = encodeURIComponent(Page.parseMainField(fixFilters));
                                            }
                                            else {
                                                if (typeof (FormList) != "undefined") {
                                                    param.filters = encodeURIComponent(FormList.parseLookupField(fixFilters));
                                                }
                                            }
                                        }
                                    },
                                    onShowPanel: function () {
                                        var lookupOptions = $(this).attr("lookupOptions");
                                        var lookupOptionsStr = $(this).attr("lookupOptions");
                                        var lookupOptions = eval("(" + lookupOptionsStr + ")")[0];
                                        var fixFilters = lookupOptions.fixFilters;
                                        if (fixFilters && fixFilters != "" && fixFilters != "1=1") {
                                            var url = $(this).combobox("options").url;
                                            $(this).combobox("reload", url);
                                        }

                                        var opts = $(this).combobox('options');
                                        if (opts.multiple == true) {
                                            var target = this;
                                            var values = $(target).combobox('getValues');
                                            $.map(values, function (value) {
                                                var el = opts.finder.getEl(target, value);
                                                el.find('input.combobox-checkbox')._propAttr('checked', true);
                                            })
                                        }
                                    },
                                    onLoadError: function (result) {
                                        $.messager.alert("错误", "lookUp初始化错误：" + result.responseText);
                                    },
                                    //                                    onChange: isDynTriggerField ? function (newValue, oldValue) {
                                    //                                        if (typeof (Page) != "undefined") {
                                    //                                            var FieldID = $("#" + this.id).attr("FieldID");
                                    //                                            for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                    //                                                if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                    //                                                    Page.Children.ShowDynColumns(Page.Children.DynColumnsDefined[dyn].tableName, newValue);
                                    //                                                    continue;
                                    //                                                }
                                    //                                            }
                                    //                                        }
                                    //                                    } : undefined
                                    onChange: function (newValue, oldValue) {
                                        if (typeof (Page) != "undefined") {
                                            var FieldID = $("#" + this.id).attr("FieldID");
                                            var isDynTriggerField = false;
                                            if (typeof (Page) != "undefined") {
                                                for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                                    if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                                        isDynTriggerField = true;
                                                        break;
                                                    }
                                                }
                                            }
                                            if (isDynTriggerField == true) {
                                                var FieldID = $("#" + this.id).attr("FieldID");
                                                for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                                    if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                                        Page.Children.ShowDynColumns(Page.Children.DynColumnsDefined[dyn].tableName, newValue);
                                                        continue;
                                                    }
                                                }
                                            }
                                            var target = this;
                                            var field = $(target).attr("FieldID");
                                            if (Page.FormulaBack) {
                                                Page.FormulaBack(field, newValue, oldValue);
                                            }

                                            if (Page.Formula) {
                                                Page.Formula(field, newValue, oldValue);
                                            }
                                        }
                                    },
                                    onLoadSuccess: function () {
                                        var opts = $(this).combobox('options');
                                        if (opts.multiple == true) {
                                            var target = this;
                                            var values = $(target).combobox('getValues');
                                            $.map(values, function (value) {
                                                var el = opts.finder.getEl(target, value);
                                                el.find('input.combobox-checkbox')._propAttr('checked', true);
                                            })
                                        }
                                    },
                                    onSelect: function (row) {
                                        //console.log(row);
                                        var opts = $(this).combobox('options');
                                        if (opts.multiple == true) {
                                            var el = opts.finder.getEl(this, row[opts.valueField]);
                                            el.find('input.combobox-checkbox')._propAttr('checked', true);
                                        }
                                    },
                                    onUnselect: function (row) {
                                        var opts = $(this).combobox('options');
                                        if (opts.multiple == true) {
                                            var el = opts.finder.getEl(this, row[opts.valueField]);
                                            el.find('input.combobox-checkbox')._propAttr('checked', false);
                                        }
                                    }
                                });
                                $("#" + option.targetID).attr("plugin", "combobox");
                                if (typeof (Page) != "undefined") {
                                    //                                    var theFieldID = $("#" + option.targetID).attr("FieldID");
                                    //                                    if (Page.MainRequiredFields && Page.MainRequiredFields.length > 0 && required == false) {
                                    //                                        for (var ii = 0; ii < Page.MainRequiredFields.length; ii++) {
                                    //                                            if (Page.MainRequiredFields[ii].field == theFieldID) {
                                    //                                                $($("#" + option.targetID).combobox("textbox")).addClass("txbrequired");
                                    //                                                break;
                                    //                                            }
                                    //                                        }
                                    //                                    }
                                    //                                    if (Page.usetype == "add") {
                                    //                                        if (Page.DefaultValues[(theFieldID)]) {
                                    //                                            var valuesArr = Page.DefaultValues[(theFieldID)].split(",");
                                    //                                            $("#" + option.targetID).combobox("setValues", valuesArr);
                                    //                                            //lookUp.setElementValueHead($("#" + option.targetID)[0], Page.DefaultValues[(theFieldID)]);
                                    //                                        }
                                    //                                    }
                                }
                            }
                            else {
                                var queryParamsParse = "";
                                if (typeof (Page) != "undefined") {
                                    if (option.fixFilters) {
                                        queryParamsParse = Page.parseMainField(option.fixFilters).replace(/%/g, "%25");
                                    }
                                }

                                $("#" + option.targetID).combotree({
                                    required: required,
                                    invalidMessage: reqMess,
                                    url: "/Base/Handler/getDataList2.ashx",
                                    queryParams: { lookupName: option.lookupName, otype: "lookup", filters: option.fixFilters == undefined ? "" : queryParamsParse },
                                    targetID: option.targetID,
                                    //lookupOptions:option,
                                    multiple: option.isMulti == undefined ? false : option.isMulti,
                                    onlyLeafCheck: option.onlyLeafCheck == undefined ? false : option.onlyLeafCheck,
                                    checkbox: true,
                                    editable: option.editable == undefined || option.editable == false ? false : option.editable,
                                    panelWidth: option.width == undefined ? lookDefine[k].width == "" ? null : lookDefine[k].width : option.width,
                                    panelHeight: option.height == undefined ? lookDefine[k].height == "" ? null : lookDefine[k].height : option.height,
                                    valueField: lookDefine[k].sReturnField,
                                    textField: lookDefine[k].sDisplayField,
                                    icons: [
                                    {
                                        iconCls: 'icon-clear1',
                                        handler: function (e) {
                                            var oldValue = $(e.data.target).combotree("getValue");
                                            if (oldValue != "" && oldValue != undefined && oldValue != null) {
                                                $(e.data.target).combotree("clear");
                                                if (typeof (Page) != "undefined") {
                                                    if (Page.Formula) {
                                                        Page.Formula($(e.data.target).attr("FieldID"));
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    ],
                                    //onSelect: ExpFun,
                                    //                                    onShowPanel: function () {
                                    //                                        var options = $(this).combotree("options");
                                    //                                        var lookupOptionStr = $("#" + options.targetID).attr("lookupOptions");
                                    //                                        var lookupOptionArr = eval("(" + lookupOptionStr + ")");
                                    //                                        var lookupOption = lookupOptionArr[0];
                                    //                                        var fixFilters = lookupOption.fixFilters;
                                    //                                        if (fixFilters && fixFilters != "" && fixFilters != "1=1") {
                                    //                                            var filtersParse = "";
                                    //                                            if (typeof (Page) != "undefined") {
                                    //                                                filtersParse = Page.parseMainField(fixFilters);
                                    //                                            }
                                    //                                            options.queryParams.filters = encodeURIComponent(filtersParse);
                                    //                                            $(this).combotree({
                                    //                                                queryParams: options.queryParams
                                    //                                            });
                                    //                                            //$(this).combotree("reload", $(this).options("url"));
                                    //                                        }
                                    //                                    },
                                    onBeforeSelect: option.onlyLeafSelect == true ? function (node) {
                                        if (!$(this).tree('isLeaf', node.target)) {
                                            return false;
                                        }
                                    } : undefined,
                                    onLoadError: function (result) {
                                        $.messager.alert("错误", "lookUp初始化错误：" + result.responseText);
                                    },
                                    //                                    onChange: isDynTriggerField ? function (newValue, oldValue) {
                                    //                                        if (typeof (Page) != "undefined") {
                                    //                                            var FieldID = $("#" + this.id).attr("FieldID");
                                    //                                            for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                    //                                                if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                    //                                                    Page.Children.ShowDynColumns(Page.Children.DynColumnsDefined[dyn].tableName, newValue);
                                    //                                                    continue;
                                    //                                                }
                                    //                                            }
                                    //                                        }
                                    //                                    } : undefined
                                    onChange: function (newValue, oldValue) {
                                        if (typeof (Page) != "undefined") {
                                            var FieldID = $("#" + this.id).attr("FieldID");
                                            var isDynTriggerField = false;
                                            if (typeof (Page) != "undefined") {
                                                for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                                    if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                                        isDynTriggerField = true;
                                                        break;
                                                    }
                                                }
                                            }
                                            if (isDynTriggerField == true) {
                                                var FieldID = $("#" + this.id).attr("FieldID");
                                                for (var dyn = 0; dyn < Page.Children.DynColumnsDefined.length; dyn++) {
                                                    if (FieldID == Page.Children.DynColumnsDefined[dyn].triggerField) {
                                                        Page.Children.ShowDynColumns(Page.Children.DynColumnsDefined[dyn].tableName, newValue);
                                                        continue;
                                                    }
                                                }
                                            }
                                            var target = this;
                                            var field = $(target).attr("FieldID");
                                            if (Page.FormulaBack) {
                                                Page.FormulaBack(field, newValue, oldValue);
                                            }
                                            if (Page.Formula) {
                                                Page.Formula(field, newValue, oldValue);
                                            }
                                        }
                                    }
                                });
                                $("#" + option.targetID).attr("plugin", "combotree");
                                if (typeof (Page) != "undefined") {
                                    //                                    var theFieldID = $("#" + option.targetID).attr("FieldID");
                                    //                                    if (Page.MainRequiredFields && Page.MainRequiredFields.length > 0 && required == false) {
                                    //                                        for (var ii = 0; ii < Page.MainRequiredFields.length; ii++) {
                                    //                                            if (Page.MainRequiredFields[ii].field == theFieldID) {
                                    //                                                $($("#" + option.targetID).combotree("textbox")).addClass("txbrequired");
                                    //                                                break;
                                    //                                            }
                                    //                                        }
                                    //                                    }
                                    //                                    if (Page.usetype == "add") {
                                    //                                        if (Page.DefaultValues[(theFieldID)]) {
                                    //                                            var valuesArr = Page.DefaultValues[(theFieldID)].split(",");
                                    //                                            $("#" + option.targetID).combotree("setValues", valuesArr);
                                    //                                            //lookUp.setElementValueHead($("#" + option.targetID)[0], Page.DefaultValues[(theFieldID)]);
                                    //                                        }
                                    //                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                for (var j = 0; j < mainObject[i].options.length; j++) {
                    var option = mainObject[i].options[j];
                    $("#" + option.targetID).removeAttr("noEasyui");
                    var cc = $("#" + option.targetID + "_val");
                    if (cc.length == 0) {
                        //创建一个hidden，用来保存value,因为textbox会丢失value
                        var inputHidden = document.createElement("input");
                        inputHidden.type = "hidden";
                        inputHidden.id = option.targetID + "_val";
                        document.body.appendChild(inputHidden);
                    }
                    for (var k = 0; k < lookDefine.length; k++) {
                        if (option.lookupName == lookDefine[k].sOrgionName) {
                            var required = false;
                            var reqMess = "不可空!";
                            if (typeof (Page) != "undefined") {
                                var theField = $("#" + option.targetID).attr("FieldID");
                                for (var il = 0; il < Page.MainRequiredFields.length; il++) {
                                    if (theField == Page.MainRequiredFields[il].field) {
                                        required = true;
                                        break;
                                    }
                                }
                            }
                            var requiredStr = $("#" + option.targetID).attr("isRequired");
                            if (requiredStr == "true") {
                                required = true;
                            }

                            var isReadOnly = false;
                            var isDisabled = false;
                            if ($("#" + option.targetID).attr("readonly") == "readonly") {
                                isReadOnly = true;
                                $("#" + option.targetID).removeAttr("readonly");
                            }
                            if ($("#" + option.targetID).attr("disabled") == "disabled") {
                                isDisabled = true;
                                $("#" + option.targetID).removeAttr("disabled");
                            }

                            option.width = option.width == undefined ? lookDefine[k].iWidth == "" ? 500 : parseInt(lookDefine[k].iWidth) < 500 ? 500 : lookDefine[k].iWidth : option.width;
                            option.height = lookDefine[k].iHeight == "" ? 400 : lookDefine[k].iHeight;
                            option.textField = lookDefine[k].sDisplayField;
                            option.valueField = lookDefine[k].sReturnField;
                            option.pageKey = lookDefine[k].sPageField == undefined || lookDefine[k].sPageField == "" || lookDefine[k].sPageField == null ? lookDefine[k].sReturnField : lookDefine[k].sPageField;
                            option.lookupCat = "popup";
                            option.fixFilters1 = lookDefine[k].sFilters;
                            var isEdit = option.editable == undefined || option.editable == false ? false : true;


                            if (j == 0) {
                                $("#" + option.targetID).textbox({
                                    required: required,
                                    missingMessage: reqMess,
                                    invalidMessage: reqMess,
                                    buttonText: "...",
                                    readonly: isReadOnly,
                                    disabled: isDisabled,
                                    editable: isEdit,
                                    icons: [
                                        {
                                            iconCls: 'icon-clear1',
                                            handler: function (e) {
                                                var oldValue = $("#" + e.data.target.id + "_val").val();
                                                if (oldValue != "" && oldValue != undefined && oldValue != null) {
                                                    $(e.data.target).textbox("clear");
                                                    $(e.data.target.id + "_val").val("");
                                                    if (typeof (Page) != "undefined") {
                                                        if (Page.Formula) {
                                                            Page.Formula($(e.data.target).attr("FieldID"));
                                                        }
                                                    }
                                                }
                                            }

                                        }
                                    ],
                                    targetID: option.targetID,
                                    onClickButton: function () {
                                        var targetid = $(this).textbox("options").targetID;
                                        var text = $(this).textbox("textbox").val();
                                        var object = lookUp.getObjByID(targetid);
                                        lookUp.current = object;
                                        lookUp.open(text, "button");
                                    }
                                });
                                //$("#" + mainLookupOptions[j].targetID).attr("plugin", "textbox");
                                var target = option.targetID;
                                $("#" + option.targetID).textbox("textbox").attr("targetID", target);
                                $("#" + option.targetID).textbox("textbox").bind("keydown", function (e) {
                                    if (e.keyCode == 13) {
                                        var target = $(this).attr("targetID");
                                        $("#" + target).textbox("button").click();
                                        //return false;
                                    }
                                });
                                $("#" + option.targetID).textbox("textbox").bind("dblclick", function (e) {
                                    var target = $(this).attr("targetID");
                                    $("#" + target).textbox("button").click();
                                });
                            }
                            break;
                        }
                    }
                }
                this.createNew(mainObject[i]);

                if (typeof (Page) != "undefined") {
                    //                    var theFieldID = $("#" + mainObject[i].id).attr("FieldID");
                    //                    if (Page.MainRequiredFields && Page.MainRequiredFields.length > 0 && required == false) {
                    //                        for (var ii = 0; ii < Page.MainRequiredFields.length; ii++) {
                    //                            if (Page.MainRequiredFields[ii].field == theFieldID) {
                    //                                $($("#" + mainObject[i].id).textbox("textbox")).addClass("txbrequired");
                    //                                break;
                    //                            }
                    //                        }
                    //                    }
                    //                    if (Page.usetype == "add") {
                    //                        if (Page.DefaultValues[(theFieldID)]) {
                    //                            lookUp.setElementValueHead($("#" + mainObject[i].id)[0], Page.DefaultValues[(theFieldID)]);
                    //                        }
                    //                    }
                }
            }
        }
    },
    //初始化子表lookup，在Page.load中调用，因为子表需在beforeLoad中定义好
    initBody: function () {
        var table = $("[tablename]");
        var childLookupNameStr = ""; //子表lookupName字段串，提供查询.这样做的好处是只查询一次数据库，增加效率
        var childObject = []; //lookup-option数组

        for (var i = 0; i < table.length; i++) {
            var fields = $("#" + table[i].id).datagrid('getColumnFields', true).concat($("#" + table[i].id).datagrid('getColumnFields'));
            for (var j = 0; j < fields.length; j++) {
                var fieldOptions = $("#" + table[i].id).datagrid("getColumnOption", fields[j]);
                if (fieldOptions.lookupOptions) {
                    for (var k = 0; k < fieldOptions.lookupOptions.length; k++) {
                        var lookUpOption = fieldOptions.lookupOptions[k];
                        childLookupNameStr += "'" + lookUpOption.lookupName + "',";
                        fieldOptions.lookupOptions[k].targetID = table[i].id + "_" + fields[j];
                        fieldOptions.lookupOptions[k].isTableField = true;
                    }
                    var object = {
                        id: table[i].id + "_" + fields[j],
                        options: undefined
                    };
                    object.options = fieldOptions.lookupOptions;
                    childObject.push(object);
                }
            }
        }
        if (childLookupNameStr.length > 0) {
            childLookupNameStr = childLookupNameStr.substr(0, childLookupNameStr.length - 1);
        }
        var lookDefineChild;
        if (childLookupNameStr.length > 0) {
            lookDefineChild = SqlGetData({
                TableName: "bscInitLookup",
                Fields: "sOrgionName,sReturnField,sDisplayField,iHeight,iWidth,sSQL,sReturnField,sPageField,iWindow,iTree,iExtend,sRootValue,iLeaf,sParentField,sChildField,sTreeDisplayField,sFilters",
                SelectAll: "True",
                Filters: [
            {
                Field: "sOrgionName",
                ComOprt: "in",
                Value: "(" + childLookupNameStr + ")"
            }]
            });
        }
        for (var j = 0; j < childObject.length; j++) {
            if (childObject[j].options.length == 1) {
                var option = childObject[j].options[0];
                for (var k = 0; k < lookDefineChild.length; k++) {
                    if (option.lookupName == lookDefineChild[k].sOrgionName) {

                        if (lookDefineChild[k].iWindow != "1") {
                            var tableid = option.targetID.substr(0, option.targetID.indexOf("_"));
                            var columnname = option.targetID.substr(option.targetID.indexOf("_") + 1, option.targetID.length - option.targetID.indexOf("_") - 1);

                            var ColumnOption = $("#" + tableid).datagrid("getColumnOption", columnname); //返回当前列选项
                            ColumnOption.editor = {
                                type: "textbox"
                            };
                            option.width = option.width == undefined ? lookDefineChild[k].iWidth == "" ? 900 : parseInt(lookDefineChild[k].iWidth) < 900 ? 900 : lookDefineChild[k].iWidth : option.width;
                            option.height = option.height == undefined ? lookDefineChild[k].iHeight == "" ? 400 : lookDefineChild[k].iHeight : option.height;
                            option.textField = lookDefineChild[k].sDisplayField;
                            option.valueField = lookDefineChild[k].sReturnField;
                            option.pageKey = lookDefineChild[k].sPageField == "" || lookDefineChild[k].sPageField == null || lookDefineChild[k].sPageField == undefined ? lookDefineChild[k].sReturnField : lookDefineChild[k].sPageField;
                            option.lookupCat = "popup";
                            option.fixFilters1 = lookDefineChild[k].sFilters;
                            this.createNew(childObject[j]);
                        }
                        else {//不是弹窗选择,下拉和树的数据源要先取过来，不然，列中只会显示value
                            var tableid = option.targetID.substr(0, option.targetID.indexOf("_"));
                            var columnname = option.targetID.substr(option.targetID.indexOf("_") + 1, option.targetID.length - option.targetID.indexOf("_") - 1);

                            var option_defined = option;
                            var option = $("#" + tableid).datagrid("getColumnOption", columnname);


                            if (lookDefineChild[k].iTree != "1") {
                                //先获取下拉数据
                                var parms = "otype=lookup&lookupname=" + lookDefineChild[k].sOrgionName + "&filters=" + encodeURIComponent(option.lookupOptions[0].fixFilters.replace(/%/g, "%25")) + "&random=" + Math.random();
                                var result = callpostback("/Base/Handler/getDataList2.ashx", parms, false, true);
                                var dataCombobox;
                                if (result) {
                                    try {
                                        dataCombobox = eval("(" + result + ")");
                                    }
                                    catch (e) {
                                        $.messager.alert("错误", "获取表格下拉lookupname:" + lookDefineChild[k].sOrgionName + "时发生错误，" + result);
                                        continue;
                                    }
                                }

                                option.formatter = function (value, row, index) {
                                    if (value != undefined) {
                                        if (this.editor.options.multiple && this.editor.options.multiple == true) {
                                            var valueArr = value.split(",");
                                            var displayValue = "";
                                            for (var i = 0; i < valueArr.length; i++) {
                                                for (var j = 0; j < this.editor.options.data.length; j++) {
                                                    if (valueArr[i] == this.editor.options.data[j][(this.editor.options.valueField)]) {
                                                        displayValue += this.editor.options.data[j][(this.editor.options.textField)] + ",";
                                                        break;
                                                    }
                                                }
                                            }
                                            if (displayValue != "") {
                                                displayValue = displayValue.substr(0, displayValue.length - 1);
                                            }
                                            return displayValue;
                                        }
                                        else {
                                            for (var i = 0; i < this.editor.options.data.length; i++) {
                                                if (this.editor.options.data[i][(this.editor.options.valueField)] == value) {
                                                    return this.editor.options.data[i][(this.editor.options.textField)];
                                                }
                                            }
                                        }
                                    }
                                    return "";
                                };

                                option.editor = {
                                    type: "combobox",
                                    options: {
                                        targetID: tableid + "_" + columnname,
                                        multiple: option_defined.isMulti == undefined ? false : option_defined.isMulti,
                                        editable: option_defined.editable == undefined ? false : option_defined.editable,
                                        panelWidth: option_defined.width == undefined ? lookDefineChild[k].width == "" ? null : lookDefineChild[k].width : option_defined.width,
                                        panelHeight: option_defined.height == undefined ? lookDefineChild[k].height == "" ? null : lookDefineChild[k].height : option_defined.height,
                                        valueField: lookDefineChild[k].sReturnField,
                                        textField: lookDefineChild[k].sDisplayField,
                                        height: tdTxbHeight,
                                        icons: [
                                        {
                                            iconCls: 'icon-clear1',
                                            handler: function (e) {
                                                $(e.data.target).textbox("clear");
                                            }
                                        }
                                        ],
                                        //url: "/Base/Handler/getDataList2.ashx",
                                        data: dataCombobox,
                                        loadFilter: option_defined.loadFilters,
                                        formatter: function (row) {
                                            var opts = $(this).combobox('options');
                                            if (opts.multiple == true) {
                                                return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField];
                                            }
                                            else {
                                                return row[opts.textField];
                                            }
                                        },
                                        onShowPanel: function () {
                                            var opts = $(this).combobox('options');
                                            if (opts.multiple == true) {
                                                var target = this;
                                                var values = $(target).combobox('getValues');
                                                $.map(values, function (value) {
                                                    var el = opts.finder.getEl(target, value);
                                                    el.find('input.combobox-checkbox')._propAttr('checked', true);
                                                })
                                            }
                                        },
                                        onLoadSuccess: function () {
                                            var opts = $(this).combobox('options');
                                            if (opts.multiple == true) {
                                                var target = this;
                                                var values = $(target).combobox('getValues');
                                                $.map(values, function (value) {
                                                    var el = opts.finder.getEl(target, value);
                                                    el.find('input.combobox-checkbox')._propAttr('checked', true);
                                                })
                                            }
                                        },
                                        onSelect: function (row) {
                                            //console.log(row);
                                            var opts = $(this).combobox('options');
                                            if (opts.multiple == true) {
                                                var el = opts.finder.getEl(this, row[opts.valueField]);
                                                el.find('input.combobox-checkbox')._propAttr('checked', true);
                                            }
                                        },
                                        onUnselect: function (row) {
                                            var opts = $(this).combobox('options');
                                            if (opts.multiple == true) {
                                                var el = opts.finder.getEl(this, row[opts.valueField]);
                                                el.find('input.combobox-checkbox')._propAttr('checked', false);
                                            }
                                        }
                                    }
                                };
                            }
                            else {
                                //先获取下拉数据
                                var parms = "otype=lookup&lookupname=" + lookDefineChild[k].sOrgionName + "&random=" + Math.random();
                                var result = callpostback("/Base/Handler/getDataList2.ashx", parms, false, true);
                                var dataCombotree;
                                if (result) {
                                    try {
                                        dataCombotree = eval("(" + result + ")");
                                    }
                                    catch (e) {
                                        $.messager.alert("错误", "获取表格下拉lookupname:" + lookDefineChild[k].sOrgionName + "时发生错误");
                                        continue;
                                    }
                                }

                                option.formatter = function (value, row, index) {
                                    var getText = function (dataC, value) {
                                        for (var i = 0; i < dataC.length; i++) {
                                            if (dataC[i].id == value) {
                                                return dataC[i].text;
                                            }
                                            else {
                                                if (dataC[i].children && dataC[i].children.length > 0) {
                                                    getText(dataC[i].children, value);
                                                }
                                            }
                                        }
                                        return undefined;
                                    };
                                    if (value != undefined) {
                                        if (this.editor.options.multiple && this.editor.options.multiple == true) {
                                            var valueArr = value.split(',');
                                            var displayValue = "";
                                            for (var i = 0; i < valueArr.length; i++) {
                                                for (var j = 0; j < this.editor.options.data.length; j++) {
                                                    if (this.editor.options.data[j].id == value) {
                                                        displayValue += this.editor.options.data[j].text + ",";
                                                        break;
                                                    }
                                                    else {
                                                        if (this.editor.options.data[j].children && this.editor.options.data[j].children.length > 0) {
                                                            //return getText(this.editor.options.data[i].children, value);
                                                            var text = getText(this.editor.options.data[j].children, value);
                                                            if (text != undefined) {
                                                                displayValue += text + ",";
                                                            }
                                                            else {
                                                                displayValue += ",";
                                                            }
                                                        }
                                                        break;
                                                    }
                                                }
                                            }
                                            if (displayValue != "") {
                                                displayValue = displayValue.substr(0, displayValue.length - 1);
                                            }
                                            return displayValue;
                                        }
                                        else {
                                            for (var i = 0; i < this.editor.options.data.length; i++) {
                                                if (this.editor.options.data[i].id == value) {
                                                    return this.editor.options.data[i].text;
                                                }
                                                else {
                                                    if (this.editor.options.data[i].children && this.editor.options.data[i].children.length > 0) {
                                                        //return getText(this.editor.options.data[i].children, value);
                                                        var text = getText(this.editor.options.data[i].children, value);
                                                        if (text != undefined) {
                                                            return text;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    return "";
                                };
                                option.editor = {
                                    type: "combotree",
                                    options: {
                                        targetID: tableid + "_" + columnname,
                                        onlyLeafCheck: option_defined.onlyLeafCheck == undefined ? false : option_defined.onlyLeafCheck,
                                        //checkbox: true,
                                        multiple: option_defined.isMulti == undefined ? false : option_defined.isMulti,
                                        editable: option_defined.editable == undefined ? false : option_defined.editable,
                                        panelWidth: option_defined.width == undefined ? lookDefineChild[k].width == "" ? null : lookDefineChild[k].width : option_defined.width,
                                        panelHeight: option_defined.height == undefined ? lookDefineChild[k].height == "" ? null : lookDefineChild[k].height : option_defined.height,
                                        valueField: lookDefineChild[k].sReturnField,
                                        textField: lookDefineChild[k].sDisplayField,
                                        height: tdTxbHeight,
                                        icons: [
                                        {
                                            iconCls: 'icon-clear1',
                                            handler: function (e) {
                                                $(e.data.target).textbox("clear");
                                            }

                                        }
                                        ],
                                        data: dataCombotree,
                                        loadFilter: option_defined.loadFilters
                                        /*formatter: function (node) {
                                        return node.text;
                                        }*/
                                    }
                                }
                            }
                        }
                        break;
                    }

                }
            }
            else {
                for (var l = 0; l < childObject[j].options.length; l++) {
                    var option = childObject[j].options[l];
                    for (var k = 0; k < lookDefineChild.length; k++) {
                        if (option.lookupName == lookDefineChild[k].sOrgionName) {
                            var tableid = option.targetID.substr(0, option.targetID.indexOf("_"));
                            var columnname = option.targetID.substr(option.targetID.indexOf("_") + 1, option.targetID.length - option.targetID.indexOf("_") - 1);

                            var ColumnOption = $("#" + tableid).datagrid("getColumnOption", columnname); //返回当前列选项
                            ColumnOption.editor = {
                                type: "textbox"
                            };
                            option.width = option.width == undefined ? lookDefineChild[k].iWidth == "" ? 500 : parseInt(lookDefineChild[k].iWidth) < 500 ? 500 : lookDefineChild[k].iWidth : option.width;
                            option.height = option.height == undefined ? lookDefineChild[k].iHeight == "" ? 400 : parseInt(lookDefineChild[k].iHeight) < 500 ? 500 : lookDefineChild[k].iHeight : option.height;
                            option.textField = lookDefineChild[k].sDisplayField;
                            option.valueField = lookDefineChild[k].sReturnField;
                            option.pageKey = lookDefineChild[k].sPageField == "" || lookDefineChild[k].sPageField == null || lookDefineChild[k].sPageField == undefined ? lookDefineChild[k].sReturnField : lookDefineChild[k].sPageField;
                            option.lookupCat = "popup";
                            option.fixFilters1 = lookDefineChild[k].sFilters;
                        }
                    }
                }
                this.createNew(childObject[j]);
            }
        }
    },
    createNew: function (obj) {
        var object = {
            id: undefined,
            lookUpObjs: []
        };
        object.id = obj.id;
        var lookUpCat = "0";
        for (var i = 0; i < obj.options.length; i++) {
            var option = obj.options[i];
            if (lookUpCat == "0") {
                lookUpCat = option.lookupCat;
            }
            else {
                if (lookUpCat != option.lookupCat) {
                    var cc = $("#" + object.id).attr("FieldID");
                    $.messager.alert("错误", "字段[" + object.id + "]的lookUp类型必须一致！");
                    return;
                }
            }
            //["aa=bb"]
            var lookUpObj = {
                condition: option.condition,
                uniqueid: option.uniqueid,
                lookupName: option.lookupName, //对应的lookupname
                fields: option.fields == undefined ? "*" : option.fields,  //要选择的所有字段名
                searchFields: option.searchFields == undefined ? option.fields : option.searchFields,  //要作为查询条件的字段
                targetID: option.targetID, //目标控件ID，如果是子表，则是tableid+'_'+列名
                //type : option.type == undefined ? "field" : option.type,  //类型：1、field，表示返回到字段。此时如果单选，可以通过MatchField返回其他字段值；如果多选只能返回到当前字段的值，以，隔开。2、table表示返回到表格。
                matchFields: option.matchFields, //如果type=field，则表示其他对应字段，源在前，返回的值在后。如果type=table，则表示对应字段，本字段也需要标明
                editMatchFields: option.editMatchFields, //如果type=field，则表示其他对应字段，源在前，返回的值在后。如果type=table，则表示对应字段，本字段也需要标明
                isMulti: option.isMulti == undefined ? false : option.isMulti,  //是否多选，type=field的多选，matchField失效
                //isCover : option.isCover == undefined ? false : option.isCover,  //是否覆盖原数据，只对type=table有效
                fixFilters: option.fixFilters == undefined ? "1=1" : option.fixFilters, //固定过滤条件
                fixFilters1: option.fixFilters1 == undefined || option.fixFilters1 == null ? "" : option.fixFilters1,
                nofixFilters: option.nofixFilters == undefined ? "1=1" : option.nofixFilters, //不固定过滤条件，在选择界面点查询后将覆盖此条件
                pageSize: option.pageSize == undefined ? 20 : option.pageSize, //一页显示的行数,默认为20
                width: option.width, //窗口宽度，默认600
                height: option.height, //窗口高度，默认400
                valueField: option.valueField, //值字段，仅对主表子段有效
                textField: option.textField, //显示字段，仅对主表子段有效
                closeOnSelect: option.closeOnSelect == undefined ? false : option.closeOnSelect,  //是否选择后关闭窗口
                onBeforeOpen: option.onBeforeOpen, //打开前执行
                onAfterSelected: option.onAfterSelected, //选择后执行
                isTableField: option.isTableField, //表示是否是子表的列
                lookupCat: option.lookupCat, //lookup的类型，有popup，combobox,comboxtree，但是此处只能是undefined或者popup
                pageKey: option.pageKey,
                isImport: option.isImport, //是否是导入按钮
                isTopImport:undefined,
                setValues: function (data) {
                    if (lookUp.beforeSetValue) {
                        //在设置数据之前执行lookUp.beforeSetValue
                        var dataProc = lookUp.beforeSetValue(this.uniqueid, data);
                        if (dataProc == false) {
                            return false;
                        }
                        if (dataProc) {
                            data = dataProc;
                        }
                    }
                    //if (this.type == "field") {
                    if (this.isTableField != true) {
                        if (this.isMulti == false) {
                            $("#" + this.targetID).textbox("setValue", data[(this.valueField)]);
                            $("#" + this.targetID).textbox("setText", data[(this.textField)]);
                            $("#" + this.targetID + "_val").val(data[(this.valueField)]);

                            if (this.matchFields && this.matchFields!="") {
                                lookUp.matchFieldsValueSetHead(this.matchFields, $("#" + this.targetID), data);
                            }
                        }
                        else {
                            var values = "";
                            for (var i = 0; i < data.length; i++) {
                                values += data[i][this.valueField] + ",";
                            }
                            if (values.length > 0) {
                                values = values.substr(0, values.length - 1);
                            }
                            var originalValue = $("#" + this.targetID).textbox("getValue");
                            originalValue = originalValue != "" ? originalValue + "," : "";
                            $("#" + this.targetID).textbox("setValue", originalValue + values);
                            var originalValueVal = $("#" + this.targetID + "_val").val();
                            originalValueVal = originalValueVal != "" ? originalValueVal + "," : "";
                            $("#" + this.targetID + "_val").val(originalValueVal + values);
                        }
                    }
                    else {
                        if (this.isImport) {//如果是导入按钮
                            if (this.isMulti == false) {
                                var appData = {};
                                var mainDataReadyToSet = [];                                
                                for (var i = 0; i < this.matchFields.length; i++) {
                                    var ofield = this.matchFields[i].toString().split('=')[0];
                                    var rfield = this.matchFields[i].toString().split('=')[1];
                                    var value = "";
                                    if (rfield[0] == "{" && rfield[rfield.length - 1] == "}") {
                                        var theExpress = rfield.substr(1, rfield.length - 2);
                                        try {
                                            value = eval(theExpress);
                                        } catch (e) {
                                            value = theExpress;
                                        }
                                    }
                                    else{
                                        value = data[(rfield)];
                                    }
                                    if (ofield.length > 2 && ofield.substr(0, 2) == "m.") {
                                        if (typeof (Page) != "undefined") {
                                            var tField = ofield.substr(2);
                                            //Page.setFieldValue(tField, value);
                                            mainDataReadyToSet.push({ field: tField, value: value });
                                        }
                                    } else {
                                        appData[ofield] = value;
                                    }
                                }
                                //在设置每一行数据之前执行lookUp.beforeSetRowValue
                                if (lookUp.beforeSetRowValue) {
                                    var result = lookUp.beforeSetRowValue(this.uniqueid, 0, data, appData);
                                    if (result == false) {
                                        return false;
                                    }
                                    if (result) {
                                        appData = result;
                                    }
                                }
                                for (var z = 0; z < mainDataReadyToSet.length; z++) {
                                    if (typeof (Page) != "undefined") {
                                        Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                                    }
                                }
                                Page.tableToolbarClick("add", this.targetID.split('`')[0], appData);
                                var rowIndex = $("#" + this.targetID.split('`')[0]).datagrid("getRows").length - 1;
                                //在设置每一行数据之后执行lookUp.afterSetRowValue
                                if (lookUp.afterSetRowValue) {
                                    var result = lookUp.afterSetRowValue(this.uniqueid, 0, data, appData, rowIndex);
                                    if (result == false) {
                                        return false;
                                    }
                                }
                            }
                            else {
                                var tableid = this.targetID.substr(0, this.targetID.indexOf("`"));
                                var tableName = $("#" + tableid).attr("serialTableName");
                                var nextID = getTableZoneID(tableName, data.length);
                                if (nextID == -1) {
                                    alert("导入失败，获取主键失败");
                                    return;
                                }
                                for (var i = 0; i < data.length; i++) {
                                    var appData = {};
                                    var mainDataReadyToSet = [];
                                    for (var j = 0; j < this.matchFields.length; j++) {
                                        var ofield = this.matchFields[j].toString().split('=')[0];
                                        var rfield = this.matchFields[j].toString().split('=')[1];
                                        var value = "";
                                        if (rfield[0] == "{" && rfield[rfield.length - 1] == "}") {
                                            var theExpress = rfield.substr(1, rfield.length - 2);
                                            try {
                                                value = eval(theExpress);
                                            } catch (e) {
                                                value = theExpress;
                                            }
                                        }
                                        else {
                                            value = data[i][(rfield)];
                                        }
                                        if (ofield.length > 2 && ofield.substr(0, 2) == "m.") {
                                            if (typeof (Page) != "undefined") {
                                                var tField = ofield.substr(2);
                                                //Page.setFieldValue(tField, value);
                                                mainDataReadyToSet.push({ field: tField, value: value });
                                            }
                                        } else {
                                            appData[ofield] = value;
                                        }
                                    }
                                    //在设置每一行数据之前执行lookUp.beforeSetRowValue
                                    if (lookUp.beforeSetRowValue) {
                                        var result = lookUp.beforeSetRowValue(this.uniqueid, i, data, appData);
                                        if (result == false) {
                                            return false;
                                        }
                                        if (result) {
                                            appData = result;
                                        }
                                    }
                                    for (var z = 0; z < mainDataReadyToSet.length; z++) {
                                        if (typeof (Page) != "undefined") {
                                            Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                                        }
                                    }

                                    Page.tableToolbarClick("add", this.targetID.split('`')[0], appData, parseInt(nextID) + parseInt(i));
                                    var rowIndex = $("#" + this.targetID.split('`')[0]).datagrid("getRows").length - 1;
                                    //在设置每一行数据之后执行lookUp.afterSetRowValue
                                    if (lookUp.afterSetRowValue) {
                                        var result = lookUp.afterSetRowValue(this.uniqueid, i, data, appData, rowIndex);
                                        if (result == false) {
                                            return false;
                                        }
                                    }
                                }
                                var SummaryFields;
                                if (typeof (Page) != "undefined") {
                                    var DynSummaryFields = Page.Children.GetDynSummryFields(tableid);
                                    if (DynSummaryFields.length > 0) {
                                        SummaryFields = Page.Children.SummaryFields.concat(DynSummaryFields);
                                    }
                                    else {
                                        SummaryFields = Page.Children.SummaryFields;
                                    }
                                    $('#' + tableid).datagrid('reloadFooter', Page.getChildFootData(tableid, SummaryFields));
                                }

                            }
                        }
                        else {
                            var currtEditor = $(datagridOp.current).datagrid("getEditor", {
                                index: datagridOp.currentRowIndex,
                                field: datagridOp.currentColumnName
                            });

                            if (this.isMulti == false) {
                                var tableid = this.targetID.substr(0, this.targetID.indexOf("_"));
                                if (this.matchFields) {
                                    var otherData = {};
                                    var mainDataReadyToSet = [];
                                    for (var i = 0; i < this.matchFields.length; i++) {
                                        var ofield = this.matchFields[i].toString().split('=')[0];
                                        var rfield = this.matchFields[i].toString().split('=')[1];
                                        var value = "";
                                        if (rfield[0] == "{" && rfield[rfield.length - 1] == "}") {
                                            var theExpress = rfield.substr(1, rfield.length - 2);
                                            try {
                                                value = eval(theExpress);
                                            } catch (e) {
                                                value = theExpress;
                                            }
                                        }
                                        else {
                                            value = data[(rfield)];
                                        }
                                        if (ofield.length > 2 && ofield.substr(0, 2) == "m.") {
                                            if (typeof (Page) != "undefined") {
                                                var tField = ofield.substr(2);
                                                mainDataReadyToSet.push({ field: tField, value: value });
                                                //Page.setFieldValue(tField, value);
                                            }
                                        } else {
                                            otherData[ofield] = value;
                                        }
                                        //otherData[ofield] = data[(rfield)];
                                    }
                                    //在设置每一行数据之前执行lookUp.beforeSetRowValue
                                    if (lookUp.beforeSetRowValue) {
                                        var result = lookUp.beforeSetRowValue(this.uniqueid, 0, data, otherData);
                                        if (result == false) {
                                            return false;
                                        }
                                        if (result) {
                                            otherData = result;
                                        }
                                    }
                                    for (var z = 0; z < mainDataReadyToSet.length; z++) {
                                        if (typeof (Page) != "undefined") {
                                            Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                                        }
                                    }
                                    $(datagridOp.current).datagrid("updateRow", { index: datagridOp.currentRowIndex, row: otherData });
                                    //在设置每一行数据之后执行lookUp.afterSetRowValue
                                    if (lookUp.afterSetRowValue) {
                                        var result = lookUp.afterSetRowValue(this.uniqueid, 0, data, otherData, datagridOp.currentRowIndex);
                                        if (result == false) {
                                            return false;
                                        }
                                    }
                                }
                                var SummaryFields;
                                if (typeof (Page) != "undefined") {
                                    var DynSummaryFields = Page.Children.GetDynSummryFields(tableid);
                                    if (DynSummaryFields.length > 0) {
                                        SummaryFields = Page.Children.SummaryFields.concat(DynSummaryFields);
                                    }
                                    else {
                                        SummaryFields = Page.Children.SummaryFields;
                                    }
                                    $('#' + tableid).datagrid('reloadFooter', Page.getChildFootData(tableid, SummaryFields));
                                }
                                //$('#' + tableid).datagrid('reloadFooter', Page.getChildFootData(tableid, Page.Children.SummaryFields));
                            }
                            else {
                                if (data.length == undefined) {
                                    data = [data];
                                }
                                var rowCounts = $(datagridOp.current).datagrid("getRows").length;
                                var currentRowIndex = datagridOp.currentRowIndex;
                                var iZoneCount = data.length - (rowCounts - currentRowIndex);
                                var tableid = this.targetID.substr(0, this.targetID.indexOf("_"));
                                var tableName = $("#" + tableid).attr("serialTableName");
                                var nextID = undefined;
                                if (iZoneCount > 0) {
                                    nextID = getTableZoneID(tableName, iZoneCount);
                                    if (nextID == -1) {
                                        alert("导入失败，获取主键失败");
                                        return false;
                                    }
                                }
                                for (var i = 0; i < data.length; i++) {
                                    var appData = {};
                                    if (this.matchFields) {
                                        if (i == 0) {
                                            var mainDataReadyToSet = [];
                                            for (var j = 0; j < this.matchFields.length; j++) {
                                                var ofield = this.matchFields[j].toString().split('=')[0];
                                                var rfield = this.matchFields[j].toString().split('=')[1];

                                                var value = "";
                                                if (rfield[0] == "{" && rfield[rfield.length - 1] == "}") {
                                                    var theExpress = rfield.substr(1, rfield.length - 2);
                                                    try {
                                                        value = eval(theExpress);
                                                    } catch (e) {
                                                        value = theExpress;
                                                    }
                                                }
                                                else {
                                                    value = data[i][(rfield)];
                                                }
                                                if (ofield.length > 2 && ofield.substr(0, 2) == "m.") {
                                                    if (typeof (Page) != "undefined") {
                                                        var tField = ofield.substr(2);
                                                        mainDataReadyToSet.push({ field: tField, value: value });
                                                        //Page.setFieldValue(tField, value);
                                                    }
                                                } else {
                                                    appData[ofield] = value;
                                                }
                                                //appData[ofield] = data[i][(rfield)];
                                            }
                                            //在设置每一行数据之前执行lookUp.beforeSetRowValue
                                            if (lookUp.beforeSetRowValue) {
                                                var result = lookUp.beforeSetRowValue(this.uniqueid, i, data, appData);
                                                if (result == false) {
                                                    return false;
                                                }
                                                if (result) {
                                                    appData = result;
                                                }
                                            }
                                            for (var z = 0; z < mainDataReadyToSet.length; z++) {
                                                if (typeof (Page) != "undefined") {
                                                    Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                                                }
                                            }
                                            $(datagridOp.current).datagrid("updateRow", { index: datagridOp.currentRowIndex, row: appData });

                                            //在设置每一行数据之后执行lookUp.afterSetRowValue
                                            if (lookUp.afterSetRowValue) {
                                                var result = lookUp.afterSetRowValue(this.uniqueid, i, data, appData, datagridOp.currentRowIndex);
                                                if (result == false) {
                                                    return false;
                                                }
                                            }
                                        }
                                        else {
                                            var mainDataReadyToSet = [];
                                            for (var j = 0; j < this.matchFields.length; j++) {
                                                var ofield = this.matchFields[j].toString().split('=')[0];
                                                var rfield = this.matchFields[j].toString().split('=')[1];
                                                var value = "";
                                                if (rfield[0] == "{" && rfield[rfield.length - 1] == "}") {
                                                    var theExpress = rfield.substr(1, rfield.length - 2);
                                                    try {
                                                        value = eval(theExpress);
                                                    } catch (e) {
                                                        value = theExpress;
                                                    }
                                                }
                                                else {
                                                    value = data[i][(rfield)];
                                                }
                                                if (ofield.length > 2 && ofield.substr(0, 2) == "m.") {
                                                    if (typeof (Page) != "undefined") {
                                                        var tField = ofield.substr(2);
                                                        mainDataReadyToSet.push({ field: tField, value: value });
                                                        //Page.setFieldValue(tField, value);
                                                    }
                                                } else {
                                                    appData[ofield] = value;
                                                }
                                                //appData[ofield] = data[i][(rfield)];
                                            }

                                            var rowIndex = 0;
                                            //在设置每一行数据之前执行lookUp.beforeSetRowValue
                                            if (lookUp.beforeSetRowValue) {
                                                var result = lookUp.beforeSetRowValue(this.uniqueid, i, data, appData);
                                                if (result == false) {
                                                    return false;
                                                }
                                                if (result) {
                                                    appData = result;
                                                }
                                            }
                                            for (var z = 0; z < mainDataReadyToSet.length; z++) {
                                                if (typeof (Page) != "undefined") {
                                                    Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                                                }
                                            }
                                            if (currentRowIndex + i < rowCounts) {
                                                $(datagridOp.current).datagrid("updateRow", {
                                                    index: currentRowIndex + i,
                                                    row: appData
                                                });
                                                rowIndex = currentRowIndex + 1;
                                            }
                                            else {
                                                var isetp = parseInt(nextID) + parseInt((currentRowIndex + i)) - parseInt(rowCounts);
                                                Page.tableToolbarClick("add", datagridOp.current.id, appData, isetp);
                                                rowIndex = rowCounts - 1 + i;
                                            }
                                            //在设置每一行数据之后执行lookUp.afterSetRowValue
                                            if (lookUp.afterSetRowValue) {
                                                var result = lookUp.afterSetRowValue(this.uniqueid, i, data, appData, rowIndex);
                                                if (result == false) {
                                                    return false;
                                                }
                                            }
                                        }
                                    }
                                }
                                var SummaryFields;
                                if (typeof (Page) != "undefined") {
                                    var DynSummaryFields = Page.Children.GetDynSummryFields(tableid);
                                    if (DynSummaryFields.length > 0) {
                                        SummaryFields = Page.Children.SummaryFields.concat(DynSummaryFields);
                                    }
                                    else {
                                        SummaryFields = Page.Children.SummaryFields;
                                    }
                                    $('#' + tableid).datagrid('reloadFooter', Page.getChildFootData(tableid, SummaryFields));
                                }
                                //$('#' + tableid).datagrid('reloadFooter', Page.getChildFootData(tableid, Page.Children.SummaryFields));
                            }
                        }
                    }
                    if (lookUp.isTopImport == undefined) {
                        if (lookUp.isPopupOpen) {
                            try {
                                if (this.isMulti == false) {
                                    $("#divlookUp").dialog("close");
                                    lookUp.isPopupOpen = false;
                                }
                                if (this.isMulti == true && this.closeOnSelect == true) {
                                    $("#divlookUp").dialog("close");
                                }
                                if (data.length == 1) {
                                    lookUp.isPopupOpen = false;
                                }
                            }
                            catch (e) {
                                lookUp.isPopupOpen = false;
                            }
                        }
                    }
                    if (this.onAfterSelected) {
                        this.onAfterSelected(data);
                    }
                    if (lookUp.afterSelected) {
                        lookUp.afterSelected(this.uniqueid, data);
                    }
                    if (typeof (Page) != "undefined") {
                        if (this.isImport != true && this.isTableField != true) {
                            if (Page.Children.HasDynColumns == true) {
                                var fieldID = $("#" + this.targetID).attr("FieldID");
                                for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
                                    if (fieldID == Page.Children.DynColumnsDefined[i].triggerField) {
                                        var tableName = Page.Children.DynColumnsDefined[i].tableName;
                                        Page.Children.ShowDynColumns(tableName, data[(this.valueField)]);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                },
                parseMainFieldValue: function (text, isOpenWindow) {
                    var fixfilters = "1=1";
                    var fixfilters1 = "";
                    var nofixFilters = "1=1";
                    if (this.fixFilters && this.fixFilters != undefined && this.fixFilters != null) {
                        if (typeof (Page) != "undefined") {
                            fixfilters = Page.parseMainField(this.fixFilters.replace(/{this}/g, text));
                        }
                        else {
                            fixfilters = this.fixFilters.replace(/{this}/g, text).replace(/&apos;/g, "'");
                            if (typeof (FormList) != "undefined") {
                                fixfilters = FormList.parseLookupField(fixfilters);
                            }
                        }
                    }
                    if (this.fixFilters1 != "" && this.fixFilters1 != undefined && this.fixFilters1 != null) {
                        if (typeof (Page) != "undefined") {
                            fixfilters1 = Page.parseMainField(this.fixFilters1.replace(/{this}/g, text));
                        }
                        else {
                            fixfilters1 = this.fixFilters1.replace(/{this}/g, text).replace(/&apos;/g, "'");
                            if (typeof (FormList) != "undefined") {
                                fixfilters1 = FormList.parseLookupField(fixfilters1);
                            }
                        }
                    }
                    if (isOpenWindow != true) {
                        if (this.nofixFilters && this.nofixFilters != undefined && this.nofixFilters != null) {
                            if (typeof (Page) != "undefined") {
                                nofixFilters = Page.parseMainField(this.nofixFilters.replace(/{this}/g, text));
                            }
                            else {
                                nofixFilters = this.nofixFilters.replace(/{this}/g, text).replace(/&apos;/g, "'");;
                                if (typeof (FormList) != "undefined") {
                                    nofixFilters = FormList.parseLookupField(nofixFilters);
                                }
                            }
                        }
                    }
                    if (fixfilters1 != "") {
                        fixfilters += " and " + fixfilters1;
                    }
                    return fixfilters + " and (" + nofixFilters + ")";
                },
                parseChildFieldValue: function (text, isOpenWindow) {
                    var fixfilters = "1=1";
                    var fixfilters1 = "";
                    var nofixFilters = "1=1";
                    if (this.fixFilters && this.fixFilters != undefined && this.fixFilters != null) {
                        fixfilters = this.fixFilters;
                        if (this.isImport != true) {
                            if (typeof (Page) != "undefined") {
                                fixfilters = Page.parseChildField(fixfilters.replace(/{this}/g, text), datagridOp.current.id, datagridOp.currentRowIndex);
                            }
                            else {
                                fixfilters = fixfilters.replace(/{this}/g, text);
                            }
                        }
                        else {
                            if (typeof (Page) != "undefined") {
                                fixfilters = Page.parseMainField(fixfilters.replace(/{this}/g, text).replace(/m\./g, ""));
                            }
                            else {
                                fixfilters = fixfilters.replace(/{this}/g, text).replace(/m\./g, "");
                            }
                        }
                    }
                    if (this.fixFilters1 != "") {
                        fixfilters1 = this.fixFilters1;
                        if (this.isImport != true) {
                            if (typeof (Page) != "undefined") {
                                fixfilters1 = Page.parseChildField(fixfilters1.replace(/{this}/g, text), datagridOp.current.id, datagridOp.currentRowIndex);
                            }
                            else {
                                fixfilters1 = fixfilters1.replace(/{this}/g, text);
                            }
                        }
                        else {
                            if (typeof (Page) != "undefined") {
                                fixfilters1 = Page.parseMainField(fixfilters1.replace(/{this}/g, text).replace(/m\./g, ""));
                            }
                            else {
                                fixfilters1 = fixfilters1.replace(/{this}/g, text).replace(/m\./g, "");
                            }
                        }
                    }
                    if (isOpenWindow != true) {
                        if (this.nofixFilters && this.nofixFilters != undefined && this.nofixFilters != null) {
                            nofixFilters = this.nofixFilters;
                            if (this.isImport != true) {
                                if (typeof (Page) != "undefined") {
                                    nofixFilters = Page.parseChildField(nofixFilters.replace(/{this}/g, text), datagridOp.current.id, datagridOp.currentRowIndex);
                                }
                                else {
                                    nofixFilters = nofixFilters.replace(/{this}/g, text);
                                }
                            }
                            else {
                                if (typeof (Page) != "undefined") {
                                    nofixFilters = Page.parseMainField(nofixFilters.replace(/{this}/g, text).replace(/m\./g, ""));
                                }
                                else {
                                    nofixFilters = nofixFilters.replace(/{this}/g, text).replace(/m\./g, "");
                                }
                            }
                        }
                    }
                    if (fixfilters1 != "") {
                        fixfilters += " and " + fixfilters1;
                    }
                    return fixfilters + " and (" + nofixFilters + ")";
                }
            };
            object.lookUpObjs.push(lookUpObj);
        }
        this.lists.push(object);
    },
    getObjByTargetId: function (id) {
        for (var i = 0; i < this.lists.length; i++) {
            if (this.lists[i].targetID == id) {
                return this.lists[i];
            }
        }
    },
    getObjByID: function (id) {
        for (var i = 0; i < this.lists.length; i++) {
            if (this.lists[i].id == id) {
                return this.lists[i];
            }
        }
    },
    getLookUpObjByID: function (id) {
        var object = this.getObjByID(id);
        if (object) {
            if (object.lookUpObjs.length == 1) {
                return object.lookUpObjs[0];
            }
            for (var i = 0; i < object.lookUpObjs.length; i++) {
                if (object.lookUpObjs[i].condition != undefined) {
                    var result = object.lookUpObjs[i].condition();
                    if (result == true) {
                        if (lookUp.IsConditionFit) {
                            var resultFit = lookUp.IsConditionFit(object.lookUpObjs[i].uniqueid);
                            if (resultFit == true) {
                                return object.lookUpObjs[i];
                            }
                        }
                        else {
                            return object.lookUpObjs[i];
                        }
                    }
                }
                else {
                    if (lookUp.IsConditionFit) {
                        var resultFit = lookUp.IsConditionFit(object.lookUpObjs[i].uniqueid);
                        if (resultFit == true) {
                            return object.lookUpObjs[i];
                        }
                    }
                    else {
                        return object.lookUpObjs[i];
                    }
                }
            }
        }
        return undefined;
    },
    getLookUpObjByCurrent: function () {
        var object = this.current;
        if (object) {
            if (object.lookUpObjs.length == 1) {
                return object.lookUpObjs[0];
            }
            for (var i = 0; i < object.lookUpObjs.length; i++) {
                if (object.lookUpObjs[i].condition != undefined) {
                    var result = object.lookUpObjs[i].condition();
                    if (result == true) {
                        if (lookUp.IsConditionFit) {
                            var resultFit = lookUp.IsConditionFit(object.lookUpObjs[i].uniqueid);
                            if (resultFit == true) {
                                return object.lookUpObjs[i];
                            }
                        }
                        else {
                            return object.lookUpObjs[i];
                        }
                    }
                }
                else {
                    if (lookUp.IsConditionFit) {
                        var resultFit = lookUp.IsConditionFit(object.lookUpObjs[i].uniqueid);
                        if (resultFit == true) {
                            return object.lookUpObjs[i];
                        }
                    }
                    else {
                        return object.lookUpObjs[i];
                    }
                }
            }
        }
        return undefined;
    },
    //有lookup数据初始化
    load: function () {
        var elementwithlookup = $("[lookupOptions]");
        for (var i = 0; i < elementwithlookup.length; i++) {
            if (elementwithlookup[i].attributes["FieldID"]) {
                var plugin = $(elementwithlookup[i]).attr("plugin");
                if ($(elementwithlookup[i]).attr("plugin") && $(elementwithlookup[i]).attr("plugin") != "textbox") {
                    continue;
                }
                var lookUpObj = this.getObjByID(elementwithlookup[i].id);
                if (lookUpObj) {
                    var value = $(elementwithlookup[i]).textbox("getValue");
                    if (value != "") {
                        lookUp.setElementValueHead(elementwithlookup[i], value, true);
                    }
                }
            }
        }
    },
    //针对主表textbox型lookup
    setElementValueHead: function (element, value, isInit) {
        $("#" + element.id + "_val").val(value);
        var lookupOptions = this.getLookUpObjByID(element.id);
        if (lookupOptions.lookupName != "") {
            //            if (value.length == 0) {
            //                return;
            //            }
            var jsonfilter = [{
                "Field": "sOrgionName",
                "ComOprt": "=",
                "Value": "'" + lookupOptions.lookupName + "'"
            }];
            var jsonobj = {
                "TableName": "bscInitLookup",
                "Fields": "iWindow,iHeight,iWidth,sControlName,sDisplayField,sReturnField,sOrgionName",
                "SelectAll": "True",
                "Filters": jsonfilter
            }
            var url = "/Base/Handler/DataBuilder.ashx";
            var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj));
            var async = false;
            var ispost = true;
            var result = callpostback(url, parms, async, ispost);
            if (result && result.length > 0) {
                if (result.indexOf("error:") > -1) {
                    $.messager.alert("错误", "lookUp初始化时出错：" + result.substr(6, result.length - 6));
                    return;
                }
                try {
                    var jsonresultobj = JSON2.parse(result);
                    if (jsonresultobj.Rows[0].iWindow != "1") {
                        var filters = jsonresultobj.Rows[0].sReturnField + "='" + document.getElementById(element.id).value + "'";

                        parms = "plugintype=combobox&ctype=text&sqlqueryobj=" + jsonresultobj.Rows[0].sOrgionName + "&filters=" + filters;
                        var async = false;
                        //var ispost = true;
                        var resultdetail = callpostback(url, parms, async, ispost);

                        if (resultdetail.length > 0) {
                            if (resultdetail.indexOf("error:") > -1) {
                                $.messager.alert("错误", "lookUp初始化时出错：" + resultdetail.substr(6, resultdetail.length - 6));
                                return;
                            }
                            var jsonresultdetailobj = JSON2.parse(resultdetail);
                            var value1 = "";
                            var text1 = "";
                            if (jsonresultdetailobj.length > 0) {
                                value1 = jsonresultdetailobj[0][(jsonresultobj.Rows[0].sReturnField)];
                                text1 = jsonresultdetailobj[0][(jsonresultobj.Rows[0].sDisplayField)];
                            }
                            $(element).textbox("setValue", value1);
                            $(element).textbox("setText", text1);
                            $("#" + element.id + "_val").val(value1); //隐藏的input，赋值
                            if (value1 == "") {
                                $($(element).textbox("textbox")).val(value);
                            }
                            if (typeof (Page) != "undefined") {
                                if (Page.Children.HasDynColumns == true) {
                                    var fieldID = $(element).attr("FieldID");
                                    for (var i = 0; i < Page.Children.DynColumnsDefined.length; i++) {
                                        if (fieldID == Page.Children.DynColumnsDefined[i].triggerField) {
                                            var tableName = Page.Children.DynColumnsDefined[i].tableName;
                                            Page.Children.ShowDynColumns(tableName, value1);
                                            continue;
                                        }
                                    }
                                }
                            }

                            //其他字段初始化，matchFields
                            if (isInit == undefined || isInit == false) {
                                if (lookupOptions.matchFields && lookupOptions.matchFields!="") {
                                    lookUp.matchFieldsValueSetHead(lookupOptions.matchFields, element, jsonresultdetailobj[0]);
                                }
                            }
                            else {
                                if (typeof (Page) != "undefined") {
                                    if (Page.usetype == "add") {
                                        if (lookupOptions.matchFields && lookupOptions.matchFields != "") {
                                            lookUp.matchFieldsValueSetHead(lookupOptions.matchFields, element, jsonresultdetailobj[0]);
                                        }
                                    }
                                    if (Page.usetype == "modify" || Page.usetype == "view") {
                                        if (lookupOptions.editMatchFields && lookupOptions.editMatchFields.length > 0) {
                                            lookUp.matchFieldsValueSetHead(lookupOptions.editMatchFields, element, jsonresultdetailobj[0]);
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
                catch (e) {

                }
            }
        }
    },
    matchFieldsValueSetHead: function (matchFields, element, data) {
        for (var i = 0; i < matchFields.length; i++) {
            var targetFieldID = matchFields[i].split("=")[0];
            var sourceFieldID = matchFields[i].split("=")[1];
            var value="";
            if (sourceFieldID.length > 0) {
                if (sourceFieldID[0] == "{" && sourceFieldID[sourceFieldID.length - 1] == "}") {
                    var express = sourceFieldID.substr(1, sourceFieldID.length - 2);
                    try {
                        value = eval(express);
                    } catch (e) {
                        value = express;
                    }
                }
                else {
                    value = data[sourceFieldID];
                }                
            }
            
            if (value == undefined || value == null) {
                value = "";
            }
            value = value == undefined || value == null ? "" : value.toString();
            var valueArr = value.split(',');
            var targetElement = $("[FieldID='" + targetFieldID + "']");
            if (targetElement && targetElement.length > 0) {
                if (targetElement[0].tagName.toLowerCase() == "input") {
                    if (targetElement[0].type == "checkbox") {
                        targetElement[0].checked = value == "1" || value == 1 ? true : false;
                    }
                    else {
                        var plugin = $(targetElement[0]).attr("plugin");
                        switch (plugin) {
                            case "textbox":
                                {
                                    //$(targetElement[0]).textbox("setValue", value);
                                    try {
                                        $(targetElement[0]).textbox("setValue", value);
                                    }
                                    catch (e) {
                                        $(targetElement[0]).val(value);
                                    }

                                    var lookUpObj = lookUp.getLookUpObjByID(targetElement[0].id);
                                    if (lookUpObj /*&& lookUpObj.lookupName !== ""*/) {
                                        lookUp.setElementValueHead(targetElement[0], value, false);
                                        $("#" + targetElement[0].id + "_val").val(value);
                                        break;
                                    }
                                    var dataFormObj = dataForm.getObjByID(targetElement[0].id);
                                    if (dataFormObj) {
                                        dataForm.setElementValue(targetElement[0], value, false);
                                        $("#" + targetElement[0].id).textbox("setValue", value);
                                        $("#" + targetElement[0].id + "_val").val(value);
                                        break;
                                    }
                                } break;
                            case "combobox": $(targetElement[0]).combobox("setValues", valueArr); break;
                            case "combotree": $(targetElement[0]).combotree("setValues", valueArr); break;
                            case "numberbox": $(targetElement[0]).numberbox("setValue", value); break;
                            case "datebox": $(targetElement[0]).datebox("setValue", value); break;
                            default: { try { $(targetElement[0]).val(value); } catch (e) { } } break;
                        }
                    }
                }
                else if (targetElement[0].tagName.toLowerCase() == "select") {
                    $(targetElement[0]).combobox("setValues", valueArr);
                }
                else if (targetElement[0].tagName.toLowerCase() == "textarea") {
                    targetElement[0].value = value;
                }
            }
        }
    },
    open: function (text, from) {
        //var object = lookUp.current;
        this.isPopupOpen = true;
        var obj = undefined;
        obj = this.getLookUpObjByCurrent();
        if (obj == undefined) {
            $.messager.alert("错误", "没有满足条件的lookUp", "info", function () {
                lookUp.isPopupOpen = false;
                if (obj) {
                    if (obj.isTableField == true && obj.isImport != true) {
                        $("#" + datagridOp.current.id).datagrid("cancelEdit", datagridOp.currentRowIndex);
                    }
                }
            });

            return;
        }
        if (obj.onBeforeOpen) {
            if (obj.onBeforeOpen() == false) {
                lookUp.isPopupOpen = false;
                return false;
            }
        }
        if (this.beforeOpen) {
            if (this.beforeOpen(obj.uniqueid) == false) {
                lookUp.isPopupOpen = false;
                return false;
            }
        }
        //获取此lookup的高度、宽度，并看看有几条数据
        var lookDefine = SqlGetData({
            TableName: "bscInitLookup",
            Fields: "sReturnField,sDisplayField,iHeight,iWidth,sSQL,sReturnField,sPageField",
            SelectAll: "True",
            Filters: [
                {
                    Field: "sOrgionName",
                    ComOprt: "=",
                    Value: "'" + obj.lookupName + "'"
                }
            ]
        });
        if (lookDefine.length > 0) {
            var filters = "";
            if (obj.isTableField == true && obj.isImport != true) {
                filters = obj.parseChildFieldValue(text, true);
            }
            else {
                filters = obj.parseMainFieldValue(text, true);
            }
            //如果从按钮弹出，则不用加过滤，如果从输入框架弹出，则要加过滤条件
            //            var inputFilters = "";
            //            if (from == "text") {
            //                //inputFilters = "(" + lookDefine[0].sDisplayField + " like '%" + text + "%' or " + lookDefine[0].sReturnField + " like '%" + text + "%')";
            //                //filters = filters == "" ? inputFilters : filters + " and " + inputFilters;
            //                //filters = filters == "" ? lookDefine[0].sDisplayField + " like '%" + text + "%'" : filters + " and " + lookDefine[0].sDisplayField + " like '%" + text + "%'";
            //            }
            var resultStr = callpostback("/Base/Handler/getDataList2.ashx", "otype=lookup&lookupname=" + obj.lookupName + "&pageKey=" + obj.pageKey + "&rows=2&page=1&filters=" + encodeURIComponent(filters.replace(/%/g, "%25")), false, true);
            try {
                var data = JSON2.parse(resultStr);
            }
            catch (e) {
                $.messager.alert("错误", resultStr, "info", function () {
                    lookUp.isPopupOpen = false;
                });
                return;
            }
            try {
                if (data.rows.length == 1) {
                    if (obj.isImport) {
                        obj.setValues(data.rows);
                    }
                    else {
                        obj.setValues(data.rows[0]);
                    }
                }
                else if (data.rows.length == 0) {
                    $.messager.alert("没有数据", "没有符合条件的数据！", "info", function () {
                        lookUp.isPopupOpen = false;
                    });
                    lookUp.isPopupOpen = false;
                    if (obj.isTableField == true && obj.isImport != true) {
                        $("#" + datagridOp.current.id).datagrid("cancelEdit", datagridOp.currentRowIndex);
                        var matchFields = obj.matchFields;
                        var updateRow = {};
                        for (var i = 0; i < matchFields.length; i++) {
                            var fieldleft = matchFields[i].split("=")[0];
                            updateRow[(fieldleft)] = "";
                        }
                        $("#" + datagridOp.current.id).datagrid("updateRow", { index: datagridOp.currentRowIndex, row: updateRow });
                    }
                    //                    alert("没有符合条件的数据!");
                    return false;
                }
                else {
                    var valueEncode = text == undefined || text == null ? "" : getEnCodeStr(text);
                    var params = "value=" + encodeURI(encodeURI(valueEncode)) + "&lookupname=" + obj.lookupName + "&isMulti=" + obj.isMulti + "&fields=" + obj.fields + "&searchFields=" + obj.searchFields + "&from=" + from + "&random=" + Math.random() + "&random=" + Math.random();
                    $("#ifrlookup").attr('src', '/Base/PopUpPage.aspx?' + params);
                    $("#divlookUp").dialog("resize", { width: obj.width, height: obj.height });
                    $("#divlookUp").dialog("move", { left: (document.body.clientWidth - obj.width) / 2, top: (document.body.clientHeight - obj.height) / 2 });
                    $("#divlookUp").dialog("restore");
                    $("#divlookUp").dialog("open");
                    var f = window.frames["ifrlookup"];
                    f.focus();
                }
            }
            catch (e) {
                $.messager.alert("错误", e.message, "info", function () {
                    lookUp.isPopupOpen = false;
                });
            }
        }
        else {
            $.messager.alert("错误", "lookup定义已不存在！", "info", function () {
                lookUp.isPopupOpen = false;
            });
        }
    },
    onBeforeOpen: function () {
        lookUp.isPopupOpen = true;
        if (lookUp.getLookUpObjByCurrent().isTableField != true) {
            var targetID = lookUp.getLookUpObjByCurrent().targetID;
            if ($("#" + targetID).textbox("getValue", "") == "") {
                $("#" + targetID + "_val").val("");
            }
        }
    },
    onBeforeClose: function () {
        lookUp.isPopupOpen = false;
        if (lookUp.getLookUpObjByCurrent().isTableField != true) {
            var targetID = lookUp.getLookUpObjByCurrent().targetID;
            if ($("#" + targetID + "_val").val() == "") {
                $("#" + targetID).textbox("setValue", "");
            }
        }
        if (lookUp.getLookUpObjByCurrent().isTableField == true && lookUp.getLookUpObjByCurrent().isImport != true) {
            $(datagridOp.current).datagrid("cancelEdit", datagridOp.currentRowIndex);
        }
        $("#ifrlookup").attr('src', '');
    },
    onBeforeDestroy: function () {
        lookUp.isPopupOpen = false;
        if (lookUp.getLookUpObjByCurrent().isTableField != true) {
            var targetID = lookUp.getLookUpObjByCurrent().targetID;
            if ($("#" + targetID + "_val").val() == "") {
                $("#" + targetID).textbox("setValue", "");
            }
        }
        if (lookUp.getLookUpObjByCurrent().isTableField == true && lookUp.getLookUpObjByCurrent().isImport != true) {
            $(datagridOp.current).datagrid("cancelEdit", datagridOp.currentRowIndex);
        }
        $("#ifrlookup").attr('src', '');
    },
    close: function () {
        $("#divlookUp").dialog("close");
    },
    //执行条件是否满足，参数uniqueid
    IsConditionFit: undefined,
    //打开前执行，参数为uniqueid
    beforeOpen: undefined,
    //设置数据之前执行,参数为uniqueid,data
    beforeSetValue: undefined,
    //设置每一行数据之前执行，参数uniqueid,index(行号，相对于返回的data来说),data（返回的经过beforeSetValue后的数据）,row（要赋值的行数据）
    beforeSetRowValue: undefined, //(uniqueid,index,data,row)
    //设置每一行数据之后执行，参数uniqueid,index(行号，相对于返回的data来说),data（返回的经过beforeSetValue后的数据）,row（已赋值的行数据）,rowIndex(赋值后的对应子表的行号)
    afterSetRowValue: undefined, //(uniqueid,index,data,row,rowIndex)
    //选择后执行，参数为uniqueid,data
    afterSelected: undefined,
    tabSwitch: function (tabid, which) {
        $("#" + tabid).tabs("select", parseInt(which));
    }
}

function getEnCodeStr(str) {
    str = str.replace(/\+/g, "%2B").replace(/\//g, "%2F").replace(/\?/g, "%3F").replace(/%/g, "%25").replace(/#/g, "%23").replace(/&/g, "%26").replace(/=/g, "%3D").replace(/\'/g, "%27");
    return str;
}
function getTableZoneID(tablename, zoneCount) {
    var jsonobj = {
        StoreProName: "SpGetZoneIden",
        StoreParms: [{
            ParmName: "@tablename",
            Value: tablename
        },
            {
                ParmName: "@iZoneCount",
                Value: zoneCount
            }
        ]
    }
    var result = SqlStoreProce(jsonobj);
    if (result && result.length > 0 && result != "-1") {
        return result;
    }
    else {
        return "-1";
    }
}