import { sendRequest, sendRequestForm, getDOMFromTemplate, getCookie, warning } from '/elearning/utils/functions.js';

let class_id = document.getElementById('class-id').value;
let username = getCookie("username");
let login_type = getCookie("type");

// Get class name
let class_name = await sendRequest(
    '/elearning/utils/execute-request.php',
    { 'do' : 'get_class_name', 'class-id' : class_id }
);
document.getElementById('class-name').innerText = class_name;

//Rename button
let rename_btn = document.getElementById('rename-button');
rename_btn.style.display = (login_type === "INSTRUCTOR") ? 'normal' : 'none';
rename_btn.addEventListener("click", async (e) => {
    let new_class_name = window.prompt("Please enter new class name!", class_name);
    if (new_class_name && new_class_name.length > 0) {
        if (new_class_name === class_name) {
            // alert("No changes are made!");

            warning('No changes are made!');
            return;
        }
        let confirm = window.confirm(`Do you want to change class name to "${new_class_name}"`);
        if (confirm) {
            await renameClassCallBack(new_class_name);
        }
    } else {
        // alert("Class name can't be null or empty!");

        warning('Class name can\'t be null or empty!');
    }
})  

async function renameClassCallBack(new_class_name) {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'update_class_name', 'class-id': class_id, 'new-class-name' : new_class_name }
    );
    console.log(response);
    let data = JSON.parse(response);
    if (data['err_code'] === 0) {
        // alert("Rename class successfully!");
        // window.location.reload();

        let class_name_element = document.getElementById('class-name');
        class_name_element.innerText = new_class_name;
        warning('Rename class successfully!');
    } else {
        // alert("Fail to rename class!");

        warning('Fail to rename class!');
    }
}

// Leave button
let leave_btn = document.getElementById('leave-button');
leave_btn.style.display = (login_type === "INSTRUCTOR") ? 'none' : 'normal';
leave_btn.addEventListener("click", async (e) => {
    e.preventDefault();
    await leaveClassCallBack();
});
async function leaveClassCallBack() {
    let confirm = window.confirm("Do you want to leave this class?");
    if (confirm) {
        let response = await sendRequest(
            '/elearning/utils/execute-request.php',
            { 'do' : 'leave_class', 'class-id' : class_id }
        );
        let data = JSON.parse(response);
        if (data['err_code'] === 0) {
            // alert("Leave now! Redirect to homepage.");

            warning('Leave now! Redirect to homepage.');
            window.location.href = '/elearning/homepage/home.php';
        } else {
            // alert("Error: Can't leave class!");

            warning('Error: Can\'t leave class!');
        }
    }
}

// Delete button
let delete_btn = document.getElementById('delete-button');
delete_btn.style.display = (login_type === "INSTRUCTOR") ? 'normal' : 'none';
delete_btn.addEventListener("click", async (e) => {
    e.preventDefault();
    await deleteClassCallBack();
})

async function deleteClassCallBack() {
    let confirm = window.confirm("Do you want to delete this class?");
    if (confirm) {
        let response = await sendRequest(
            '/elearning/utils/execute-request.php',
            { 'do' : 'delete_class', 'class-id' : class_id }
        );
        let data = JSON.parse(response);
        if (data['err_code'] === 0) {
            // alert("Delete successfully! Redirect to homepage.");

            warning('Delete successfully! Redirect to homepage.');
            window.location.href = '/elearning/homepage/home.php';
        } else {
            // alert("Error: Can't delete class!");

            warning('Error: Can\'t delete class!');
        }
    }
}

await getClassCell();

/** Class cell */
async function getClassCell() {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php', 
        {'do' : 'get_class_cell', 'class-id' : class_id}
    );    

    let cells = JSON.parse(response);

    for (let cell of cells) {
        await addCell(cell['cell_id']);
    }
}

export async function addCell(cell_id) {
    let container = document.getElementById("class-cell-container");
    let notification_template = document.getElementById("notification-cell-template");
    let homework_template = document.getElementById("homework-cell-template");

    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'get_cell_data', 'cell-id' : cell_id }
    );
    let data = JSON.parse(response);

    let template_clone = null;  
    if (data['notification_note'] != null) {
        template_clone = notification_template.cloneNode(true);
    } else if (data['homework_expirationdate'] != null) {
        template_clone = homework_template.cloneNode(true);
        data['hwdetail_grade'] = null;

        if (login_type === "STUDENT") {
            let response2 = await sendRequest(
                '/elearning/utils/execute-request.php',
                { 'do' : 'get_hw_grade', 'cell-id' : cell_id, 'student-id' : username}
            );
            let data2 = JSON.parse(response2);

            if (data2 && data2['hwdetail_grade']) {
                data['hwdetail_grade'] = data2['hwdetail_grade'];
            } else {
                data['hwdetail_grade'] = "No grade yet";
            }
        }

    } else {
        console.log("ERROR: Can't identify class cell type!");
        return;
    }
    let node = getDOMFromTemplate(template_clone, data);
    container.appendChild(node);
 
    let inputs = node.querySelectorAll(".file-input-form");
    for (let input_form of inputs) {
        await updateFileDisplay(input_form);
    }
    await addCellEvent(cell_id);

    return true;
}

async function addCellEvent(cell_id) {
    console.log(cell_id);
    let cell = document.getElementById(cell_id);
    let login_type = getCookie("type");

    let inputs = cell.querySelectorAll(".file-input-form");
    if (inputs != null) {
        inputs.forEach(
            form => form.addEventListener("submit", async (e) => {
                e.preventDefault();
                await uploadCallBack(e.target);
            })
        );
    }

    let outputs = cell.querySelectorAll(".file-output-form");
    if (outputs != null) {
        outputs.forEach(
            form => form.addEventListener("submit", async (e) => {
                e.preventDefault();
                await cancelUploadCallBack(e.target);
            })
        );
    }

    let delete_form = cell.querySelector(".delete-form");
    if (delete_form != null) {
        delete_form.addEventListener("submit", async (e) => {
            e.preventDefault();
            await deleteCellCallBack(e.target);
        })
    }

    let edit_expirationdate_btn = cell.querySelector(".edit-expiration-date-button");
    if (edit_expirationdate_btn != null) {
        edit_expirationdate_btn.addEventListener("click", (e) => {
            let cell_id = e.currentTarget.value;
            let form = document.getElementById(`edit-expiration-date-form-${cell_id}`);
            form.reset();
            let form_style = getComputedStyle(form).display;
            form.style.display = (form_style == 'none') ? 'block' : 'none';
        });
    }

    let edit_expirationdate_form = cell.querySelector(".edit-expiration-date-form");
    edit_expirationdate_form.addEventListener("submit", async (e) => {
        e.preventDefault();
        await updateExDateCallBack(e.target);
    })

    //Hide some display based on privileges
    if (login_type === "STUDENT") {
        let noti_cell_note = document.getElementById(`notification-cell-note-${cell_id}`);
        if (noti_cell_note) { noti_cell_note.style.display = 'none'; }        

        let doc_input_form = document.getElementById(`document-input-form-${cell_id}`);
        if (doc_input_form) {
            let response = await sendRequestForm(doc_input_form, { 'do' : 'get_file' });
            let is_contained_file = (JSON.parse(response)) ? true : false;
            if (!is_contained_file) {
                let doc_file = document.getElementById(`document-file-${cell_id}`);
                doc_file.style.display = 'none';
            } else {
                doc_input_form.style.display = 'none';
            }
        }

        let doc_output_form = document.getElementById(`document-output-form-${cell_id}`);
        let cancel_btn = doc_output_form.querySelector("button");             
        if (cancel_btn) { cancel_btn.style.display = 'none'; }

        let hw_progress = document.getElementById(`homework-progress-${cell_id}`);
        if (hw_progress) { hw_progress.style.display = 'none'; }

        let delete_form = document.getElementById(`delete-form-${cell_id}`);
        delete_form.style.display = 'none';

    } else if (login_type === "INSTRUCTOR") {        
        let hw_file = document.getElementById(`homework-file-${cell_id}`);
        if (hw_file) { hw_file.style.display = 'none'; }

        let leave_btn = document.getElementById("leave-button");
        if (leave_btn) { leave_btn.style.display = 'none'; }
    }
}

async function uploadCallBack(form) {
    let file = form.querySelector("[type=file]").files;
    if (file.length == 0) {
        // alert("No file to upload");

        warning('No file to upload');
        return;
    }

    let response = await sendRequestForm(form, { 'do' : 'upload_file' });
    let data = JSON.stringify(response);
    if (data != null) {
        // alert("Upload file successfully!");

        warning('Upload file successfully!');
    } else {
        // alert("Error when trying to upload file!");

        warning('Error when trying to upload file!');
        return;
    }   
    
    //Clear input file
    form.querySelector("[type=file]").value = null;

    //Update file display
    await updateFileDisplay(form);
}

async function updateFileDisplay(form) {
    let input_form, output_form;
    if (form.id.includes("input")) {
        let output_form_id = form.id.replace("input", "output");
        input_form = form;
        output_form = document.getElementById(output_form_id);
    } else if (form.id.includes("output")) {
        let input_form_id = form.id.replace("output", "input");
        output_form = form;
        input_form = document.getElementById(input_form_id);        
    } 

    let response = await sendRequestForm(input_form, { 'do' : 'get_file' });
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

async function cancelUploadCallBack(form) {
    let confirm = window.confirm("Do you want to cancel the upload?");

    if (confirm == true) {
        let response = await sendRequestForm(form, {'do' : 'cancel_upload_file'});
        
        let data = JSON.parse(response);

        if (data['error_code'] == 1) {
            // alert("Directory did not exist before deletion!");

            warning('Directory did not exist before deletion!')
            return;
        } else {
            // alert("File removed successfully");

            warning('File removed successfully');
            await updateFileDisplay(form);
        }        
    }

}

async function deleteCellCallBack(form) {
    let confirm = window.confirm("Are you sure you want to delete this cell?");
    if (confirm) {
        let response = await sendRequestForm(form, { 'do' : 'delete_cell' });
        let data = JSON.parse(response);
        if (data['err_code'] == 1) {
            // alert("Delete error: Unknow cell type!");

            warning('Delete error: Unknow cell type!');
            return;
        } else {
            let cell = document.getElementById(data['cell_id']);
            cell.remove();
        }

        // alert("Delete cell successfully!");

        warning('Delete cell successfully!');
    }   
}

async function updateExDateCallBack(form) {
    let cell_id = form.querySelector("[name=cell-id]").value;
    let response = await sendRequestForm(form, { 'do' : 'update_hw_exd' });
    let data = JSON.parse(response);
    let new_date_str = `Expiration date: ${data['expiration-date']}`;
    let hw_1 = document.getElementById(`homework-output-expiration-date-${cell_id}`);
    let hw_2 = document.getElementById(`homework-progress-expiration-date-${cell_id}`);
    
    hw_1.innerText = new_date_str;
    hw_2.innerText = new_date_str;
    
    warning("Change expiration date successfully!");
}
