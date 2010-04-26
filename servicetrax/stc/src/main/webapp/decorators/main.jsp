<%@ page session="true"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ServiceTrax - <decorator:title default="Unknown Title" /></title>
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<link href="<c:url value="/css/stc.css"/>" media="screen" rel="Stylesheet" type="text/css" />

<decorator:head />

</head>

<body onload="<decorator:getProperty property="body.onload" />"   style="<decorator:getProperty property="body.style" />">
<decorator:body />

</body>

</html>
