function calculateHours() {

    var lunchDinnerHours = getValue('breakTimeHours');
    var lunchDinnerMinutes = getValue('breakTimeMinutes');

    var startHours = getValue('startTimeHour');
    var startMinutes = getValue('startTimeMinutes');
    var startAMPM = getValue('startTimeAmPm');
    var start = parseInt(startHours * 60) + parseInt(startMinutes);
    if (startAMPM == 'PM') {
        start += 720;
    }

    var endHours = getValue('endTimeHour');
    var endMinutes = getValue('endTimeMinutes');
    var endAMPM = getValue('endTimeAmPm');
    var end = parseInt(endHours * 60) + parseInt(endMinutes);
    if (endAMPM == 'PM') {
        end += 720;
    }

    var breakTime = parseInt(lunchDinnerHours * 60) + parseInt(lunchDinnerMinutes);
    var netHours = ((end - start) - breakTime) / 60.0;
    var hours = document.getElementById('qty');
    hours.value = netHours.toFixed(2);
    enableFormButtons();
    return netHours;
}

function getValue(widgetName) {
    var widget = document.getElementById(widgetName);
    return widget.options[widget.selectedIndex].value;
}