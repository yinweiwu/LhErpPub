<%@ WebHandler Language="C#" Class="childTableConfigHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using sysBaseDAL.common;
using Newtonsoft.Json;
public class childTableConfigHandler : IHttpHandler
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
                    string sFieldKey = context.Request.Params["sFieldKey"] == null ? "NULL" : "'" + context.Request.Params["sFieldKey"].ToString().Replace("'", "''") + "'";
                    string sTitle = context.Request.Params["sTitle"] == null ? "NULL" : "'" + context.Request.Params["sTitle"].ToString().Replace("'", "''") + "'";
                    string sSql = context.Request.Params["sSql"] == null ? "NULL" : context.Request.Params["sSql"].ToString().Replace("'", "''");
                    string sTableName = context.Request.Params["sTableName"] == null ? "NULL" : "'" + context.Request.Params["sTableName"].ToString() + "'";
                    string sSerialTableName = context.Request.Params["sSerialTableName"] == null ? "NULL" : "'" + context.Request.Params["sSerialTableName"].ToString() + "'";
                    string sLinkField = context.Request.Params["sLinkField"] == null ? "NULL" : "'" + context.Request.Params["sLinkField"].ToString() + "'";
                    string sFixFields = context.Request.Params["sFixFields"] == null ? "NULL" : "'" + context.Request.Params["sFixFields"].ToString() + "'";
                    string sSumFields = context.Request.Params["sSumFields"] == null ? "NULL" : "'" + context.Request.Params["sSumFields"].ToString() + "'";
                    string sOrder = context.Request.Params["sOrder"] == null ? "NULL" : "'" + context.Request.Params["sOrder"].ToString() + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString() == "on" ? "'1'" : "'0'";
                    if (otype == "add")
                    {
                        string iFormid = context.Request.Params["iFormid"] == null ? "NULL" : "'" + context.Request.Params["iFormid"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscChildTables";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscChildTables where iformid=" + iFormid + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscChildTables (iRecNo,iFormid,iSerial,sTitle,sSql,sTableName,sFieldKey,sLinkField,sFixFields,sSumFields,sOrder,iDisabled,sSerialTableName) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iFormid + ",'" + nextSerial + "'," + sTitle + ",'" + sSql + "'," + sTableName + "," + sFieldKey + "," + sLinkField + "," + sFixFields + "," + sSumFields + "," + sOrder + "," + iDisabled + "," + sSerialTableName + ") ");
                            strSql.Append("insert into bscChildTablesDEvent (iMainRecNo) values ('" + nextRecNo + "')");
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
                        strSql.Append("update bscChildTables set iSerial=" + iSerial + ",sFieldKey=" + sFieldKey + ",sOrder=" + sOrder + ",sTitle=" + sTitle + ",sSql='" + sSql + "',sTableName=" + sTableName + ",sLinkField=" + sLinkField + ",sFixFields=" + sFixFields + ",sSumFields=" + sSumFields + ",iDisabled=" + iDisabled + ",sSerialTableName=" + sSerialTableName + " ");
                        strSql.Append(" where iRecNo=" + iRecNo + "");
                        strSql.Append("if not exists(select 1 from bscChildTablesDEvent where iMainRecNo=" + iRecNo + ")begin\r\n");
                        strSql.Append("insert into bscChildTablesDEvent (iMainRecNo) values (" + iRecNo + ") end\r\n");                        
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
                    strSql.Append("delete from bscChildTables where iRecNo=" + iRecNo);
                    strSql.Append(" delete from bscChildTablesDColumns where iMainRecNo=" + iRecNo);
                    strSql.Append(" delete from bscChildTablesDLookUp where iMainRecNo=" + iRecNo);
                    strSql.Append(" delete from bscChildTablesDImportBtn where iMainRecNo=" + iRecNo);
                    strSql.Append(" delete from bscChildTablesDEvent where iMainRecNo=" + iRecNo);
                    strSql.Append(" delete from bacChildTablesDExpression where iMainRecNo=" + iRecNo);
                    strSql.Append(" delete from bscChildDynColumn where iMainRecNo=" + iRecNo);
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
                else if (otype == "bulidColumns")
                {
                    string sSql = context.Request.Params["sSql"] == null ? "NULL" : context.Request.Params["sSql"].ToString().Replace("'", "''");
                    string iRecNo = context.Request.Params["iRecNo"] == null ? "NULL" : "'" + context.Request.Params["iRecNo"].ToString() + "'";
                    SqlQueryExec sqeAfterAdd = new SqlQueryExec(sSql.Replace("{condition}", "1<>1").Replace(",{columns}", ""));
                    DataTable tableAfaterAdd = sqeAfterAdd.SqlQueryComm(connStr);
                    StringBuilder sqlAfterAdd = new StringBuilder();
                    if (tableAfaterAdd.Columns.Count > 0)
                    {
                        sqlAfterAdd.Append("delete from bscChildTablesDColumns where iMainRecNo=" + iRecNo + " ");
                        for (int i = 0; i < tableAfaterAdd.Columns.Count; i++)
                        {
                            sqlAfterAdd.Append("declare @iRecNo" + i.ToString() + " int ");
                            sqlAfterAdd.Append("exec GetTableLsh 'bscChildTablesDColumns',@iRecNo" + i.ToString() + " output ");
                            string sType = "字符";
                            switch (tableAfaterAdd.Columns[i].ColumnName.Substring(0,1).ToLower())
                            {
                                case "i": sType = "整数"; break;
                                case "f": sType = "数据"; break;
                                case "d": sType = "日期"; break;
                            }
                            sqlAfterAdd.Append("insert into bscChildTablesDColumns (iRecNo,iMainRecNo,iSerial,sFieldName,sType) values (@iRecNo" + i.ToString() + "," + iRecNo + "," + (i + 1).ToString() + ",'" + tableAfaterAdd.Columns[i].ColumnName + "','" + sType + "') ");
                        }
                        //sqlAfterAdd.Append("insert into ");
                    }
                    sqlAfterAdd.Append("select 1 as r");
                    sqeAfterAdd.Commtext = sqlAfterAdd.ToString();
                    DataTable tableAfterAddResult = sqeAfterAdd.SqlQueryComm(connStr);
                    if (tableAfterAddResult.Rows.Count > 0)
                    {
                        if (tableAfterAddResult.Rows[0][0].ToString() == "1")
                        {
                            context.Response.Write("1");
                        }
                        else
                        {
                            context.Response.Write("error:发生错误！");
                        }
                    }
                }
            }
            else if (from == "tableColumn")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    string sFieldName = context.Request.Params["sFieldName"] == null ? "NULL" : "'" + context.Request.Params["sFieldName"].ToString().Replace("'", "''") + "'";
                    string sTitle = context.Request.Params["sTitle"] == null ? "NULL" : "'" + context.Request.Params["sTitle"].ToString().Replace("'", "''") + "'";
                    string sType = context.Request.Params["sType"] == null ? "NULL" : "'" + context.Request.Params["sType"].ToString() + "'";
                    string iEdit = context.Request.Params["iEdit"] == null ? "NULL" : context.Request.Params["iEdit"].ToString() == "on" ? "'1'" : "'0'";
                    string iHidden = context.Request.Params["iHidden"] == null ? "NULL" : context.Request.Params["iHidden"].ToString() == "on" ? "'1'" : "'0'";
                    string fWidth = context.Request.Params["fWidth"] == null ? "NULL" : "'" + context.Request.Params["fWidth"].ToString() + "'";
                    string iRequired = context.Request.Params["iRequired"] == null ? "NULL" : context.Request.Params["iRequired"].ToString() == "on" ? "'1'" : "'0'";
                    string iDigit = context.Request.Params["iDigit"] == null ? "NULL" : "'" + context.Request.Params["iDigit"].ToString() + "'";
                    string sDefaultValue = context.Request.Params["sDefaultValue"] == null ? "NULL" : "'" + context.Request.Params["sDefaultValue"].ToString().Replace("'", "''") + "'";
                    string iAutoAdd = context.Request.Params["iAutoAdd"] == null ? "NULL" : context.Request.Params["iAutoAdd"].ToString() == "on" ? "'1'" : "'0'";
                    string iNoCopy = context.Request.Params["iNoCopy"] == null ? "NULL" : context.Request.Params["iNoCopy"].ToString() == "on" ? "'1'" : "'0'";
                    
                    string iSum = context.Request.Params["iSum"] == null ? "NULL" : context.Request.Params["iSum"].ToString() == "on" ? "'1'" : "'0'";
                    string iAvg = context.Request.Params["iAvg"] == null ? "NULL" : context.Request.Params["iAvg"].ToString() == "on" ? "'1'" : "'0'";
                    string iCount = context.Request.Params["iCount"] == null ? "NULL" : context.Request.Params["iCount"].ToString() == "on" ? "'1'" : "'0'";
                    string iMax = context.Request.Params["iMax"] == null ? "NULL" : context.Request.Params["iMax"].ToString() == "on" ? "'1'" : "'0'";
                    string iMin = context.Request.Params["iMin"] == null ? "NULL" : context.Request.Params["iMin"].ToString() == "on" ? "'1'" : "'0'";
                    string iFix = context.Request.Params["iFix"] == null ? "NULL" : context.Request.Params["iFix"].ToString() == "on" ? "'1'" : "'0'";

                    string sSumMainField = context.Request.Params["sSumMainField"] == null ? "NULL" : "'" + context.Request.Params["sSumMainField"].ToString().Replace("'", "''") + "'";
                    string sAvgMainField = context.Request.Params["sAvgMainField"] == null ? "NULL" : "'" + context.Request.Params["sAvgMainField"].ToString().Replace("'", "''") + "'";
                    string sCountMainField = context.Request.Params["sCountMainField"] == null ? "NULL" : "'" + context.Request.Params["sCountMainField"].ToString() + "'";
                    string sMaxMainField = context.Request.Params["sMaxMainField"] == null ? "NULL" : "'" + context.Request.Params["sMaxMainField"].ToString().Replace("'", "''") + "'";
                    string sMinMainField = context.Request.Params["sMinMainField"] == null ? "NULL" : "'" + context.Request.Params["sMinMainField"].ToString().Replace("'", "''") + "'";
                    string sStyle = context.Request.Params["sStyle"] == null ? "NULL" : "'" + context.Request.Params["sStyle"].ToString().Replace("'", "''") + "'";
                    string sHideSql = context.Request.Params["sHideSql"] == null ? "NULL" : "'" + context.Request.Params["sHideSql"].ToString().Replace("'", "''") + "'";
                    string iSummryDigit = context.Request.Params["iSummryDigit"] == null ? "NULL" : "'" + context.Request.Params["iSummryDigit"].ToString().Replace("'", "''") + "'";
                    if (otype == "add")
                    {
                        string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "NULL" : "'" + context.Request.Params["iMainRecNo"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscChildTablesDColumns";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscChildTablesDColumns where iMainRecNo=" + iMainRecNo + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }
                            strSql.Append("insert into bscChildTablesDColumns (iRecNo,iMainRecNo,iSerial,sFieldName,sTitle,sType,iEdit,iHidden,fWidth,iRequired,iDigit,sDefaultValue,iAutoAdd,iSum,iAvg,iCount,iMax,iMin,sSumMainField,sAvgMainField,sCountMainField,sMaxMainField,sMinMainField,iFix,iNoCopy,sStyle,sHideSql,iSummryDigit) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iMainRecNo + ",'" + nextSerial + "'," + sFieldName + "," + sTitle + "," + sType + "," + iEdit + "," + iHidden + "," + fWidth + "," + iRequired + "," + iDigit + "," + sDefaultValue + "," + iAutoAdd + "," + iSum + "," + iAvg + "," + iCount + "," + iMax + "," + iMin + "," + sSumMainField + "," + sAvgMainField + "," + sCountMainField + "," + sMaxMainField + "," + sMinMainField + "," + iFix + "," + iNoCopy + "," + sStyle + "," + sHideSql + "," + iSummryDigit + ") ");
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
                        strSql.Append("update bscChildTablesDColumns set iSerial=" + iSerial + ",sFieldName=" + sFieldName + ",sTitle=" + sTitle + ",sType=" + sType + ",iEdit=" + iEdit + ",iHidden=" + iHidden + ",fWidth=" + fWidth + ",iRequired=" + iRequired + ",iDigit=" + iDigit + ",sDefaultValue=" + sDefaultValue + ",iAutoAdd=" + iAutoAdd + ",iSum=" + iSum + ",iAvg=" + iAvg + ",iCount=" + iCount + ",iMax=" + iMax + ",iMin=" + iMin + ",sSumMainField=" + sSumMainField + ",sAvgMainField=" + sAvgMainField + ",sCountMainField=" + sCountMainField + ",sMaxMainField=" + sMaxMainField + ",sMinMainField=" + sMinMainField + ",iFix=" + iFix + ",iNoCopy=" + iNoCopy + ",sStyle=" + sStyle + ",sHideSql=" + sHideSql + ",iSummryDigit=" + iSummryDigit + " ");
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
                    strSql.Append("delete from bscChildTablesDColumns where iRecNo=" + iRecNo + " select 1 as r");
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
                else if (otype == "saveColumnSort")
                {
                    string detailStr = context.Request.Params["detailStr"] == null ? "" : context.Request.Params["detailStr"].ToString();
                    DataTable table = JsonConvert.DeserializeObject<DataTable>(detailStr);
                    StringBuilder strSql = new StringBuilder();
                    for (int i = 0; i < table.Rows.Count; i++)
                    {
                        strSql.Append("update bscChildTablesDColumns set iSerial=" + table.Rows[i]["iSerial"].ToString() + " where iRecNo=" + table.Rows[i]["iRecNo"].ToString() + " ");
                    }
                    SqlQueryExec sqe = new SqlQueryExec();
                    sqe.Commtext = strSql.ToString();
                    try
                    {
                        sqe.SqlQueryCommQuery(connStr);
                        context.Response.Write("1");
                    }
                    catch (Exception ex)
                    {
                        context.Response.Write(ex.Message);
                    }
                }
            }
            else if (from == "tableLookUp")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    string sFieldName = context.Request.Params["sFieldName"] == null ? "NULL" : "'" + context.Request.Params["sFieldName"].ToString().Replace("'", "''") + "'";
                    string sCondition = context.Request.Params["sCondition"] == null ? "NULL" : "'" + context.Request.Params["sCondition"].ToString().Replace("'", "''") + "'";
                    string sLookUpName = context.Request.Params["sLookUpName"] == null ? "NULL" : "'" + context.Request.Params["sLookUpName"].ToString().Replace("'", "''") + "'";
                    string sFields = context.Request.Params["sFields"] == null ? "NULL" : "'" + context.Request.Params["sFields"].ToString().Replace("'", "''") + "'";
                    string sSearchFields = context.Request.Params["sSearchFields"] == null ? "NULL" : "'" + context.Request.Params["sSearchFields"].ToString().Replace("'", "''") + "'";
                    string sMatchFields = context.Request.Params["sMatchFields"] == null ? "NULL" : "'" + context.Request.Params["sMatchFields"].ToString().Replace("'", "''") + "'";
                    string sFixFilters = context.Request.Params["sFixFilters"] == null ? "NULL" : "'" + context.Request.Params["sFixFilters"].ToString().Replace("'", "''") + "'";
                    string sChangeFilters = context.Request.Params["sChangeFilters"] == null ? "NULL" : "'" + context.Request.Params["sChangeFilters"].ToString().Replace("'", "''") + "'";
                    string fWidth = context.Request.Params["fWidth"] == null ? "NULL" : "'" + context.Request.Params["fWidth"].ToString().Replace("'", "''") + "'";
                    string fHeight = context.Request.Params["fHeight"] == null ? "NULL" : "'" + context.Request.Params["fHeight"].ToString().Replace("'", "''") + "'";
                    string iMulti = context.Request.Params["iMulti"] == null ? "NULL" : context.Request.Params["iMulti"].ToString() == "on" ? "'1'" : "'0'";
                    string iEdit = context.Request.Params["iEdit"] == null ? "NULL" : context.Request.Params["iEdit"].ToString() == "on" ? "'1'" : "'0'";
                    string iPageSize = context.Request.Params["iPageSize"] == null ? "NULL" : "'" + context.Request.Params["iPageSize"].ToString().Replace("'", "''") + "'";
                    string sBeforeOpen = context.Request.Params["sBeforeOpen"] == null ? "NULL" : "'" + context.Request.Params["sBeforeOpen"].ToString().Replace("'", "''") + "'";
                    string sAfterSelected = context.Request.Params["sAfterSelected"] == null ? "NULL" : "'" + context.Request.Params["sAfterSelected"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString() == "on" ? "'1'" : "'0'";
                    string sComboLoadFilters = context.Request.Params["sComboLoadFilters"] == null ? "NULL" : "'" + context.Request.Params["sComboLoadFilters"].ToString().Replace("'", "''") + "'";
                    string sEditMatchFields = context.Request.Params["sEditMatchFields"] == null ? "NULL" : "'" + context.Request.Params["sEditMatchFields"].ToString().Replace("'", "''") + "'";
                    if (otype == "add")
                    {
                        string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "NULL" : "'" + context.Request.Params["iMainRecNo"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscChildTablesDLookUp";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscChildTablesDLookUp where iMainRecNo=" + iMainRecNo + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }
                            strSql.Append("insert into bscChildTablesDLookUp (iRecNo,iMainRecNo,iSerial,sFieldName,sCondition,sLookUpName,sFields,sSearchFields,sMatchFields,sFixFilters,sChangeFilters,fWidth,fHeight,iMulti,iPageSize,sBeforeOpen,sAfterSelected,iEdit,iDisabled,sComboLoadFilters,sEditMatchFields) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iMainRecNo + ",'" + nextSerial + "'," + sFieldName + "," + sCondition + "," + sLookUpName + "," + sFields + "," + sSearchFields + "," + sMatchFields + "," + sFixFilters + "," + sChangeFilters + "," + fWidth + "," + fHeight + "," + iMulti + "," + iPageSize + "," + sBeforeOpen + "," + sAfterSelected + "," + iEdit + "," + iDisabled + "," + sComboLoadFilters + "," + sEditMatchFields + ") ");
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
                        strSql.Append("update bscChildTablesDLookUp set sFieldName=" + sFieldName + ",iSerial=" + iSerial + ",sCondition=" + sCondition + ",sLookUpName=" + sLookUpName + ",sFields=" + sFields + ",sSearchFields=" + sSearchFields + ",sMatchFields=" + sMatchFields + ",sFixFilters=" + sFixFilters + ",sChangeFilters=" + sChangeFilters + ",fWidth=" + fWidth + ",fHeight=" + fHeight + ",iMulti=" + iMulti + ",iPageSize=" + iPageSize + ",sBeforeOpen=" + sBeforeOpen + ",sAfterSelected=" + sAfterSelected + ",iEdit=" + iEdit + ",iDisabled=" + iDisabled + ",sComboLoadFilters=" + sComboLoadFilters + ",sEditMatchFields=" + sEditMatchFields + " ");
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
                    strSql.Append("delete from bscChildTablesDLookUp where iRecNo=" + iRecNo + " select 1 as r");
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
            else if (from == "tableEvent")
            {
                string iMainRecNo = context.Request.Params["iMainRecNo"].ToString();

                string sOnBeforeAddRow = context.Request.Params["sOnBeforeAddRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnBeforeAddRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnAfterAddRow = context.Request.Params["sOnAfterAddRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnAfterAddRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnBeforeDeleteRow = context.Request.Params["sOnBeforeDeleteRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnBeforeDeleteRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnAfterDeleteRow = context.Request.Params["sOnAfterDeleteRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnAfterDeleteRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";

                string sOnClickRow = context.Request.Params["sOnClickRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnClickRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnDblClickRow = context.Request.Params["sOnDblClickRow"] == "" ? "NULL" : "'" + context.Request.Params["sOnDblClickRow"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnClickCell = context.Request.Params["sOnClickCell"] == "" ? "NULL" : "'" + context.Request.Params["sOnClickCell"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnDblClickCell = context.Request.Params["sOnDblClickCell"] == "" ? "NULL" : "'" + context.Request.Params["sOnDblClickCell"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnBeforeEdit = context.Request.Params["sOnBeforeEdit"] == "" ? "NULL" : "'" + context.Request.Params["sOnBeforeEdit"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnBeginEdit = context.Request.Params["sOnBeginEdit"] == "" ? "NULL" : "'" + context.Request.Params["sOnBeginEdit"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnEndEdit = context.Request.Params["sOnEndEdit"] == "" ? "NULL" : "'" + context.Request.Params["sOnEndEdit"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                string sOnAfterEdit = context.Request.Params["sOnAfterEdit"] == "" ? "NULL" : "'" + context.Request.Params["sOnAfterEdit"].ToString().Replace("'", "''").Replace("\"", "''") + "'";

                string sSql = "update bscChildTablesDEvent set sOnBeforeAddRow=" + sOnBeforeAddRow + ",sOnAfterAddRow=" + sOnAfterAddRow + ",sOnBeforeDeleteRow=" + sOnBeforeDeleteRow + ",sOnAfterDeleteRow=" + sOnAfterDeleteRow + ",sOnClickRow=" + sOnClickRow + ",sOnDblClickRow=" + sOnDblClickRow + ",sOnClickCell=" + sOnClickCell + ",sOnDblClickCell=" + sOnDblClickCell + ",sOnBeforeEdit=" + sOnBeforeEdit + ",sOnBeginEdit=" + sOnBeginEdit + ",sOnEndEdit=" + sOnEndEdit + ",sOnAfterEdit=" + sOnAfterEdit + " where iMainRecNo=" + iMainRecNo;
                sSql += " select 1 as r";
                SqlQueryExec sqe = new SqlQueryExec(sSql);
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
            else if (from == "tableImport")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    string sType = context.Request.Params["sType"] == null ? "NULL" : "'" + context.Request.Params["sType"].ToString().Replace("'", "''") + "'";
                    string sTitle = context.Request.Params["sTitle"] == null ? "NULL" : "'" + context.Request.Params["sTitle"].ToString().Replace("'", "''") + "'";
                    string sIden = context.Request.Params["sIden"] == null ? "NULL" : "'" + context.Request.Params["sIden"].ToString().Replace("'", "''") + "'";
                    string sMenuID = context.Request.Params["iMenuID"] == null ? "NULL" : "'" + context.Request.Params["iMenuID"].ToString().Replace("'", "''") + "'";
                    string sMatchFields = context.Request.Params["sMatchFields"] == null ? "NULL" : "'" + context.Request.Params["sMatchFields"].ToString().Replace("'", "''") + "'";
                    string iWidth = context.Request.Params["iWidth"] == null ? "NULL" : "'" + context.Request.Params["iWidth"].ToString() + "'";
                    string iHeight = context.Request.Params["iHeight"] == null ? "NULL" : "'" + context.Request.Params["iHeight"].ToString().Replace("'", "''") + "'";
                    string iMulti = context.Request.Params["iMulti"] == null ? "NULL" : context.Request.Params["iMulti"].ToString() == "on" ? "1" : "0";
                    string sOnBeforeOpen = context.Request.Params["sOnBeforeOpen"] == null ? "NULL" : "'" + context.Request.Params["sOnBeforeOpen"].ToString().Replace("'", "''") + "'";
                    string sOnSelected = context.Request.Params["sOnSelected"] == null ? "NULL" : "'" + context.Request.Params["sOnSelected"].ToString().Replace("'", "''") + "'";
                    string sFilters = context.Request.Params["sFilters"] == null ? "NULL" : "'" + context.Request.Params["sFilters"].ToString().Replace("'", "''") + "'";
                    string iTree = context.Request.Params["iTree"] == null ? "NULL" : context.Request.Params["iTree"].ToString() == "on" ? "1" : "0";
                    string iCover = context.Request.Params["iCover"] == null ? "NULL" : context.Request.Params["iCover"].ToString() == "on" ? "1" : "0";
                    string sFields = context.Request.Params["sFields"] == null ? "NULL" : "'" + context.Request.Params["sFields"].ToString() + "'";
                    string sSearchFields = context.Request.Params["sSearchFields"] == null ? "NULL" : "'" + context.Request.Params["sSearchFields"].ToString().Replace("'", "''") + "'";
                    string sFixFilters = context.Request.Params["sFixFilters"] == null ? "NULL" : "'" + context.Request.Params["sFixFilters"].ToString().Replace("'", "''") + "'";
                    string sChangeFilters = context.Request.Params["sChangeFilters"] == null ? "NULL" : "'" + context.Request.Params["sChangeFilters"].ToString().Replace("'", "''") + "'";
                    string iPageSize = context.Request.Params["iPageSize"] == null ? "NULL" : "'" + context.Request.Params["iPageSize"].ToString() + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString() == "on" ? "1" : "0";
                    string sGroup = context.Request.Params["sGroup"] == null ? "NULL" : "'" + context.Request.Params["sGroup"].ToString().Replace("'", "''") + "'";
                    string sStyle = context.Request.Params["sStyle"] == null ? "NULL" : "'" + context.Request.Params["sStyle"].ToString().Replace("'", "''") + "'";
                    if (otype == "add")
                    {
                        string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "NULL" : "'" + context.Request.Params["iMainRecNo"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bscChildTablesDImportBtn";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bscChildTablesDImportBtn where iMainRecNo=" + iMainRecNo + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bscChildTablesDImportBtn (iRecNo,iMainRecNo,iSerial,sTitle,sType,sIden,iMenuID,sMatchFields,iWidth,iHeight,iMulti,sOnBeforeOpen,sOnSelected,sFilters,iTree,iCover,sFields,sSearchFields,sFixFilters,sChangeFilters,iPageSize,iDisabled,sGroup,sStyle) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iMainRecNo + ",'" + nextSerial + "'," + sTitle + "," + sType + "," + sIden + "," + sMenuID + "," + sMatchFields + "," + iWidth + "," + iHeight + "," + iMulti + "," + sOnBeforeOpen + "," + sOnSelected + "," + sFilters + "," + iTree + "," + iCover + "," + sFields + "," + sSearchFields + "," + sFixFilters + "," + sChangeFilters + "," + iPageSize + "," + iDisabled + "," + sGroup + "," + sStyle + ") ");

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
                        strSql.Append("update bscChildTablesDImportBtn set iSerial=" + iSerial + ",sTitle=" + sTitle + ",sType=" + sType + ",sIden=" + sIden + ",iMenuID="+sMenuID+",sMatchFields=" + sMatchFields + ",iWidth=" + iWidth + ",iHeight=" + iHeight + ",iMulti=" + iMulti + ",sOnBeforeOpen=" + sOnBeforeOpen + ",");
                        strSql.Append("sOnSelected=" + sOnSelected + ",sFilters=" + sFilters + ",iTree=" + iTree + ",iCover=" + iCover + ",sFields=" + sFields + ",sSearchFields=" + sSearchFields + ",sFixFilters=" + sFixFilters + ",sChangeFilters=" + sChangeFilters + ",iPageSize=" + iPageSize + ",iDisabled=" + iDisabled + ",sGroup=" + sGroup + ",sStyle=" + sStyle);
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
                    strSql.Append("delete from bscChildTablesDImportBtn where iRecNo=" + iRecNo + " select 1 as r");
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
            else if (from == "tableExp")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == "add" || otype == "edit")
                {
                    string sSourceField = context.Request.Params["sSourceField"] == null ? "NULL" : "'" + context.Request.Params["sSourceField"].ToString().Replace("'", "''") + "'";
                    string sTargetField = context.Request.Params["sTargetField"] == null ? "NULL" : "'" + context.Request.Params["sTargetField"].ToString().Replace("'", "''") + "'";
                    string sExpression = context.Request.Params["sExpression"] == null ? "NULL" : "'" + context.Request.Params["sExpression"].ToString().Replace("'", "''") + "'";
                    string iDisabled = context.Request.Params["iDisabled"] == null ? "NULL" : context.Request.Params["iDisabled"].ToString() == "on" ? "1" : "0";
                    if (otype == "add")
                    {
                        string iMainRecNo = context.Request.Params["iMainRecNo"] == null ? "NULL" : "'" + context.Request.Params["iMainRecNo"].ToString() + "'";
                        StringBuilder strSql = new StringBuilder();
                        SqlStoreProcQuery ssp = new SqlStoreProcQuery();
                        ssp.StoreProName = "SpGetIden";
                        ssp.ParamsStr = "bacChildTablesDExpression";
                        if (ssp.SqlStoreProcQueryExce(connStr, "").Rows.Count > 0)
                        {
                            string nextRecNo = ssp.SqlStoreProcQueryExce(connStr, "").Rows[0][0].ToString();
                            string nextSerial = "1";
                            SqlQueryExec sqe = new SqlQueryExec("select max(iSerial)+1 from bacChildTablesDExpression where iMainRecNo=" + iMainRecNo + "");
                            DataTable table = sqe.SqlQueryComm(connStr);
                            if (table.Rows.Count > 0)
                            {
                                nextSerial = table.Rows[0][0].ToString();
                            }
                            if (nextSerial == "")
                            {
                                nextSerial = "1";
                            }

                            strSql.Append("insert into bacChildTablesDExpression (iRecNo,iMainRecNo,iSerial,sSourceField,sTargetField,sExpression,iDisabled) ");
                            strSql.Append("values ");
                            strSql.Append("('" + nextRecNo + "'," + iMainRecNo + ",'" + nextSerial + "'," + sSourceField + "," + sTargetField + "," + sExpression + "," + iDisabled + ") ");

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
                        strSql.Append("update bacChildTablesDExpression set iSerial=" + iSerial + ",sSourceField=" + sSourceField + ",sTargetField=" + sTargetField + ",sExpression=" + sExpression + ",iDisabled=" + iDisabled + "");
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
                    strSql.Append("delete from bacChildTablesDExpression where iRecNo=" + iRecNo + " select 1 as r");
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
            else if (from == "tableDyn")
            {
                string otype = context.Request.Params["otype"] == null ? null : context.Request.Params["otype"].ToString();
                if (otype == null)
                {
                    string iMainRecNo = context.Request.Params["iMainRecNo"].ToString();
                    string sTriggerField = context.Request.Params["sTriggerField"] == "" ? "NULL" : "'" + context.Request.Params["sTriggerField"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string sColumnSource = context.Request.Params["sColumnSource"] == "" ? "NULL" : "'" + context.Request.Params["sColumnSource"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string iColumnIndex = context.Request.Params["iColumnIndex"] == "" ? "NULL" : "'" + context.Request.Params["iColumnIndex"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string iSummary = context.Request.Params["iSummary"] == null ? "NULL" : context.Request.Params["iSummary"].ToString() == "on" ? "'1'" : "NULL";
                    string sSummaryFieldM = context.Request.Params["sSummaryFieldM"] == "" ? "NULL" : "'" + context.Request.Params["sSummaryFieldM"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string sSummaryFieldD = context.Request.Params["sSummaryFieldD"] == "" ? "NULL" : "'" + context.Request.Params["sSummaryFieldD"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string iWidth = context.Request.Params["iWidth"] == "" ? "NULL" : "'" + context.Request.Params["iWidth"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    try
                    {
                        sqlHelper sqlhelper = new sqlHelper(connStr);
                        DataTable tableCheck = sqlhelper.commExecAndReturn(context.Request.Params["sColumnSource"].ToString().Replace("{this}", "0"));
                    }
                    catch (Exception ex)
                    {
                        context.Response.Write("error:列源设置错误：" + ex.Message);
                        return;
                    }
                    string sColumnDataSource = context.Request.Params["sColumnDataSource"] == "" ? "NULL" : "'" + context.Request.Params["sColumnDataSource"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    //try
                    //{
                    //    sqlHelper sqlhelper = new sqlHelper(connStr);
                    //    DataTable tableCheck = sqlhelper.commExecAndReturn(context.Request.Params["sColumnDataSource"].ToString());
                    //}
                    //catch (Exception ex)
                    //{
                    //    context.Response.Write("error:列数据源设置错误：" + ex.Message);
                    //    return;
                    //}
                    string sTableName = context.Request.Params["sTableName"] == "" ? "NULL" : "'" + context.Request.Params["sTableName"].ToString().Replace("'", "''").Replace("\"", "''") + "'";

                    string sColumnMatchField = context.Request.Params["sColumnMatchField"] == "" ? "NULL" : "'" + context.Request.Params["sColumnMatchField"].ToString().Replace("'", "''").Replace("\"", "''") + "'";
                    string sColumnValueMatchField = context.Request.Params["sColumnValueMatchField"] == "" ? "NULL" : "'" + context.Request.Params["sColumnValueMatchField"].ToString().Replace("'", "''").Replace("\"", "''") + "'";

                    try
                    {
                        sqlHelper sqlhelper = new sqlHelper(connStr);
                        DataTable tableCheck = sqlhelper.commExecAndReturn("select top 1 " + context.Request.Params["sColumnMatchField"].ToString() + "," + context.Request.Params["sColumnValueMatchField"].ToString() + " from " + context.Request.Params["sTableName"].ToString());
                    }
                    catch (Exception ex)
                    {
                        context.Response.Write("error:目标表设置错误：" + ex.Message);
                        return;
                    }
                    StringBuilder sSql = new StringBuilder();
                    sSql.Append("delete from bscChildDynColumn where iMainRecNo='" + iMainRecNo + "'");
                    sSql.Append("insert into bscChildDynColumn (iMainRecNo,sTriggerField,sColumnSource,sColumnDataSource,sTableName,sColumnMatchField,sColumnValueMatchField,iColumnIndex,iSummary,sSummaryFieldM,sSummaryFieldD,iWidth) values ");
                    sSql.Append("(" + iMainRecNo + "," + sTriggerField + "," + sColumnSource + "," + sColumnDataSource + "," + sTableName + "," + sColumnMatchField + "," + sColumnValueMatchField + "," + iColumnIndex + "," + iSummary + "," + sSummaryFieldM + "," + sSummaryFieldD + "," + iWidth + ")");
                    sSql.Append(" select 1 as r");
                    SqlQueryExec sqe = new SqlQueryExec(sSql.ToString());
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
                else if (otype == "remove") {
                    string iMainRecNo = context.Request.Params["iMainRecNo"].ToString();
                    try
                    {
                        sqlHelper sqlhelper = new sqlHelper(connStr);
                        sqlhelper.commExec("delete from bscChildDynColumn where iMainRecNo='" + iMainRecNo + "'");
                        context.Response.Write("1");
                    }
                    catch (Exception ex) {
                        context.Response.Write(ex.Message);
                    }
                }
            }
            else if (from == null)
            {
                string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
                if (otype == "getFormField")
                {
                    string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
                    DataTable tableForm = new SqlQueryExec("select sShowSql from bscDataBill where iFormID=" + iformid+" order by iFormID asc").SqlQueryComm(connStr);
                    if (tableForm.Rows.Count > 0)
                    {
                        DataTable tableFields = new SqlQueryExec(tableForm.Rows[0]["sShowSql"].ToString().Replace("{condition}", "1<>1").Replace(",{columns}", "").Replace("{fields}", "*")).SqlQueryComm(connStr);
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
                        context.Response.Write("error:表单不存在，请检查所选择表单是否为目录！");
                    }
                }
                else if (otype == "getLookUpName")
                {
                    DataTable tableLookUpName = new SqlQueryExec("select sOrgionName,sControlName,sReturnField,sDisplayField,iWindow from bscInitLookup order by sOrgionName asc").SqlQueryComm(connStr);
                    if (tableLookUpName.Rows.Count > 0)
                    {
                        context.Response.Write(JsonHelper.ToJsonNoRows(tableLookUpName));
                    }
                    else
                    {
                        context.Response.Write("error:未定义任务lookUp！");
                    }
                }
                else if (otype == "getLookUpField")
                {
                    string lookUpName = context.Request.Params["lookUpName"] == null ? "" : context.Request.Params["lookUpName"].ToString();
                    DataTable tableLookUp = new SqlQueryExec("select sSQL from bscInitLookup where sOrgionName='" + lookUpName + "'").SqlQueryComm(connStr);
                    if (tableLookUp.Rows.Count > 0)
                    {
                        DataTable tableLookUpFields = new SqlQueryExec(tableLookUp.Rows[0]["sSQL"].ToString().Replace("{condition}", "1<>1")).SqlQueryComm(connStr);
                        if (tableLookUpFields.Columns.Count > 0)
                        {
                            StringBuilder fieldStr = new StringBuilder();
                            fieldStr.Append("{\"total\":\"" + tableLookUpFields.Columns.Count.ToString() + "\",\"rows\":[");
                            for (int i = 0; i < tableLookUpFields.Columns.Count; i++)
                            {
                                fieldStr.Append("{\"field\":\"" + tableLookUpFields.Columns[i].ColumnName + "\"},");
                            }
                            fieldStr.Remove(fieldStr.Length - 1, 1);
                            fieldStr.Append("]}");
                            context.Response.Write(fieldStr);
                        }
                        else
                        {
                            context.Response.Write("error:此lookUp不存在列！");
                        }
                    }
                }
                else if (otype == "getFormID")
                {
                    DataTable tableFormID = new SqlQueryExec("select iFormID,sMenuName as sBillType,iMenuID from FSysMainMenu where iFormID is not null order by iFormID asc").SqlQueryComm(connStr);
                    if (tableFormID.Rows.Count > 0)
                    {
                        context.Response.Write(JsonHelper.ToJsonNoRows(tableFormID));
                    }
                    else
                    {
                        context.Response.Write("error:未定义任何Form！");
                    }
                }                
            }
            else if (from == "tablePb")
            {
                StringBuilder sSql = new StringBuilder();
                string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                string sPbRecNos = context.Request.Params["sPbRecNos"] == null ? "" : context.Request.Params["sPbRecNos"].ToString();
                sSql.Append("update bscChildTables set sPbRecNos='" + sPbRecNos + "' where iRecNo=" + iRecNo);
                //sSql.Append(" select 1 as r");
                try
                {
                    SqlQueryExec sqe = new SqlQueryExec(sSql.ToString());
                    sqe.SqlQueryComm(connStr);
                    context.Response.Write("1");
                }
                catch (Exception ex)
                {
                    context.Response.Write("error:" + ex.Message);
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