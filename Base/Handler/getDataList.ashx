<%@ WebHandler Language="C#" Class="getDataList" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Text;
using sysBaseDAL.common;
public class getDataList : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        //string plugintype = context.Request.Params["plugin"] == null ? null : context.Request.Params["plugin"].ToString();
        string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
        try
        {
            if (otype == "formlist")//如果是表单列表插件
            {
                string formid = context.Request.Params["iformid"].ToString();
                string menuid = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
                sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                SqlQueryObject sqo;
                if (context.Request.Params["isChild"].ToString() == "0")
                {
                    sqo = new SqlQueryObject("bscDataBill", "sShowSql,sMainOrder,sFieldKey,iQuery,iStore,sStoreParms,sOpenFilters", true);
                    sqo.Filters = new List<SqlFilter>();
                    sqo.Filters.Add(new SqlFilter("iFormID", "=", formid));
                    DataTable tablesql = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    if (tablesql.Rows.Count > 0)
                    {
                        string menuFilters = "";
                        if (menuid != "")
                        {
                            DataTable tableMenuFilter = sqlhelper.getTableData("select sOpenSql from FSysMainMenu where iMenuID='" + menuid + "'");
                            if (tableMenuFilter.Rows.Count > 0)
                            {
                                menuFilters = tableMenuFilter.Rows[0]["sOpenSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name);
                            }
                        }                        
                        if (tablesql.Rows[0]["iQuery"].ToString() == "1")
                        {
                            if (tablesql.Rows[0]["iStore"].ToString() == "1")
                            {
                                string filters = "";
                                if (context.Request.Params["filters"] != null)
                                {
                                    filters = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                                }
                                filters = filters == "" ? menuFilters : filters + "$" + menuFilters;
                                string sqltext = tablesql.Rows[0]["sShowSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name);
                                if (filters.Length > 0)
                                {
                                    string[] parmvaluearr = filters.Split('$');
                                    while (sqltext.IndexOf("{") > 0)
                                    {
                                        int flag = 0;
                                        int index = sqltext.IndexOf("{");
                                        int lindex = sqltext.IndexOf("}");
                                        string parm = sqltext.Substring(index + 1, lindex - index - 1);
                                        for (int pi = 0; pi < parmvaluearr.Length; pi++)
                                        {
                                            if (parmvaluearr[pi].Split('=')[0] == parm)
                                            {
                                                sqltext = sqltext.Replace("{" + parm + "}", parmvaluearr[pi].Split('=')[1]);
                                                flag = 1;
                                                break;
                                            }
                                        }
                                        if (flag == 0)
                                        {//第一层中没有,进行第二层替换
                                            string[] parmvaluearr1 = tablesql.Rows[0]["sStoreParms"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name).Split('$');
                                            //var flag = 0;
                                            for (int pi = 0; pi < parmvaluearr1.Length; pi++)
                                            {
                                                if (parmvaluearr1[pi].Split('=')[0] == parm)
                                                {
                                                    sqltext = sqltext.Replace("{" + parm + "}", parmvaluearr1[pi].Split('=')[1]);
                                                    flag = 1;
                                                    break;
                                                }
                                            }
                                            if (flag == 0)
                                            {
                                                throw new Exception("查询的参数不存在");
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    string[] parmvaluearr = tablesql.Rows[0]["sStoreParms"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name).Split('$');
                                    int flag = 0;
                                    while (sqltext.IndexOf("{") > 0)
                                    {
                                        int index = sqltext.IndexOf("{");
                                        int lindex = sqltext.IndexOf("}");
                                        string parm = sqltext.Substring(index + 1, lindex - index - 1);
                                        for (int pi = 0; pi < parmvaluearr.Length; pi++)
                                        {
                                            if (parmvaluearr[pi].Split('=')[0] == parm)
                                            {
                                                sqltext = sqltext.Replace("{" + parm + "}", parmvaluearr[pi].Split('=')[1]);
                                                flag = 1;
                                                break;
                                            }
                                        }
                                    }
                                    if (flag == 0)
                                    {
                                        throw new Exception("查询的参数不存在");
                                    }
                                }
                                SqlQueryExec sqe = new SqlQueryExec(sqltext);
                                DataTable dt = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                                string jsonstr = JsonHelper.ToJsonNoRows(dt);
                                context.Response.Write("{Rows:" + jsonstr + ",Total:" + dt.Rows.Count.ToString() + "}");
                            }

                            else
                            {
                                string filters = "1=1";
                                if (context.Request.Params["filters"] != null)
                                {
                                    filters = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                                }
                                filters = menuFilters == "" ? filters : filters + " and " + menuFilters;
                                string sql = tablesql.Rows[0]["sShowSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name);
                                sql = sql.Replace("{condition}", filters).Replace("{fields}", getColName(formid, false));
                                SqlQueryExec sqe = new SqlQueryExec(sql);
                                DataTable dt = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                                string jsonstr = JsonHelper.ToJsonNoRows(dt);
                                context.Response.Write("{Rows:" + jsonstr + ",Total:" + dt.Rows.Count.ToString() + "}");
                            }
                        }
                        else
                        {
                            string sqlmain = tablesql.Rows[0]["sShowSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name); ;
                            string sqlmainorder = tablesql.Rows[0]["sMainOrder"].ToString();
                            string filterKey = tablesql.Rows[0]["sFieldKey"].ToString();
                            string selfields = getColName(formid, false);
                            if (selfields.ToUpper().IndexOf(filterKey.ToUpper()) < 0)
                            {
                                selfields = filterKey + "," + selfields;
                            }
                            if (selfields == "1")
                            {
                                throw new Exception("未定义列名！");
                            }
                            //加入权限语句
                            SiteBll siteb = new SiteBll(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                            string powerFilters = siteb.getRightSql(HttpContext.Current.User.Identity.Name, formid);
                            SqlQueryExec sqe = new SqlQueryExec(sqlmain, "select " + selfields + " from(" + sqlmain + ") as A", powerFilters, sqlmainorder, filterKey);
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
                            if (context.Request.Params["treefilters"] != null)
                            {
                                if (sqe.FilterStr.Length == 0)
                                {
                                    sqe.FilterStr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["treefilters"].ToString());
                                }
                                else
                                {
                                    sqe.FilterStr += " and " + Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["treefilters"].ToString());
                                }
                            }
                            if (menuFilters != "")
                            {
                                sqe.FilterStr += " and " + menuFilters;
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
                    }
                }
                else
                {
                    sqo = new SqlQueryObject("bscDataBill", "sDetailSql,sDeitailFieldKey,sChildOrder,sLinkField", true);
                    sqo.Filters = new List<SqlFilter>();
                    sqo.Filters.Add(new SqlFilter("iFormID", "=", formid));
                    DataTable tablesql = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                    string sqlmain = tablesql.Rows[0]["sDetailSql"].ToString().Replace("{userid}", HttpContext.Current.User.Identity.Name); ;
                    string sqlmainorder = tablesql.Rows[0]["sDeitailFieldKey"].ToString();
                    string filterKey = tablesql.Rows[0]["sDeitailFieldKey"].ToString();
                    string selfields = getColName(formid, true);
                    if (selfields.ToUpper().IndexOf(filterKey.ToUpper()) < 0)
                    {
                        selfields = filterKey + "," + selfields;
                    }
                    if (selfields == "1")
                    {
                        throw new Exception("未定义列名！");
                    }

                    string mainRecNo = context.Request.Params["iMainRecNo"].ToString();
                    string mainFiledKye = tablesql.Rows[0]["sLinkField"].ToString().Split('=')[1];

                    SqlQueryExec sqe = new SqlQueryExec(sqlmain, "select " + selfields + " from(" + sqlmain + ") as A", mainFiledKye + "=" + mainRecNo, sqlmainorder, filterKey);
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
            }
            else if (otype == "lookup")
            {
                string lookupname = context.Request.Params["lookupname"].ToString();
                SqlQueryObject sqo = new SqlQueryObject("bscInitLookup", "sOrgionName,sControlName,sSQL,sReturnField,sDisplayField,sTitles,sPageField,sOrder", true);
                sqo.Filters.Add(new SqlFilter("sOrgionName", "=", "'" + lookupname + "'"));
                string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                DataTable tablelookup = sqo.SqlQueryExec(connstr)[0];
                StringBuilder strinit = new StringBuilder();
                if (tablelookup.Rows.Count > 0)
                {
                    //SqlQueryExec sqecompany = new SqlQueryExec("select top 1 b.sClassID as companyid from bscdataperson as a,bscdataclass as b where a.sCode='" + HttpContext.Current.User.Identity.Name + "' and a.sclassid like b.sclassid+'%' and b.itype='07' and isnull(b.iCompany,0)=1");
                    //DataTable tablecompany = sqecompany.SqlQueryComm(connstr);
                    //string companyid = "";
                    //if (tablecompany.Rows.Count > 0)
                    //{
                    //    companyid = tablecompany.Rows[0][0].ToString();
                    //}
                    //DataTable tablecompany=
                    string ssql = tablelookup.Rows[0]["sSQL"].ToString().Replace("\r\n", " ").Replace("{userid}", HttpContext.Current.User.Identity.Name);
                    //sqlfilters = sqlfilters.Length == 0 ? " 1=1 " : sqlfilters;                
                    //可变的过滤条件
                    string filters = "1=1";
                    if (context.Request["filters"] != null)
                    {
                        filters = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request["filters"].ToString());
                    }
                    ssql = ssql.Replace("{condition}", filters);
                    string sOrder = "";
                    if (tablelookup.Rows[0]["sOrder"].ToString() != "")
                    {
                        sOrder = tablelookup.Rows[0]["sOrder"].ToString();
                    }
                    string pageKey = context.Request.Params["pageKey"].ToString();
                    SqlQueryExec sqe = new SqlQueryExec(ssql, "select * from(" + ssql + ") as A", "1=1", sOrder, pageKey);
                    if (context.Request.Params["pagesize"] != null)
                    {
                        string choosecount = context.Request.Params["pagesize"];
                        int skipcount = (int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(choosecount);
                        sqe.ChooseCount = choosecount;
                        sqe.SkipCount = skipcount.ToString();
                    }
                    /*if (context.Request.Params["filters"] != null)
                    {
                        if (sqe.FilterStr.Length == 0)
                        {
                            sqe.FilterStr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                        }
                        else
                        {
                            sqe.FilterStr += " and " + Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["filters"].ToString());
                        }
                    }*/
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
                    //ssqlquery = ssqlquery.Replace("{condition}", sqlfilters);
                }
                else
                {
                    context.Response.Write("对不起，没有可选择的数据。");
                }
            }
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }

    public string getColName(string formid, bool isChild)
    {
        //获取列名
        SqlQueryObject sqogridcol = new SqlQueryObject();
        sqogridcol.TableName = "View_Yww_bscDataQueryD";
        sqogridcol.Fields = "*";
        sqogridcol.SelectAll = true;
        SqlFilter sfgrid1 = new SqlFilter("iFormID", "=", formid);
        sqogridcol.Filters.Add(sfgrid1);
        if (isChild)
        {
            sqogridcol.Filters.Add(new SqlFilter("isnull(isChild,0)", "=", "1"));
            sqogridcol.Filters[sqogridcol.Filters.Count - 2].LinkOprt = "and";
        }
        else
        {
            sqogridcol.Filters.Add(new SqlFilter("isnull(isChild,0)", "=", "0"));
            sqogridcol.Filters[sqogridcol.Filters.Count - 2].LinkOprt = "and";
        }
        DataTable tablegridcol = sqogridcol.SqlQueryExec(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString)[0];//列名的表
        DataRow[] mainrows = tablegridcol.Select("", "iHide asc,iShowOrder asc");//取主表的列
        if (mainrows.Length > 0)//定义显示的grid的列
        {
            string gridfields = "";//SQL中的字段语句
            for (int z = 0; z < mainrows.Length; z++)
            {
                if (mainrows[z]["sFieldsType"].ToString() == "date")//如果列为date型，则字段要加convert()
                {
                    gridfields += mainrows[z]["sExpression"].ToString() + "=convert(varchar(10)," + mainrows[z]["sExpression"].ToString() + ",23),";
                }
                else if (mainrows[z]["sFieldsType"].ToString() == "datetime")
                {
                    gridfields += mainrows[z]["sExpression"].ToString() + "=convert(varchar(20)," + mainrows[z]["sExpression"].ToString() + ",20),";
                }
                else if (mainrows[z]["sFieldsType"].ToString() != "imageUrl" && mainrows[z]["sFieldsType"].ToString() != "附件")
                {
                    gridfields += mainrows[z]["sExpression"].ToString() + ",";
                }
            }
            gridfields = gridfields.Remove(gridfields.Length - 1, 1);
            return gridfields;
        }
        else
        {
            return "1";
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}