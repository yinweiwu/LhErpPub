<%@ page language="C#" autoeventwireup="true" inherits="Base_imageUpload_imagesShow, App_Web_imagesshow.aspx.6a2b6d67" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>图片显示</title>
    <script src="../JS/easyui_new/jquery.easyui.min.js"></script>
    <script language="javascript" type="text/javascript">
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
            document.getElementById("TextBox2").value = sFullName;
            var fileName = getFileName(sFullName);
            var theNameOld = document.getElementById("TextBox1").value;
            if (theNameOld == "") {
                document.getElementById("TextBox1").value = fileName;
                //document.getElementById("hidfileName").value = fileName;
            }
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
        body{
            font-family:'Microsoft YaHei';
            font-size:12px;
        }
        .btn {
            height: 30px;
            line-height: 30px;
            position: relative;
            color: #888;
            background: #fafafa;
            border: 1px solid #ddd;
            border-radius: 4px;
            top: 0px;
            left: 0px;
            width:60px;
        }

        .shadow {
            height: 30px;
            width: 98%;
            border: 1px solid #CCC;
            -moz-box-shadow: inset 0 0 5px #CCC;
            -webkit-box-shadow: inset 0 0 5px #CCC;
            box-shadow: inset 0 0 5px #CCC;
        }
    </style>
</head>
<body style="padding: 0px; margin: 0px">
    <form id="form1" runat="server">
        <div style="padding: 0px; margin: 0px; width:100%;">
            <table style=" width:100%;">
                <tr>
                    <td colspan="3" style="text-align:center;">
                        <asp:Image ID="Image1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width:50px;">
                        <asp:Label ID="labTypeName" runat="server" Text="图片"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox2" CssClass="shadow" BackColor="#e0e0e0" runat="server"></asp:TextBox>
                    </td>
                    <td style="width:130px;">
                        <input type="button" value="浏览" class="btn" onclick="document.getElementById('FileUpload1').click()" />

                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="labFileTypeName" runat="server" Text="图片名称"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox1" CssClass="shadow" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="btn" runat="server" Text="上传" CssClass="btn" OnClick="Button1_Click" />
                        <asp:Button ID="btnDelete" runat="server" CssClass="btn" Text="删除" OnClick="btnDelete_Click" />
                        <div style="display: none;">
                            <asp:FileUpload ID="FileUpload1" runat="server" onchange="setFileName()" Width="180px" />
                        </div>
                    </td>
                </tr>
            </table>


        </div>
    </form>
</body>
</html>