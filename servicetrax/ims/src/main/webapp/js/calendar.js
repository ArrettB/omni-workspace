
function chooseDate(field)
{
	serv = '/ims/ShowCalendar?form='+field.form.name+'&field='+field.name;
	win = window.open(serv, 'CalWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=155,height=160');
	win.focus();
}


// Calendar Object
// a widget that draws a calendar with layers
// 19990930

// Copyright 1999 Dan Steinman
// Distributed under the terms of the GNU Library General Public License
// Available at http://www.dansteinman.com/dynapi/

function Calendar(x,y,hSpace,vSpace) {
	this.name = "Calendar"+(Calendar.count++)
	this.x = x
	this.y = y
	this.hSpace = hSpace
	this.vSpace = vSpace
	this.obj = this.name + "Object"
	eval(this.obj + "=this")
}
{
var p = Calendar.prototype
p.bgColor = '#FFFFFF'
p.dayBarColor = '#FFFFFF'
p.active = false
p.switchMonths = true
p.selectToday = true
p.daylist = new Array('Su','Mo','Tu','We','Th','Fr','Sa')
p.changeYear = CalendarChangeYear
p.setYear = CalendarSetYear
p.changeMonth = CalendarChangeMonth
p.setMonth = CalendarSetMonth
p.changeDay = CalendarChangeDay
p.selectDay = CalendarSelectDay
p.selectNone = CalendarSelectNone
p.setDate = CalendarSetDate
p.useDate = CalendarUseDate
p.writeDate = CalendarWriteDate
p.build = CalendarBuild
p.activate = CalendarActivate
p.onChange = new Function()
}
function CalendarBuild(year,month,day) {
	this.w = 7*this.hSpace
	this.h = 7*this.vSpace
	this.useDate(year,month,day)

	this.css = css(this.name+'Cal',this.x,this.y,this.w,this.h,this.bgColor)+
	css(this.name+'CalDayBar',0,0,this.w,this.vSpace,this.dayBarColor)
	for (var i=0;i<7;i++) {
		this.css+=css(this.name+'CalDay'+this.daylist[i],this.hSpace*i,0)
	}
	var c = 0
	for (var i=0;i<6;i++) {
		for (var j=0;j<7;j++) {
			this.css+=css(this.name+'Cal'+(c++),this.hSpace*j,this.vSpace*(i+1))
		}
	}

	this.div = '<div id="'+this.name+'Cal">\n'+
	'<div id="'+this.name+'CalDayBar">\n'
	for (var i=0;i<7;i++) {
		this.div+='<div id="'+this.name+'CalDay'+this.daylist[i]+'" class="calDay">&nbsp;'+this.daylist[i]+'</div>\n'
	}
	this.div+='</div>\n'
	for (var i=0;i<42;i++) {
		this.div+='<div id="'+this.name+'Cal'+i+'">'+this.spotstr[i]+'</div>\n'
	}
	this.div+='</div>'
}
function CalendarActivate(doChange) {
	this.lyr = new DynLayer(this.name+'Cal')
	this.spot = new Array()
	for (var i=0;i<42;i++) {
		this.spot[i] = new DynLayer(this.name+'Cal'+i)
		if (is.ns) this.spot[i].elm.captureEvents(Event.MOUSEDOWN)
		this.spot[i].elm.onmousedown = new Function(this.obj+'.selectDay('+i+'); return false;')
	}
	if (doChange!=false) this.onChange()
}
function getMonthLength(month,year) {
	var monthlength = new Array(31,28,31,30,31,30,31,31,30,31,30,31)
	if (month==1 && (year/4==Math.floor(year/4) || year/400==Math.floor(year/400))) {
		return 29
	}
	else return monthlength[month]
}
function CalendarChangeYear(dy) {
	this.setDate(this.year - 0 + dy,this.month,this.day)
}
function CalendarSetYear(y) {
	this.setDate(y,this.month,this.day)
}
function CalendarChangeMonth(dm) {
	this.setDate(this.year,this.month - 0 + dm,this.day)
}
function CalendarSetMonth(m) {
	this.setDate(this.year,m,this.day)
}
function CalendarChangeDay(dd) {
	this.selectDay(this.todayspot - 0 + dd)
}
function CalendarSetDate(year,month,day) {
	if (this.active) return false
	else this.active = true
	this.useDate(year,month,day)
	this.writeDate()
	this.onChange()
}
function CalendarUseDate(year,month,day) {
	var d = new Date()
	if (month==null) month = d.getMonth()
	if (day==null) day = d.getDate()
	if (year==null) year = d.getYear()
	if (year<100) year += 1900
	if (month<0) {
		month = 11
		year -= 1
	}
	else if (month>11) {
		month = 0
		year += 1
	}
	var l = getMonthLength(month,year)
	if (day>l || day<0) {
		day = l
	}
	
	this.year = year
	this.month = month
	this.day = day

	var date = new Date(this.year,this.month,this.day)
	date.setDate(1)
	this.calshift = date.getDay()  // days from last month to show
	var thisMonth_length = getMonthLength(this.month,this.year)
	var lastMonth = (this.month==0)? 11 : this.month-1
	var lastMonth_length = getMonthLength(lastMonth,this.year)
	var calstart = lastMonth_length-this.calshift+1  // first day to show

	var which,c;
	day = 0
	this.spotday = new Array()
	this.spotstr = new Array()

	for (var i=0;i<this.calshift;i++) {  // days before this month
		this.spotday[i] = calstart+i
		this.spotstr[i] = CalendarGetString(this.spotday[i],0)
	}
	this.firstspot = this.calshift  // spot index of day 1
	for (var i=this.calshift;i<thisMonth_length+this.calshift;i++) {  // days in this month
		this.spotday[i] = i-this.calshift+1
		if (this.spotday[i]==this.day && this.selectToday) {
			which = 2
			this.todayspot = i  // the highlighted day
		}
		else {
			which = 1
		}
		this.spotstr[i] = CalendarGetString(this.spotday[i],which)
	}
	c = 1
	this.lastspot = thisMonth_length+this.calshift
	for (var i=thisMonth_length+this.calshift;i<42;i++) {  // days after this month
		this.spotday[i] = c++
		this.spotstr[i] = CalendarGetString(this.spotday[i],0)
	}
}
function CalendarWriteDate() {
	for (var i=0;i<42;i++) {
		this.spot[i].write(this.spotstr[i])
	}
	this.active = false
}
function CalendarGetString(day,which) {
	if (day<10) day = '&nbsp;'+day
	if (which==0) return '<div class="calShaded">&nbsp;'+day+'&nbsp;</div>'
	if (which==1) return '<div class="calNormal">&nbsp;'+day+'&nbsp;</div>'
	if (which==2) return '<div class="calHighlighted">&nbsp;'+day+'&nbsp;</div>'
}
function CalendarSelectDay(i) {
	if (i==this.todayspot || this.active) return
	if (i<this.firstspot && this.switchMonths) {
		this.setDate(this.year,this.month-1,this.spotday[i])
	}
	else if (i>=this.lastspot && this.switchMonths) {
		this.setDate(this.year,this.month+1,this.spotday[i])
	}
	else {
		if (this.todayspot!=null) this.spot[this.todayspot].write(CalendarGetString(this.spotday[this.todayspot],1))
		this.todayspot = i
		this.useDate(this.year,this.month,this.spotday[i])
		this.spot[i].write(CalendarGetString(this.spotday[i],2))
		this.onChange()
	}
}
function CalendarSelectNone() {
	if (this.todayspot!=null) this.spot[this.todayspot].write(CalendarGetString(this.spotday[this.todayspot],1))
	this.todayspot = null
}
Calendar.count = 0
