//secondRow.jsp - javascript to support the addJobLocation and addOriginContact dialog
YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeOriginAddress();
    initializeOriginContact();
});

function initializeOriginContact() {
    // Define various event handlers for new origin address
    var handleContactSubmit = function() {
        this.submit();
    };
    var handleContactCancel = function() {
        this.cancel();
    };

    var handleContactSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var originContactDropdown = document.getElementById("originContactDropdown");
        var currentSelection = originContactDropdown.value;
        originContactDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            originContactDropdown.options.add(newOption);
            newOption.value = messages[i].CONTACT_ID;
            newOption.text = messages[i].CONTACT_NAME;
            if (newOption.value == currentSelection) {
                document.getElementById("originContactPhone").value = messages[i].PHONE_WORK;
                document.getElementById("originContactName").value = messages[i].CONTACT_NAME;
            }
        }
        originContactDropdown.value = currentSelection;
    };

    var handleContactFailure = function(o) {
        alert("Add origin contact failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addContact", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addContact = new YAHOO.widget.Dialog("addOriginContact",
                                                                 { width : "30em",
                                                                     fixedcenter : true,
                                                                     visible : false,
                                                                     constraintoviewport : true,
                                                                     buttons : [
                                                                         { text:"Submit", handler:handleContactSubmit, isDefault:true },
                                                                         { text:"Cancel", handler:handleContactCancel }
                                                                     ]
                                                                 });

    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addContact.validate = function() {

        var data = this.getData();

        if (data == undefined) {
            return false;
        }

        if (YAHOO.lang.trim(data.contactName) == "") {
            alert("A name is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.contactPhone) == "") {
            alert("A phone is required.");
            return false;
        }
        return true;
    };

    // Wire up the success and failure handlers
    YAHOO.example.container.addContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    // Render the Dialog
    YAHOO.example.container.addContact.render();

    YAHOO.util.Event.addListener("newOriginContact", "click", YAHOO.example.container.addContact.show, YAHOO.example.container.addContact, true);

}


function initializeOriginAddress() {
    // Define various event handlers for new origin address
    var handleLocationSubmit = function() {
        this.submit();
    };
    var handleLocationCancel = function() {
        this.cancel();
    };

    var handleLocationSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        var originAddressDropdown = document.getElementById("originAddressDropdown");
        var currentSelection = originAddressDropdown.value;
        originAddressDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            originAddressDropdown.options.add(newOption);
            newOption.value = messages[i].jobLocationId;
            newOption.text = messages[i].jobLocationName;
            if (newOption.value == currentSelection) {
                document.getElementById("originAddress.jobLocationName").value = messages[i].jobLocationName;
                document.getElementById("originAddress.streetOne").value = messages[i].streetOne;
                var cityStateZip = messages[i].city + ' ' + messages[i].state + ' ' + messages[i].zip;
                document.getElementById("cityStateZip").value = cityStateZip;
            }
        }
        originAddressDropdown.value = currentSelection;
    };

    var handleLocationFailure = function(o) {
        alert("Add job location failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addJobLocation", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addJobLocation = new YAHOO.widget.Dialog("addJobLocation",
                                                                     { width : "30em",
                                                                         fixedcenter : true,
                                                                         visible : false,
                                                                         constraintoviewport : true,
                                                                         buttons : [
                                                                             { text:"Submit", handler:handleLocationSubmit, isDefault:true },
                                                                             { text:"Cancel", handler:handleLocationCancel }
                                                                         ]
                                                                     });

    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addJobLocation.validate = function() {

        var data = this.getData();

        if (data == undefined) {
            return false;
        }

        if (YAHOO.lang.trim(data.jobLocationName) == "") {
            alert("A job location name is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.streetOne) == "") {
            alert("An address is required.");
            return false;
        }

        if (YAHOO.lang.trim(data.city) == "") {
            alert("A city is required.");
            return false;
        }

        var isZip = /^\d{5}([\-]\d{4})?$/;
        if (YAHOO.lang.trim(data.zip) == "" || !isZip.test(data.zip)) {
            alert("A valid zip code is required.");
            return false;
        }

        return true;
    };

    // Wire up the success and failure handlers
    YAHOO.example.container.addJobLocation.callback = {
        success: handleLocationSuccess,
        failure: handleLocationFailure
    };

    // Render the Dialog
    YAHOO.example.container.addJobLocation.render();

    YAHOO.util.Event.addListener("newOriginAddress", "click", YAHOO.example.container.addJobLocation.show, YAHOO.example.container.addJobLocation, true);

}


YAHOO.util.Event.on('originAddressDropdown', 'change', function (event) {

    var callbacks = {

        start : function(o) {
            document.getElementById('spinner').style.visibility = 'visible';
        },

        complete : function(o) {
            document.getElementById('spinner').style.visibility = 'hidden';
        },

        success : function (o) {
            var messages = [];
            try {
                messages = YAHOO.lang.JSON.parse(o.responseText);
                document.getElementById("originAddress.jobLocationName").value = messages['jobLocationName'];
                document.getElementById("originAddress.streetOne").value = messages['streetOne'];
                var cityStateZip = messages['city'] + ' ' + messages['state'] + ' ' + messages['zip'];
                document.getElementById("cityStateZip").value = cityStateZip;
            }
            catch (exception) {
                alert("JSON Parse failed: " + exception);
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        failure : function (o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        // 10 second timeout
        timeout : 10000
    };

    YAHOO.util.Connect.startEvent.subscribe(callbacks.start, callbacks);
    YAHOO.util.Connect.completeEvent.subscribe(callbacks.complete, callbacks);

    var id = this.value;
    var url = '/stc/updateOriginAddress.html?jobLocationId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});

YAHOO.util.Event.on('originContactDropdown', 'change', function (event) {

    var callbacks = {

        start : function(o) {
            document.getElementById('spinner').style.visibility = 'visible';
        },

        complete : function(o) {
            document.getElementById('spinner').style.visibility = 'hidden';
        },

        success : function (o) {
            var messages = [];
            try {
                messages = YAHOO.lang.JSON.parse(o.responseText);
                document.getElementById("originContactPhone").value = messages['PHONE_WORK'];
                document.getElementById("originContactName").value = messages['CONTACT_NAME'];
            }
            catch (exception) {
                alert("JSON Parse failed: " + exception);
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        failure : function (o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                document.getElementById('spinner').style.visibility = 'hidden';
            }
        },

        // 10 second timeout
        timeout : 10000
    };

    YAHOO.util.Connect.startEvent.subscribe(callbacks.start, callbacks);
    YAHOO.util.Connect.completeEvent.subscribe(callbacks.complete, callbacks);

    var id = this.value;
    var url = '/stc/updateOriginContact.html?originContactId=' + id;
    YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
});



