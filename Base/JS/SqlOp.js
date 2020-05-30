//获取数据返回数组[]
function SqlGetData(p_parms, p_async, p_ispost,functionname) {
    var json = SqlGetDataGrid(p_parms, p_async, p_ispost, functionname);
    if (p_async == false || p_async == undefined) {
        if (json.Rows) {
            return json.Rows;           
        }
        else {
            return [];
        }
    }
}
//获取数据返回{Rows:[],Total:}
function SqlGetDataGrid(p_parms, p_async, p_ispost, functionname) {
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "plugintype=grid&sqlqueryobj=" + encodeURIComponent(JSON.stringify(p_parms).replace(/%/g, "%25"));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost, functionname);
    if (async == false) {
        if (result && result.length > 0) {
            try {
                var jsonobj = eval("(" + result + ")");
                return jsonobj;
            }
            catch (e) {
                return {};
            }
        }
        else {
            return {};
        }
    }
}
//获取数据，返回数组[]
function SqlGetDataComm(sqltext, p_async, p_ispost,functionName) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "ctype=text&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost, functionName);
    if (async == false) {
        if (result && result.length > 0) {
            try {
                var jsonobj = eval("(" + result + ")");
                return jsonobj;
            }
            catch (e) {
                return [];
            }
        }
        else {
            return [];
        }
    }
}
function SqlExecComm(sqltext, p_async, p_ispost) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "noresult=1&ctype=text&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    return result;
}
function SqlCommExec(sqlobj, iresult, p_async, p_ispost) {
    var noresult = iresult == undefined || iresult == false ? 1 : 0;
    var url = "/Base/Handler/getData.ashx";
    var parms = "noresult="+noresult+"&rowcount=1&ctype=text&sqlobj=" + encodeURIComponent(JSON.stringify(sqlobj));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (noresult == 1) {
        return result;
    }
    else {
        try {
            return JSON2.parse(result);
        }
        catch (e) {
            return [];  
        }
    }
}

function SqlGetDataGridComm(sqltext, p_async, p_ispost) {
    var jsonquery = {
        Commtext: sqltext.replace(/%/g, "%25")
    }
    var url = "/Base/Handler/DataBuilder.ashx";
    var parms = "ctype=text&rowcount=1&sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonquery));
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (result && result.length > 0) {
        try {
            var jsonobj = eval("(" + result + ")");
            return jsonobj;
        }
        catch (e) {
            return { Rows: [], Total: 0 };
        }
    }
    else {
        return { Rows: [], Total: 0 };
    }
}
function SqlExecStore(storename, parmsstr, returnall, p_async, p_ispost,outparm) {
    var jsonobj = {
        StoreProName: storename,
        ParamsStr: parmsstr
    };
    var url = "/Base/Handler/StoreProHandler.ashx";
    var all = returnall == true ? "1" : "0";
    var outparmstr = !!outparm ? "&outparm=" + outparm : "";
    var parms = "sqlqueryobj=" + encodeURIComponent(JSON.stringify(jsonobj)) + "&returnall=" + all + outparmstr;
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (returnall == true) {
        if (result) {
            try {
                var jsonobj = eval("(" + result + ")");
                return jsonobj;
            }
            catch (e) {
                return result;
            }
        }
        else {
            return { Rows: [], Total: 0 }; ;
        }
    }
    else {
        if (result) {
            return result;
        }
        else {
            return "";
        }
    }
}
function SqlStoreProce(storeobj, returnall, p_async, p_ispost) {
    /*var jsonobj = {
        StoreProName: storename,
        StoreParms: parmsobj
    };*/
    var url = "/Base/Handler/StoreProcedure.ashx";
    var all = returnall == true ? "1" : "0";
    var parms = "sqlqueryobj=" + encodeURIComponent(JSON.stringify(storeobj)) + "&returnall=" + all;
    var async = p_async == undefined || p_async == null ? false : p_async;
    var ispost = p_ispost == undefined || p_ispost == null ? true : p_ispost;
    var result = callpostback(url, parms, async, ispost);
    if (returnall == true) {
        if (result) {
            try {
                var jsonobj = eval("(" + result + ")");
                return jsonobj;
            }
            catch (e) {
                return result;
            }
        }
        else {
            return { Rows: [], Total: 0 }; ;
        }
    }
    else {
        if (result) {
            return result;
        }
        else {
            return "";
        }
    }
}
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