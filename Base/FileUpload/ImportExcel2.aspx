<%@ page language="C#" autoeventwireup="true" inherits="Base_FileUpload_ImportExcel, App_Web_importexcel2.aspx.bb5a45a8" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="message/js/jquery-1.11.2.min.js" type="text/javascript"></script>
    <script src="message/js/messagebox.min.js" type="text/javascript"></script>
    <link href="message/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="message/css/messagebox.css" rel="stylesheet" type="text/css" />
    <title>导入数据</title>
    <script type="text/javascript">
        function doUpload() {
            document.getElementById("divLoad").style.display = "block";
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
        body {
            font-size: 14px;
            font-family: 'Microsoft YaHei';
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
        .a-upload {
            padding: 4px 10px;
            height: 30px;
            width: 80px;
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
            text-decoration: none;
        }

            .a-upload input {
                position: absolute;
                font-size: 100px;
                right: 0;
                top: 0;
                opacity: 0;
                filter: alpha(opacity=0);
                cursor: pointer;
            }

            .a-upload:hover {
                color: Black;
                background: #eee;
                border-color: #ccc;
                text-decoration: none;
            }

        .btnOr {
            color: White;
            width: 80px;
            height: 30px;
            background-color: #ff8b3d;
            text-decoration: none;
            border: none;
            font-weight: bold;
            border-radius: 1px;
            font-size: 14px;
        }

        .colorFont {
            color: #ff8b3d;
        }

        table {
        }

            table tr td {
                height: 40px;
                vertical-align: middle;
                padding: 2px;
            }

                table tr td .textbox {
                    border: solid 1px #ff8b3d;
                    width: 230px;
                    height: 28px;
                }

                table tr td .btn {
                    background-color: #ff8b3d;
                    height: 30px;
                    border: solid 1px #ff8b3d;
                    border-radius: 0px;
                    width: 60px;
                    font-size: 14px;
                    color: #ffffff;
                    /*font-weight: bold;*/
                }
    </style>
</head>
<body style="vertical-align: middle;">
    <form id="form1" runat="server">
        <div id="divLoad" class="loading" style="display: none;">
        正在上传...
    </div>
        <div style="text-align: center; width: 100%; vertical-align: middle; margin-top: 30px;">
            <table style="margin: auto;">
                <tr>
                    <td style="font-weight: bold;">请选择要导入的文件：
                    </td>
                    <td>
                        <input id="text1" type="text" class="textbox" readonly="readonly" />
                    </td>
                    <td>
                        <input type="button" class="btn" value="浏览" onclick="document.getElementById('FileUpload1').click()" />
                        <div style="display: none;">
                            <asp:FileUpload ID="FileUpload1" runat="server" onchange="document.getElementById('text1').value=this.value" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" style="text-align: left;">注意：导入文件有格式要求，点击
                        <a href="javascript:void(0)" class="colorFont" onclick="downLoadTemplate()">下载导入模板</a>
                    </td>
                </tr>
            </table>
        </div>
        <div style="width: 100%; text-align: center;">
            <asp:Button ID="Button1" runat="server" Text="上传" class="btnOr" OnClick="uploadExcel1"
                OnClientClick="doUpload()" />
        </div>
        <div id="download" style="display: none;">
            <iframe id="ifrD" name="ifrD"></iframe>
        </div>
    </form>
</body>
</html>
