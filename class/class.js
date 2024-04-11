import { interpolate, sendRequest, sendRequestForm } from '/elearning/utils/functions.js';

getInitCell();

async function getInitCell() {
    let class_id = document.getElementById('class-id').value;
    let response = await sendRequest(
        '/elearning/utils/functions.php', 
        {'do' : 'get_init_cell', 'class_id' : class_id}
    );    

    let data = JSON.parse(response);

    console.log(data);

    let container = document.getElementById("class-cell-container");
    let notification_template = document.getElementById("notification-cell-template");
    let homework_template = document.getElementById("homework-cell-template");

    let html = '';
    for (let row of data) {
        let template_clone = null;  
        if (row['notification_note'] != null) {
            template_clone = notification_template.cloneNode(true);
        } else if (row['homework_expirationdate'] != null) {
            template_clone = homework_template.cloneNode(true);
        } else {
            console.log("ERROR: Can't undentify class cell type!");
            return;
        }
        
        html += interpolate(template_clone.innerHTML, row);        
    }

    container.innerHTML = html;
    addEvents();
}

function addEvents() {
    let homework_forms = document.getElementsByClassName("homework-form");
    for (let form of homework_forms) {
        form.addEventListener("submit", async (e) => { 
            e.preventDefault(); 

            let cell_id = e.target.querySelector("[name=cell-id]").value;
            await uploadCallBack(cell_id);

            let file_input = e.target.querySelector("[type=file]");
            let file_list = e.target.querySelector("[class=homework-list]");            
            await updateFileDisplay(file_input, file_list, cell_id);
        });
    }
}

async function uploadCallBack(cell_id) {    
    let form = document.getElementById(`homework-form-${cell_id}`);
    let response = await sendRequestForm(form, {'do' : 'upload_homework'});
    if (response === "SUCCESS") {
        alert("Upload file successfully!");
    } else {      
        alert("Error when trying to upload file!");
        return;
    }      
}

async function updateFileDisplay(file_input, file_list, cell_id) {
    let response = await sendRequest(
        '/elearning/utils/functions.php',
        { 'do' : 'get_homework', 'cell_id' : cell_id }
    );

    if (response == null) {
        console.log("No files");
    } else {
        alert(response);
        let data = JSON.parse(response);
        console.log(data);
    }
}