<%@ WebHandler Language="C#" Class="PDAHandler2" %>

using System;
using System.Web;
using System.Data;
using sysBaseDAL.common;
using sysBaseRequestResult;
using Newtonsoft.Json;
using System.Text;
using WebMobileBLL;
public class PDAHandler2 : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string otype = context.Request.Params["otype"] == null ? "" : context.Request.Params["otype"].ToString();
        string sConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["SysBase"].ConnectionString;
        string sDb = context.Request.Params["db"] == null ? "" : context.Request.Params["db"].ToString();
        string userid = context.Request.Params["userid"] == null ? "" : context.Request.Params["userid"].ToString();
        string pwd = context.Request.Params["pwd"] == null ? "" : context.Request.Params["pwd"].ToString();
        sConnStr = sConnStr.Replace("database=ZSNETERP2015", "database=" + sDb);
        if (otype == "Hello")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                result.success = true;
                result.message = "Hello World";
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "scanBarcodeStockIn")
        {
            string barcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            string berchid = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.ScanBarcodeStockIn(barcode, berchid, userid);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "deleteBarcodeFromStockIn")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            //string berchid = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.DeleteBarcodeFromStockIn(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "deleteBarcod")
        {
            string barcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.DeleteBarcode(barcode, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "GetCheckRecordByBarcode")
        {
            string barcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            //string berchid = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetTheCheckRecordByBarcode(barcode);
                result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //else if (otype == "GetBarcodeFromStock")
        //{
        //    string barcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
        //    requestTablesResult result = new requestTablesResult();
        //    try
        //    {
        //        PDAHelper ph = new PDAHelper(sConnStr);
        //        DataTable table = ph.GetBarcodeFromStock(barcode);
        //        result.tables.Add(table);
        //        result.success = true;
        //    }
        //    catch (Exception ex)
        //    {
        //        result.success = false;
        //        result.message = ex.Message;
        //    }
        //    context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        //}
        else if (otype == "scanBarcodeStockDb")
        {
            string barcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            string heap = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.ScanBarcodeStockDb(barcode, heap, iBscDataStockMRecNo, userid);
                //result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        else if (otype == "deleteBarcodeStockDb")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            //string heap = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            //string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.DeleteBarcodeFromStockDb(iRecNo, userid);
                //result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //获取供应商
        else if (otype == "GetSupplier")
        {
            string filters = context.Request.Params["filters"] == null ? "1=1" : context.Request.Params["filters"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetSupplier(filters);
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
        //获取仓库
        else if (otype == "GetStockM")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetStockM(userid);
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
        //获取仓库
        else if (otype == "GetStockD")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "0" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetStockD(iBscDataStockMRecNo, userid);
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
        //保存成品销售出库单
        else if (otype == "SaveMMStockProductOut")
        {
            string iMMStockProductOutMRecNo = context.Request.Params["iMMStockProductOutMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iSDSendDRecNo = context.Request.Params["iSDSendDRecNo"] == null ? "" : context.Request.Params["iSDSendDRecNo"].ToString();
            string sBarcodes = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            string iBillType = context.Request.Params["iBillType"] == null ? "" : context.Request.Params["iBillType"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.SaveMMStockProductOutSale(iMMStockProductOutMRecNo, iBscDataStockMRecNo, iSDSendDRecNo, sBarcodes, iBillType, userid);
                //result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //保存成品领用出库单
        else if (otype == "SaveMMStockProductOutPick")
        {
            string iMMStockProductOutMRecNo = context.Request.Params["iMMStockProductOutMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductOutMRecNo"].ToString();
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iSDSendDRecNo = context.Request.Params["iSDSendDRecNo"] == null ? "" : context.Request.Params["iSDSendDRecNo"].ToString();
            string sBarcodes = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            string iBillType = context.Request.Params["iBillType"] == null ? "" : context.Request.Params["iBillType"].ToString();
            string iBscDataCustomerRecNo = context.Request.Params["iBscDataCustomerRecNo"] == null ? "" : context.Request.Params["iBscDataCustomerRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.SaveMMStockProductOutPick(iMMStockProductOutMRecNo, iBscDataStockMRecNo, iSDSendDRecNo, sBarcodes, iBillType, iBscDataCustomerRecNo, userid);
                //result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //删除成品领用出库单
        else if (otype == "DeleteBarcodeFromStockOutPick")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            //string heap = context.Request.Params["berchid"] == null ? "" : context.Request.Params["berchid"].ToString();
            //string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.DeleteBarcodeFromStockOutPick(iRecNo, userid);
                //result.tables.Add(table);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //获取成品销售出库未提交出库单
        else if (otype == "GetPDANotSubmitMMStockProductOut")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductOut(userid);
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
        //获取未完成发货通知单明细
        else if (otype == "GetPDANotSendDList")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSendDList();
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

        //根据物料、颜色、条码获取库存
        else if (otype == "GetBarcodeFromStockQty")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iBscDataMatRecNo = context.Request.Params["iBscDataMatRecNo"] == null ? "" : context.Request.Params["iBscDataMatRecNo"].ToString();
            string iBscDataColorRecNo = context.Request.Params["iBscDataColorRecNo"] == null ? "" : context.Request.Params["iBscDataColorRecNo"].ToString();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetBarcodeFromStockQty(iBscDataStockMRecNo, iBscDataMatRecNo, iBscDataColorRecNo, sBarCode);
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
        //根据条码取库存明细
        else if (otype == "GetBarcodeFromStockQtyByBarcode")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sBarcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetBarcodeFromStockQtyByBarcode(iBscDataStockMRecNo, sBarcode);
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


        //成品销售出库提交
        else if (otype == "MMStockProductOutMSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductOutMSubmit(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");

        }
        //成品销售出库单删除
        else if (otype == "MMStockProductOutMDelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductOutMDelete(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //获取成品销售出库单明细
        else if (otype == "GetPDANotSubmitMMStockProductOutD")
        {
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductOutD(iMainRecNo, userid);
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
        //获取未提交成品盘点单
        else if (otype == "GetPDANotSubmitMMStockProductCheck")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductCheck(userid);
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
        //获取成品盘点单明细
        else if (otype == "GetPDANotSubmitMMStockProductCheckD")
        {
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductCheckD(iMainRecNo, userid);
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
        //成品盘点单提交
        else if (otype == "MMStockProductCheckMSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductCheckMSubmit(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");

        }
        //成品盘点单删除
        else if (otype == "MMStockProductCheckMDelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductCheckMDelete(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //根据条码从验布记录中获取明细
        else if (otype == "GetBarcodeFromVatNoRecodeWithStockQty")
        {
            //string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sBarcode = context.Request.Params["barcode"] == null ? "" : context.Request.Params["barcode"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetBarcodeFromVatNoRecodeWithStockQty(sBarcode);
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
        //保存盘点单
        else if (otype == "MMStockProductCheckMSave")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "0" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string sBerChIDStr = context.Request.Params["sBerChIDStr"] == null ? "" : context.Request.Params["sBerChIDStr"].ToString();
            string sBarcodeStr = context.Request.Params["sBarcodeStr"] == null ? "" : context.Request.Params["sBarcodeStr"].ToString();
            string fPcQtyStr = context.Request.Params["fPcQtyStr"] == null ? "" : context.Request.Params["fPcQtyStr"].ToString();
            string fPcPurQtyStr = context.Request.Params["fPcPurQtyStr"] == null ? "" : context.Request.Params["fPcPurQtyStr"].ToString();
            string iMMStockProductCheckMRecNo = context.Request.Params["iMMStockProductCheckMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductCheckMRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductCheckMSave(iBscDataStockMRecNo, sBerChIDStr, sBarcodeStr, fPcQtyStr, fPcPurQtyStr, iMMStockProductCheckMRecNo, userid);
                result.success = true;
                //result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        //获取未提交成品调拨单
        else if (otype == "GetPDANotSubmitMMStockProductDb")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductDb(userid);
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
        //获取成品调拨单明细
        else if (otype == "GetPDANotSubmitMMStockProductDbD")
        {
            requestTablesResult result = new requestTablesResult();
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table = ph.GetPDANotSubmitMMStockProductDbD(iMainRecNo, userid);
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
        //成品调拨单保存
        else if (otype == "SaveMMStockProductDb")
        {
            string iMMStockProductDbMRecNo = context.Request.Params["iMMStockProductDbMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductDbMRecNo"].ToString();
            string iOutBscDataStockMRecNo = context.Request.Params["iOutBscDataStockMRecNo"] == null ? "" : context.Request.Params["iOutBscDataStockMRecNo"].ToString();
            string iInBscDataStockMRecNo = context.Request.Params["iInBscDataStockMRecNo"] == null ? "" : context.Request.Params["iInBscDataStockMRecNo"].ToString();
            string iInBscDataStockDRecNo = context.Request.Params["iInBscDataStockDRecNo"] == null ? "" : context.Request.Params["iInBscDataStockDRecNo"].ToString();
            string sBarcodes = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.SaveMMStockProductDb(iMMStockProductDbMRecNo, iOutBscDataStockMRecNo, iInBscDataStockMRecNo, iInBscDataStockDRecNo, sBarcodes, userid);
                result.success = true;
                //result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }
        //成品调拨单提交
        else if (otype == "MMStockProductDbMSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductDbMSubmit(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //成品调拨单删除
        else if (otype == "MMStockProductDbMDelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                ph.MMStockProductDbMDelete(iRecNo, userid);
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }

        //获取成品入库单明细
        else if (otype == "GetPDAMMStockProductInD")
        {
            requestTablesResult result = new requestTablesResult();
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select a.* from vwMMStockProductInD1 a where a.iMainRecNo='" + iMainRecNo + "' order by a.iSerial asc";
                DataTable resultTable;
                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    resultTable = tableData;
                }
                catch
                {
                    throw;
                }
                table = resultTable;
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

        //获取成品库存仅仅by条码
        else if (otype == "GetBarcodeFromStockQtyByOnlyBarcodeWithSDOrderDD")
        {
            requestTablesResult result = new requestTablesResult();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select a.sBarcode as sBarCode,a.fWeight as fPurQty,a.*,b.iRecNo as iStockQtyRecNo,a.sBarcode as sBarCode from vwSDOrderDDVatNoDReelNo a left join (select a.sBarCode,a.iRecNo from MMStockProductInD1 a inner join MMStockProductInM1 b on a.iMainRecNo=b.iRecNo and b.iStatus>3) b on a.sBarcode=b.sBarCode where a.sBarCode='" + sBarCode + "'";
                DataTable resultTable;
                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    resultTable = tableData;
                }
                catch
                {
                    throw;
                }
                table = resultTable;
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

        //成品入库单保存
        else if (otype == "SaveMMStockProductIn")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "0" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iBscDataStockDRecNo = context.Request.Params["iBscDataStockDRecNo"] == null ? "0" : context.Request.Params["iBscDataStockDRecNo"].ToString();
            string sBarcodeStr = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            string iMMStockProductInMRecNo = context.Request.Params["iMMStockProductInMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductInMRecNo"].ToString();
            string sOrderNo = context.Request.Params["sOrderNo"] == null ? "0" : context.Request.Params["sOrderNo"].ToString();

            requestResult result = new requestResult();
            try
            {
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                try
                {
                    sqlHelper.commExec(string.Concat(new string[]
                    {
                    "exec SpSaveMMStockProductInM ",
                    iBscDataStockMRecNo,
                    ",",
                    iBscDataStockDRecNo,
                    ",'",
                    sBarcodeStr,
                    "',",
                    iMMStockProductInMRecNo,
                    ",'",
                    userid,
                    "','",
                    sOrderNo,
                    "'"
                    }));
                }
                catch
                {
                    throw;
                }
                result.success = true;
                //result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }

        //获取未提交成品调拨单
        else if (otype == "GetPDANotSubmitMMStockProductIn")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select iRecNo,sBillNo,sCode,sName,iBscDataMatRecNo,iBscDataColorRecNo,sColorID,a.sStockName,sUserName,"+
                        "convert(varchar(10),a.dDate,23) as sDateStr,a.fQty,a.fPurQty,"+
                        "iCount=(select count(*) from MMStockProductInD1 as b where a.iRecNo=b.iMainRecNo),"+
                        "sPileNo=(select top 1 sPileNo from MMStockProductInD1 b where a.iRecNo=b.iMainRecNo) "+
                        "from vwMMStockProductInM1 as a where a.sUserID='" + userid + "' and isnull(iStatus,0)<2 order by a.dDate desc";

                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    table = tableData;
                }
                catch
                {
                    throw;
                }
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

        //成品入库单提交
        else if (otype == "MMStockProductInMSubmit")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(string.Concat(new string[]
                {
                "exec [SpStockProductSetQty] 2000021,",
                iRecNo,
                ",'",
                userid,
                "','submit' "
                }));
                try
                {
                    DataTable dataTable = sqlHelper.commExecAndReturn(stringBuilder.ToString());
                    if (dataTable.Rows[0][0].ToString() != "1")
                    {
                        throw new Exception(dataTable.Rows[0][0].ToString());
                    }
                }
                catch
                {
                    throw;
                }
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //成品入库单删除
        else if (otype == "MMStockProductInMDelete")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append("if not exists(select 1 from MMStockProductInM1 where iRecNo='" + iRecNo + "' and iStatus>1)\r\n");
                stringBuilder.Append("begin\r\n");
                stringBuilder.Append(string.Concat(new string[]
                {
                "  delete from MMStockProductInD1 where iMainRecNo='",
                iRecNo,
                "' delete from MMStockProductInM1 where iRecNo='",
                iRecNo,
                "' \r\n"
                }));
                stringBuilder.Append("end\r\n");
                stringBuilder.Append("else\r\n");
                stringBuilder.Append("begin\r\n");
                stringBuilder.Append("  raiserror('已审批不可删除',16,1)\r\n");
                stringBuilder.Append("end");
                try
                {
                    sqlHelper.commExec(stringBuilder.ToString());
                }
                catch
                {
                    throw;
                }
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }

        //获取成品销售出库单明细
        else if (otype == "GetPDANotSubmitMMStockProductOutD1")
        {
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select * from vwMMStockProductOutD1 where iMainRecNo='" + iMainRecNo + "' order by iSerial asc";

                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    table = tableData;
                }
                catch
                {
                    throw;
                }
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

        //获取成品库存仅仅by条码或堆号
        else if (otype == "GetBarcodeFromStockQtyByOnlyBarcodeOrPileNo")
        {
            requestTablesResult result = new requestTablesResult();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select a.*,b.sName,c.sColorID,d.sContractNo,d.sOrderNo,isnull(e.sBerChID,'') as sBerChID from MMStockQty a inner join BscDataMat b on a.iBscDataMatRecNo=b.iRecNo inner join BscDataColor c on a.iBscDataColorRecNo=c.iRecNo inner join SDContractM d on a.iSdOrderMRecNo=d.iRecNo left join BscDataStockD e on a.iBscDataStockDRecNo=e.iRecNo where a.sBarCode='" + sBarCode + "' or a.sPileNo='"+ sBarCode +"'";
                DataTable resultTable;
                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    resultTable = tableData;
                }
                catch
                {
                    throw;
                }
                table = resultTable;
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

        //成品销售出库单保存
        else if (otype == "SaveMMStockProductOut1")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "0" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iBscDataStockDRecNo = context.Request.Params["iBscDataStockDRecNo"] == null ? "0" : context.Request.Params["iBscDataStockDRecNo"].ToString();
            string sBarcodeStr = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            string iMMStockProductOutMRecNo = context.Request.Params["iMMStockProductOutMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductOutMRecNo"].ToString();
            string sOrderNo = context.Request.Params["sOrderNo"] == null ? "0" : context.Request.Params["sOrderNo"].ToString();

            requestResult result = new requestResult();
            try
            {
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                try
                {
                    sqlHelper.commExec(string.Concat(new string[]
                    {
                    "exec SpSaveMMStockProductOutM ",
                    iBscDataStockMRecNo,
                    ",",
                    iBscDataStockDRecNo,
                    ",'",
                    sBarcodeStr,
                    "',",
                    iMMStockProductOutMRecNo,
                    ",'",
                    userid,
                    "','",
                    sOrderNo,
                    "'"
                    }));
                }
                catch
                {
                    throw;
                }
                result.success = true;
                //result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }

         //获取未提交成品出库单
        else if (otype == "GetPDANotSubmitMMStockProductOut1")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select iRecNo,sBillNo,sCode,sName,iBscDataMatRecNo,iBscDataColorRecNo,sColorID,a.sStockName,sUserName,"+
                        "convert(varchar(10),a.dDate,23) as sDateStr,a.fQty,a.fPurQty,"+
                        "iCount=(select count(*) from MMStockProductOutD1 as b where a.iRecNo=b.iMainRecNo),"+
                        "sPileNo=(select top 1 sPileNo from MMStockProductOutD1 b where a.iRecNo=b.iMainRecNo) "+
                        "from vwMMStockProductOutM1 as a where a.sUserID='" + userid + "' and isnull(iStatus,0)<2 and a.iBillType=2 order by a.dDate desc";

                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    table = tableData;
                }
                catch
                {
                    throw;
                }
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

        //成品出库单提交
        else if (otype == "MMStockProductOutMSubmit1")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(string.Concat(new string[]
                {
                "exec [SpStockProductSetQty] 2000022,",
                iRecNo,
                ",'",
                userid,
                "','submit' "
                }));
                try
                {
                    DataTable dataTable = sqlHelper.commExecAndReturn(stringBuilder.ToString());
                    if (dataTable.Rows[0][0].ToString() != "1")
                    {
                        throw new Exception(dataTable.Rows[0][0].ToString());
                    }
                }
                catch
                {
                    throw;
                }
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }
        //成品出库单删除
        else if (otype == "MMStockProductOutMDelete1")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append("if not exists(select 1 from MMStockProductOutM1 where iRecNo='" + iRecNo + "' and iStatus>1)\r\n");
                stringBuilder.Append("begin\r\n");
                stringBuilder.Append(string.Concat(new string[]
                {
                "  delete from MMStockProductOutD1 where iMainRecNo='",
                iRecNo,
                "' delete from MMStockProductOutM1 where iRecNo='",
                iRecNo,
                "' \r\n"
                }));
                stringBuilder.Append("end\r\n");
                stringBuilder.Append("else\r\n");
                stringBuilder.Append("begin\r\n");
                stringBuilder.Append("  raiserror('已审批不可删除',16,1)\r\n");
                stringBuilder.Append("end");
                try
                {
                    sqlHelper.commExec(stringBuilder.ToString());
                }
                catch
                {
                    throw;
                }
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
        }

        //获取成品领用出库单明细
        else if (otype == "GetPDANotSubmitMMStockProductOutDLing1")
        {
            string iMainRecNo = context.Request.Params["iRecNo"] == null ? "" : context.Request.Params["iRecNo"].ToString();
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select a.*,fStockQty=ISNULL(b.fQty,0)+ISNULL(c.fOutQty,0),fStockPurQty=ISNULL(b.fPurQty,0)+ISNULL(c.fOutPurQty,0) from vwMMStockProductOutD1 a left join MMStockQty b on a.sBarCode=b.sBarCode left join (select SUM(a.fQty) fOutQty,SUM(a.fPurQty) fOutPurQty,a.sBarCode from MMStockProductOutD1 a inner join MMStockProductOutM1 b on a.iMainRecNo=b.iRecNo and b.iStatus>3 group by a.sBarCode)as c on c.sBarCode=a.sBarCode where a.iMainRecNo='" + iMainRecNo + "' order by a.iSerial asc";

                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    table = tableData;
                }
                catch
                {
                    throw;
                }
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

        //获取成品库存仅仅by条码
        else if (otype == "GetBarcodeFromStockQtyByOnlyBarcode")
        {
            requestTablesResult result = new requestTablesResult();
            string sBarCode = context.Request.Params["sBarCode"] == null ? "" : context.Request.Params["sBarCode"].ToString();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select a.*,b.sName,c.sColorID,d.sContractNo,d.sOrderNo,isnull(e.sBerChID,'') as sBerChID from MMStockQty a inner join BscDataMat b on a.iBscDataMatRecNo=b.iRecNo inner join BscDataColor c on a.iBscDataColorRecNo=c.iRecNo inner join SDContractM d on a.iSdOrderMRecNo=d.iRecNo left join BscDataStockD e on a.iBscDataStockDRecNo=e.iRecNo where a.sBarCode='" + sBarCode + "'";
                DataTable resultTable;
                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    resultTable = tableData;
                }
                catch
                {
                    throw;
                }
                table = resultTable;
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

        //成品领用出库单保存
        else if (otype == "SaveMMStockProductOutLing1")
        {
            string iBscDataStockMRecNo = context.Request.Params["iBscDataStockMRecNo"] == null ? "0" : context.Request.Params["iBscDataStockMRecNo"].ToString();
            string iBscDataStockDRecNo = context.Request.Params["iBscDataStockDRecNo"] == null ? "0" : context.Request.Params["iBscDataStockDRecNo"].ToString();
            string sBarcodeStr = context.Request.Params["sBarcodes"] == null ? "" : context.Request.Params["sBarcodes"].ToString();
            string iMMStockProductOutMRecNo = context.Request.Params["iMMStockProductOutMRecNo"] == null ? "0" : context.Request.Params["iMMStockProductOutMRecNo"].ToString();

            requestResult result = new requestResult();
            try
            {
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                try
                {
                    sqlHelper.commExec(string.Concat(new string[]
                    {
                    "exec SpSaveMMStockProductOutMLing ",
                    iBscDataStockMRecNo,
                    ",",
                    iBscDataStockDRecNo,
                    ",'",
                    sBarcodeStr,
                    "',",
                    iMMStockProductOutMRecNo,
                    ",'",
                    userid,
                    "'"
                    }));
                }
                catch
                {
                    throw;
                }
                result.success = true;
                //result.tables.Add(table);
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(JsonConvert.SerializeObject(result));
        }

        //获取未提交成品领用出库单
        else if (otype == "GetPDANotSubmitMMStockProductOutLing1")
        {
            requestTablesResult result = new requestTablesResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                DataTable table;
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                string commText = "select iRecNo,sBillNo,sCode,sName,iBscDataMatRecNo,iBscDataColorRecNo,sColorID,a.sStockName,sUserName,"+
                        "convert(varchar(10),a.dDate,23) as sDateStr,a.fQty,a.fPurQty,"+
                        "iCount=(select count(*) from MMStockProductOutD1 as b where a.iRecNo=b.iMainRecNo),"+
                        "sPileNo=(select top 1 sPileNo from MMStockProductOutD1 b where a.iRecNo=b.iMainRecNo) "+
                        "from vwMMStockProductOutM1 as a where a.sUserID='" + userid + "' and isnull(iStatus,0)<2 and a.iBillType=4 order by a.dDate desc";

                try
                {
                    DataTable tableData = sqlHelper.getTableData(commText);
                    table = tableData;
                }
                catch
                {
                    throw;
                }
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

        //成品出库单提交
        else if (otype == "MMStockProductOutMLingSubmit1")
        {
            string iRecNo = context.Request.Params["iRecNo"] == null ? "0" : context.Request.Params["iRecNo"].ToString();
            requestResult result = new requestResult();
            try
            {
                PDAHelper ph = new PDAHelper(sConnStr);
                sqlHelper sqlHelper = new sqlHelper(sConnStr);
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(string.Concat(new string[]
                {
                "exec [SpStockProductSetQty] 80314,",
                iRecNo,
                ",'",
                userid,
                "','submit' "
                }));
                try
                {
                    DataTable dataTable = sqlHelper.commExecAndReturn(stringBuilder.ToString());
                    if (dataTable.Rows[0][0].ToString() != "1")
                    {
                        throw new Exception(dataTable.Rows[0][0].ToString());
                    }
                }
                catch
                {
                    throw;
                }
                result.success = true;
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = ex.Message;
            }
            context.Response.Write(context.Request.Params["callback"].ToString() + "(" + JsonConvert.SerializeObject(result) + ")");
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