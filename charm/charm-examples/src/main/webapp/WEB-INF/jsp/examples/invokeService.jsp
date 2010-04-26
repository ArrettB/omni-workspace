<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@page contentType="text/html" import="java.sql.Timestamp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Example List</title>
</head>
<body>

<%@ taglib prefix="charm" uri="/tld/charm"%>

String Test:
<charm:invokeService serviceName="invokeTestService" methodName="testString" var="stringTest">
	<charm:parameter name="param1" value="Additional&Text here" />
	<charm:parameter name="param2" value="Addi > tio n < al Text h\\> \> \& ere2222" />
</charm:invokeService>
<c:out value="${stringTest}" />
<br />

Integer Test:
<charm:invokeService serviceName="invokeTestService" methodName="testInteger" var="integerTest">
	<charm:parameter name="integerTest" value="123" />
</charm:invokeService>
<c:out value="${integerTest}" />
<br />


Double Test:
<charm:invokeService serviceName="invokeTestService" methodName="testDouble" var="doubleTest">
	<charm:parameter name="param1" value="4.94065645841246544e-324" />
</charm:invokeService>
<c:out value="${doubleTest}" />
<br />


Float Test:
<charm:invokeService serviceName="invokeTestService" methodName="testFloat" var="floatTest">
	<charm:parameter name="param1" value="3.40282346638528860e+38" />
</charm:invokeService>
<c:out value="${floatTest}" />
<br />


boolean Test:
<charm:invokeService serviceName="invokeTestService" methodName="testBoolean" var="booleanTest">
	<charm:parameter name="param1" value="false" />
</charm:invokeService>
<c:out value="${booleanTest}" />
<br />


Date Test 1:
<charm:invokeService serviceName="invokeTestService" methodName="testTimestamp" var="result3">
	<charm:parameter name="param1" value="2005-12-22 13:10:00" />
</charm:invokeService>
<c:out value="${result3}" />
<br />
<fmt:formatDate value="${result3}" />
<br />


Date Object Test 1:
<charm:invokeService serviceName="invokeTestService" methodName="testTimestamp" var="timestampTest">
	<charm:parameter name="param1" value="<%= new java.sql.Timestamp(123456) %>" />
</charm:invokeService>
<c:out value="${timestampTest}" />
<br />
<fmt:formatDate value="${timestampTest}" />
<br />


List Test:
<charm:invokeService serviceName="invokeTestService" methodName="getList" var="result4" />
<c:out value="${result4}" />
<br />

This one should just get written out:
<charm:invokeService serviceName="invokeTestService" methodName="getList" />
<br />



Array Test 1:
<charm:invokeService serviceName="invokeTestService" methodName="getArray" var="array" />
<c:forEach var="testArray" items="${array}">
	<c:out value="${testArray}" />
</c:forEach>
<br />




</body>
</html>
