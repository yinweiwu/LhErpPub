// 对Date的扩展，将 Date 转化为指定格式的String 
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
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

function f_clickRowCell(rowIndex, field, value) {
    if (editIndex == undefined) {
        $("#tableMatWasteStock").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
        var ed = $("#tableMatWasteStock").datagrid('getEditor', { index: rowIndex, field: field });
        if (ed) {
            $(ed.target).select();
        }
    }
    else {
        $("#tableMatWasteStock").datagrid('endEdit', editIndex);
        $('#tableMatWasteStock').datagrid('unselectRow', editIndex);
        $("#tableMatWasteStock").datagrid('selectRow', rowIndex)
                  .datagrid('editCell', { index: rowIndex, field: field });
        var ed = $("#tableMatWasteStock").datagrid('getEditor', { index: rowIndex, field: field });
        if (ed) {
            //var target = ed.target;
            $(ed.target).focus();
            $(ed.target).select();
        }
    }
    editIndex = rowIndex;
}
function quit() {
    top.closeTab();
}

function txbMessage(message,id) {
    $("#"+id).val(message);
//    var color = "red";
//    for (var i = 0; i < 20; i++) {
//        setTimeout(function () {
//            $("#txbMessage").css("color", color);
//        }, 100 * (i + 1));
//        if (color == "red") {
//            color = "blue";
//        }
//        else {
//            color = "red";
//        }
//    }
    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 100);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 200);
    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 300);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 400);
    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 500);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 600);
    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 700);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 800);
    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 900);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 1000);

    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 1100);
    setTimeout(function () {
        $("#" + id).css("color", "blue");
    }, 1200);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "red");
//    }, 1300);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "blue");
//    }, 1400);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "red");
//    }, 1500);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "blue");
//    }, 1600);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "red");
//    }, 1700);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "blue");
//    }, 1800);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "red");
//    }, 1900);
//    setTimeout(function () {
//        $("#txbMessage").css("color", "blue");
//    }, 2000);

    setTimeout(function () {
        $("#" + id).css("color", "red");
    }, 1300);
}