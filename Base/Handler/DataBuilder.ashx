<%@ WebHandler Language="C#" Class="DataBuilder" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;

public class DataBuilder : IHttpHandler {
    public void ProcessRequest (HttpContext context) {
        string plugintype = context.Request.Params["plugintype"] == null ? null : context.Request.Params["plugintype"].ToString();
        if (context.Request.Params["ctype"] == null)//表示不是命令直接访问数据库。而是通过类SqlQueryObject
        {
            try
            {
                if (plugintype == "grid")//如果是grid插件
                {
                    string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                    SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlqueryobj);
                    if (context.Request.Params["pagesize"] != null)
                    {
                        string choosecount = context.Request.Params["pagesize"];
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
                    if (context.Request.Params["sortname"] != null)
                    {
                        if (context.Request.Params["sortname"].ToString().Length > 0)
                        {
                            string[] sortnames = context.Request.Params["sortname"].ToString().Split(',');
                            string[] sortorders = context.Request.Params["sortorder"].ToString().Split(',');
                            for (int i = 0; i < sortnames.Length; i++)
                            {
                                sqo.Sorts.Add(new SqlSort(sortnames[i], sortorders[i]));
                            }
                        }
                    }
                    List<DataTable> dts = sqo.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    string jsonstr = JsonHelper.ToJson(dts);
                    context.Response.Write(jsonstr);
                }
                else if (plugintype == "combobox")
                {
                    string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                    SqlQueryObject sqo = JsonHelper.JsonDeserialize<SqlQueryObject>(sqlqueryobj);
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
            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else
        {
            string ctype = context.Request.Params["ctype"].ToString();
            if (ctype == "text")//表示是通过命令直接访问用类SqlQueryExec
            {
                try
                {
                    if (plugintype == "grid")
                    {
                        string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                        SqlQueryExec sqe = JsonHelper.JsonDeserialize<SqlQueryExec>(sqlqueryobj);
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
                    else if (plugintype == "combobox")
                    {
                        string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                        SqlQueryObject sqo = new SqlQueryObject("bscInitLookup", "sSQL,sOrder", true);
                        sqo.Filters.Add(new SqlFilter("sOrgionName", "=", "'" + sqlqueryobj + "'"));
                        DataTable tablelookup = sqo.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString)[0];
                        if (tablelookup.Rows.Count > 0)
                        {
                            string sql = tablelookup.Rows[0][0].ToString();
                            if (context.Request.Params["filters"] != null)
                            {
                                sql = sql.Replace("{condition}", Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString()).Length > 0 ? Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString()) : "1=1");
                            }
                            if (tablelookup.Rows[0]["sOrder"].ToString()!="")
                            {
                                sql = sql + " order by " + tablelookup.Rows[0]["sOrder"].ToString();
                            }
                            SqlQueryExec sqe = new SqlQueryExec(sql.Replace("{userid}", HttpContext.Current.User.Identity.Name).Replace("{condition}", "1=1"));
                            DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            string jsonstr = JsonHelper.ToJsonNoRows(table);
                            context.Response.Write(jsonstr);
                        }
                        else
                        {
                            context.Response.Write("");
                        }
                    }
                    else if(plugintype==null)
                    {
                        if (context.Request.Params["noresult"] == null)//返回结果
                        {
                            if (context.Request.Params["rowcount"] == null || context.Request.Params["rowcount"].ToString() != "1")
                            {
                                string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                                SqlQueryExec sqe = JsonHelper.JsonDeserialize<SqlQueryExec>(sqlqueryobj);
                                DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                                string jsonstr = JsonHelper.ToJsonNoRows(table);
                                context.Response.Write(jsonstr);
                            }
                            else
                            {
                                string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                                SqlQueryExec sqe = JsonHelper.JsonDeserialize<SqlQueryExec>(sqlqueryobj);
                                DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                                //var aaa = JsonHelper.ToJsonNoRows(table);
                                string jsonstr = "{Rows:" + JsonHelper.ToJsonNoRows(table) + ",Total:" + table.Rows.Count.ToString() + "}";
                                context.Response.Write(jsonstr);
                            }
                        }
                        else if (context.Request.Params["noresult"] != null && context.Request.Params["noresult"] == "1")//返回结果
                        {
                            string sqlqueryobj = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
                            SqlQueryExec sqe = JsonHelper.JsonDeserialize<SqlQueryExec>(sqlqueryobj);
                            sqe.SqlQueryCommQuery(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            context.Response.Write("1");
                        }
                    }
                }
                catch (Exception ex)
                {
                    context.Response.Write("error:" + ex.Message);
                }
            }
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}