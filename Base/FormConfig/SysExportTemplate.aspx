<%@ page language="C#" autoeventwireup="true" inherits="Base_FormConfig_SysFormExportTemple, App_Web_sysexporttemplate.aspx.bce11225" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Base/JS/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        function checkFileExists() {
            var fileNameFull = $("#FileUpload1").val();
            var filename = getFileName(fileNameFull);
            var isExists = false;
            var message = "";
            $.ajax(
                {
                    url: "SysExportTemplate.aspx",
                    async: false,
                    cache: false,
                    data: { otype: "checkExists", filename: filename, iFormID: getQueryString("iFormID"), tableName: getQueryString("tableName"), isDetail: getQueryString("isDetail") },
                    success: function (obj) {
                        if (obj.success == false) {
                            isExists = true;
                            message = obj.message;
                        }
                    },
                    error: function (data) {

                    },
                    dataType: "json"
                }
            )
            if (isExists == true) {
                if (confirm("检测到已存在同名模板，" + message + ",是否继续上传？")) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        function getFileName(o) {
            var pos = o.lastIndexOf("\\");
            return o.substring(pos + 1);
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
            padding: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div>
            <p>
                已导入模板：<asp:Label ID="Label1" runat="server" Text="尚未上传模板" ForeColor="Blue"></asp:Label>（重新导入后可覆盖前一台模板）
            </p>
        </div>
        <hr />
        <div>
            <p>
                <table>
                    <tr>
                        <td>
                            请选择excel文件：
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:FileUpload ID="FileUpload1" runat="server" />
                            <asp:Button ID="Button1" runat="server" Text="上传" OnClick="Button1_Click" OnClientClick="return checkFileExists()" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">
                        </td>
                    </tr>
                </table>
            </p>
        </div>
    </div>
    </form>
</body>
</html>
