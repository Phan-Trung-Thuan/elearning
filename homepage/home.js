function loadComponentFromFile(filepath, location) {
    var client = new XMLHttpRequest();
    client.open('GET', filepath);
    client.onreadystatechange = function() {
         location.innerHTML = client.responseText;
         client.onload;
    }
    client.send();
}

var topnav_container = document.getElementById("topnav-container");
var content = loadComponentFromFile('http://localhost/elearning/topnav/topnav.php', topnav_container);