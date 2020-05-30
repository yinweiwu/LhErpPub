<%@ page language="C#" autoeventwireup="true" inherits="Base_FileUpload_FileUpload, App_Web_fileupload.aspx.bb5a45a8" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/Base/JS/easyui_new/themes/gray/easyui.css?r=2" rel="stylesheet" type="text/css" />
    <link href="/Base/JS/easyui_new/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="/Base/JS/easyui_new/jquery.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="/Base/JS/easyui_new/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <%--<script src="../JS/easyui_new/jquery.easyui.min.js" type="text/javascript"></script>--%>
    <style type="text/css">
        body {
            font-size: 12px;
            font-family: Verdana;
        }

        #GridView1 {
            border: solid 1px #efefef;
            /*border-top: none;*/
        }

            #GridView1 tr td {
                border: solid 1px #efefef;
                height: 25px;
            }

        .a-upload {
            padding: 4px 10px;
            height: 20px;
            line-height: 20px;
            position: relative;
            cursor: pointer;
            color: #888;
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
                color: #444;
                background: #eee;
                border-color: #ccc;
                text-decoration: none;
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
            width: 80px;
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
    <script language="javascript" language="javascript">
        function doUpload() {
            var fileName = document.getElementById("FileUpload1").value;
            document.getElementById("LabFileName").innerHTML = getFileName1(fileName);
            document.getElementById("Button1").click();
        }
        function getFileName1(o) {
            var pos = o.lastIndexOf("\\");
            return o.substring(pos + 1);
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
            document.getElementById("TextBox2").value = sFullName;
            var fileName = getFileName(sFullName);
            //var theNameOld = document.getElementById("TextBox1").value;
            //if (theNameOld == "") {
            document.getElementById("TextBox1").value = fileName;
            //document.getElementById("hidfileName").value = fileName;
            //}
        }
        function openImageWindow(obj) {
            var iformid = $(obj).attr("iformid");
            var tablename = $(obj).attr("tablename");
            var irecno = $(obj).attr("iRecNo");
            var iTableRecNo = $(obj).attr("iTableRecNo");
            window.open('showImage.aspx?iTableRecNo=' + iTableRecNo + '&iRecNo=' + irecno + '&iformid=' + iformid + '&tablename=' + tablename, 'height=600, width=800, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Panel ID="Panel2" runat="server" Style="font-size: 12px; overflow: hidden; text-align: center;">
                <asp:Image ID="Image1" runat="server" />
                <input type="hidden" id="hidSelectRecNo" name="hidSelectRecNo" />
            </asp:Panel>
            <asp:Panel ID="Panel1" runat="server" Style="font-size: 12px; overflow: hidden;">
                <table style="width:100%;">

                    <tr>
                        <td style="width:100px;">
                            <asp:Label ID="labTypeName" runat="server" Text="附件"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="TextBox2" CssClass="shadow" BackColor="#e0e0e0" runat="server"></asp:TextBox>
                        </td>
                        <td style="width:100px;">
                            <input type="button" value="浏览" class="btn" onclick="document.getElementById('FileUpload1').click()" />

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="labFileTypeName" runat="server" Text="附件名称"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="TextBox1" CssClass="shadow" runat="server"></asp:TextBox>
                            <%--<input type="hidden" id="hidfileName" name="hidfileName" />--%>
                        </td>
                        <td>
                            <asp:Button ID="Button1" runat="server" Text="上传" CssClass="btn" OnClick="Button1_Click" />
                            <div style="display: none;">
                                <asp:FileUpload ID="FileUpload1" runat="server" onchange="setFileName()" Width="180px" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: center;">
                            <%----%>
                        </td>
                    </tr>
                </table>
                <div style="display: none;">
                    <a href="javascript:;" class="a-upload">
                        <%--<asp:FileUpload ID="FileUpload1" runat="server" Width="180px" onchange="doUpload()" />--%>
                        选择文件
                    </a>
                    <asp:Label ID="LabFileName" runat="server" Text=""></asp:Label>

                </div>

            </asp:Panel>
            <%--<div style="background-color: #efefef; width: 100%; height: 25px; line-height: 25px;">
                列表
            </div>--%>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Width="100%"
                ShowHeader="False" DataSourceID="SqlDataSource1" DataKeyNames="iRecNo" OnRowDataBound="GridView1_RowDataBound"
                OnRowCommand="GridView1_RowCommand" BorderColor="#CCCCCC">
                <Columns>
                    <asp:BoundField DataField="iRecNo" Visible="False" />

                    <asp:TemplateField>
                        <ItemTemplate>
                            <a href='<%# Eval("iRecNo", "FileDownLoad.aspx?irecno={0}") %>' target="down">
                                <%# Eval("sFileShowName") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="sUserName" >
                    <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="dInputDate" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}"
                        HeaderText="上传日期">
                        <ItemStyle Width="150px" />
                    </asp:BoundField>
                    <asp:CommandField ShowDeleteButton="True" Visible="False">
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                    </asp:CommandField>

                    <asp:TemplateField HeaderText="删除">
                        <ItemStyle Width="60px" HorizontalAlign="Center" VerticalAlign="Middle" />
                        <ItemTemplate>
                            <a href="javascript:void(0)" onclick="$.messager.confirm('您确认删除吗？','您确认删除此文件吗？',function(r){ if(r){ __doPostBack('__Page','deleteFile:<%# Eval("iRecNo") %>') } })">删除</a>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
                <EmptyDataTemplate>
                    <div style="margin: auto; text-align: center;">
                        暂无...
                    </div>
                </EmptyDataTemplate>
                <RowStyle Height="25px" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" SelectCommand="SELECT a.[iRecNo], a.[sFileName],sFileShowName=isnull(a.sFileShowName,a.sFileName),a.[dInputDate],b.sName as sUserName FROM [FileUplad] as a,BscDataPerson as b WHERE ((a.[sTableName] = @sTableName) AND (a.[iTableRecNo] = @iTableRecNo) AND (a.[iFormID] = @iFormID) and a.sUserID=b.sCode and isnull(a.iType,0)=0 )"
                DeleteCommand="DELETE FROM [FileUplad] WHERE [iRecNo] = @iRecNo" InsertCommand="INSERT INTO [FileUplad] ([sFileName]) VALUES (@sFileName)"
                UpdateCommand="UPDATE [FileUplad] SET [sFileName] = @sFileName WHERE [iRecNo] = @iRecNo">
                <DeleteParameters>
                    <asp:Parameter Name="iRecNo" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="sFileName" Type="String" />
                </InsertParameters>
                <SelectParameters>
                    <asp:QueryStringParameter DefaultValue="0" Name="iFormID" QueryStringField="iformid"
                        Type="Int32" />
                    <asp:QueryStringParameter DefaultValue="0" Name="sTableName" QueryStringField="tablename"
                        Type="String" />
                    <asp:QueryStringParameter DefaultValue="0" Name="iTableRecNo" QueryStringField="irecno"
                        Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="sFileName" Type="String" />
                    <asp:Parameter Name="iRecNo" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
        <div style="display: none;">
            <iframe id="down" name="down" height="0px" width="0px"></iframe>
        </div>
    </form>
</body>
</html>
