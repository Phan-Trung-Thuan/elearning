import { sendRequest, sendRequestForm, getDOMFromTemplate } from '/elearning/utils/functions.js';

let class_id = document.getElementById('class-id').value;

/** Leave button */
let leave_btn = document.getElementById('leave-button');
leave_btn.addEventListener("click", async (e) => {
    e.preventDefault();
    await leaveCallBack();
});

async function leaveCallBack() {
    let confirm = window.confirm("Do you want to leave this class?");
    if (confirm) {
        let response = await sendRequest(
            '/elearning/utils/functions.php',
            { 'do' : 'leave_class', 'class-id' : class_id }
        );
        let data = JSON.parse(response);
        if (data['err_code'] === 0) {
            alert("Leave now! Redirect to homepage.");
            window.location.href = '/elearning/homepage/home.php';
        } else {
            alert("Error: Can't leave class!");
        }
    }
}


getInitCell();

/** Class cell */
async function getInitCell() {
    let response = await sendRequest(
        '/elearning/utils/functions.php', 
        {'do' : 'get_init_cell', 'class-id' : class_id}
    );    

    let cells = JSON.parse(response);

    for (let cell of cells) {
        let result = await addCell(cell['cell_id']);
    }
}

export async function addCell(cell_id) {
    let container = document.getElementById("class-cell-container");
    let notification_template = document.getElementById("notification-cell-template");
    let homework_template = document.getElementById("homework-cell-template");

    let response = await sendRequest(
        '/elearning/utils/functions.php',
        { 'do' : 'get_cell_data', 'cell-id' : cell_id }
    );
    let data = JSON.parse(response);

    let template_clone = null;  
    if (data['notification_note'] != null) {
        template_clone = notification_template.cloneNode(true);
    } else if (data['homework_expirationdate'] != null) {
        template_clone = homework_template.cloneNode(true);
    } else {
        console.log("ERROR: Can't identify class cell type!");
        return;
    }
    let node = getDOMFromTemplate(template_clone, data);
    container.appendChild(node);
    
    if (data['homework_expirationdate'] != null ) {
        await updateFileDisplay(data['cell_id']);
    }
    addCellEvent(cell_id);

    return true;
}

export function addCellEvent(cell_id) {
    console.log(cell_id);
    let cell = document.getElementById(cell_id);
    
    let form = null;
    form = cell.querySelector("[class=homework-input-form]");
    if (form != null) {
        form.addEventListener("submit", async (e) => { 
            e.preventDefault();             
            await uploadCallBack(cell_id);            
            await updateFileDisplay(cell_id);            
        });
    }
    
    form = cell.querySelector("[class=homework-output-form]");
    if (form != null) {
        form.addEventListener("submit", async(e) => {
            e.preventDefault();
            await cancelUploadCallBack(cell_id);
        });
    }

    form = cell.querySelector("[class=delete-form]");
    if (form != null) {
        form.addEventListener("submit", async (e) => {
            e.preventDefault();
            await deleteCallBack(cell_id);
        });
    }
}

async function deleteCallBack(cell_id) {
    let form = document.getElementById(`delete-form-${cell_id}`);
    let confirm = window.confirm("Are you sure you want to delete this cell?");
    if (confirm) {
        let response = await sendRequestForm(form, { 'do' : 'delete_cell' });
        let data = JSON.parse(response);
        if (data['err_code'] == 1) {
            alert("Delete error: Unknow cell type!");
            return;
        } else {
            let cell = document.getElementById(data['cell_id']);
            cell.remove();
        }

        alert("Delete cell successfully!");
    }   
}

async function uploadCallBack(cell_id) {
    let form = document.getElementById(`homework-input-form-${cell_id}`);
    console.log(form);
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

async function cancelUploadCallBack(cell_id) {
    let form = document.getElementById(`homework-output-form-${cell_id}`);
    let confirm = window.confirm("Do you want to cancel the upload?");

    if (confirm == true) {
        let response = await sendRequestForm(form, {'do' : 'cancel_homework'});
        let data = JSON.parse(response);

        if (data['error_code'] == 1) {
            alert("Directory did not exist before deletion!");
            return;
        } else {
            alert("File removed successfully");
            
            let cell_id = form.querySelector("[name=cell-id]").value;
            await updateFileDisplay(cell_id);
        }        
    }

}

async function updateFileDisplay(cell_id, file_type) {   
    if (file_type === 'homework') {
        
        let input_form = document.getElementById(`homework-input-form-${cell_id}`);
        let output_form = document.getElementById(`homework-output-form-${cell_id}`);
    }

    let response = await sendRequestForm(input_form, {'do' : 'get_homework'});
    let data = JSON.parse(response);

    if (data == null) {      
        changeDisplayHelper(input_form, output_form, true);
    } else {
        let ul = output_form.querySelector("ul");
        ul.innerHTML = '';
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

