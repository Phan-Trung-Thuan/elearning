let forms = document.getElementsByClassName("join-class-form");

async function sendJoinClassRequest(class_id) {
    let url = "/elearning/utils/functions.php";
    let data = { 'do': "join_class", 'class_id': class_id };

    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}

async function callBack(class_id) {
    let response = await sendJoinClassRequest(class_id);
    alert(response);
}

for (let i = 0; i < forms.length; i++) {
    forms[i].addEventListener("submit", async (e) => { e.preventDefault(); callBack(e.target.attributes.classID.value); });
}
