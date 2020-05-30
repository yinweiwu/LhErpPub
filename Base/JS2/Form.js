var Form = {
    __add: function (url,formElementID) {
        //主表
        var mainData = {};
        var querystr = "";
        var tablename = document.getElementById("TableName").value;
        var fieldkeys = document.getElementById("FieldKey").value;
        var fieldkeyvalue = document.getElementById("FieldKeyValue").value;
        var input;
        var textarea;
        var select;
        if (formElementID) {
            input = $("form[id='" + formElementID + "'] input[FieldID]");
            textarea = $("form[id='" + formElementID + "'] textarea[FieldID]");
            select = $("form[id='" + formElementID + "'] select[FieldID]");
        } else {
            input = $("input[FieldID]");
            textarea = $("textarea[FieldID]");
            select = $("select[FieldID]");
        }
        for (var i = 0; i < textarea.length; i++) {
            var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
                var fieldid = textarea[i].attributes["FieldID"].nodeValue;
                var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
                var saveValue = textarea[i].attributes["SaveValue"] == null ? "" : textarea[i].attributes["SaveValue"].nodeValue;
                var value = textarea[i].value;
                mainData[(fieldid)] = value;
            }
        }
        for (var i = 0; i < input.length; i++) {
            var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
                var objtype = input[i].type;
                var fieldid = input[i].attributes["FieldID"].nodeValue;
                var fieldtype = "空";
                if (input[i].attributes["FieldType"] == null) {
                    fieldtype = "空";
                }
                else {
                    fieldtype = input[i].attributes["FieldType"].nodeValue;
                }
                var saveValue = input[i].attributes["SaveValue"] == null ? "" : input[i].attributes["SaveValue"].nodeValue;
                if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                    var value = input[i].value;
                    if ($(input[i]).attr("plugin") == "combobox" || $(input[i]).attr("plugin") == "combotree" || $(input[i]).attr("plugin") == "textbox") {
                        if (saveValue.toLowerCase() != "false") {
                            if ($(input[i]).attr("plugin") == "combobox") {
                                value = $(input[i]).combobox("getValues");
                                if (value == "" || value == undefined) {
                                    value = $(input[i]).combobox("getText");
                                }
                            }
                            else if ($(input[i]).attr("plugin") == "combotree") {
                                //                                value = $(input[i]).combotree("getValues");
                                //                                if (value == "" || value == undefined) {
                                //                                    value = $(input[i]).combotree("getText");
                                //                                }
                                var treeText = $(input[i]).combotree("getText");
                                if (treeText == "") {
                                    value = treeText;
                                }
                                else {
                                    value = $(input[i]).combotree("getValues");
                                }
                            }
                            else {
                                try {
                                    value = $(input[i]).textbox("getValue");
                                }
                                catch (e) {
                                    value = $(input[i]).val();
                                }
                                if (value != "") {
                                    if (typeof (lookUp) != "undefined") {
                                        var lookUpObj = lookUp.getLookUpObjByID(input[i].id);
                                        if (lookUpObj /*&& lookUpObj.lookupName !== ""*/) {
                                            value = $("#" + input[i].id + "_val").val();
                                            if (value == "") {
                                                value = $($("#" + input[i].id).textbox("textbox")).val();
                                            }
                                        }
                                    }
                                    if (typeof (dataForm) != "undefined") {
                                        var dataFormObj = dataForm.getObjByID(input[i].id);
                                        if (dataFormObj) {
                                            value = $("#" + input[i].id + "_val").val();
                                            if (value == "") {
                                                value = $($("#" + input[i].id).textbox("textbox")).val();
                                            }
                                        }
                                    }
                                    if (value == "") {
                                        value = $(input[i]).val();
                                    }
                                }
                            }
                        }
                        else {
                            if ($(input[i]).attr("plugin") == "combobox") {
                                value = $(input[i]).combobox("getText");
                            }
                            else if ($(input[i]).attr("plugin") == "combotree") {
                                value = $(input[i]).combotree("getText");
                            }
                            else {
                                try {
                                    value = $(input[i]).textbox("getText");
                                }
                                catch (e) {
                                    value = $(input[i]).val();
                                }
                            }
                        }
                    }
                    if ($(input[i]).attr("plugin") == "datebox" || $(input[i]).attr("plugin") == "datetimebox") {
                        if ($(input[i]).attr("plugin") == "datebox") {
                            value = $("#" + input[i].id).datebox("getValue");
                        }
                        else {
                            value = $("#" + input[i].id).datetimebox("getValue");
                        }
                    }
                    value = isArray(value) ? value.join(",") : value;
                    mainData[(fieldid)] = value;
                }
                if (objtype == "checkbox") {
                    var value = input[i].checked == true ? "1" : "0";
                    mainData[(fieldid)] = value;
                }
            }
        }
        for (var i = 0; i < select.length; i++) {
            var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
                var fieldid = select[i].attributes["FieldID"].nodeValue;
                var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
                var value = $(select[i]).combobox("getValue");
                var saveValue = select[i].attributes["SaveValue"] == null ? "" : select[i].attributes["SaveValue"].nodeValue;
                if (saveValue.toLowerCase() == "false") {
                    value = select[i].options[select[i].selectedIndex].text;
                }
                mainData[(fieldid)] = value;
            }
        }
        var operate = "add";
        var querystr = {
            TableName: tablename,
            Operatortype: "add",
            Data: mainData,
            FieldKeys: fieldkeys,
            FieldKeysValues: fieldkeyvalue
        };
        //子表
        var jsonchildren = [];
        var children = $("table[isson='true'][tablename][tablename!='']");
        for (var i = 0; i < children.length; i++) {
            var jsonobj = {};
            var tablename = children[i].attributes["tablename"].nodeValue;
            var linkfield = children[i].attributes["linkfield"].nodeValue;
            var fieldkey = children[i].attributes["fieldkey"].nodeValue;
            jsonobj.childtype = "son";
            jsonobj.tablename = tablename;
            jsonobj.linkfield = linkfield;
            jsonobj.fieldkey = fieldkey;
            //var dataOrg = $("#" + children[i].id).datagrid("getRows");
            var dataOrg = $("#" + children[i].id).datagrid("getData").originalRows ? $("#" + children[i].id).datagrid("getData").originalRows : $("#" + children[i].id).datagrid("getData").rows;
            if (typeof (datagridOp) != "undefined") {
                if (datagridOp.currentRowIndex) {
                    $("#" + children[i].id).datagrid("endEdit", datagridOp.currentRowIndex);
                }
                else {
                    for (var j = 0; j < dataOrg.length; j++) {
                        $("#" + children[i].id).datagrid("endEdit", j);
                    }
                }
            }
            else {
                for (var j = 0; j < dataOrg.length; j++) {
                    $("#" + children[i].id).datagrid("endEdit", j);
                }
            }
            var data = [];
            deepCopy(data, dataOrg);
            var sqlObj = {
                TableName: "SysColumns",
                Fields: "Name",
                SelectAll: "True",
                Filters: [
                {
                    Field: "id",
                    ComOprt: "=",
                    Value: "Object_Id('" + tablename + "')"
                }
            ]
            };
            var tablefields = SqlGetData(sqlObj);
            for (var ic = 0; ic < data.length; ic++) {
                for (var key in data[ic]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                            break;
                        }
                    }
                    if (exists == false) {
                        delete data[ic][key];
                    }
                }
            }
            jsonobj.data = data;
            jsonchildren.push(jsonobj);

            if (typeof (Page) != "undefined") {
                if (Page.Children.HasDynColumns == true) {
                    for (var j = 0; j < Page.Children.DynColumnsDefined.length; j++) {
                        if (tablename == Page.Children.DynColumnsDefined[j].tableName) {
                            var jsonObjGrand = {};
                            jsonObjGrand.childtype = "grandson";
                            jsonObjGrand.tablename = Page.Children.DynColumnsDefined[j].tableNameD;
                            jsonObjGrand.father = tablename;
                            var dataGrand = [];
                            for (var d in dataOrg) {
                                for (var k = 0; k < Page.Children.DynColumnsDefined[j].columns.length; k++) {
                                    var fieldColumn = "";
                                    for (var o in Page.Children.DynColumnsDefined[j].columns[0]) {
                                        fieldColumn = o;
                                        break;
                                    }

                                    var dataGrandOne = {};
                                    dataGrandOne.iMainRecNo = dataOrg[d][fieldkey];
                                    dataGrandOne[(Page.Children.DynColumnsDefined[j].columnMatchField)] = Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)];
                                    if (dataOrg[d][(Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)])]) {
                                        dataGrandOne[(Page.Children.DynColumnsDefined[j].columnValueMatchField)] = dataOrg[d][(Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)])];
                                        dataGrand.push(dataGrandOne);
                                    }
                                }
                            }
                            jsonObjGrand.data = dataGrand;
                            jsonchildren.push(jsonObjGrand);
                        }
                    }
                }
            }
        }

        var iFormID = "";
        var sBillType = document.title;
        if (typeof (Page) != "undefined") {
            iFormID = Page.iformid;
        } else {
            iFormID = "自定义";
        }
        $.ajax({
            url: url,
            data: { mainquery: JSON2.stringify(querystr), children: JSON2.stringify(jsonchildren), iFormID: iFormID, sBillType: sBillType },
            cache: false,
            type: "POST",
            async: false,
            success: function (data) {
                result = data;
                if (result.indexOf("error:") == -1) {
                    var children = $("table[isson='true'][tablename][tablename!='']");
                    for (var i = 0; i < children.length; i++) {
                        $(children[i]).removeAttr("deleteKey");
                        //var data1 = $("#" + children[i].id).datagrid("getRows");
                        var data1 = $("#" + children[i].id).datagrid("getData").originalRows ? $("#" + children[i].id).datagrid("getData").originalRows : $("#" + children[i].id).datagrid("getData").rows;
                        for (var j = 0; j < data1.length; j++) {
                            $("#" + children[i].id).datagrid("updateRow", { row: { __hxstate: "" }, index: j });
                        }
                    }
                }
            },
            error: function (data) {
                $.messager.alert("出错", "与服务器连接失败！");
            }

        });
        return result;
    },
    //表单修改保存
    __update: function (irecno, url, formElementID) {
        //主表
        var mainData = {};
        var tablename = document.getElementById("TableName").value;
        var fieldkeys = document.getElementById("FieldKey").value;
        
        var input;
        var textarea;
        var select;
        if (formElementID) {
            input = $("form[id='" + formElementID + "'] input[FieldID]");
            textarea = $("form[id='" + formElementID + "'] textarea[FieldID]");
            select = $("form[id='" + formElementID + "'] select[FieldID]");
        } else {
            input = $("input[FieldID]");
            textarea = $("textarea[FieldID]");
            select = $("select[FieldID]");
        }
        

        for (var i = 0; i < textarea.length; i++) {
            var nosave = textarea[i].attributes["NoSave"] == null ? "FALSE" : textarea[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (textarea[i].attributes["FieldID"] != undefined && textarea[i].attributes["FieldID"] != null && textarea[i].attributes["FieldID"].nodeValue.length > 0 && textarea[i].id != "FieldKey") {
                var fieldid = textarea[i].attributes["FieldID"].nodeValue;
                var fieldtype = textarea[i].attributes["FieldType"] == null ? "空" : textarea[i].attributes["FieldType"].nodeValue;
                var value = textarea[i].value;
                mainData[(fieldid)] = value;
            }
        }
        for (var i = 0; i < input.length; i++) {
            var nosave = input[i].attributes["NoSave"] == null ? "FALSE" : input[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (input[i].attributes["FieldID"] != undefined && input[i].attributes["FieldID"] != null && input[i].attributes["FieldID"].nodeValue.length > 0 && input[i].id != "FieldKey") {
                var objtype = input[i].type;
                var fieldid = input[i].attributes["FieldID"].nodeValue;
                var fieldtype = input[i].attributes["FieldType"] == null ? "空" : input[i].attributes["FieldType"].nodeValue;
                var saveValue = input[i].attributes["SaveValue"] == null ? "" : input[i].attributes["SaveValue"].nodeValue;

                if (objtype == "text" || objtype == "password" || objtype == "hidden") {
                    var value = input[i].value;
                    if ($(input[i]).attr("plugin") == "combobox" || $(input[i]).attr("plugin") == "combotree" || $(input[i]).attr("plugin") == "textbox") {
                        if (saveValue.toLowerCase() != "false") {
                            if ($(input[i]).attr("plugin") == "combobox") {
                                value = $(input[i]).combobox("getValues");
                                if (value == "" || value == undefined) {
                                    value = $(input[i]).combobox("getText");
                                }
                            }
                            else if ($(input[i]).attr("plugin") == "combotree") {
                                var treeText = $(input[i]).combotree("getText");
                                if (treeText == "") {
                                    value = treeText;
                                }
                                else {
                                    value = $(input[i]).combotree("getValues");
                                }
                                //                                if (value == "" || value == undefined) {
                                //                                    value = $(input[i]).combotree("getText");
                                //                                }
                            }
                            else {
                                try {
                                    value = $(input[i]).textbox("getValue");
                                }
                                catch (e) {
                                    value = $(input[i]).val();
                                }

                                if (value != "") {
                                    if (typeof (lookUp) != "undefined") {
                                        var lookUpObj = lookUp.getLookUpObjByID(input[i].id);
                                        if (lookUpObj /*&& lookUpObj.lookupName !== ""*/) {
                                            value = $("#" + input[i].id + "_val").val();
                                            if (value == "") {
                                                value = $($("#" + input[i].id).textbox("textbox")).val();
                                            }
                                        }
                                    }
                                    if (typeof (dataForm) != "undefined") {
                                        var dataFormObj = dataForm.getObjByID(input[i].id);
                                        if (dataFormObj) {
                                            value = $("#" + input[i].id + "_val").val();
                                            if (value == "") {
                                                value = $($("#" + input[i].id).textbox("textbox")).val();
                                            }
                                        }
                                    }
                                    if (value == "") {
                                        value = $(input[i]).val();
                                    }
                                }
                            }
                        }
                        else {
                            if ($(input[i]).attr("plugin") == "combobox") {
                                value = $(input[i]).combobox("getText");
                            }
                            else if (input[i].attr("plugin") == "combotree") {
                                value = $(input[i]).combotree("getText");
                            }
                            else {
                                try {
                                    value = $(input[i]).textbox("getText");
                                }
                                catch (e) {
                                    value = $(input[i]).val();
                                }
                            }
                        }
                    }
                    if ($(input[i]).attr("plugin") == "datebox" || $(input[i]).attr("plugin") == "datetimebox") {
                        if ($(input[i]).attr("plugin") == "datebox") {
                            value = $(input[i]).datebox("getValue");
                        }
                        else {
                            value = $(input[i]).datetimebox("getValue");
                        }
                    }
                    value = isArray(value) ? value.join(",") : value;
                    mainData[(fieldid)] = value;
                }
                if (objtype == "checkbox") {
                    var value = input[i].checked == true ? "1" : "0";
                    mainData[(fieldid)] = value;
                }
            }
        }
        for (var i = 0; i < select.length; i++) {
            var nosave = select[i].attributes["NoSave"] == null ? "FALSE" : select[i].attributes["NoSave"].nodeValue.toUpperCase();
            if (nosave == "TRUE") {
                continue;
            }
            if (select[i].attributes["FieldID"] != undefined && select[i].attributes["FieldID"] != null && select[i].attributes["FieldID"].nodeValue.length > 0 && select[i].id != "FieldKey") {
                var fieldid = select[i].attributes["FieldID"].nodeValue;
                var fieldtype = select[i].attributes["FieldType"] == null ? "空" : select[i].attributes["FieldType"].nodeValue;
                var value = $(select[i]).combobox("getValue");
                var saveValue = select[i].attributes["SaveValue"] == null ? "" : select[i].attributes["SaveValue"].nodeValue;
                if (saveValue.toLowerCase() == "false") {
                    value = select[i].options[select[i].selectedIndex].text;
                }
                mainData[(fieldid)] = value;
            }
        }
        var operate = "update";
        var querystr = {
            TableName: tablename,
            Operatortype: "update",
            Data: mainData,
            FieldKeys: fieldkeys,
            FieldKeysValues: irecno,
            FilterFields: fieldkeys,
            FilterComOprts: "=",
            FilterValues: irecno
        };

        //子表、孙子表
        var jsonchildren = [];
        var children = $("table[isson='true'][tablename][tablename!='']");
        for (var i = 0; i < children.length; i++) {
            var jsonobj = {};
            var tablename = children[i].attributes["tablename"].nodeValue;
            var linkfield = children[i].attributes["linkfield"].nodeValue;
            var fieldkey = children[i].attributes["fieldkey"].nodeValue;
            var deleteKey = children[i].attributes["deleteKey"] ? children[i].attributes["deleteKey"].nodeValue : null;
            jsonobj.childtype = "son";
            jsonobj.tablename = tablename;
            jsonobj.linkfield = linkfield;
            jsonobj.fieldkey = fieldkey;
            //jsonobj.addKey = [];
            if (deleteKey) {
                deleteKey = deleteKey.substr(0, deleteKey.length - 1);
                jsonobj.deleteKey = deleteKey.split(',');
            }
            //var dataOrg = $("#" + children[i].id).datagrid("getRows");
            var dataOrg = $("#" + children[i].id).datagrid("getData").originalRows ? $("#" + children[i].id).datagrid("getData").originalRows : $("#" + children[i].id).datagrid("getData").rows;
            if (typeof (datagridOp) != "undefined") {
                if (datagridOp.currentRowIndex) {
                    $("#" + children[i].id).datagrid("endEdit", datagridOp.currentRowIndex);
                }
                else {
                    for (var j = 0; j < dataOrg.length; j++) {
                        $("#" + children[i].id).datagrid("endEdit", j);
                    }
                }
            }
            else {
                for (var j = 0; j < dataOrg.length; j++) {
                    $("#" + children[i].id).datagrid("endEdit", j);
                }
            }
            var data = [];
            deepCopy(data, dataOrg);
            //只保存表中的列
            var sqlObj = {
                TableName: "SysColumns",
                Fields: "Name",
                SelectAll: "True",
                Filters: [
                {
                    Field: "id",
                    ComOprt: "=",
                    Value: "Object_Id('" + tablename + "')"
                }
            ]
            };
            var tablefields = SqlGetData(sqlObj);
            for (var ic = 0; ic < data.length; ic++) {
                for (var key in data[ic]) {
                    var exists = false;
                    for (var j = 0; j < tablefields.length; j++) {
                        if (key == tablefields[j].Name) {
                            exists = true;
                            break;
                        }
                    }
                    if (exists == false && key != "__hxstate") {
                        delete data[ic][key];
                    }
                }
            }
            jsonobj.data = data;
            jsonchildren.push(jsonobj);

            if (typeof (Page) != "undefined") {
                if (Page.Children.HasDynColumns == true) {
                    for (var j = 0; j < Page.Children.DynColumnsDefined.length; j++) {
                        if (tablename == Page.Children.DynColumnsDefined[j].tableName) {
                            var jsonObjGrand = {};
                            jsonObjGrand.childtype = "grandson";
                            jsonObjGrand.tablename = Page.Children.DynColumnsDefined[j].tableNameD;
                            jsonObjGrand.father = tablename;
                            var dataGrand = [];
                            for (var d in dataOrg) {
                                for (var k = 0; k < Page.Children.DynColumnsDefined[j].columns.length; k++) {
                                    var fieldColumn = "";
                                    for (var o in Page.Children.DynColumnsDefined[j].columns[0]) {
                                        fieldColumn = o;
                                        break;
                                    }
                                    var dataGrandOne = {};
                                    dataGrandOne.iMainRecNo = dataOrg[d][fieldkey];
                                    dataGrandOne[(Page.Children.DynColumnsDefined[j].columnMatchField)] = Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)];
                                    if (dataOrg[d][(Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)])]) {
                                        dataGrandOne[(Page.Children.DynColumnsDefined[j].columnValueMatchField)] = dataOrg[d][(Page.Children.DynColumnsDefined[j].columns[k][(fieldColumn)])];
                                        dataGrand.push(dataGrandOne);
                                    }
                                }
                            }
                            jsonObjGrand.data = dataGrand;
                            jsonchildren.push(jsonObjGrand);
                        }
                    }
                }
            }
        }

        var iFormID = "";
        var sBillType = document.title;
        if (typeof (Page) != "undefined") {
            iFormID = Page.iformid;
        } else {
            iFormID = "自定义";
        }
        $.ajax({
            url: url,
            type: "POST",
            data: { mainquery: JSON2.stringify(querystr), children: JSON2.stringify(jsonchildren), iFormID: iFormID, sBillType: sBillType },
            cache: false,
            async: false,
            success: function (data) {
                result = data;
                if (result.indexOf("error:") == -1) {
                    var children = $("table[isson='true'][tablename][tablename!='']");
                    for (var i = 0; i < children.length; i++) {
                        $(children[i]).removeAttr("deleteKey");
                        //var data1 = $("#" + children[i].id).datagrid("getRows");
                        var data1 = $("#" + children[i].id).datagrid("getData").originalRows ? $("#" + children[i].id).datagrid("getData").originalRows : $("#" + children[i].id).datagrid("getData").rows;
                        for (var j = 0; j < data1.length; j++) {
                            $("#" + children[i].id).datagrid("updateRow", { row: { __hxstate: "" }, index: j });
                        }
                    }
                }
            },
            error: function (data) {
                $.messager.alert("出错", "与服务器连接失败！");
            }
        });
        return result;
    }
}
function isArray(obj) {
    return Object.prototype.toString.call(obj) === '[object Array]';
}
function deepCopy(destination, source) {
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
function getType(o) {
    var _t;
    return ((_t = typeof (o)) == "object" ? o == null && "null" || Object.prototype.toString.call(o).slice(8, -1) : _t).toLowerCase();
}