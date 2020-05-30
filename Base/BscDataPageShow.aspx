<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="JS/kindeditor/themes/default/default.css" rel="stylesheet" type="text/css" />
    <link href="JS/kindeditor/plugins/code/prettify.css" rel="stylesheet" type="text/css" />
    <script src="JS/kindeditor/kindeditor.js" type="text/javascript"></script>
    <script src="JS/kindeditor/lang/zh_CN.js" type="text/javascript"></script>
    <script src="JS/kindeditor/plugins/code/prettify.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            //            $("#__ExtTextBox2").combotree({
            //                multiple: true
            //            });

            //            if (Page.usetype == "modify" || Page.usetype == null) {
            //                var valueArr = Page.pageData.sDepartMent ? Page.pageData.sDepartMent.split(",") : [];

            //                setTimeout(function () { $("#__ExtTextBox2").combotree('setValues', valueArr); }, 1000);
            //            }
        })
        var editor;
        KindEditor.ready(function (K) {
            editor = K.create('#editor_id', {
                cssPath: '/Base/JS/kindeditor/plugins/code/prettify.css',
                uploadJson: '/Base/kindHandler/upload_json.ashx',
                fileManagerJson: '/Base/kindHandler/file_manager_json.ashx',
                allowFileManager: true,
                items: [
                    'source', '|', 'undo', 'redo', '|', 'preview', 'cut', 'copy', 'paste',
                    'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
                    'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
                    'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
                    'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
                    'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage', 'insertfile',
                    'table', 'hr', 'emoticons', 'pagebreak',
                    'anchor', 'link', 'unlink'
                ],
                afterCreate: function () {
                    /*var self = this;
                    K.ctrl(document, 13, function () {
                    self.sync();
                    K('form[name=example]')[0].submit();
                    });
                    K.ctrl(self.edit.doc, 13, function () {
                    self.sync();
                    K('form[name=example]')[0].submit();
                    });*/
                }
            });
            prettyPrint();
            if (Page.usetype == "view" || Page.usetype == null) {
                editor.readonly(true);
            }
        });
        Page.beforeSave = function () {
            editor.sync();
            alert(Page.getFieldValue("sUserID"));
            //var html = editor.html();
            //$("#__ExtHidden1").val(html);
            return true;
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div>
        <table class="tabmain">
            <tr>
                <td>
                    分类
                </td>
                <td colspan="5">
                    <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Width="450px" Z_FieldID="sTitle"
                        Z_Required="True" Z_RequiredTip="分类不能为空" />
                </td>
            </tr>
            <%--<tr>
                <td>
                    面向部门
                </td>
                <td colspan="6">
                    <cc1:exttextbox2 id="ExtTextBox2" runat="server" width="450px" z_fieldid="sDepartMent" />
                </td>
            </tr>--%>
            <tr>
                <%--<td>
                    置顶顺序
                </td>
                <td>
                    <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldtype="整数" width="50" z_fieldid="iSerial"
                        z_value="1" />
                </td>--%>
                <%--<td>
                    过期时间
                </td>
                <td>
                    <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="dExpTime" Z_FieldType="时间" />
                </td>--%>
                <%--                <td>
                    不发布
                </td>
                <td>
                    <cc1:extcheckbox2 id="ExtCheckbox1" runat="server" z_fieldid="iHidden" />
                </td>--%>
            </tr>
            <tr>
                <td>
                    内容：
                    <cc1:ExtHidden2 ID="ExtHidden1" runat="server" Z_FieldID="sUserID" />
                    <cc1:ExtHidden2 ID="ExtHidden2" runat="server" Z_FieldID="dInputDate" />
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <textarea id="editor_id" fieldid="sContent" style="width: 800px; height: 600px;">
                    </textarea>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
