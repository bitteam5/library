<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="description" content="비트 도서관">
<meta name="keyword" content="비트 도서관">
<meta name="copyright"
	content="COPYRIGHT(C) BIT LIBRARY. ALL RIGHTS RESERVED.">
<meta content="initial-scale=1, width=device-width" name="viewport">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>도서 상세페이지</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/main.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/mypagemenu.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/bookDetail.css">

<style>
#button {
	margin: -1px;
	border: 1px solid rgba(0, 155, 255, 0.9);
	background-color: rgba(0, 0, 0, 0);
	color: rgba(0, 155, 255, 0.9);
	padding: 3px;
	border-radius: 5px;
	font-size: 24px;
}
#button:hover{
	color:white;
	background-color: skyblue;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/top.jsp" flush="false"/>

<div id="divContentsW">
	<div id="divContents">
		<div id="divContent">
			<div class="searchDetail">
				<div class="searchLink">
					<form name="frmMylist" action="/mylist/writeitem" method="post" />
					 <ul class="searchLinkBtn">
						<button id="button" type="button" class="rent">대여</button>
						<button id="button" type="wishList" class="wish">위시리스트</button>
						<button id="button" type="button" class="reserve">예약</button>

					 </ul>
					  <div class="profile">
					   <c:forEach var="bookdt" items="${bookdt}">
						<div class="profileHeader">
							<h1>${bookdt.bookTitle}</h1>
							<h3>${bookdt.author}</h3>
						</div>
					   </c:forEach>
						<div class="profileContent">
							<div class="briefInfo">
							 <dl>
							  <dd class="bookImg">
							   <img id="coverimage" src="${bookdt[0].imagePath}" width="300"
									align="center">
							  </dd>
							 </dl>
							<span class="bookBg"></span>
						   </div>

						   <div class="table">
							<div id="divProfile">
							 <table class="profiletable">
							  <tbody>
								<tr>
								 <th scope="row">자료유형</th>
								  <td>${bookdt[0].type}</td>
								</tr>
								<tr>
								 <th scope="row">저&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자</th>
								  <td>${bookdt[0].author}</td>
								</tr>
								<tr>
								 <th scope="row">발행사항</th>
								  <td>${bookdt[0].pubYear}.${bookdt[0].publisher}</td>
								</tr>
							 </tbody>
							</table>

							</div>
							 <div class="searchInfo">
							  <div class="serchContents">
							   <div class="listTable">
								<table border="2" align="right" text-align="center">
								 <tr>
								  <th></th>
								  <th>도서번호</th>
								  <th>도서상태</th>
								  <th>예약여부</th>
								 </tr>
								 <c:forEach var="bookdtList" items="${bookdtList }">
								  <c:set var="reservest" value="${bookdtList.reserveStatus}" />
								  <c:set var="bookst" value="${bookdtList.rentStatus}" />
								   <c:choose>
								    <c:when test="${bookst == 2}">
								     <c:set var="bookstat" value="대여가능" />
								     <c:set var="reservestat" value="예약불가" />
								    </c:when>
								   <c:otherwise>
									<c:set var="bookstat" value="대여중" />
									 <c:choose>
									  <c:when test="${reservest == 0}">
										<c:set var="reservestat" value="예약가능" />
									  </c:when>
									<c:otherwise>
									 <c:set var="reservestat" value="예약불가" />
									</c:otherwise>
									 </c:choose>
									</c:otherwise>
								    </c:choose>

									 <tr>
									  <td class="num footable-first-column"><input
										  type="checkbox" name="check" id="check"
										  data-reservest="${reservest}"
										  data-bookNo="${bookdtList.bookNo}" value="${bookst}"
										  onclick="check_only(this)"></td>
									  <td>${bookdtList.bookNo}</td>
									  <td><c:out value="${bookstat}" /></td>
									  <td><c:out value="${reservestat}" /></td>
									 </tr>
								   </c:forEach>
								 </table>
							    </div>
							   </div>
							  </div>
							 </div>
						    </div>
						  </div>
					    </div>
					  </div>
				    </div>
				  </div>

	<script type="text/javascript">
		function check_only(check) {
			var obj = document.getElementsByName("check");
			for (var i = 0; i < obj.length; i++) {
				if (obj[i] != check) {
					obj[i].checked = false;
				}
			}
		}
	</script>

	<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>

	<script>
		$(".rent").click(function() {
			$("input[name=check]:checked").each(function() {
				if (this.value != "2") { //대여불가
					alert("대여가 불가능합니다.") // 4/4 오후 9시 여기까지 현재 가능.
				} else {
					var count = $("input[name=check]:checked").length;
					var no = new Array;
					$("input[name=check]:checked").each(function() {
						no.push($(this).attr("data-bookNo")); //체크된 것의 data-bookNo 값을 뽑아서 배열에 넣기
					});

					if (count == 0) { //아무것도 선택된 것이 없을때 alert 띄워주기
						alert("선택된 도서가 없습니다.")
					} else {//선택된 것이 있으면 controller로 값 넘겨주기

						$.ajaxSettings.traditional = true;
						$.ajax({
							url : "/lib/rent.do",
							type : "post",
							data : {chknos : no},
							success : function(data) {
								alert('선택하신 도서가 대여되었습니다!');
								console.log(data)
							},
							error : function(request, status, error){
								alert("code:" + request.status + "\n"
										+ "message : " + request.responseText
										+ "\n" + "error : " +error);
								
							},
						});
					}

				}
			});
		});

		$(".reserve").click(function() {
			$("input[name=check]:checked").each(function() {
				if ($(this).attr("data-reservest") != "0") { //예약불가
					alert("예약이 불가능합니다.") // 4/4 오후 9시 여기까지 현재 가능.
				} else {
					if (this.value == "2") {
						alert("예약이 불가능합니다.")
					} else {
						var count = $("input[name=check]:checked").length;
						var no = new Array;
						$("input[name=check]:checked").each(function() {
							no.push($(this).attr("data-bookNo")); //체크된 것의 data-bookNo 값을 뽑아서 배열에 넣기
						});

						if (count == 0) { //아무것도 선택된 것이 없을때 alert 띄워주기
							alert("선택된 도서가 없습니다.")
						} else {//선택된 것이 있으면 controller로 값 넘겨주기

							$.ajaxSettings.traditional = true;
							$.ajax({
								url : "/lib/reserve.do",
								type : "post",
								data : {chknos : no},
								success : function(data) {
									alert('선택하신 도서가 예약되었습니다!');
									consloe.log(data);
								},
								error : function(request, status, error){
									alert("code:" + request.status + "\n"
											+ "message : " + request.responseText
											+ "\n" + "error : " +error);
								
								},
							});
						}
					}
				}
				;
			})
		});
	</script>
</body>
</html>