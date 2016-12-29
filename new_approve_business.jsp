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

	//jqueryajax�ص�����
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
			$("#telePhone").html(nullToSpace(detail[0].PHONE,"��"));
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
		*	eleId,Ҫ���뵽����Ԫ��Id
		*	tdValues,Ҫ�����ֵ����ά����
		*   ���磬Ҫ��id=��target����tr�������У���eleid����target
		*   tdValues����Ϊ�գ�Ĭ�����һ�пհ�ֵ,������target��������ͬ������
		*   Ҫ��ӵ�����ΪtdValues.length,����ΪtdValues[0].length
		**/
		function initTR(eleId,tdValues){
			var targetElement=$("#"+eleId);
			var rowNum=1;
			var colNum=1;
			var tdData=[[]];
			if(targetElement){//�����idԪ�ش��ڣ���ʼ����У����򲻽��в�����
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
			ѡ���Ƿ������������
		**/
		function expIsJump(num){
			expJumpNum=num;
		}
		/**
		ѡ���Ƿ�������֧����
		**/
		function loanIsJump(num){
			loanJumpNum=num;
		}
		/**
		��ֵ�滻��Ĭ���滻Ϊ""
		**/
		function nullToSpace(nullData,replaceData){
			newData="";
			if(replaceData)newData=replaceData;
			return nullData==null?newData:nullData;
		}
		/**
		��ֵ�滻��Ĭ���滻Ϊ"0"
		**/
		function nullToZero(nullData,replaceData){
			newData="0";
			if(replaceData)newData=replaceData;
			return nullData==null?newData:nullData;
		}
		/**
		�滻ǰ��Ŀո�
		**/
		function trim(s){
			return s.replace(/(^\s*)|(\s*$)/g,"");
		}
		
		//����ͨ��
		function approveAgent(){
			fm.checkResult.value="yes";
			fm.expJump.value=expJumpNum;
			fm.loanJump.value=loanJumpNum;
			fm.applyNo.value=batchNo;
			fm.workListID.value=workListID;
			fm.target="fraSubmit";
			fm.action = contextPath+"/businessmanage/BusinessSpInput.do";
			var showStr="���ڱ������ݣ������Ժ��Ҳ�Ҫ�޸���Ļ�ϵ�ֵ����������ҳ��";
			var urlStr="../common/jsp/MessagePage.jsp?picture=C&content=" + showStr ;
			showInfo=window.showModelessDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
			fm.submit(); 
		}
		/*******************
		 * �����û���ť���� *
		 *******************/
		function returnUser(){
			fm.applyNo.value=batchNo;
			fm.workListID.value=workListID;
			if(trim(fm.advice.value)==""){
				alert("�����û�ʱ,�����������Ϊ��!");
				fm.advice.focus();
				return false;
			}
			fm.operate.value="returnUser";
			fm.checkResult.value="no";	
			fm.target="fraSubmit";
			fm.action = contextPath+"/businessmanage/BusinessSpInput.do";
			var showStr="���ڴ������ݣ������Ժ�...";
			var urlStr="../common/jsp/MessagePage.jsp?picture=C&content=" + showStr ;
			showInfo=window.showModelessDialog(urlStr,window,"status:no;help:0;close:0;dialogWidth:550px;dialogHeight:250px");
			fm.submit();
		}
		/**************
		 * ȡ����ť����
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
		 **�ύ���غ�ִ�еĲ���*
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
			<span class="fs-bold">�������ٱ��չɷ����޹�˾</span>
		</div>
	</div>
	<div class="contain">
		<div class="contain-content">
			<div class="content-title clear">
				<span class="title-span fs-bold float-left">��֧�������</span>
				<span class="float-right ">
					<input type="button"  value="����ͨ��" onclick="checkSession();approveAgent()">
					<input type="button"  value="�˻�" onclick="checkSession();returnUser()">
					<input type="button"  value="ȡ��" onclick="cancelClick()">
				</span>
			</div>
			<div class="content-info">
				<p class="fs-bold">�������ٱ��չɷ����޹�˾</p>
				<p class="fs-bold">ǩ��</p>
				<table class="top-table" cellpadding="0" cellspacing="0" >
					<col style="width: 15%">
					<col style="width: 30%">
					<col style="width: 15%">
					<col style="width: 40%">
					<tbody>
						<tr>
							<td class=""><span class="red-left-border fs-bold">��������:</span></td>
							<td id="applyDate"></td>
							<td class="td-left fs-bold">������:</td>
							<td id="applyNo"></td>
						</tr>
						<tr>
							<td class=""><span class="red-left-border fs-bold">������:</span></td>
							<td id="userName" name="userName"></td>
							<td class="td-left fs-bold">�绰:</td>
							<td id="telePhone"></td>
						</tr>
						<tr>
							<td class=""><span class="red-left-border fs-bold">��˾:</span></td>
							<td id="comName" ></td>
							<td class="td-left fs-bold">����:</td>
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
							<td class="fs-bold">���벿��</td>
							<td  id="applyDeptName" name="deptName"></td>
							<td class="fs-bold">������</td>
							<td id="applyUserName" name="userName"></td>
						</tr>
						<tr>
							<td class="fs-bold">��֧���</td>
							<td colspan="3" class="td-left" id="applyMoney"></td>
						</tr>
						<tr>
							<td class="fs-bold">��������</td>
							<td colspan="3" class="td-left" id="describe"></td>
						</tr>
						<tr>
							<td class="fs-bold">��ϸ˵��</td>
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
							<td colspan="3" class="bg-gray">��̯��ϸ</td>
						</tr>
						<tr id="splitTitle">
							<td class="fs-bold">��̯��˾</td>
							<td class="fs-bold">��̯����</td>
							<td class="fs-bold">��̯���</td>
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
							<td colspan="5" class="fs-bold bg-gray">������Ϣ</td>
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
							<td colspan="5" class="fs-bold bg-gray">Ԥ����Ϣ</td>
						</tr>
						<tr id="budgetTitle">
							<td>Ԥ���Ŀ</td>
							<td>Ԥ���ܶ�</td>
							<td>���ý��</td>
							<td>������</td>
							<td>֧�����</td>
						</tr>
						<tr>
							<td colspan="5" class="fs-bold bg-gray">������¼</td>
						</tr>
						<tr id="historyTitle">
							<td>��������</td>
							<td>��������</td>
							<td>������</td>
							<td>�������</td>
							<td>��ע</td>
						</tr>
					</tbody>
				</table>
				<div class="clear bg-gray margin-top-bottom">
					<div class="float-left">
						<span class="td-left">���������Ƿ�����</span>
						<span>
							<span class="span-btn active " onclick="btn();expIsJump(1)">��</span>
							<span class="span-btn " onclick="btn();expIsJump(0)">��</span>
						</span>
					</div>
					<div class="float-right">
						<span class="td-left">��������Ƿ�����</span>
						<span>
							<span class="span-btn active" onclick="btn();loanIsJump(1)">��</span>
							<span class="span-btn " onclick="btn();loanIsJump(0)">��</span>
						</span>
					</div>
				</div>
				<div>
					<span class="red-left-border fs-bold">�������:</span>
					<br>
					<textarea class="bg-gray" name="advice" rows=4 style="border:0px;margin: 20px auto;width:98%;overflow:hidden;padding: 1% " ></textarea>
				</div>
				<div class="content-title clear">
					<span class="float-right ">
						<input type="button"  value="����ͨ��" onclick="checkSession();approveAgent()">
						<input type="button"  value=" �˻� " onclick="checkSession();returnUser()">
						<input type="button"  value=" ȡ�� " onclick="cancelClick()">
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