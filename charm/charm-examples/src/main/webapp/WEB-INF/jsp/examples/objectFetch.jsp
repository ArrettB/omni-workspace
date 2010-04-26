<%@ include file="../includes/header.jsp" %>

<h1>JDBC Object Fetch:</h1>
 <charm:objectFetch
 	dataService="jdbcService"
 	var="jdbcResult"
 	identifier="1"
 	table="bbp_codes"
 	identifierName="code_id"
 	scope="page"
 />
 
<strong>Code:</strong> <c:out value="${jdbcResult.code}"/><br>
<strong>Description:</strong> <c:out value="${jdbcResult.description}"/><br>
<strong>Date Created:</strong> <c:out value="${jdbcResult.date_created}"/><br>


<h1>Hibernate Object Fetch:</h1>

 <charm:objectFetch
 	dataService="hibernateService"
 	var="hibernateResult"
 	identifier="1"
 	className="com.dynamic.skeleton.orm.BbpCodes"
 	scope="page"
 />
 
<strong>Code:</strong> <c:out value="${hibernateResult.code}"/><br>
<strong>Description:</strong> <c:out value="${hibernateResult.description}"/><br>
<strong>Date Created:</strong> <c:out value="${hibernateResult.dateCreated}"/><br>


<%@ include file="../includes/footer.jsp" %>
