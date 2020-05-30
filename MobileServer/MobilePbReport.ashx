<%@ WebHandler Language="C#" Class="MobilePbReport" %>

using System;
using System.Web;
using sysBaseRequestResult;
using System.Data;
using sysBaseBll;
using Newtonsoft.Json;
public class MobilePbReport : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "getPbDefine")
        {
            PbLodop pbld = new PbLodop(sConnStr);
            requestTablesResult result = new requestTablesResult();
            try
            {
                DataTable tablePb = pbld.GetPbDefined(HttpContext.Current);
                result.success = true;
                result.tables.Add(tablePb);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getPbDataSource")
        {
            requestDataSetResult result = new requestDataSetResult();
            PbLodop pbld = new PbLodop(sConnStr);
            try
            {
                DataTable tablePb = pbld.GetPbDefined(HttpContext.Current);
                DataSet ds = pbld.GetAllDataSource(HttpContext.Current, tablePb);
                result.success = true;
                result.dataset = ds;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
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