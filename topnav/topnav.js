checkEnrollment();

// Set position of my class dropdown content
let dropdown_content_class = document.getElementById("dropdown-content-class");
let rect = document.getElementById("my-class").getBoundingClientRect();
dropdown_content_class.style.top = (rect.bottom).toString() + 'px';
dropdown_content_class.style.left = (rect.left + 13).toString() + 'px';

document.getElementById("logout-btn").addEventListener("click", function() {
    const confirm = window.confirm("Are you sure?");
    if (confirm) {
        window.location.href = "http://localhost/elearning/login/index.php";
    } else {
        window.location.href = window.location.href;
    }    
});

async function checkEnrollment() {
    let response = await sendCheckEnrollmentRequest();
    let data = JSON.parse(response); 
    
    // console.log(data);

    let dropdown = document.getElementById("dropdown-content-class");
    for (let enroll_class of data) {
        let element = document.createElement("a");
        element.setAttribute("href", `/elearning/class/class.php?class_id=${enroll_class["class_id"]}`);
        element.innerHTML = '<strong>' + enroll_class["class_id"] + " - " + enroll_class["class_name"] + '</strong>';
        dropdown.append(element);
    }
}

async function sendCheckEnrollmentRequest() {
    let url = "/elearning/topnav/topnav.php";
    
    const response = await fetch(url, {
        method: "POST",
        dataType: "json"
    });

    
    return response.text();
}
