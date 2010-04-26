<%@ include file="../includes/init.jsp"%>
<%@ taglib prefix="charm" uri="/tld/charm"%>
<html>
<head>


<title><fmt:message key="logmanager.title" /></title>


<style type="text/css">
minTable {
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
    font-family : courier;
    font-size : 10pt;
}
.adminTable .jive-odd TD {
    background-color : #fff;
}
.adminTable .jive-even TD {
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

<div class="adminTable">
<table width="100%"	cellpadding="" cellspacing="0">
	<thead>
		<tr>
			<th><fmt:message key="logviewer.number"/></th>
			<th><fmt:message key="logviewer.level"/></th>
			<th><fmt:message key="logviewer.date"/></th>
			<th><fmt:message key="logviewer.line"/></th>
		</tr>
	</thead>
	<tbody>
	
		<c:forEach var="item" items="${lines}" varStatus="loop">
					<tr class="even">
						<td>${item.number}</td>
						<td>${item.level}</td>
						<td><fmt:formatDate pattern="MM/dd/yy HH:mm:ss" value="${item.date}" /></td>
						<td>${item.line}</td>
					</tr>
		</c:forEach>
	</tbody>
</table>
</div>

</body>
</html>
