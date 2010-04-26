<%@ include file="includes/header.jsp" %>

<center>
<h2>Take a Guess!</h2>
</center>

<c:if test="${message != null}">
<b><c:out value="${message}"/></b>
</c:if>

<form 
	method="POST" 
	name="guessForm" 
	style="margin: 0px auto;"
	action="<c:url value="/guess.form" />" 
	class="form">
 	
<div class="formRow">
  <label class="label" for="j_username">What is your guess?</label>
  <span class="control">
    <input type="text" name="guess" />
  </span>
</div>
	
	<div align="right">
	<input value="Guess!" name="submit" type="submit">
	</div>

	</form>
	
</div>


<%@ include file="includes/footer.jsp" %>

