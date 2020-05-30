<%@ WebHandler Language="C#" Class="FormListHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using Newtonsoft.Json;
using sysBaseExplain;
using System.Data;
using sysBaseChartExplain;
public class FormListHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        if (otype == "GetFormListData")
        {
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestTablesResult result = fl.GetFormListData(context, HttpContext.Current.User.Identity.Name);
            string isQuery = context.Request.Params["isQuery"] == null ? "0" : context.Request.Params["isQuery"].ToString();
            string isTreeList=context.Request.Params["isTreeList"] == null ? "0" : context.Request.Params["isTreeList"].ToString();
            if (isQuery == "1")
            {
                if (isTreeList == "1")
                {
                    DataTable tableData = result.tables[0];
                    string strData = "{\"rows\":" + JsonConvert.SerializeObject(tableData) + ",\"total\":\"" + tableData.Rows.Count + "\"}";
                    context.Response.Write(strData);
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(result));
                }
            }
            if (isQuery == "0")
            {
                if (result.success)
                {
                    context.Response.Write(result.message);
                }
                else
                {
                    context.Response.Write(result.message);
                }
            }
        }
        else if (otype == "FormListInit")
        {
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestResult result = fl.FormListInit(context, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "FormListSave")
        {
            string listData = context.Request.Params["rowsData"] == null ? "" : context.Request.Params["rowsData"].ToString();
            string formid = context.Request.Params["formid"] == null ? "" : context.Request.Params["formid"].ToString();
            DataTable table = JsonConvert.DeserializeObject<DataTable>(listData);
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestResult result = fl.FormListSave(table, HttpContext.Current.User.Identity.Name, formid);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetDynColumns")
        {
            string formid = context.Request.Params["formid"] == null ? "" : context.Request.Params["formid"].ToString();
            string conditionGUID = context.Request.Params["conditionGUID"] == null ? "" : context.Request.Params["conditionGUID"].ToString();
            string value = context.Request.Params["conditionValue"] == null ? "" : context.Request.Params["conditionValue"].ToString();
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestTablesResult result = fl.GetFormListDynColumns(formid, conditionGUID, value, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "FormListChart")
        {
            chartExplain chartEp = new chartExplain(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestResult result = chartEp.FormListChartExplain(context,null);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "FormListSummary")
        {
            string formid = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            bool isChild = context.Request.Params["isChild"] == null ? false : context.Request.Params["isChild"].ToString() == "1" ? true : false;
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            DataTable result = fl.GetFormListSummaryData(formid, filters, isChild, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "GetTheFormListData")
        {
            FormList fl = new FormList(System.Configuration.ConfigurationManager.ConnectionStrings["sysBase"].ConnectionString);
            requestTablesResult result = fl.GetTheFormListData(context, HttpContext.Current.User.Identity.Name);
            context.Response.Write(JsonConvert.SerializeObject(result));
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