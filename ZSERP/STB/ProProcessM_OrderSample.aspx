<%@ Page Title="" Language="C#" MasterPageFile="~/Base/BasePage.master" %>

<%@ Register Assembly="ExtendControl2" Namespace="ExtendControl2" TagPrefix="cc1" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="_" runat="Server">
    <div id="divContent" class="easyui-layout" data-options="fit:true,border:false">
        <div data-options="region:'north',border:false" style="overflow: hidden;">
            <!—如果只有一个主表，这里的north要变为center-->
            <div id="divHiden" style="display: none;">
                <!--隐藏字段位置-->

            </div>
            <!--主表部分-->
            <table class="tabmain">
                <tr>
                    <!--这里是主表字段摆放位置-->
                    <td>楼宇编号
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox1" runat="server" z_fieldid="sBuildID" />
                    </td>
                    <td>楼宇名称
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox2" runat="server" z_fieldid="sBuildName" />
                    </td>
                    <td>楼宇类型
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox3" runat="server" z_fieldid="iType" />
                    </td>
                    <td>建筑面积
                    </td>
                    <td>
                        <cc1:exttextbox2 id="ExtTextBox4" runat="server" z_fieldid="fBuildArea" />
                    </td>
                </tr>
            </table>
        </div>
        <div data-options="region:'center',border:false">
            <!--下面是子表。注意，子表必须要指定tablename，tablename为数据集成中定义的子表表名-->
            <div id="divTableTab" class="easyui-tabs" data-options="fit:true,border:false">
                <div data-options="fit:true" title="子表1标题">
                    <!--子表1  -->
                    <table id="table1" tablename="bscDataBuildDLay">
                    </table>
                </div>
                <div data-options="fit:true" title="子表2标题">
                    <!--子表2  -->
                    <table id="table2" tablename="bscDataBuildDUnit">
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

