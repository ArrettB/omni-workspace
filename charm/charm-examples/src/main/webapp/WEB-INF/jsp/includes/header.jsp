<%@ include file="init.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>The skeleton project</title>
	<meta http-equiv="Expires" content="-1" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<link rel="stylesheet" href="<c:url value="/styles/screen.css"/>" type="text/css" media="screen, print" />
</head>

<body>

<%--
request.getRequestURI() =  <%=request.getRequestURI()%><br>
request.getRequestURL() =  <%=request.getRequestURL()%><br>
request.getContextPath() =  <%=request.getContextPath()%><br>
request.getPathInfo() =  <%=request.getPathInfo()%><br>
request.getPathTranslated() =  <%=request.getPathTranslated()%><br>
File: <%=application.getRealPath(request.getRequestURI())%><br>
--%>



<% 
	if (request.getRequestURI().indexOf("examples") != -1)
	{
		String contextPlus = request.getContextPath() + "/WEB-INF/jsp";
		String uri  = request.getRequestURI();
		String url = request.getContextPath() + uri.substring(contextPlus.length()) + ".source";	
%>
	<ul id="showsource">
		<li><a href="<%=url%>">View JSP Source</a></li>
	</ul>
<% 
	} 
%>