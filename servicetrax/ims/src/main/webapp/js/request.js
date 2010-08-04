function on_load_request()
{
    if (document.getElementById("ims_action"))
    {
        document.getElementById("ims_action").value = "";
    }
}


function showHideViewCustomerButton()
{
    id = document.getElementById("customer_id").value;
    if (id == null || id == "")
    {
        document.getElementById("viewCustomerButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("viewCustomerButtonDiv").style.display = "block";
    }
}

function showHideNewCustomerContactButton()
{
    id = document.getElementById("customer_id").value;

    if (id == null || id == "")
    {
        document.getElementById("newCustContact1ButtonDiv").style.display = "none";
        document.getElementById("newCustContact2ButtonDiv").style.display = "none";
        document.getElementById("newCustContact3ButtonDiv").style.display = "none";
        document.getElementById("newCustContact4ButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("newCustContact1ButtonDiv").style.display = "block";
        document.getElementById("newCustContact2ButtonDiv").style.display = "block";
        document.getElementById("newCustContact3ButtonDiv").style.display = "block";
        document.getElementById("newCustContact4ButtonDiv").style.display = "block";
    }
}

/*
 function showHideVewCustomerContactButton()
 {
 id = document.getElementById("customer_contact_id").value;

 if (id == null || id == "")
 {
 document.getElementById("viewCustContact1ButtonDiv").style.display="none";
 }
 else
 {
 document.getElementById("viewCustContact1ButtonDiv").style.display="none";
 }
 }

 function showHideViewCustomerCotnactButton(index)
 {
 alert("In showHideViewCustomerCotnactButton. index = " + index);
 var id = "";

 if (index == 1)
 {
 id = document.getElementById("customer_contact_id").value;
 }
 else
 {
 id = document.getElementById("customer_contact" + index + "_id").value;
 }

 alert("In showHideViewCustomerCotnactButton. id = " + id);

 if (id == null || id == "")
 {
 document.getElementById("viewCustContact" + index + "ButtonDiv").style.display="none";
 }
 else
 {
 document.getElementById("viewCustContact" + index + "ButtonDiv").style.display="block";
 }
 }
 */

function showHideNewEndUserButton()
{
    c_id = document.getElementById("customer_id").value;
    if (c_id == null || c_id == "")
    {
        document.getElementById("newEndUserButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("newEndUserButtonDiv").style.display = "block";
    }
}

function showHideViewEndUserButton()
{
    eu_id = document.getElementById("end_user_id").value;
    if (eu_id == null || eu_id == "")
    {
        document.getElementById("viewEndUserButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("viewEndUserButtonDiv").style.display = "block";
    }
}

function showHideNewJobLocationtButton()
{
    id = document.getElementById("end_user_id").value;

    if (id == null || id == "")
    {
        document.getElementById("newJobLocationButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("newJobLocationButtonDiv").style.display = "block";
    }
}

function showHideViewJobLocationtButton()
{
    id = document.getElementById("job_location_id").value;

    if (id == null || id == "")
    {
        document.getElementById("viewJobLocationButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("viewJobLocationButtonDiv").style.display = "block";
    }
}

function showHideNewJobLocationContactButton()
{
    id = document.getElementById("job_location_id").value;

    if (id == null || id == "")
    {
        document.getElementById("newJobLocContactButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("newJobLocContactButtonDiv").style.display = "block";
    }
}

function showHideViewJobLocationContactButton()
{
    id = document.getElementById("job_location_contact_id").value;

    if (id == null || id == "")
    {
        document.getElementById("viewJobLocContactButtonDiv").style.display = "none";
    }
    else
    {
        document.getElementById("viewJobLocContactButtonDiv").style.display = "block";
    }
}


function resetCustomerContacts()
{
    c_id = document.getElementById("customer_id").value;

    for (i = 1; i < 5; i ++)
    {
        loadCustomerContact(c_id, i);
    }
}

function onSystemFurnitureChange()
{
    var furn_type_na_id = document.getElementById("furniture_line_type_na").value;
    var deliv_type_na_id = document.getElementById("delivery_type_na").value;
    var sys_furn_type = document.getElementById("system_furniture_line_type_id").value;

    if (sys_furn_type == furn_type_na_id)
    {
        document.getElementById("delivery_type_id").value = deliv_type_na_id;
    }

}

function updateCustomer()
{
    document.getElementById("customer_id").value = document.getElementById("current_customer_id").value;
}

function updateEndUser()
{
    document.getElementById("end_user_id").value = document.getElementById("current_end_user_id").value;
}

function updateJobLocation()
{
    document.getElementById("job_location_id").value = document.getElementById("current_job_location_id").value;
}

function updateContact(contactType, index)
{
    var new_value;
    if (contactType == "customer")
    {
        new_value = document.getElementById("current_customer_contact_id" + index).value;
        if (index == "1")
        {
            document.getElementById("customer_contact_id").value = new_value;
        }
        else
        {
            document.getElementById("customer_contact" + index + "_id").value = new_value;
        }
    }
    else {
        if (contactType == "job_location")
        {
            new_value = document.getElementById("current_job_location_contact_id").value;
            document.getElementById("job_location_contact_id").value = new_value;
        }
    }

}

function saveAndRedisplay()
{
    valid = validateSave()

    if (valid)
    {
        document.getElementById("ims_action").value = "save_and_redisplay";
        exitFunction('Save');

        //alert("It is valid");
    }
}

function validateSave()
{
    var result = true;

    if (result && document.getElementById("project_type_id").value == "")
    {
        alert("Type of Service is required.");
        document.getElementById("project_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("customer_id").value == "")
    {
        alert("Customer is required.");
        document.getElementById("customer_id").focus();
        result = false;
    }

    if (result && document.getElementById("end_user_id").value == "")
    {
        alert("End User is required.");
        document.getElementById("end_user_id").focus();
        result = false;
    }

    return result;
}

function validateCommissionMarkups()
{
    if (result && document.getElementById("fuel_surcharge").value == "")
    {
        alert("Fuel surcharge needs to be selected.");
        document.getElementById("fuel_surcharge").focus();
        return false;
    }

    if (result && document.getElementById("labor_markup").value == "")
    {
        alert("A labor markup needs to be selected.");
        document.getElementById("labor_markup").focus();
        return false;
    }

    if (result && document.getElementById("trucking_markup").value == "")
    {
        alert("A trucking markup needs to be selected.");
        document.getElementById("trucking_markup").focus();
        return false;
    }

    if (result && document.getElementById("expense_markup").value == "")
    {
        alert("An expense markup needs to be selected.");
        document.getElementById("expense_markup").focus();
        return false;
    }


    return true;
}


function validateSendCommons()
{
    var result = validateSave();

    if (result && document.getElementById("a_m_contact_id").value == "")
    {
        alert("Omni Project Manager is required.");
        document.getElementById("a_m_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("job_name").value == "")
    {
        alert("Project Name is required.");
        document.getElementById("job_name").focus();
        result = false;
    }

    if (result && document.getElementById("a_m_sales_contact_id").value == "")
    {
        alert("Omni Sales Person is required.");
        document.getElementById("a_m_sales_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("customer_contact_id").value == "")
    {
        alert("Customer Contact 1 is required.");
        //	document.getElementById("customer_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("est_start_date").value == "")
    {
        alert("Requested Service Date is required.");
        document.getElementById("est_start_date").focus();
        result = false;
    }

    if (result && document.getElementById("est_end_date").value == "")
    {
        alert("Requested Completion Date is required.");
        document.getElementById("est_end_date").focus();
        result = false;
    }

    if (result && document.getElementById("days_to_complete").value == "")
    {
        alert("Number of Days to Complete is required.");
        document.getElementById("days_to_complete").focus();
        result = false;
    }

    if (result && document.getElementById("system_furniture_line_type_id").value == "")
    {
        alert("Systems Furniture is required.");
        document.getElementById("system_furniture_line_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("delivery_type_id").value == "")
    {
        alert("Systems Furniture Shipping Method is required.");
        document.getElementById("delivery_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("other_furniture_type_id").value == "")
    {
        alert("Other Furniture is required.");
        document.getElementById("other_furniture_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("other_delivery_type_id").value == "")
    {
        alert("Other Furniture Shipping Method is required.");
        document.getElementById("other_delivery_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("prod_disp_id").value == "")
    {
        alert("Extra Product Disposition is required.");
        document.getElementById("prod_disp_id").focus();
        result = false;
    }

    if (result && document.getElementById("wall_mount_type_id").value == "")
    {
        alert("Wall Mount is required.");
        document.getElementById("wall_mount_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("elevator_avail_type_id").value == "")
    {
        alert("Delivery Conditions is required.");
        document.getElementById("elevator_avail_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("is_stair_carry_required").value == "")
    {
        alert("Stair Carry Required is required.");
        document.getElementById("is_stair_carry_required").focus();
        result = false;
    }

    if (result && document.getElementById("job_location_id").value == "")
    {
        alert("Job Location is required.");
        document.getElementById("job_location_id").focus();
        result = false;
    }

    if (result && document.getElementById("job_location_contact_id").value == "")
    {
        alert("Job Location Contact is required.");
        document.getElementById("job_location_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("quote_type_id").value == "")
    {
        alert("Billing Type is required.");
        document.getElementById("quote_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("taxable_flag").value == "")
    {
        alert("Sales Tax is required.");
        document.getElementById("taxable_flag").focus();
        result = false;
    }

    if (result && document.getElementById("customer_costing_type_id").value == "")
    {
        alert("Customer Costing is required.");
        document.getElementById("customer_costing_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("description").value == "")
    {
        alert("Narrative Work Request is required.");
        document.getElementById("description").focus();
        result = false;
    }

    if (result && document.getElementById("plan_location_type_id") != null && document.getElementById("plan_location_type_id").value == "")
    {
        alert("Plan Location is required.");
        document.getElementById("plan_location_type_id").focus();
        result = false;
    }
    return result;
}

function validateSendQuoteRequest()
{
    return validateSendCommons();
}

function validateSendServiceRequest()
{
    var result = validateSendCommons();
    if (result && document.getElementById("display_markup_widgets").value == "true" &&
            document.getElementById("has_existing_invoices").value == "false") {
        result = validateCommissionMarkups();
    }

    // alert("ext_customer_id = " + document.getElementById("ext_customer_id").value);
    if (result && trim(document.getElementById("ext_customer_id").value) == "")
    {
        alert("Customer must be setup/synchronized in Great Plain before sending service request.");
        //document.getElementById("customer_id").focus();
        result = false;
    }

    if (result && document.getElementById("schedule_with_client_flag").value == "")
    {
        alert("Omni Schedule with Client is required.");
        document.getElementById("schedule_with_client_flag").focus();
        result = false;
    }

    if (result && document.getElementById("schedule_type_id").value == "")
    {
        alert("Schedule Type is required.");
        document.getElementById("schedule_type_id").focus();
        result = false;
    }
    /*
     if (result && document.getElementById("est_start_time").value == "")
     {
     alert("Requested Start Time is required.");
     document.getElementById("est_start_time").focus();
     result = false;
     }
     */
    if (result && document.getElementById("dealer_po_no").value == "")
    {
        alert("Purchase Order is required.");
        document.getElementById("dealer_po_no").focus();
        result = false;
    }

    if (result && document.getElementById("dealer_po_line_no").value == "")
    {
        alert("PO Line Number is required.");
        document.getElementById("dealer_po_line_no").focus();
        result = false;
    }

    if (result && document.getElementById("order_type_id").value == "")
    {
        alert("Order Type is required.");
        document.getElementById("order_type_id").focus();
        result = false;
    }
    /*
     if (result && (document.getElementById("po_count").value == "0" || document.getElementById("po_count").value == ""))
     {
     alert("At least one PO has to be released.");
     //document.getElementById("order_type_id").focus();
     result = false;
     }
     */
    return result;
}

function validateSaveProjectFolder()
{
    var result = validateSave();

    if (result && document.getElementById("project_no").value == "")
    {
        alert("Service Account is required.");
        document.getElementById("project_no").focus();
        result = false;
    }

    if (result && document.getElementById("a_m_contact_id").value == "")
    {
        alert("Omni Project Manager is required.");
        document.getElementById("a_m_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("job_name").value == "")
    {
        alert("Project Name is required.");
        document.getElementById("job_name").focus();
        result = false;
    }

    if (result && document.getElementById("a_m_sales_contact_id").value == "")
    {
        alert("Omni Sales Person is required.");
        document.getElementById("a_m_sales_contact_id").focus();
        result = false;
    }

    if (result && document.getElementById("customer_contact_id").value == "")
    {
        alert("Customer Contact 1 is required.");
        result = false;
    }

    if (result && document.getElementById("job_location_id").value == "")
    {
        alert("Job Location is required.");
        document.getElementById("job_location_id").focus();
        result = false;
    }

    if (result && document.getElementById("job_location_contact_id").value == "")
    {
        alert("Job Location Contact is required.");
        document.getElementById("job_location_contact_id").focus();
        result = false;
    }
    if (result && document.getElementById("schedule_type_id").value == "")
    {
        alert("Schedule Type is required.");
        document.getElementById("schedule_type_id").focus();
        result = false;
    }
    if (result && document.getElementById("est_start_date").value == "")
    {
        alert("Requested Service Date is required.");
        document.getElementById("est_start_date").focus();
        result = false;
    }
    if (result && document.getElementById("est_end_date").value == "")
    {
        alert("Requested Completion Date is required.");
        document.getElementById("est_end_date").focus();
        result = false;
    }
    if (result && document.getElementById("delivery_type_id").value == "")
    {
        alert("Systems Furniture Shipping Method is required.");
        document.getElementById("delivery_type_id").focus();
        result = false;
    }
    if (result && document.getElementById("dealer_po_no").value == "")
    {
        alert("Purchase Order is required.");
        document.getElementById("dealer_po_no").focus();
        result = false;
    }

    if (result && document.getElementById("dealer_po_line_no").value == "")
    {
        alert("PO Line Number is required.");
        document.getElementById("dealer_po_line_no").focus();
        result = false;
    }

    if (result && document.getElementById("taxable_flag").value == "")
    {
        alert("Sales Tax is required.");
        document.getElementById("taxable_flag").focus();
        result = false;
    }

    if (result && document.getElementById("customer_costing_type_id").value == "")
    {
        alert("Customer Costing is required.");
        document.getElementById("customer_costing_type_id").focus();
        result = false;
    }

    if (result && document.getElementById("description").value == "")
    {
        alert("Narrative Work Request is required.");
        document.getElementById("description").focus();
        result = false;
    }

    return result;
}

function trim(textToTrim)
{
    while (textToTrim.charAt(0) == ' ')
    {
        textToTrim = textToTrim.substring(1);
    }

    while (textToTrim.charAt(textToTrim.length - 1) == ' ')
    {
        textToTrim = textToTrim.substring(0, textToTrim.length - 1);
    }

    return textToTrim;
}

function fieldValidator(field, type)
{
    var failure = false;
    var value = "";
    if (type == "number")
    {
        var c = null;
        for (var i = 0; i < field.value.length; i++)
        {
            c = field.value.charAt(i);
            if (isNaN(c)) //&& c!= '.' && c != ' ' && c != ',' && c != '&')
            {
                failure = true;
            }
            else
            {
                value += c;
            }
        }
        if (failure)
        {
            field.value = value;
            alert("This field only accepts " + type + "s...");
        }
    }
}

function showMap(p1, p2, p3, p4, p5)
{
    url = "http://www.mapquest.com/maps/map.adp?formtype=address&addtohistory=&address=";
    addr = p1;
    if (p2 != null && p2 != "")
    {
        addr = addr + " " + p2;
    }

    url += escape(addr);
    url += "&city=" + escape(p3);
    url += "&state=" + p4;
    if (p5 != null && p5 != "")
    {
        url += "&zipcode=" + escape(p5);
    }
    url += "&country=US&geodiff=1";

    // alert("url = " + url);

    newWindow(url, 'map');
}

function textCounter(field, countfield, maxlimit, action)
{
    if (field.value.length > maxlimit)
    {
        field.value = field.value.substring(0, maxlimit);
        alert("You can only type " + maxlimit + " letters in this field.");
    }
    else
    {
        countfield.value = maxlimit - field.value.length;
    }
}
