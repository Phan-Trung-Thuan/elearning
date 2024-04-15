import { sendRequest } from '/elearning/utils/functions.js'

getEnrollClasses();

async function getEnrollClasses() {
    let response = await sendRequest(
        "/elearning/utils/functions.php",
        { 'do' : 'get_enroll_class' }
    );

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

// Set position of my class dropdown content
let dropdown_content_class = document.getElementById("dropdown-content-class");
let rect = document.getElementById("my-class").getBoundingClientRect();
dropdown_content_class.style.top = (rect.bottom).toString() + 'px';
dropdown_content_class.style.left = (rect.left).toString() + 'px';

document.getElementById("logout-btn").addEventListener("click", async function() {
    const confirm = window.confirm("Are you sure?");
    if (confirm) {
        await sendRequest('http://localhost/elearning/utils/functions.php', {'do': 'logout'});
        location.reload()
    }
});
