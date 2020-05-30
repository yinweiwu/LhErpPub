<%@ WebHandler Language="C#" Class="DataOperator" %>

using System;
using System.Web;
using System.Text.RegularExpressions;
using System.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Text;
using System.Data.SqlClient;
public class DataOperator : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string from = context.Request.Params["from"].ToString();
        if (from == "getAllTableName")
        {
            SqlQueryExec sqe = new SqlQueryExec("Select name From Sysobjects where type='u'");
            DataTable table = sqe.SqlQueryComm(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            context.Response.Write(JsonHelper.ToJsonNoRows(table));
        }
        if (from == "sysbillnocheck")
        {
            try
            {
                //string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
                //string childrenstr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["children"].ToString());

                string mainquery = context.Request.Params["mainquery"].ToString();
                string childrenstr = context.Request.Params["children"].ToString();

                List<ChildObj> children = JsonConvert.DeserializeObject<List<ChildObj>>(childrenstr);
                SqlOperatorObject soo = JsonConvert.DeserializeObject<SqlOperatorObject>(mainquery);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlFormOperatorWithGrandsonDic(children, conn));

            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysquerywincnfig")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string childrenstr = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["children"].ToString());
            try
            {
                object childrenobj = JsonHelper.JsonDeserializeObject(childrenstr);
                List<ChildObj> children = SiteBll.TranformObjToChildObj(childrenobj);
                SqlOperatorObject soo = JsonHelper.JsonDeserialize<SqlOperatorObject>(mainquery);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlFormOperatorWithGrandson(children, conn));
            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }


            /*string childrenTablename = context.Request.Params["childrenTablename"].ToString();
            string childrenFieldKey = context.Request.Params["childrenFieldKey"].ToString();
            string childrendata = context.Request.Params["childrenDataCallback"].ToString();
            string childrenDataCallback = childrendata;
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string[] tablenamechilds = childrenTablename.Split(',');
            string[] fieldkeychilds = childrenFieldKey.Split('|');
            //char[] splitor = { '[', '|', ']' };
            string[] childrenDataArr = Regex.Split(childrenDataCallback, "[<|>]", RegexOptions.IgnoreCase);
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                List<DataTable> tablechilds = new List<DataTable>();
                for (int i = 0; i < childrenDataArr.Length; i++)
                {
                    if (childrenDataArr[i].Length > 0)
                    {
                        DataTable table = JsonHelper.ToDataTable(childrenDataArr[i]);
                        tablechilds.Add(table);
                    }
                }
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysQueryWinOperate(tablenamechilds, fieldkeychilds, tablechilds, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }*/
        }
        else if (from == "sysquerycnditn")
        {
            string mainquery = context.Request.Params["mainquery"].ToString();
            string detaildata = context.Request.Params["children"].ToString();

            //List<ChildObj> children = JsonConvert.DeserializeObject<List<ChildObj>>(childrenstr);
            //SqlOperatorObject soo = JsonConvert.DeserializeObject<SqlOperatorObject>(mainquery);
            //string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            //context.Response.ContentType = "text/plain";
            //context.Response.Write(soo.SqlFormOperatorWithGrandsonDic(children, conn));


            //string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            //string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                //DataTable table = JsonHelper.ToDataTable(detaildata);
                DataTable table = JsonConvert.DeserializeObject<DataTable>(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysQueryCnditnOperate(table, conn));
            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysinitvalueset")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            string iflag = context.Request.Params["iflag"] == null ? "0" : context.Request.Params["iflag"].ToString();
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysInitValueSetOperate(table, conn, iflag));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysmustvalueset")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysiMustValueSetOperate(table, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysinitlookupset")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysLookUpSetOperate(table, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysinitbgcolorset")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysBgColorSetOperate(table, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysprintdataset")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysPrintDataSetOperate(table, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysmainmenuright")
        {
            string mainquery = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["mainquery"].ToString());
            string detaildata = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["detaildata"].ToString());
            try
            {
                SqlSysOperate soo = JsonHelper.JsonDeserialize<SqlSysOperate>(mainquery);
                DataTable table = JsonHelper.ToDataTable(detaildata);
                string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                context.Response.ContentType = "text/plain";
                context.Response.Write(soo.SqlSysMainMenuRight(table, conn));
            }

            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysBscDataBillDWeixinDAddOrModify")
        {
            string dataStr = context.Request.Params["formData"] == null ? "" : context.Request.Params["formData"].ToString();
            string useType = context.Request.Params["useType"] == null ? "" : context.Request.Params["useType"].ToString();
            try
            {
                Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(dataStr);
                StringBuilder sbComm = new StringBuilder(500);
                if (useType.Equals("add"))
                {
                    sbComm.Append("insert into bscDataBillDWeixinD (");
                    foreach (string item in dic.Keys)
                    {
                        sbComm.AppendFormat("{0},", item);
                    }
                    if (dic.Keys.Count > 0)
                    {
                        sbComm.Remove(sbComm.Length - 1, 1);
                    }
                    sbComm.Append(") values (");
                    foreach (string item in dic.Keys)
                    {
                        string value = string.IsNullOrEmpty(dic[item]) ? "NULL" : "'" + dic[item] + "'";
                        sbComm.AppendFormat("{0},", value);
                    }
                    if (dic.Keys.Count > 0)
                    {
                        sbComm.Remove(sbComm.Length - 1, 1);
                    }
                    sbComm.Append(") ");
                }
                else
                {
                    sbComm.Append("update bscDataBillDWeixinD set ");
                    foreach (string item in dic.Keys)
                    {
                        if (!item.Equals("iRecNo") && !item.Equals("sGUID"))
                        {
                            string value = string.IsNullOrEmpty(dic[item]) ? "NULL" : "'" + dic[item] + "'";
                            sbComm.AppendFormat("{0}={1},", item, value);
                        }
                    }
                    if (dic.Keys.Count > 0)
                    {
                        sbComm.Remove(sbComm.Length - 1, 1);
                    }
                    sbComm.AppendFormat(" where iRecNo={0}", dic["iRecNo"]);
                }
                string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(sConnStr))
                {
                    using (SqlCommand comm = new SqlCommand())
                    {
                        comm.CommandType=CommandType.Text;
                        comm.CommandText=sbComm.ToString();
                        comm.Connection = conn;
                        comm.Connection.Open();
                        comm.ExecuteNonQuery();
                    }
                }
                context.Response.Write("1");
            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
        }
        else if (from == "sysBscDataBillDWeixinDDelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string sConnStr=System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(sConnStr))
                {
                    using (SqlCommand comm = new SqlCommand())
                    {
                        comm.CommandText="delete from bscDataBillDWeixinD where iRecNo= "+iRecNo;
                        comm.Connection = conn;
                        comm.Connection.Open();
                        comm.ExecuteNonQuery();
                    }
                }
                context.Response.Write("1");
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