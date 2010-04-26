<%@ include file="../includes/init.jsp"%>

<html>
<head>
<title><fmt:message key="sessionManager.title" /></title>

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

<div class="adminTable">
<table width="100%" cellpadding="" cellspacing="0">
	<thead>
		<tr>
			<th><fmt:message key="sessionManager.id" /></th>
			<th><fmt:message key="sessionManager.user" /></th>
			<th><fmt:message key="sessionManager.dateCreated" /></th>
			<th><fmt:message key="sessionManager.dateAccessed" /></th>
			<th><fmt:message key="sessionManager.host" /></th>
			<th><fmt:message key="sessionManager.ipAddress" /></th>
			<th><fmt:message key="sessionManager.agent" /></th>
			<th><fmt:message key="sessionManager.referer" /></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="item" items="${sessions}" varStatus="loop">
			<c:url value="/admin/sessions.html" var="sessionUrl">
				<c:param name="id" value="${item.id}" />
			</c:url>

			<c:choose>
				<c:when test="${loop.count % 2 == 0}">
					<tr class="even">
						<td><a href="${sessionUrl}">${item.id}</a></td>
						<td>${item.user}</td>
						<td><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.dateCreated}" /></td>
						<td><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.dateAccessed}" /></td>
						<td>${item.host}</td>
						<td>${item.ipAddress}</td>
						<td>${item.agent}</td>
						<td>${item.referer}</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr class="odd">
						<td><a href="${sessionUrl}">${item.id}</a></td>
						<td>${item.user}</td>
						<td><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.dateCreated}" /></td>
						<td><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.dateAccessed}" /></td>
						<td>${item.host}</td>
						<td>${item.ipAddress}</td>
						<td>${item.agent}</td>
						<td>${item.referer}</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</tbody>
</table>
</div>

<br>
<br>
<br>

<c:if test="${param.id != null}">
	<div class="adminTable">
	<table width="100%" cellpadding="" cellspacing="0">
		<thead>
			<tr>
				<th colspan="2"><fmt:message key="sessionManager.selectedSession"/>&nbsp;${param.id} </th>
		</tr>
		<tr>
			<th><fmt:message key="sessionManager.attributeName" /></th>
			<th><fmt:message key="sessionManager.attributeValue" /></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${selectedSession}" var="entry" varStatus="loop">
		<c:choose>
			<c:when test="${loop.count % 2 == 0}">
				<tr class="even">
					<td><c:out value="${entry.key}" /></td>
					<td><c:out value="${entry.value}" /></td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr class="even">
					<td><c:out value="${entry.key}" /></td>
					<td><c:out value="${entry.value}" /></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	</tbody>
</table>
</div>
</c:if>

</body>
</html>
