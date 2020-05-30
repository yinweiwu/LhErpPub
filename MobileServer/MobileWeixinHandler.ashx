<%@ WebHandler Language="C#" Class="MobileWeixinHandler" %>

using System;
using System.Web;
using System.Data;
using sysBaseBll;
using Newtonsoft.Json;
using sysBaseDAL.common;
public class MobileWeixinHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "refreshWeixinOpenID")
        {
            sysBaseRequestResult.requestResult result = new sysBaseRequestResult.requestResult();
            try
            {
                sqlHelper sqlhelper = new sqlHelper(sConnStr);
                string appidSql = "select top 1 sWeiXinAppID,sWeiXinSecret from SysParam ";
                DataTable table = sqlhelper.getTableData(appidSql);
                sysBaseMessage.WeiXin.WeiXinHelper wxh = new sysBaseMessage.WeiXin.WeiXinHelper(table.Rows[0]["sWeiXinAppID"].ToString(), table.Rows[0]["sWeiXinSecret"].ToString(), sConnStr);
                bool success = wxh.UpdateAllUserInfoOnline();
                result.success = success;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}