<%@ include file="../includes/init.jsp"%>
<html>
<head>

<c:if test="${param.refresh != null && param.refresh != 'none'}">
	<meta http-equiv="refresh" content="${param.refresh}">
</c:if>


<title><fmt:message key="logmanager.title" /></title>


<style type="text/css">

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
.adminTable TD  .odd {
    background-color : #fff;
}
.adminTable TD .even {
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

	IFRAME {
    border : 1px #666 solid;
}
	
</style>

</head>

<body>

Directory: ${logDirectory}

<div class="managerContainer">
<form method="POST" action='<c:url value="logManager.html" />'>
<input type="hidden" name="file" value="${param.file}">
<table>
	<tr>
		<td><fmt:message key="logmanager.order" /></td>
		<td><input type="radio" name="order" value="asc"
			onclick="this.form.submit();" id="rb1"> <label for="rb1"><fmt:message
			key="logmanager.asc" /></label> <input type="radio" name="order"
			value="desc" onclick="this.form.submit();" id="rb2"> <label for="rb2"><fmt:message
			key="logmanager.desc" /></label></td>
	
	</tr>
	<tr>
		<td><fmt:message key="logmanager.numlines" /></td>
		<td><charm:dropdown id="numLines" name="numLines" currentValue="${param.numLines}" onChange="this.form.submit();">
			<charm:option name="50" value="50" />
			<charm:option name="100" value="100" />
			<charm:option name="250" value="250" />
			<charm:option name="500" value="500" />
		</charm:dropdown></td>
	</tr>
	<tr>
		<td><fmt:message key="logmanager.refresh" /></td>
		<td><charm:dropdown id="refresh" name="refresh"
			currentValue="${param.refresh}" onChange="this.form.submit();">
			<charm:option name="none" value="none" />
			<charm:option name="5" value="5" />
			<charm:option name="10" value="10" />
			<charm:option name="15" value="15" />
			<charm:option name="30" value="30" />
			<charm:option name="60" value="60" />
		</charm:dropdown></td>
	</tr>
</table>
</form>
</div>
<form action=""></form>

<div class="adminTable">
<table
	width="100%"
	cellpadding="" cellspacing="0">
	<thead>
		<tr>
			<th><fmt:message key="logmanager.filename" /></th>
			<th><fmt:message key="logmanager.lastmodified" /></th>
			<th><fmt:message key="logmanager.size" /></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="item" items="${files}" varStatus="loop">
			<c:url value="logManager.html" var="fileUrl">
				<c:param name="numLines" value="${param.numLines }" />
				<c:param name="lines" value="${param.numLines }" />
				<c:param name="refresh" value="${param.refresh }" />
				<c:param name="file" value="${item.fileName}" />
			</c:url>

			<c:choose>
				<c:when test="${loop.count % 2 == 0}">
					<tr class="even">
						<td><a href="${fileUrl}">${item.fileName}</a></td>
						<td nowrap><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.lastModified}" /></td>
						<td>${item.numBytesString}</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr class="odd">
						<td><a href="${fileUrl}">${item.fileName}</a></td>
						<td nowrap><fmt:formatDate pattern="MM/dd/yy hh:mm aaa" value="${item.lastModified}" /></td>
						<td>${item.numBytesString}</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</tbody>
</table>
</div>

<br><br><br>

<c:url value="logManager.html" var="iframeUrl">
	<c:param name="mode" value="display" />
	<c:param name="numLines" value="${param.numLines}" />
	<c:param name="file" value="${param.file}" />
</c:url>

<iframe src="${iframeUrl}" frameborder="0" height="400" width="100%"
	marginheight="0" marginwidth="0" scrolling="auto"></iframe>

</body>
</html>
