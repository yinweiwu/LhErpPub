<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;
using System.Web;
using System.Web.Security;
using System.Data;
using sysBaseDAL;
using sysBaseMessage;
using sysBaseRequestResult;
using System.Drawing;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
public class LoginHandler : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Params["otype"] == null)
        {
            //if (getExpireDays() < 0)
            //{
            //    context.Response.Write("warn:系统已到期，无法登录，请与供应商联系！");
            //}
            //else
            //{
            string userid = context.Request.Params["userid"].ToString();
            string psd = context.Request.Params["password"].ToString();
            string validateNum = context.Request.Params["validateNum"] == null ? "" : context.Request.Params["validateNum"].ToString();
            string remember = context.Request.Params["remember"].ToString();
            context.Response.ContentType = "text/plain";

            ////是否需要验证码
            //if (isDisabledIdenCode() != "1")
            //{
            //    if (HttpContext.Current.Session != null)
            //    {
            //        string lastValidateNum = HttpContext.Current.Session["ValidateNum"] == null ? "" : HttpContext.Current.Session["ValidateNum"].ToString();
            //        if (lastValidateNum.ToLower() != validateNum.ToLower())
            //        {
            //            context.Response.Write("warn:验证码错误！");
            //            return;
            //        }
            //    }
            //}                
            try
            {
                string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
                User user = new User(connstr);
                int i = user.loginuser(userid.TrimEnd(), psd);
                if (i == 1)
                {
                    bool needMobile = false;
                    sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(connstr);
                    DataTable tableSysParam = sqlhelper.getTableData("select top 1 iMobileLoginCheck from SysParam");
                    bool loginDir = false;
                    if (tableSysParam.Rows.Count > 0)
                    {
                        needMobile = tableSysParam.Rows[0]["iMobileLoginCheck"].ToString() == "1" ? true : false;
                    }
                    if (needMobile)
                    {
                        //是否记录
                        HttpCookie cookieRememberMobileUserID = context.Request.Cookies["rememberMobileUserid"];
                        if (cookieRememberMobileUserID == null || ("`" + cookieRememberMobileUserID.Value + "`").IndexOf(userid) == -1)
                        {
                            DataTable tablePerson = sqlhelper.getTableData("select sTel from bscDataPerson where sCode='" + userid + "'");
                            if (tablePerson.Rows[0]["sTel"].ToString().Trim() != "")
                            {
                                string mobile = "";
                                for (int z = 0; z < tablePerson.Rows.Count; z++)
                                {
                                    mobile += tablePerson.Rows[z][0].ToString() + ",";
                                }
                                if (mobile.Length > 0)
                                {
                                    mobile = mobile.Substring(0, mobile.Length - 1);
                                }
                                context.Response.Write(mobile);
                                return;
                            }
                            else
                            {
                                loginDir = true;
                            }
                        }
                        else
                        {
                            loginDir = true;
                        }
                    }
                    else
                    {
                        loginDir = true;
                    }
                    if (loginDir == true)
                    {
                        string role = user.getrole(userid);
                        FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, userid.TrimEnd(), DateTime.Now, DateTime.Now.AddMinutes(240), false, role, "/");
                        string hashticket = FormsAuthentication.Encrypt(ticket);
                        HttpCookie KL_USERcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hashticket);
                        //用户信息放在Cookie中
                        DataTable table = user.getUserInfo(userid.TrimEnd());
                        HttpCookie useridcookie = new HttpCookie("LastUser");
                        useridcookie["userid"] = userid.TrimEnd();
                        if (remember == "1")
                        {
                            useridcookie["pwd"] = user.getEncryptStr(psd);
                        }
                        else
                        {
                            useridcookie["pwd"] = "";
                        }
                        useridcookie.Expires = DateTime.Now.AddDays(30);
                        context.Response.Cookies.Add(useridcookie);
                        context.Response.Cookies.Add(KL_USERcookie);
                        context.Response.Write("1");
                    }
                }
                else
                {
                    context.Response.Write("warn:用户名或密码不正确！");
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("error:" + ex.Message);
            }
            //}
        }
        else if (context.Request.Params["otype"].ToString() == "validateMessageLogin")
        {
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            string mobile = context.Request.Params["mobile"] == null ? "" : context.Request.Params["mobile"].ToString();
            string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
            string psd = context.Request.Params["password"] == null ? "" : context.Request.Params["password"].ToString();
            string remember = context.Request.Params["remember"] == null ? "" : context.Request.Params["remember"].ToString();
            string rememberBrowser = context.Request.Params["rememberBrowser"] == null ? "" : context.Request.Params["rememberBrowser"].ToString();
            string sValidateCode = context.Request.Params["validateCode"] == null ? "" : context.Request.Params["validateCode"].ToString();
            sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(connstr);
            try
            {
                DataTable tableExits = sqlhelper.getTableData("select 1 from MobileValidateCode where sMobile='" + GetSafeSQL(mobile) + "' and sUserID='" + GetSafeSQL(userid) + "' and sValidateCode='" + GetSafeSQL(sValidateCode) + "' and datediff(minute,dInputDate,getdate())<=30");
                if (tableExits.Rows.Count > 0)
                {
                    User user = new User(connstr);
                    string role = user.getrole(userid);
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(1, userid, DateTime.Now, DateTime.Now.AddMinutes(240), false, role, "/");
                    string hashticket = FormsAuthentication.Encrypt(ticket);
                    HttpCookie KL_USERcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hashticket);
                    //用户信息放在Cookie中
                    DataTable table = user.getUserInfo(userid);
                    HttpCookie useridcookie = new HttpCookie("LastUser");
                    useridcookie["userid"] = userid;
                    if (remember == "1")
                    {
                        useridcookie["pwd"] = user.getEncryptStr(psd);
                    }
                    else
                    {
                        useridcookie["pwd"] = "";
                    }
                    useridcookie.Expires = DateTime.Now.AddDays(30);
                    //是否记录
                    HttpCookie cookieRememberMobileUserID = context.Request.Cookies["rememberMobileUserid"];
                    if (cookieRememberMobileUserID == null)
                    {
                        HttpCookie rememberMobileUserID = new HttpCookie("rememberMobileUserid");
                        rememberMobileUserID.Value = userid;
                        rememberMobileUserID.Expires = DateTime.Now.AddDays(30);
                        context.Response.Cookies.Add(rememberMobileUserID);
                    }
                    else
                    {
                        if (("`" + cookieRememberMobileUserID.Value + "`").IndexOf(userid) == -1)
                        {
                            cookieRememberMobileUserID.Value = cookieRememberMobileUserID.Value + "`" + userid;
                        }
                    }
                    context.Response.Cookies.Add(useridcookie);
                    context.Response.Cookies.Add(KL_USERcookie);
                    context.Response.Write("1");
                }
                else
                {
                    context.Response.Write("验证码不正确！");
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else if (context.Request.Params["otype"].ToString() == "getuserid")
        {
            HttpCookie useridcookie = context.Request.Cookies["LastUser"];
            if (useridcookie != null)
            {
                string userid = useridcookie["userid"].ToString();
                string pwd = useridcookie["pwd"] == null ? "" : useridcookie["pwd"].ToString();
                User user = new User();
                string pwdDe = user.getDecryptStr(pwd);
                string userStr = "{\"userid\":\"" + userid + "\",\"pwd\":\"" + pwdDe + "\"}";

                context.Response.Write(userStr);
            }
            else
            {
                context.Response.Write("");
            }
        }
        else if (context.Request.Params["otype"].ToString() == "islogin")
        {
            if (context.User.Identity.IsAuthenticated)
            {
                context.Response.Write("1");
            }
            else
            {
                context.Response.Write("0");
            }
        }
        else if (context.Request.Params["otype"].ToString() == "getcurtuserid")
        {
            context.Response.Write(HttpContext.Current.User.Identity.Name);
        }
        else if (context.Request.Params["otype"].ToString() == "getcurtusername")
        {
            //context.Response.Write(HttpContext.Current.User.Identity.Name);
            SqlQueryExec sqe = new SqlQueryExec("select sName from bscdataperson where scode='" + HttpContext.Current.User.Identity.Name + "'");
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            DataTable table = sqe.SqlQueryComm(connstr);
            if (table.Rows.Count > 0)
            {
                context.Response.Write(table.Rows[0][0].ToString());
            }
            else
            {
                context.Response.Write("");
            }
        }
        else if (context.Request.Params["otype"].ToString() == "getServerUrl")
        {
            string host = context.Request.Url.Host;
            int port = context.Request.Url.Port;
            string path = context.Request.ApplicationPath;
            string url = "http://" + host + ":" + port.ToString() + path;
            context.Response.Write(url);
        }
        else if (context.Request.Params["otype"].ToString() == "loginLog")
        {
            //记录登录信息
            string IPAddr = HttpContext.Current.Request.UserHostAddress;
            sysBaseDAL.common.sqlHelper sqlh = new sysBaseDAL.common.sqlHelper(System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString);
            //iType 1登录；2登出；
            sqlh.commExec("IF EXISTS(SELECT * FROM sysobjects WHERE id=object_id('SysLogs') AND OBJECTPROPERTY(id,'IsUserTable') = 1)begin insert into SysLogs(iType,sUserID,dDateTime,sIP) values (1,'" + HttpContext.Current.User.Identity.Name + "',getdate(),'" + HttpContext.Current.Request.UserHostAddress + "') end");
            context.Response.Write("1");
        }
        else if (context.Request.Params["otype"].ToString() == "sendShortMessage")
        {
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            SMSHelper smsh = new SMSHelper(connstr);
            Random ran = new Random();
            int RandKey = ran.Next(10000, 99999);
            string mobile = context.Request.Params["mobile"] == null ? "" : context.Request.Params["mobile"].ToString();
            string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
            requestResult result = new requestResult();
            string cent = "验证码:" + RandKey.ToString() + "，该验证码用于系统登录，30分钟内有效。";
            result = smsh.sendMSM(mobile, cent);
            if (result.success != true)
            {
                context.Response.Write(result.message);
            }
            else
            {
                sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(connstr);
                string comm = "insert into MobileValidateCode(sMobile,sValidateCode,sUserID,dInputDate) values('" + GetSafeSQL(mobile) + "','" + GetSafeSQL(RandKey.ToString()) + "','" + GetSafeSQL(userid) + "',getdate())";
                try
                {
                    sqlhelper.commExec(comm);
                    context.Response.Write("1");
                }
                catch (Exception ex)
                {
                    context.Response.Write(ex.Message);
                }
            }

        }
        else if (context.Request.Params["otype"].ToString() == "validateNum")
        {
            string validateNum = CreateRandomNum(4);
            Bitmap image = CreateImage(validateNum);
            context.Response.ClearContent();
            context.Response.ContentType = "image/Gif";
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            //将图像保存到指定流
            try
            {
                image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
                context.Response.BinaryWrite(ms.ToArray());
                HttpContext.Current.Session["ValidateNum"] = validateNum;
            }
            catch
            {

            }
            finally
            {
                image.Dispose();
            }
        }
        else if (context.Request.Params["otype"].ToString() == "loginCarouselImage")
        {
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(connstr);
            try
            {
                DataTable table = sqlhelper.getTableData("select top 1 sLoginImage1,sLoginImage2,sLoginImage3,sLoginImage4 from SysParam");
                if (table.Rows.Count > 0)
                {
                    string result = table.Rows[0][0].ToString() + "," + table.Rows[0][1].ToString() + "," + table.Rows[0][2].ToString() + "," + table.Rows[0][3].ToString();
                    context.Response.Write(result);
                }
                else
                {
                    context.Response.Write("");
                }
            }
            catch
            {
                context.Response.Write("");
            }
        }
        else if (context.Request.Params["otype"].ToString() == "verify")
        {
            string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
            User user = new User(connstr);
            context.Response.Write(user.SysExpiredDate());
        }
        else if (context.Request.Params["otype"].ToString() == "isDisabledIdenCode")
        {
            context.Response.Write(isDisabledIdenCode());

        }
    }

    private string isDisabledIdenCode()
    {
        string connstr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        sysBaseDAL.common.sqlHelper sqlhelper = new sysBaseDAL.common.sqlHelper(connstr);
        string comm = "select top 1 iDisableLoginIdenCode from SysParam";
        try
        {
            DataTable table = sqlhelper.getTableData(comm);
            return table.Rows[0][0].ToString();
        }
        catch
        {
            return "0";
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    //生产随机数
    private string CreateRandomNum(int NumCount)
    {
        string allChar = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,O,P,Q,R,S,T,U,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,m,n,o,p,q,s,t,u,w,x,y,z";
        string[] allCharArray = allChar.Split(',');//拆分成数组
        string randomNum = "";
        int temp = -1;                             //记录上次随机数的数值，尽量避免产生几个相同的随机数
        Random rand = new Random();
        for (int i = 0; i < NumCount; i++)
        {
            if (temp != -1)
            {
                rand = new Random(i * temp * ((int)DateTime.Now.Ticks));
            }
            int t = rand.Next(35);
            if (temp == t)
            {
                return CreateRandomNum(NumCount);
            }
            temp = t;
            randomNum += allCharArray[t];


        }
        return randomNum;
    }
    //生产图片
    private Bitmap CreateImage(string validateNum)
    {
        if (validateNum == null || validateNum.Trim() == string.Empty)
            return null;
        //生成BitMap图像
        System.Drawing.Bitmap image = new System.Drawing.Bitmap(validateNum.Length * 12 + 12, 22);
        Graphics g = Graphics.FromImage(image);
        try
        {
            //生成随机生成器
            Random random = new Random();
            //清空图片背景
            g.Clear(Color.White);
            //画图片的背景噪音线
            for (int i = 0; i < 25; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Height);
                int y2 = random.Next(image.Height);
                g.DrawLine(new Pen(Color.Silver), x1, x2, y1, y2);
            }
            Font font = new System.Drawing.Font("Arial", 12, (System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
            System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.Blue, Color.DarkRed, 1.2f, true);
            g.DrawString(validateNum, font, brush, 2, 2);
            //画图片的前景噪音点
            for (int i = 0; i < 100; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);
                image.SetPixel(x, y, Color.FromArgb(random.Next()));

            }
            //画图片的边框线
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
            //System.IO.MemoryStream ms = new System.IO.MemoryStream();
            //将图像保存到指定流
            //image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
            return image;
            /*HttpContext.Response.ClearContent();
            Response.ContentType = "image/Gif";
            Response.BinaryWrite(ms.ToArray());*/
        }
        catch
        {
            return null;
        }
        finally
        {
            g.Dispose();
            //image.Dispose();
        }
    }


    private int getExpireDays()
    {
        string expireDateStr = string.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["expireDate"]) ? "2199-12-31 23:59:59" : System.Configuration.ConfigurationManager.AppSettings["expireDate"] + " 23:59:59";
        DateTime expireDate = Convert.ToDateTime(expireDateStr);
        TimeSpan ts = expireDate - DateTime.Now;
        if (ts.Days > 0)
        {
            return ts.Days;
        }
        else
        {
            if (ts.Hours >= 0)
            {
                return 0;
            }
            else
            {
                return -1;
            }
        }
    }

    /// <summary>
    /// 过滤SQL非法字符串
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    private string GetSafeSQL(string value)
    {
        if (string.IsNullOrEmpty(value))
            return string.Empty;
        value = Regex.Replace(value, @";", string.Empty);
        value = Regex.Replace(value, @"'", string.Empty);
        value = Regex.Replace(value, @"&", string.Empty);
        value = Regex.Replace(value, @"%20", string.Empty);
        value = Regex.Replace(value, @"--", string.Empty);
        value = Regex.Replace(value, @"==", string.Empty);
        value = Regex.Replace(value, @"<", string.Empty);
        value = Regex.Replace(value, @">", string.Empty);
        value = Regex.Replace(value, @"%", string.Empty);
        return value;
    }
}