<%@ page language="C#" autoeventwireup="true" inherits="Base_FileUpload_ImportExcel, App_Web_importexcel.aspx.bb5a45a8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="message/js/jquery-1.11.2.min.js" type="text/javascript"></script>
    <script src="message/js/messagebox.min.js" type="text/javascript"></script>
    <link href="message/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="message/css/messagebox.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
        function doUpload() {
            document.getElementById("divLoad").style.display = "block";
        }
        function getFileName(o) {
            var pos = o.lastIndexOf("\\");
            return o.substring(pos + 1);
        }

        function stepNext(i) {
            $(".divStep").hide();
            $("#div" + (i + 1)).show();
            $(".spanSep" + i).removeClass("colorFont");
            $(".spanSep" + (i + 1)).addClass("colorFont");
        }
        function stepPre(i) {
            $(".divStep").hide();
            $("#div" + (i - 1)).show();
            $(".spanSep" + i).removeClass("colorFont");
            $(".spanSep" + (i - 1)).addClass("colorFont");
        }
        function finish() {
            if (window.parent.hideImport) {
                window.parent.hideImport();
            }
        }
        function showImportInfo() {
            if (window.parent.showImportFinishInfo) {
                window.parent.showImportFinishInfo();
            }
        }
        function downLoadTemplate() {
            var iFormID = getQueryString("iFormID");
            var isDetail = getQueryString("isDetail");
            var tableName = getQueryString("tableName");
            $("#ifrD").attr("src", "ExcelTemplateDownload.aspx?iFormID=" + iFormID + "&isDetail=" + isDetail + "&tableName=" + tableName + "&r=" + Math.random());
        }
        function getQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
    </script>
    <style type="text/css">
        body
        {
            font-size: 12px;
            font-family: Verdana;
        }
        .a-upload 
        {
            padding: 4px 10px;
            height: 20px;
            line-height: 20px;
            position: relative;
            cursor: pointer;
            color: #444;
            background: #fafafa;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
            display: inline-block;
            *display: inline;
            *zoom: 1;
            text-decoration:none;
        }

        .a-upload  input 
        {
            position: absolute;
            font-size: 100px;
            right: 0;
            top: 0;
            opacity: 0;
            filter: alpha(opacity=0);
            cursor: pointer
        }

        .a-upload:hover 
        {
            color: Black;
            background: #eee;
            border-color: #ccc;
            text-decoration: none
        }
        .loading
        {
	        width:100px;
	        height:40px;
	        position: absolute;
	        top:30%;
	        left:30%;
	        line-height:40px;
	        color:#fff;
	        padding-left:40px;
	        font-size:12px;
	        background: #000 url(images/loader.gif) no-repeat 10px 50%;
	        opacity: 0.7;
	        z-index:9999;
	        -moz-border-radius:10px;
	        -webkit-border-radius:10px;
	        border-radius:10px;
	        filter:progid:DXImageTransform.Microsoft.Alpha(opacity=70);
        }
        .btnOr
        {
            color:White;
            width:60px;
            height:25px;
            background-color:#ff8b3d;
            text-decoration:none;
            border:none;
            font-weight:bold;
            border-radius:1px;
        }
        .colorFont
        {
            color:#ff8b3d;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div id="divLoad" class="loading" style="display: none;">
        正在上传...
    </div>
    <div id="div1" class="divStep" style="display: none;">
        <p>
            <span class="spanSep1 colorFont">1.下载模板</span>&nbsp;>&nbsp;<span class="spanSep2">2.导入Excel</span>&nbsp;>&nbsp;
            <span class="spanSep3">3.导入完毕</span>
        </p>
        <p>
            温馨提示：
        </p>
        <p>
            如果已经有导入模板，请直接点击【下一步】
            <br />
            如果没有导入模板，请点击<a href="javascript:void(0)" class="colorFont" onclick="downLoadTemplate()">下载导入模板</a>
        </p>
        <p style="text-align: center;">
            <input id="Button2" type="button" class="btnOr" value="下一步" onclick="stepNext(1)" />
        </p>
    </div>
    <div id="div2" class="divStep" style="display: none;">
        <p>
            <span class="spanSep1">1.下载模板</span>&nbsp;>&nbsp;<span class="spanSep2">2.导入Excel</span>&nbsp;>&nbsp;
            <span class="spanSep3">3.导入完毕</span>
        </p>
        <p style="text-align: center;">
            <table style="margin:auto;">
                <tr>
                    <td>
                        请选择要导入的文件：
                    </td>
                    <td>
                        <asp:FileUpload ID="FileUpload1" runat="server" />
                    </td>
                </tr>
            </table>
        </p>
        <p style="text-align: center;">
            <input id="Button3" type="button" class="btnOr" value="上一步" onclick="stepPre(2)" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" Text="上传" class="btnOr" OnClick="uploadExcel"
                OnClientClick="doUpload()" />
        </p>
    </div>
    <div id="div3" class="divStep" style="display: none;">
        <p>
            <span class="spanSep1">1.下载模板</span>&nbsp;>&nbsp;<span class="spanSep2">2.导入Excel</span>&nbsp;>&nbsp;
            <span class="spanSep3">3.导入完毕</span>
        </p>
        <p>
            文件已上传！点击查看导入记录<a href="javascript:void(0)" class="colorFont" onclick="showImportInfo()">查看导入记录</a>
        </p>
        <p style="text-align: center;">
            <input id="Button4" type="button" class="btnOr" value="上一步" onclick="stepPre(3)" />&nbsp;&nbsp;&nbsp;&nbsp;
            <input id="Button5" type="button" class="btnOr" value="完成" onclick="finish()" />
        </p>
    </div>
    <div id="download" style="display: none;">
        <iframe id="ifrD" name="ifrD"></iframe>
    </div>
    <script language="javascript" type="text/javascript">$("#div1").show();</script>
    </form>
</body>
</html>
