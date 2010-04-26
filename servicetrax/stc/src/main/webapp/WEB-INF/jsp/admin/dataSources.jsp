<%@ include file="../includes/init.jsp"%>

<html>
<head>
<title><fmt:message key="database.title" /></title>



<style type="text/css">


/* tables */

.adminTable {
    border-color : #bbb;
    border-style : solid;
    border-width : 1px 1px 0px 1px;
}
.adminTable .c1, fieldset .c1 {
    width : 30%;
}
.adminTable TH, .adminTable TD {
    padding : 4px;
}
.adminTable TH {
    background-color : #eee;
    border-bottom : 1px #bbb solid;
    border-right : 1px #bbb solid;
    text-align : left;
    font-family : verdana;
    font-size : 8pt;
    font-weight : bold;
}
.adminTable TR TD {
    border-bottom : 1px #ccc solid;
}
.adminTable TD {
    font-family : arial, helvetica, sans-serif;
    font-size : 10pt;
}
.adminTable .odd TD {
    background-color : #fff;
}
.adminTable .even TD {
    background-color : #fbfbfb;
}
.adminTable TFOOT TD {
    background-color : #ddd;
    font-family : verdana;
    font-size : 8pt;
    border-right : 1px #bbb solid;
}
.adminTable TD TD {
    border-width : 0px;
}
.adminTable INPUT, .adminTable SELECT {
    font-family : verdana;
    font-size : 8pt;
}


</style>

</head>

<body>

<ul>
<li><a href="<c:url value="/admin/dataSources.html"/>">Data Sources</a></li>
<li><a href="<c:url value="/admin/hibernateStats.html"/>">Hibernate Stats</a></li>
<li><a href="<c:url value="sessions.html"/>">Sessions</a></li>
</ul>

		<c:forEach items="${dataSources}" var="ds">

<div class="adminTable">
			<table width="100%" cellpadding="" cellspacing="0">
			<thead>
				<tr>
					<th colspan="2"><fmt:message key="database.datasourceName" />&nbsp;${ds.key} </th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${ds.value}" var="entry" varStatus="loop">
				<c:choose>
					<c:when test="${loop.count % 2 == 0}">
						<tr class="even">
							<td width="30%"><fmt:message key="${entry.key}" /></td>
							<td width="70%"><c:out value="${entry.value}" /></td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr class="even">
							<td width="30%"><fmt:message key="${entry.key}" /></td>
							<td width="70%"><c:out value="${entry.value}" /></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</c:forEach>
	</tbody>
</table>
</div>
<br><br>
		</c:forEach>
</body>
</html>
