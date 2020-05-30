<%@ WebHandler Language="C#" Class="PbHandler" %>

using System;
using System.Web;
using Newtonsoft.Json;
using sysBaseRequestResult;
using sysBaseDAL.common;
using System.Data;
using sysBaseBll;
using System.Text;
public class PbHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        string from = context.Request.Params["from"].ToString();
        string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        try
        {
            switch (from)
            {
                case "posturl":
                    {
                        string irecno = context.Request.Params["irecno"].ToString();
                        string ReportFileValue = context.Request.Params["ReportFileValue"].ToString();
                        string commtext = "update pbReportData set sPbStr='" + ReportFileValue + "' where iRecNo=" + irecno + "";
                        SqlQueryExec sqe = new SqlQueryExec(commtext);
                        sqe.SqlQueryComm(connstr);
                        context.Response.ContentType = "text/plain";
                    } break;
                case "pageseturl":
                    {
                        string irecno = context.Request.Params["irecno"].ToString();
                        string LeftMargin = context.Request.Params["LeftMargin"].ToString();
                        string RightMargin = context.Request.Params["RightMargin"].ToString();
                        string TopMargin = context.Request.Params["TopMargin"].ToString();
                        string BottomMargin = context.Request.Params["BottomMargin"].ToString();
                        string smargin = LeftMargin + "," + RightMargin + "," + TopMargin + "," + BottomMargin;
                        string commtext = "update pbReportData set sMargin='" + smargin + "' where iRecNo=" + irecno + "";
                        SqlQueryExec sqe = new SqlQueryExec(commtext);
                        sqe.SqlQueryComm(connstr);
                        context.Response.ContentType = "text/plain";
                    }break;
                case "printurl":
                    {
                        sqlHelper sqlhelper = new sqlHelper(connstr);
                        string irecno = context.Request.Params["irecno"].ToString();
                        string key = context.Request.Params["key"].ToString();
                        string iformid = context.Request.Params["iformid"].ToString();
                        string userid = context.Request.Params["userid"].ToString();
                        string PrintCopy = context.Request.Params["PrintCopy"].ToString();
                        DataTable pbDefined = sqlhelper.getTableData("select sAfterPrintStoredProcedure from pbReportData where iRecNo=" + irecno);
                        string afterPrintStoredProcedure = pbDefined.Rows[0]["sAfterPrintStoredProcedure"].ToString();
                        if (!string.IsNullOrEmpty(afterPrintStoredProcedure))
                        {
                            sqlhelper.commExec(new StringBuilder().AppendFormat("exec {0} {1},{2},'{3}',{4} ", afterPrintStoredProcedure, iformid, key, userid, PrintCopy).ToString());
                        }
                    } break;
                //case "getStimulsoftReportStr":
                //    {
                //        requestResult result = new requestResult();
                //        try
                //        {
                //            StimulsoftReport sr = new StimulsoftReport(connstr);
                            
                //            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                //            string str = sr.GetReportStr(iRecNo);                            
                //            result.success = true;
                //            result.message = str;
                //        }
                //        catch (Exception ex)
                //        {
                //            result.success = false;
                //            result.message = ex.Message;
                //        }
                //        context.Response.Write(JsonConvert.SerializeObject(result));
                //    } break;
                //case "getStimulsoftReportDataSource":
                //    {
                //        //这里只能获取SQL中的数据，表单列的数据要在前台设计时获取
                //        requestResult result = new requestResult();
                //        StimulsoftReport sr = new StimulsoftReport(connstr);
                //        result = sr.GetReportDataSource(context);
                //        context.Response.Write(JsonConvert.SerializeObject(result));
                //    } break;
                //case "saveStimulsoftReport":
                //    {
                //        //这里只能获取SQL中的数据，表单列的数据要在前台设计时获取
                //        requestResult result = new requestResult();
                //        StimulsoftReport sr = new StimulsoftReport(connstr);
                //        string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                //        string str = context.Request.Params["str"] == null ? "" : context.Request.Params["str"].ToString();
                //        try
                //        {
                //            sr.SaveReport(iRecNo, str);
                //            result.success = true;
                //        }
                //        catch(Exception ex)
                //        {
                //            result.success = false;
                //            result.message = ex.Message;
                //        }
                //        context.Response.Write(JsonConvert.SerializeObject(result));
                //    } break;
                //case "saveLodopReport":
                //    {
                //        //这里只能获取SQL中的数据，表单列的数据要在前台设计时获取
                //        requestResult result = new requestResult();
                //        StimulsoftReport sr = new StimulsoftReport(connstr);
                //        string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
                //        string str = context.Request.Params["str"] == null ? "" : context.Request.Params["str"].ToString();
                //        try
                //        {
                //            sr.SaveReport(iRecNo, str);
                //            result.success = true;
                //        }
                //        catch (Exception ex)
                //        {
                //            result.success = false;
                //            result.message = ex.Message;
                //        }
                //        context.Response.Write(JsonConvert.SerializeObject(result));
                //    } break;
            }
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