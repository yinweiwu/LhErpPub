var tdTxbHeight = 25;
var datagridOp = {
    current: undefined, //当前datagrid
    currentColumnName: undefined, //当前列名
    currentColumnIndex: undefined, //当前列号
    currentRowIndex: undefined, //当前行号
    clickColumnName: undefined, //点击的列名
    currentIsEdit: undefined, //是否在编辑中
    currentCustEvent: [], //用户自定的datagrid事件，需要在系统事件后执行
    isEidtorTextarea: undefined, //当前编辑是否为textarea，如果是则敲回车不跳到下一列
    lookUpNotOpen: undefined,
    init: function () {
        //        document.onkeydown = function () {
        //            if (event.keyCode == 13 || event.keyCode == 9) {
        //                if (event.srcElement.tagName.toLowerCase() != "textarea") {
        //                    if (datagridOp.currentIsEdit == true) {
        //                        //如果正在弹窗选择，则不跳到下一个
        //                        if (typeof (lookUp) != "undefined") {
        //                            if (lookUp.isPopupOpen == false && datagridOp.isEidtorTextarea == undefined) {
        //                                datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex, datagridOp.currentColumnName);
        //                            }
        //                        }
        //                    }
        //                    else {
        //                        var isie = (document.all) ? true : false;
        //                        if (isie) {
        //                            event.keyCode = 9;
        //                        }
        //                        else {
        //                            var el = getNextElement(evt.target);
        //                            if (el.type != 'hidden')
        //                                ;   //nothing to do here.
        //                            else
        //                                while (el.type == 'hidden')
        //                                    el = getNextElement(el);
        //                            if (!el)
        //                                return false;
        //                            else
        //                                el.focus();
        //                            //把提交按钮retrun 为false
        //                            return false;
        //                        }
        //                    }
        //                }
        //            }
        //        }
    },
    cellClick: function (tableid, rowIndex, field, value) {
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

        datagridOp.clickColumnName = field;
        var tableObj = $("#" + tableid)[0];
        if ((datagridOp.current == undefined) || (datagridOp.current == tableObj && datagridOp.currentRowIndex == undefined)) {
            $("#" + tableid).datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
            var ed = $("#" + tableid).datagrid('getEditor', { index: rowIndex, field: field });
            doFoucus(ed);
        }
        else {
            if (datagridOp.currentIsEdit) {
                $("#" + datagridOp.current.id).datagrid('endEdit', datagridOp.currentRowIndex); //结束上次编辑的行
            }
            $("#" + datagridOp.current.id).datagrid('unselectRow', datagridOp.currentRowIndex); //取消选择上次编辑的行
            $("#" + tableid).datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
            var ed = $("#" + tableid).datagrid('getEditor', { index: rowIndex, field: field });
            doFoucus(ed);
        }
        datagridOp.current = $("#" + tableid)[0];
        datagridOp.currentColumnName = field;
        datagridOp.currentRowIndex = rowIndex;
        var fields = $("#" + tableid).datagrid('getColumnFields', true).concat($("#" + tableid).datagrid('getColumnFields'));
        for (var i = 0; i < fields.length; i++) {
            if (field == fields[i]) {
                datagridOp.currentColumnIndex = i;
                break;
            }
        }
        for (var i = 0; i < datagridOp.currentCustEvent.length; i++) {
            if (datagridOp.currentCustEvent[i].targetID == tableid) {
                if (datagridOp.currentCustEvent[i].onClickCell) {
                    //datagridOp.currentCustEvent[i].onClickCell(rowIndex, field, value);
                }
                break;
            }
        }
        stopBubble();
    },
    beforeEditor: function (tableid, index, row) {
        if (typeof (lookUp) != "undefined") {
            if (lookUp.isPopupOpen) {
                return false;
            }
        }
        //加入判断下字段是否可编辑
        if (getQueryString("from") == "proc") { //如果是流程中打开的话
            var caneditor = false;
            if (Page.isProcBack == false) {//如果当前节点不是退回的,是退回的继续
                var tablename = $("#" + tableid).attr("tablename");
                for (var i = 0; i < Page.pageProcModifyChildrenFields.length; i++) {
                    if (tablename.toUpperCase() == Page.pageProcModifyChildrenFields[i].split(".")[0].toUpperCase() && datagridOp.clickColumnName == Page.pageProcModifyChildrenFields[i].split(".")[1]) {
                        caneditor = true;
                        break;
                    }
                }
                if (caneditor == false) {
                    return false;
                }
            }
        }
        else {
            if (typeof (Page) != "undefined") {
                if (Page.isChildrenDisabled) {
                    return false;
                }
            }
        }
        var ColumnOption = $("#" + tableid).datagrid("getColumnOption", datagridOp.clickColumnName);
        if (ColumnOption.editor == undefined) {
            return false;
        }
        if (ColumnOption.lookupOptions) {
            if (ColumnOption.lookupOptions.length > 1 || (ColumnOption.lookupOptions.length == 1 && ColumnOption.lookupOptions[0].lookupCat == "popup")) {
                if (ColumnOption.editor) {
                    var datagridid = tableid;
                    var editable = ColumnOption.lookupOptions[0].editable == undefined || ColumnOption.lookupOptions[0].editable == false ? false : true;
                    if (ColumnOption.editor.options) {
                        if (ColumnOption.editor.options.buttonText == undefined) {
                            ColumnOption.editor.options.buttonText = "...";
                            ColumnOption.editor.options.editable = editable;
                            ColumnOption.editor.options.height = tdTxbHeight;
                            ColumnOption.editor.options.icons = [
                                    {
                                        iconCls: 'icon-clear1',
                                        handler: function (e) {
                                            $(e.data.target).textbox("clear");
                                        }
                                    }
                                    ];
                        }
                        if (ColumnOption.editor.options.onClickButton == undefined) {
                            ColumnOption.editor.options.onClickButton = function () {
                                var text = $(this).textbox("textbox").val();
                                var lookupobj = lookUp.getObjByID(datagridid + "_" + datagridOp.currentColumnName);
                                lookUp.current = lookupobj;
                                lookUp.open(text, "button");
                                //lookupobj.open(text);
                            }
                        }
                    }
                    else {
                        ColumnOption.editor.options = {
                            buttonText: "...",
                            editable: editable,
                            height: tdTxbHeight,
                            icons: [
                                    {
                                        iconCls: 'icon-clear1',
                                        handler: function (e) {
                                            $(e.data.target).textbox("clear");
                                        }
                                    }
                                    ],
                            onClickButton: function () {
                                //datagridOp.lookUpBtnClick(datagridid, "#" + tableid);
                                var text = $(this).textbox("textbox").val();
                                var lookupobj = lookUp.getObjByID(datagridid + "_" + datagridOp.currentColumnName);
                                lookUp.current = lookupobj;
                                lookUp.open(text, "button");
                            }
                        }
                    }
                }
            }
        }
        datagridOp.current = $("#" + tableid)[0];
        datagridOp.currentColumnName = datagridOp.clickColumnName;
        datagridOp.currentRowIndex = index;
        var fields = $("#" + tableid).datagrid('getColumnFields', true).concat($("#" + tableid).datagrid('getColumnFields'));
        for (var i = 0; i < fields.length; i++) {
            if (datagridOp.clickColumnName == fields[i]) {
                datagridOp.currentColumnIndex = i;
                break;
            }
        }
        for (var i = 0; i < datagridOp.currentCustEvent.length; i++) {
            if (datagridOp.currentCustEvent[i].targetID == tableid) {
                if (datagridOp.currentCustEvent[i].onBeforeEdit) {
                    datagridOp.currentCustEvent[i].onBeforeEdit(index, row);
                }
                break;
            }
        }
    },
    beginEditor: function (tableid, index, row) {
        try {
            datagridOp.currentIsEdit = true;
            var ColumnOption = $("#" + tableid).datagrid("getColumnOption", datagridOp.currentColumnName);
            var editor = $("#" + tableid).datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
            if (ColumnOption.lookupOptions) {
                if (ColumnOption.lookupOptions.length > 1 || (ColumnOption.lookupOptions.length == 1 && ColumnOption.lookupOptions[0].lookupCat == "popup")) {
                    $(editor.target).textbox("textbox").bind("keydown", function (e) {
                        if (e.keyCode == 13 || e.keyCode == 9 || e.keyCode == 40 || e.keyCode == 38 || e.keyCode == 37 || e.keyCode == 39) {
                            var isOpen = false;
                            if (e.keyCode == 13 || e.keyCode == 9 || e.keyCode == 40 || e.keyCode == 38) {
                                isOpen = true;
                            }
                            else {
                                var event = event ? event : window.event;
                                var obj = event.srcElement ? event.srcElement : event.target;
                                var cursortPosition = getCursortPosition(obj);
                                if (e.keyCode == 37) {                                    
                                    if (cursortPosition == 0) {
                                        isOpen = true;
                                    }
                                }
                                else {
                                    if (cursortPosition == obj.value.length) {
                                        isOpen = true;
                                    }
                                }
                            }
                            if (isOpen) {
                                var text = $(editor.target).textbox("textbox").val();
                                datagridOp.lookUpNotOpen = true;
                                $(datagridOp.current).datagrid("endEdit", datagridOp.currentRowIndex);
                                datagridOp.lookUpNotOpen = undefined;
                                var lookupobj = lookUp.getObjByID(tableid + "_" + datagridOp.currentColumnName);
                                lookUp.current = lookupobj;
                                lookUp.open(text, "text");
                                stopBubble(e);
                                datagridOp.currentIsEdit = true;
                                datagridOp.gotoNextEditor(datagridOp.currentColumnIndex, datagridOp.currentRowIndex, datagridOp.currentColumnName);
                            }                            
                        }
                    });
                    $(editor.target).textbox("textbox").bind("dblclick", function (e) {
                        var text = $(editor.target).textbox("textbox").val();
                        var lookupobj = lookUp.getObjByID(tableid + "_" + datagridOp.currentColumnName);
                        lookUp.current = lookupobj;
                        lookUp.open(text, "text");
                    });
                    //$($(editor.target).textbox("textbox")).attr("isDetailColumnEditting", "true");
                }
            }
            //            if (editor) {
            //                if (editor.type == "text" || editor.type == "textarea" || editor.type == "checkbox") {
            //                    $(editor.target).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "textbox") {
            //                    $($(editor.target).textbox("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "numberbox") {
            //                    $($(editor.target).numberbox("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "datebox") {
            //                    $($(editor.target).datebox("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "datetimebox") {
            //                    $($(editor.target).datetimebox("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "combobox") {
            //                    $($(editor.target).combobox("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //                else if (editor.type == "combotree") {
            //                    $($(editor.target).combotree("textbox")).attr("isDetailColumnEditting", "true");
            //                }
            //            }
        }
        catch (e) {
            datagridOp.currentIsEdit = undefined;
        }
        finally {
            for (var i = 0; i < datagridOp.currentCustEvent.length; i++) {
                if (datagridOp.currentCustEvent[i].targetID == tableid) {
                    if (datagridOp.currentCustEvent[i].onBeginEdit) {
                        datagridOp.currentCustEvent[i].onBeginEdit(index, row);
                    }
                    break;
                }
            }
        }
    },
    endEditor: function (tableid, index, row, change) {
        if (datagridOp.lookUpNotOpen != true) {
            var ColumnOption = $("#" + tableid).datagrid("getColumnOption", datagridOp.currentColumnName);
            if (ColumnOption != null && ColumnOption != undefined) {
                var editor = $("#" + tableid).datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                if (ColumnOption.lookupOptions) {
                    if (ColumnOption.lookupOptions.length > 1 || (ColumnOption.lookupOptions.length == 1 && ColumnOption.lookupOptions[0].lookupCat == "popup")) {
                        //var editor = $("#" + tableid).datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                        if (editor) {
                            var text = $(editor.target).textbox("textbox").val();
                            if (text != "") {
                                var lookupobj = lookUp.getObjByID(tableid + "_" + datagridOp.currentColumnName);
                                lookUp.current = lookupobj;
                                lookUp.open(text, "text");
                            }
                            else {
                                if (change[(datagridOp.currentColumnName)] != undefined && change[(datagridOp.currentColumnName)] != null) {
                                    //alert(1);
                                    var lookupobj = lookUp.getObjByID(tableid + "_" + datagridOp.currentColumnName);
                                    lookUp.current = lookupobj;
                                    var theLookup = lookUp.getLookUpObjByCurrent();
                                    if (theLookup) {
                                        var matchFields = theLookup.matchFields;
                                        var updateRow = {};
                                        for (var i = 0; i < matchFields.length; i++) {
                                            var fieldleft = matchFields[i].split("=")[0];
                                            row[(fieldleft)] = "";
                                        }
                                    }
                                    //$("#" + tableid).datagrid("updateRow", { index: datagridOp.currentRowIndex, row: updateRow });
                                }
                            }
                        }
                    }
                    //树在删除文本框中内容时，要清除值
                    else if (ColumnOption.lookupOptions.length == 1 && ColumnOption.lookupOptions[0].lookupCat != "popup") {
                        var editor = $("#" + tableid).datagrid("getEditor", { index: index, field: datagridOp.currentColumnName });
                        if (editor && editor.type == "combotree") {
                            var text = $($(editor.target).combotree("textbox")).val();
                            if (text == "") {
                                row[(datagridOp.currentColumnName)] = "";
                            }
                        }
                    }
                }
                //                if (editor) {
                //                    if (editor.type == "text" || editor.type == "textarea" || editor.type == "checkbox") {
                //                        $(editor.target).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "textbox") {
                //                        $($(editor.target).textbox("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "numberbox") {
                //                        $($(editor.target).numberbox("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "datebox") {
                //                        $($(editor.target).datebox("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "datetimebox") {
                //                        $($(editor.target).datetimebox("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "combobox") {
                //                        $($(editor.target).combobox("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                    else if (editor.type == "combotree") {
                //                        $($(editor.target).combotree("textbox")).removeAttr("isDetailColumnEditting");
                //                    }
                //                }
            }
        }
    },
    afterEditor: function (tableid, index, row, changes) {
        datagridOp.currentIsEdit = undefined;
        for (var i = 0; i < datagridOp.currentCustEvent.length; i++) {
            if (datagridOp.currentCustEvent[i].targetID == tableid) {
                if (datagridOp.currentCustEvent[i].onAfterEdit) {
                    datagridOp.currentCustEvent[i].onAfterEdit(index, row, changes);
                }
                break;
            }
        }
    },
    gotoNextEditor: function (curtColumnIndex, curtRowIndex) {
        //        if ($(this.current).datagrid("validateRow", curtRowIndex) != true) {
        //            return false;
        //        }
        if (lookUp.isPopupOpen) {
            return false;
        }
        if (this.currentIsEdit == undefined) {
            return false;
        }
        var r = this.getNextColumnName(curtColumnIndex);
        if (r == 0) {
            return false;
        }
        else if (r == 1) {
            var rows = $(this.current).datagrid("getRows");
            datagridOp.lookUpNotOpen = true;
            $(this.current).datagrid("endEdit", curtRowIndex);
            datagridOp.lookUpNotOpen = undefined;
            this.currentIsEdit = true;
            if (curtRowIndex < rows.length - 1) {
                this.gotoNextEditor(-1, curtRowIndex + 1);
            }
            else {
                if (typeof (Page) != "undefined") {
                    Page.tableToolbarClick("add", datagridOp.current.id, {});
                    datagridOp.gotoNextEditor(-1, curtRowIndex + 1);
                }
            }
        }
        else {
            var coloptin = $(this.current).datagrid("getColumnOption", r.field);
            if (coloptin.editor) {
                this.clickColumnName = r.field;
                //$(this.current).datagrid('editCell', { index: rowIndex, field: field });
                datagridOp.lookUpNotOpen = true;
                $(this.current).datagrid("endEdit", curtRowIndex);
                datagridOp.lookUpNotOpen = undefined;
                $(this.current).datagrid("editCell", { index: curtRowIndex, field: r.field });
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
                var ed = $(this.current).datagrid('getEditor', { index: curtRowIndex, field: r.field });
                doFoucus(ed);
                this.currentColumnName = r.field;
                this.currentColumnIndex = r.index;
                this.currentRowIndex = curtRowIndex;
            }
            else {
                this.gotoNextEditor(curtColumnIndex + 1, curtRowIndex);
            }
        }
    },
    getNextColumnName: function (curtColumnIndex) {
        var fields = $(datagridOp.current).datagrid('getColumnFields', true).concat($(datagridOp.current).datagrid('getColumnFields'));
        if (curtColumnIndex > fields.length - 1) {
            return 0; //返回0表示超出列数
        }
        else if (curtColumnIndex == fields.length - 1) {
            return 1; //返回1表示最后一列
        }
        else {
            var columnOption = $(datagridOp.current).datagrid("getColumnOption", fields[curtColumnIndex + 1]);
            if (columnOption && columnOption.editor && columnOption.hidden != true && columnOption.checkbox != true) {
                var result = { field: fields[curtColumnIndex + 1], index: curtColumnIndex + 1 };
                return result;
            }
            else {
                return datagridOp.getNextColumnName(curtColumnIndex + 1);
            }
        }
    },
    gotoPreviousEditor: function (curtColumnIndex, curtRowIndex) {
        if (lookUp.isPopupOpen) {
            return false;
        }
        if (this.currentIsEdit == undefined) {
            return false;
        }
        var r = this.getPreviousColumnName(curtColumnIndex);
        if (r == 0) {
            var rows = $(this.current).datagrid("getRows");
            datagridOp.lookUpNotOpen = true;
            $(this.current).datagrid("endEdit", curtRowIndex);
            //datagridOp.endEditor(this.current.id, curtRowIndex, rows[curtRowIndex]);
            datagridOp.lookUpNotOpen = undefined;
            this.currentIsEdit = true;
            if (curtRowIndex > 0) {
                this.gotoPreviousEditor(100000, curtRowIndex - 1);
            }
        }
        else {
            var coloptin = $(this.current).datagrid("getColumnOption", r.field);
            if (coloptin.editor) {
                this.clickColumnName = r.field;
                //$(this.current).datagrid('editCell', { index: rowIndex, field: field });
                datagridOp.lookUpNotOpen = true;
                $(this.current).datagrid("endEdit", curtRowIndex);
                datagridOp.lookUpNotOpen = undefined;
                $(this.current).datagrid("editCell", { index: curtRowIndex, field: r.field });
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
                var ed = $(this.current).datagrid('getEditor', { index: curtRowIndex, field: r.field });
                doFoucus(ed);
                this.currentColumnName = r.field;
                this.currentColumnIndex = r.index;
                this.currentRowIndex = curtRowIndex;
            }
            else {
                this.gotoPreviousEditor(curtColumnIndex - 1, curtRowIndex);
            }
        }
    },
    getPreviousColumnName: function (curtColumnIndex) {
        var fields = $(datagridOp.current).datagrid('getColumnFields', true).concat($(datagridOp.current).datagrid('getColumnFields'));
        if (curtColumnIndex == 0) {
            return 0;//返回0表示是第0列
        }
        else if (curtColumnIndex > fields.length - 1) {
            curtColumnIndex = fields.length - 1;
        }
        var columnOption = $(datagridOp.current).datagrid("getColumnOption", fields[curtColumnIndex - 1]);
        if (columnOption && columnOption.editor && columnOption.hidden != true && columnOption.checkbox != true) {
            var result = { field: fields[curtColumnIndex - 1], index: curtColumnIndex - 1 };
            return result;
        }
        else {
            return datagridOp.getPreviousColumnName(curtColumnIndex - 1);
        }

    }
}

function getNextElement(field) {
    var form = field.form;
    for (var e = 0; e < form.elements.length; e++) {
        if (field == form.elements[e])
            break;
    }
    return form.elements[++e % form.elements.length];
}

function stopBubble(e) {
    // 如果传入了事件对象，那么就是非ie浏览器
    if (e && e.stopPropagation) {
        //因此它支持W3C的stopPropagation()方法
        e.stopPropagation();
    } else {
        //否则我们使用ie的方法来取消事件冒泡
        window.event.cancelBubble = true;
    }
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
