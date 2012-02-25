<div id="addOriginContact" class="yui-panel">
    <div class="hd">Boo hoo Enter your new origin contact information</div>
    <div class="bd">

        <form:form name="addOriginContactForm" id="addOriginContactForm"
                   action="${pageContext.request.contextPath}/addOriginContact.html" method="post">
            <table border="0" cellspacing="5" cellpadding="0">
                <input type="hidden" name="customerId" value="${hotSheet.customerId}"/>
                <input type="hidden" name="extDealerId" value="${hotSheet.extCustomerId}"/>
                <tr>
                    <td>
                        Name:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactName" id="contactName"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Phone:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactPhone" id="contactPhone"/>
                        </label>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</div>

<div id="editOriginContact" class="yui-panel">
    <div class="hd">Foo bar Edit the origin contact information</div>
    <div class="bd">

        <form:form name="editOriginContactForm" id="editOriginContactForm"
                   action="${pageContext.request.contextPath}/editOriginContact.html" method="post">
            <table border="0" cellspacing="5" cellpadding="0">
                <input type="hidden" name="customerId" value="${hotSheet.customerId}"/>
                <input type="hidden" name="extDealerId" value="${hotSheet.extCustomerId}"/>
                <tr>
                    <td>
                        Name:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactName" id="contactName"/>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Phone:
                    </td>
                    <td>
                        <label>
                            <input type="text" name="contactPhone" id="contactPhone"/>
                        </label>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</div>