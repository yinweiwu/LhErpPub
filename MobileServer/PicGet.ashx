<%@ WebHandler Language="C#" Class="PicGet" %>

using System;
using System.Web;
using System.IO;
public class PicGet : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
	    //string datastring=DateTime.Now.Year.ToString()+DateTime.Now.Month.ToString()+DateTime.Now.Day.ToString()+DateTime.Now.Hour.ToString()+DateTime.Now.Minute.ToString()+DateTime.Now.Second.ToString();
	    HttpPostedFile httpPostedFile = context.Request.Files[0];
	    string fileall="\\Base\\imageUpload\\images\\"+DateTime.Now.ToString("yyyy-MM")+"\\";
	    if (Directory.Exists(context.Request.MapPath(fileall)) == false)//如果不存在就创建file文件夹
	    {
               Directory.CreateDirectory(context.Request.MapPath(fileall));
            }
	    string datastring=context.Request.Form["senddate"];  
	    string irecno=context.Request.Form["irecno"];    //文件名是：" + iformid + "_" + tablename + "_" + irecno + "_" + imageid + "_" + fileNameFull
	    string iformid="5030";
	    string tablename="BscDataCustomerVisit";
	    string imageid="__ExtFile1";
		string a = httpPostedFile.FileName;   //文件名称中设计多个特定符号； 
        string[] str = a.Split('/'); //根据特定符号截取为字符串数组；  
        string temp = str[str.Length - 1]; //取出数组最后一位； 
	    string path=fileall+ iformid + "_" + tablename + "_" + irecno + "_" + imageid + "_" +datastring+httpPostedFile.FileName;
	   // string path=httpPostedFile.FileName;
            string realfilepath = context.Request.MapPath(path);
	     
           httpPostedFile.SaveAs(realfilepath);

       
       
       context.Response.Write("签到成功");
       // context.Response.Write(realfilepath);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
     public static string UploadImg(HttpPostedFileBase head, string path, HttpServerUtilityBase Server)
    {
        string json = "-1";
        try
        {
            if ((head == null))
            {
                json = "-1";
            }
            else
            {
                bool flag = true;
                if (!System.IO.Directory.Exists(Server.MapPath(path)))
                {
                    System.IO.Directory.CreateDirectory(Server.MapPath(path));
                }
                var supportedTypes = new[] { "jpg", "jpeg", "png", "gif", "bmp", "JPG", "GIF", "JPEG", "PNG", "BMP" };
                var fileExt = System.IO.Path.GetExtension(head.FileName).Substring(1);
                //if (!supportedTypes.Contains(fileExt))
                //{
                //    json = "-1";
                //    flag = false;
                //}
                if (head.ContentLength > 1024 * 1000 * 10)
                {
                    json = "-1";
                    flag = false;
                }
                if (flag)
                {
                    Random r = new Random();
                    var filename = DateTime.Now.ToString("yyyyMMddHHmmssfff") + r.Next(10000) + "." + fileExt;
                    var filepath = System.IO.Path.Combine(Server.MapPath(path), filename);
                    head.SaveAs(filepath);
                    json = path + filename;
                }
            }
        }
        catch (Exception)
        {
            json = "-1";
        }
        return json;
    }
}