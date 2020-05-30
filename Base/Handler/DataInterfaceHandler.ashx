<%@ WebHandler Language="C#" Class="DataInterfaceHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Data;
public class DataInterfaceHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        try
        {
            if (otype == "table")
            {
                SqlQueryObject sqo = JsonConvert.DeserializeObject<SqlQueryObject>(context.Request.Params["sqlqueryobj"].ToString());
                DataTable table = sqo.SqlQueryExecNoCount(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
                requestTablesResult result = new requestTablesResult();
                result.success = true;
                result.tables.Add(table);
                //JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
            else if (otype == "store")
            {
                SqlStoreProcQuery sspq = JsonConvert.DeserializeObject<SqlStoreProcQuery>(context.Request.Params["sqlqueryobj"].ToString());
                string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                DataTable table = sspq.SqlStoreProcExec(connstr);

                if (context.Request.Params["returnall"] == null || context.Request.Params["returnall"].ToString() != "1")
                {
                    requestResult result = new requestResult();
                    result.success = true;
                    result.message = table.Rows[0][0].ToString();
                    JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                    context.Response.Write(JsonConvert.SerializeObject(result, Formatting.Indented, jSetting));
                }
                else if (context.Request.Params["returnall"].ToString() == "1")
                {
                    requestTablesResult result = new requestTablesResult();
                    result.success = true;
                    result.tables.Add(table);
                    JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                    context.Response.Write(JsonConvert.SerializeObject(result, Formatting.Indented, jSetting));
                }
            }
            else if (otype == "storeDs")
            {
                SqlStoreProcQuery sspq = JsonConvert.DeserializeObject<SqlStoreProcQuery>(context.Request.Params["sqlqueryobj"].ToString());
                string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                DataSet ds = sspq.SqlStoreProcExecDs(connstr);
                requestTablesResult result = new requestTablesResult();
                result.success = true;
                foreach (DataTable dt in ds.Tables)
                {
                    result.tables.Add(dt);
                }                
                JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                context.Response.Write(JsonConvert.SerializeObject(result, Formatting.Indented, jSetting));
            }
            else if (otype == "sysOpreateLog")
            {
                string opreateType = context.Request.Params["opreateType"] == null ? "" : context.Request.Params["opreateType"].ToString();
                string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
                string iBillRecNo = context.Request.Params["iBillRecNo"] == null ? "" : context.Request.Params["iBillRecNo"].ToString();
                string sBillType = context.Request.Params["sBillType"] == null ? "" : context.Request.Params["sBillType"].ToString();
                string sDbConn= System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                sysBaseBll.SysOpreateLog sol = new sysBaseBll.SysOpreateLog(sDbConn);
                sol.addLog(HttpContext.Current.User.Identity.Name, "", iformid, iBillRecNo, sBillType, "", opreateType);
            }
        }
        catch (Exception ex)
        {
            requestResult result = new requestResult();
            result.success = false;
            result.message = ex.Message;
            JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
            context.Response.Write(JsonConvert.SerializeObject(result, Formatting.Indented, jSetting));
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