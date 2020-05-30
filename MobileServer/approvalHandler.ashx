<%@ WebHandler Language="C#" Class="approvalHandler" %>

using System;
using System.Web;
using sysBaseApproval;
using sysBaseRequestResult;
using Newtonsoft.Json;
public class approvalHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        approval apl = new approval(sConnStr);
        if (otype == "submit")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            bool isPush = context.Request.Params["isPush"] == null ? false : context.Request.Params["isPush"].ToString() == "1" ? true : false;
            string pushGUID = context.Request.Params["pushGUID"] == null ? "" : context.Request.Params["pushGUID"].ToString();
            //string userid = userid;
            requestResult result = apl.procSubmit(iformid, key, userid, isPush, pushGUID);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "isNeedPush")
        {
            string iRecNo=context.Request.Params["iRecNo"]==null?"":context.Request.Params["iRecNo"].ToString();
            requestResult result = apl.procIsNeedPust(iRecNo);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "isNeedPushWhenSubmit")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            //string userid = userid;
            requestResult result = apl.procIsNeedPustWhenSubmit(iformid, key, userid, 1);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "check")
        {
            string iRecNo=context.Request.Params["iRecNo"]==null?"":context.Request.Params["iRecNo"].ToString();
            string message=context.Request.Params["message"]==null?"":context.Request.Params["message"].ToString();
            bool needPush = context.Request.Params["needPush"] == null ? false : context.Request.Params["needPush"].ToString().ToLower() == "true" ? true : false;
            requestResult result = apl.procDoCheck(iRecNo, message, userid, needPush);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "back")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procBack(iRecNo, message, userid);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "cancelSubmit")
        {
            string ifomrid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procSubmitCancel(ifomrid, key, userid);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            
        }
        else if (otype == "cancelCheck")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheck(iRecNo, message, userid);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //撤销审批新
        else if (otype == "cancelCheck1")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procCheckCancel(iformid,key,"", userid,false);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "formStatus")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procFormStatus(iformid, key);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "abandon")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procAbandon(iRecNo, message, userid);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "checkCancelAsk")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCheckCancelAsk(iformid, key, userid,message);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "checkCancelFromFirst")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheckFromFirst(iRecNo, message, userid,false);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "checkCancelAskDisagree")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheckFromFirst(iRecNo, message, userid, true);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}