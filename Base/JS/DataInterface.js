//var VoiceObj = undefined;
//try {
//    VoiceObj = new ActiveXObject("Sapi.SpVoice");
//    VoiceObj.Volume = 100;
//} catch (e) {

//}
//获取数据返回数组[]
function SqlGetData(p_parms, p_async, p_ispost, functionname) {
    if (p_async != true) {
        var resultObj = SqlGetDataResult(p_parms, p_async, p_ispost, functionname);
        if (resultObj.success == true) {
            result = resultObj.tables[0];
            return result;
        }
        else {
            alert(resultObj.message);
            return [];
        }
    }
    else {
        SqlGetDataResult(p_parms, p_async, p_ispost, functionname);
    }
}
function SqlStoreProce(storeobj, returnall, p_async, p_ispost, functionname) {
    if (p_async != true) {
        var resultObj = SqlStoreProceResult(storeobj, returnall, p_async, p_ispost, functionname);
        var result;
        if (resultObj.success == true) {
            if (returnall == true) {
                result = resultObj.tables[0];
            }
            else {
                result = resultObj.message;
            }
            return result;
        }
        else {
            alert(resultObj.message);
            if (returnall == true) {
                result = [];
            }
            else {
                result = "";
            }
            return result;
        }
    }
    else {
        SqlStoreProceResult(storeobj, returnall, p_async, p_ispost, functionname);
    }
    //    var result;
    //    var type = p_ispost == undefined || p_ispost == true ? "POST" : "GET";
    //    var isReturnAll = returnall == true ? 1 : 0;
    //    p_async = p_async != true ? false : true;
    //    $.ajax({
    //        url: "/Base/Handler/DataInterfaceHandler.ashx",
    //        type: type,
    //        async: p_async,
    //        cache: false,
    //        data: { otype: "store", sqlqueryobj: JSON2.stringify(storeobj), returnall: isReturnAll },
    //        success: function (data) {
    //            var resultObj = JSON2.parse(data);
    //            if (resultObj.success == true) {
    //                if (returnall == true) {
    //                    result = resultObj.tables[0];
    //                }
    //                else {
    //                    result = resultObj.message;
    //                }
    //                if (p_async == true) {
    //                    if (functionname) {
    //                        functionname(data);
    //                    }
    //                }
    //            }
    //            else {
    //                alert(resultObj.message);
    //            }
    //        },
    //        error: function (data) {
    //            alert("获取数据时，连接到服务器失败！");
    //            result = [];
    //        }
    //    });
    //    return result;
}

function SqlStoreProceDs(storeobj, p_async, p_ispost, functionname) {
    var resultObj;
    var type = p_ispost == undefined || p_ispost == true ? "POST" : "GET";
    p_async = p_async != true ? false : true;
    $.ajax({
        url: "/Base/Handler/DataInterfaceHandler.ashx",
        type: type,
        async: p_async,
        cache: false,
        data: { otype: "storeDs", sqlqueryobj: JSON2.stringify(storeobj) },
        success: function (data) {
            resultObj = data;
            if (p_async == true) {
                if (functionname) {
                    functionname(data);
                }
            }
        },
        error: function (data) {
            resultObj = { success: false, message: "获取数据时，连接到服务器失败！" };
            if (p_async == true) {
                if (functionname) {
                    functionname(resultObj);
                }
            }
            return resultObj;
        },
        dataType: "json"
    });
    return resultObj;
}

function PlayVoice(str) {
    var audioplayer = document.getElementById("sysBasePlayer");
    if (audioplayer != null) {
        audioplayer.src = "";
        document.body.removeChild(audioplayer);
    }
    if (typeof (str) != 'undefined') {
        if (navigator.userAgent.indexOf("MSIE") > 0) {// IE         
            var player = document.createElement('bgsound');
            player.id = "sysBasePlayer";
            player.src = "";
            player.src = str;
            player.setAttribute('autostart', 'true');
            //            if (loop) {
            //                player.setAttribute('loop', 'infinite');
            //            }
            document.body.appendChild(player);
        } else { // Other FF Chome Safari Opera         
            var player = document.createElement('audio');
            player.id = "sysBasePlayer";
            player.setAttribute('autoplay', 'autoplay');
            //            if (loop) {
            //                player.setAttribute('loop', 'loop');
            //            }
            document.body.appendChild(player);
            var mp3 = document.createElement('source');
            mp3.src = str;
            mp3.type = 'audio/mpeg';
            player.appendChild(mp3);
            //            var ogg = document.createElement('source');
            //            ogg.src = str['ogg'];
            //            ogg.type = 'audio/ogg';
            //            player.appendChild(ogg);
        }
    }

}

function PlayVoiceTTS(str) {
    try {
        VoiceObj.Speak(str, 1);
    }
    catch (exception) {
        alert("Speak error");
    }
}

function SqlGetDataResult(p_parms, p_async, p_ispost, functionname) {
    p_async = p_async != true ? false : true;
    var type = p_ispost == undefined || p_ispost == true ? "POST" : "GET";
    var resultObj;
    $.ajax({
        url: "/Base/Handler/DataInterfaceHandler.ashx",
        type: type,
        async: p_async,
        cache: false,
        data: { otype: "table", sqlqueryobj: JSON2.stringify(p_parms) },
        success: function (data) {
            resultObj = JSON2.parse(data);
            if (p_async == true) {
                if (functionname) {
                    functionname(resultObj);
                }
            }
            //return resultObj;
        },
        error: function (data) {
            resultObj = { success: false, message: "获取数据时，连接到服务器失败！" };
            if (p_async == true) {
                if (functionname) {
                    functionname(resultObj);
                }
            }
            //return resultObj;
        }
    });
    return resultObj;
}

function SqlStoreProceResult(storeobj, returnall, p_async, p_ispost, functionname) {
    var resultObj;
    var type = p_ispost == undefined || p_ispost == true ? "POST" : "GET";
    var isReturnAll = returnall == true ? 1 : 0;
    p_async = p_async != true ? false : true;
    $.ajax({
        url: "/Base/Handler/DataInterfaceHandler.ashx",
        type: type,
        async: p_async,
        cache: false,
        data: { otype: "store", sqlqueryobj: JSON2.stringify(storeobj), returnall: isReturnAll },
        success: function (data) {
            resultObj = JSON2.parse(data);
            if (p_async == true) {
                if (functionname) {
                    functionname(data);
                }
            }
            return resultObj;
        },
        error: function (data) {
            resultObj = { success: false, message: "获取数据时，连接到服务器失败！" };
            if (p_async == true) {
                if (functionname) {
                    functionname(resultObj);
                }
            }
            return resultObj;
        }
    });
    return resultObj;
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
function getSMSBalance() {
    var obj;
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: false,
        cache: false,
        data: { otype: "getSMSBalance" },
        success: function (data) {
            if (resultObj.success == true) {
                result = JSON2.parse(resultObj.message);
            }
            else {
                alert(resultObj.message);
            }
        },
        error: function (data) {
            alert("发生错误：" + data.responseText);
        },
        dataType: "json"
    });
    return result;
}
function sendSMS(mobile, content) {
    var result = "0";
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: false,
        cache: false,
        data: { otype: "sendSMS", mobile: mobile, content: content },
        success: function (data) {
            var resultObj = JSON2.parse(data);
            if (resultObj.success == true) {
                result = "1";
            }
            else {
                alert(resultObj.message);
                result = "0";
            }
        },
        error: function (data) {
            alert("发生错误：" + data.responseText);
            result = "0";
        }
    });
    return result;
}
function sendWeiXinMessage(templet, openid, message, url) {
    var result = false;
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: false,
        cache: false,
        data: { otype: "SendWeiXinMessage", templet: templet, openid: openid, message: JSON2.stringify(message), url: (url == null || url == undefined ? "" : url) },
        success: function (data) {
            if (data.success == true) {
                result = true;
            }
            else {
                result = false;
                console.log(data.message);
                //alert(data.message);
            }
        },
        error: function (data) {
            result = false;
            alert("发生未知错误");
        },
        dataType: "json"
    });
    return result;
}
function sendFormWeiXinMessage(iFormID, iRecNo) {
    var result = false;
    $.ajax({
        url: "/Base/Handler/PublicHandler.ashx",
        type: "post",
        async: false,
        cache: false,
        data: { otype: "SendFormWeiXinMessage", iFormID: iFormID, iRecNo: iRecNo },
        success: function (data) {
            if (data.success == true) {
                result = true;
            }
            else {
                result = false;
                console.log(data.message);
                //alert(data.message);
            }
        },
        error: function (data) {
            result = false;
            alert("发生未知错误");
        },
        dataType: "json"
    });
    return result;
}
function SysOpreateAddLog(opreateType, iformid, ibillRecNo, sBillType) {
    $.ajax({
        url: "/Base/Handler/DataInterfaceHandler.ashx",
        type: "post",
        async: true,
        cache: false,
        data: { otype: "sysOpreateLog", opreateType: opreateType, iformid: iformid, iBillRecNo: ibillRecNo, sBillType: sBillType },
        success: function (data) {

        },
        error: function (data) {

        }
    });
}