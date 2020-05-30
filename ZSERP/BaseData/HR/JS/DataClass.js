var selectedNode;
var itype;
var LookUp;
$(function () {
    LookUp = new LookUpObj();
    itype = getQueryString("itype");
    document.getElementById("ExtHidden1").value = itype;
    if (itype == "01") {
        document.getElementById("divpur").style.display = "block";
        //document.getElementById("TableName")
    }
    else if (itype == "07") {
        document.getElementById("divdept").style.display = "block";
    }
    /*else if (itype == "10") {
        document.getElementById("divAssets").style.display = "block";
    }*/
    else if (itype == "09") {
        document.getElementById("divMachine").style.display = "block";
    }
    var height = document.documentElement.clientHeight;
    $("#layout1").ligerLayout({ leftWidth: 250 });
    $("#accordion1").ligerAccordion(
    {
        height: height - 50
    });
    $("#accordion2").ligerAccordion(
    {
        height: height - 50
    });
    var data;
    if (itype != '01' && itype != '03') {
        var jsontreefilter = [{
            Field: "iType",
            ComOprt: "=",
            Value: "'" + itype + "'"
        }];
        var jsontree = {
            TableName: "bscDataClass",
            Fields: "iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName",
            SelectAll: "True",
            Filters: jsontreefilter,
            Sorts: [
                { SortName: "sClassID",
                    SortOrder: "asc"
                }
            ]
        }
        data = SqlGetData(jsontree, false, true);
    }
    else {
        if (itype == '01') {
            var sqltext = "select * from(" +
                           "select 0 as iRecNo,'01' as iType, '0' as sParentID,a.sCode as sClassID,isnull(a.sCode,'')+'-'+a.sName as sName,sName as sClassName from BscDataListD as a where a.sClassID='matClass' " +
                            "union " +
                            " select iRecNo,iType,sParentID,sClassID,sClassID+'-'+sClassName as sName,sClassName from bscDataClass where iType='01'" +
            ") as a order by sClassID";
            data = SqlGetDataComm(sqltext);
        }
        else if (itype == '03') {
            var sqltext = "select iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName " +
                      "from bscDataClass where iType='03' " +
                      "union " +
                      "select 0 as iRecNo,sCode as sClassID,sName as sClassName,'0' as sParentID,'03' as iType," +
                      "sCode+'-'+sName AS sName from BscDataListD where sClassID='matClass'";
            data = SqlGetDataComm(sqltext);
        }
    }
    $("#tree1").ligerTree({
        checkbox: false,
        data: data,
        idFieldName: 'sClassID',
        parentIDFieldName: 'sParentID',
        textFieldName: 'sName',
        attribute: ['iRecNo,iType,sClassName'],
        btnClickToToggleOnly: true,
        nodeWidth: 150,
        onSelect: f_treeSelect,
        isExpand: true
    });
    //分类类型
    var jsonclassfilter = [
    {
        Field: "sClassID",
        ComOprt: "=",
        Value: "'DataClassType'"
    }
    ]
    var jsonclasssort = [
    {
        SortName: "sCode",
        SortOrder: "asc"
    }
    ]
    var jsonclass = {
        TableName: "BscDataListD",
        Fields: "sCode,sName",
        SelectAll: "True",
        Filters: jsonclassfilter,
        Sorts: jsonclasssort
    }

    $("#tool").ligerToolBar({
        items: [
            { id: 'addm', text: '新增分类', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif' },
            { line: true },
            { id: 'addc', text: '新增子分类', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/add.gif' },
            { line: true },
            { id: 'delete', text: '删除子分类', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/delete.gif' },
            { line: true },
            { id: 'save', text: '保存', click: itemclick, img: '/Base/JS/lib/ligerUI/skins/icons/save.gif' }
            ]
    });
    LookUp.lookupinit();
})
function itemclick(item) {
    if (item.id == "addm") {
        if (itype == "01" || itype == "03") {
            if (selectedNode) {
                if (selectedNode.data.iRecNo == "0") {
                    alert("根分类请在公共数据-物料分类中增加");
                    return;
                }
            }
            else {
                alert("根分类请在公共数据-物料分类中增加");
                return;
            }
        }
        var irecno = getChildID("bscDataClass");
        document.getElementById("FieldKeyValue").value = irecno;
        //var classtype = $.ligerui.get('ExtTextBox1');
        //如果有选择节点
        if (selectedNode) {
            //分类父节点编号
            document.getElementById("pbh").value = selectedNode.data.sParentID;
            var sqltext = "select max(sClassID) as r from bscDataClass where iType='" + itype + "' and sParentID='" + selectedNode.data.sParentID + "'";
            var maxclassid = "";
            var jsonresult = SqlGetDataComm(sqltext);
            if (jsonresult.length > 0) {
                var mclassid = jsonresult[0].r;
                if (parseInt(mclassid.substr(mclassid.length - 1, 1)) >= 0 && parseInt(mclassid.substr(mclassid.length - 1, 1)) < 9) {
                    maxclassid = mclassid.substr(0, mclassid.length - 1) + (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                }
                else {
                    if (mclassid.length >= 2) {
                        maxclassid = mclassid.substr(0, mclassid.length - 2) + (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                    }
                    else {
                        maxclassid = (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                    }
                }
            }
            else {
                maxclassid = "01";
            }

            var tree = $.ligerui.get('tree1');
            var pnode = tree.getParentTreeItem(selectedNode.data.treedataindex);
            var ptext = "";
            //var pdom = tree.getNodeDom(pnode);
            if (pnode) {
                var phtml = pnode.innerHTML;
                var findex = phtml.indexOf("<span>");
                var lindex = phtml.indexOf("</span>");
                ptext = phtml.substr(findex + 6, lindex - findex - 6);
                ptext = ptext.substr(ptext.indexOf("-") + 1, ptext.length - ptext.indexOf("-") - 1);
            }
            document.getElementById("ExtTextBox1").value = ptext;
            document.getElementById("cbh").value = maxclassid;
            document.getElementById("ExtTextBox3").focus();
        }
        else {
            document.getElementById("pbh").value = "0";

            var sqltext = "select max(sClassID) as r from bscDataClass where iType='" + itype + "' and sParentID='0'";
            var maxclassid = "";
            var jsonresult = SqlGetDataComm(sqltext);
            if (jsonresult.length > 0) {
                var mclassid = jsonresult[0].r;
                if (mclassid != "") {
                    if (parseInt(mclassid.substr(mclassid.length - 1, 1)) >= 0 && parseInt(mclassid.substr(mclassid.length - 1, 1)) < 9) {
                        maxclassid = mclassid.substr(0, mclassid.length - 1) + (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                    }
                    else {
                        if (mclassid.length >= 2) {
                            maxclassid = mclassid.substr(0, mclassid.length - 2) + (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                        }
                        else {
                            maxclassid = (parseInt(mclassid.substr(mclassid.length - 1, 1)) + 1).toString();
                        }
                    }
                }
                else {
                    maxclassid = "01";
                }
            }
            else {
                maxclassid = "01";
            }
            document.getElementById("cbh").value = maxclassid;
            document.getElementById("ExtTextBox3").focus();

        }

        var input = document.getElementById("divmain").getElementsByTagName("INPUT");
        var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
        var select = document.getElementById("divmain").getElementsByTagName("SELECT");
        for (var i = 0; i < input.length; i++) {
            if (input[i].type != "checkbox" && input[i].type != "hidden") {
                if (input[i].id != "pbh" && input[i].id != "cbh" && input[i].id != "ExtTextBox1") {
                    input[i].value = "";
                }
            }
            else if (input[i].type == "checkbox") {
                input[i].checked = false;
            }
        }
        for (var i = 0; i < textarea.length; i++) {
            textarea[i].value = "";
        }
        for (var i = 0; i < select.length; i++) {
            select[i].value = "";
        }
    }
    if (item.id == "addc") {
        if (itype == "01" || itype == "03") {
            if (selectedNode) {
                
            }
            else {
                alert("根分类请在公共数据-物料分类中增加");
                return;
            }
        }

        var irecno = getChildID("bscDataClass");
        document.getElementById("FieldKeyValue").value = irecno;
        //var classtype = $.ligerui.get('ExtTextBox1');
        //如果有选择节点
        if (selectedNode) {
            //分类父节点编号
            document.getElementById("pbh").value = selectedNode.data.sClassID;
            document.getElementById("ExtTextBox1").value = selectedNode.data.sClassName;
            var maxid = "";
            var ccount = selectedNode.data.children == null ? 0 : selectedNode.data.children.length;
            if (ccount < 10) {
                maxid = "0" + (ccount + 1).toString();
            }
            else {
                maxid = (ccount + 1).toString();
            }

            /*var tree = $.ligerui.get('tree1');
            var pnode = tree.getParentTreeItem(selectedNode.data.treedataindex);
            var ptext = "";
            //var pdom = tree.getNodeDom(pnode);
            if (pnode) {
                var phtml = pnode.innerHTML;
                var findex = phtml.indexOf("<span>");
                var lindex = phtml.indexOf("</span>");
                ptext = phtml.substr(findex + 6, lindex - findex - 6);
                ptext = ptext.substr(ptext.indexOf("-") + 1, ptext.length - ptext.indexOf("-") - 1);
            }*/
            document.getElementById("ExtTextBox1").value = selectedNode.data.sClassName;

            document.getElementById("cbh").value = selectedNode.data.sClassID + maxid;
            document.getElementById("ExtTextBox3").focus();
        }
        else {
            document.getElementById("pbh").value = "0";
        }

        var input = document.getElementById("divmain").getElementsByTagName("INPUT");
        var textarea = document.getElementById("divmain").getElementsByTagName("TEXTAREA");
        var select = document.getElementById("divmain").getElementsByTagName("SELECT");
        for (var i = 0; i < input.length; i++) {
            if (input[i].type != "checkbox" && input[i].type != "hidden") {
                if (input[i].id != "pbh" && input[i].id != "cbh" && input[i].id != "ExtTextBox1") {
                    input[i].value = "";
                }
            }
            else if (input[i].type == "checkbox") {
                input[i].checked = false;
            }
        }
        for (var i = 0; i < textarea.length; i++) {
            textarea[i].value = "";
        }
        for (var i = 0; i < select.length; i++) {
            select[i].value = "";
        }
    }
    else if (item.id == "delete") {
        if (selectedNode) {
            var tree = $.ligerui.get('tree1');
            if (tree.hasChildren(selectedNode)) {
                alert("请先删除子分类！");
                return;
            }
            else {
                var irecno = selectedNode.data.iRecNo;
                irecno = irecno == "" ? "0" : irecno;
                if (irecno == "0") {
                    alert("根分类请在公共数据中修改！");
                }
                else {
                    if (confirm("确认删除所选择分类？")) {
                        var jsonobj = {
                            StoreProName: "SpDeleteOrModify",
                            ParamsStr: getQueryString("FormID") + ",'" + document.getElementById("TableName").value + "','" + document.getElementById("FieldKey").value + "'," + irecno + ",'',1"
                        }
                        url = "/Base/Handler/StoreProHandler.ashx";
                        parms = "sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj));
                        async = false;
                        ispost = true;
                        var result = callpostback(url, parms, async, ispost); //返回字符，需要在存储过程中以select返回结果。
                        if (result == "1") {
                            alert("删除成功！");
                            var data;
                            if (itype != '01' && itype != '03') {
                                var jsontreefilter = [{
                                    Field: "iType",
                                    ComOprt: "=",
                                    Value: "'" + itype + "'"
                                }];
                                var jsontree = {
                                    TableName: "bscDataClass",
                                    Fields: "iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName",
                                    SelectAll: "True",
                                    Filters: jsontreefilter
                                }
                                data = SqlGetData(jsontree, false, true);
                            }
                            else {
                                if (itype == '01') {
                                    var sqltext = "select * from(" +
                           "select 0 as iRecNo,'01' as iType, '0' as sParentID,a.sCode as sClassID,a.sCode+'-'+a.sName as sName,sName as sClassName from BscDataListD as a where a.sClassID='matClass' " +
                            "union " +
                            " select iRecNo,iType,sParentID,sClassID,sClassID+'-'+sClassName as sName,sClassName from bscDataClass where iType='01'" +
            ") as a order by sClassID";
                                    data = SqlGetDataComm(sqltext);
                                }
                                else if (itype == '03') {
                                    var sqltext = "select iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName " +
                      "from bscDataClass where iType='03' " +
                      "union " +
                      "select 0 as iRecNo,sCode as sClassID,sName as sClassName,'0' as sParentID,'03' as iType," +
                      "sCode+'-'+sName AS sName from BscDataListD where sClassID='matClass'";
                                    data = SqlGetDataComm(sqltext);
                                }
                            }
                            var tree = $.ligerui.get('tree1');
                            tree.clear()
                            tree.setData(data);
                            selectedNode = undefined;
                        }
                        else {
                            alert(result);
                        }
                    }
                }
            }
        }
        else {
            alert("请选择要删除的分类！");
        }
    }
    else if (item.id == "save") {
        var irecno = document.getElementById("FieldKeyValue").value;
        irecno = irecno == "" ? "0" : irecno;
        if (irecno == "0") {
            alert("没有可保存的数据！");
        }
        else {
            var cid = document.getElementById("cbh").value;
            var pid = document.getElementById("pbh").value;
            if (cid == pid) {
                alert("子分类编号不能于父分类编号相同！");
                return;
            }
            if (cid.substr(0, pid.length) != pid) {
                alert("子分类编号必须包含父分类编号！")
                return;
            }
            var sqltext = "select count(*) as r from bscDataClass where iRecNo=" + irecno;
            var resultjson = SqlGetDataComm(sqltext);
            if (resultjson[0].r == "1") {
                var or = operateupdate(irecno, "/Base/Handler/DataOperatorNew.ashx");
                if (or.indexOf("error") > -1) {
                    alert(or);
                }
                else {
                    alert("保存成功！");
                    var data;
                    if (itype != '01' && itype != '03') {
                        var jsontreefilter = [{
                            Field: "iType",
                            ComOprt: "=",
                            Value: "'" + itype + "'"
                        }];
                        var jsontree = {
                            TableName: "bscDataClass",
                            Fields: "iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName",
                            SelectAll: "True",
                            Filters: jsontreefilter,
                            Sorts: [
                                { 
                                    SortName: "sClassID",
                                    SortOrder: "asc"
                                }
                            ]
                        }
                        data = SqlGetData(jsontree, false, true);
                    }
                    else {
                        if (itype == '01') {
                            var sqltext = "select * from(" +
                           "select 0 as iRecNo,'01' as iType, '0' as sParentID,a.sCode as sClassID,a.sCode+'-'+a.sName as sName,sName as sClassName from BscDataListD as a where a.sClassID='matClass' " +
                            "union " +
                            " select iRecNo,iType,sParentID,sClassID,sClassID+'-'+sClassName as sName,sClassName from bscDataClass where iType='01'" +
            ") as a order by sClassID";
                            data = SqlGetDataComm(sqltext);
                        }
                        else if (itype == '03') {
                            var sqltext = "select iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName " +
                      "from bscDataClass where iType='03' " +
                      "union " +
                      "select 0 as iRecNo,sCode as sClassID,sName as sClassName,'0' as sParentID,'03' as iType," +
                      "sCode+'-'+sName AS sName from BscDataListD where sClassID='matClass'";
                            data = SqlGetDataComm(sqltext);
                        }
                    }
                    var tree = $.ligerui.get('tree1');
                    tree.clear()
                    tree.setData(data);
                }
            }
            else {
                var or = oprateadd("/Base/Handler/DataOperatorNew.ashx");
                if (or.indexOf("error") > -1) {
                    alert(or);
                }
                else {
                    alert("保存成功！");
                    var data;
                    if (itype != '01' && itype != '03') {
                        var jsontreefilter = [{
                            Field: "iType",
                            ComOprt: "=",
                            Value: "'" + itype + "'"
                        }];
                        var jsontree = {
                            TableName: "bscDataClass",
                            Fields: "iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName",
                            SelectAll: "True",
                            Filters: jsontreefilter
                        }
                        data = SqlGetData(jsontree, false, true);
                    }
                    else {
                        if (itype == '01') {
                            var sqltext = "select * from(" +
                           "select 0 as iRecNo,'01' as iType, '0' as sParentID,a.sCode as sClassID,a.sCode+'-'+a.sName as sName,sName as sClassName from BscDataListD as a where a.sClassID='matClass' " +
                            "union " +
                            " select iRecNo,iType,sParentID,sClassID,sClassID+'-'+sClassName as sName,sClassName from bscDataClass where iType='01'" +
            ") as a order by sClassID";
                            data = SqlGetDataComm(sqltext);
                        }
                        else if (itype == '03') {
                            var sqltext = "select iRecNo,sClassID,sClassName,sParentID,iType,sClassID+'-'+sClassName as sName " +
                      "from bscDataClass where iType='03' " +
                      "union " +
                      "select 0 as iRecNo,sCode as sClassID,sName as sClassName,'0' as sParentID,'03' as iType," +
                      "sCode+'-'+sName AS sName from BscDataListD where sClassID='matClass'";
                            data = SqlGetDataComm(sqltext);
                        }
                    }
                    var tree = $.ligerui.get('tree1');
                    tree.clear()
                    tree.setData(data);
                }
            }
        }
    }
}
function f_treeSelect(node) {

    selectedNode = node;
    document.getElementById("FieldKeyValue").value = node.data.iRecNo;

    var tree = $.ligerui.get('tree1');
    var pnode = tree.getParentTreeItem(node.data.treedataindex);
    var ptext = "";
    //var pdom = tree.getNodeDom(pnode);
    if (pnode) {
        var phtml = pnode.innerHTML;
        var findex = phtml.indexOf("<span>");
        var lindex = phtml.indexOf("</span>");
        ptext = phtml.substr(findex + 6, lindex - findex - 6);
        ptext = ptext.substr(ptext.indexOf("-") + 1, ptext.length - ptext.indexOf("-") - 1);
    }

    document.getElementById("ExtTextBox1").value = ptext;
    var itype = getQueryString("itype");
    if (node.data.iRecNo == "0" && (itype == "01" || itype == "03")) {
        document.getElementById("ExtTextBox3").value = node.data.sClassName;
        document.getElementById("cbh").value = node.data.sClassID;
        document.getElementById("pbh").value = "";
    }
    else {
        pageinit();
        LookUp.lookupdatainit();
    }
}