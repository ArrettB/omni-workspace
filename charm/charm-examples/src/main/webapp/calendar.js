
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

		var self = this;
		var onSelectFunction = function()
		{
			var selectedDate = self.calendarObj.getSelectedDates()[0];
			YAHOO.util.Dom.get(self.inputId).value = self.formatDate(selectedDate);
			self.isOverCal = false;
			self.hideCalendar();
		}
		this.calendarObj.onSelect = onSelectFunction;


		YAHOO.util.Event.addListener(this.imgId, 'click', function() {self.showCalendar();});
		YAHOO.util.Event.addListener(this.inputId, 'blur', function() {self.hideCalendar();});
		YAHOO.util.Event.addListener(this.containerId, 'mouseover', function() {self.overCal();});
		YAHOO.util.Event.addListener(this.containerId, 'mouseout', function() {self.outCal();});

		this.overlayObj = new YAHOO.widget.Overlay(this.containerId);
		this.overlayObj.cfg.setProperty('context', [this.imgId, 'tl', 'tr']);
		this.overlayObj.cfg.setProperty('iframe', true);
		this.overlayObj.cfg.setProperty('visible', false);
		this.overlayObj.cfg.setProperty('zIndex', 10);
		this.overlayObj.render(document.body);
		
	},


	hideCalendar:function()
	{
		if (!this.isOverCal)
		{
			YAHOO.util.Dom.get(this.containerId).style.display = 'none';
			this.overlayObj.hide();
		}
	},


	showCalendar:function()
	{
		var value = YAHOO.util.Dom.get(this.inputId).value;
		if (value != '')
		{
			this.calendarObj.select(value);
			this.calendarObj.pageDate = new Date(value);
		}
		this.calendarObj.render();
		YAHOO.util.Dom.get(this.containerId).style.display = 'block';
		this.overlayObj.show();
		
		var inputField = YAHOO.util.Dom.get(this. inputId);
		inputField.focus();
		
	},

	overCal:function()
	{
		this.isOverCal = true;
		var inputField = YAHOO.util.Dom.get(this.inputId);
		inputField.focus();
	},

	outCal:function()
	{
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
