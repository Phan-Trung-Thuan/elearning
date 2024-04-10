getInitCell();

import { interpolate } from '/elearning/utils/functions.js';

async function getInitCell() {
    let response = await sendGetInitCellRequest();
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

async function sendGetInitCellRequest() {
    let url = '/elearning/utils/functions.php';
    let class_id = document.getElementById('class_id').name;
    let data = { 'do' : 'get_init_cell', 'class_id' : class_id};

    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}

async function sendUploadFileRequest(cell_id) {
    let form_data = new FormData();
    let files_upload = document.getElementById(`file-upload-${cell_id}`).files;
    for (let i = 0; i < files_upload.length; i++) {
        form_data.append("file[]", files_upload[i]);        
    }

    form_data.append("cell_id", cell_id);

    let url = '/elearning/utils/upload.php';
    const response = await fetch(url, {
        method: 'POST',
        body: form_data
    });

    return response.text();
}

async function uploadCallBack(cell_id) {
    let response = await sendUploadFileRequest(cell_id);
    if (response != null) {
        alert(response);
    }
}

function addEvents() {
    let upload_buttons = document.getElementsByClassName("upload-button");
    for (let btn of upload_buttons) {
        btn.addEventListener("click", async (e) => { 
            e.preventDefault(); 
            uploadCallBack(e.target.attributes.cellId.value);    
        });
    }
}