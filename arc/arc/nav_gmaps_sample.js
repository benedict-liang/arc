$(document).ready(function(){

var map;
var poly;
var route_type_array;
var currentCoords;
var destCoords;

function initialize() {
    //initialize with current location
	GMaps.geolocate({
		success: function(position) {
			currentCoords = position.coords;
			map = new GMaps({
				div: '#map_canvas',
				lat: currentCoords.latitude,
				lng: currentCoords.longitude
			});
            map.addMarker({
                lat: currentCoords.latitude,
                lng: currentCoords.longitude,
                title: 'Start Marker',
                infoWindow: {
                    content: "You are here!"
                }
            });
		},
		error: function(error) {
			alert('Geolocation failed: '+error.message);
		},
		not_supported: function() {
			alert("Your browser does not support geolocation");
		},
	});
};

$(window).load(initialize());

//Upon submission of form
$('#geocoding_form').submit(function(e){
    e.preventDefault();

    route_type_array = [];
    var checkedboxes = $('input[class="route_type"]:checked');

    checkedboxes.each(function(){
    	route_type_array.push(this.value);
    });

    //user must choose at least 1 route type!
    if(route_type_array.length > 0){

        //Clear out all markers, polylines, hide option buttons,
        //and empty title string, from previous calculations
        clearExisting();
        $("#options").children().css('display', 'none');

        //start of query URI
    	var queryHTML = "http://46.137.253.103:8000/api/1.0/route_xy.json?";

        //convert lat long to SVY21 coordinate system
    	var currentCoordsEN = BulkCnvLL2EN(currentCoords.latitude, currentCoords.longitude);
    	currentCoordsEN = currentCoordsEN.split(',');

		queryHTML += "from_x=" + Math.round(parseFloat(currentCoordsEN[0])) + "&from_y=" + Math.round(parseFloat(currentCoordsEN[1]));

		getdestcoords(queryHTML);
    }
    else{
    	alert("Please choose at least one checkbox!");
    }
});

function getdestcoords(queryHTML){
	var result;
	GMaps.geocode({
	  	address: $('#address').val().trim() + ", singapore",
	  	callback: function(results, status){
	    	if(status=='OK'){
		      	destCoords = results[0].geometry.location;
               
		      	map.setCenter(destCoords.lat(), destCoords.lng());
		      	map.addMarker({
		      		lat: destCoords.lat(),
		      		lng: destCoords.lng()
		      	});
		      	var destCoordsEN = BulkCnvLL2EN(destCoords.lat(), destCoords.lng());
				destCoordsEN = destCoordsEN.split(',');
				result = "&to_x=" + Math.round(parseFloat(destCoordsEN[0])) + "&to_y=" + Math.round(parseFloat(destCoordsEN[1]));
	    	}
	    	else{
	    		result = "failed";
	    	}
	    	queryHTML += result;
	    	addtoHTML(queryHTML);
	 	}
	});
};

function addtoHTML(queryHTML){

	for(index in route_type_array){
		queryHTML += "&type[]=" + route_type_array[index];
	}

	calcRoute(queryHTML, route_type_array[0], route_type_array);
}

function clearExisting(){
    map.removeMarkers();
    removePolylines();
    document.getElementById("title").innerText = "";
    document.getElementById("directions").innerText = "";
}

//remove existing polylines
function removePolylines(){
    //reference array of polylines in map object
    var polyArr = map.polylines;

    //for all polylines in array, 
    //set visibility of current polyline
    for(i in polyArr){
        polyArr[i].setVisible(false); 
    }

    //empty polyline array
    map.polylines = [];
}

//Route Object
function routeObject(start, end) {
    this.routeStart = start;
    this.routeEnd = end;
    this.legs = [];
    this.steps = [];
}

//Step Object
function stepObject(start, end, dist, instr, pathCoords) {
    this.stepStart = start;
    this.stepEnd = end;
    this.distance = dist;
    this.instructions = instr;
    this.pathCoordinates = pathCoords;
}

//Calculates route and obtains data directly from HTML query
function calcRoute(queryHTML, route_type, route_type_array) {
	
    qHTMLArr = queryHTML.split('&');
    var HTMLString = "getJsonFile.php?";
    for(i in qHTMLArr){
    	HTMLString += "link[]="+qHTMLArr[i]+"&";
    }
    console.log(HTMLString);
    $.getJSON(HTMLString, function(data){
    	createRoute(data, route_type);
        for(i in route_type_array){
            $("."+route_type_array[i]).css('display','inline');    
        }
    });
}

//calculates route from current json data with other options
function calcNewRoute(route_type) {
    clearExisting();

    var HTMLString = "getJsonFile.php?link[]=fetch";
    
    $.getJSON(HTMLString, function(data){
        createRoute(data, route_type);
    });
}

//get new routes if option is clicked
$('.cheapest').click(function(){ calcNewRoute("cheapest"); });
$('.traffic').click(function(){ calcNewRoute("traffic"); });
$('.shortest').click(function(){ calcNewRoute("shortest"); });
$('.fastest').click(function(){ calcNewRoute("fastest"); });


//create route from json data
function createRoute(data, route_type){
    //set title div text
    var fromText = data["data"]["from"];
    var toText = data["data"]["to"];
    document.getElementById("title").innerText = "From " + fromText + " to " + toText + "\n Route Type: " + route_type;

    var routeData = data["data"]["route"][route_type];

    //get start and end coords
    var routeDataCoords = routeData["coords"];
    var mainCoords = routeDataCoords.replace(/,/g, ' ').split(' ');  
    var l = mainCoords.length;
    start = [parseFloat(mainCoords[1]), parseFloat(mainCoords[0])];
    end = [parseFloat(mainCoords[l-1]), parseFloat(mainCoords[l-2])];

    //create new routeObject with start and end variables
    var route = new routeObject(start, end);

    //for each turn in object
    $.each(routeData["turns"], function (key, val) {

        //distance of step
        var dist = val["dist"];

        //instruction issued at each turn
        var instr = val["move"] + " " + val["onto"];

        //parse string into floating point numbers
        var turnCoordsStringArray = val["coords"].replace(/,/g, ' ').split(' ');

        //get coordinates along the path
        var pathCoords = [];
        for (i = 0; i < turnCoordsStringArray.length; i += 2) {
            pathCoords.push(
                [parseFloat(turnCoordsStringArray[i + 1]), parseFloat(turnCoordsStringArray[i])]
            )
        }

        //get start and end of path
        stepStart = pathCoords[0];
        stepEnd = pathCoords[pathCoords.length - 1];

        route.steps.push(
            new stepObject(stepStart, stepEnd, dist, instr, pathCoords)
        );

    });
    showSteps(route);
}

function showSteps(myRoute) {

    //array of directions
    var dirArray = [];
    var dirHTML = document.createElement('ol');
    
    //place markers and include turn instructions for each marker
    for (var i = 0; i < myRoute.steps.length; i++) {
        var instrText = myRoute.steps[i].instructions + "\n" + myRoute.steps[i].distance + "km";
        map.addMarker({
	        lat: myRoute.steps[i].stepStart[0],
	        lng: myRoute.steps[i].stepStart[1],
	        title: 'Turn Marker',
	        infoWindow: {
	          content: instrText
	        }
	    });

        dirArray.push(instrText);

        map.drawPolyline({
		  	path: myRoute.steps[i].pathCoordinates,
		  	strokeColor: "blue",
            strokeOpacity: 0.8,
            strokeWeight: 3
		});

    }

    //set instructions for directions sidebar
    for(var i=0; i<dirArray.length; i++){
        var node = document.createElement('li');
        node.innerText = dirArray[i] + "\n \n";
        dirHTML.appendChild(node);
    }

    document.getElementById("directions").appendChild(dirHTML);
}

});