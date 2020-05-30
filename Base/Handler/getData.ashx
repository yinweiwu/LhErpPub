<%@ WebHandler Language="C#" Class="getData" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Text;
public class getData : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string plugin = context.Request.Params["plugin"] == null ? null : context.Request.Params["plugin"].ToString();
        if (context.Request.Params["ctype"] == null)//表示不是命令直接访问数据库。而是通过类SqlQueryObject
        {
            try
            {
                if (plugin == "datagrid")//如果是grid插件
                {
                    string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                    SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlobj);
                    if (context.Request.Params["rows"] != null)
                    {
                        string choosecount = context.Request.Params["rows"];
                        int skipcount = (int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(choosecount);
                        sqo.ChooseCount = choosecount;
                        sqo.SkipCount = skipcount.ToString();
                    }
                    if (context.Request.Params["filters"] != null)
                    {
                        string jsonfiltersstr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                        List<SqlFilter> sflist = JsonHelper.JsonDeserialize<SqlFilter>(jsonfiltersstr, true);
                        if (sqo.Filters.Count > 0)
                        {
                            sqo.Filters[sqo.Filters.Count - 1].LinkOprt = "and";
                        }
                        sqo.Filters.AddRange(sflist);
                    }
                    if (context.Request.Params["sort"] != null)
                    {
                        if (context.Request.Params["sort"].ToString().Length > 0)
                        {
                            string[] sortnames = context.Request.Params["sort"].ToString().Split(',');
                            string[] sortorders = context.Request.Params["order"].ToString().Split(',');
                            for (int i = 0; i < sortnames.Length; i++)
                            {
                                sqo.Sorts.Add(new SqlSort(sortnames[i], sortorders[i]));
                            }
                        }
                    }
                    List<DataTable> dts = sqo.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    string jsonstr = JsonHelper.ToJsonDataGrid(dts);
                    context.Response.Write(jsonstr);
                }
                else if (plugin == "combobox")
                {
                    string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                    SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlobj);
                    if (context.Request.Params["key"] != null)
                    {
                        string key = context.Request.Params["key"].ToString();
                        string field = context.Request.Params["field"].ToString();
                        List<SqlFilter> sqlfs = new List<SqlFilter>();
                        SqlFilter sqlf = new SqlFilter();
                        sqlf.Field = field;
                        sqlf.ComOprt = "like";
                        sqlf.Value = "'%" + key + "%'";
                        if (sqo.Filters != null && sqo.Filters.Count > 0)
                        {
                            sqo.Filters[sqo.Filters.Count - 1].LinkOprt = "and";
                        }
                        sqlfs.Add(sqlf);
                        sqo.Filters = sqlfs;
                    }
                    List<DataTable> dts = sqo.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    string jsonstr = JsonHelper.ToJsonNoRows(dts[0]);
                    context.Response.Write(jsonstr);
                }
                else if (plugin == "combotree")
                {
                    string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                    SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlobj);
                    DataTable table = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    string rootValue = context.Request.Params["rootvalue"].ToString();
                    string parentid = context.Request.Params["parentid"].ToString();
                    string childid = context.Request.Params["childid"].ToString();
                    string displayid = context.Request.Params["displayid"].ToString();
                    string treestr = BuilderTreeStr(table, rootValue, 0, parentid, childid, displayid);
                    context.Response.Write(treestr);
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else
        {
            string ctype = context.Request.Params["ctype"].ToString();
            if (ctype == "text")//表示是通过命令直接访问用类SqlQueryExec
            {
                try
                {
                    if (plugin == "datagrid")
                    {
                        string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                        SqlQueryExec sqe = JsonHelper.JsonDeserialize<SqlQueryExec>(sqlobj);
                        if (context.Request.Params["pagesize"] != null)
                        {
                            string choosecount = context.Request.Params["pagesize"];
                            int skipcount = (int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(choosecount);
                            sqe.ChooseCount = choosecount;
                            sqe.SkipCount = skipcount.ToString();
                        }
                        if (context.Request.Params["filters"] != null)
                        {
                            if (sqe.FilterStr.Length == 0)
                            {
                                sqe.FilterStr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                            }
                            else
                            {
                                sqe.FilterStr += " and " + Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                            }
                        }
                        if (context.Request.Params["sortname"] != null)
                        {
                            if (context.Request.Params["sortname"].ToString().Length > 0)
                            {
                                string[] sortnames = context.Request.Params["sortname"].ToString().Split(',');
                                string[] sortorders = context.Request.Params["sortorder"].ToString().Split(',');
                                for (int i = 0; i < sortnames.Length; i++)
                                {
                                    sqe.SortStr = sortnames[i] + " " + sortorders[i] + ",";
                                }
                                if (sqe.SortStr.Length > 0)
                                {
                                    sqe.SortStr = sqe.SortStr.Substring(0, sqe.SortStr.Length - 1);
                                }
                            }
                        }
                        List<DataTable> dts = sqe.SqlQueryDataAndTotalCount2(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                        string jsonstr = JsonHelper.ToJson(dts);
                        context.Response.Write(jsonstr);
                    }
                    else if (plugin == "combobox")
                    {
                        string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                        SqlQueryObject sqo = new SqlQueryObject("bscInitLookup", "sSQL", true);
                        sqo.Filters.Add(new SqlFilter("sOrgionName", "=", "'" + sqlobj + "'"));
                        DataTable tablelookup = sqo.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString)[0];
                        if (tablelookup.Rows.Count > 0)
                        {
                            SqlQueryExec sqecompany = new SqlQueryExec("select top 1 b.sClassID as companyid from bscdataperson as a,bscdataclass as b where a.sCode='" + HttpContext.Current.User.Identity.Name + "' and a.sclassid like b.sclassid+'%' and b.itype='07' and isnull(b.iCompany,0)=1");
                            DataTable tablecompany = sqecompany.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            string companyid = "";
                            if (tablecompany.Rows.Count > 0)
                            {
                                companyid = tablecompany.Rows[0][0].ToString();
                            }
                            string sql = tablelookup.Rows[0][0].ToString();
                            /*if (context.Request.Params["key"] != null)
                            {
                                string key = context.Request.Params["key"].ToString();
                                string field = context.Request.Params["field"].ToString();
                                if (sqe.FilterStr.Length > 0)
                                {
                                    sqe.FilterStr += " and " + field + " like '%" + key + "%'";
                                }
                                else
                                {
                                    sqe.FilterStr = field + " like '%" + key + "%'";
                                }
                            }*/
                            if (context.Request.Params["filters"] != null)
                            {
                                /*if (sqe.FilterStr.Length == 0)
                                {
                                    sqe.FilterStr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                                }
                                else
                                {
                                    sqe.FilterStr += " and " + Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                                }*/
                                sql = sql.Replace("{condition}", Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString()).Length > 0 ? Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString()) : "1=1");
                            }
                            SqlQueryExec sqe = new SqlQueryExec(sql.Replace("{userid}", HttpContext.Current.User.Identity.Name).Replace("{companyid}", companyid).Replace("{condition}", "1=1"));
                            DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            string jsonstr = JsonHelper.ToJsonNoRows(table);
                            context.Response.Write(jsonstr);
                        }
                        else
                        {
                            context.Response.Write("");
                        }
                    }
                    else if (plugin == null)
                    {
                        if (context.Request.Params["noresult"] == null || context.Request.Params["noresult"].ToString() != "1")//返回结果
                        {
                            string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                            SqlCommExec sqe = JsonHelper.JsonDeserialize<SqlCommExec>(sqlobj);
                            DataTable table = sqe.SqlCommExecDo(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            //var aaa = JsonHelper.ToJsonNoRows(table);
                            string jsonstr = JsonHelper.ToJsonNoRows(table);
                            context.Response.Write(jsonstr);
                        }
                        else if (context.Request.Params["noresult"] != null && context.Request.Params["noresult"] == "1")//返回结果
                        {
                            string sqlobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlobj"].ToString());
                            SqlCommExec sqe = JsonHelper.JsonDeserialize<SqlCommExec>(sqlobj);
                            sqe.SqlCommExecDo(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            context.Response.Write("1");
                        }
                    }
                }
                catch (Exception ex)
                {
                    context.Response.Write(ex.Message);
                }
            }
        }
    }

    public string BuilderTreeStr(DataTable table, string rootvalue, int level, string parentid, string childid, string displayid)
    {
        StringBuilder treeStr = new StringBuilder();
        treeStr.Append("[");
        DataRow[] Rows = table.Select("isnull(" + parentid + ",'')" + "='" + rootvalue + "'");
        for (int i = 0; i < Rows.Length; i++)
        {
            treeStr.Append("{\"id\":");
            treeStr.Append("\"" + Rows[i][childid].ToString() + "\"");
            treeStr.Append(",\"text\":");
            treeStr.Append("\"" + Rows[i][displayid].ToString() + "\"");
            treeStr.Append(",\"children\":");
            treeStr.Append(BuilderTreeStr(table, Rows[i][childid].ToString(), level + 1, parentid, childid, displayid));
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