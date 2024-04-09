let forms = document.getElementsByClassName("join-class-form");

async function callBack(class_id) {
    let response = await sendJoinClassRequest(class_id);
    if (response === "SUCCESS") {
        window.location.href = `/elearning/class/class.php?class_id=${class_id}`;
    } else if (response === "ERROR") {
        alert("ERROR: Can't read join class request!");
        return;
    }
}

async function sendJoinClassRequest(class_id) {
    let url = "/elearning/utils/functions.php";
    let data = { 'do': "join_class", 'class_id': class_id };

    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}

for (let i = 0; i < forms.length; i++) {
    forms[i].addEventListener("submit", async (e) => { e.preventDefault(); callBack(e.target.attributes.classID.value); });
}
