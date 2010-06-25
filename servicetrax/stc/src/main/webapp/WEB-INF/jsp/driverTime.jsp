<%@ page session="true" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="charm" uri="/tld/charm" %>
<%@ taglib prefix="stc" uri="/tld/stc" %>

<html>
<head>
<title><fmt:message key="servicetrax.tc.driverTime.title"/></title>

<!-- DWR includes -->
<script src="<c:url value="/dwr/engine.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/util.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/interface/timeManager.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/interface/timeRecord.js"/>" type="text/javascript"></script>
<script src="<c:url value="/dwr/interface/resourceInfo.js"/>" type="text/javascript"></script>

<!-- script.acolu.us includes -->
<script src="<c:url value="/js/script.aculo.us/prototype.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/scriptaculous.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/controls.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/script.aculo.us/effects.js"/>" type="text/javascript"></script>
<link href="<c:url value="/css/script.aculo.us/script.aculo.us.css"/>" media="screen" rel="Stylesheet" type="text/css"/>

<!-- Calendar Includes -->
<script type="text/javascript" src="<c:url value="/js/yui/yahoo/yahoo.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/yui/dom/dom.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/yui/event/event.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/yui/container/container.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/yui/calendar/calendar.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/charm/calendar.js"/>"></script>

<script src="<c:url value="/js/stcTime.js"/>" type="text/javascript"></script>


<link rel="stylesheet" type="text/css" href="<c:url value="/js/yui/calendar/assets/calendar.css"/>"/>

<script src="<c:url value="/js/autocomplete.js"/>" type="text/javascript"></script>


<script type="text/javascript">

    function resetTimeFields() {
        document.getElementById('startTimeHour').selectedIndex = 0;
        document.getElementById('startTimeMinutes').selectedIndex = 0;
        document.getElementById('startTimeAmPm').selectedIndex = 0;
        document.getElementById('endTimeHour').selectedIndex = 0;
        document.getElementById('endTimeMinutes').selectedIndex = 0;
        document.getElementById('endTimeAmPm').selectedIndex = 0;
        document.getElementById('breakTimeHours').selectedIndex = 0;
        document.getElementById('breakTimeMinutes').selectedIndex = 0;
    }

    Event.observe(window, 'load', function() {
        resetTimeFields();
    });


    var record = { id:-1};

    /////////////////////////
    //  Utility Functions  //
    /////////////////////////

    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    function debug(id)
    {
        alert(id + ' = ' + dwr.util.toDescriptiveString($(id), 0, { escapeHtml:false }));
    }

    function debugFull(id)
    {
        alert(id + ' = ' + dwr.util.toDescriptiveString($(id), 1, { escapeHtml:false }));
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
        {
            return weekdays[theDate.getDay()] + "<br/>" + (theDate.getMonth() + 1) + "/" + theDate.getDate();
        }
        else
        {
            return "";
        }
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
            var r = obj.attachEvent("on" + evType, fn);
            return r;
        }
        else
        {
            return false;
        }
    }


</script>

<script type="text/javascript">


    //////////////////////////////
    //  Autocomplete Functions  //
    /////////////////////////////


    var convertMapToHtml = function(data)
    {

        // The onComplete function takes one argument, which is the
        // data returned by the DWR call.
        // It must return a string, which should be the
        // html definition of a <ul> tag with <li> tags for each item.
        var html = "<ul>";
        for (var property in data)
        {
            html += "<li id=\"" + property + "\" >" + data[property] + "</li>";
        }
        html += "</ul>";
        return html;

    }

    var convertJobInfo = function(data)
    {
        if (data.length == 0)
        {
            dwr.util.setValue("job_id_msg", "<fmt:message key='servicetrax.tc.time.form.nojobs'/>", { escapeHtml:false });
            dwr.util.setValue("job_id_hidden", "", { escapeHtml:false });
            enableFormButtons();
        }
        else
        {
            dwr.util.setValue("job_id_msg", "", { escapeHtml:false });

        }

        // The onComplete function takes one argument, which is the
        // data returned by the DWR call.
        // It must return a string, which should be the
        // html definition of a <ul> tag with <li> tags for each item.
        var html = "<ul>";
        for (var i = 0; i < data.length; i++)
        {
            var id = data[i].jobId + ":" + data[i].jobNo + ":" + data[i].endUserName;
            html += '<li id="' + id + '" >';
            html += data[i].html;
            html += '</li>';
        }
        html += "</ul>";
        return html;

    }

    var convertResourceInfo = function(data)
    {
        if (data.length == 0)
        {
            dwr.util.setValue("resource_id_msg", "<fmt:message key='servicetrax.tc.time.form.noresources'/>", { escapeHtml:false });
            dwr.util.setValue("resource_id_hidden", "", { escapeHtml:false });
            enableFormButtons();
        }
        else
        {
            dwr.util.setValue("resource_id_msg", "", { escapeHtml:false });
        }

        // The onComplete function takes one argument, which is the
        // data returned by the DWR call.
        // It must return a string, which should be the
        // html definition of a <ul> tag with <li> tags for each item.
        var html = "<ul>";
        for (var i = 0; i < data.length; i++)
        {
            var id = data[i].resourceId + ":" + data[i].resourceName;
            html += '<li id="' + id + '" >';
            html += data[i].html;
            html += '</li>';
        }
        html += "</ul>";

        return html;
    }


    function onChooseJob(txt, li)
    {
        var idString = li.id;
        var idSplit = idString.split(":");
        var jobId = idSplit[0];
        var jobString = idSplit[1] + " - " + idSplit[2];

        dwr.util.setValue("job_id_hidden", jobId, { escapeHtml:false });
        dwr.util.setValue("job_autocomplete", jobString, { escapeHtml:false });
        refreshReqList();

        refreshItemList();
    }

    function onChooseResource(txt, li)
    {

        var idString = li.id;
        var idSplit = idString.split(":");
        var resourceId = idSplit[0];
        var resourceString = idSplit[1];

        dwr.util.setValue("resource_id_hidden", resourceId, { escapeHtml:false });
        dwr.util.setValue("resource_autocomplete", resourceString, { escapeHtml:false });
        refreshItemList();
    }

    function refreshItemList()
    {
        var jobId = dwr.util.getValue("job_id_hidden", { escapeHtml:false });
        var resourceId = dwr.util.getValue("resource_id_hidden", { escapeHtml:false });
        if (jobId && resourceId)
        {
            timeManager.getItems(resourceId, jobId, getItemsCallback);
        }
        else
        {
            dwr.util.removeAllOptions("items", { escapeHtml:false });
            addDummyOption("items", ["<< Not Available >>"]);
        }

    }

    function refreshReqList()
    {
        var jobId = dwr.util.getValue("job_id_hidden", { escapeHtml:false });
        if (jobId)
        {
            timeManager.getRequisitions(jobId, getRequisitionsCallback);
        }
        else
        {
            dwr.util.removeAllOptions("reqs", { escapeHtml:false });
            addDummyOption("reqs", "<< Not Available >>");
        }
    }

    function refreshPaycodeList()
    {
        timeManager.getPaycodes(getPaycodesCallback);
    }


    function getRequisitionsCallback(data)
    {
        dwr.util.removeAllOptions("reqs", { escapeHtml:false });
        addDummyOption("reqs", "<< Choose >>");
        dwr.util.addOptions("reqs", data, { escapeHtml:false });

        if (record && record.serviceId)
            dwr.util.setValue('reqs', record.serviceId, { escapeHtml:false });

        enableFormButtons();
    }

    function getItemsCallback(data)
    {
        dwr.util.removeAllOptions("items", { escapeHtml:false });
        addDummyOption("items", "<< Choose >>");
        dwr.util.addOptions("items", data, { escapeHtml:false });

        if (record && record.itemId)
            dwr.util.setValue('items', record.itemId, { escapeHtml:false });

        enableFormButtons();

    }

    function getPaycodesCallback(data)
    {
        dwr.util.removeAllOptions("paycodes", { escapeHtml:false });
        addDummyOption("paycodes", "<< Choose >>");
        dwr.util.addOptions("paycodes", data, { escapeHtml:false });

        if (record && record.payCode)
            dwr.util.setValue('paycodes', record.payCode, { escapeHtml:false });

        enableFormButtons();

    }


</script>

<script type="text/javascript">


//////////////////////////////
//  Table Functions         //
//////////////////////////////


var currentData;
var dateCal;

function updateTable()
{
    timeManager.getAllRecords(fillTable);
    resetForm();
}

function updateWarning()
{
    var numInvalid = 0;
    if (currentData)
    {
        for (var i = 0; i < currentData.length; i++)
        {
            if (!currentData[i].paycodeValid)
                numInvalid++;
        }
    }

    if (numInvalid == 0)
    {
        new Effect.Fade('warn');
    }
    else if (numInvalid == 1)
    {
        dwr.util.setValue("warn", "1 record has a  mismatched pay code.", { escapeHtml:false });
        new Effect.Appear('warn');
    }
    else
    {
        dwr.util.setValue("warn", numInvalid + " records have mismatched pay codes.", { escapeHtml:false });
        new Effect.Appear('warn');
    }
}

var rowClicked = function(row, id, event)
{
    var element = Event.element(event);
    if ('INPUT' != element.tagName)
    {
        var rows = $("records").getElementsByTagName("tr");
        for (var i = 0; i < rows.length; i++)
        {
            var valid = currentData[i].paycodeValid;

            if (!valid)
            {
                row.className = "warn";
            }
            else if (i % 2 == 0)
            {
                rows[i].className = "even";
            }
            else
            {
                rows[i].className = "odd";
            }
        }

        row.className = "selected";
        timeManager.getRecord(id, populateForm);
    }
}

var myRowCreater = function(options)
{

    var row = document.createElement("tr");
    var id = options.rowData.id;
    var valid = options.rowData.paycodeValid;
    if (!valid)
    {
        row.className = "warn";
        addEvent(row, "click", function(event) {
            rowClicked(row, id, event);
        });
    }
    else if (options.rowIndex % 2 == 0)
    {
        row.className = "even";
        addEvent(row, "click", function(event) {
            rowClicked(row, id, event);
        });
    }
    else
    {
        row.className = "odd";
        addEvent(row, "click", function(event) {
            rowClicked(row, id, event);
        });
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


function fillTable(data)
{
    currentData = data;

    var getId = function(timeRecord) {
        return timeRecord.id
    };
    var getJobString = function(timeRecord) {
        return timeRecord.jobString
    };
    var getServiceString = function(timeRecord) {
        return timeRecord.serviceString
    };
    var getResourceString = function(timeRecord) {
        return timeRecord.resourceString
    };
    var getItemString = function(timeRecord) {
        return timeRecord.itemString
    };
    var getPaycodeString = function(timeRecord) {
        return timeRecord.paycodeString
    };
    var getQty = function(timeRecord) {
        return timeRecord.qty.toFixed(1)
    };
    var getDate = function(timeRecord) {
        return formatDate(timeRecord.date)
    };
    var getDelete = function(timeRecord)
    {
        return '<input type="button" value="Delete" onclick="deleteRecord(' + timeRecord.id + ', \'' + timeRecord.id + '\')"/>';
    };

    dwr.util.removeAllRows("records", { escapeHtml:false });
    dwr.util.addRows("records", data, [getDate, getId, getResourceString, getJobString, getServiceString,  getItemString, getPaycodeString, getQty, getDelete], {rowCreator:myRowCreater, cellCreator:myCellCreator, escapeHtml:false});

    if (data.length == 0)
    {
        var tr = document.createElement("tr");
        tr.className = "static";
        var td = document.createElement("td");
        td.colSpan = 9;
        var textNode = document.createTextNode('<fmt:message key="servicetrax.tc.time.table.nodata"/>');
        td.appendChild(textNode);
        tr.appendChild(td);
        $("records").appendChild(tr);
    }
    else
    {
        mergeCells();
    }

    timeManager.getSubTotals(getSubTotalsCallback);

    updateWarning();

}

function mergeCells()
{
    var currentCell = null;
    var rows = $("records").getElementsByTagName("tr");
    for (var i = 0; i < rows.length; i++)
    {
        var row = rows[i];
        var cell = getCellFromRow(row, 0);
        cell.className = "header";
        if (currentCell && currentCell.innerHTML == cell.innerHTML)
        {
            row.removeChild(cell);
            currentCell.rowSpan = currentCell.rowSpan + 1;

        }
        else
        {
            currentCell = cell;
        }
    }
}

function getCellFromRow(row, cellNumber)
{
    return row.getElementsByTagName("td")[cellNumber];
}


function getSubTotalsCallback(mapData)
{
    dwr.util.removeAllRows("recordsFooter", { escapeHtml:false });
    for (var key in mapData)
    {
        var tr = createRow(["", "", "", "", "", "", key, mapData[key].toFixed(1), ""]);
        $("recordsFooter").appendChild(tr);
    }
}

function addRecord()
{
    //ids
    record.resourceId = dwr.util.getValue('resource_id_hidden', { escapeHtml:false });
    record.jobId = dwr.util.getValue('job_id_hidden', { escapeHtml:false });
    record.serviceId = dwr.util.getValue('reqs', { escapeHtml:false });
    record.itemId = dwr.util.getValue('items', { escapeHtml:false });

    record.qty = dwr.util.getValue('qty', { escapeHtml:false });
    record.paycode = dwr.util.getValue('paycodes', { escapeHtml:false });

    var dateString = dwr.util.getValue('date', { escapeHtml:false });
    var dateSplit = dateString.split("/");
    var month = parseInt(eval(dateSplit[0]), 10) - 1;
    var day = dateSplit[1];
    var year = dateSplit[2];
    var dateVal = new Date(year, month, day);
    record.date = dateVal;

    //strings
    record.resourceString = dwr.util.getValue('resource_autocomplete', { escapeHtml:false });
    record.jobString = dwr.util.getValue('job_autocomplete', { escapeHtml:false });
    record.itemString = getSelectText('items');

    // time fields
    record.startTimeHour = dwr.util.getValue('startTimeHour', { escapeHtml:false});
    record.startTimeMinutes = dwr.util.getValue('startTimeMinutes', { escapeHtml:false});
    record.startTimeAmPm = dwr.util.getValue('startTimeAmPm', { escapeHtml:false});
    record.endTimeHour = dwr.util.getValue('endTimeHour', { escapeHtml:false});
    record.endTimeMinutes = dwr.util.getValue('endTimeMinutes', { escapeHtml:false});
    record.endTimeAmPm = dwr.util.getValue('endTimeAmPm', { escapeHtml:false});
    record.breakTimeHours = dwr.util.getValue('breakTimeHours', { escapeHtml: false});
    record.breakTimeMinutes = dwr.util.getValue('breakTimeMinutes', {escapeHtml: false});

    //serviceString is updated on the server
    timeManager.addRecord(record, tableOperationCallback);

}

function populateForm(timeRecord)
{
    record = timeRecord;

    if (timeRecord)
    {
        dwr.util.setValue('resource_id_hidden', timeRecord.resourceId, { escapeHtml:false });
        dwr.util.setValue('resource_autocomplete', timeRecord.resourceString, { escapeHtml:false });
        dwr.util.setValue('job_id_hidden', timeRecord.jobId, { escapeHtml:false });
        dwr.util.setValue('job_autocomplete', timeRecord.jobString, { escapeHtml:false });

        dwr.util.setValue('paycodes', timeRecord.paycode, { escapeHtml:false });
        dwr.util.setValue('qty', timeRecord.qty, { escapeHtml:false });

        // time fields
        dwr.util.setValue('startTimeHour', timeRecord.startTimeHour, {escapeHtml:false});
        dwr.util.setValue('startTimeMinutes', timeRecord.startTimeMinutes, {escapeHtml:false});
        dwr.util.setValue('startTimeAmPm', timeRecord.startTimeAmPm, {escapeHtml:false});
        dwr.util.setValue('endTimeHour', timeRecord.endTimeHour, {escapeHtml:false});
        dwr.util.setValue('endTimeMinutes', timeRecord.endTimeMinutes, {escapeHtml:false});
        dwr.util.setValue('endTimeAmPm', timeRecord.endTimeAmPm, {escapeHtml:false});
        dwr.util.setValue('breakTimeHours', timeRecord.breakTimeHours, {escapeHtml:false});
        dwr.util.setValue('breakTimeMinutes', timeRecord.breakTimeMinutes, {escapeHtml:false});

        var now = timeRecord.date;
        if (now)
        {
            var month = now.getMonth() + 1;
            var monthDayYear = month + "/" + now.getDate() + "/" + now.getFullYear();
            dwr.util.setValue('date', monthDayYear, { escapeHtml:false });
        }
        refreshReqList();
        refreshItemList();

        dwr.util.setValue("edit_button", "<fmt:message key="servicetrax.tc.time.form.edit"/>", { escapeHtml:false });
    }
    else
    {
        resetForm();
    }
}

function resetForm()
{
    record = { id:-1};
    refreshReqList();
    refreshItemList();
    dwr.util.setValue("qty", 0, { escapeHtml:false });
    dwr.util.setValue("edit_button", "<fmt:message key="servicetrax.tc.time.form.add"/>", { escapeHtml:false });
    resetTimeFields();
    enableFormButtons();
}


function cancelEdit()
{
    updateTable();
}

record = { id:-1};


function deleteRecord(id, name)
{
    if (confirm("Are you sure you want to delete line #" + name + "?"))
    {
        timeManager.deleteRecord({ id:id }, tableOperationCallback);
    }
}

function clearRecords()
{
    if (confirm("This will remove all of the time card records.  Are you sure?"))
    {
        record = { id:-1};
        timeManager.clearRecords(tableOperationCallback);
    }
}

function commitRecords()
{
    record = { id:-1};
    timeManager.commitRecords(commitOperationCallback);
}

function tableOperationCallback(data)
{
    updateTable();
    dwr.util.setValue("message", data, { escapeHtml:false });
}

function commitOperationCallback(data)
{
    tableOperationCallback();
    if (window.opener.refreshHours)
    {
        window.opener.refreshHours();
    }
    else if (window.opener)
    {
        window.opener.location.href = window.opener.location.href;
    }
}


function enableFormButtons()
{
    var jobId = dwr.util.getValue("job_id_hidden", { escapeHtml:false });
    var resourceId = dwr.util.getValue("resource_id_hidden", { escapeHtml:false });
    var itemId = dwr.util.getValue("items", { escapeHtml:false });
    var reqId = dwr.util.getValue("reqs", { escapeHtml:false });
    var qty = parseFloat(dwr.util.getValue("qty", { escapeHtml:false }));

    if (jobId && resourceId && itemId >= 0 && reqId >= 0 && qty > 0 && isDateValid())
    {
        $("edit_button").disabled = false;
    }
    else
    {
        $("edit_button").disabled = true;
    }
    if (record && record.id > 0)
    {
        $("cancel_button").disabled = false;
    }
    else
    {
        $("cancel_button").disabled = true
    }
}

function isDateValid()
{
    var date = dwr.util.getValue("date", { escapeHtml:false });
    var dateParts = date.split("/");
    if (dateParts.length == 3)
    {
        var month = parseInt(dateParts[0], 10);
        var day = parseInt(dateParts[1], 10);
        var year = parseInt(dateParts[2], 10);

        if (month > 0 && month <= 12 && day > 0 && day <= 31 && year > 2000)
            return true;
        else
            return false;
    }
    else
    {
        return false;
    }
}


</script>


<script type="text/javascript">


    function bodyOnLoad()
    {
        var noJobs = function()
        {
            dwr.util.setValue("job_id_msg", "No Jobs", { escapeHtml:false });
        }
        var noResources = function()
        {
            dwr.util.setValue("resource_id_msg", "No resources", { escapeHtml:false });
        }

        new Autocompleter.DWR("job_autocomplete", "job_autocomplete_div", timeManager.getJobInfos, convertJobInfo, {afterUpdateElement: onChooseJob, noDataFunction: noJobs});
        new Autocompleter.DWR("resource_autocomplete", "resource_autocomplete_div", timeManager.getResources, convertResourceInfo, {afterUpdateElement: onChooseResource});

        addEvent($("items"), "change", enableFormButtons);
        addEvent($("reqs"), "change", enableFormButtons);
        addEvent($("qty"), "change", enableFormButtons);
        addEvent($("date"), "keyup", enableFormButtons);

        dwr.engine.setPreHook(function() {
            $('indicator').style.visibility = 'visible';
        });
        dwr.engine.setPostHook(function() {
            $('indicator').style.visibility = 'hidden';
        });

        var now = new Date();
        var month = now.getMonth() + 1;
        var monthDayYear = month + "/" + now.getDate() + "/" + now.getFullYear();
        dwr.util.setValue('date', monthDayYear, { escapeHtml:false });

        refreshPaycodeList();
        updateTable();

        enableFormButtons();

        loadJobInfo();
    }

    function loadJobInfo()
    {
    <c:if test="${param.jobId != null}">
    <charm:objectFetch var="job" className="Job" identifierName="jobId" identifier="${param.jobId}" />
        var jobId = ${param.jobId};

    <%--alert("jobName = " + decode("<c:out value='${job.jobName}'/>"));--%>
        var jobString = '<c:out value="${job.jobNo}"/> - ' + decode("<c:out value='${job.jobName}'/>");

        dwr.util.setValue("job_id_hidden", jobId, { escapeHtml:false });
        dwr.util.setValue("job_autocomplete", jobString, { escapeHtml:false });

        refreshReqList();
        refreshItemList();
    </c:if>
    }

    function decode(originalStr)
    {
        if (originalStr == null || originalStr == '')
        {
            return originalStr;
        }
        else
        {
            return originalStr.replace("&#039;", "\'").replace('&#034;', '\"');
        }
    }

</script>

</head>


<body onload="bodyOnLoad()" style="margin-left:20px;margin-right:20px;">

<h2 id="title"><fmt:message key="servicetrax.tc.driverTime.title"/></h2>

<form name="entryForm">
    <table class="formTable" border="0">
        <tbody>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.date"/></td>
            <td class="control">
                <stc:hasRight function="time_modify_date" rightType="view">
                    <charm:calendar name="date" id="date"/>
                </stc:hasRight>
                <stc:hasRightElse>
                <input name="date" id="date" readonly/>
                </stc:hasRightElse>
            <td></td>
            <td align="right" rowspan="2" colspan="2">
                <div id="indicator"><img src="<c:url value="/images/indicator_medium.gif"/>" alt="indicator"/></div>
            </td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.resource"/></td>
            <td class="control"><input type="hidden" name="resource_id_hidden" id="resource_id_hidden" value="-1"/>
                <input autocomplete="off" type="text" id="resource_autocomplete" style="width:300px;"/>

                <div class="auto_complete" id="resource_autocomplete_div"></div>
            </td>
            <td class="controlMessage"><span id="resource_id_msg">&nbsp;</span></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.job"/></td>
            <td class="control"><input type="hidden" name="job_id_hidden" id="job_id_hidden" value="-1"/>
                <input autocomplete="off" type="text" id="job_autocomplete" style="width:300px;"/>

                <div class="auto_complete" id="job_autocomplete_div"></div>
            </td>
            <td class="controlMessage"><span id="job_id_msg">&nbsp;</span></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.req"/></td>
            <td class="control"><select id="reqs">
                <option/>
            </select></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.item"/></td>
            <td class="control"><select id="items">
                <option/>
            </select></td>
        </tr>
        <tr>
            <td class="label"><fmt:message key="servicetrax.tc.time.form.paycode"/></td>
            <td class="control"><select id="paycodes">
                <option/>
            </select></td>
        </tr>

        <tr>
            <td colspan="2">
                <table border="0" style="margin-left:-3px; margin-top:-10px;">
                    <tr>
                        <td style="padding-top:10px;">
                            Start Time
                        </td>
                        <td style="padding-left:28px; padding-top:10px;">
                            <label>
                                <select name="start_time_hour" id="startTimeHour" class="regular"
                                        onchange="calculateHours();">
                                    <option value="0">12</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                </select>
                            </label>
                        </td>
                        <td style="padding-top:10px;">
                            <label>
                                <select name="start_time_minutes" id="startTimeMinutes" class="regular"
                                        onchange="calculateHours();">
                                    <option value="00">00</option>
                                    <option value="15">15</option>
                                    <option value="30">30</option>
                                    <option value="45">45</option>
                                </select>
                            </label>
                        </td>

                        <td style="padding-top:10px;">
                            <label>
                                <select name="start_time_AMPM" id="startTimeAmPm" class="regular"
                                        onchange="calculateHours();">
                                    <option value="AM">AM</option>
                                    <option value="PM">PM</option>
                                </select>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            End Time
                        </td>
                        <td style="padding-left:28px;">
                            <label>
                                <select name="end_time_hour" id="endTimeHour" class="regular"
                                        onchange="calculateHours();">
                                    <option value="0">12</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                </select>
                            </label>
                        </td>
                        <td>
                            <label>
                                <select name="end_time_minutes" id="endTimeMinutes" class="regular"
                                        onchange="calculateHours();">
                                    <option value="00">00</option>
                                    <option value="15">15</option>
                                    <option value="30">30</option>
                                    <option value="45">45</option>
                                </select>
                            </label>
                        </td>
                        <td>
                            <label>
                                <select name="end_time_AMPM" id="endTimeAmPm" class="regular"
                                        onchange="calculateHours();">
                                    <option value="AM">AM</option>
                                    <option value="PM">PM</option>
                                </select>
                            </label>
                        </td>
                    <tr>
                        <td>
                            Lunch/Dinner
                        </td>
                        <td style="padding-left:28px;">
                            <label>
                                <select name="lunch_dinner_hours" id="breakTimeHours" class="regular"
                                        onchange="calculateHours();">
                                    <option value="0">0&nbsp;&nbsp;</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </label>
                        </td>
                        <td colspan="2">
                            <label>
                                <select name="lunch_dinner_minutes" id="breakTimeMinutes" class="regular"
                                        onchange="calculateHours();">
                                    <option value="00">00</option>
                                    <option value="15">15</option>
                                    <option value="30">30</option>
                                    <option value="45">45</option>
                                </select>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-top:5px;">
                            Hrs. Worked
                        </td>
                        <td colspan="3" style="padding-top:5px; padding-left:28px;">
                            <label>
                                <input type="text" id=qty name="qty" size="10" value=""
                                       class="regular" disabled style="height:13px;">
                            </label>
                        </td>
                    </tr>
                </table>
            </td>

        </tr>

        <tr>
            <td colspan="4" align="left">
                <input type="button" name="edit_button" id="edit_button" value="" onclick="addRecord()"/>
                <input type="button" name="cancel_button" id="cancel_button"
                       value="<fmt:message key="servicetrax.tc.time.form.cancel"/>" onclick="cancelEdit()"/>
            </td>
        </tr>
        </tbody>
    </table>
</form>

<div id="message">
</div>

<table class="recordsTable">
    <thead>
    <tr>
        <th><fmt:message key="servicetrax.tc.time.table.date"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.line"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.resource"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.job"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.req"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.item"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.paycode"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.qty"/></th>
        <th><fmt:message key="servicetrax.tc.time.table.action"/></th>
    </tr>
    </thead>
    <tbody id="records">
    <tr>
        <td></td>
    </tr>
    </tbody>
    <tfoot id="recordsFooter">
    <tr>
        <td></td>
    </tr>
    </tfoot>
</table>
<br/>

<input type="button" name="Done" value="<fmt:message key="servicetrax.tc.time.table.done"/>" onclick="commitRecords()"/>
<input type="button" name="Clear" value="<fmt:message key="servicetrax.tc.time.table.clear"/>"
       onclick="clearRecords()"/>

<div id="warn">
</div>

</body>
</html>
