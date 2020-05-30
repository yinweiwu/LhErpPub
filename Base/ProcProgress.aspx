<%@ page language="C#" autoeventwireup="true" inherits="FrameFiles_ProcProgress, App_Web_procprogress.aspx.fca1e55" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>流程进度</title>
    <style type="text/css">
        #GridView1
        {
            font-size: 12px;
            margin:auto;
            width:100%;
        }
        #GridView1 tr th
        {
            font-weight: bold;
            height: 25px;
            padding: 5px;
        }
        #GridView1 tr td
        {
            font-weight: bold;
            height: 25px;
            text-align: center;
            padding: 5px;
            font-weight:normal;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="iFormID" HeaderText="iFormID" SortExpression="iFormID"
                    Visible="False" />
                <asp:BoundField DataField="iSerial" HeaderText="节点序号" 
                    SortExpression="iSerial" />
                <asp:BoundField DataField="sCheckName" HeaderText="节点名称" 
                    SortExpression="sCheckName" />
                <asp:BoundField DataField="iBillRecNo" HeaderText="iBillRecNo" SortExpression="iBillRecNo"
                    Visible="False" />
                <asp:BoundField DataField="curtProc" HeaderText="当前节点" ReadOnly="True" SortExpression="curtProc" />
                <asp:BoundField DataField="iRead" HeaderText="iRead" SortExpression="iRead" Visible="False" />
            </Columns>
            <EmptyDataTemplate>
                暂无数据
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:sysBase %>"
            SelectCommand="SpProcessProgress" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="iFormID" QueryStringField="iformid" Type="Int32" />
                <asp:QueryStringParameter Name="irecno" QueryStringField="irecno" 
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    </form>
</body>
</html>
