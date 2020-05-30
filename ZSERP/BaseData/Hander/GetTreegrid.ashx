<%@ WebHandler Language="C#" Class="GetTreegrid" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using sysBaseDAL.common;
public class GetTreegrid : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string id = context.Request.Params["idField"] == null ? "" : context.Request.Params["idField"].ToString();
            string text = context.Request.Params["textField"] == null ? "" : context.Request.Params["textField"].ToString();
            string parent = context.Request.Params["parentField"] == null ? "" : context.Request.Params["parentField"].ToString();
            string rootValue = context.Request.Params["rootValue"] == null ? "" : context.Request.Params["rootValue"].ToString();
            string isAsync = context.Request.Params["isAsync"] == null ? "0" : context.Request.Params["isAsync"].ToString();
            rootValue = context.Request.Params["id"] == null ? rootValue : context.Request.Params["id"].ToString();
            int level = context.Request.Params["level"] != null ? Convert.ToInt32(context.Request.Params["level"]) : 0;
            if (context.Request.Params["otype"] == null)
            {
                string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());//解码
                SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlobj);
                DataTable table = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                bool async = isAsync == "1" ? true : false;
                string jsonStr = BuilderTreeStrAll(table, id, text, "sCode", "sName", parent, rootValue, "", async, level, 0);
                context.Response.Write(jsonStr);
            }
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }

    public string BuilderTreeStrAll(DataTable table, string sParentID, string sClassName, string sCode, string sName, string parent, string rootvalue, string checkField, bool isaysn, int level, int curtLevel)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        string query = "[" + parent + "]='" + rootvalue + "'";
        DataRow[] Rows = table.Select(query);
        for (int i = 0; i < Rows.Length; i++)
        {
            DataRow[] subRows = table.Select("[" + parent + "]='" + Rows[i][sParentID].ToString() + "'");
            string switchstr = (subRows.Length > 0 && curtLevel < level) || subRows.Length == 0 ? "open" : "closed";
            if ((level == 0 || curtLevel < level) && isaysn == false)
            {
                //switchstr = "open";
            }
            /*if (isaysn == true)
            {
                switchstr = "closed";
            }*/
            treeStr.Append("{\"sParentID\":");
            treeStr.Append("\"" + Rows[i][sParentID].ToString() + "" + Rows[i][sCode].ToString() + "\"");
            treeStr.Append(",\"sClassName\":");
            treeStr.Append("\"" + Rows[i][sClassName].ToString().Replace("\r\n", "\\r\\n").Replace("\n", "\\n") + "\"");
            treeStr.Append(",\"sCode\":");
            treeStr.Append("\"" + Rows[i][sCode].ToString() + "\"");
            treeStr.Append(",\"sName\":");
            treeStr.Append("\"" + Rows[i][sName].ToString().Replace("\r\n", "\\r\\n").Replace("\n", "\\n") + "\"");
            treeStr.Append(",\"state\":");
            treeStr.Append("\"" + switchstr + "\"");
            if (checkField.Length > 0)
            {
                string checkedstr = Rows[i][checkField].ToString() == "1" ? "true" : "false";
                treeStr.Append(",\"checked\":");
                if (subRows.Length > 0 && isaysn == false)
                {
                    checkedstr = "false";
                }
                treeStr.Append(checkedstr);
            }
            if ((curtLevel < level || level == 0) && isaysn == false)
            {
                treeStr.Append(",\"children\":");
                treeStr.Append(BuilderTreeStrAll(table, sParentID, sClassName, sCode, sName, parent, Rows[i][sParentID].ToString(), checkField, isaysn, level, curtLevel + 1));
            }

            treeStr.Append("},");
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