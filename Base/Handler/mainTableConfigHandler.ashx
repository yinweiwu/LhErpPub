<%@ WebHandler Language="C#" Class="mainTableConfigHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
public class mainTableConfigHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string from = context.Request.Params["from"] == null ? null : context.Request.Params["from"].ToString();
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        try
        {
            if (from == "tableDefault")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    //string iFormID = context.Request.Params["iFormID"] == null ? "NULL" : "'" + context.Request.Params["iFormID"].ToString().Replace("'", "''") + "'";
                    string sFieldName = context.Request.Params["sFieldName"] == null ? "NULL" : "'" + context.Request.Params["sFieldName"].ToString().Replace("'", "''") + "'";
                    string sDefaultValue = context.Request.Params["sDefaultValue"] == null ? "NULL" : "'" + context.Request.Params["sDefaultValue"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString().ToLower() == "on" ? "1" : "NULL";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscMainTableDefault";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscMainTableDefault where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscMainTableDefault (iRecNo,iFormid,iSerial,sFieldName,sDefaultValue,iDisabled) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + ",'" + nextSerial + "'," + sFieldName + "," + sDefaultValue + "," + iDisabled + ") ");
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
                        strSql.Append("update bscMainTableDefault set iSerial=" + iSerial + ",sFieldName=" + sFieldName + ",sDefaultValue=" + sDefaultValue + ",iDisabled=" + iDisabled + "");
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
                    strSql.Append("delete from bscMainTableDefault where iRecNo=" + iRecNo);
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
            if (from == "tableRequired")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    //string iFormID = context.Request.Params["iFormID"] == null ? "NULL" : "'" + context.Request.Params["iFormID"].ToString().Replace("'", "''") + "'";
                    string sFieldName = context.Request.Params["sFieldName"] == null ? "NULL" : "'" + context.Request.Params["sFieldName"].ToString().Replace("'", "''") + "'";
                    string sRequiredTip = context.Request.Params["sRequiredTip"] == null ? "NULL" : "'" + context.Request.Params["sRequiredTip"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString().ToLower() == "on" ? "1" : "NULL";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscMainTableRequired";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscMainTableRequired where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscMainTableRequired (iRecNo,iFormid,iSerial,sFieldName,sRequiredTip,iDisabled) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + ",'" + nextSerial + "'," + sFieldName + "," + sRequiredTip + "," + iDisabled + ") ");
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
                        strSql.Append("update bscMainTableRequired set iSerial=" + iSerial + ",sFieldName=" + sFieldName + ",sRequiredTip=" + sRequiredTip + ",iDisabled=" + iDisabled);
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
                    strSql.Append("delete from bscMainTableRequired where iRecNo=" + iRecNo);
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
            if (from == "tableLookUp")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    //string iFormID = context.Request.Params["iFormID"] == null ? "NULL" : "'" + context.Request.Params["iFormID"].ToString().Replace("'", "''") + "'";
                    string sFieldName = context.Request.Params["sFieldName"] == null ? "NULL" : "'" + context.Request.Params["sFieldName"].ToString().Replace("'", "''") + "'";
                    string sType = context.Request.Params["sType"] == null ? "NULL" : "'" + context.Request.Params["sType"].ToString().Replace("'", "''") + "'";
                    string sCondition = context.Request.Params["sCondition"] == null ? "NULL" : "'" + context.Request.Params["sCondition"].ToString().Replace("'", "''") + "'";
                    string sIden = context.Request.Params["sIden"] == null ? "NULL" : "'" + context.Request.Params["sIden"].ToString().Replace("'", "''") + "'";
                    string sMenuID = context.Request.Params["iMenuID"] == null ? "NULL" : "'" + context.Request.Params["iMenuID"].ToString().Replace("'", "''") + "'";
                    string sMatchFields = context.Request.Params["sMatchFields"] == null ? "NULL" : "'" + context.Request.Params["sMatchFields"].ToString().Replace("'", "''") + "'";
                    string iWidth = context.Request.Params["iWidth"] == null ? "NULL" : "'" + context.Request.Params["iWidth"].ToString().Replace("'", "''") + "'";
                    string iHeight = context.Request.Params["iHeight"] == null ? "NULL" : "'" + context.Request.Params["iHeight"].ToString().Replace("'", "''") + "'";
                    string sOnBeforeOpen = context.Request.Params["sOnBeforeOpen"] == null ? "NULL" : "'" + context.Request.Params["sOnBeforeOpen"].ToString().Replace("'", "''") + "'";
                    string sOnSelected = context.Request.Params["sOnSelected"] == null ? "NULL" : "'" + context.Request.Params["sOnSelected"].ToString().Replace("'", "''") + "'";
                    string sFields = context.Request.Params["sFields"] == null ? "NULL" : "'" + context.Request.Params["sFields"].ToString().Replace("'", "''") + "'";
                    string sSearchFields = context.Request.Params["sSearchFields"] == null ? "NULL" : "'" + context.Request.Params["sSearchFields"].ToString().Replace("'", "''") + "'";

                    string sFixFilters = context.Request.Params["sFixFilters"] == null ? "NULL" : "'" + context.Request.Params["sFixFilters"].ToString().Replace("'", "''") + "'";
                    string sChangeFilters = context.Request.Params["sChangeFilters"] == null ? "NULL" : "'" + context.Request.Params["sChangeFilters"].ToString().Replace("'", "''") + "'";
                    string iPageSize = context.Request.Params["iPageSize"] == null ? "NULL" : "'" + context.Request.Params["iPageSize"].ToString().Replace("'", "''") + "'";

                    string sFilters = context.Request.Params["sFilters"] == null ? "NULL" : "'" + context.Request.Params["sFilters"].ToString().Replace("'", "''") + "'";
                    string iTree = context.Request.Params["iTree"] == null ? "NULL" : context.Request.Params["iTree"].ToString().ToLower() == "on" ? "1" : "NULL";
                    string iCover = context.Request.Params["iCover"] == null ? "NULL" : context.Request.Params["iCover"].ToString().ToLower() == "on" ? "1" : "NULL";
                    string iEdit = context.Request.Params["iEdit"] == null ? "NULL" : context.Request.Params["iEdit"].ToString().ToLower() == "on" ? "1" : "NULL";
                    string sTextID = context.Request.Params["sTextID"] == null ? "NULL" : "'" + context.Request.Params["sTextID"].ToString().Replace("'", "''") + "'";
                    string sValueID = context.Request.Params["sValueID"] == null ? "NULL" : "'" + context.Request.Params["sValueID"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString().ToLower() == "on" ? "1" : "NULL";
                    string iMulti = context.Request.Params["iMulti"] == null ? "NULL" : context.Request.Params["iMulti"].ToString().ToLower() == "on" ? "1" : "NULL";
                    string sGroupField = context.Request.Params["sGroupField"] == null ? "NULL" : "'" + context.Request.Params["sGroupField"].ToString() + "'";
                    string sEditMatchFields = context.Request.Params["sEditMatchFields"] == null ? "NULL" : "'" + context.Request.Params["sEditMatchFields"].ToString().Replace("'", "''") + "'";
                    string iRecNo = context.Request.Params["iRecNo"] == null ? "NULL" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscChildTablesDLookUp";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscMainTableLookUp where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }
                            strSql.Append("if exists (select 1 from bscMainTableLookUp where sFieldName=" + sFieldName + " and sType<>" + sType + " and iFormID=" + iFormid + " and iRecNo<>" + iRecNo + ")begin select '一个字段只能设置一种类型！' as r return end ");
                            strSql.Append("insert into bscMainTableLookUp (iRecNo,iFormid,iMenuID,iSerial,sFieldName,sType,sCondition,sIden,sMatchFields,iWidth,iHeight,sOnBeforeOpen,sOnSelected,sFields,sSearchFields,sFixFilters,sChangeFilters,iPageSize,sFilters,iTree,iCover,sValueID,sTextID,iEdit,iDisabled,iMulti,sGroupField,sEditMatchFields) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + "," + sMenuID + ",'" + nextSerial + "'," + sFieldName + "," + sType + "," + sCondition + "," + sIden + "," + sMatchFields + "," + iWidth + "," + iHeight + "," + sOnBeforeOpen + "," + sOnSelected + "," + sFields + "," + sSearchFields + "," + sFixFilters + "," + sChangeFilters + "," + iPageSize + "," + sFilters + "," + iTree + "," + iCover + "," + sValueID + "," + sTextID + "," + iEdit + "," + iDisabled + "," + iMulti + "," + sGroupField + "," + sEditMatchFields + ") ");
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
                                    context.Response.Write("error:" + tableResult.Rows[0][0].ToString());
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
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";

                        StringBuilder strSql = new StringBuilder();
                        string iSerial = context.Request.Params["iSerial"] == null ? "NULL" : "'" + context.Request.Params["iSerial"].ToString().Replace("'", "''") + "'";
                        strSql.Append("if exists (select 1 from bscMainTableLookUp where sFieldName=" + sFieldName + " and sType<>" + sType + " and iFormID=" + iFormid + " and iRecNo<>" + iRecNo + ")begin select '一个字段只能设置一种类型！' as r return end ");
                        strSql.Append("update bscMainTableLookUp set iSerial=" + iSerial + ",iMenuID=" + sMenuID + ",sFieldName=" + sFieldName + ",sType=" + sType + ",sCondition=" + sCondition + ",sIden=" + sIden + ",sMatchFields=" + sMatchFields + ",iWidth=" + iWidth);
                        strSql.Append(",iHeight=" + iHeight + ",sOnBeforeOpen=" + sOnBeforeOpen + ",sOnSelected=" + sOnSelected + ",sFields=" + sFields + ",sSearchFields=" + sSearchFields + ",sFixFilters=" + sFixFilters + ",sChangeFilters=" + sChangeFilters + ",iPageSize=" + iPageSize);
                        strSql.Append(",sFilters=" + sFilters + ",iTree=" + iTree + ",iCover=" + iCover);
                        strSql.Append(",sTextID=" + sTextID + ",sValueID=" + sValueID + ",iEdit=" + iEdit + ",iDisabled=" + iDisabled + ",iMulti=" + iMulti + ",sGroupField=" + sGroupField + ",sEditMatchFields=" + sEditMatchFields);
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
                                context.Response.Write("error:" + tableResult.Rows[0][0].ToString());
                            }
                        }
                    }
                }

                else if (otype == "remove")
                {
                    string iRecNo = context.Request.Params["iRecNo"] == null ? "NULL" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                    StringBuilder strSql = new StringBuilder();
                    strSql.Append("delete from bscMainTableLookUp where iRecNo=" + iRecNo);
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
            if (from == "tableExp")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    //string iFormID = context.Request.Params["iFormID"] == null ? "NULL" : "'" + context.Request.Params["iFormID"].ToString().Replace("'", "''") + "'";
                    string sCondition = context.Request.Params["sCondition"] == null ? "NULL" : "'" + context.Request.Params["sCondition"].ToString().Replace("'", "''") + "'";
                    string sSourceField = context.Request.Params["sSourceField"] == null ? "NULL" : "'" + context.Request.Params["sSourceField"].ToString().Replace("'", "''") + "'";
                    string sTargetField = context.Request.Params["sTargetField"] == null ? "NULL" : "'" + context.Request.Params["sTargetField"].ToString().Replace("'", "''") + "'";
                    string sExpression = context.Request.Params["sExpression"] == null ? "NULL" : "'" + context.Request.Params["sExpression"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString().ToLower() == "on" ? "1" : "NULL";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscMainTableExpression";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscMainTableExpression where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscMainTableExpression (iRecNo,iFormid,iSerial,sCondition,sSourceField,sTargetField,sExpression,iDisabled) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + ",'" + nextSerial + "'," + sCondition + "," + sSourceField + "," + sTargetField + "," + sExpression + "," + iDisabled + ") ");
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
                        strSql.Append("update bscMainTableExpression set iSerial=" + iSerial + ",sCondition=" + sCondition + ",sSourceField=" + sSourceField + ",sTargetField=" + sTargetField + ",sExpression=" + sExpression + ",iDisabled=" + iDisabled);
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
                    strSql.Append("delete from bscMainTableExpression where iRecNo=" + iRecNo);
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
            if (from == "tableEvent")
            {
                string iFormID = context.Request.Params["iFormID"] == null ? "NULL" : "'" + context.Request.Params["iFormID"].ToString().Replace("'", "''") + "'";
                string sBeforeSave = context.Request.Params["sBeforeSave"] == null ? "NULL" : "'" + context.Request.Params["sBeforeSave"].ToString().Replace("'", "''") + "'";
                string sAfterSave = context.Request.Params["sAfterSave"] == null ? "NULL" : "'" + context.Request.Params["sAfterSave"].ToString().Replace("'", "''") + "'";
                string sBeforeLoad = context.Request.Params["sBeforeLoad"] == null ? "NULL" : "'" + context.Request.Params["sBeforeLoad"].ToString().Replace("'", "''") + "'";
                string sAfterLoad = context.Request.Params["sAfterLoad"] == null ? "NULL" : "'" + context.Request.Params["sAfterLoad"].ToString().Replace("'", "''") + "'";
                StringBuilder strSql = new StringBuilder();
                SqlQueryExec sqe = new SqlQueryExec();
                strSql.Append("if not exists(select 1 from bscMainTableEvent where iformid=" + iFormID + ")");
                strSql.Append(" begin insert into bscMainTableEvent (iFormid,sBeforeSave,sAfterSave,sBeforeLoad,sAfterLoad) ");
                strSql.Append("values ");
                strSql.Append("(" + iFormID + "," + sBeforeSave + "," + sAfterSave + "," + sBeforeLoad + "," + sAfterLoad + ") end");
                strSql.Append(" else begin");
                strSql.Append(" update bscMainTableEvent set sBeforeSave=" + sBeforeSave + ",sAfterSave=" + sAfterSave + ",sBeforeLoad=" + sBeforeLoad + ",sAfterLoad=" + sAfterLoad + " where iformid=" + iFormID + "");
                strSql.Append(" end");
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
            if (from == null)
            {
                string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
                if (otype == "getFormField")
                {
                    string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
                    DataTable tableForm = new SqlQueryExec("select sTableName from bscDataBill where iFormID=" + iformid).SqlQueryComm(connStr);
                    if (tableForm.Rows.Count > 0)
                    {
                        DataTable tableFields = new SqlQueryExec("select * from " + tableForm.Rows[0]["sTableName"].ToString() + " where 1<>1").SqlQueryComm(connStr);
                        if (tableFields.Columns.Count > 0)
                        {
                            StringBuilder fieldStr = new StringBuilder();
                            fieldStr.Append("{\"total\":\"" + tableFields.Columns.Count.ToString() + "\",\"rows\":[");
                            for (int i = 0; i < tableFields.Columns.Count; i++)
                            {
                                fieldStr.Append("{\"field\":\"" + tableFields.Columns[i].ColumnName + "\"},");
                            }
                            fieldStr.Remove(fieldStr.Length - 1, 1);
                            fieldStr.Append("]}");
                            context.Response.Write(fieldStr);
                        }
                        else
                        {
                            context.Response.Write("error:表单表名未定义或表已不存在！");
                        }
                    }
                    else
                    {
                        context.Response.Write("error:表单不存在！");
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