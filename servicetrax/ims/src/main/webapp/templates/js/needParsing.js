
<!--
//functions in this file need to be parsed for variables or what have you.


// -------------------------  newWindow() --------------------------

//Opens new window
//optionally adds the value of the droplist's (field) current selection to link 

function newWindow(alink, window_name, aHeight, aWidth, field)
{
   var attribs = ##-WIN2-## +
   		 ',height=' + aHeight + ',width=' + aWidth;

   if( !(field == null) )
   {
      if( field.type == 'select-one')
      {
         var index = field.selectedIndex;
         if ( !(index == -1 ) )
         {//option is selected so determine value (id) of contact to add to href
      
            alink = alink + field.options[index].value;
         }
      }
      if( field.type == 'text' || field.type == 'hidden')
      {
         alink = alink + field.value;
      }
//alert("link='"+alink+"' field.type='"+field.type+"'");

   }   
   var the_window = window.open(alink,window_name,attribs);

   return true;
}

function newWindowScrollBars(alink, window_name, aHeight, aWidth, field)
{
   var attribs = ##-WIN2ScrollBars-## +
   		 ',height=' + aHeight + ',width=' + aWidth;

   if( !(field == null) )
   {
      if( field.type == 'select-one')
      {
         var index = field.selectedIndex;
         if ( !(index == -1 ) )
         {//option is selected so determine value (id) of contact to add to href
      
            alink = alink + field.options[index].value;
         }
      }
      if( field.type == 'text' || field.type == 'hidden')
      {
         alink = alink + field.value;
      }
//alert("link='"+alink+"' field.type='"+field.type+"'");

   }   
   var the_window = window.open(alink,window_name,attribs);

   return true;
}


function move_billing_lines(form)
{
	if (form.submit_action.options[form.submit_action.selectedIndex].value == 'changeBillServiceId')
	{
		url = {!s:showPage.toJavaScriptString()!}+'bill/bill_move_lines.html'
			+ '?title=Move Lines'
			+ '&form='+form.name;

		newWindow(url,'MoveBillingLines',180,350);
	}
	else
	{
		form.submit();
	}
}

-->