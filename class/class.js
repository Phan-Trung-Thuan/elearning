import { sendRequest, sendRequestForm, getDOMFromTemplate } from '/elearning/utils/functions.js';

let class_id = document.getElementById('class-id').value;

/** Class cell */

getInitCell();

async function getInitCell() {
    let response = await sendRequest(
        '/elearning/utils/functions.php', 
        {'do' : 'get_init_cell', 'class_id' : class_id}
    );    

    let data = JSON.parse(response);

    console.log(data);

    let container = document.getElementById("class-cell-container");
    let notification_template = document.getElementById("notification-cell-template");
    let homework_template = document.getElementById("homework-cell-template");

    for (let params of data) {
        let template_clone = null;  
        if (params['notification_note'] != null) {
            template_clone = notification_template.cloneNode(true);
        } else if (params['homework_expirationdate'] != null) {
            template_clone = homework_template.cloneNode(true);
        } else {
            console.log("ERROR: Can't identify class cell type!");
            return;
        }
        let node = getDOMFromTemplate(template_clone, params);
        container.appendChild(node);
        
        if (params['homework_expirationdate'] != null ) {
            updateFileDisplay(params['cell_id']);
        }
    }

    addFormEvents();
}

function addFormEvents() {
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
        await updateFileDisplay(cell_id);
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

/** Popup create class cell form */
let form = document.getElementById("create-cell-form-container");
let open_form_btn = document.getElementById("open-form-button");
open_form_btn.addEventListener("click", () => {
    form.style.display = 'block';
});
let close_form_btn = document.getElementById("close-form-button");
close_form_btn.addEventListener("click", () => {
    form.style.display = 'none';
});

let cell_type_selection = document.getElementById("cell-type");
let option_container = document.getElementById("option-container");
let option_length = document.getElementById("option-container").childElementCount;

//Get all required fields of all options
let required_fields = [];
for (let i = 0; i < option_length; i++) {
    let node = document.getElementById(`cell-type-option-${i}`);
    required_fields[i] = node.querySelectorAll("[required]");
}

cell_type_selection.addEventListener("change", () => {
    let option_no = parseInt(cell_type_selection.value);
    form.querySelector("[type=hidden][name=option-no]").value = option_no;

    for (let i = 0; i < option_length; i++) {
        let node = document.getElementById(`cell-type-option-${i}`);
        if (i == option_no) {
            node.style.display = 'block';

            //enable required inputs of chosen option
            let fields = required_fields[i];
            fields.forEach( field => field.required = true);
        } else {
            node.style.display = 'none';

            //clear input and disable required inputs of other options
            let inputs = node.querySelectorAll("input");
            inputs.forEach( input => input.value = "" );
            
            let fields = required_fields[i];
            fields.forEach( field => field.required = false);
        }
    }
});


//Create form
let create_cell_form = document.getElementById("create-cell-form");
create_cell_form.addEventListener("submit", async (e) => {
    e.preventDefault();
    await addNewCell();
});

async function addNewCell() {
    let response = await sendRequestForm(create_cell_form, { 'do' : 'create_cell', 'class-id' : class_id });
    console.log(response);
}