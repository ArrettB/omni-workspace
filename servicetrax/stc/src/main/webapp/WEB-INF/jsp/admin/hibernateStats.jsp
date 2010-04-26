<%@ include file="../includes/init.jsp"%>

<html>
<head>
<title>Statistics Page</title>

<ul>
<li><a href="<c:url value="/admin/dataSources.html"/>">Data Sources</a></li>
<li><a href="<c:url value="/admin/hibernateStats.html"/>">Hibernate Stats</a></li>
<li><a href="<c:url value="sessions.html"/>">Sessions</a></li>
</ul>

<style type="text/css">

table
{
	font:normal 76%/150% "Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif;
	border-collapse:separate;
	border-spacing:0;
	margin:0 0 1em;
	color:#000;
	}
table a {
	color:#523A0B;
	text-decoration:none;
	border-bottom:1px dotted;
	}
table a:visited {
	color:#444;
	font-weight:normal;
	}
table a:visited:after {
	content:"\00A0\221A";
	}
table a:hover {
	border-bottom-style:solid;
	}
thead th,
thead td,
tfoot th,
tfoot td {
	border:1px solid #523A0B;
	border-width:1px 0;
	background:#EBE5D9;
	}
th {
	font-weight:bold;
	line-height:normal;
	padding:0.25em 0.5em;
	text-align:left;
	}
tbody th,
td {
	padding:0.25em 0.5em;
	text-align:left;
	vertical-align:top;
	}
tbody th {
	font-weight:normal;
	white-space:nowrap;
	}
tbody th a:link,
tbody th a:visited {
	font-weight:bold;
	}
tbody td,
tbody th {
	border:1px solid #fff;
	border-width:1px 0;
	}
tbody tr.odd th,
tbody tr.odd td {
	border-color:#EBE5D9;
	background:#F7F4EE;
	}
tbody tr:hover td,
tbody tr:hover th {
	background:#ffffee;
	border-color:#523A0B;
	}
caption {
	font-family:Georgia,Times,serif;
	font-weight:normal;
	font-size:1.4em;
	text-align:left;
	margin:0;
	padding:0.5em 0.25em;
	}
</style>

</head>

<body>


<table
	style="border-left:1px solid #523A0B;border-right:1px solid #523A0B;border-bottom:1px solid #523A0B;"
	cellpadding="" cellspacing="0">
	<thead>
		<tr>
			<th>Query</th>
			<th style="text-align:right;">Num Times</th>
			<th style="text-align:right;">Avg (ms)</th>
			<th style="text-align:right;">Min (ms)</th>
			<th style="text-align:right;">Max (ms)</th>
			<th style="text-align:right;">Cache Hits</th>
			<th style="text-align:right;">Cache Misses</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="item" items="${statistics}" varStatus="loop">
			<c:choose>
				<c:when test="${loop.count % 2 == 0}">
					<tr class="even">
				</c:when>
				<c:otherwise>
					<tr class="odd">
				</c:otherwise>
			</c:choose>
			<td><pre>${item.query}</pre></td>
			<td style="text-align:right;">${item.executionCount}</td>
			<td style="text-align:right;">${item.executionAvgTime}</td>
			<td style="text-align:right">${item.executionMinTime}</td>
			<td style="text-align:right;">${item.executionMaxTime}</td>
			<td style="text-align:right;">${item.cacheHitCount}</td>
			<td style="text-align:right;">${item.cacheMissCount}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<form method="POST" action="<c:url value="/admin/hibernateStats.html"/>" >
<input type="hidden" name="clearCache" value="true" />
<input type="submit" name="submit" value="Clear Cache">
</form>


</body>
</html>
