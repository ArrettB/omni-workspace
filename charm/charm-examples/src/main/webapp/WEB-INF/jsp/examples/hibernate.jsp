<%@ include file="../includes/header.jsp" %>

 <charm:hibernateTest
 dataService="hibernateService"
 defaultQuery="SELECT code FROM com.dynamic.skeleton.orm.BbpCodes code"
 />

<%@ include file="../includes/footer.jsp" %>