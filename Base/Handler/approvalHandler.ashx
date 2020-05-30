<%@ WebHandler Language="C#" Class="approvalHandler" %>

using System;
using System.Web;
using sysBaseApproval;
using sysBaseRequestResult;
public class approvalHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        approval apl = new approval(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
        if (otype == "submit")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            bool isPush = context.Request.Params["isPush"] == null ? false : context.Request.Params["isPush"].ToString() == "1" ? true : false;
            string pushGUID = context.Request.Params["pushGUID"] == null ? "" : context.Request.Params["pushGUID"].ToString();
            string userid = HttpContext.Current.User.Identity.Name;
            requestResult result = apl.procSubmit(iformid, key, userid, isPush, pushGUID);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "isNeedPush")
        {
            string iRecNo=context.Request.Params["iRecNo"]==null?"":context.Request.Params["iRecNo"].ToString();
            requestResult result = apl.procIsNeedPust(iRecNo);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "isNeedPushWhenSubmit")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            string userid = HttpContext.Current.User.Identity.Name;
            requestResult result = apl.procIsNeedPustWhenSubmit(iformid, key, userid, 1);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "check")
        {
            string iRecNo=context.Request.Params["iRecNo"]==null?"":context.Request.Params["iRecNo"].ToString();
            string message=context.Request.Params["message"]==null?"":context.Request.Params["message"].ToString();
            bool needPush = context.Request.Params["needPush"] == null ? false : context.Request.Params["needPush"].ToString().ToLower() == "true" ? true : false;
            requestResult result = apl.procDoCheck(iRecNo, message, HttpContext.Current.User.Identity.Name, needPush);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "back")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procBack(iRecNo, message, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "cancelSubmit")
        {
            string ifomrid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procSubmitCancel(ifomrid, key, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonHelper.JsonSerialize(result));
            
        }
        else if (otype == "cancelCheck")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheck(iRecNo, message, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        //撤销审批新
        else if (otype == "cancelCheck1")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procCheckCancel(iformid,key,"", HttpContext.Current.User.Identity.Name,false);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "formStatus")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            requestResult result = apl.procFormStatus(iformid, key);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "abandon")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procAbandon(iRecNo, message, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "checkCancelAsk")
        {
            string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
            string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCheckCancelAsk(iformid, key, HttpContext.Current.User.Identity.Name,message);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "checkCancelFromFirst")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheckFromFirst(iRecNo, message, HttpContext.Current.User.Identity.Name,false);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
        else if (otype == "checkCancelAskDisagree")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            string message = context.Request.Params["message"] == null ? "" : context.Request.Params["message"].ToString();
            requestResult result = apl.procCancelCheckFromFirst(iRecNo, message, HttpContext.Current.User.Identity.Name, true);
            context.Response.Write(JsonHelper.JsonSerialize(result));
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}