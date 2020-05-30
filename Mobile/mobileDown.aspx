<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        //string company = Request.Cookies["LastUser"]["company"].ToString();
        try
        {
            //string fileName = tablefile.Rows[0]["iFormID"].ToString() + "_" + tablefile.Rows[0]["sTableName"].ToString() + "_" + tablefile.Rows[0]["iTableRecNo"].ToString() + "_" + tablefile.Rows[0]["sFileName"].ToString();//客户端保存的文件名
            string filePath = Server.MapPath("hxapp.apk");//路径
            FileInfo fileInfo = new FileInfo(filePath);
            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.AddHeader("Content-Disposition", "attachment;filename=hxapp.apk");
            Response.AddHeader("Content-Length", fileInfo.Length.ToString());
            Response.AddHeader("Content-Transfer-Encoding", "binary");
            Response.ContentType = "application/octet-stream";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
            Response.WriteFile(fileInfo.FullName);
            Response.Flush();
            Response.End();
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            font-size: 14px;
            font-family: Verdana;
            padding-top:10px;
            padding-left:20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <p>
        安卓版： 
        <asp:LinkButton ID="LinkButton1" runat="server" onclick="LinkButton1_Click">点击下载</asp:LinkButton>
        <br />
        <br />
        或者扫描二维码：<br />
        <img style="width:150px;height:150px;margin-left:10px;" src="hxapp.png" />
        <br />
        <font style="color:Red;">如果使用微信扫描，请按提示点击右上角选择浏览器中打开下载</font> 
        <br />
        <br />
        <br />
        苹果版： 请到app store中搜索"环鑫科技"下载。
    </p>
        <br />
        <br />
    <p>
        <font style="color:Red; font-weight:bold; font-size:18px;">重要说明：第一次登录必须通过扫描二维码方式登录（二维码在个人中心-二维码名片中）。</font> 
    </p>
    </form>
</body>
</html>
