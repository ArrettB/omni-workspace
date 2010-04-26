<%@ include file="../includes/header.jsp" %>

<%-- JDBC Test No Parameters   --%>
 <charm:queryService
  	var="result"
 	namedQueryId="allCodes"
 >
</charm:queryService>
<h1>JDBC Results (List):</h1>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable">
<thead>
	<tr>
	<th style="font-family:">Code</th>
	<th>Description</th>
	<th>Date Created</th>
	</tr>
</thead>
<tbody>
<c:forEach var="item" items="${result}" varStatus="loop">
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${item.code}"/></td>
    <td align="left"><c:out value="${item.description}"/></td>
    <td align="left"><fmt:formatDate value="${item.date_created}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>

<%-- JDBC Test With Parameter   --%>
 <charm:queryService
  	var="result"
 	namedQueryId="uniqueCode"
 >
<charm:parameter name="codeID" value="1"/>
</charm:queryService>
<h1>JDBC Results (Single):</h1>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable">
<thead>
	<tr>
	<th style="font-family:">Code</th>
	<th>Description</th>
	<th>Date Created</th>
	</tr>
</thead>
<tbody>
<c:forEach var="item" items="${result}">
  <tr class="odd"> 
    <td align="left"><c:out value="${item.code}"/></td>
    <td align="left"><c:out value="${item.description}"/></td>
    <td align="left"><fmt:formatDate value="${item.date_created}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>



<%-- Hibernate Test No Parameters   --%>
 <charm:queryService
  	var="result"
 	namedQueryId="hib.allCodes"
 >
</charm:queryService>
<h1>Hibernate Results (List):</h1>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable">
<thead>
	<tr>
	<th>Code</th>
	<th>Description</th>
	<th>Date Created</th>
	</tr>
</thead>
<tbody>
<c:forEach var="item" items="${result}" varStatus="loop">
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${item.code}"/></td>
    <td align="left"><c:out value="${item.description}"/></td>
    <td align="left"><fmt:formatDate value="${item.dateCreated}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>

<%-- Hibnerate Test With Parameter   --%>
 <charm:queryService
  	var="result"
 	namedQueryId="hib.uniqueCode"
 >
<charm:parameter name="codeID" value="1"/>
</charm:queryService>
<h1>Hibernate Results (Single):</h1>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable">
<thead>
	<tr>
	<th>Code</th>
	<th>Description</th>
	<th>Date Created</th>
	</tr>
</thead>
<tbody>
<c:forEach var="item" items="${result}">
  <tr class="odd"> 
    <td align="left"><c:out value="${item.code}"/></td>
    <td align="left"><c:out value="${item.description}"/></td>
    <td align="left"><fmt:formatDate value="${item.dateCreated}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<%@ include file="../includes/footer.jsp" %>