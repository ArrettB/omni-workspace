<%@ include file="../includes/init.jsp" %>

<html>
<head>
<title>Table Example</title>
  <script type="text/javascript" src="<c:url value="/js/yui/yahoo/yahoo.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/dom/dom.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/event/event.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/container/container.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/calendar/calendar.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/charm/calendar.js"/>"></script>
  <link rel="stylesheet" type="text/css" href="<c:url value="/js/yui/calendar/assets/calendar.css"/>" /> 
</head>
<body>


<form name="searchForm" method="POST">
<table>
<tr>
<td>State</td>
<td>
<charm:dropdown name="state" currentValue="${param.state}" onchange="document.searchForm.submit();">
		<charm:options 
			dataService="jdbcService" 
			query="SELECT state_name, state_code FROM states ORDER BY state_name" 
			optionLabel="state_name"
			optionValue="state_code"
			/>
</charm:dropdown>
</td>
</tr>
</table>
</form>
	

<charm:queryService
var="result"
namedQueryId="citiesByState">
	<charm:parameter name="stateCode" value="${param.state}" />
</charm:queryService>

<display:table name="${result}" export="true" id="row" class="bodytable" pagesize="25" requestURI="tables.html">
  <display:column property="cityName" title="City" sortable="true" autolink="true"/>
  <display:column property="stateCode" title="State" sortable="true"/>
</display:table>

</body>
</html>



