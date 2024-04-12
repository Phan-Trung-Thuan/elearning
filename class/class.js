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

    for (let row of data) {
        if (row['homework_expirationdate'] != null ) {
            updateFileDisplay(row['cell_id']);
        }
    }
}

function addEvents() {
    let input_forms = document.getElementsByClassName("homework-input-form");    

    for (let form of input_forms) {
        form.addEventListener("submit", async (e) => { 
            e.preventDefault();             

            let cell_id = form.querySelector("[name=cell-id]").value;
            await uploadCallBack(form);
            await updateFileDisplay(cell_id);
        });
    }

    let output_forms = document.getElementsByClassName("homework-output-form"); 
    for (let form of output_forms) {
        form.addEventListener("submit", async(e) => {
            e.preventDefault();
            let cell_id = form.querySelector("[name=cell-id]").value;
            cancelUploadCallBack(form);
        });
    }

}

async function uploadCallBack(form) {
    let file = form.querySelector("[type=file]").files;
    if (file.length == 0) {
        alert("No file to upload");
        return;
    }

    let response = await sendRequestForm(form, {'do' : 'upload_homework'});
    let data = JSON.stringify(response);
    if (data != null) {
        alert("Upload file successfully!");
    } else {      
        alert("Error when trying to upload file!");
        return;
    }
    
    //Clear input file
    form.querySelector("[type=file]").value = null;
}

async function cancelUploadCallBack(form) {
    let confirm = window.confirm("Do you want to cancel the upload?");

    if (confirm == false) {
        return;
    }

    let response = await sendRequestForm(form, {'do' : 'cancel_homework'});
    let data = JSON.parse(response);

    if (data['error_code'] == 0) {
        alert("File removed successfully");
        
        let cell_id = form.querySelector("[name=cell-id]").value;
        updateFileDisplay(cell_id);
    } else if (data['error_code'] == 1) {
        alert("Directory did not exist before deletion!");
        return;
    }
}


async function updateFileDisplay(cell_id) {   
    let input_form = document.getElementById(`homework-input-form-${cell_id}`);
    let output_form = document.getElementById(`homework-output-form-${cell_id}`);

    let response = await sendRequestForm(input_form, {'do' : 'get_homework'});
    let data = JSON.parse(response);

    if (data == null) {
        console.log("No files");       
        changeDisplayHelper(input_form, output_form, true);
    } else {
        console.log(data);

        let ul = output_form.querySelector("ul");
        for (let i = 0; i < data.length; i++) {
            let file = data[i]["file_name"] + "." + data[i]["file_extension"];
            let a = document.createElement("a");
            a.download = "";
            a.href = data["dir"] + file; 
            a.innerText = file;      
            
            let li = document.createElement("li");
            li.style.listStyleType = "disc";
            li.appendChild(a);
            ul.appendChild(li);           
        }
        
        changeDisplayHelper(input_form, output_form, false);
    }
}

function changeDisplayHelper(input_form, output_form, is_display_input) {
    if (is_display_input == true) {
        input_form.style.display = "block";
        output_form.style.display = "none";
    } else {
        input_form.style.display = "none";
        output_form.style.display = "block";
    }
}