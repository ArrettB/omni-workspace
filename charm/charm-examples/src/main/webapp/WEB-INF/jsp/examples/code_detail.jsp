<%@ include file="../includes/header.jsp" %>

<%@ taglib prefix="charm" uri="/tld/charm" %>

<charm:form
 name="codeForm"
 action="process.form"
 successView="examples/code_list"
 formView="examples/code_detail"
 fieldDecorator="divDecorator"
 css="form"
>
 	<charm:bind name="b1" dataService="hibernateService" identifier="${param.codeId}" className="com.dynamic.skeleton.orm.BbpCodes"/>
 
		<charm:text bind="b1" property="codeId" label="codeForm.codeId.label" readonly="true" displayonly="true"/>
		<charm:text bind="b1" property="code" label="codeForm.code.label" mandatory="true"/>
		<charm:textarea bind="b1" property="description" labelKey="codeForm.desc.label" rows="5"/>

		<div align="right">
			<charm:button code="Save" display="Save" />
			<charm:button code="Delete" display="Delete" />
		</div>
	
</charm:form>
