<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<html>
	<head>
		<title><decorator:title  /></title>
		<link rel="stylesheet" href="<c:url value="/styles/bbp.css"/>" type="text/css" media="screen, print" />
		<link rel="stylesheet" href="<c:url value="/styles/screen.css"/>" type="text/css" media="screen, print" />
		<decorator:head />
	</head>
	<body>

		<h1><decorator:title /></h1>
		<p align="right"><i>(printable version)</i></p>

		<decorator:body />

	</body>
</html>
