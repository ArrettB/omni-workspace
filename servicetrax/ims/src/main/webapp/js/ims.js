<!--

// -------------------------  chooseDate(field) --------------------------

//Calls the Calendar Chooser found in calendar.js
//To Use: <script>makeButton('selectDate','choose_off','choose_on','chooseTheDate(PUT THE INPUT FIELD NAME HERE)')</script>
//field parameter is a textbox that displays the selected date.

// -------------------------  checkAllBoxes(cABox,cBox) --------------------------

//checks on the checkboxes on a form.  Used when you want to submit
//all the checkbox.value's whether the checkbox is checked or not.
//Used in conjuction with setCheckboxes() and setCheckboxVals().

function checkAllBoxes(cABox,cBox)
{

	if (cABox == null || cBox == null)
	{
		return;
	}
	if (cABox.checked)
	{
		cBox.checked = true;
		for(var i=0; i<cBox.length; ++i)
		{
			cBox[i].checked = true;
		}
	}
	else
	{
		cBox.checked = false;
		for(var i=0; i<cBox.length; ++i)
		{
			cBox[i].checked = false;
		}
	}
}

// -------------------------  setCheckboxes(aForm) --------------------------

//After the form, call this function to check checkboxes 
//that have value="Y" in that form
//eg. <script language="JavaScript">setCheckboxes(this.job_detail_edit);"</script>
//note this.job_detail_edit is the form name.

function setCheckboxes(aForm)
{
   for( var i = 0; i < aForm.length; i++)
   {
      var e = aForm.elements[i];
     
      if( e.type == 'checkbox' )
      {
      	var value = new String(e.value);
      	if ( value.charAt(0) == 'Y' ) 
       	{//value says that yes, the checkbox should be checked
          	e.defaultChecked = true; 
           	e.checked = true; 
       	}
       	else
       	{//values says no, the checkbox should not be checked
           	e.defaultChecked = false; 
           	e.checked = false; 
       	}
      }
   }
   return;
}


// -------------------------  setCheckboxesVal(aForm) --------------------------

//use on forms that have checkboxes, to convert checkbox value to Y or N
//place in onSubmit of the form
//eg. onSubmit="return setCheckboxesVal(this);"
//note: had to set checked=true for N in order to get checkbox to send value 

function setCheckboxesVal( aForm )
{
   for( var i = 0; i < aForm.length; i++)
   {
      var e = aForm.elements[i];
     
      if( e.type == 'checkbox' )
      {
      	if ( e.checked == true) 
      	{
      		e.value = 'Y';
      	}
      	else
      	{//not checked, so set checked to send value of no
      	 	e.value = 'N';
        	e.checked = true;
      	}
      }
   }
   return true; //true because called in onSubmit of form
}

// -------------------------  setCheckboxesImages() --------------------------

//locates all images that have a name = 'Y' or 'N' or '' and
//sets the image to point to the appropriate gifs
//eg. <img name='<?r:req_detail_edit:loc_val_flag?>'>
function setCheckboxImages()
{
   for( var i = 0; i < document.images.length; i++)
   {
	var image = document.images[i];
	if( image.name != null )
	{
      		if( image.name == 'Y' )
      			image.src = '/ims/images/checkbox_on.gif';
 	     	else if ( (image.name == 'N') || (image.name=='') )
 	     		image.src = '/ims/images/checkbox_off.gif';
        }
   }
   return;
}


function setFormStatus(myForm, statusId)
{
	myForm.statusId.value = statusId
}

// -------------------------  colorTab(...) --------------------------

function colorTab(tabl, address, address1, address2, address3, address4, address5)
{
	if (address == address1 || address == address2 || address == address3 || address == address4 || address == address5)
	{
		tabl.className = 'TabSelected';
	}
	else
	{
		tabl.className = 'Tab';
	}
}

function colorTabLine(tabl, line1, address, address1, address2, address3, address4, address5)
{
	if (address == address1 || address == address2 || address == address3 || address == address4 || address == address5)
	{
		tabl.className = 'TabSelected';
		line1.className = 'TabLineSelected';
	}
	else
	{
		tabl.className = 'Tab';
		line1.className = 'TabLine';
	}
}



// -------------------------  tabObject(tab_name,template_name) --------------------------

function tabObject(tab_name,template_name, location)
{
	this.name = tab_name;
	this.template = template_name;
	this.location = location;
}

// -------------------------  typeObject(...) --------------------------
function typeObject(id, name, code)
{
	this.id = id;
	this.name = name;
	this.code = code;
}

// -------------------------  focusFirstField() --------------------------

//focuses on first field that is not a readonly nor a disabled field, 
//hence, focuses on first editable field.

function focusFirstField()
{

	//can't focus on first field if it is disabled, default is enabled

	var i = 0;
	var increment=true;

	if( !(allFields == null) && !(allFields.length === (void 0) ) )
	{
		while( allFields[i] )
		{//find first field to focus on

			if ( allFields[i].disabled === undefined )
			{//two or more fields may have same name in this form, so focus on first
				eval( allFields[i][1].focus() ); //attempt to focus on first field
				i = allFields.length; //exit loop         
			}
			else if ( allFields[i].disabled == null || allFields[i].disabled==false )
			{//field is enabled

				if ( allFields[i].readOnly==null || allFields[i].readOnly==false )
				{//field is not readonly so focus on it as first field
	
					if( !(allFields[i].type == 'hidden' ) )
					{
						allFields[i].focus();
						i = allFields.length; //exit loop
					}
				}
				else //next field
				{
					i++;
				}
			}
			else //next field
			{
				i++;
			}
		}
	}
}

// -------------------------  setFormEdit2(edit_flag) --------------------------

//if edit_flag='n' then disables all smartform fields, and all images on page.
//if edit_flag='y' then enables all smartform fields, and all images on page
//if you want field not to be enabled, add tag 'readonly' to smartfield.
//if you want field to stay enabled, set name="xyz_enabled1", needs to start with enabled, must
//keep each name unique so a second one could be name="xyz_enabled2", all lowercase etc
function setFormEdit2(edit_flag)
{
   var edit;
   if ( edit_flag=='y' || edit_flag == 'Y' )   
      edit = true;
   else
      edit = false;
      
   //handle smartform fields
   var field;
   for (i = 0; i < allFields.length; i++)
   {
      field = allFields[i];

      if( !(field === undefined || field.className === undefined ) )
      {//field and class are defined, so we can proceed

         if ( edit )
         {//want to edit so make sure all non-readonly fields are editable

            if( (field.className=='readonly_temp') )
            {//don't want to change the class of readonly
               field.className = 'regularEdit';
               field.readOnly = false;

               if (field.type.substring(0,6) == 'select')
               {
               		field.disabled = false;
               }

            }
         }
         else if( !( field.name.substr(0,11) == 'xyz_enabled' ) )
         {//disable all fields ecept readonly and fields whose name starts with 'xyz_enabled'

            if( !(field.className=='readonly'))
            {//don't want to change the class of readonly
               field.className = 'readonly_temp';
               field.readOnly = true;
               
               if (field.type.substring(0,6) == 'select')
               {
               		field.disabled = true;
               }
            }
         }
      }
   }
   //handle chooser images.
   var image;
   var images = this.document.images;
   for (i = 0; i < images.length; i++)
   {
      image = images[i];
      if( edit )
         image.disabled = false;
      else
         image.disabled = true;
   } 
 
   focusFirstField()
   return false; //so it doesn't submit the form if used in form action tag
}



function contains(theValue, theArray)
{
	for (var i = 0; i < theArray.length; i++)
	{
		if (theValue == theArray[i])
		{
			return true;
		}
	}
	return false;
}



function setFormEditSkip(edit_flag, skipFields)
{   
	
  
  var edit;
   if ( edit_flag=='y' || edit_flag == 'Y' )   
      edit = true;
   else
      edit = false;
      
   //handle smartform fields
   var field;
   for (i = 0; i < allFields.length; i++)
   {
      field = allFields[i];
      if (contains(field, skipFields))
      {
      	continue;
      }	
      
	
      if( !(field === undefined || field.className === undefined ) )
      {//field and class are defined, so we can proceed

         if ( edit )
         {//want to edit so make sure all non-readonly fields are editable

            if( (field.className=='readonly_temp') )
            {//don't want to change the class of readonly
               	field.className = 'regular';
               	field.disabled = false;
               	field.readOnly = false;
				if( !(field.type == null) && field.type == 'select-one' )
               	{
               		field.onchange = field.onerror;
              		field.onerror = null;
            		field.onmousedown = null;
            		field.onkeydown = null;
               	}
            }
         }
         else if( !( field.name.substr(0,11) == 'xyz_enabled' ) )
         {//disable all fields ecept readonly and fields whose name starts with 'xyz_enabled'

            if( !(field.className=='readonly'))
            {//don't want to change the class of readonly
               	field.className = 'readonly_temp';
               	field.readOnly = true;

				if( !(field.type == null) && field.type == 'select-one' )
               	{
               		field.onmousedown = function() {temp_index=this.selectedIndex};
					field.onkeydown = function() {temp_index=this.selectedIndex};		
					field.onerror = field.onchange;
					field.onchange = function() {this.selectedIndex=temp_index};
               	}
            }
	    	if( !(field.type == null) && field.type == 'checkbox' )
	    	{
	    		field.disabled = true;
	    	}
         }
      }
   }
	//handle chooser images.
	var image;
	var images = this.document.images;
	for (i = 0; i < images.length; i++)
	{
		image = images[i];
		if (!contains(image, skipFields))
		{

			if(edit)
				image.disabled = false;
			else
				image.disabled = true;
		}
	} 
 
   return false; //so it doesn't submit the form if used in form action tag
}



// -------------------------  setFormEdit(edit_flag) --------------------------

//if edit_flag='n' then disables all smartform fields, and all images on page.
//if edit_flag='y' then enables all smartform fields, and all images on page
//if you want field not to be enabled, add tag 'readonly' to smartfield.
//if you want field to stay enabled, set name="xyz_enabled1", needs to start with enabled, must
//keep each name unique so a second one could be name="xyz_enabled2", all lowercase etc

var temp_index = 0;

function setFormEdit(edit_flag)
{
   var edit;
   if ( edit_flag=='y' || edit_flag == 'Y' )   
      edit = true;
   else
      edit = false;
      
   //handle smartform fields
   var field;
   for (i = 0; i < allFields.length; i++)
   {
      field = allFields[i];

      if( !(field === undefined || field.className === undefined ) )
      {//field and class are defined, so we can proceed

         if ( edit )
         {//want to edit so make sure all non-readonly fields are editable

            if( (field.className=='readonly_temp') )
            {//don't want to change the class of readonly
               	field.className = 'regular';
               	field.disabled = false;
               	field.readOnly = false;
				if( !(field.type == null) && field.type == 'select-one' )
               	{
               		field.onchange = field.onerror;
              		field.onerror = null;
            		field.onmousedown = null;
            		field.onkeydown = null;
               	}
            }
         }
         else if( !( field.name.substr(0,11) == 'xyz_enabled' ) )
         {//disable all fields ecept readonly and fields whose name starts with 'xyz_enabled'

            if( !(field.className=='readonly'))
            {//don't want to change the class of readonly
               	field.className = 'readonly_temp';
               	field.readOnly = true;

				if( !(field.type == null) && field.type == 'select-one' )
               	{
               		field.onmousedown = function() {temp_index=this.selectedIndex};
					field.onkeydown = function() {temp_index=this.selectedIndex};		
					field.onerror = field.onchange;
					field.onchange = function() {this.selectedIndex=temp_index};
               	}
            }
	    	if( !(field.type == null) && field.type == 'checkbox' )
	    	{
	    		field.disabled = true;
	    	}
         }
      }
   }
   //handle chooser images.
   var image;
   var images = this.document.images;
   for (i = 0; i < images.length; i++)
   {
      image = images[i];
      if( edit )
         image.disabled = false;
      else
         image.disabled = true;
   } 
 
   return false; //so it doesn't submit the form if used in form action tag
}

// -------------------------  secureButtons() --------------------------

//if template_functions array variable is defined, then
//adjust any smartform buttons to be enabled based on 
//what the template_functions specify.
//Notes: default is disabled all fields and buttons.
//  Also if input is named 'New','Copy','Delete','Save','Cancel'
//  then this function will blowup because it attempts to name an input
//  to be one of those names.
 
function secureButtons()
{
   //first disable all the buttons
   var items = document.all.item('button');
   for (i = 0; i < items.length; i++)
   {
      if( !(items[i].value == 'Done') ) //don't disable done button
      {
      	items[i].disabled = true;
      }
   }
   
   //enable appropriate buttons, the template functions array defined in header.html
   var viewOnly = false;
   if( !(this.template_functions == null) && !(items == null) )
   {//exists so now enable buttons

      for (i = 0; i < template_functions.length; i++)
      {
         crud = template_functions[i];
         //alert('crud:'+i+' '+crud);

         if( crud == 'View' )
         {
            if( template_functions.length == 1 ) 
               viewOnly=true;
         }
         else if( crud == 'Create' )
         {
            for (j = 0; j < items.length; j++)
            {
               if( items[j].value == 'New'){    items[j].disabled = false;}
               if( items[j].value == 'Copy'){   items[j].disabled = false;}
               if( items[j].value == 'Save'){   items[j].disabled = false;}  
               if( items[j].value == 'Cancel'){ items[j].disabled = false;}
            }
         }
         else if( crud == 'Update' )
         {
            for (j = 0; j < items.length; j++)
            {
               if( items[j].value == 'Save'){   items[j].disabled = false;}
               if( items[j].value == 'Cancel'){ items[j].disabled = false;}
            }
         }
         else if( crud == 'Delete' )
         {
            for (j = 0; j < items.length; j++)
            {

               if( items[j].value == 'Delete'){ items[j].disabled = false;}
               if( items[j].value == 'Cancel'){ items[j].disabled = false;}
            }
         }
      }
      if( i==0 ) 
	viewOnly=true;//no security defined, so default view access
   }
   else
   {//no function exists, so default is view mode
      viewOnly=true;
   }
   if( viewOnly )
   	setFormEdit('n');
   else
   	focusFirstField();
}


// -------------------------  returnDroplistOption() --------------------------

//When opening a new window similar to a chooser, return id and value back
//parent window's droplist or even a textbox.

function returnDroplistOption(aForm, aDroplist, optionName, optionValue, action)
{
//alert("optionName:'"+optionName+"', optionValue:'"+optionValue+"', form:'"+aForm+"', aDroplist:'"+aDroplist+"', action:'"+action+"'");

	if( !(aForm == null || aForm == '' || aDroplist == null || aDroplist == '') )
	{//there is a form and droplist field to update, continue
   
		var name_null = (optionName == null || optionName == '');
		var value_null = (optionValue == null || optionValue == '');
		if( !(name_null && value_null) || (name_null && value_null) )
		{//if both name and value blank, then must have deleted or hit new, so okay continue
		 //if one exists and the other doesn't then some type of error
   
		        var the_field = eval('window.opener.' + aForm + '.' + aDroplist);
     
			if ( the_field )
			{//droplist field found
      	
				if( the_field.type == 'hidden' || the_field.type == 'text' )
				{//not a droplist
					the_field.value = optionValue;
					var text_field = eval('window.opener.' + aForm + '.' + aDroplist +'_text');
					text_field.value = optionName;
				}
				else if( the_field.type == 'select-one' )
				{//it is a dropdown
					var len = the_field.length;
					var not_found = true;
					for( i = 0; i < len; i++)
					{//see if value already in list, if so don't add, just show it
	            
						if( the_field.options[i].value == optionValue )
						{
							not_found = false;
							if( action == 'remove' )
							{
								the_field.options[i] = null;
								break;
							}
							else
							{
								the_field.options[i].selected = true;
								the_field.options[i].text = optionName;
								break;
							}
						}
					}
			
					if( not_found )
					{//add new option to list since not in list
						the_field.length = len + 1;
						the_field.options[len].value = optionValue;
						the_field.options[len].text = optionName;
						the_field.options[len].selected = true;
					}
					
					if( the_field.onchange )
					{//run the onChange="" after a timeout
						if( window.opener.performOnChange )
							window.opener.performOnChange(aForm + '.' + aDroplist);
					}
				}
				else
					alert(aForm+"."+aDroplist+".type='"+the_field.type+"' not handled.");
			}
		}
		else
		{//one exists and the other doesn't, there is some type of error
			alert("Missing optionName='"+optionName+"' or optionValue='"+optionValue+"', cannot update droplist.");       
		}
	}
	else
	{
		alert("Lost transient data for form=... and field=...");
	}
	return false;
}

// -------------------------  setSelect(...) --------------------------

function setSelect(field, optionValue)
{
	if( !(field === undefined) && !(field.options === undefined) && !(optionValue === undefined) )
	{
		var found = false;
		for(i=0; i < field.length; i++)	
		{
			if( field.options[i].value == optionValue )
			{
				field.options[i].selected = true;
				found = true;
				break;
			}
		}
		if( !found )
			field.selectedIndex = -1;
	}
}

// -------- register row data change -----------------
function changed(e_id) {
  document.getElementById(e_id).value="Y";
}

-->