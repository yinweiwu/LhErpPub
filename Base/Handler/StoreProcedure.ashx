<%@ WebHandler Language="C#" Class="StoreProcedure" %>

using System;
using System.Web;
using System.Data;
public class StoreProcedure : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string sqlparms = Microsoft.JScript.GlobalObject.decodeURIComponent(context.Request.Params["sqlqueryobj"].ToString());
        try
        {
            SqlStoreProcQuery sspq = JsonHelper.JsonDeserialize<SqlStoreProcQuery>(sqlparms);
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            DataTable table = sspq.SqlStoreProcExec(connstr);
            string result = "";
            if (context.Request.Params["returnall"] == null || context.Request.Params["returnall"].ToString() != "1")
            {
                result = table.Rows[0][0].ToString();
                result = result.Replace("\\n", "<br />");
            }
            else if (context.Request.Params["returnall"].ToString() == "1")
            {

                result = "{Rows:" + JsonHelper.ToJsonNoRows(table) + ",Total:" + table.Rows.Count + "}";
            }
            context.Response.Write(result);
        }
        catch (Exception ex)
        {
            context.Response.Write(ex.Message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}