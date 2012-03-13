YAHOO.namespace("example.container");
YAHOO.util.Event.onDOMReady(function () {
    initializeDestinationContact();
});

function initializeDestinationContact() {

    var handleContactSubmit = function() {
        setHiddenContactId('editDestinationContactId');
        var result = this.submit();
        if (result) {
            YAHOO.example.container.addDestinationContact.element.style.zIndex = -1;
        }
    };

    var handleEditSubmit = function() {
        setHiddenContactId('editDestinationContactId');
        //Is there actually an entry?
        var theDropdown = document.getElementById('destinationContactDropdown');
        var contactId = theDropdown.options[theDropdown.selectedIndex];
        if (contactId == undefined) {
            alert("No destination contact selected to edit.");
            return false;
        }

        var result = this.submit();
        if (result) {
            YAHOO.example.container.addDestinationContact.element.style.zIndex = -1;
        }
    };


    var handleDeactivateSubmit = function() {
        setHiddenContactId('deactivateDestinationContactId');
        var result = this.submit();
        if (result) {
            YAHOO.example.container.deactivateContact.element.style.zIndex = -1;
        }
    };


    var handleContactCancel = function() {
        this.cancel();
        YAHOO.example.container.addDestinationContact.element.style.zIndex = -1;
    };

    var handleContactSuccess = function(o) {
        var messages = YAHOO.lang.JSON.parse(o.responseText);

        if (isPrimary(messages)) {
            alert("Destination contact has been saved to an existing hotsheet. Cannot delete.");
            return false;
        }

        var destinationContactDropdown = document.getElementById("destinationContactDropdown");
        destinationContactDropdown.options.length = 0;
        for (var i = 0; i < messages.length; i++) {
            var newOption = document.createElement("OPTION");
            destinationContactDropdown.options.add(newOption);
            newOption.value = messages[i].CONTACT_ID;
            newOption.text = messages[i].CONTACT_NAME;
            if (i == 0) {
                document.getElementById("jobContactPhone").value = messages[i].PHONE_WORK;
                document.getElementById("jobContactName").value = messages[i].CONTACT_NAME;
            }
        }

        if (messages.length == 0) {
            document.getElementById("jobContactPhone").value = '';
            document.getElementById("jobContactName").value = '';
        }
    };

    var handleContactFailure = function(o) {
        alert("Add origin contact failed: " + o.status);
    };

    // Remove progressively enhanced content class, just before creating the module
    YAHOO.util.Dom.removeClass("addDestinationContact", "yui-pe-content");

    // Instantiate the Dialog
    YAHOO.example.container.addDestinationContact = new YAHOO.widget.Dialog("addDestinationContact",
                                                                            { width : "30em",
                                                                                zIndex : -1,
                                                                                fixedcenter : true,
                                                                                visible : false,
                                                                                constraintoviewport : true,
                                                                                buttons : [
                                                                                    { text:"Submit", handler:handleContactSubmit, isDefault:true },
                                                                                    { text:"Cancel", handler:handleContactCancel }
                                                                                ]
                                                                            });

    YAHOO.example.container.editDestinationContact = new YAHOO.widget.Dialog("editDestinationContact",
                                                                             { width : "30em",
                                                                                 zIndex : -1,
                                                                                 fixedcenter : true,
                                                                                 visible : false,
                                                                                 constraintoviewport : true,
                                                                                 buttons : [
                                                                                     { text:"Submit", handler:handleEditSubmit, isDefault:true },
                                                                                     { text:"Cancel", handler:handleContactCancel }
                                                                                 ]
                                                                             });


    YAHOO.example.container.deactivateDestinationContact = new YAHOO.widget.Dialog("deactivateDestinationContact",
                                                                                   { width : "25em",
                                                                                       zIndex : -1,
                                                                                       fixedcenter : true,
                                                                                       visible : false,
                                                                                       constraintoviewport : true,
                                                                                       buttons : [
                                                                                           { text:"&nbsp;&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;", handler:handleDeactivateSubmit, isDefault:true },
                                                                                           { text:"&nbsp;&nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;", handler:handleContactCancel }
                                                                                       ]
                                                                                   });


    // Validate the entries in the form to require that both first and last name are entered
    YAHOO.example.container.addDestinationContact.validate = function() {

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
    YAHOO.example.container.addDestinationContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };

    YAHOO.example.container.editDestinationContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };


    YAHOO.example.container.deactivateDestinationContact.callback = {
        success: handleContactSuccess,
        failure: handleContactFailure
    };


    // Render the Dialog
    YAHOO.example.container.addDestinationContact.render();
    YAHOO.example.container.editDestinationContact.render();
    YAHOO.example.container.deactivateDestinationContact.render();

    function init(e) {
        YAHOO.example.container.addDestinationContact.show();
        YAHOO.example.container.addDestinationContact.element.style.zIndex = 2;
    }

    function initEdit(e) {
        YAHOO.example.container.editDestinationContact.show();
        YAHOO.example.container.editDestinationContact.element.style.zIndex = 2;
        var destinationDropdown = document.getElementById('destinationContactDropdown');
        document.getElementById('editDestinationContactName').value = destinationDropdown.options[destinationDropdown.selectedIndex].text;
        document.getElementById('editDestinationContactPhone').value = document.getElementById('jobContactPhone').value;
    }


    function initDeactivate(e) {
        YAHOO.example.container.deactivateDestinationContact.show();
        YAHOO.example.container.deactivateDestinationContact.element.style.zIndex = 2;
    }

    function isPrimary(messages) {
        return messages.length == undefined && messages.isPrimary == 'true';
    }

    function setHiddenContactId(widgetId) {
        var contactDropDown = document.getElementById('destinationContactDropdown');

        //The dropdown is empty
        if (contactDropDown.selectedIndex == -1) {
            return;
        }

        var contactId = contactDropDown.options[contactDropDown.selectedIndex];
        var contactIdHidden = document.getElementById(widgetId);
        if (contactIdHidden != undefined && contactId != undefined) {
            contactIdHidden.value = contactId.value;
        }
    }

    YAHOO.util.Event.addListener("newDestinationContact", "click", init, YAHOO.example.container.addDestinationContact, true);
    YAHOO.util.Event.addListener("deactivateDestinationContactButton", "click", initDeactivate, YAHOO.example.container.deactivateDestinationContact, true);
    YAHOO.util.Event.addListener("editDestinationContactButton", "click", initEdit, YAHOO.example.container.editDestinationContact, true);
}


YAHOO.util.Event.on('destinationContactDropdown', 'change', function (event) {

    var callbacks = {

        start : function(o) {
            document.getElementById('destinationAddressSpinner').style.visibility = 'visible';
        },

        complete : function(o) {
            document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
        },

        success : function (o) {
            var messages = [];
            try {
                messages = YAHOO.lang.JSON.parse(o.responseText);
                document.getElementById("jobContactPhone").value = messages['PHONE_WORK'];
                document.getElementById("jobContactName").value = messages['CONTACT_NAME'];
            }
            catch (exception) {
                alert("JSON Parse failed: " + exception);
                document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
            }
        },

        failure : function (o) {
            if (!YAHOO.util.Connect.isCallInProgress(o)) {
                alert("Async call failed!");
                document.getElementById('destinationAddressSpinner').style.visibility = 'hidden';
            }
        },

        // 10 second timeout
        timeout : 10000
    };

    YAHOO.util.Connect.startEvent.subscribe(callbacks.start, callbacks);
    YAHOO.util.Connect.completeEvent.subscribe(callbacks.complete, callbacks);

    var id = this.value;
    var url = '/stc/updateDestinationContact.html?jobLocationContactId=' + id;
    YAHOO.util.Connect.asyncRequest('POST', url, callbacks);
});



