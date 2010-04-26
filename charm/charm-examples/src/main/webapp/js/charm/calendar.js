
PopupCalendar = function(calendarId, inputId, containerId, dialogId, imgId)
{
    this.init(calendarId, inputId, containerId, dialogId, imgId);
};

PopupCalendar.prototype =
{
	calendarId:null,
	inputId:null,
	containerId:null,
	imgId:null,
	calendarObj:null,
	overlayObj:null,
	isOverCal:false,

	init:function(calendarId, inputId, containerId, imgId)
	{
    	this.calendarId = calendarId;
		this.inputId = inputId;
		this.containerId = containerId;
		this.imgId = imgId;

		this.calendarObj = new YAHOO.widget.Calendar(calendarId, containerId);

		var onSelectFunction = function(type,args,obj)
		{
			var dates = args[0];  
			var selectedDate = dates[0];
		    var year = selectedDate[0], month = selectedDate[1], day = selectedDate[2]; 
		    var formatted = this.quickPad(month) + "/" + this.quickPad(day) + "/" + year;
			YAHOO.util.Dom.get(this.inputId).value = formatted;
			this.isOverCal = false;
			this.hideCalendar();
		}
		
		this.calendarObj.selectEvent.subscribe(onSelectFunction, this, true);
		this.calendarObj.cfg.setProperty('title', 'Please Choose a Date');
		this.calendarObj.cfg.setProperty('close', true);
		this.calendarObj.render();
		this.calendarObj.hide();
		
		YAHOO.util.Event.addListener(this.imgId, 'click', function(e, obj) {this.showCalendar();}, this, true);
		YAHOO.util.Event.addListener(this.inputId, 'blur', function(e, obj) {this.hideCalendar();}, this, true);
		YAHOO.util.Event.addListener(this.containerId, 'mouseover', function(e, obj) {this.overCal();}, this, true);
//		YAHOO.util.Event.addListener(this.containerId, 'mouseout', function(e, obj) {this.outCal();}, this, true);

	


//		this.overlayObj = new YAHOO.widget.Overlay(this.containerId);
//		this.overlayObj.cfg.setProperty('context', [this.imgId, 'tl', 'tr']);
//		this.overlayObj.cfg.setProperty('iframe', true);
//		this.overlayObj.cfg.setProperty('visible', false);
//		this.overlayObj.cfg.setProperty('zIndex', 10);
//		this.overlayObj.render(document.body);
		
	},


	hideCalendar:function()
	{
	//	console.log('hideCalendar');
		if (!this.isOverCal)
		{
//			YAHOO.util.Dom.get(this.containerId).style.display = 'none';
//			this.overlayObj.hide();
			this.calendarObj.hide();
			
			YAHOO.util.Event.purgeElement(this.containerId);
		}
	},


	showCalendar:function()
	{
	//	console.log('showCalendar');
		
		var value = YAHOO.util.Dom.get(this.inputId).value;
		if (value != '')
		{
			this.calendarObj.select(value);
			this.calendarObj.cfg.setProperty("pagedate", new Date(value));
		}
		this.calendarObj.render();
		this.calendarObj.show();
		
	
		
		var xy = YAHOO.util.Dom.getXY(this.imgId);
		var imgWidth = YAHOO.util.Dom.get(this.imgId).width;
		
		YAHOO.util.Dom.setX(this.containerId, xy[0] + imgWidth + 2);
		YAHOO.util.Dom.setY(this.containerId, xy[1] + 0);
		
		YAHOO.util.Event.addListener(this.containerId, 'mouseover', function(e, obj) {this.overCal();}, this, true);
		YAHOO.util.Event.addListener(this.containerId, 'mouseout', function(e, obj) {this.outCal();}, this, true);
		
//		YAHOO.util.Dom.get(this.containerId).style.display = 'block';
//		this.overlayObj.show();
		
		var inputField = YAHOO.util.Dom.get(this. inputId);
		inputField.focus();
		
	},

	overCal:function()
	{
	//	console.log('overCal');
		this.isOverCal = true;
		var inputField = YAHOO.util.Dom.get(this.inputId);
		inputField.focus();
	},

	outCal:function()
	{
	//	console.log('outCal');
		this.isOverCal = false;
	},

	formatDate:function(theDate)
	{
		if (theDate)
			return this.quickPad(theDate.getMonth() + 1) + "/" + this.quickPad(theDate.getDate()) + "/" + theDate.getFullYear();
	 	  else
	 		return "";
	},

	quickPad:function(num)
	{
		if (num > 9)
			return num;
		else
			return "0" + num;
	},

	getSelectedDate:function()
	{
		var selected = this.calendarObj.getSelectedDates();
		if (selected.length == 1)
		{
			return selected[0];
		}
	}

};
