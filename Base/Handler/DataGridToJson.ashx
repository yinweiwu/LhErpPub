<%@ WebHandler Language="C#" Class="DataGridToXml" %>

using System;
using System.Web;
using System.IO;
using System.Text;
using sysBaseDAL.common;
using System.Data;
public class DataGridToXml : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string pbRecNo = context.Request.Params["pbRecNo"] == null ? "0" : context.Request.Params["pbRecNo"].ToString();
        try
        {
            DirectoryInfo path = new System.IO.DirectoryInfo(context.Server.MapPath("/ExcelTmp"));
            deletefile(path);
        }
        catch
        { 
            
        }
        try
        {
            sqlHelper sqlhelper = new sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            DataTable table = sqlhelper.getTableData("select iDataSourceFromList from pbReportData where iRecNo='" + pbRecNo + "'");
            if (table.Rows.Count > 0)
            {
                if (table.Rows[0][0].ToString() == "1")
                {
                    string title = context.Request.Params["title"] == null ? "" : context.Request.Params["title"].ToString();
                    if (!Directory.Exists(context.Server.MapPath("/ExcelTmp")))
                    {
                        Directory.CreateDirectory(context.Server.MapPath("/ExcelTmp"));
                    }
                    string fn = title + "_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".json";
                    string data = context.Request.Params["data"] == null ? "" : context.Request.Params["data"].ToString();
                    //data = "var data=" + data;
                    File.WriteAllText(context.Server.MapPath("/ExcelTmp/" + fn), data, Encoding.UTF8);//如果是gb2312的xml申明，第三个编码参数修改为Encoding.GetEncoding(936)
                    context.Response.Write(fn);//返回文件名提供下载
                }
                else
                {
                    context.Response.Write("");
                }
            }
        }
        catch
        {
            context.Response.Write("");
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private void deletefile(DirectoryInfo path)
    {
        foreach (DirectoryInfo d in path.GetDirectories())
        {
            deletefile(d);
        }
        foreach (FileInfo f in path.GetFiles())
        {
            var ex = f.Extension;
            if (ex.ToLower() == ".json")
            {
                DateTime ct = f.CreationTime;
                TimeSpan ts = DateTime.Now - ct;
                if (ts.Days > 0 || ts.Hours > 0 || ts.Minutes > 10)
                {
                    f.Delete();
                }
            }
        }
    }
}