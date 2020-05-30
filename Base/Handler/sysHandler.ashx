<%@ WebHandler Language="C#" Class="sysHandler" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using sysBaseDAL.common;
using Newtonsoft.Json;
using sysBaseRequestResult;

public class sysHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";        
        string otype = context.Request.Params["otype"].ToString();
        if (otype == "getmainsqlfield")
        {
            string iformid = context.Request.Params["iformid"].ToString();
            string sqlcomm = "select sShowSql,iQuery,iStore,sStoreParms from bscDataBill where iFormID=" + iformid;
            //sqlcomm = "select * from (" + sqlcomm + ") as A where 1=0";
            SqlQueryExec sqe = new SqlQueryExec(sqlcomm);
            try
            {
                DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                if (table.Rows.Count > 0)
                {
                    if (table.Rows[0]["sShowSql"].ToString().Length > 0)
                    {
                        string sqlcomm2 = "";
                        if (table.Rows[0]["iQuery"].ToString() == "1")
                        {
                            if (table.Rows[0]["iStore"].ToString() == "" || table.Rows[0]["iStore"].ToString() == "0")
                            {
                                //sqlcomm2 = "select * from (" + table.Rows[0]["sShowSql"].ToString().Replace("{userid}", "master").Replace("{condition}", "1=1").Replace("{fields}", "*") + ") as A where 1=0";
                                sqlcomm2 = table.Rows[0]["sShowSql"].ToString().Replace("{userid}", "__").Replace("{condition}", "1<>1").Replace("{fields}", "*").Replace(",{columns}", "");
                            }
                            else
                            {
                                string comm = table.Rows[0]["sShowSql"].ToString().Replace("{userid}", "master").Replace("{condition}", "1=1").Replace(",{columns}", "");
                                string[] parmvaluearr = table.Rows[0]["sStoreParms"].ToString().Replace("{userid}", "master").Split('$');
                                while (comm.IndexOf("{") > -1)
                                {
                                    int index = comm.IndexOf("{");
                                    int lindex = comm.IndexOf("}");
                                    string parm = comm.Substring(index + 1, lindex - index - 1);
                                    int flag = 0;
                                    for (int pi = 0; pi < parmvaluearr.Length; pi++)
                                    {
                                        if (parmvaluearr[pi].Split('=')[0] == parm)
                                        {
                                            comm = comm.Replace("{" + parm + "}", parmvaluearr[pi].Split('=')[1]);
                                            flag = 1;
                                            break;
                                        }
                                    }
                                    if (flag == 0)
                                    {
                                        context.Response.Write("存储过程中存在未定义默认值的参数!");
                                        return;
                                    }
                                }
                                sqlcomm2 = "exec " + comm;
                            }
                        }
                        else
                        {
                            sqlcomm2 = "select * from (" + table.Rows[0]["sShowSql"].ToString().Replace("{userid}", "master").Replace("{condition}", "1=1").Replace("{fields}", "*").Replace(",{columns}", "") + ") as A where 1=0";
                        }
                        sqe.Commtext = sqlcomm2;
                        DataTable tablefields = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                        if (tablefields.Columns.Count > 0)
                        {
                            StringBuilder sbstring = new StringBuilder();
                            sbstring.Append("[");
                            for (int i = 0; i < tablefields.Columns.Count; i++)
                            {
                                sbstring.Append("{ \"Name\":\"" + tablefields.Columns[i].ColumnName + "\" },");
                            }
                            if (sbstring.Length > 1)
                            {
                                sbstring.Remove(sbstring.Length - 1, 1);
                            }
                            sbstring.Append("]");
                            context.Response.Write(sbstring.ToString());
                        }
                    }
                    else
                    {
                        context.Response.Write("[]");
                    }
                }
                else
                {
                    context.Response.Write("未定义主表SQL语句！");
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (otype == "getdetailsqlfield")
        {
            string iformid = context.Request.Params["iformid"].ToString();
            string sqlcomm = "select sDetailSql from bscDataBill where iFormID=" + iformid;
            SqlQueryExec sqe = new SqlQueryExec(sqlcomm);
            try
            {
                DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                if (table.Rows.Count > 0)
                {
                    //string tablename = "select * from (" + table.Rows[0]["sShowSql"].ToString() + ") where 1=0";
                    if (table.Rows[0]["sDetailSql"].ToString().Length > 0)
                    {
                        string sqlcomm2 = "select * from (" + table.Rows[0]["sDetailSql"].ToString().Replace("{userid}", "master") + ") as A where 1=0";
                        sqe.Commtext = sqlcomm2;
                        DataTable tablefields = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                        if (tablefields.Columns.Count > 0)
                        {
                            StringBuilder sbstring = new StringBuilder();
                            sbstring.Append("[");
                            for (int i = 0; i < tablefields.Columns.Count; i++)
                            {
                                sbstring.Append("{ \"Name\":\"" + tablefields.Columns[i].ColumnName + "\" },");
                            }
                            if (sbstring.Length > 1)
                            {
                                sbstring.Remove(sbstring.Length - 1, 1);
                            }
                            sbstring.Append("]");
                            context.Response.Write(sbstring.ToString());
                        }
                    }
                    else
                    {
                        context.Response.Write("[]");
                    }
                }
                else
                {
                    context.Response.Write("未定义子表SQL语句！");
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (otype == "columnsDefineCopy")
        {
            string toformid = context.Request.Params["toformid"].ToString();
            string fromformid = context.Request.Params["fromformid"].ToString();
            SqlStoreProcQuery ssp = new SqlStoreProcQuery();
            ssp.StoreProName = "Yww_FormDefineCopy";
            ssp.ParamsStr = fromformid + "," + toformid + ",3,'" + HttpContext.Current.User.Identity.Name + "'";
            DataTable table = ssp.SqlStoreProcQueryExce(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString, "");
            context.Response.Write(table.Rows[0][0].ToString());
        }
        else if (otype == "getFormListColumnsDefine")
        {
            string connStr=System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            sqlHelper sqlhelper = new sqlHelper(connStr);
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string comm = "select a.iMainRecNo,a.[GUID],a.sFieldsdisplayName,a.sFieldsType,a.iWidth,a.iHide,a.iShowOrder,isnull(a.sAlign,'center') sAlign,a.iSort,a.iSummryDigit,a.sSummary,a.isChild from bscDataQueryD as a,bscDataQueryM as b where a.iMainRecNo=b.iRecNo and b.iFormID='" + iformid + "' order by isnull(a.isChild,0) asc,isnull(a.iHide,0) asc,iShowOrder asc ";
            requestTablesResult result = new requestTablesResult();
            try
            {
                DataTable tableColumns = sqlhelper.getTableData(comm);
                result.success = true;
                result.tables.Add(tableColumns);                
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getChildColumnsDefine")
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            sqlHelper sqlhelper = new sqlHelper(connStr);
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string tableName = context.Request.Params["tableName"] == null ? "" : context.Request.Params["tableName"].ToString();
            string comm = "select a.iRecNo,a.iMainRecNo,a.sTitle,a.sType,a.iHidden,a.fWidth,a.iRequired,a.iDigit,a.sDefaultValue,a.iSerial,a.iSummryDigit from bscChildTablesDColumns as a,bscChildTables as b where a.iMainRecNo=b.iRecNo and b.iFormID='" + iformid + "' and sTableName='" + tableName + "' order by isnull(a.iHidden,0) asc,a.iSerial asc ";
            requestTablesResult result = new requestTablesResult();
            try
            {
                DataTable tableColumns = sqlhelper.getTableData(comm);
                result.success = true;
                result.tables.Add(tableColumns);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getSysConfigFile")
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            sqlHelper sqlhelper = new sqlHelper(connStr);
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            StringBuilder strB = new StringBuilder(4000);
            strB.AppendFormat("select * from BscDataBill where iFormID={0} ", iformid);
            strB.AppendFormat("select * from BscDataBillD where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscDataBillDForm where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscDataBillDUser where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscDataSearch where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscDataQueryM where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscDataQueryD where iMainRecNo=(select iRecNo from bscDataQueryM where iFormID={0}) ", iformid);
            strB.AppendFormat("select * from bscDataQueryDAppStyle where iMainRecNo=(select iRecNo from bscDataQueryM where iFormID={0}) ", iformid);
            strB.AppendFormat("select * from BscDataInit where iFormID={0} ", iformid);
            strB.AppendFormat("select * from pbReportData where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscMainTableDefault where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscMainTableEvent where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscMainTableExpression where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscMainTableLookUp where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscMainTableRequired where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscChildTables where iFormID={0} ", iformid);
            strB.AppendFormat("select * from bscChildTablesDColumns where iMainRecNo=(select iRecNo from bscChildTables where iFormID={0}) ", iformid);
            strB.AppendFormat("select * from bscChildTablesDEvent where iMainRecNo=(select iRecNo from bscChildTables where iFormID={0}) ", iformid);
            strB.AppendFormat("select * from bscChildTablesDImportBtn where iMainRecNo=(select iRecNo from bscChildTables where iFormID={0}) ", iformid);
            strB.AppendFormat("select * from bscChildTablesDLookUp where iMainRecNo=(select iRecNo from bscChildTables where iFormID={0}) ", iformid);
            try
            {
                DataSet ds = sqlhelper.getTablesData(strB.ToString());
                StringBuilder strObj = new StringBuilder();
                strObj.AppendFormat("{\"iformid:\":\"{0}\",\"config\":[", iformid);
                for (int i = 0; i < ds.Tables.Count; i++)
                {
                    DataTable table = ds.Tables[i];
                    strObj.AppendFormat("{\"tablename\":\"{0}\",columns:\"", table.TableName);
                    for (int j = 0; j < table.Columns.Count; j++)
                    {
                        strObj.AppendFormat("{0},", table.Columns[j].ColumnName);
                    }
                    if (table.Columns.Count > 0)
                    {
                        strObj.Remove(strObj.Length - 1, 1);
                    }
                    strObj.Append("\",\"data\":[");
                    for (int j = 0; j < table.Rows.Count; j++)
                    {
                        string rowStr = JsonConvert.SerializeObject(table.Rows[j]);
                        strObj.AppendFormat("{0},", rowStr);
                    }
                    if (table.Rows.Count > 0)
                    {
                        strObj.Remove(strObj.Length - 1, 1);
                    }
                    strObj.Append("]},");
                }
                if (ds.Tables.Count > 0)
                {
                    strObj.Remove(strObj.Length - 1, 1);
                }
                strObj.Append("]}");
                //生产txt文件
            }
            catch (Exception ex)
            {
                
            }
            
            
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