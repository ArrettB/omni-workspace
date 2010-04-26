
<%@ page session="true"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x"         uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"        uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql"       uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"  %>
<%@ taglib prefix="page"      uri="http://www.opensymphony.com/sitemesh/page" %>
<%@ taglib prefix="display"   uri="http://displaytag.sf.net" %>
<%@ taglib prefix="charm"     uri="/tld/charm" %>

<html>
<head>
<title>Job Cost Report</title>
<link rel="stylesheet" href="<c:url value="/css/displaytag.css"/>" type="text/css" media="screen, print" />

  <script type="text/javascript" src="<c:url value="/js/yui/yahoo/yahoo.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/dom/dom.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/event/event.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/container/container.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/calendar/calendar.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/charm/calendar.js"/>"></script>
  <link rel="stylesheet" type="text/css" href="<c:url value="/js/yui/calendar/assets/calendar.css"/>" /> 

<meta HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE" /> 

<script type="text/javascript">
YAHOO.util.Event.addListener(window, 'load', setDefaultDates);

function setDefaultDates()
{
	var startDateInput = YAHOO.util.Dom.get('p_start_date');
	var endDateInput = YAHOO.util.Dom.get('p_end_date');

	if (startDateInput.value == '')
	{
		var endDate = new Date();
		
		var startDate = new Date();
		startDate.setDate(startDate.getDate()- 14); // two weeks back
		
		startDateInput.value = formatDate(startDate);
		endDateInput.value = formatDate(endDate);
		
	}
}


function formatDate(theDate)
{
	if (theDate)
		return this.quickPad(theDate.getMonth() + 1) + "/" + this.quickPad(theDate.getDate()) + "/" + theDate.getFullYear();
	  else
		return "";
}

function quickPad(num)
{
	if (num > 9)
		return num;
	else
		return "0" + num;
}

</script>



</head>
<body>

<h2>Posted Job Profitability Report</h2>
<form name="reportForm" method="POST" action="posted_job_profitability_report.html">
<input type="hidden" name="submitted" value="Y">
<table border="0" cellspacing="0" cellpading="0" class="reportParamTable">
<thead>
<tr><th colspan="2" class="reportParamHead">Report Parameters</th></thead>
<tbody>
	<tr>
		<td class="label">Start Date</td>
		<td class="control"><charm:calendar name="p_start_date" value="${param.p_start_date}" /></td>
		</tr>
		<tr>
		<td class="label">End Date</td>
		<td class="control"><charm:calendar name="p_end_date" value="${param.p_end_date}"/></td>
	</tr>	
</tbody>
	
</table>

<input type="submit" value="Run Report">

</form>

<c:choose>
	<c:when test="${param.submitted != 'Y'}">

	<div id="message">
	Please choose a date range to run the report.
	</div>

	</c:when>
	<c:otherwise>

		<charm:queryService var="result"
			namedQueryId="reports.posted_job_cost.single_org">
			<charm:parameter name="organization_id" value="${sessionScope['com.dynamic.servicetrax.interceptors.LoginInterceptor.loginCrediantials'].organizationId}" />
			<charm:parameter name="start_date" value="${param.p_start_date}" />
			<charm:parameter name="end_date" value="${param.p_end_date}" />
		</charm:queryService>

		<display:table name="${result}" export="true" id="row"  class="bodytable" pagesize="100" requestURI="posted_job_profitability_report.html" varTotals="totals">

			<display:setProperty name="basic.msg.empty_list">
				<div id="message">No data returned for that date range.</div>
			</display:setProperty>
			<display:setProperty name="basic.empty.showtable" value="false" />
			<display:setProperty name="paging.banner.items_name" value="jobs" />
			<display:setProperty name="paging.banner.item_name" value="job" />
			<display:setProperty name="export.types" value="csv pdf rtf xml" />
			
  			<display:column property="job no" title="Job No" sortable="true" />
  			<display:column property="job type" title="Job Type" sortable="true" />
			<display:column property="customer name" title="Customer" sortable="true" />
			<display:column property="end user name" title="End User" sortable="true" />
			<display:column property="posted by" title="Posted By" sortable="true" />
			<display:column property="posted date" title="Date Posted" sortable="true" format="{0,date,MM/dd/yyyy}"/>
			<display:column property="total invoiced" title="Total Invoiced" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="total cost" title="Total Cost" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="labor cost" title="Labor Cost" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="truck cost" title="Truck Cost" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="sub cost" title="Sub Cost" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="expense cost" title="Expense Cost" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" total="true" />
			<display:column property="gross_profit" title="Gross Profit" style="text-align:right;" format="{0,number,$#,##0.00}" sortable="true" />
			<display:column property="gross_profit_pct" title="Gross Profit %" style="text-align:right;" format="{0,number,##0.00%}" sortable="true" />
			<display:column property="cost_pct" title="Cost %" style="text-align:right;" format="{0,number,##0.00%}" sortable="true" />
			<display:column property="job owner" title="Owner" sortable="true" />
			<display:column property="job supervisor" title="Supervisor" sortable="true" />
			<display:column property="sp sales" title="SP Sales" sortable="true" />
			
			<display:footer media="html">
				<tr style="font-weight:bold;">
					<td>Totals:</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>  		
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column7} "/></td>   			
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column8} "/></td>   		
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column9} "/></td>   		
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column10} "/></td>   		
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column11} "/></td>  
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${totals.column12} "/></td> 
					<%-- gross profit = invoiced - cost --%>
					<td style="text-align:right;"><fmt:formatNumber type="currency" value="${(totals.column7 - totals.column8)}"/></td>   		
					<%-- gross profit pct = invoiced - cost / invoiced--%>
					<td style="text-align:right;"><fmt:formatNumber pattern="##0.00%" value="${(totals.column7 - totals.column8) / totals.column7}"/></td>   		
					<%-- cost pct = cost / invoiced --%>
					<td style="text-align:right;"><fmt:formatNumber pattern="##0.00%" value="${totals.column8 / totals.column7}"/></td>   		
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</display:footer>


		</display:table>
	</c:otherwise>
</c:choose>


</body>
</html>
