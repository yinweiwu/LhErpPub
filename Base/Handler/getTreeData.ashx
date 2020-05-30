<%@ WebHandler Language="C#" Class="getTreeData" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using sysBaseDAL.common;
public class getTreeData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string id = context.Request.Params["idField"] == null ? "" : context.Request.Params["idField"].ToString();
            string text = context.Request.Params["textField"] == null ? "" : context.Request.Params["textField"].ToString();
            string parent = context.Request.Params["parentField"] == null ? "" : context.Request.Params["parentField"].ToString();
            string attribute = context.Request.Params["attribute"] != null ? context.Request.Params["attribute"].ToString() : "";
            string rootValue = context.Request.Params["rootValue"] == null ? "" : context.Request.Params["rootValue"].ToString();
            string isAsync = context.Request.Params["isAsync"] == null ? "0" : context.Request.Params["isAsync"].ToString();
            rootValue = context.Request.Params["id"] == null ? rootValue : context.Request.Params["id"].ToString();
            int level = context.Request.Params["level"] != null ? Convert.ToInt32(context.Request.Params["level"]) : 0;
            if (context.Request.Params["otype"] == null)
            {
                string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlobj);
                DataTable table = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                bool async = isAsync == "1" ? true : false;
                string jsonStr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, "", async, level, 0);
                context.Response.Write(jsonStr);
            }
            else if (context.Request.Params["otype"].ToString() == "getFormListTree")
            {
                string formID = context.Request.Params["formID"] == null ? "" : context.Request.Params["formID"].ToString();
                sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                DataTable tableBill = sqlhelper.getTableData("select [sPfield],[sCfield],[sDfield],[sTreeSql] from bscDataBill where iFormID='" + formID + "'");
                if (tableBill.Rows.Count > 0)
                {
                    id = tableBill.Rows[0]["sCfield"].ToString();
                    text = tableBill.Rows[0]["sDfield"].ToString();
                    parent = tableBill.Rows[0]["sPfield"].ToString();
                    rootValue = rootValue == "" ? "-1" : rootValue;
                    DataTable tableSource = sqlhelper.getTableData(tableBill.Rows[0]["sTreeSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name));
                    string jsonStr = BuilderTreeStrAll(tableSource, id, text, parent, "", rootValue, "", false, level, 0);
                    context.Response.Write(jsonStr);
                }
            }
            else if (context.Request.Params["otype"].ToString() == "getright")
            {

                string groupid = context.Request.Params["groupid"] == null ? "" : context.Request.Params["groupid"].ToString();
                string checkField = context.Request.Params["checkField"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "Yww_GetUserRight";
                ssp.StoreParms = new List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@groupid", groupid.ToString()));
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                string jsonstr = "";
                //jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, false, level, 0);
                if (context.Request.Params["id"] == null)
                {
                    jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, true, level, 0);
                }
                else
                {
                    jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, false, level, 0);
                }
                context.Response.Write(jsonstr);
            }
            else if (context.Request.Params["otype"].ToString() == "getSingleRight")
            {
                string iBscDataPersonRecNo = context.Request.Params["iBscDataPersonRecNo"] == null ? "" : context.Request.Params["iBscDataPersonRecNo"].ToString();
                string checkField = context.Request.Params["checkField"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "Yww_GetUserRightOfSingle";
                ssp.StoreParms = new List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@iBscDataPersonRecNo", iBscDataPersonRecNo));
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                string jsonstr = "";
                //jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, false, level, 0);
                if (context.Request.Params["id"] == null)
                {
                    jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, true, level, 0);
                }
                else
                {
                    jsonstr = BuilderTreeStrAll(table, id, text, parent, attribute, rootValue, checkField, false, level, 0);
                }
                context.Response.Write(jsonstr);
            }
            else if (context.Request.Params["otype"].ToString() == "getrightGrid")
            {
                string groupid = context.Request.Params["groupid"] == null ? "" : context.Request.Params["groupid"].ToString();
                SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                ssp.StoreProName = "Yww_GetUserRight";
                ssp.StoreParms = new List<StoreParm>();
                ssp.StoreParms.Add(new StoreParm("@groupid", groupid.ToString()));
                DataTable table = ssp.SqlStoreProcExec(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
                string jsonstr = BuilderTreeGridStrAll(table, id, text, parent, attribute, rootValue);
                context.Response.Write(jsonstr);
            }
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }

    public string BuilderTreeStrAll(DataTable table, string id, string text, string parent, string attribute, string rootvalue, string checkField, bool isaysn, int level, int curtLevel)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        string query = "[" + parent + "]='" + rootvalue + "'";
        DataRow[] Rows = table.Select(query);
        for (int i = 0; i < Rows.Length; i++)
        {
            DataRow[] subRows = table.Select("[" + parent + "]='" + Rows[i][id].ToString() + "'");
            string switchstr = (subRows.Length > 0 && curtLevel < level) || subRows.Length == 0 ? "open" : "closed";
            if ((level == 0 || curtLevel < level)&&isaysn==false)
            {
                switchstr = "open";
            }
            /*if (isaysn == true)
            {
                switchstr = "closed";
            }*/
            treeStr.Append("{\"id\":");
            treeStr.Append("\"" + Rows[i][id].ToString() + "\"");
            treeStr.Append(",\"text\":");
            treeStr.Append("\"" + Rows[i][text].ToString().Replace("\r\n","\\r\\n").Replace("\n","\\n") + "\"");
            treeStr.Append(",\"state\":");
            treeStr.Append("\"" + switchstr + "\"");
            if (checkField.Length > 0)
            {
                string checkedstr = Rows[i][checkField].ToString() == "1" ? "true" : "false";
                treeStr.Append(",\"checked\":");
                if (subRows.Length > 0&&isaysn==false)
                {
                    checkedstr = "false";
                }
                treeStr.Append(checkedstr);
            }
            if (attribute.Length > 0)
            {
                treeStr.Append(",\"attributes\":{");
                string[] attrArr = attribute.Split(',');
                for (int j = 0; j < attrArr.Length; j++)
                {
                    treeStr.Append("\"" + attrArr[j] + "\":");
                    treeStr.Append("\"" + Rows[i][attrArr[j]].ToString() + "\",");
                }
                treeStr.Remove(treeStr.Length - 1, 1);
                treeStr.Append("}");
            }
            if ((curtLevel < level || level == 0 )&& isaysn == false)
            {
                treeStr.Append(",\"children\":");
                treeStr.Append(BuilderTreeStrAll(table, id, text, parent, attribute, Rows[i][id].ToString(), checkField, isaysn, level, curtLevel + 1));
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

    public string BuilderTreeGridStrAll(DataTable table, string id, string text, string parent, string attribute, string rootvalue)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        string query = "[" + parent + "]='" + rootvalue + "'";
        DataRow[] Rows = table.Select(query);
        for (int i = 0; i < Rows.Length; i++)
        {
            treeStr.Append("{\"id\":");
            treeStr.Append("\"" + Rows[i][id].ToString() + "\"");
            treeStr.Append(",\"text\":");
            treeStr.Append("\"" + Rows[i][text].ToString().Replace("\r\n", "\\r\\n").Replace("\n", "\\n") + "\"");
            if (attribute.Length > 0)
            {
                string[] attrArr = attribute.Split(',');
                treeStr.Append(",");
                for (int j = 0; j < attrArr.Length; j++)
                {
                    treeStr.Append("\"" + attrArr[j] + "\":");
                    treeStr.Append("\"" + Rows[i][attrArr[j]].ToString() + "\",");
                }
                treeStr.Remove(treeStr.Length - 1, 1);
            }
            treeStr.Append(",\"children\":");
            treeStr.Append(BuilderTreeGridStrAll(table, id, text, parent, attribute, Rows[i][id].ToString()));

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


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}