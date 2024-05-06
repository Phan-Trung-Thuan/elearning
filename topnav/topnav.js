import { sendRequest } from '/elearning/utils/functions.js'

let login_type = document.querySelector("input[type=hidden][name=type]").value;
if (login_type === "STUDENT") {
    getEnrollClasses();
    let create_class = document.getElementById("create-class");
    if (create_class) { create_class.style.display = 'none'; }

} else if (login_type === "INSTRUCTOR") {
    getInstructorClasses();
}

let create_class = document.getElementById("create-class");
create_class.addEventListener("click", async (e) => {
    let class_name = window.prompt("Please enter class name");
    if (class_name != null && class_name != "") {
        let confirm = window.confirm(`Do you want to create the class "${class_name}"`);
        if (confirm) {
            await createClass(class_name);
        }
    }
});

async function createClass(class_name) {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'create_class', 'class-name' : class_name }
    );

    let data = JSON.parse(response);
    if (data) {
        let class_id = data['class_id'];
        let confirm = window.confirm("Create class successfully! Move to new class now?");
        if (confirm) {
            window.location.href = `http://localhost/elearning/class/class.php?class_id=${class_id}`;
        }
    } else {
        alert("Fail to create class!")
    }
}

async function getEnrollClasses() {
    let response = await sendRequest(
        "http://localhost/elearning/utils/execute-request.php",
        { 'do' : 'get_enroll_class' }
    );
    
    let data = JSON.parse(response);
    addClass(data);
}

async function getInstructorClasses() {
    let response = await sendRequest(
        'http://localhost/elearning/utils/execute-request.php',
        { 'do' : 'get_instructor_class' }
    );
    // console.log(response);
    let data = JSON.parse(response);

    addClass(data);
}

function addClass(data) {
    let dropdown = document.getElementById("dropdown-content-class");
    for (let enroll_class of data) {
        let element = document.createElement("a");
        element.setAttribute("href", `/elearning/class/class.php?class_id=${enroll_class["class_id"]}`);
        element.innerHTML = '<strong>' + enroll_class["class_name"] + '</strong>';
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
        await sendRequest('http://localhost/elearning/utils/execute-request.php', {'do': 'logout'});
        location.reload()
    }
});
