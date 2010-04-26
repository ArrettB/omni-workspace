
<script type="text/javascript">
function toggleLayer(whichLayer)
{
	if (document.getElementById)
	{
		// this is the way the standards work
		var style2 = document.getElementById(whichLayer).style;
		style2.display = style2.display? "":"block";
	}
	else if (document.all)
	{
		// this is the way old msie versions work
		var style2 = document.all[whichLayer].style;
		style2.display = style2.display? "":"block";
	}
	else if (document.layers)
	{
		// this is the way nn4 works
		var style2 = document.layers[whichLayer].style;
		style2.display = style2.display? "":"block";
	}
}
</script>

<style type="text/css">
	div#debugInfo
	{
		margin: 0px 20px 0px 20px;
		display: none;
	}
</style>

<span style="font-family:Verdana,Helvitica,Sans-Serif;font-size:7pt">
<a href="javascript:toggleLayer('debugInfo');" title="View Debug Information For This Page">Show Debug</a>
</span>

<div id="debugInfo">


<h2>pageContext</h2>
<c:out value="${pageContext}"/><br/>

<h2>pageScope</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${pageScope}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<h2>requestScope</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${requestScope}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<h2>sessionScope</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${sessionScope}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<h2>Application Scope - ${applicationScope}</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${applicationScope}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<h2>Parameters - ${param}</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${param}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>


<h2>Header - ${header}</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${header}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>




<h2>cookie</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${cookie}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>

<h2>initParams</h2>
<table cellspacing="0" cellpadding="0" border="1" class="bodytable" >
<thead>
	<tr>
	<th>Key</th>
	<th>Value</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${initParam}" var="entry" varStatus="loop" >
	<c:choose>
	   <c:when test="${loop.count % 2 == 0}">
	     <tr class="even"> 
	   </c:when> 
	   <c:otherwise>
	      <tr class="odd"> 
	   </c:otherwise>
	 </c:choose> 
    <td align="left"><c:out value="${entry.key}"/></td>
    <td align="left" width="500"><c:out value="${entry.value}"/></td>
</tr>
</c:forEach> 
</tbody>
</table>

<h2>Class path list:</h2>
<c:forTokens
 items="${applicationScope['org.apache.catalina.jsp_classpath']}"
 delims=";" var="entry">
 <c:out value="${entry}"/><br/>
</c:forTokens>


</div>
