<%@ page language="C#" autoeventwireup="true" inherits="Base_FileUpload_showImage, App_Web_showimage.aspx.bb5a45a8" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>大图显示</title>
    <style type="text/css">
        body {
            font-size: 14px;
            font-family: 'Microsoft YaHei';
        }
    </style>
    <script type="text/javascript">
        var maxWidth;
        var maxHeight;
        var minWidth;
        var minHeight;
        window.onload = function () {
            var img = document.getElementById("Image1");
            maxWidth = img.width * 2; //放大的极限值
            maxHeight = img.height * 2; //放大的高度的极限值
            minWidth = img.width * 0.5; //缩小宽度的极限值
            minHeight = img.height * 0.5; //缩小高度的极限值        
        }

        //判断图片是否存在
        function CheckImgExists(imgurl) {
            var ImgObj = new Image(); //判断图片是否存在  
            ImgObj.src = imgurl;
            //没有图片，则返回-1  
            if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
                return true;
            } else {
                return false;
            }
        }

        function maxFun() {
            var img = document.getElementById("Image1");
            if (!CheckImgExists(img.src)) {
                return;
            }
            
            var maxHeight = img.height * 2; //放大的高度的极限值
            var endWidth = img.width * 1.3; //每次点击后的宽度
            var endHeight = img.height * 1.3; //每次点击后的高度
            var maxTimer = setInterval(function () {
                if (img.width < endWidth) {
                    if (img.width < maxWidth) {
                        img.style.width = (img.width * 1.05)+"px";
                        img.style.height = (img.height * 1.05) + "px";
                    } else {
                        alert("已经放大到最大值了")
                        clearInterval(maxTimer);
                    }
                } else {
                    clearInterval(maxTimer);
                }
            }, 20);
        }

        //实现缩小函数
        function minFun() {
            var img = document.getElementById("Image1");
            if (!CheckImgExists(img.src)) {
                return;
            }            

            var endWidth = img.width * 0.7; //每次点击后的宽度
            var endHeight = img.height * 0.7; //每次点击后的高度
            var maxTimer = setInterval(function () {
                if (img.width > endWidth) {
                    if (img.width > minWidth) {
                        img.style.width = (img.width * 0.95)+"px";
                        img.style.height = (img.height * 0.95)+"px";
                    } else {
                        alert("已经缩小到最小值了")
                        clearInterval(maxTimer);
                    }
                } else {
                    clearInterval(maxTimer);
                }
            }, 20);
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center;">
            <table>
                <tr>
                    <td style="text-align: left;" colspan="2">
                        <a href="#" style="text-decoration:none;color:black;" onclick="maxFun()">
                            <img src="images/doMax.png" style="vertical-align: middle;width:25px;height:25px;" />放大
                        </a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="#" style="text-decoration:none;color:black;" onclick="minFun()">
                            <img src="images/doMin.png" style="vertical-align: middle;width:25px;height:25px;" />缩小
                        </a>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Image ID="Image1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;" colspan="2">
                        <asp:HyperLink ID="HyperLink1" runat="server">上一张</asp:HyperLink>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:HyperLink ID="HyperLink2" runat="server">下一张</asp:HyperLink>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
