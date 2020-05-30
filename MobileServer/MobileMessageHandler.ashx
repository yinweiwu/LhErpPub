<%@ WebHandler Language="C#" Class="MobileMessageHandler" %>

using System;
using System.Web;
using sysBaseMessage.WeiXin;
using sysBaseDAL.common;
using System.Data;
using Newtonsoft.Json;
using sysBaseRequestResult;

public class MobileMessageHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "SendTempletMessage")
        {
            sqlHelper sqlhelper = new sqlHelper(sConnStr);
            requestResult result = new requestResult();
            try
            {
                DataTable table = sqlhelper.getTableData("select top 1 sWeiXinAppID,sWeiXinSecret from SysParam");
                if (table.Rows.Count > 0)
                {
                    string sAppID = table.Rows[0]["sWeiXinAppID"].ToString();
                    string sSecret = table.Rows[0]["sWeiXinSecret"].ToString();
                    result.message += sAppID + sSecret + " ";
                    WeiXinHelper wxh = new WeiXinHelper(sAppID, sSecret);
                    result.message += "2";
                    string templet = context.Request.Params["templet"] == null ? "" : context.Request.Params["templet"].ToString();
                    string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
                    string openid = context.Request.Params["openid"] == null ? "" : context.Request.Params["openid"].ToString();
                    result.message += "3";
                    string openUrl = context.Request.Params["openUrl"] == null ? "" : context.Request.Params["openUrl"].ToString();
                    try
                    {
                        MessageContent mc = JsonConvert.DeserializeObject<MessageContent>(message);
                        if (openUrl != "")
                        {
                            wxh.Url = openUrl;
                        }                        
                        wxh.Templet = templet;
                        wxh.SendTempletMessage(openid, mc);                        
                        result.success = true;
                        result.message = wxh.Url;
                        context.Response.Write(JsonConvert.SerializeObject(result));
                    }
                    catch (Exception ex)
                    {
                        result.success = false;
                        result.message = "1"+ex.Message;
                        context.Response.Write(JsonConvert.SerializeObject(result));
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message += ex.Message;
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
        }        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}