<%@ WebHandler Language="C#" Class="UpdateLogHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using sysBaseDAL.common;
using Newtonsoft.Json;
public class UpdateLogHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string from = context.Request.Params["from"] == null ? null : context.Request.Params["from"].ToString();
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        try
        {
            if (from == "table")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    
                    string sContent = context.Request.Params["sContent"] == null ? "NULL" : "'" + context.Request.Params["sContent"].ToString() + "'";
                    string sUserID = context.User.Identity.Name;
                    string sReMark = context.Request.Params["sReMark"] == null ? "NULL" : "'" + context.Request.Params["sReMark"].ToString() + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString() == "on" ? "'1'" : "'0'";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscDataBillDUpdateLog";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscDataBillDUpdateLog where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscDataBillDUpdateLog (iRecNo,iFormid,iSerial,sContent,sUserID,dInputDate,sReMark,iDisabled) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + ",'" + nextSerial + "'," + sContent + ",'" + sUserID + "',GETDATE()," + sReMark + "," + iDisabled + ") ");
                            strSql.Append(" select 1 as r");
                            sqe.Commtext = strSql.ToString();
                            DataTable tableResult = sqe.SqlQueryComm(connStr);
                            if (tableResult.Rows.Count > 0)
                            {
                                if (tableResult.Rows[0][0].ToString() == "1")
                                {
                                    context.Response.Write("1");
                                }
                                else
                                {
                                    context.Response.Write("error:数据库执行错误！");
                                }
                            }
                        }
                        else
                        {
                            context.Response.Write("error:错误下一主键错误！");
                        }
                    }
                    else if (otype == "edit")
                    {
                        //string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        string iRecNo = context.Request.Params["iRecNo"] == null ? "NULL" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        string iSerial = context.Request.Params["iSerial"] == null ? "NULL" : "'" + context.Request.Params["iSerial"].ToString().Replace("'", "''") + "'";
                        strSql.Append("update bscDataBillDUpdateLog set iSerial=" + iSerial + ",sContent=" + sContent + ",sUserID='" + sUserID + "',dInputDate=GETDATE()"+",sReMark=" + sReMark + ",iDisabled=" + iDisabled + " ");
                        strSql.Append(" where iRecNo=" + iRecNo + "");                   
                        strSql.Append(" select 1 as r");
                        SqlQueryExec sqe = new SqlQueryExec();
                        sqe.Commtext = strSql.ToString();
                        DataTable tableResult = sqe.SqlQueryComm(connStr);
                        if (tableResult.Rows.Count > 0)
                        {
                            if (tableResult.Rows[0][0].ToString() == "1")
                            {
                                context.Response.Write("1");
                            }
                            else
                            {
                                context.Response.Write("error:数据库执行错误！");
                            }
                        }
                    }
                }

                else if (otype == "remove")
                {
                    string iRecNo = context.Request.Params["iRecNo"] == null ? "NULL" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                    StringBuilder strSql = new StringBuilder();
                    strSql.Append("delete from bscDataBillDUpdateLog where iRecNo=" + iRecNo);
                    strSql.Append("  select 1 as r ");
                    SqlQueryExec sqe = new SqlQueryExec();
                    sqe.Commtext = strSql.ToString();
                    DataTable tableResult = sqe.SqlQueryComm(connStr);
                    if (tableResult.Rows.Count > 0)
                    {
                        if (tableResult.Rows[0][0].ToString() == "1")
                        {
                            context.Response.Write("1");
                        }
                        else
                        {
                            context.Response.Write("error:数据库执行错误！");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("error:" + ex.Message);
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