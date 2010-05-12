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
    var hours = document.getElementById('qty');
    hours.value = netHours.toFixed(2);
    enableFormButtons();
    return netHours;
}

function getValue(widgetName) {
    var widget = document.getElementById(widgetName);
    return widget.options[widget.selectedIndex].value;
}