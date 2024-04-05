window.onload = function () {
    addEnrollmentClasses();
}

async function addEnrollmentClasses(student_id) {
    let response = await sendGetClassRequest(student_id);
    let data = JSON.parse(response); 
    
    // console.log(data);

    let dropdown = document.getElementById("dropdown-content-class");
    for (let enroll_class of data) {
        let element = document.createElement("a");
        element.setAttribute("href", "");
        element.innerText = enroll_class["class_id"] + " - " + enroll_class["class_name"];
        dropdown.append(element);
    }
}

async function sendGetClassRequest(student_id) {
    let url = "/elearning/topnav/getclass.php";
    let data = { 'student_id' : student_id };

    const response = await fetch(url, {
        method: "POST",
        body: JSON.stringify(data),
        dataType: "json"
    });

    return response.text();
}
