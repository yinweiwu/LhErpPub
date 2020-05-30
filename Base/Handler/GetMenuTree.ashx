<%@ WebHandler Language="C#" Class="GetMenuTree" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using Newtonsoft.Json;

public class GetMenuTree : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params["itype"] == null || context.Request.Params["itype"].ToString() == "")
        {
            try
            {
                SqlQueryExec sqe = new SqlQueryExec("select * from View_Yww_FSysMainMenu order by iSerial asc");
                DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string jsonStr = BuilderTreeStrAll(table, "0", 1, true);
                context.Response.Write(jsonStr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (context.Request.Params["itype"].ToString() == "getSubMenu")
        {
            List<StoreParm> sparms = new List<StoreParm>();
            sparms.Add(new StoreParm("@userid", "input", 50, context.User.Identity.Name));
            SqlStoreProcQuery ssq = new SqlStoreProcQuery();
            ssq.StoreParms = sparms;
            ssq.StoreProName = "GetUserMainMenu";
            try
            {
                DataTable table = ssq.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string parentMenuID = context.Request.Params["parentMenuID"].ToString();
                if (context.Request.Params["id"] != null)
                {
                    parentMenuID = context.Request.Params["id"].ToString();
                }
                string jsonstr = BuilderTreeStr(table, parentMenuID, 0,false);
                context.Response.Write(jsonstr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (context.Request.Params["itype"].ToString() == "getUserMenu")
        {
            List<StoreParm> sparms = new List<StoreParm>();
            sparms.Add(new StoreParm("@userid", "input", 50, context.User.Identity.Name));
            SqlStoreProcQuery ssq = new SqlStoreProcQuery();
            ssq.StoreParms = sparms;
            ssq.StoreProName = "GetUserMainMenu";
            try
            {
                DataTable table = ssq.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string jsonstr = BuilderTreeStrAll(table, "0", 1,false);
                context.Response.Write(jsonstr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (context.Request.Params["itype"].ToString() == "getUserCommonMenu")
        {
            List<StoreParm> sparms = new List<StoreParm>();
            sparms.Add(new StoreParm("@userid", "input", 50, context.User.Identity.Name));
            sparms.Add(new StoreParm("@type", "input", 50, "2"));
            SqlStoreProcQuery ssq = new SqlStoreProcQuery();
            ssq.StoreParms = sparms;
            ssq.StoreProName = "GetUserMainMenu";
            try
            {
                DataTable table = ssq.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                string jsonstr = BuildUserCommMenuStr(table);
                context.Response.Write(jsonstr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (context.Request.Params["itype"].ToString() == "getUserMenu1")
        {
            List<StoreParm> sparms = new List<StoreParm>();
            sparms.Add(new StoreParm("@userid", "input", 50, context.User.Identity.Name));
            SqlStoreProcQuery ssq = new SqlStoreProcQuery();
            ssq.StoreParms = sparms;
            ssq.StoreProName = "GetUserMainMenu";
            try
            {
                DataTable table = ssq.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                //string jsonstr = BuilderTreeStrAll(table, "0", 1,false);
                context.Response.Write(JsonConvert.SerializeObject(table));
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
    }
    public string BuilderTreeStrAll(DataTable table, string fatherid, int level,bool showHide)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        string showHideSql = showHide ? "" : " and isnull(iHidden,0)=0 ";
        DataRow[] Rows = table.Select("iParentMenuId=" + fatherid + showHideSql, "iHidden asc,iSerial asc");
        for (int i = 0; i < Rows.Length; i++)
        {
            string switchstr = "open";
            treeStr.Append("{\"id\":");
            treeStr.Append("\"" + Rows[i]["iMenuID"].ToString() + "\"");
            treeStr.Append(",\"text\":");
            string sMenuName = Rows[i]["iHidden"].ToString() == "1" ? Rows[i]["sMenuName"].ToString() + "(隐)" : Rows[i]["sMenuName"].ToString();
            treeStr.Append("\"" + sMenuName + "\"");
            if (Rows[i]["sIcon"].ToString() != "")
            {
                treeStr.Append(",\"iconCls\":");
                treeStr.Append("\"" + Rows[i]["sIcon"].ToString() + "\"");
            }
            treeStr.Append(",\"state\":");
            treeStr.Append("\"" + switchstr + "\"");
            treeStr.Append(",\"attributes\":{\"sFilePath\":");
            treeStr.Append("\"" + Rows[i]["sFilePath"].ToString() + "\"");
            treeStr.Append(",\"iSerial\":");
            treeStr.Append("\"" + Rows[i]["iSerial"].ToString() + "\"");
            treeStr.Append(",\"iFormID\":");
            treeStr.Append("\"" + Rows[i]["iFormID"].ToString() + "\"");
            treeStr.Append(",\"sUserID\":");
            treeStr.Append("\"" + Rows[i]["sUserID"].ToString() + "\"");
            treeStr.Append(",\"dinputDate\":");
            treeStr.Append("\"" + Rows[i]["dinputDate"].ToString() + "\"");
            treeStr.Append(",\"sParms\":");
            treeStr.Append("\"" + Rows[i]["sParms"].ToString() + "\"");
            treeStr.Append(",\"sOpenSql\":");
            treeStr.Append("\"" + Rows[i]["sOpenSql"].ToString() + "\"");
            treeStr.Append(",\"sIcon\":");
            treeStr.Append("\"" + Rows[i]["sIcon"].ToString() + "\"");
            treeStr.Append(",\"iFullScreen\":");
            treeStr.Append("\"" + Rows[i]["iFullScreen"].ToString() + "\"");
            treeStr.Append("}");
            treeStr.Append(",\"children\":");
            treeStr.Append(BuilderTreeStrAll(table, Rows[i]["iMenuID"].ToString(), level + 1,showHide));
            treeStr.Append("},");
        }
        if (treeStr.Length > 1)
        {
            treeStr.Remove(treeStr.Length - 1, 1);
        }
        treeStr.Append("]");
        return treeStr.ToString();
    }
    public string BuilderTreeStr(DataTable table, string fatherid, int level,bool showHide)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        string showHideSql = showHide ? "" : " and isnull(iHidden,0)=0 ";
        DataRow[] Rows = table.Select("iParentMenuId=" + fatherid + showHideSql, "iSerial asc");
        for (int i = 0; i < Rows.Length; i++)
        {
            //string switchstr = level == 0 ? "open" : "closed";
            DataRow[] subRows = table.Select("iParentMenuId=" + Rows[i]["iMenuID"].ToString());
            string switchstr = subRows.Length == 0 ? "open" : "closed";
            treeStr.Append("{\"id\":");
            treeStr.Append("\"" + Rows[i]["iMenuID"].ToString() + "\"");
            treeStr.Append(",\"text\":");
            treeStr.Append("\"" + Rows[i]["sMenuName"].ToString() + "\"");
            if (Rows[i]["sIcon"].ToString() != "")
            {
                treeStr.Append(",\"iconCls\":");
                treeStr.Append("\"" + Rows[i]["sIcon"].ToString() + "\"");
            }
            treeStr.Append(",\"state\":");
            treeStr.Append("\"" + switchstr + "\"");
            treeStr.Append(",\"attributes\":{\"sFilePath\":");
            treeStr.Append("\"" + Rows[i]["sFilePath"].ToString() + "\"");
            treeStr.Append(",\"iSerial\":");
            treeStr.Append("\"" + Rows[i]["iSerial"].ToString() + "\"");
            treeStr.Append(",\"iFormID\":");
            treeStr.Append("\"" + Rows[i]["iFormID"].ToString() + "\"");
            treeStr.Append(",\"sUserID\":");
            treeStr.Append("\"" + Rows[i]["sUserID"].ToString() + "\"");
            treeStr.Append(",\"dinputDate\":");
            treeStr.Append("\"" + Rows[i]["dinputDate"].ToString() + "\"");
            treeStr.Append(",\"sParms\":");
            treeStr.Append("\"" + Rows[i]["sParms"].ToString() + "\"");
            treeStr.Append(",\"sOpenSql\":");
            treeStr.Append("\"" + Rows[i]["sOpenSql"].ToString() + "\"");
            treeStr.Append(",\"sIcon\":");
            treeStr.Append("\"" + Rows[i]["sIcon"].ToString() + "\"");
            treeStr.Append(",\"iFullScreen\":");
            treeStr.Append("\"" + Rows[i]["iFullScreen"].ToString() + "\"");
            treeStr.Append("}");
            //treeStr.Append(",\"children\":");
            //treeStr.Append(BuilderTreeStr(table, Rows[i]["iMenuID"].ToString(), level + 1));
            treeStr.Append("},");
        }
        if (treeStr.Length > 1)
        {
            treeStr.Remove(treeStr.Length - 1, 1);
        }
        treeStr.Append("]");
        treeStr.Replace(",\"children\":[]", "");
        return treeStr.ToString();
    }
    public string BuildUserCommMenuStr(DataTable table)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        List<string> iRecNoStr = new List<string>();
        for (int i = 0; i < table.Rows.Count; i++)
        {
            if (iRecNoStr.Contains(table.Rows[i]["iRecNo"].ToString()))
            {
                continue;
            }
            if (table.Rows[i]["iHidden"].ToString() != "1")
            {
                treeStr.Append("{\"id\":");
                treeStr.Append("\"" + table.Rows[i]["iRecNo"].ToString() + "\"");
                treeStr.Append(",\"text\":");
                treeStr.Append("\"" + table.Rows[i]["sGroupName"].ToString() + "\"");
                treeStr.Append(",\"iconCls\":\"icon-group\"");
                treeStr.Append(",\"state\":");
                treeStr.Append("\"open\"");
                treeStr.Append(",\"children\":[");
                DataRow[] subRows = table.Select("sGroupName='" + table.Rows[i]["sGroupName"].ToString() + "' and isnull(iHidden,0)<>1 ");
                for (int j = 0; j < subRows.Length; j++)
                {
                    iRecNoStr.Add(subRows[j]["iRecNo"].ToString());
                    treeStr.Append("{\"id\":");
                    treeStr.Append("\"" + subRows[j]["iMenuID"].ToString() + "\"");
                    if (subRows[j]["sIcon"].ToString() != "")
                    {
                        treeStr.Append(",\"iconCls\":");
                        treeStr.Append("\"" + subRows[j]["sIcon"].ToString() + "\"");
                    }
                    treeStr.Append(",\"text\":");
                    treeStr.Append("\"" + subRows[j]["sMenuName"].ToString() + "\"");
                    treeStr.Append(",\"attributes\":{\"sFilePath\":");
                    treeStr.Append("\"" + subRows[j]["sFilePath"].ToString() + "\"");
                    treeStr.Append(",\"iSerial\":");
                    treeStr.Append("\"" + subRows[j]["iSerial"].ToString() + "\"");
                    treeStr.Append(",\"iFormID\":");
                    treeStr.Append("\"" + subRows[j]["iFormID"].ToString() + "\"");
                    treeStr.Append(",\"sParms\":");
                    treeStr.Append("\"" + subRows[j]["sParms"].ToString() + "\"");
                    treeStr.Append(",\"sOpenSql\":");
                    treeStr.Append("\"" + subRows[j]["sOpenSql"].ToString() + "\"");
                    treeStr.Append(",\"iFullScreen\":");
                    treeStr.Append("\"" + subRows[j]["iFullScreen"].ToString() + "\"");
                    treeStr.Append("}");
                    treeStr.Append("},");
                }
                if (subRows.Length > 0)
                {
                    treeStr.Remove(treeStr.Length - 1, 1);
                }
                treeStr.Append("]");
                treeStr.Append("},");
            }
        }
        if (treeStr.Length > 1)
        {
            treeStr.Remove(treeStr.Length - 1, 1);
        }
        treeStr.Append("]");
        return treeStr.ToString();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}