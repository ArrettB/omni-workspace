<%@ include file="../includes/init.jsp" %>
<html>
<head>
<title>Date Picker Example</title>
  <script type="text/javascript" src="<c:url value="/js/yui/yahoo/yahoo.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/dom/dom.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/event/event.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/container/container.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/yui/calendar/calendar.js"/>"></script>
  <script type="text/javascript" src="<c:url value="/js/charm/calendar.js"/>"></script>
  <link rel="stylesheet" type="text/css" href="<c:url value="/js/yui/calendar/assets/calendar.css"/>" /> 
</head>
<body>

<table>
<tr>
<td>Start Date</td>
<td> <charm:calendar name="startDate" /></td>
</tr>
<tr>
<td>End Date</td>
<td> <charm:calendar name="endDate" /></td>
</tr>
<td>A Select</td>
<td><select name="test">
<option value="1">This is a very very long option 1</option>
<option value="2">This is a very very long option 2</option>
<option value="3">This is a very very long option 3</option>
<option value="4">This is a very very long option 4</option>
</select>

</td>
</table>



</body>
</html>




