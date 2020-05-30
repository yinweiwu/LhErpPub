//需引用jquery,easyui,datainterface.js
var LODOP;
//window.onload = function () {
//    LODOP = getLodop();
//};
var hxLodop = {
    pbDefinedList: [],
    pbDefinedListOriginal:[],
    currentFormID: undefined,
    currentRecNo: undefined,
    currentKey:undefined,
    currentFormIDLink: undefined,
    currentRecNoLink:undefined,
    createNew: function (iformid, key, irecno, filters, params, formlistFileName, iformidLink, irecnoLink) {
        //LODOP = getLodop();
        hxLodop.currentFormID = iformid;
        hxLodop.currentRecNo = irecno;
        hxLodop.currentKey = key;
        hxLodop.currentFormIDLink = iformidLink;
        hxLodop.currentRecNoLink = irecnoLink;
        var pbDefined = null;
        var theRecno = irecnoLink ? irecnoLink : irecno;
        for (var i = 0; i < hxLodop.pbDefinedList.length; i++) {
            if (hxLodop.pbDefinedList[i].iRecNo == theRecno) {
                pbDefined = hxLodop.pbDefinedList[i];
                break;
            }
        }
        if (pbDefined == null) {
            //获取目标报表的定义，如果是有连接，则获取的是连接的定义
            var iformidRequest = iformidLink ? iformidLink : iformid;
            var irecnoRequest = irecnoLink ? irecnoLink : irecno;
            //获取报表定义和数据源
            $.ajax({
                url: "/Base/PbLodop.aspx",
                type: "get",
                async: false,
                cache: false,
                data: { backType: "getPbDefine", iformid: iformidRequest, irecno: irecnoRequest },
                success: function (data) {
                    if (data.success == true) {
                        if (data.tables.length > 0 && data.tables[0].length > 0) {
                            hxLodop.pbDefinedList.push(data.tables[0][0]);
                            pbDefined = data.tables[0][0];
                        } else {
                            MessageShow("报表未定义", "报表未定义");
                        }
                    } else {
                        MessageShow("错误", data.message);
                    }
                },
                error: function (data) {
                    MessageShow("错误", "获取报表定义时发生未知错误");
                },
                dataType: "json"
            });
            //如果有连接的报，原报表定义也要获取
            if (iformidLink) {
                $.ajax({
                    url: "/Base/PbLodop.aspx",
                    type: "get",
                    async: false,
                    cache: false,
                    data: { backType: "getPbDefine", iformid: iformid, irecno: irecno },
                    success: function (data) {
                        if (data.success == true) {
                            if (data.tables.length > 0 && data.tables[0].length > 0) {
                                hxLodop.pbDefinedListOriginal.push(data.tables[0][0]);
                                //pbDefined = data.tables[0][0];
                            } else {
                                MessageShow("报表未定义", "报表未定义");
                            }
                        } else {
                            MessageShow("错误", data.message);
                        }
                    },
                    error: function (data) {
                        MessageShow("错误", "获取报表定义时发生未知错误");
                    },
                    dataType: "json"
                });
            }
        }
        var postData = {
            backType: "getPbDataSource",
            iformid: iformid,
            key: key,
            irecno: irecno,
            filters: filters
        }
        $.extend(postData, params);
        var dataSource = {};
        //获取报表数据源
        $.ajax({
            url: "/Base/PbLodop.aspx",
            type: "post",
            async: false,
            cache: false,
            data: postData,
            success: function (data) {
                if (data.success == true) {
                    dataSource = data.dataset;
                    for (var dataSourceKey in dataSource) {
                        window[dataSourceKey] = dataSource[dataSourceKey];
                    }
                } else {
                    MessageShow("错误", data.message);
                }
            },
            error: function (data) {

            },
            dataType: "json"
        });
        var hxlodop = {
            pbDefined: pbDefined,
            dataSource: dataSource,
            key: key
        }
        return hxlodop;
    },
    preview: function (iformid, key, irecno, filters, params, formlistFileName, copies, iformidLink, irecnoLink) {
        LODOP = getLodop();
        var pbNew = hxLodop.createNew(iformid, key, irecno, filters, params, formlistFileName, iformidLink, irecnoLink);
        var code = pbNew.pbDefined.sPbStr.replace(/&apos;/g, "'");	//打印前变量重读一下最新值
        if (copies && copies > 1) {
            code += " LODOP.SET_PRINT_COPIES(" + copies + ");";
        }
        eval(code);
        //LODOP.SET_PRINT_MODE("CATCH_PRINT_STATUS", true);
        if (LODOP.CVERSION) {
            LODOP.On_Return = function (TaskID, Value) {
                if (Value > 0) {
                    hxLodop.afterPrint(Value);
                }
            };
            LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
            LODOP.PREVIEW();
        } else {
            LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
            var printCount = LODOP.PREVIEW();
            if (printCount > 0) {
                hxLodop.afterPrint(printCount);
            }
        }
        //if (returnFn != null && returnFn != undefined) {
        //    returnFn(iformid, key, irecno);
        //}
        return;
    },
    print: function (iformid, key, irecno, filters, params, formlistFileName, copies, iformidLink, irecnoLink) {
        LODOP = getLodop();
        var pbNew = hxLodop.createNew(iformid, key, irecno, filters, params, formlistFileName, iformidLink, irecnoLink);
        var designCode = pbNew.pbDefined.sPbStr.replace(/&apos;/g, "'");
        if (copies && copies > 1) {
            designCode += " LODOP.SET_PRINT_COPIES(" + copies + ");";
        }
        eval(designCode);
        if (LODOP.CVERSION) {
            LODOP.On_Return = function (TaskID, Value) {
                if (Value == true) {
                    hxLodop.afterPrint(1);
                }
            };
            LODOP.PRINT();
        } else {
            var success = LODOP.PRINT();
            if (success == true) {
                hxLodop.afterPrint(1);
            }
        }
        //if (returnFn != null && returnFn != undefined) {
        //    returnFn(iformid, key, irecno);
        //}
        return;
    },
    setup: function (iformid, key, irecno, filters, params, formlistFileName, iformidLink, irecnoLink) {
        LODOP = getLodop();
        var pbNew = hxLodop.createNew(iformid, key, irecno, filters, params, formlistFileName, iformidLink, irecnoLink);
        var designCode = pbNew.pbDefined.sPbStr;
        eval(designCode);
        LODOP.PRINT_SETUP();
    },
    afterPrint: function (printCount) {
        var pbDefined;
        var iformid = hxLodop.currentFormID;
        var key = hxLodop.currentKey;
        var irecno = hxLodop.currentRecNo;
        if (hxLodop.currentFormIDLink) {
            for (var i = 0; i < hxLodop.pbDefinedListOriginal.length; i++) {
                if (hxLodop.pbDefinedListOriginal[i].iRecNo == irecno) {
                    pbDefined = hxLodop.pbDefinedListOriginal[i];
                    break;
                }
            }
        }

        //打印log
        //获取报表定义和数据源
        $.ajax({
            url: "/Base/Handler/DataInterfaceHandler.ashx",
            type: "get",
            async: false,
            cache: false,
            data: { otype: "sysOpreateLog", opreateType: "打印", iformid: iformid, iBillRecNo: key, sBillType: pbDefined.sPbName },
            success: function (data) {
                if (data.success == true) {
                    if (data.tables.length > 0 && data.tables[0].length > 0) {
                        hxLodop.pbDefinedList.push(data.tables[0][0]);
                        pbDefined = data.tables[0][0];
                    } else {
                        //MessageShow("报表未定义", "报表未定义");
                    }
                } else {
                    //MessageShow("错误", data.message);
                }
            },
            error: function (data) {
                //MessageShow("错误", "获取报表定义时发生未知错误");
            },
            dataType: "json"
        });

        //存储过程有四个固定参数 iFormID,key,sUserID,iPrintCount，分别表示表单号，数据主键值，当前用户，打印数量（直接打印默认1，预览根据用户打印的次数，未打印时不执行此存储过程）
        if (pbDefined.sAfterPrintStoredProcedure) {
            var jsonobj = {
                StoreProName: pbDefined.sAfterPrintStoredProcedure,
                StoreParms: [{
                    ParmName: "@iFormID",
                    Value: iformid
                }, {
                    ParmName: "@key",
                    Value: key
                }, {
                    ParmName: "@sUserID",
                    Value: userid
                }, {
                    ParmName: "@iPrintCount",
                    Value: printCount
                }
                ]
            }
            var result = SqlStoreProce(jsonobj);
            if (result != "1") {
                MessageShow("错误", result);
            }
            else {
                if (hxLodop.printSuccess) {
                    hxLodop.printSuccess(iformid, key, irecno);
                }
            }
        } else {
            if (hxLodop.printSuccess) {
                hxLodop.printSuccess(iformid, key, irecno);
            }
        }
    },
    printSuccess: undefined,
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
    getNowTime: function () {
        var nowdate = new Date();
        var hour = nowdate.getHours();      //获取当前小时数(0-23)
        var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
        var second = nowdate.getSeconds();
        return hour + ":" + minute + ":" + second;
    }
}

function getNowDate() {
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
}
function getNowTime() {
    var nowdate = new Date();
    var hour = nowdate.getHours();      //获取当前小时数(0-23)
    var minute = nowdate.getMinutes();     //获取当前分钟数(0-59)
    var second = nowdate.getSeconds();
    return hour + ":" + minute + ":" + second;
}
function MessageShow(title, message) {
    var iheight = (message.length / 20) * 20;
    iheight = iheight < 100 ? 100 : iheight;
    $.messager.show({
        showSpeed: 100,
        title: title,
        height: iheight,
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