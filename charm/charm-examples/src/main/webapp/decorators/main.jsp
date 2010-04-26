<%@ page session="true"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x"         uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"        uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql"       uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"  %>
<%@ taglib prefix="page"      uri="http://www.opensymphony.com/sitemesh/page" %>
<%@ taglib prefix="display"   uri="http://displaytag.sf.net" %>
<%@ taglib prefix="charm"     uri="/tld/charm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title><decorator:title default="Default Title" /></title>


<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<link rel="stylesheet" href="<c:url value="/styles/displaytag.css"/>" type="text/css" media="screen, print" />

<script type="text/javascript" src="<c:url value="/js/numberFormat153.js"/>" ></script>


    <style type="text/css" media="screen">
        @import url("<c:url value="/css/tools.css"/>");
        @import url("<c:url value="/css/typo.css"/>");
        @import url("<c:url value="/css/forms.css"/>");
        /* swap layout stylesheet:
        layout-navtop-localleft.css
		layout-navtop-subright.css
		layout-navtop-3col.css
		layout-navtop-1col.css
		layout-navleft-1col.css
		layout-navleft-2col.css*/
        @import url("<c:url value="/css/layout-navleft-1col.css"/>");
        @import url("<c:url value="/css/layout.css"/>");
        @import url("<c:url value="/css/skin.css"/>");
    </style>
    
    
    
    <script type="text/javascript">
    
    	var errorMessageClass = "errorMessage"
    	var errorInputClass = "errorInput";
    	var messageClass = "message"
    
    	var validInputClass = "input";
    
    	function formatAsMoney(theControl)
    	{
    		if (theControl.value.length > 0)
    		{
    			var num = new NumberFormat();
    			num.setInputDecimal('.');
    			num.setNumber(theControl.value);
    			num.setPlaces('2');
    			num.setCurrencyValue('$');
    			num.setCurrency(true);
    			num.setCurrencyPosition(num.LEFT_OUTSIDE);
    			num.setNegativeFormat(num.PARENTHESIS);
    			num.setNegativeRed(false);
    			num.setSeparators(true, ',', ',');
    			theControl.value = num.toFormatted();
    		}
    	}
    
    	function formatAsPercent(theControl)
    	{
    		var num = new NumberFormat();
    		num.setInputDecimal('.');
    		num.setNumber(theControl.value);
    		num.setPlaces('2');
    		num.setCurrency(false);
    		num.setNegativeFormat(num.PARENTHESIS);
    		num.setNegativeRed(false);
    		num.setSeparators(true, ',', ',');
    		theControl.value = num.toFormatted() + "%";
    	}
    
    	function message(inputElement, classString, errorMessage)
    	{
    		 var messageDiv = document.createElement("div");
    
    		 inputElement.parentNode.insertBefore(messageDiv, inputElement);
    		 messageDiv.className = classString;
    		 messageDiv.appendChild(document.createTextNode(errorMessage));
    
    		 return true;
    	}
    
    	function addError(inputElement, errorMessage)
    	{
    		inputElement.valid = false;
    		inputElement.className = errorInputClass;
    
    		message(inputElement, errorMessageClass, errorMessage);
    	}
    
    	function addMessage(inputElement, message)
    	{
    		message(inputElement, messageClass, errorMessage);
    	}
    
    	function clearErrorOrMessage(inputElement)
    	{
    		inputElement.valid = true;
    		inputElement.className = validInputClass;
    		message(inputElement);
    	}
    
    	function validateInput(inputElement, pattern, errorMessage)
    	{
    		alert(inputElement.value);
    		var regExpression = new RegExp(pattern, "i")
    		if (!inputElement.value.match(regExpression))
    		{
    			addError(inputElement, errorMessage);
    		}
    	}
    
    	function revalidateInput(inputElement, pattern)
    	{
    		 if (!inputElement.valid)
    		 {
    			var regExpression = new RegExp(pattern, "i")
    			if (inputElement.value.match(regExpression))
    			{
    				clearErrorOrMessage(input);
    			}
    		}
    	}
    
    	function popUp(url)
    	{
    		var windowFeatures = "scrollbars=yes,resizable=yes,width=300,height=300";
    		var popUp = window.open(url, "_new", windowFeatures);
    		popUp.focus();
    	}
    
    	function popUp(url, width, height)
    	{
    		var windowFeatures = "scrollbars=yes,resizable=yes,width=" + width + ",height=" + height;
    		var popUp = window.open(url, "_new", windowFeatures);
    		popUp.focus();
    	}
    
    
    </script>

    
    <decorator:head />
    
    
    
    
</head>

<body id="page-home" onload="<decorator:getProperty property="body.onload" />">

    <div id="page">

        <div id="header" class="clearfix">

            <div id="branding">
                <img src="images/logo.gif" alt="Logo goes here" />
            </div><!-- end branding -->

            <div id="search">
                <form method="post" action="">
					<div><label for="search-site">Search</label>
					<input type="text" name="search" id="search-site" />
                    <input type="submit" value="go" name="search" id="search" /></div>
				</form>
            </div><!-- end search -->

		<!--
	    <div id="login">
		<c:choose>
			<c:when test="${sessionScope.user == null}">
					You have not yet logged in. <a href="<c:url value="/public/user_home.html" />" class="mast"></a> <a href="<c:url value="index.html" />" class="mast">Login</a>
			</c:when>
			<c:otherwise>
					Welcome, <c:out value="${sessionScope.user.username}" />  |  <a href="<c:url value="/logout.go"/>" class="mast"></a> <a href="<c:url value="/logout.go"/>" class="mast">Exit</a>
			</c:otherwise>
		</c:choose>
		</div>
		-->
            <hr />
        </div><!-- end header -->


        <div id="content" class="clearfix">

            <div id="main">
                <h1><decorator:title default="Default Title" /></h1>

		<decorator:usePage id="p" />
		<%
			HttpServletRequest req = p.getRequest();
			StringBuffer printUrl = new StringBuffer();
			printUrl.append( req.getRequestURI() );
			printUrl.append("?printable=true");
			if (request.getQueryString()!=null) {
				printUrl.append('&');
				printUrl.append(request.getQueryString());
			}
		%>
		<p align="right">[ <a href="<%= printUrl %>">printable version</a> ]</p>

                <decorator:body />
               
               
                <hr />
            </div><!-- end main -->

            <div id="sub">

                <h2>Sub</h2>
                <p>Proin pellentesque ullamcorper ipsum. Sed tincidunt tincidunt mi. Vestibulum magna wisi, vehicula eu, ullamcorper et, egestas in, tortor. Vestibulum interdum, massa in faucibus laoreet, tortor massa congue ligula, et feugiat elit mauris nec enim. Phasellus pellentesque tellus nec nisl. Mauris dignissim iaculis leo. Maecenas id lorem. Aenean tortor eros, dignissim eu, vehicula id, dictum eu, neque. Maecenas nisl. Proin dui lacus, aliquam eget, volutpat vel, aliquam quis, velit. Proin neque. Etiam turpis odio, tincidunt id, accumsan tincidunt, mollis a, nibh. Donec porta.</p>

            </div><!-- end sub -->


            <div id="local">
                <h2>Local</h2>
                <ul>
                    <li><a href="somewhere.html">Content page 1</a></li>
                    <li><a href="somewhere.html">Content page 2</a></li>
                    <li><a href="somewhere.html">Content page 3</a></li>
                    <li><a href="somewhere.html">Content page 4</a></li>
                    <li><a href="somewhere.html">Content page 5</a></li>
                    <li><a href="somewhere.html">Content page 6</a></li>
                </ul>

            </div><!-- end sub -->


            <div id="nav">
                <div class="wrapper">
                <h2 class="accessibility">Navigation</h2>
                <ul class="clearfix">
			<c:choose>
				<c:when test="${param.mi == 'home'}">
					<li><strong><a href="<c:url value="/public/home.html?mi=home"/>">Home</a></strong></li>
				</c:when>
				<c:otherwise>
					<li><a href="<c:url value="/public/home.html?mi=home"/>">Home</a></li>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${param.mi == 'about'}">
					<li><strong><a href="<c:url value="/public/about.html?mi=about"/>">About</a></strong></li>
				</c:when>
				<c:otherwise>
					<li><a href="<c:url value="/public/about.html?mi=about"/>">About</a></li>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${param.mi == 'contactUs'}">
					<li><strong><a href="<c:url value="/public/contactUs.html?mi=contactUs"/>">Contact Us</a></strong></li>
				</c:when>
				<c:otherwise>
					<li><a href="<c:url value="/public/contactUs.html?mi=contactUs"/>">Contact Us</a></li>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${param.mi == 'help'}">
					<li><strong><a href="<c:url value="/public/help.html?mi=help"/>">Help</a></strong></li>
				</c:when>
				<c:otherwise>
					<li><a href="<c:url value="/public/help.html?mi=help"/>">Help</a></li>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${param.mi == 'privacy'}">
					<li class="last"><strong><a href="<c:url value="/public/privacyPolicy.html?mi=privacy"/>">Privacy Policy</a></strong></li>
				</c:when>
				<c:otherwise>
					<li class="last"><a href="<c:url value="/public/privacyPolicy.html?mi=privacy"/>">Privacy Policy</a></li>
				</c:otherwise>
			</c:choose>
			
	

               
                </ul>
                </div>
                <hr />
            </div><!-- end nav -->

        </div><!-- end content -->


        <div id="footer" class="clearfix">
            <p>&copy; Copyright 2006 Apex It</p>
        </div><!-- end footer -->

    </div><!-- end page -->

    <div id="extra1">&nbsp;</div>
    <div id="extra2">&nbsp;</div>

</body>
</html>