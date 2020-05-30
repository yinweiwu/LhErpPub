var dataForm = {
    currentID: undefined,
    current: undefined,
    lists: [],
    createNew: function (obj) {
        dataForm.lists.push(obj);
    },
    getObjByID: function (id) {
        for (var i = 0; i < this.lists.length; i++) {
            if (this.lists[i].id == id) {
                return this.lists[i];
            }
        }
    },
    getDataFormObjByID: function (id) {
        var obj = this.getObjByID(id);
        if (obj) {
            if (obj.dataFormObjs.length == 1) {
                return obj.dataFormObjs[0];
            }
            for (var i = 0; i < obj.dataFormObjs.length; i++) {
                if (obj.dataFormObjs[i].condition != undefined) {
                    var result = obj.dataFormObjs[i].condition();
                    if (result == true) {
                        if (dataForm.IsConditionFit) {
                            var resultFit = dataForm.IsConditionFit(obj.dataFormObjs[i].uniqueid);
                            if (resultFit == true) {
                                return obj.dataFormObjs[i];
                            }
                        }
                        else {
                            return obj.dataFormObjs[i];
                        }
                        //return object.lookUpObjs[i];
                    }
                }
                else {
                    if (dataForm.IsConditionFit) {
                        var resultFit = dataForm.IsConditionFit(obj.dataFormObjs[i].uniqueid);
                        if (resultFit == true) {
                            return obj.dataFormObjs[i];
                        }
                    }
                    else {
                        return obj.dataFormObjs[i];
                    }
                }
            }
            return undefined;
        }
        return undefined;
    },
    //init只能初始化主表子段，子表的在子表定义中初始化
    init: function (options) {
        var elements = $("[dataFormOptions]");
        for (var i = 0; i < elements.length; i++) {
            var str = $(elements[i]).attr("dataFormOptions");
            if (str && str.length > 0) {
                var dataFormOptions = eval("(" + str + ")");
                dataFormOptions.menuid = dataFormOptions.menuid == undefined ? dataFormOptions.menuid : getQueryString("MenuID");
                var id = elements[i].id;
                if (id == undefined || id == "") {
                    elements[i].id = "dataFormOptions" + elements[i].uniqueID;
                    id = "dataFormOptions" + elements[i].uniqueID;
                }
                //dataFormOptions.id = id;
                var object = {
                    id: id,
                    dataFormObjs: dataFormOptions
                };
                dataForm.createNew(object);


                var required = false;
                var reqMess = "不可空!";
                var notNull = false;
                var nullTip = "";
                if ($(elements[i]).hasClass("easyui-validatebox")) {
                    var validOption = $(elements[i]).validatebox("options");
                    notNull = validOption.required;
                    nullTip = validOption.invalidMessage;
                    $(elements[i]).validatebox("disableValidation");
                }

                if (notNull == true) {
                    required = true;
                }
                if (nullTip != "") {
                    reqMess = nullTip;
                }

                var plugin = $(elements[i]).attr("plugin");
                if (plugin && plugin == "textbox") {
                    //创建一个hidden，用来保存value,因为textbox会丢失value
                    var inputHidden = document.createElement("input");
                    inputHidden.type = "hidden";
                    inputHidden.id = id + "_val";
                    document.body.appendChild(inputHidden);

                    $(elements[i]).textbox({
                        buttonText: "...",
                        onClickButton: function () {
                            dataForm.currentID = this.id;
                            dataForm.open(this.id);
                        },
                        icons: [
                            {
                                iconCls: 'icon-clear1',
                                handler: function (e) {
                                    var oldValue = $(e.data.target.id + "_val").val();
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
                        ]
                    });
                    $(elements[i]).textbox("textbox").attr("targetID", elements[i].id);
                    $(elements[i]).textbox("textbox").bind("dblclick", function () {
                        var target = $(this).attr("targetID");
                        $("#" + target).textbox("button").click();
                    })

                    if (typeof (Page) != "undefined") {
                        //                        var theFieldID = $(elements[i]).attr("FieldID");
                        //                        if (Page.MainRequiredFields && Page.MainRequiredFields.length > 0 && required == false) {
                        //                            for (var ii = 0; ii < Page.MainRequiredFields.length; ii++) {
                        //                                if (Page.MainRequiredFields[ii].field == theFieldID) {
                        //                                    $(elements[i]).textbox("textbox").addClass("txbrequired");
                        //                                    break;
                        //                                }
                        //                            }
                        //                        }
                        //                        if (Page.usetype == "add") {
                        //                            if (Page.DefaultValues[(theFieldID)]) {
                        //                                dataForm.setElementValue(elements[i], Page.DefaultValues[(theFieldID)]);
                        //                            }
                        //                        }
                    }
                }
                else {
                    elements[i].onclick = function () {
                        dataForm.currentID = "dataFormOptions" + this.uniqueID;
                        dataForm.open("dataFormOptions" + this.uniqueID);
                    }
                }
            }
        }
    },
    load: function () {
        var elementwithDataForm = $("[dataFormOptions]");
        for (var i = 0; i < elementwithDataForm.length; i++) {
            if (elementwithDataForm[i].attributes["FieldID"]) {
                var plugin = $(elementwithDataForm[i]).attr("plugin");
                if ($(elementwithDataForm[i]).attr("plugin") && $(elementwithDataForm[i]).attr("plugin") != "textbox") {
                    continue;
                }
                var value = $(elementwithDataForm[i]).textbox("getValue");
                if (value != "") {
                    this.setElementValue(elementwithDataForm[i], value, true);
                }
            }
        }
    },
    setElementValue: function (element, value, isInit) {
        var id = element.id;
        var obj = this.getObjByID(id);
        if (obj) {
            if (obj.isMulti != true) {
                var dataFormObj = this.getDataFormObjByID(id);
                var url = "/Base/Handler/getDataList2.ashx";
                var filters = (dataFormObj.valueID + "='" + value + "'").replace(/%/g, "%25");
                var parms = "otype=formlist&isChild=0&iformid=" + dataFormObj.formid + "&rows=1&page=1&filters=" + encodeURIComponent(filters);
                var result = callpostback(url, parms, false, true);
                if (result && result.length > 0) {
                    try {
                        var data = eval("(" + result + ")");
                        if (data.rows) {
                            $(element).textbox("setValue", data.rows[0][(dataFormObj.valueID)]);
                            $(element).textbox("setText", data.rows[0][(dataFormObj.textID)]);
                            $("#" + element.id + "_val").val(data.rows[0][(dataFormObj.valueID)]);
                            if (isInit == undefined || isInit == false) {
                                if (dataFormObj.matchFields) {
                                    var data = data.rows[0];
                                    var matchFields = dataFormObj.matchFields;
                                    this.matchFieldsSet(matchFields, element, data);
                                }
                            }
                            else {
                                if (typeof (Page) != "undefined") {
                                    if (Page.usetype == "add") {
                                        if (dataFormObj.matchFields) {
                                            var data = data.rows[0];
                                            var matchFields = dataFormObj.matchFields;
                                            this.matchFieldsSet(matchFields, element, data);
                                        }
                                    }
                                    if (Page.usetype == "modify" || Page.usetype == "view") {
                                        //lookUp.matchFieldsValueSetHead(lookupOptions.editMatchFields, element, jsonresultdetailobj[0]);
                                        var data = data.rows[0];
                                        var matchFields = dataFormObj.editMatchFields;
                                        this.matchFieldsSet(matchFields, element, data);
                                    }
                                }
                            }
                        }
                        else {
                            $(element).textbox("setValue", data[0][(dataFormObj.valueID)]);
                            $(element).textbox("setText", data[0][(dataFormObj.textID)]);
                            $("#" + element.id + "_val").val(data[0][(dataFormObj.valueID)]);
                            if (isInit == undefined || isInit == false) {
                                if (dataFormObj.matchFields) {
                                    var data = data[0];
                                    var matchFields = dataFormObj.matchFields;
                                    this.matchFieldsSet(matchFields, element, data);
                                }
                            }
                            else {
                                if (typeof (Page) != "undefined") {
                                    if (Page.usetype == "add") {
                                        if (dataFormObj.matchFields) {
                                            var data = data[0];
                                            var matchFields = dataFormObj.matchFields;
                                            this.matchFieldsSet(matchFields, element, data);
                                        }
                                    }
                                    if (Page.usetype == "modify" || Page.usetype == "view") {
                                        //lookUp.matchFieldsValueSetHead(lookupOptions.editMatchFields, element, jsonresultdetailobj[0]);
                                        var data = data[0];
                                        var matchFields = dataFormObj.editMatchFields;
                                        this.matchFieldsSet(matchFields, element, data);
                                    }
                                }
                            }
                        }


                    }
                    catch (e) {
                        $.messager.alert("错误", "dataForm初始化时发生错误：" + result);
                    }

                }
            }
        }
    },
    matchFieldsSet: function (matchFields, element, data) {
        for (var i = 0; i < matchFields.length; i++) {
            var targetFieldID = matchFields[i].split("=")[0];
            var sourceFieldID = matchFields[i].split("=")[1];
            if (sourceFieldID && targetFieldID) {
                var value = "";
                if (sourceFieldID[0] == "{" && sourceFieldID[sourceFieldID.length - 1] == "}") {
                    var express = sourceFieldID.substr(1, sourceFieldID.length - 2);
                    value = eval(express);
                } else {
                    value = data[sourceFieldID];
                }

                if (value == undefined || value == null) {
                    value = "";
                }
                var valueArr = value.toString().split(",");
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
                                        var lookUpObj = lookUp.getObjByID(targetElement[0].id);
                                        if (lookUpObj /*&& lookUpObj.lookupName !== ""*/) {
                                            lookUp.setElementValueHead(targetElement[0], value, false);
                                            $("#" + targetElement[0].id + "_val").val(value);
                                            break;
                                        }
                                        var dataFormObj = dataForm.getObjByID(targetElement[0].id);
                                        if (dataFormObj) {
                                            dataForm.setElementValue(targetElement[0], value, false);
                                            $("#" + targetElement[0].id + "_val").val(value);
                                            break;
                                        }
                                    } break;
                                case "combobox": $(targetElement[0]).combobox("setValue", valueArr); break;
                                case "combotree": $(targetElement[0]).combotree("setValue", valueArr); break;
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
            
        }
    },
    open: function () {
        var obj = this.getDataFormObjByID(dataForm.currentID);
        if (obj == undefined) {
            $.messager.alert("错误", "没有满足条件的dataForm");
            return;
        }
        if (obj.onBeforeOpen) {
            if (obj.onBeforeOpen() == false) {
                return;
            }
        }
        if (this.beforeOpen) {
            if (this.beforeOpen(obj.uniqueid) == false) {
                return;
            }
        }
        var p = obj;
        var sheight = screen.height;
        var swidth = screen.width - 10;
        //        var iWidth = p.width == -1 ? swidth + "px" : p.width + "px";
        //        var iHeight = p.height == -1 ? sheight + "px" : p.height + "px";
        var iWidth = swidth + "px";
        var iHeight = sheight + "px";

        //打开表单form
        p.menuid = p.menuid == undefined ? getQueryString("MenuID") : p.menuid;
        var url = "/Base/FormList.aspx?FormID=" + p.formid + "&MenuID=" + p.menuid + "&popup=1&returnFn=dataForm.setValue";
        if (p.fixFilters) {
            url += "&fixFilters=" + escape(Page.parseMainField(p.fixFilters));
        }
        if (p.nofixFilters) {
            url += "&nofixFilters=" + escape(Page.parseMainField(p.nofixFilters));
        }
        if (p.type == "field") {
            //url += "&multi=0";
            if (obj.isMulti != true) {
                url += "&multi=0";
            }
            else {
                url += "&multi=1";
            }
            window.open(url, "dataForm", "width=" + iWidth + ", height=" + iHeight + ",top=0,left=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
        }
        else {
            if (obj.isMulti != true) {
                url += "&multi=0";
            }
            else {
                url += "&multi=1";
            }
            window.open(url, "dataForm", "width=" + iWidth + ", height=" + iHeight + ",top=0,left=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no,alwaysRaised=yes,depended=yes");
        }
    },
    setValue: function (selectedRow) {
        var data = [];
        if (selectedRow.length) {
            data = selectedRow;
        }
        else {
            data.push(selectedRow);
        }
        var obj = this.getDataFormObjByID(this.currentID);
        if (dataForm.beforeSetValue) {
            var dataProc = dataForm.beforeSetValue(obj.uniqueid, data);
            if (dataProc == false) {
                return false;
            }
            if (dataProc) {
                data = dataProc;
            }
        }
        if (obj == undefined) {
            $.messager.alert("错误", "没有满足条件的dataForm");
            return;
        }
        if (obj.type == "field") {
            if (obj.isMulti != true) {
                $("#" + this.currentID).textbox("setValue", data[0][(obj.valueID)]);
                $("#" + this.currentID).textbox("setText", data[0][(obj.textID)]);

                $("#" + this.currentID + "_val").val(data[0][(obj.valueID)]);
                if (obj.matchFields) {
                    dataForm.matchFieldsSet(obj.matchFields, $("#" + this.currentID)[0], data[0]);
                }
            }
            else {
                var str = "";
                for (var i = 0; i < data.length; i++) {
                    str += data[i][(obj.valueID)] + ",";
                }
                str = str == "" ? "" : str.substr(0, str.length - 1);
                $("#" + this.currentID).textbox("setValue", str);
                $("#" + this.currentID).textbox("setText", str);
                $("#" + this.currentID + "_val").val(str);
            }
        }
        else if (obj.type == "table") {
            if (obj.matchFields) {
                //如果覆盖，先删除原数据
                if (obj.isCover == true) {
                    for (var i = 0; i < $("#" + obj.targetTableID).datagrid("getRows").length; i++) {
                        $("#" + obj.targetTableID).datagrid("deleteRow", i);
                    }
                }

                var tableid = obj.targetTableID;
                var tableName = $("#" + tableid).attr("serialTableName");
                var nextID = getTableZoneID(tableName, data.length);
                if (nextID == -1) {
                    alert("导入失败，获取主键失败");
                    return;
                }
                for (var i = 0; i < data.length; i++) {
                    var appendData = {};
                    var mainDataReadyToSet = [];
                    for (var j = 0; j < obj.matchFields.length; j++) {
                        var targetFieldID = obj.matchFields[j].split("=")[0];
                        var sourceFieldID = obj.matchFields[j].split("=")[1];

                        var value = "";
                        if (sourceFieldID[0] == "{" && sourceFieldID[sourceFieldID.length - 1] == "}") {
                            var theExpress = sourceFieldID.substr(1, sourceFieldID.length - 2);
                            try{
                                value = eval(theExpress);
                            } catch (e) {
                                value = theExpress;
                            }
                        }
                        else {
                            value = data[i][(sourceFieldID)];
                        }
                        if (targetFieldID.length > 2 && targetFieldID.substr(0, 2) == "m.") {
                            if (typeof (Page) != "undefined") {
                                var tField = targetFieldID.substr(2);
                                mainDataReadyToSet.push({ field: tField, value: value });
                            }
                        } else {
                            appendData[targetFieldID] = value;
                        }
                        //appendData[(targetFieldID)] = data[i][(sourceFieldID)];
                    }
                    //在设置每一行数据之前执行dataForm.beforeSetRowValue
                    if (dataForm.beforeSetRowValue) {
                        var result = dataForm.beforeSetRowValue(obj.uniqueid, i, data, appendData);
                        if (result == false) {
                            return false;
                        }
                        if (result) {
                            appendData = result;
                        }
                    }
                    for (var z = 0; z < mainDataReadyToSet.length; z++) {
                        if (typeof (Page) != "undefined") {
                            Page.setFieldValue(mainDataReadyToSet[z].field, mainDataReadyToSet[z].value);
                        }
                    }
                    var nextRecNo = parseInt(nextID) + parseInt(i);
                    Page.tableToolbarClick("add", obj.targetTableID, appendData, nextRecNo);
                    var rowIndex = $("#" + obj.targetTableID).datagrid("getRows").length - 1;
                    //在设置每一行数据之后执行dataForm.afterSetRowValue
                    if (dataForm.afterSetRowValue) {
                        var result = dataForm.afterSetRowValue(obj.uniqueid, i, data, appendData, rowIndex);
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
        }
        if (obj.onSelected) {
            obj.onSelected(data);
        }
        if (dataForm.afterSelected) {
            dataForm.afterSelected(obj.uniqueid, data);
        }
    },
    //是否满足执行条件，参数uniqueid
    IsConditionFit: undefined,
    //选择后执行，参数为uniqueid
    beforeOpen: undefined,
    //设置数据之前执行,参数为uniqueid,data
    beforeSetValue: undefined,
    //设置每一行数据之前执行，参数uniqueid,index(行号，相对于返回的data来说),data（返回的经过beforeSetValue后的数据）,row（要赋值的行数据）
    beforeSetRowValue: undefined,
    //设置每一行数据之后执行，参数uniqueid,index(行号，相对于返回的data来说),data（返回的经过beforeSetValue后的数据）,row（已赋值的行数据）,rowIndex(赋值后的对应子表的行号)
    afterSetRowValue: undefined,
    //选择后执行，参数为uniqueid,data
    afterSelected: undefined,
    tabSwitch: function (tabid, which) {
        $("#" + tabid).tabs("select", parseInt(which));
    }
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