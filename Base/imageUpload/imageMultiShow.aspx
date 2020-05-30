<%@ page language="C#" autoeventwireup="true" inherits="Base_imageUpload_imageMultiShow, App_Web_imagemultishow.aspx.6a2b6d67" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>图片显示</title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=2" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            var box = document.getElementById("divFileName");
            $("#divTitle").bind("mousedown", function (event) {
                event = event || window.event;
                //获取鼠标点击的位置距离div左边的距离
                var positionX = event.clientX - box.offsetLeft;
                var positionY = event.clientY - box.offsetTop;
                document.onmousemove = function(event) {
                    event = event || window.event;
                    var divX = event.clientX - positionX;
                    var divY = event.clientY - positionY;                    
                    box.style.left = divX + 'px';
                    box.style.top = divY + 'px';
                }
                document.onmouseup = function() {
                    document.onmousemove = null;
                }
            })
        })

        function addImage() {
            document.getElementById("FileUpload1").click();
            return false;
        }
        function uploadFile() {
            $("#divFileName").show();
            setFileName();
            return false;
        }

        function getFileName(path) {
            var pos1 = path.lastIndexOf('/');
            var pos2 = path.lastIndexOf('\\');
            var pos = Math.max(pos1, pos2)
            if (pos < 0)
                return path;
            else
                return path.substring(pos + 1);
        }
        function setFileName() {
            var sFullName = document.getElementById("FileUpload1").value;
            var fileName = getFileName(sFullName);
            fileName = fileName.substr(0, fileName.indexOf("."));
            document.getElementById("TextBox1").value = fileName;
        }

        function checkFileName() {
            var fileName = $("#TextBox1").val();
            if (fileName == "") {
                alert("文件名不能为空");
                return false;
            }
            return true;
        }
        function openImageWindow(obj) {
            var iformid = $(obj).attr("iformid");
            var tablename = $(obj).attr("tablename");
            var irecno = $(obj).attr("iRecNo");
            var iTableRecNo = $(obj).attr("iTableRecNo");
            window.open('/Base/FileUpload/showImage.aspx?iTableRecNo=' + iTableRecNo + '&iRecNo=' + irecno + '&iformid=' + iformid + '&tablename=' + tablename, 'height=600, width=800, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
        }
    </script>
    <style type="text/css">
        body {
            font-size: 12px;
            font-family: 'Microsoft YaHei';
        }

        .shadow {
            height: 30px;
            width: 140px;
            border: 1px solid #CCC;
            -moz-box-shadow: inset 0 0 5px #CCC;
            -webkit-box-shadow: inset 0 0 5px #CCC;
            box-shadow: inset 0 0 5px #CCC;
        }

        .lbText {
            display: block;
            text-decoration: none;
            vertical-align: middle;
            line-height: 50px;
            word-wrap: break-word;
        }

        .tab {
            border-collapse: collapse;
            width: 100%;
        }

            .tab tr td {
                border: solid 1px #e0e0e0;
                border-top: none;
                text-align: center;
                vertical-align: middle;
                width: 50px;
                height: 50px;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%; text-align: center;">
            <div style="border: solid 1px #e0e0e0; margin: 0px;">
                <asp:Image ID="Image1" runat="server" />
            </div>
            <div style="text-align: left; width: 100%;">
                <asp:Table ID="Table1" runat="server" CssClass="tab">
                </asp:Table>
            </div>
        </div>
        <div style="display: none;">
            <asp:FileUpload ID="FileUpload1" runat="server" onchange="uploadFile()" />
        </div>
        <div id="divFileName" style="display: none; box-shadow: 1px 1px 5px 5px #888888; background-color: #efefef; width: 200px; height: 100px; z-index: 100; position: absolute; top: 80px; left: 100px; border: solid 2px #a0a0a0;">
            <div id="divTitle" style="height: 25px; background-color:#e0e0e0; cursor:move;border-bottom:solid 1px #a0a0a0;vertical-align:middle;">
                <div style="float:left;margin-left:5px;height:25px; line-height:25px; vertical-align:middle; font-weight:bold;">请输入文件名</div>
                <div style="float:right; margin-right:5px; width:20px; height:25px; line-height:25px; vertical-align:middle; cursor:pointer;text-align:center;" onclick="$('#divFileName').hide()">X</div>
            </div>
            <div>
                <table>
                    <tr>
                        <td style="width: 50px;">文件名
                        </td>
                        <td>
                            <asp:TextBox ID="TextBox1" CssClass="shadow" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <%--<input type="button" value="关闭" onclick="$('#divFileName').hide()" />--%>
                            <asp:Button ID="Button1" runat="server" Text="确定上传" OnClientClick="return checkFileName()" OnClick="Button1_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="height: 10px;">
            </div>
        </div>
    </form>
</body>
</html>
