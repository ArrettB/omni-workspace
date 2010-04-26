<%@ include file="includes/header.jsp" %>

<center>
<h2>Take a Guess!</h2>
</center>

<b>You are a very good guesser!</b>

<c:url value="/guess.html" var="guessURL">
 <c:param name="foo" value="bar"/>
</c:url>
<a href="<c:out value="${guessURL}"/>">Guess again?</a>

<%@ include file="includes/footer.jsp" %>

