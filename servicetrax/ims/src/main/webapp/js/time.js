<!--

$(document).ready(function() {
    $(lunch_dinner_hours).val('0');
    $(lunch_dinner_minutes).val('0');
    $(num_hours).val('0');
    calculateHours();
});

function calculateHoursOnSubmit() {
    var hours = calculateHours();
    if (hours == undefined || hours < 0) {
        alert("Hours worked must be more than 0");
        return false;
    }
    return true;
}

function calculateHours() {

    var lunchDinnerHours = $(lunch_dinner_hours).val();
    var lunchDinnerMinutes = $(lunch_dinner_minutes).val();

    var startHours = $(start_time_hour).val();
    var startMinutes = $(start_time_minutes).val();
    var startAMPM = $(start_time_AMPM).val();
    var start = parseInt(startHours * 60) + parseInt(startMinutes);
    if (startAMPM == 'PM') {
        start += 720;
    }

    var endHours = $(end_time_hour).val();
    var endMinutes = $(end_time_minutes).val();
    var endAMPM = $(end_time_AMPM).val();
    var end = parseInt(endHours * 60) + parseInt(endMinutes);
    if (endAMPM == 'PM') {
        end += 720;
    }

    var breakTime = parseInt(lunchDinnerHours * 60) + parseInt(lunchDinnerMinutes);
    var netHours = ((end - start) - breakTime) / 60.0;
    $(num_hours).val(netHours.toFixed(2));
    return netHours.toFixed(2);
}

//-->