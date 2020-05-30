<%@ WebHandler Language="C#" Class="DataInterfaceHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Data;
public class DataInterfaceHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        try
        {
            if (otype == "table")
            {
                SqlQueryObject sqo = JsonConvert.DeserializeObject<SqlQueryObject>(context.Request.Params["sqlqueryobj"].ToString());
                DataTable table = sqo.SqlQueryExecNoCount(sConnStr);
                requestTablesResult result = new requestTablesResult();
                result.success = true;
                result.tables.Add(table);
                //JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            }
            else if (otype == "store")
            {
                SqlStoreProcQuery sspq = JsonConvert.DeserializeObject<SqlStoreProcQuery>(context.Request.Params["sqlqueryobj"].ToString());
                //string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                DataTable table = sspq.SqlStoreProcExec(sConnStr);
                
                if (context.Request.Params["returnall"] == null || context.Request.Params["returnall"].ToString() != "1")
                {
                    requestResult result = new requestResult();
                    result.success = true;
                    result.message = table.Rows[0][0].ToString();
                    JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                    context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result, Formatting.Indented, jSetting) + ")");
                }
                else if (context.Request.Params["returnall"].ToString() == "1")
                {
                    requestTablesResult result = new requestTablesResult();
                    result.success = true;
                    result.tables.Add(table);
                    JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                    context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result, Formatting.Indented, jSetting) + ")");
                }
            }
        }
        catch (Exception ex)
        {
            requestResult result = new requestResult();
            result.success = false;
            result.message = ex.Message;
            JsonSerializerSettings jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result, Formatting.Indented, jSetting) + ")");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}