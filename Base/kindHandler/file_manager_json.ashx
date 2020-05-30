<%@ webhandler Language="C#" class="FileManager" %>

/**
 * KindEditor ASP.NET
 *
 * 本ASP.NET程序是演示程序，建议不要直接在实际项目中使用。
 * 如果您确定直接使用本程序，使用之前请仔细确认相关安全设置。
 *
 */

using System;
using System.Collections;
using System.Web;


public class FileManager : IHttpHandler
{
	public void ProcessRequest(HttpContext context)
	{
		
		context.Response.AddHeader("Content-Type", "application/json; charset=UTF-8");
        context.Response.Write(SiteBll.kindFileManage(context));
		context.Response.End();
	}

	public bool IsReusable
	{
		get
		{
			return true;
		}
	}
}
