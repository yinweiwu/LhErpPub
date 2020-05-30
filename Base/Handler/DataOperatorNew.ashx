<%@ WebHandler Language="C#" Class="DataBuilderNew" %>

using System;
using System.Web;
using System.Text.RegularExpressions;
using System.Data;
using System.Collections.Generic;
using Newtonsoft.Json;
public class DataBuilderNew : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string mainquery = context.Request.Params["mainquery"].ToString();
        string childrenstr = context.Request.Params["children"].ToString();
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        try
        {
            List<ChildObj> children = JsonConvert.DeserializeObject<List<ChildObj>>(childrenstr);
            SqlOperatorObject soo = JsonConvert.DeserializeObject<SqlOperatorObject>(mainquery);
            string conn = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            context.Response.ContentType = "text/plain";
            if (otype == "")
            {
                context.Response.Write(soo.SqlFormOperatorWithGrandsonDic(children, conn));
            }
            else
            {
                context.Response.Write(soo.SqlFormOperatorWithGrandsonDic1(children, conn));
            }
            //操作日志
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string sBillType = context.Request.Params["sBillType"] == null ? "" : context.Request.Params["sBillType"].ToString();
            sysBaseBll.SysOpreateLog sol = new sysBaseBll.SysOpreateLog(conn);
            sol.addLog(HttpContext.Current.User.Identity.Name, "", iFormID, soo.FieldKeysValues, sBillType, "", (soo.Operatortype == "add" ? "增加" : "修改"));
        }
        catch (Exception ex)
        {
            context.Response.Write("error:" + ex.Message);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}