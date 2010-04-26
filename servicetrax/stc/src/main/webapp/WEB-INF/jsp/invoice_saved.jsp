<%@ page session="true"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="charm" uri="/tld/charm"%>

<html>
<head>

<!-- dwr includes -->
<script src="<c:url value="/dwr/engine.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/util.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/interface/invoiceManager.js"/>" type="text/javascript"></script>

<!-- script.acolu.us includes -->
<script src="<c:url value="/js/script.aculo.us/prototype.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/scriptacolous.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/controls.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/effects.js"/>" type="text/javascript"></script>
<link href="<c:url value="/css/script.aculo.us/script.aculo.us.css"/>" media="screen" rel="Stylesheet" type="text/css" />


<script src="<c:url value="/js/autocomplete.js"/>" type="text/javascript"></script>

<title><fmt:message key="servicetrax.billing.invoice.saved.title"/></title>

</head>

<body>
<h2 id="title"><fmt:message key="servicetrax.billing.invoice.saved.title"/></h2>
</body>
</html>
