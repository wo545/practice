<%@ page language="java" contentType="text/html; charset=gbk"
    pageEncoding="gbk"%>
<%@ page isELIgnored="false"%>
<%@page import="java.util.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link rel=stylesheet type=text/css href="../common/css/newApprove.css">
<script src="../common/javascript/Common.js"></script>
<script src="../common/jquery/jquery-1.8.3.min.js"></script>
<title>Insert title here</title>

<script type="text/javascript">
var contextPath = "${pageContext.request.contextPath}";
var batchNo = "${param.batchNo}";
var workListID = "${param.workListID}";
var expJumpNum=0;
var loanJumpNum=0;
var url=contextPath+"/newapprove/approve.do?batchNo="+batchNo;

	//jqueryajax回调函数
	function jQueryCallBack(result,status,xhr){
		 if(status=="success"){
			 if(document.readyState==="complete"){
			  	initValues(result);
			 }else{
				 window.onload=function (){initValues(result);};
			 }
		 }
	     if(status=="error"){
			  alert("Error: "+xhr.status+": "+xhr.statusText);
	     }
	}
	(function(){
		$.ajax({url:url,success:jQueryCallBack,type:"get"});
	})();
		function btn() {
			var ev=event.srcElement;
			var btnClass="";
			if(ev.getAttribute){
				btnClass=ev.getAttribute("class");
			}else{
				btnClass=ev.className;
			}
			if(!btnClass){
				btnClass=ev.className;
			}
			var spanArray = ev.parentNode.children;
			for(var i=0;i<spanArray.length;i++){
		  		if(spanArray[i]===ev){
					ev.className="span-btn active";
		  		} else {
		  			spanArray[i].className=btnClass.replace('active','');
		  		}
		    }
		}
		function initValues(values){
			values=eval("("+values+")");
			var detail=values.detail;
			var approveHistory=values.approveHistory;
			var uploadFile=values.uploadFile;
			var budgetDetail=values.budgetDetail;
			var splitDetail=values.splitDetail;
			$("#applyNo").html(detail[0].APPLYNO);
			$("#applyDate").html(detail[0].APPLYDATE);
			$("[name='deptName']").html(detail[0].DEPTNAME);
			$("#comName").html(detail[0].COMNAME);
			$("[name='userName']").html(detail[0].USERNAME);
			$("#applyMoney").html(detail[0].AMOUNT);
			$("#describe").html(detail[0].DESCRIBE);
			$("#detailDesScript").html(detail[0].DETAILDESSCRIPT);
			$("#telePhone").html(nullToSpace(detail[0].PHONE,"无"));
			var splitsDatas=[];
			for(var i=0;i<splitDetail.length;i++){
				 splitsDatas[i]=new Array();
				 splitsDatas[i][0]=splitDetail[i].COMNAME;
				 splitsDatas[i][1]=splitDetail[i].DEPTNAME;
				 splitsDatas[i][2]=splitDetail[i].AMOUNT;
			} 
			initTR("splitTitle",splitsDatas);
			initUploadFile(uploadFile);
			var budgetDatas=[];
			for(var i=0;i<budgetDetail.length;i++){
				budgetDatas[i]=new Array();
				budgetDatas[i][0]=budgetDetail[i].EXPITEMSTATE;
				budgetDatas[i][1]=budgetDetail[i].AMOUNT;
				budgetDatas[i][2]=budgetDetail[i].USABLEAMOUNT;
				budgetDatas[i][3]=budgetDetail[i].ZHCLOCK;
				budgetDatas[i][4]=budgetDetail[i].LXLOCK; 
			}   
			initTR("budgetTitle",budgetDatas);
			var historyDatas=[];
			for(var i=0;i<approveHistory.length;i++){
				historyDatas[i]=new Array();
				historyDatas[i][0]=approveHistory[i].APPROVEDATE;
				historyDatas[i][1]=approveHistory[i].TACHENAME;
				historyDatas[i][2]=approveHistory[i].USERNAME;
				historyDatas[i][3]=approveHistory[i].CODENAME;
				historyDatas[i][4]=approveHistory[i].ADVICECONTENT; 
			}   
			initTR("historyTitle",historyDatas);
		}
		/**
		*	eleId,要插入到其后的元素Id
		*	tdValues,要插入的值，二维属组
		*   比如，要在id=“target”的tr后边添加行，择eleid就是target
		*   tdValues可以为空，默认添加一行空白值,列数和target的列数相同，否则
		*   要添加的行数为tdValues.length,列数为tdValues[0].length
		**/
		function initTR(eleId,tdValues){
			var targetElement=$("#"+eleId);
			var rowNum=1;
			var colNum=1;
			var tdData=[[]];
			if(targetElement){//如果该id元素存在，开始添加行，否则不进行操作。
				if(tdValues == undefined||tdValues == null||tdValues.length==0){
					colNum=$("#"+eleId+">td").length;
					for(var c=0;c<colNum;c++){
						tdData[0].push("");
					}
				}else{
					tdData=tdValues;
					rowNum=tdData.length;
					colNum=tdData[0].length;
				}
				for(var i=0;i<rowNum;i++){
					var tr=document.createElement("tr");
					for(var j=0;j<colNum;j++){
						var td=document.createElement("td");
						td.innerHTML=nullToSpace(tdData[i][j]);
						$(tr).append(td);
					}
					$(targetElement).after(tr);
				}
			}
		}
		function initUploadFile(uploadFiles){
			var uploadFile=$("#uploadFile");
			if(uploadFiles==null)return;
			for(var i=0;i<uploadFiles.length;i++){
				var a=document.createElement("a");
				///a.href=uploadFiles[i].SAVEPATH;
				//a.innerHTML=uploadFiles[i].FILENAME;
				a.title=uploadFiles[i].FILENAME;
				a.className="attach clear";
				a.href=contextPath + "/businessmanage/BusinessFileDL.do?batchNo="+uploadFiles[i].BATCHNO;
				var img=document.createElement("img");
				img.src="../common/images/ms-attach.png";
				var span=document.createElement("span");
				span.innerHTML=uploadFiles[i].FILENAME;
				$(a).append(img);
				$(a).append(span);
				$(uploadFile).append(a);
			}
		}
		/**
			选择是否跳过请款审批
		**/
		function expIsJump(num){
			expJumpNum=num;
		}
		/**
		选择是否跳过借支审批
		**/
		function loanIsJump(num){
			loanJumpNum=num;
		}
		/**
		空值替换，默认替换为""
		**/
		function nullToSpace(nullData,replaceData){
			newData="";
			if(replaceData)newData=replaceData;
			return nullData==null?newData:nullData;
		}
		/**
		空值替换，默认替换为"0"
		**/
		function nullToZero(nullData,replaceData){
			newData="0";
			if(replaceData)newData=replaceData;
			return nullData==null?newData:nullData;
		}
		/**
		替换前后的空格
		**/
		function trim(s){
			return s.replace(/(^\s*)|(\s*$)/g,"");
		}
		
		//审批通过
		function approveAgent(){
			fm.checkResult.value="yes";
			fm.expJump.value=expJumpNum;
			fm.loanJump.value=loanJumpNum;
			fm.applyNo.value=batchNo;
			fm.workListID.value=workListID;
			fm.target="fraSubmit";
			fm.action = contextPath+"/businessmanage/BusinessSpInput.do";
			var showStr="正在保存数据，请您稍候并且不要修改屏幕上的值或链接其他页面";
			var urlStr="../common/jsp/MessagePage.jsp?picture=C&content=" + showStr ;
			showInfo=window.showModelessDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
			fm.submit(); 
		}
		/*******************
		 * 返回用户按钮操作 *
		 *******************/
		function returnUser(){
			fm.applyNo.value=batchNo;
			fm.workListID.value=workListID;
			if(trim(fm.advice.value)==""){
				alert("返回用户时,审批意见不能为空!");
				fm.advice.focus();
				return false;
			}
			fm.operate.value="returnUser";
			fm.checkResult.value="no";	
			fm.target="fraSubmit";
			fm.action = contextPath+"/businessmanage/BusinessSpInput.do";
			var showStr="正在处理数据，请您稍候...";
			var urlStr="../common/jsp/MessagePage.jsp?picture=C&content=" + showStr ;
			showInfo=window.showModelessDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
			fm.submit();
		}
		/**************
		 * 取消按钮操作
		 **************/
		function cancelClick()
		{
			if(typeof(top.opener)!="undefined"){
		  		try{
		  			top.opener.focus();
		  		}catch(e){
		  		}
			}
			top.close();
		}
		/***********************
		 **提交返回后执行的操作*
		 ***********************/
		function afterSubmit( rFlag, rMessage )
		{
			try{
				showInfo.close();
				window.focus();
			}catch(e){
			}
			if (rFlag == "Fail" )
			{
				var urlStr="../common/jsp/MessagePage.jsp?picture=F&content=" + rMessage ;
				showModalDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
			}
			if (rFlag == "Success" )
			{
				var urlStr="../common/jsp/MessagePage.jsp?picture=S&content=" + rMessage ;
				showModalDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
				top.opener.queryClick();
				top.opener.focus();
				top.close();
			}
		} 
</script>
</head>
<body>
	<form name="fm" >
	<div class="top">
		<div class="top-content clear">
			<img src="../common/images/ms-head-left.jpg">
			<span class="fs-bold">民生人寿保险股份有限公司</span>
		</div>
	</div>
	<div class="contain">
		<div class="contain-content">
			<div class="content-title clear">
				<span class="title-span fs-bold float-left">动支申请管理</span>
				<span class="float-right ">
					<input type="button"  value="审批通过" onclick="checkSession();approveAgent()">
					<input type="button"  value="退回" onclick="checkSession();returnUser()">
					<input type="button"  value="取消" onclick="cancelClick()">
				</span>
			</div>
			<div class="content-info">
				<p class="fs-bold">民生人寿保险股份有限公司</p>
				<p class="fs-bold">签报</p>
				<table class="top-table" cellpadding="0" cellspacing="0" >
					<col style="width: 15%">
					<col style="width: 30%">
					<col style="width: 15%">
					<col style="width: 40%">
					<tbody>
						<tr>
							<td class=""><span class="red-left-border fs-bold">申请日期:</span></td>
							<td id="applyDate"></td>
							<td class="td-left fs-bold">申请编号:</td>
							<td id="applyNo"></td>
						</tr>
						<tr>
							<td class=""><span class="red-left-border fs-bold">申请人:</span></td>
							<td id="userName" name="userName"></td>
							<td class="td-left fs-bold">电话:</td>
							<td id="telePhone"></td>
						</tr>
						<tr>
							<td class=""><span class="red-left-border fs-bold">公司:</span></td>
							<td id="comName" ></td>
							<td class="td-left fs-bold">部门:</td>
							<td id="deptName" name="deptName"></td>
						</tr>
					</tbody>
				</table>
				<table class="table-one print-table" cellpadding="0" cellspacing="0" >
					<col style="width: 15%">
					<col style="width: 40%">
					<col style="width: 15%">
					<col style="width: 30%">
					<tbody>
						<tr>
							<td class="fs-bold">申请部门</td>
							<td  id="applyDeptName" name="deptName"></td>
							<td class="fs-bold">申请人</td>
							<td id="applyUserName" name="userName"></td>
						</tr>
						<tr>
							<td class="fs-bold">动支金额</td>
							<td colspan="3" class="td-left" id="applyMoney"></td>
						</tr>
						<tr>
							<td class="fs-bold">报销事项</td>
							<td colspan="3" class="td-left" id="describe"></td>
						</tr>
						<tr>
							<td class="fs-bold">详细说明</td>
							<td colspan="3" class="td-left" id="detailDesScript"></td>
						</tr>
					</tbody>
				</table>
				<table class="table-two print-table" >
					<col style="width: 33.3%">
					<col style="width: 33.3%">
					<col style="width: 33.4%">
					<tbody id>
						<tr>
							<td colspan="3" class="bg-gray">分摊明细</td>
						</tr>
						<tr id="splitTitle">
							<td class="fs-bold">分摊公司</td>
							<td class="fs-bold">分摊部门</td>
							<td class="fs-bold">分摊金额</td>
						</tr>
					</tbody>
				</table>
				<table class="table-three print-table">
					<col style="width: 20%">
					<col style="width: 20%">
					<col style="width: 20%">
					<col style="width: 20%">
					<col style="width: 20%">
					<tbody>
						<tr>
							<td colspan="5" class="fs-bold bg-gray">附件信息</td>
						</tr>
						<tr>
							<td colspan="5" id="uploadFile">
								<!--  <a  class="attach clear" title="aaas.jpg">
									<img src="attach.png">
									<span>aaa.jpg</span>
								</a>   -->
							</td>
						</tr>
						<tr>
							<td colspan="5" class="fs-bold bg-gray">预算信息</td>
						</tr>
						<tr id="budgetTitle">
							<td>预算科目</td>
							<td>预算总额</td>
							<td>可用金额</td>
							<td>冻结金额</td>
							<td>支出金额</td>
						</tr>
						<tr>
							<td colspan="5" class="fs-bold bg-gray">审批记录</td>
						</tr>
						<tr id="historyTitle">
							<td>审批日期</td>
							<td>审批环节</td>
							<td>审批人</td>
							<td>审批结果</td>
							<td>备注</td>
						</tr>
					</tbody>
				</table>
				<div class="clear bg-gray margin-top-bottom">
					<div class="float-left">
						<span class="td-left">后续报销是否审批</span>
						<span>
							<span class="span-btn active " onclick="btn();expIsJump(1)">是</span>
							<span class="span-btn " onclick="btn();expIsJump(0)">否</span>
						</span>
					</div>
					<div class="float-right">
						<span class="td-left">后续借款是否审批</span>
						<span>
							<span class="span-btn active" onclick="btn();loanIsJump(1)">是</span>
							<span class="span-btn " onclick="btn();loanIsJump(0)">否</span>
						</span>
					</div>
				</div>
				<div>
					<span class="red-left-border fs-bold">审批意见:</span>
					<br>
					<textarea class="bg-gray" name="advice" rows=4 style="border:0px;margin: 20px auto;width:98%;overflow:hidden;padding: 1% " ></textarea>
				</div>
				<div class="content-title clear">
					<span class="float-right ">
						<input type="button"  value="审批通过" onclick="checkSession();approveAgent()">
						<input type="button"  value=" 退回 " onclick="checkSession();returnUser()">
						<input type="button"  value=" 取消 " onclick="cancelClick()">
					</span>
				</div>
			</div>
		</div>
	</div>
	<input type="hidden" name="expJump">
	<input type="hidden" name="loanJump">
	<input type="hidden" name="checkResult">
	<input type="hidden" name="workListID">
	<input type="hidden" name="applyNo">
	<input type="hidden" name="operate">
	<input type="hidden" name="batchNo">
	</form>
</body>
</html>