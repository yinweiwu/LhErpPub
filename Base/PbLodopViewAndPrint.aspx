<%@ page language="C#" autoeventwireup="true" inherits="Base_PbLodopDesign, App_Web_pblodopviewandprint.aspx.fca1e55" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
     <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="JS/DataInterface.js" type="text/javascript"></script>
    <script src="/Base/JS/json2.js" type="text/javascript"></script>
    <script language="javascript" src="/Base/Lodop/LodopFuncs.js?r=1"></script>
    <object id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width="0" height="0">
        <embed id="LODOP_EM" type="application/x-print-lodop" width="0" height="0"></embed>
    </object>
    <script type="text/javascript">
        var dataSourceDefined;
        var LODOP;
        window.onload = function () {
            try {
                LODOP = getLodop();
            } catch (e) {

            }
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input id="txbPrintJob" type="hidden" />
        </div>
        <script type="text/javascript">
            function exportExcel() {
                var code = $("#txaDesinCodeSave").val()
                LODOP = getLodop();
                eval(code);
                if (LODOP.CVERSION) CLODOP.On_Return = null;
                LODOP.SET_SAVE_MODE("Orientation", 2); //Excel文件的页面设置：横向打印   1-纵向,2-横向;
                LODOP.SET_SAVE_MODE("PaperSize", 9);  //Excel文件的页面设置：纸张大小   9-对应A4
                LODOP.SET_SAVE_MODE("Zoom", 90);       //Excel文件的页面设置：缩放比例
                LODOP.SET_SAVE_MODE("CenterHorizontally", true);//Excel文件的页面设置：页面水平居中
                LODOP.SET_SAVE_MODE("CenterVertically", true); //Excel文件的页面设置：页面垂直居中
                //		LODOP.SET_SAVE_MODE("QUICK_SAVE",true);//快速生成（无表格样式,数据量较大时或许用到） 
                LODOP.SAVE_TO_FILE("新文件名.xls");
            }

            function getQueryString(name) {
                var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
                var r = window.location.search.substr(1).match(reg);
                if (r != null) return unescape(r[2]); return null;
            }

            function PrintPreview() {
                doPreview(1);
            }
            function PrintSetup() {
                LODOP = getLodop();
                var designCode = pbDefined[0].sPbStr;
                eval(designCode);
                LODOP.PRINT_SETUP();
            }
            function doPreview(itype) {
                var code = pbDefined[0].sPbStr.replace(/&apos;/g, "'");	//打印前变量重读一下最新值
                LODOP = getLodop();
                eval(code);
                //LODOP.SET_PRINT_MODE("CATCH_PRINT_STATUS", true);
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        if (Value > 0) {
                            afterPrint(Value);
                        }
                    };
                    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
                    LODOP.PREVIEW();                    
                } else {
                    LODOP.SET_SHOW_MODE("LANDSCAPE_DEFROTATED", 1);
                    var printCount = LODOP.PREVIEW();
                    afterPrint(printCount);
                }
                var returnFn = getQueryString("returnFn");
                var iformid = getQueryString("iformid");
                var key = getQueryString("key");
                var irecno = getQueryString("irecno");
                if (returnFn != null && returnFn != undefined) {
                    if (window.opener) {
                        eval("window.opener." + returnFn + "(" + iformid + "," + key + "," + irecno + ")");
                    }
                    else {
                        if (window.parent) {
                            eval("window.parent." + returnFn + "(" + iformid + "," + key + "," + irecno + ")");
                        }
                    }
                }
                return;
            }
            function Print() {
                LODOP = getLodop();
                var designCode = pbDefined[0].sPbStr.replace(/&apos;/g, "'");
                eval(designCode);
                //LODOP.SET_PRINT_MODE("CATCH_PRINT_STATUS", true);
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        //document.getElementById('txbPrintJob').value = Value;
                        //printEvent();
                        if (Value == true) {
                            afterPrint(1);
                        }
                    };
                    LODOP.PRINT();
                } else {
                    var success = LODOP.PRINT();
                    if (success == true) {
                        afterPrint(1);
                    }
                }
                var returnFn = getQueryString("returnFn");
                var iformid = getQueryString("iformid");
                var key = getQueryString("key");
                var irecno = getQueryString("irecno");
                if (returnFn != null && returnFn != undefined) {
                    if (window.opener) {
                        eval("window.opener." + returnFn + "(" + iformid + "," + key + "," + irecno + ")");
                    }
                    else {
                        if (window.parent) {
                            eval("window.parent." + returnFn + "(" + iformid + "," + key + "," + irecno + ")");
                        }
                    }
                }
                return;
            }

            function afterPrint(printCount) {
                //alert(1);
                var iformid = getQueryString("iformid");
                var key = getQueryString("key");
                var irecno = getQueryString("irecno");
                if (iformid == pbDefined[0].iFormID && irecno == pbDefined[0].iRecNo) {
                    //存储过程有四个固定参数 iFormID,key,sUserID,iPrintCount，分别表示表单号，数据主键值，当前用户，打印数量（直接打印默认1，预览根据用户打印的次数，未打印时不执行此存储过程）
                    if (pbDefined[0].sAfterPrintStoredProcedure) {
                        var jsonobj = {
                            StoreProName: pbDefined[0].sAfterPrintStoredProcedure,
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
                            alert(result);
                        }
                        else {
                            if (window.opener) {
                                window.opener.GridRefresh();
                            }
                            else if (window.parent && window.parent.FormList) {
                                window.parent.FormList.NeedSelectedKey = null;
                                window.parent.GridRefresh();
                            }
                            else {
                                window.returnValue = "1";
                            }
                        }
                    }
                }
            }


            function printEvent() {
                

                var jobCode = document.getElementById('txbPrintJob').value;
                if (LODOP.CVERSION) {
                    LODOP.On_Return = function (TaskID, Value) {
                        if (Value == "0") {
                            afterPrint();
                        }
                    };
                }
                var strResult = LODOP.GET_VALUE("PRINT_STATUS_EXIST", jobCode);
                if (!LODOP.CVERSION) {
                    if (strResult == "0") {
                        afterPrint();
                    }
                }
            }

            var compare = function (prop) {
                return function (obj1, obj2) {
                    var val1 = obj1[prop];
                    var val2 = obj2[prop];
                    if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                        val1 = Number(val1);
                        val2 = Number(val2);
                    }
                    if (val1 < val2) {
                        return -1;
                    } else if (val1 > val2) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            }

        </script>
    </form>
</body>
</html>
