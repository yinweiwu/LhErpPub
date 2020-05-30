<%@ WebHandler Language="C#" Class="childTableExplain" %>

using System;
using System.Web;
using System.Data;
using System.Text;
using sysBaseExplain;
using sysBaseRequestResult;
using Newtonsoft.Json;
public class childTableExplain : IHttpHandler
{
    //解析formid的子表
    public void ProcessRequest(HttpContext context)
    {
        //iformid
        string iformid = context.Request.Params["iformid"] == null ? "" : context.Request.Params["iformid"].ToString();
        //imenuid
        //string imenuid = context.Request.Params["imenuid"] == null ? "" : context.Request.Params["imenuid"].ToString();
        //主键值
        string key = context.Request.Params["key"] == null ? "" : context.Request.Params["key"].ToString();
        //usetype
        string usetype = context.Request.Params["usetype"] == null ? "" : context.Request.Params["usetype"].ToString();
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        tableExplain tableExp = new tableExplain(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
        if (otype == "child")
        {
            //解析哪些子表,形如"tableid1=testd1,tableid2=testd2",前面是id,后面是子表表名
            string tables = context.Request.Params["tables"] == null ? "" : context.Request.Params["tables"].ToString();
            requestResult result = tableExp.doExplain(iformid, tables, key, usetype, HttpContext.Current.User.Identity.Name);
            if (result.success)
            {
                context.Response.Write(result.result);
            }
            else
            {
                context.Response.Write("error:" + result.message);
            }
        }
        else if (otype == "main")
        { 
            //解析主表
            requestResult result = tableExp.doMainExplain(iformid, key, usetype);
            if (result.success)
            {
                context.Response.Write(result.result);
            }
            else
            {
                context.Response.Write("error:" + result.message);
            }
        }
        else if (otype == "getDynColumns")
        {
            string value = context.Request.Params["value"] == null ? "" : context.Request.Params["value"].ToString();
            //string iformid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string tableName = context.Request.Params["tableName"] == null ? "" : context.Request.Params["tableName"].ToString();
            requestTablesResult result = tableExp.GetDynColumns(iformid, tableName, value, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getCopyData")
        {
            string copyKey = context.Request.Params["copyKey"] == null ? "" : context.Request.Params["copyKey"].ToString();
            requestTablesResult result = tableExp.GetFormCopyData(iformid, copyKey);
            var jSetting = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
            context.Response.Write(JsonConvert.SerializeObject(result, jSetting));
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