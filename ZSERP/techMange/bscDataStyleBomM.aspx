<%@ Page Title="" Language="VB" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="JS/bscDataStyleBomM.js?<%= Guid.NewGuid() %>" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" Runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true">
        <div data-options="region:'north'" style="overflow: hidden;">
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>
                        款号
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox1" runat="server" Z_FieldID="iBscDataStyleMRecNo" Z_Required="true"  />
                    </td>
                    <td>
                        款式名称
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox8" runat="server" Z_FieldID="sTyleName"  Z_NoSave="true"  Z_disabled="true"/>
                    </td>
                   
                    <td>尺码组</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox4" runat="server" Z_FieldID="sSizeGroupID"  Z_NoSave="true" Z_disabled="true" />
                    </td>
                    <td rowspan="3">
                        <cc1:ExtFile ID="ExtFile1" runat="server" Z_FileType="图片" Z_ImageHeight="70" Z_ImageWidth="70"  >
                                </cc1:ExtFile>
                    </td>
                </tr>
                <tr>
                    <td>日期</td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox2" Z_FieldType="日期" runat="server" Z_FieldID="dDate"
                            Z_Required="true" />
                    </td>
                    <td>
                        颜色
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox3" runat="server" Z_FieldID="iBscDataColorRecNo"  />
                    </td>
                    <td>
                        版本说明
                    </td>
                    <td colspan="3">
                        <cc1:ExtTextBox2 ID="ExtTextBox5" runat="server" Z_FieldID="sLabelReMark"  />
                        
                    </td>
                </tr>
                <tr>
                    <td>
                        备注
                    </td>
                    <td>
                        <cc1:ExtTextArea2 ID="ExtTextArea1" runat="server" Z_FieldID="sReMark"  />
                        
                    </td>
                    
                   <td>
                        制单人
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox6" runat="server" Z_FieldID="sUserID" Z_disabled="true" />
                    </td>
                    <td>
                        制单时间
                    </td>
                    <td>
                        <cc1:ExtTextBox2 ID="ExtTextBox7" runat="server" Z_FieldID="dInputDate" Z_disabled="true" />
                        <cc1:ExtHidden2  Z_FieldID="iStatus" Z_Value="0" runat="server"/>
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center'">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="物料清单">
                    <!--  子表1  -->
                    <table id="bscDataStyleBomD" tablename="bscDataStyleBomD">
                    </table>
                </div>
                <%--<div data-options="fit:true" title="子表2标题">
                    <!--  子表2  -->
                    <%--<table id="table2" tablename="bscDataBuildDUnit">
                    </table>--%>
            </div>
       </div>
    </div>
</asp:Content>

