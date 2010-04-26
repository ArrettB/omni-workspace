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

<title>Invoice Detail</title>



<script type="text/javascript">
<!--//

	var record = { invoiceLineId:-1};

	/////////////////////////
	//  Utility Functions  //
	/////////////////////////

	function debug(id)
	{
	    alert(id  + ' = ' + dwr.util.toDescriptiveString($(id), 0, { escapeHtml:false }));
	}

	function debugFull(id)
	{
	    alert(id  + ' = ' + dwr.util.toDescriptiveString($(id), 1, { escapeHtml:false }));
	}

	function addCell(trElement, text)
	{
	    var tdElement = document.createElement("td");
	    if (text)
	    {
		    var textNode = document.createTextNode(text);
	    	tdElement.appendChild(textNode);
	    }
	    trElement.appendChild(tdElement);
	}

	function createRow(cellData)
	{
		var trElement = document.createElement("tr");
		for (var i = 0; i < cellData.length; i++)
		{
			addCell(trElement, cellData[i]);
		}
		return trElement;
	}

	function getSelectText(selectId)
	{
		var selectTag = $(selectId);
		var index = selectTag.selectedIndex;
		if (index >= 0)
		{
			var selected = selectTag.options[index];
			return selected.text;
		}
		else
		{
			return null;
		}
	}

	function addDummyOption(selectId, optionText)
	{
		dwr.util.addOptions(selectId, {"-1":optionText}, { escapeHtml:false });
	}


	function formatDate(theDate)
	{
		if (theDate)
			return weekdays[theDate.getDay()] + "<br/>" + (theDate.getMonth() + 1) + "/" + theDate.getDate();
		else
			return "";
	}

	function addEvent(obj, evType, fn)
	{
		 if (obj.addEventListener)
		 {
		    obj.addEventListener(evType, fn, true);
		    return true;
		 }
		 else if (obj.attachEvent)
		 {
		    var r = obj.attachEvent("on"+evType, fn);
		    return r;
		 }
		 else
		 {
		    return false;
		 }
	}

-->
</script>


<script type="text/javascript">
<!--//

//////////////////////////////
	//  Table Functions         //
	//////////////////////////////


	var currentData;
	var defaultInvoiceLineNo = 0;

	function refreshTable()
	{
		invoiceManager.refreshRecords(updateTableCallback);
		resetForm();
	}

	function loadTable()
	{
		invoiceManager.loadRecords(${param.invoiceId}, updateTableCallback);
		resetForm();
	}

	function updateWarning()
	{
		$("warn").style.visibility = 'hidden';
	}

	var rowClicked = function(row, invoiceLineNo)
	{
		var rows = $("records").getElementsByTagName("tr");
		for (var i = 0; i < rows.length; i++)
		{
			if (i % 2 == 0)
			{
				rows[i].className="even";
			}
			else
			{
				rows[i].className="odd";
			}
		}

		row.className="selected";
		invoiceManager.getRecord(invoiceLineNo, populateForm);
	}

	var myRowCreater = function(options)
	{

	    var row = document.createElement("tr");
	    var invoiceLineNo = options.rowData.invoiceLineNo;
		if (options.rowIndex % 2 == 0)
	    	{
	    		row.className = "even";
			addEvent(row, "click", function() { rowClicked(row, invoiceLineNo); });
		}
		else
		{
			row.className = "odd";
			addEvent(row, "click", function() { rowClicked(row, invoiceLineNo); });
		}

	    return row;
	};

	var myCellCreator = function(options)
	{
	    var td = document.createElement("td");
	    if (options.cellNum == 0)
	    	td.className = "header";
	    return td;
	};




	function updateTableCallback(data)
	{
		currentData = data;

		var getId = function(record) { return record.invoiceLineId };
		var getLineNo = function(record) { return record.invoiceLineNo };
		var getPO = function(record) { return record.poNo };
		var getItemString = function(record) { return record.itemString };
		var getServiceString = function(record) { return record.serviceString };
		var getDescription = function(record) { return record.description };
		var getQty = function(record) { return record.qty.toFixed(1) };
		var getRate = function(record) { return record.rate.toFixed(2) };
		var getTotal = function(record) { return record.total.toFixed(2) };
		var getTaxableFlag = function(record) { return record.taxableFlag };
		var getDelete = function(record)
		{
		  return '<input type="button" value="Delete" onclick="deleteRecord('+record.invoiceLineNo+', \''+record.invoiceLineNo+'\')"/>';
		};

	  dwr.util.removeAllRows("records", { escapeHtml:false });
	  dwr.util.addRows("records", data, [getLineNo, getPO, getDescription, getItemString, getServiceString, getQty,  getRate,  getTotal, getTaxableFlag, getDelete], {rowCreator:myRowCreater, cellCreator:myCellCreator, escapeHtml:false});

	  //create a empty record if necessary
	  if (data.length == 0)
	  {
	   	  var tr = document.createElement("tr");
	      tr.className = "static";
	      var td = document.createElement("td");
	      td.colSpan = 9;
	      var textNode = document.createTextNode('<fmt:message key="servicetrax.billing.invoice.line.table.nodata"/>');
	      td.appendChild(textNode);
	      tr.appendChild(td);
	      $("records").appendChild(tr);
	  }
	  else
	  {
	  }

		invoiceManager.getSubTotals(getSubTotalsCallback);

		dwr.util.setValue("line_no", currentData.length + 1, { escapeHtml:false });
		updateWarning();

		//update po no
		updatePoNo(data);

		if (defaultInvoiceLineNo > 0)
		{
			var rows = $("records").getElementsByTagName("tr");
			rows[defaultInvoiceLineNo - 1].className = "selected";
			invoiceManager.getRecord(populateForm, defaultInvoiceLineNo);
			defaultInvoiceLineNo = 0;
		}

	}

	function updatePoNo(records)
	{
		var poNo = ""
		for (var i = 0; i < records.length; i++)
		{
			if (records[i].poNo)
				poNo = poNo + records[i].poNo + ", ";
		}
		if (poNo.length > 0)
			poNo = poNo.substring(0, poNo.length - 2);

		 dwr.util.setValue("invoice_poNo", poNo, { escapeHtml:false });
	}
	
	function onChooseService(txt, li)
	{
	   var idString = li.id;
	   var idSplit = idString.split(":");
	   var serviceId = idSplit[0];
	   var serviceString = idSplit[1] + " - " + idSplit[2];

	   dwr.util.setValue("service_id_hidden", serviceId, { escapeHtml:false });
	   enableFormButtons();
  	}
	
	var convertServiceInfo = function(data)
	{
		if (data.length == 0)
		{
			dwr.util.setValue("service_id_msg", "<fmt:message key='servicetrax.billing.invoice.lines.no_req'/>", { escapeHtml:false });
	 		dwr.util.setValue("service_id_hidden", "", { escapeHtml:false });
	 		enableFormButtons();
	 	}
		else
		{
			dwr.util.setValue("service_id_msg", "", { escapeHtml:false });

		}

	    var html="<ul>";
	    for (var i=0; i < data.length; i++ )
		{
		 var id = data[i].serviceId + ":" + data[i].serviceNo;
		 html += '<li id="' + id + '" >';
		 html += data[i].serviceNo;
		 html += '</li>';
	  	}
		html+="</ul>";
	    return html;
	}
	
	var performServiceQuery = function(data, callback)
	{
		return invoiceManager.getServiceInfos(data, callback);
	}



	function onChooseItem(txt, li)
	{
	   var idString = li.id;
	   var idSplit = idString.split(":");
	   var itemId = idSplit[0];
	   var itemString = idSplit[1] + " - " + idSplit[2];

	   dwr.util.setValue("item_id_hidden", itemId, { escapeHtml:false });
	    enableFormButtons();
  	}

	var convertItemInfo = function(data)
	{
		if (data.length == 0)
		{
			dwr.util.setValue("item_id_msg", "<fmt:message key='servicetrax.billing.invoice.lines.no_items'/>", { escapeHtml:false });
	 		dwr.util.setValue("item_id_hidden", "", { escapeHtml:false });
	 		enableFormButtons();
	 	}
		else
		{
			dwr.util.setValue("item_id_msg", "", { escapeHtml:false });

		}

	    // The onComplete function takes one argument, which is the
	    // data returned by the DWR call.
	    // It must return a string, which should be the
	    // html definition of a <ul> tag with <li> tags for each item.
	    var html="<ul>";
	    for (var i=0; i < data.length; i++ )
		{
		 var id = data[i].itemId + ":" + data[i].itemName;
		 html += '<li id="' + id + '" >';
		 html += data[i].itemName;
		 html += '</li>';
	  	}
		html+="</ul>";
	    return html;
	}


	var performItemQuery = function(data, callback)
	{
		return invoiceManager.getItemInfos(data, callback);
	}

	function bodyOnLoad()
	{

		{$('indicator').style.visibility = 'hidden';}

		new Autocompleter.DWR("item_autocomplete", "item_autocomplete_div", performItemQuery, convertItemInfo, {afterUpdateElement: onChooseItem});
		new Autocompleter.DWR("service_autocomplete", "service_autocomplete_div", performServiceQuery, convertServiceInfo, {afterUpdateElement: onChooseService});

		dwr.engine.setPreHook(function() {$('indicator').style.visibility = 'visible';});
		dwr.engine.setPostHook(function() {$('indicator').style.visibility = 'hidden';});

		addEvent($("po_no"), "change", enableFormButtons);
		addEvent($("qty"), "change", enableFormButtons);
		addEvent($("rate"), "change", enableFormButtons);
	    	addEvent($("description"), "change", enableFormButtons);
		addEvent($("qty"), "keyup", updateTotal);
		addEvent($("rate"), "keyup", updateTotal);
		addEvent($("description"), "keyup", updateCount);


		<c:if test="${param.invoiceLineNo != null}" >
		defaultInvoiceLineNo = ${param.invoiceLineNo};
		</c:if>

		loadTable();

		resetForm();
		enableFormButtons();

	}

	function updateRecord()
	{
	  //ids
	  record.itemId = dwr.util.getValue('item_id_hidden', { escapeHtml:false });
	  record.itemString = dwr.util.getValue('item_autocomplete', { escapeHtml:false });
	  record.serviceId = dwr.util.getValue('service_id_hidden', { escapeHtml:false });
  	  record.serviceString = dwr.util.getValue('service_autocomplete', { escapeHtml:false });
	  record.qty = dwr.util.getValue('qty', { escapeHtml:false });
	  record.rate = dwr.util.getValue('rate', { escapeHtml:false });
	  record.description = dwr.util.getValue('description', { escapeHtml:false });
	  record.poNo = dwr.util.getValue('po_no', { escapeHtml:false });
	  record.invoiceLineNo = dwr.util.getValue('line_no', { escapeHtml:false });
	  record.taxableFlag = dwr.util.getValue('taxable_flag', { escapeHtml:false });

	  invoiceManager.updateRecord(record,tableOperationCallback);

	}


	record = { invoiceLineId:-1};


	function deleteRecord(invoiceLineNo, name)
	{
		if (confirm("Are you sure you want to delete line #" + name + "?"))
		{
			invoiceManager.deleteRecord({ invoiceLineNo:invoiceLineNo }, tableOperationCallback);
		}
	}

	function resetRecords()
	{
		if (confirm("All of the changes you have made will be lost. Are you sure you wish to continue?"))
		{
			record = { invoiceLineId:-1};
			invoiceManager.resetRecords(tableOperationCallback);
		}
	}

	function commitRecords()
	{
		record = { invoiceLineId:-1};
		invoiceManager.commitRecords(commitOperationCallback);
	}

	function commitOperationCallback(data)
	{
		//always send them back to the main invoice detail screen.
		if (window.opener)
		{
			var url = '/ims/action/bill/inv/job_inv_main.html?invoice_id=${param.invoiceId}&status_id=' + dwr.util.getValue("status_id", { escapeHtml:false });;
			var mainFrame = window.opener.top.self.main_frame;
			if (mainFrame.bill_frame)
			{
				mainFrame.bill_frame.location = url;
			}
			else if (mainFrame.job_frame.job_bill_frame.job_inv_frame)
			{
				mainFrame.job_frame.job_bill_frame.job_inv_header.location = url;
				mainFrame.job_frame.job_bill_frame.job_inv_frame.location.reload();
			}
			else if (mainFrame.job_frame.job_bill_frame)
			{
				mainFrame.job_frame.job_bill_frame.location = url;
			}

		}
		window.close();
	}

	function tableOperationCallback(data)
	{
		refreshTable();
		dwr.util.setValue("message", data, { escapeHtml:false });
	}

	function resetForm()
	{
	    record = { invoiceLineId:-1};
   	    dwr.util.setValue("line_no", "", { escapeHtml:false });
	    dwr.util.setValue("qty", 0, { escapeHtml:false });
	    dwr.util.setValue("rate", 0, { escapeHtml:false });
	    dwr.util.setValue("total", 0, { escapeHtml:false });
	    dwr.util.setValue("description", "", { escapeHtml:false });
	    dwr.util.setValue("item_id_hidden", "", { escapeHtml:false });
	    dwr.util.setValue("item_autocomplete", "", { escapeHtml:false });
	    dwr.util.setValue("service_id_hidden", "", { escapeHtml:false });
	    dwr.util.setValue("service_autocomplete", "", { escapeHtml:false });
	    dwr.util.setValue("po_no", "", { escapeHtml:false });
	    dwr.util.setValue("taxable_flag", "N", { escapeHtml:false });
	    dwr.util.setValue("edit_button", "<fmt:message key="servicetrax.billing.invoice.line.form.add"/>", { escapeHtml:false });
	    enableFormButtons();
	     updateCount();

	}


	function enableFormButtons()
	{
		var itemId =  dwr.util.getValue("item_id_hidden", { escapeHtml:false });
		var serviceId =  dwr.util.getValue("service_id_hidden", { escapeHtml:false });
		var qty =  parseFloat(dwr.util.getValue("qty", { escapeHtml:false }));
		var rate =  parseFloat(dwr.util.getValue("rate", { escapeHtml:false }));
		var desc =  dwr.util.getValue("description", { escapeHtml:false });
	//	alert('itemId = '+ itemId);
	//	alert('qty = ' + qty);
	//	alert('rate = ' + rate);
	//	alert('desc = ' + desc);
		if (itemId && serviceId && rate > 0 && qty > 0)
		{
			$("edit_button").disabled = false;
		}
		else
		{
		   $("edit_button").disabled = true;
		}
		if (record.invoiceLineId > 0)
		{
			$("cancel_button").disabled = false;
		}
		else
		{
			$("cancel_button").disabled = true
		}
	}

	function populateForm(rec)
	{
		record = rec;

		dwr.util.setValue('item_id_hidden', record.itemId, { escapeHtml:false });
		dwr.util.setValue('item_autocomplete', record.itemString, { escapeHtml:false });
		
		dwr.util.setValue('service_id_hidden', record.serviceId, { escapeHtml:false });
		dwr.util.setValue('service_autocomplete', record.serviceString, { escapeHtml:false });

		dwr.util.setValue('po_no', record.poNo, { escapeHtml:false });
		dwr.util.setValue('line_no', record.invoiceLineNo, { escapeHtml:false });

		dwr.util.setValue('description', record.description, { escapeHtml:false });
		dwr.util.setValue('qty', record.qty.toFixed(1), { escapeHtml:false });
		dwr.util.setValue('rate', record.rate.toFixed(2), { escapeHtml:false });
		dwr.util.setValue('total', record.total.toFixed(2), { escapeHtml:false });
		dwr.util.setValue('taxable_flag', record.taxableFlag, { escapeHtml:false });

	    dwr.util.setValue("edit_button", "<fmt:message key="servicetrax.billing.invoice.line.form.edit"/>", { escapeHtml:false });

	   enableFormButtons();
	   updateCount();
	}


	function cancelEdit()
	{
		refreshTable();
	}

	function getSubTotalsCallback(mapData)
	{
		dwr.util.removeAllRows("recordsFooter", { escapeHtml:false });
		for (var key in mapData)
		{
			var tr = createRow(["", "", "",   key, "", "", mapData[key].toFixed(2), "", ""]);
			$("recordsFooter").appendChild(tr);
		}
	}

	function updateTotal()
	{
		var total = dwr.util.getValue("qty", { escapeHtml:false }) * dwr.util.getValue("rate", { escapeHtml:false });
		dwr.util.setValue('total', total.toFixed(2), { escapeHtml:false });
	}

	function updateCount()
	{
		var length = dwr.util.getValue("description", { escapeHtml:false }).length;
		if (length > 100)
		{
			length = 100;
			dwr.util.setValue("description", dwr.util.getValue("description", { escapeHtml:false }).substring(0,100), { escapeHtml:false });
		}
		dwr.util.setValue('count', 100 - length, { escapeHtml:false });

	}
 -->
</script>

</head>


<h2 id="title"><fmt:message key="servicetrax.billing.invoice.title"/></h2>

<body onload="bodyOnLoad()" style="margin-left:20px;margin-right:20px;">

<charm:invokeService serviceName="sessionService" methodName="getOrganizationId" var="organizationId">
</charm:invokeService>


<charm:form name="Invoice_detail"
action="process.form"
successView="invoice_saved"
formView="admin/Invoice_detail"
fieldDecorator="none"
css="">

<charm:bind name="invoice" identifier="${param.invoiceId}" className="Invoice" primary="true" /> <charm:error bind="invoice" css="errorFormRow" />
<input type="hidden" name="status_id" id="stastus_id" value="${invoice.invoiceStatus.statusId}" />

<table class="formTable">
<tr>
<td class="label"><label for="invoice_invoiceId"><fmt:message key="servicetrax.billing.invoice.form.invoice_no"/></label></td>
<td class="control">
<charm:text bind="invoice" property="invoiceId" label="servicetrax.billing.invoice.form.invoice_no"  />
</td>

<td class="label"><label for="invoice_job.jobNo"><fmt:message key="servicetrax.billing.invoice.form.job_no"/></label></td>
<td class="control">
<charm:text bind="invoice" property="job.jobNo" label="servicetrax.billing.invoice.form.job_no" />
</td>
</tr>

<tr>
<td class="label"><label for="invoice_job.customer.customerName"><fmt:message key="servicetrax.billing.invoice.form.customer"/></label></td>
<td class="control">
	<charm:text bind="invoice" property="job.customer.customerName" label="servicetrax.billing.invoice.form.customer" />
</td>

<td class="label"><label for="invoice_invoiceStatus.name"><fmt:message key="servicetrax.billing.invoice.form.status"/></label></td>
<td class="control">
	<charm:text bind="invoice" property="invoiceStatus.name" label="servicetrax.billing.invoice.form.customer"  />
</td>
</tr>


<tr>
<td class="label"><label for="invoice_poNo"><fmt:message key="servicetrax.billing.invoice.form.po_no"/></label></td>
<td class="control">
	<charm:text bind="invoice" property="poNo" label="servicetrax.billing.invoice.form.po_no" />
</td>
</tr>

<tr>
<td class="label"><label for="invoice_lookupByBillingTypeId"><fmt:message key="servicetrax.billing.invoice.form.billing_type"/></label></td>
<td class="control">
	<charm:select bind="invoice" property="lookupByBillingTypeId" label="servicetrax.billing.invoice.form.billing_type" >
		<charm:options namedQueryId="hibernate.lookups" optionLabel="name" optionValue="lookupId">
			<charm:parameter name="lookupTypeCode" value="billing_type" />
		</charm:options>
	</charm:select>
</td>
<td class="label"><label for="invoice_lookupByInvoiceTypeId"><fmt:message key="servicetrax.billing.invoice.form.invoice_type"/></label></td>
<td class="control">
	<charm:select bind="invoice" property="lookupByInvoiceTypeId" label="servicetrax.billing.invoice.form.invoice_type">
		<charm:options namedQueryId="hibernate.lookups" optionLabel="name" optionValue="lookupId">
			<charm:parameter name="lookupTypeCode" value="invoice_type" />
		</charm:options>
	</charm:select>
</td>
</tr>


<tr>
<td class="label"><label for="invoice_assignedToUserId"><fmt:message key="servicetrax.billing.invoice.form.assigned_to"/></label></td>
<td class="control">
	<charm:select bind="invoice" property="assignedToUserId" label="servicetrax.billing.invoice.form.assigned_to">
		<charm:options namedQueryId="hibernate.invoiceAssignedTos" optionLabel="fullName" optionValue="userId">
			<charm:parameter name="organizationId" value="${organizationId}" />
		</charm:options>
	</charm:select>
</td>
</tr>


<tr>
<td class="label"><label for="invoice_description"><fmt:message key="servicetrax.billing.invoice.form.description"/></label></td>
<td colspan="3">
	<charm:textarea bind="invoice" property="description"  cols="60" rows="5" label="servicetrax.billing.invoice.form.description" />
</td>
</tr>

		<tr><td colspan="4">
			<charm:audit bind="invoice" />
		</td></tr>

	</table>

</charm:form>

<div id="indicator"><img src="<c:url value="/images/indicator_medium.gif"/>" alt="indicator" /></div>
<form name="entryForm">

<table class="formTable">





<tr>
	<td class="label">
		<label for="line_no"><fmt:message key="servicetrax.billing.invoice.line.form.line_no" /></label>
	</td>
	<td class="control">
		<input type="text" id="line_no" disabled="true"/>
	</td>
	<td class="label">
		<label for="line_no"><fmt:message key="servicetrax.billing.invoice.line.form.po_no" /></label>
	</td>
	<td class="control">
		<input type="text" id="po_no" />
	</td>
</tr>


<tr>
	<td class="label">
		<label for="item_autocomplete"><fmt:message key="servicetrax.billing.invoice.line.form.item" /></label>
	</td>
	<td class="control">
		<input autocomplete="off" type="text" id="item_autocomplete" style="width:300px;" />
		<div class="auto_complete" id="item_autocomplete_div"></div>
		<span class="controlMessage" id="item_id_msg">&nbsp;</span>
		<input type="hidden" name="item_id_hidden" id="item_id_hidden" value="-1" />
	</td>
	
	<td class="label">
		<label for="service_autocomplete"><fmt:message key="servicetrax.billing.invoice.line.form.req" /></label>
	</td>
	<td class="control">
		<input autocomplete="off" type="text" id="service_autocomplete" style="width:300px;" />
		<div class="auto_complete" id="service_autocomplete_div"></div>
		<span class="controlMessage" id="service_id_msg">&nbsp;</span>
		<input type="hidden" name="service_id_hidden" id="service_id_hidden" value="-1" />
	</td>
</tr>


<tr>
	<td class="label">
		<label for="qty"><fmt:message key="servicetrax.billing.invoice.line.form.qty" /></label>
	</td>
	<td class="control">
		<input type="text" id="qty"  style="width:10em;"/>
	</td>
	<td class="label">
		<label for="rate"><fmt:message key="servicetrax.billing.invoice.line.form.rate" /></label>
	</td>
	<td class="control">
		<input type="text" id="rate" class="small" style="width:10em;"/>
	</td>
	<td class="total">
		<label for="total"><fmt:message key="servicetrax.billing.invoice.line.form.total" /></label>
	</td>
	<td class="control">
		<input type="text" id="total" disabled="true"  style="width:10em;"/>
	</td>
</tr>

<tr>
	<td class="label">
		<label for="description"><fmt:message key="servicetrax.billing.invoice.line.form.desc" /></label>
	</td>
	<td class="control" colspan="5">
		<textarea id="description" cols="60" rows="2"></textarea>
		<span id="count" value="100" style="margin-left:5px;margin-right:5px;vertical-align:baseline;padding-right:5px;padding-left:5px;width:50px;border:1px solid; ">100</span>characters left.
	</td>

</tr>


<tr>
	<td class="label">
		<label for="description"><fmt:message key="servicetrax.billing.invoice.line.form.taxable_flag" /></label>
	</td>
	<td class="control">
		<select id="taxable_flag">
		<option value="N">No</option>
		<option value="Y">Yes</option>
		</select>
	</td>

</tr>

<tr><td colspan="4">
<input type="button" name="edit_button" id="edit_button" value="" onclick="updateRecord()" />
<input type="button" name="cancel_button" id="cancel_button" value="<fmt:message key="servicetrax.billing.invoice.line.form.cancel"/>" onclick="cancelEdit()" />
</td></tr>


</table>



<div id="message"></div>


<table class="recordsTable">
	<thead>
		<tr>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.line_no" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.po_no" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.desc" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.item" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.req" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.qty" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.rate" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.total" /></th>
			<th><fmt:message key="servicetrax.billing.invoice.line.table.taxable_flag" /></th>
	  		<th><fmt:message key="servicetrax.billing.invoice.line.table.action" /></th>
		</tr>
	</thead>
	<tbody id="records">
		<tr><td></td></tr>
	</tbody>
	<tfoot id="recordsFooter">
	<tr><td></td></tr>
	</tfoot>
</table>
<br />

<input type="button" name="Done" value="<fmt:message key="servicetrax.billing.invoice.line.table.done"/>" onclick="commitRecords()" />
<input type="button" name="Reset" value="<fmt:message key="servicetrax.billing.invoice.line.table.reset"/>" onclick="resetRecords()" />

<div id="warn">
</div>


</body>
</html>
