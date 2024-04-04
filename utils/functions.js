function loadDoc(url, callBackFunction) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            callBackFunction(this);
        }
    };
    xhttp.open("GET", url, true);
    xhttp.send();
}