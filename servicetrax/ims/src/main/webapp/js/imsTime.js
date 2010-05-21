var popupHours;
var popupServiceLineId;

function init() {
	// Define various event handlers for Dialog
	var handleSubmit = function() {
        var hours = document.getElementById('popup_num_hours').value;
        var testHours = hours + 0;
        if(testHours <= 0) {
            alert("Please enter a time that is more than 0 hours.");
            return false;
        }

        setFormValue(popupServiceLineId + '_num_hours', hours);
        setFormValue(popupServiceLineId + '_num_hours_display', hours);

        var lunchDinnerHours = getValue('popup_lunch_dinner_hours');
        setFormValue(popupServiceLineId + '_lunch_dinner_hours', lunchDinnerHours);

        var lunchDinnerMinutes = getValue('popup_lunch_dinner_minutes');
        setFormValue(popupServiceLineId + '_lunch_dinner_minutes', lunchDinnerMinutes);

        var startHours = getValue('popup_start_time_hour');
        setFormValue(popupServiceLineId + '_start_time_hour', startHours);

        var startMinutes = getValue('popup_start_time_minutes');
        setFormValue(popupServiceLineId + '_start_time_minutes', startMinutes);

        var startAMPM = getValue('popup_start_time_AMPM');
        setFormValue(popupServiceLineId + '_start_time_AMPM', startAMPM);

        var endHours = getValue('popup_end_time_hour');
        setFormValue(popupServiceLineId + '_end_time_hour', endHours);

        var endMinutes = getValue('popup_end_time_minutes');
        setFormValue(popupServiceLineId + '_end_time_minutes', endMinutes);

        var endAMPM = getValue('popup_end_time_AMPM');
        setFormValue(popupServiceLineId + '_end_time_AMPM', endAMPM);

        changed(popupServiceLineId + '_changed');

	    popupHours.hide();

	    return true;
	};

	var handleCancel = function() {
	    popupHours.hide();
	};

    popupHours = new YAHOO.widget.Dialog("popupHoursDiv", { width : "300px",
												    fixedcenter : true,
													visible : false,
													constraintoviewport : true,
													buttons : [ { text:"Change", handler:handleSubmit, isDefault:true },
																{ text:"Cancel", handler:handleCancel } ]
							     } );

	popupHours.render();

	YAHOO.util.Event.addListener("hide", "click", popupHours.hide, popupHours, true);
}

function initializeTimeFields() {
    document.getElementById('lunch_dinner_hours').selectedIndex = 0;
    document.getElementById('lunch_dinner_minutes').selectedIndex = 0
    document.getElementById('num_hours').value = '0';
    calculateHours();
}

function showPopup(serviceLineId) {
    popupServiceLineId = serviceLineId;

    var lunchDinnerHours = getFormValue(popupServiceLineId + '_lunch_dinner_hours');
    setValue('popup_lunch_dinner_hours', lunchDinnerHours);

    var lunchDinnerMinutes = getFormValue(popupServiceLineId + '_lunch_dinner_minutes');
    setValue('popup_lunch_dinner_minutes', lunchDinnerMinutes);

    var startHours = getFormValue(popupServiceLineId + '_start_time_hour');
    setValue('popup_start_time_hour', startHours);

    var startMinutes = getFormValue(popupServiceLineId + '_start_time_minutes');
    setValue('popup_start_time_minutes', startMinutes);

    var startAMPM = getFormValue(popupServiceLineId + '_start_time_AMPM');
    setValue('popup_start_time_AMPM', startAMPM);

    var endHours = getFormValue(popupServiceLineId + '_end_time_hour');
    setValue('popup_end_time_hour', endHours);

    var endMinutes = getFormValue(popupServiceLineId + '_end_time_minutes');
    setValue('popup_end_time_minutes', endMinutes);

    var endAMPM = getFormValue(popupServiceLineId + '_end_time_AMPM');
    setValue('popup_end_time_AMPM', endAMPM);

    calculatePopupHours();
    
    popupHours.show();
}

function calculateHoursOnSubmit() {
    var hours = calculateHours();
    if (hours == undefined || hours <= 0) {
        alert("Hours worked must be more than 0");
        return false;
    }
    return true;
}

function calculateHours() {

    var lunchDinnerHours = getValue('lunch_dinner_hours');
    var lunchDinnerMinutes = getValue('lunch_dinner_minutes');

    var startHours = getValue('start_time_hour');
    var startMinutes = getValue('start_time_minutes');
    var startAMPM = getValue('start_time_AMPM');
    var start = parseInt(startHours * 60) + parseInt(startMinutes);
    if (startAMPM == 'PM') {
        start += 720;
    }

    var endHours = getValue('end_time_hour');
    var endMinutes = getValue('end_time_minutes');
    var endAMPM = getValue('end_time_AMPM');
    var end = parseInt(endHours * 60) + parseInt(endMinutes);
    if (endAMPM == 'PM') {
        end += 720;
    }

    var breakTime = parseInt(lunchDinnerHours * 60) + parseInt(lunchDinnerMinutes);
    var netHours = ((end - start) - breakTime) / 60.0;
    var hours = document.getElementById('num_hours');
    hours.value = netHours.toFixed(2);
    return netHours;
}

function calculatePopupHours() {

    var lunchDinnerHours = getValue('popup_lunch_dinner_hours');
    var lunchDinnerMinutes = getValue('popup_lunch_dinner_minutes');

    var startHours = getValue('popup_start_time_hour');
    var startMinutes = getValue('popup_start_time_minutes');
    var startAMPM = getValue('popup_start_time_AMPM');
    var start = parseInt(startHours * 60) + parseInt(startMinutes);
    if (startAMPM == 'PM') {
        start += 720;
    }

    var endHours = getValue('popup_end_time_hour');
    var endMinutes = getValue('popup_end_time_minutes');
    var endAMPM = getValue('popup_end_time_AMPM');
    var end = parseInt(endHours * 60) + parseInt(endMinutes);
    if (endAMPM == 'PM') {
        end += 720;
    }

    var breakTime = parseInt(lunchDinnerHours * 60) + parseInt(lunchDinnerMinutes);
    var netHours = ((end - start) - breakTime) / 60.0;
    var hours = document.getElementById('popup_num_hours');
    hours.value = netHours.toFixed(2);
    return netHours;
}

function getFormValue(widgetName) {
    var form = document.getElementById('enterHoursForm');
    var widget = form.elements[widgetName];
    return widget.value;
}

function setFormValue(widgetName, value) {
    var form = document.getElementById('enterHoursForm');
    var widget = form.elements[widgetName];
    widget.value = value;
}

function setValue(widgetName, value) {
    var widget = document.getElementById(widgetName);
    widget.value = value;
}

function getValue(widgetName) {
    var widget = document.getElementById(widgetName);
    return widget.options[widget.selectedIndex].value;
}