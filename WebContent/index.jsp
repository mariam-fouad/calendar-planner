<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="classes.Event" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%
 Event e = new Event();
ArrayList <Event> allEvents=new ArrayList <Event>();
allEvents=e.getAllEvents();
%>
<eclipse.refreshLocal resource="MyProject/MyFolder" depth="infinite"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href='fullcalendar-3.9.0/fullcalendar.min.css' rel='stylesheet' />
<link href='fullcalendar-3.9.0/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<script src='fullcalendar-3.9.0/lib/moment.min.js'></script>
<script src='fullcalendar-3.9.0/lib/jquery.min.js'></script>
<script src='fullcalendar-3.9.0/fullcalendar.min.js'></script>
<script >
$(document).ready(function() {
	var eventNumbers = <%= allEvents.size()%>
	evenNumbers=parseInt(eventNumbers);
	var fullEventList=new Map();
	function formatDate(date) {
	    var d = new Date(date),
	        month = '' + (d.getMonth() + 1),
	        day = '' + d.getDate(),
	        year = d.getFullYear();

	    if (month.length < 2) month = '0' + month;
	    if (day.length < 2) day = '0' + day;

	    return [year, month, day].join('-');
	}
	function colorUserMap (color)
	{
		if(color=="#9847bc")
			{
				return "defualt User";
			}
	}

	var  eventsList=[]; 
    
	<%
	   for (int i=0;i<allEvents.size();i++)
	   {
		 %>
		 eventsList.push({id:"<%=i%>",title:"<%=allEvents.get(i).title%>",start:"<%=allEvents.get(i).startDate%>",
			  end:"<%=allEvents.get(i).endDate%>",color:"<%=allEvents.get(i).color%>"});
		 fullEventList.set("<%=i%>",{id:"<%=i%>",title:"<%=allEvents.get(i).title%>",start:"<%=allEvents.get(i).startDate%>",
			  end:"<%=allEvents.get(i).endDate%>",color:"<%=allEvents.get(i).color%>",imgUrl:"<%=allEvents.get(i).imgUrl%>"
				  ,discription:"<%=allEvents.get(i).discription%>"}); 
		 <%
	   }
	%>

    $('#calendar').fullCalendar({
      defaultView: 'month',
      header: {
    	  left: 'prev,next today',
          center: 'title',
          right: 'prevYear, nextYear'
    	},
      editable: true,
      eventLimit: true, // allow "more" link when too many events
      events:eventsList,
      dayClick: function(date, jsEvent, view) {
    	// Get the modal
    	  var modal = document.getElementById('addEvent');
    	   modal.style.display = "block";
    	 // Get the <span> element that closes the modal
    		var span = document.getElementById("closeAddEvent");
    		var submitButton = document.getElementById("addEventButton");
    	    submitButton.onclick = function() {
    	    	var title = document.getElementById("eventAddTitle").value;
    	    	if (title=="")
    	    		{
    	    		  alert("Please add the title");
    	    		  return;
    	    		}
        	    var e = document.getElementById("eventAddArea");
        	    var color = e.options[e.selectedIndex].value;
        	    if (color=="")
        	    	{
        	    	 alert("Please select an option in the area field");
        	    	 return;
        	    	}
        	    var des= document.getElementById("eventAddDescription").value;
        	    if (des=="")
        	    	{
        	    	 alert("Please add the discription field");
        	    	 return;
        	    	}
        	    if( document.getElementById("eventAddImage").files.length == 0 )
        	    	{
        	    	 alert("Please select an image from the file");
        	    	 return;
        	    	}
        	    
        	    var image = document.getElementById('eventAddImage').files[0].name;
        	    image="Images/"+image;
        	    var startDate = formatDate(document.getElementById("eventAddStartDate").value);
        	    if (startDate=="NaN-NaN-NaN")
        	    	{
        	    	 alert("Please select a start date for the event");
        	    	 return;
        	    	}
        	    var endDateTemp = document.getElementById("eventAddEndDate").value;
        	    var split = endDateTemp.split('-');
        	    var nextDate = new Date(parseInt(split[0]), parseInt(split[1] - 1), parseInt(split[2]) + 1, 0,0,0,0);
        	    var endDate = new Date();
        	    endDate = formatDate(nextDate);
        	    if (endDate=="NaN-NaN-NaN")
    	    	{
    	    	 alert("Please select an end date for the event");
    	    	 return;
    	    	}
        	    var d1 = Date.parse(startDate);
	     	    var d2 = Date.parse(endDate);
	     	    if (d1 > d2) {
	     	        alert ("Please make sure that the end date is after the start date");
	     	        return;
	     	    }
        	    var object ={id:eventNumbers.toString(),title:title,start:startDate,end:endDate,color:color};
        	    $('#calendar').fullCalendar( 'renderEvent', object, true);
        	    fullEventList.set(eventNumbers.toString(),{id:eventNumbers,title:title,start:startDate,end:endDate,color:color
        	    	,imgUrl:image,discription:des});
        	    var ajaxData= "startDate<"+startDate+"~color<"+ color+"~title<"+title+"~imgUrl<"+image+
        	    "~endDate<"+endDate+"~discription<"+des;
        	    $.ajax({
	                   type:"POST",
	                   url:"AddEventServlet", 
	                   dataType: 'json',
			           contentType:'application/json',
			           data:JSON.stringify(ajaxData),
			
	
	                   cache: false,
	                   processData:false,

               });
        	    document.getElementById("eventAddTitle").value="";
        	    document.getElementById("eventAddArea").selectedIndex = 0;
        	    document.getElementById("eventAddDescription").value="";
        	    document.getElementById('eventAddImage').value="";
        	    document.getElementById("eventAddStartDate").value="";
        	    document.getElementById("eventAddEndDate").value="";
        	    eventNumbers++;
        	    modal.style.display = "none";
    		}
    		span.onclick = function() {
    		    modal.style.display = "none";
    		}

    	  },
    	  eventClick: function(calEvent, jsEvent, view) {
    		var modalEdit = document.getElementById('updateEvent');
    		modalEdit.style.display = "block";
       	 // Get the <span> element that closes the modal
       		var spanEdit = document.getElementById("closeEditEvent");
       		var editButton = document.getElementById("updateEventButton");
       		var deleteButton = document.getElementById("deleteEventButton");
       		var eventId = calEvent.id;
       		var eventObject=fullEventList.get(eventId);
       		document.getElementById("eventEditTitle").value=eventObject.title;
       		document.getElementById("eventEditArea").value=eventObject.color;
       		document.getElementById("eventEditDescription").value=eventObject.discription;
       		document.getElementById("eventEditStartDate").value=eventObject.start;
       	    var endDateInput = new Date(eventObject.end);
       	    endDateInput.setDate(endDateInput.getDate()-1);
 	        endDateInput = formatDate(endDateInput);
       		document.getElementById("eventEditEndDate").value=endDateInput;
       		
       		
       		editButton.onclick = function() {
       			var title=document.getElementById("eventEditTitle").value;
       			if (title=="")
	    		{
	    		  alert("Please add the title");
	    		  return;
	    		}
       		    var e = document.getElementById("eventEditArea");
     	        var color = e.options[e.selectedIndex].value;
     	        if (color =="")
     	       {
      	    	 alert("Please select an option in the area field");
      	    	 return;
      	    	}
     	        var des = document.getElementById("eventEditDescription").value;
     	       if (des=="")
	   	    	{
	   	    	 alert("Please add the discription field");
	   	    	 return;
	   	    	}
     	        var image;
     	       if( document.getElementById("eventEditImage").files.length == 0 ){
   	        	  image = eventObject.imgUrl;
     	    	}
   
     	        else
     	        	{
     	        	image = document.getElementById("eventEditImage").files[0].name;
       	            image="Images/"+image;

     	        	}
     	        var start = formatDate(document.getElementById("eventEditStartDate").value);
     	        var endDateTemp = document.getElementById("eventEditEndDate").value;
     	        var split = endDateTemp.split('-');
       	        var nextDate = new Date(parseInt(split[0]), parseInt(split[1] - 1), parseInt(split[2]) + 1, 0,0,0,0);
       	        endDate = formatDate(nextDate);
	       	    var d1 = Date.parse(start);
	     	    var d2 = Date.parse(endDate);
	     	    if (d1 >= d2) {
	     	        alert ("Please make sure that the end date is after the start date");
	     	        return;
	     	    }
       	        var ajaxData ="startDate<"+start+"~color<"+ color+"~title<"+title+"~imgUrl<"+image+
        	    "~endDate<"+endDate+"~discription<"+des+
        	    ">startDate<"+eventObject.start+"~color<"+ eventObject.color+"~title<"+
        	    eventObject.title+"~imgUrl<"+eventObject.imgUrl+"~endDate<"+eventObject.end+
        	    "~discription<"+eventObject.discription; 
	       	     $.ajax({
	                 type:"POST",
	                 url:"UpdateEventServlet", 
	                 dataType: 'json',
			           contentType:'application/json',
			           data:JSON.stringify(ajaxData),
			
	
	                 cache: false,
	                 processData:false,
			
	        	 });
	       	     var updatedEvent = {
	       	    		id:eventId,
	       	    		title:title,
	       	    	    start:start,
	       				end:endDate,
	       				color:color
	       	     };
	       	  $('#calendar').fullCalendar( 'removeEvents' ,eventId );
	       	  $('#calendar').fullCalendar( 'renderEvent', updatedEvent, true);
	       	 fullEventList.set(eventId,{id:eventId,title:title,start:start,end:endDate,color:color
     	    	,imgUrl:image,discription:des});
	       	modalEdit.style.display = "none";

     	     }
       		deleteButton.onclick = function() {
       			var ajaxData ="startDate<"+eventObject.start+"~color<"+ eventObject.color+"~title<"+
        	    eventObject.title+"~imgUrl<"+eventObject.imgUrl+"~endDate<"+eventObject.end+
        	    "~discription<"+eventObject.discription; 
       			$.ajax({
	                 type:"POST",
	                 url:"DeleteEventServlet", 
	                 dataType: 'json',
			           contentType:'application/json',
			           data:JSON.stringify(ajaxData),
			
	
	                 cache: false,
	                 processData:false,
			
	        	 });
       			fullEventList.delete(eventId);
       			$('#calendar').fullCalendar( 'removeEvents' ,eventId );
       			modalEdit.style.display = "none";
       		 }
       		spanEdit.onclick = function() {
    		    modalEdit.style.display = "none";
    		}

    	  },


    	  eventMouseover: function(calEvent, jsEvent) {
    		  var eventId = calEvent.id;
         	  var eventObject=fullEventList.get(eventId);
    	      var tooltip = '<div class="tooltipevent" style="width:250;height:250;background:#ddd;position:absolute;z-index:10001;"> <h3> <center>' + 
    	      calEvent.title+' </center> </h3>'+ " <center><img src='"+eventObject.imgUrl+"' alt='Event Image' height='100' width='100'></center>"+ "<p> <center> <b> Area: </b>"+colorUserMap(eventObject.color)+" </center></p>"+
    	      "<p> <center> <b>Discription: </b>"+eventObject.discription+" </center></p>"+'</div>';
    	      $("body").append(tooltip);
    	      $(this).mouseover(function(e) {
    	          $(this).css('z-index', 10000);
    	          $('.tooltipevent').fadeIn('500');
    	          $('.tooltipevent').fadeTo('10', 1.9);
    	      }).mousemove(function(e) {
    	          $('.tooltipevent').css('top', e.pageY +10);
    	          $('.tooltipevent').css('left', e.pageX + 20);
    	      });
    	  },

    	  eventMouseout: function(calEvent, jsEvent) {
    	       $(this).css('z-index', 8);
    	       $('.tooltipevent').remove();
    	  },


    	  
    });

  });

</script>
<style>
/*! normalize.css v4.2.0 | MIT License | github.com/necolas/normalize.css */

/**
 * 1. Change the default font family in all browsers (opinionated).
 * 2. Correct the line height in all browsers.
 * 3. Prevent adjustments of font size after orientation changes in IE and iOS.
 */

html {
  font-family: sans-serif;
 /* 1 */
  line-height: 1.15;
 /* 2 */
  -ms-text-size-adjust: 100%;
 /* 3 */
  -webkit-text-size-adjust: 100%;
 /* 3 */;
}

/**
 * Remove the margin in all browsers (opinionated).
 */

body {
  margin: 0;
}

/* HTML5 display definitions
   ========================================================================== */

/**
 * Add the correct display in IE 9-.
 * 1. Add the correct display in Edge, IE, and Firefox.
 * 2. Add the correct display in IE.
 */

article,
aside,
details, /* 1 */
figcaption,
figure,
footer,
header,
main, /* 2 */
menu,
nav,
section,
summary {
 /* 1 */
  display: block;
}

/**
 * Add the correct display in IE 9-.
 */

audio,
canvas,
progress,
video {
  display: inline-block;
}

/**
 * Add the correct display in iOS 4-7.
 */

audio:not([controls]) {
  display: none;
  height: 0;
}

/**
 * Add the correct vertical alignment in Chrome, Firefox, and Opera.
 */

progress {
  vertical-align: baseline;
}

/**
 * Add the correct display in IE 10-.
 * 1. Add the correct display in IE.
 */

template, /* 1 */
[hidden] {
  display: none;
}

/* Links
   ========================================================================== */

/**
 * 1. Remove the gray background on active links in IE 10.
 * 2. Remove gaps in links underline in iOS 8+ and Safari 8+.
 */

a {
  background-color: transparent;
 /* 1 */
  -webkit-text-decoration-skip: objects;
 /* 2 */;
}

/**
 * Remove the outline on focused links when they are also active or hovered
 * in all browsers (opinionated).
 */

a:active,
a:hover {
  outline-width: 0;
}

/* Text-level semantics
   ========================================================================== */

/**
 * 1. Remove the bottom border in Firefox 39-.
 * 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
 */

abbr[title] {
  border-bottom: none;
 /* 1 */
  text-decoration: underline;
 /* 2 */
  text-decoration: underline dotted;
 /* 2 */;
}

/**
 * Prevent the duplicate application of `bolder` by the next rule in Safari 6.
 */

b,
strong {
  font-weight: inherit;
}

/**
 * Add the correct font weight in Chrome, Edge, and Safari.
 */

b,
strong {
  font-weight: bolder;
}

/**
 * Add the correct font style in Android 4.3-.
 */

dfn {
  font-style: italic;
}

/**
 * Correct the font size and margin on `h1` elements within `section` and
 * `article` contexts in Chrome, Firefox, and Safari.
 */

h1 {
  font-size: 2em;
  margin: 0.67em 0;
}

/**
 * Add the correct background and color in IE 9-.
 */

mark {
  background-color: #ff0;
  color: #000;
}

/**
 * Add the correct font size in all browsers.
 */

small {
  font-size: 80%;
}

/*<style>
/*! normalize.css v4.2.0 | MIT License | github.com/necolas/normalize.css */

/**
 * 1. Change the default font family in all browsers (opinionated).
 * 2. Correct the line height in all browsers.
 * 3. Prevent adjustments of font size after orientation changes in IE and iOS.
 */

html {
  font-family: sans-serif;
 /* 1 */
  line-height: 1.15;
 /* 2 */
  -ms-text-size-adjust: 100%;
 /* 3 */
  -webkit-text-size-adjust: 100%;
 /* 3 */;
}

/**
 * Remove the margin in all browsers (opinionated).
 */

body {
  margin: 0;
}

/* HTML5 display definitions
   ========================================================================== */

/**
 * Add the correct display in IE 9-.
 * 1. Add the correct display in Edge, IE, and Firefox.
 * 2. Add the correct display in IE.
 */

article,
aside,
details, /* 1 */
figcaption,
figure,
footer,
header,
main, /* 2 */
menu,
nav,
section,
summary {
 /* 1 */
  display: block;
}

/**
 * Add the correct display in IE 9-.
 */

audio,
canvas,
progress,
video {
  display: inline-block;
}

/**
 * Add the correct display in iOS 4-7.
 */

audio:not([controls]) {
  display: none;
  height: 0;
}

/**
 * Add the correct vertical alignment in Chrome, Firefox, and Opera.
 */

progress {
  vertical-align: baseline;
}

/**
 * Add the correct display in IE 10-.
 * 1. Add the correct display in IE.
 */

template, /* 1 */
[hidden] {
  display: none;
}

/* Links
   ========================================================================== */

/**
 * 1. Remove the gray background on active links in IE 10.
 * 2. Remove gaps in links underline in iOS 8+ and Safari 8+.
 */

a {
  background-color: transparent;
 /* 1 */
  -webkit-text-decoration-skip: objects;
 /* 2 */;
}

/**
 * Remove the outline on focused links when they are also active or hovered
 * in all browsers (opinionated).
 */

a:active,
a:hover {
  outline-width: 0;
}

/* Text-level semantics
   ========================================================================== */

/**
 * 1. Remove the bottom border in Firefox 39-.
 * 2. Add the correct text decoration in Chrome, Edge, IE, Opera, and Safari.
 */
*
 * Prevent `sub` and `sup` elements from affecting the line height in
 * all browsers.
 */

sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
  vertical-align: baseline;
}

sub {
  bottom: -0.25em;
}

sup {
  top: -0.5em;
}

/* Embedded content
   ========================================================================== */

/**
 * Remove the border on images inside links in IE 10-.
 */

img {
  border-style: none;
}

/**
 * Hide the overflow in IE.
 */

svg:not(:root) {
  overflow: hidden;
}

/* Grouping content
   ========================================================================== */

/**
 * 1. Correct the inheritance and scaling of font size in all browsers.
 * 2. Correct the odd `em` font sizing in all browsers.
 */

code,
kbd,
pre,
samp {
  font-family: monospace, monospace;
 /* 1 */
  font-size: 1em;
 /* 2 */;
}

/**
 * Add the correct margin in IE 8.
 */

figure {
  margin: 1em 40px;
}

/**
 * 1. Add the correct box sizing in Firefox.
 * 2. Show the overflow in Edge and IE.
 */

hr {
  box-sizing: content-box;
 /* 1 */
  height: 0;
 /* 1 */
  overflow: visible;
 /* 2 */;
}

/* Forms
   ========================================================================== */

/**
 * 1. Change font properties to `inherit` in all browsers (opinionated).
 * 2. Remove the margin in Firefox and Safari.
 */

button,
input,
optgroup,
select,
textarea {
  font: inherit;
 /* 1 */
  margin: 0;
 /* 2 */;
}

/**
 * Restore the font weight unset by the previous rule.
 */

optgroup {
  font-weight: bold;
}

/**
 * Show the overflow in IE.
 * 1. Show the overflow in Edge.
 */

button,
input {
 /* 1 */
  overflow: visible;
}

/**
 * Remove the inheritance of text transform in Edge, Firefox, and IE.
 * 1. Remove the inheritance of text transform in Firefox.
 */

button,
select {
 /* 1 */
  text-transform: none;
}

/**
 * 1. Prevent a WebKit bug where (2) destroys native `audio` and `video`
 *    controls in Android 4.
 * 2. Correct the inability to style clickable types in iOS and Safari.
 */

button,
html [type="button"], /* 1 */
[type="reset"],
[type="submit"] {
  -webkit-appearance: button;
 /* 2 */;
}

/**
 * Remove the inner border and padding in Firefox.
 */

button::-moz-focus-inner,
[type="button"]::-moz-focus-inner,
[type="reset"]::-moz-focus-inner,
[type="submit"]::-moz-focus-inner {
  border-style: none;
  padding: 0;
}

/**
 * Restore the focus styles unset by the previous rule.
 */

button:-moz-focusring,
[type="button"]:-moz-focusring,
[type="reset"]:-moz-focusring,
[type="submit"]:-moz-focusring {
  outline: 1px dotted ButtonText;
}

/**
 * Change the border, margin, and padding in all browsers (opinionated).
 */

fieldset {
  border: 1px solid #c0c0c0;
  margin: 0 2px;
  padding: 0.35em 0.625em 0.75em;
}

/**
 * 1. Correct the text wrapping in Edge and IE.
 * 2. Correct the color inheritance from `fieldset` elements in IE.
 * 3. Remove the padding so developers are not caught out when they zero out
 *    `fieldset` elements in all browsers.
 */

legend {
  box-sizing: border-box;
 /* 1 */
  color: inherit;
 /* 2 */
  display: table;
 /* 1 */
  max-width: 100%;
 /* 1 */
  padding: 0;
 /* 3 */
  white-space: normal;
 /* 1 */;
}

/**
 * Remove the default vertical scrollbar in IE.
 */

textarea {
  overflow: auto;
}

/**
 * 1. Add the correct box sizing in IE 10-.
 * 2. Remove the padding in IE 10-.
 */

[type="checkbox"],
[type="radio"] {
  box-sizing: border-box;
 /* 1 */
  padding: 0;
 /* 2 */;
}

/**
 * Correct the cursor style of increment and decrement buttons in Chrome.
 */

[type="number"]::-webkit-inner-spin-button,
[type="number"]::-webkit-outer-spin-button {
  height: auto;
}

/**
 * 1. Correct the odd appearance in Chrome and Safari.
 * 2. Correct the outline style in Safari.
 */

[type="search"] {
  -webkit-appearance: textfield;
 /* 1 */
  outline-offset: -2px;
 /* 2 */;
}

/**
 * Remove the inner padding and cancel buttons in Chrome and Safari on OS X.
 */

[type="search"]::-webkit-search-cancel-button,
[type="search"]::-webkit-search-decoration {
  -webkit-appearance: none;
}

/**
 * Correct the text style of placeholders in Chrome, Edge, and Safari.
 */

::-webkit-input-placeholder {
  color: inherit;
  opacity: 0.54;
}

/**
 * 1. Correct the inability to style clickable types in iOS and Safari.
 * 2. Change font properties to `inherit` in Safari.
 */

::-webkit-file-upload-button {
  -webkit-appearance: button;
 /* 1 */
  font: inherit;
 /* 2 */;
}

body {
  margin: 40px 10px;
  padding: 0;
  font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
  font-size: 14px;
}

#calendar {
  max-width: 900px;
  margin: 0 auto;
}

.modal {
  display: none;
 /* Hidden by default */
  position: fixed;
 /* Stay in place */
  z-index: 1;
 /* Sit on top */
  left: 0;
  top: 0;
  width: 100%;
 /* Full width */
  height: 100%;
 /* Full height */
  overflow: auto;
 /* Enable scroll if needed */
  background-color: rgb(0,0,0);
 /* Fallback color */
  background-color: rgba(0,0,0,0.4);
 /* Black w/ opacity */;
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto;
 /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
 /* Could be more or less, depending on screen size */;
}

/* The Close Button */
.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}
/*Model Style*/

.modal-content h1 {
  border-bottom: 1px solid #ddd;
  padding-bottom: 15px;
  text-transform: capitalize;
}

.modal-content .formwrapper {
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  -webkit-flex-wrap: wrap;
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
}

.form-eventTitle,
.form-eventUser,
.form-eventStartDate,
.form-eventEndDate {
  width: 50%;
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  margin-bottom: 15px;
}

.form-eventDescription,
.form-eventImage {
  width: 100%;
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  margin-bottom: 15px;
}

.form-eventDescription label,
.form-eventImage label {
  width: 12.5%;
}

.form-eventTitle label,
.form-eventUser label,
.form-eventStartDate label,
.form-eventEndDate label {
  width: 25%;
}

.form-eventTitle input,
.form-eventUser select,
.form-eventStartDate input,
.form-eventEndDate input {
  width: 60%;
}

.form-eventDescription textarea,
.form-eventImage input {
  width: 70%;
}

#updateEventButton {
  margin-right: 15px;
}

.buttonWrapper {
  display: -ms-flexbox;
  display: -webkit-flex;
  display: flex;
  -webkit-justify-content: flex-end;
  -ms-flex-pack: end;
  justify-content: flex-end;
  width: 92.5%;
}



</style>
<title>My calendar planner</title>
</head>
<body>
<div id='calendar'></div>
<div id='calendar'></div>
<!-- The Modal for add Event -->
<div id="addEvent" class="modal">

  <!-- Modal content -->
  <div class="modal-content AddEvent">
    <span class="close" id="closeAddEvent">&times;</span>
    <h1>Add an Event</h1>
    <div class="formwrapper">
      <div class="form-eventTitle">
  	    <label>Event title :</label>
        <input id="eventAddTitle" type="text" />
      </div>
      <div class="form-eventUser">
  	    <label>Area :</label>
  	    <select id="eventAddArea" >
  	      <option value=""selected disabled hidden>please select an option</option>
  		  <option value="#9847bc">defualt User</option>
  		</select>
      </div>
      <div class="form-eventDescription">
      	<label> Description : </label>
        <textarea id="eventAddDescription" ></textarea>
      </div>
      <div class="form-eventImage">
      	<label>Image :</label>
        <input id="eventAddImage" type="file"/>
      </div>
      <div class="form-eventStartDate">
      	<label>Time Start : </label>
        <input id="eventAddStartDate" type="date" >
      </div>
      <div class="form-eventEndDate">
      	<label>Time End : </label>
        <input id="eventAddEndDate" type="date" >
      </div>
      <div class="buttonWrapper">
      	<button id="addEventButton">Add Event</button>
      </div>
    </div>
  </div>
 </div>

 <!-- The Modal for add Event -->
<div id="updateEvent" class="modal">
  <!-- Modal content -->
  <div class="modal-content EditEvent">
    <span class="close" id="closeEditEvent">&times;</span>
    <h1>update an Event</h1>
    <div class="formwrapper">
      <div class="form-eventTitle">
  	    <label>Event title : </label>
        <input id="eventEditTitle" type="text"/>
      </div>
      <div class="form-eventUser">
  	    <label>Area : </label>
  	    <select id="eventEditArea" >
  		  <option value="#9847bc" >defualt User</option>
  		</select>
      </div>
      <div class="form-eventDescription">
      	<label>Description : </label>
        <textarea id="eventEditDescription" ></textarea>
      </div>
      <div class="form-eventImage">
      	<label>Image : </label>
        <input id="eventEditImage" type="file" />
      </div>
      <div class="form-eventStartDate">
      	<label>Time Start : </label>
        <input id="eventEditStartDate" type="date" >
      </div>
      <div class="form-eventEndDate">
      	<label>Time End : </label>
        <input id="eventEditEndDate" type="date" >
      </div>
      <div class="buttonWrapper">
        <div>
        	<button id="updateEventButton">Update Event</button>
        </div>
        <div>
             <button id="deleteEventButton">Delete Event</button>
        </div>
     </div>
    </div>
  </div>
 </div>

</body>
</html>