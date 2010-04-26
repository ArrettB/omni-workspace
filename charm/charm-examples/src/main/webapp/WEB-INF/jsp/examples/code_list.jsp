<%@ include file="../includes/header.jsp" %>

<h1>Code Listing</h1>

 <charm:queryService
  	var="result"
 	namedQueryId="hib.allCodes"
 >
</charm:queryService>


<display:table name="result" export="true" id="row" class="bodytable" requestURI="code_list.html">
  <display:column property="code" href="code_detail.html" paramId="codeId" paramProperty="codeId" sortable="true" />
  <display:column property="description" sortable="true"/>
  <display:column property="dateCreated" title="Date Created" sortable="true" />
  <display:column property="dateModified" title="Date Modified" sortable="true" />
</display:table>


<c:url value="code_detail.html" var="new_url"/>

<form name="newCode" 
	  method="POST" 
	  action="<c:out value="${new_url}"/>"
>
<input type="submit" name="submit" value="Create New"/>
</form>


<%@ include file="../includes/footer.jsp" %>    