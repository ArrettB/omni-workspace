
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


</head>
<body>

<h2>Reports</h2>

<div id="message">
Please choose a report to run.
</div>

<div class="itemList">

<ul>
<li>
<a href="<c:url value="job_profitability_report.html"/>">Job Profitability</a> </br>
</li>

<li>
<a href="<c:url value="posted_job_profitability_report.html"/>">Posted Job Profitability</a> </br>
</li>
</ul>
</div>

</body>
</html>
