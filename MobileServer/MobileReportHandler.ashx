<%@ WebHandler Language="C#" Class="MobileReportHandler" %>

using System;
using System.Web;
using sysBaseRequestResult;
using WebMobileBLL;
using System.Data;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
public class MobileReportHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "GetReportMenu")
        {
            requestTablesResult result = new requestTablesResult();
            string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable menuData = mf.GetReportMenu(userid, parentMenuID,false);
                result.success = true;
                result.tables.Add(menuData);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        if (otype == "GetReportMenuPDA")
        {
            requestTablesResult result = new requestTablesResult();
            string parentMenuID = context.Request.Params["parentMenuID"] == null ? "0" : context.Request.Params["parentMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable menuData = mf.GetReportMenu(userid, parentMenuID,true);
                result.success = true;
                result.tables.Add(menuData);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportInfo")
        {
            requestResult result = new requestResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tableBill = mf.GetReportInfo(iMenuID, userid);
                StringBuilder str = new StringBuilder();
                str.Append("{");
                str.Append("\"pPageCount\":\""+tableBill.Rows[0]["pPageCount"].ToString()+"\"");
                str.Append(",\"sBillType\":\"" + tableBill.Rows[0]["sBillType"].ToString() + "\"");
                str.Append(",\"iStore\":\"" + tableBill.Rows[0]["iStore"].ToString() + "\"");
                str.Append(",\"iFormID\":\"" + tableBill.Rows[0]["iFormID"].ToString() + "\"");
                str.Append(",\"sAppStyle\":\"" + tableBill.Rows[0]["sAppStyle"].ToString() + "\"");
                str.Append(",\"iShowChart\":\"" + tableBill.Rows[0]["iShowChart"].ToString() + "\"");
                str.Append(",\"sAppFiltersName1\":\"" + tableBill.Rows[0]["sAppFiltersName1"].ToString() + "\"");
                str.Append(",\"sAppFiltersName2\":\"" + tableBill.Rows[0]["sAppFiltersName2"].ToString() + "\"");
                str.Append(",\"sAppFiltersName3\":\"" + tableBill.Rows[0]["sAppFiltersName3"].ToString() + "\"");
                str.Append(",\"sAppFiltersName4\":\"" + tableBill.Rows[0]["sAppFiltersName4"].ToString() + "\"");
                str.Append(",\"sAppFilters1\":\"" + tableBill.Rows[0]["sAppFilters1"].ToString() + "\"");
                str.Append(",\"sAppFilters2\":\"" + tableBill.Rows[0]["sAppFilters2"].ToString() + "\"");
                str.Append(",\"sAppFilters3\":\"" + tableBill.Rows[0]["sAppFilters3"].ToString() + "\"");
                str.Append(",\"sAppFilters4\":\"" + tableBill.Rows[0]["sAppFilters4"].ToString() + "\"");
                str.Append(",\"sTreeListPField\":\"" + tableBill.Rows[0]["sTreeListPField"].ToString() + "\"");
                str.Append(",\"sTreeListCField\":\"" + tableBill.Rows[0]["sTreeListCField"].ToString() + "\"");
                str.Append(",\"sTreeListDField\":\"" + tableBill.Rows[0]["sTreeListDField"].ToString() + "\"");                
                str.Append("}");
                result.success = true;
                result.message=str.ToString();
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }            
        else if (otype == "GetReportCondition") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tableCondition = mf.GetReportCondition(iMenuID, userid);
                result.success = true;
                result.tables.Add(tableCondition);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getReportStyle") 
        {
            requestResult result = new requestResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                string sStyle = mf.GetReportStyle(iMenuID, userid);
                result.success = true;
                result.message = sStyle;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getReportStyleO")
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tableStyle = mf.GetReportStyleO(iMenuID, userid);
                result.success = true;
                result.tables.Add(tableStyle);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "getReportData")
        {
            //requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "" : context.Request.Params["filters"].ToString();
            string chooseCount = context.Request.Params["rows"] == null ? "30" : context.Request.Params["rows"].ToString();
            string skipCount = ((int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(chooseCount)).ToString();
            string sort = "";
            string sortname = context.Request.Params["sort"] == null ? "" : context.Request.Params["sort"].ToString();
            string sortorder = context.Request.Params["order"] == null ? "asc" : context.Request.Params["order"].ToString();
            bool isFirst = context.Request.Params["isFirst"] == null ? false : (context.Request.Params["isFirst"].ToString() == "1" ? true : false);
            bool isChart = context.Request.Params["isChart"] == null ? false : (context.Request.Params["isChart"].ToString() == "1" ? true : false);
            if (sortname != "") {
                sort = sortname + " " + sortorder;
            }
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                List<DataTable> tables = mf.GetReportData(iMenuID, userid, filters, int.Parse(chooseCount), int.Parse(skipCount), sort, isFirst, isChart);
                string backStr = context.Request.Params["callback"].ToString() + "(" + "{\"rows\":" + JsonConvert.SerializeObject(tables[0]) + ",\"total\":\"" + tables[1].Rows[0][0].ToString() + "\"})";
                context.Response.Write(backStr);
            }
            catch (Exception ex)
            {
                //result.success = false;
                //result.message = ex.Message;
                context.Response.Write(context.Request.Params["callback"].ToString() + "(" + ex.Message + ")");
            }
            //context.Response.Write(JsonConvert.SerializeObject(result));
        }
        else if (otype == "getReportDataByFormID")
        {
            requestTablesResult result = new requestTablesResult();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "1=1" : context.Request.Params["filters"].ToString();
            string chooseCount = context.Request.Params["rows"] == null ? "30" : context.Request.Params["rows"].ToString();
            string skipCount = context.Request.Params["page"] == null ? "0" : ((int.Parse(context.Request.Params["page"].ToString()) - 1) * int.Parse(chooseCount)).ToString();
            string sort = "";
            string sortname = context.Request.Params["sort"] == null ? "" : context.Request.Params["sort"].ToString();
            string sortorder = context.Request.Params["order"] == null ? "asc" : context.Request.Params["order"].ToString();
            bool isFirst = context.Request.Params["isFirst"] == null ? false : (context.Request.Params["isFirst"].ToString() == "1" ? true : false);
            bool isChart = context.Request.Params["isChart"] == null ? false : (context.Request.Params["isChart"].ToString() == "1" ? true : false);
            string sync = context.Request.Params["sync"] == null ? "" : context.Request.Params["sync"].ToString();
            if (sortname != "")
            {
                sort = sortname + " " + sortorder;
            }
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                List<DataTable> tables = mf.GetReportDataByFormID(iFormID, userid, filters, int.Parse(chooseCount), int.Parse(skipCount), sort, isFirst, isChart);
                result.success = true;
                result.tables = tables;
                result.message = iFormID+"_"+sync;
                //context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
                //context.Response.Write(context.Request.Params["callback"].ToString() + "(" + ex.Message + ")");
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportSort")
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();            
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable tables = mf.GetReportSort(iMenuID, userid);
                result.success = true;
                result.tables.Add(tables);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportColumns") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetReportColumns(iMenuID, userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex) 
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetAssicateData") 
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetAssicateData(iMenuID, userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportChartInfo")
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetReportChartInfo(iMenuID, userid);
                result.success = true;
                result.tables.Add(table);
            }
            catch(Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetrReportChart")
        {
            requestResult result = new requestResult();
            MobileReport mf = new MobileReport(sConnStr);
            result = mf.GetrReportChart(context, userid);
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportSummaryData")
        {
            requestTablesResult result = new requestTablesResult();
            string iMenuID = context.Request.Params["iMenuID"] == null ? "" : context.Request.Params["iMenuID"].ToString();
            string filters = context.Request.Params["filters"] == null ? "1=1" : context.Request.Params["filters"].ToString();
            bool isFirst = context.Request.Params["isFirst"] == null ? false : (context.Request.Params["isFirst"].ToString() == "1" ? true : false);
            MobileReport mf = new MobileReport(sConnStr);
            try
            {
                DataTable table = mf.GetReportSummaryData(iMenuID, userid, filters, isFirst, false);
                result.success = true;
                result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;                
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetReportUnionDefined")
        {
            requestDataSetResult result = new requestDataSetResult();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            MobileReportUnion mru = new MobileReportUnion(sConnStr);
            try
            {
                DataSet ds = mru.GetReportUnionDefined(iFormID, userid);
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
        else if (otype == "GetEChartSetting")
        {
            requestResult<sysBaseChartExplain.EChartSetting> result = new requestResult<sysBaseChartExplain.EChartSetting>();
            string iFormID = context.Request.Params["iFormID"] == null ? "" : context.Request.Params["iFormID"].ToString();
            string sync = context.Request.Params["sync"] == null ? "" : context.Request.Params["sync"].ToString();
            sysBaseChartExplain.EChartsDao ecd = new sysBaseChartExplain.EChartsDao(sConnStr);
            try
            {
                sysBaseChartExplain.EChartSetting ecs = ecd.GetSetting(iFormID, userid);
                result.success = true;
                result.obj = ecs;
                result.message = iFormID + "_" + sync;
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