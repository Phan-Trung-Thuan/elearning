import { sendRequestForm } from '/elearning/utils/functions.js';
import { addCell } from '/elearning/class/class.js';

let class_id = document.getElementById('class-id').value;

let form = document.getElementById("create-cell-form-container");
//Open button
let open_form_btn = document.getElementById("open-form-button");
open_form_btn.addEventListener("click", () => {
    form.style.display = 'block';
});
let close_form_btn = document.getElementById("close-form-button");
//Close button
close_form_btn.addEventListener("click", () => {
    form.style.display = 'none';
});

let cell_type_selection = document.getElementById("cell-type");
let option_length = document.getElementById("option-container").childElementCount;

//Get all required fields of all options
let required_fields = [];
for (let i = 0; i < option_length; i++) {
    let node = document.getElementById(`cell-type-option-${i}`);
    required_fields[i] = node.querySelectorAll("[required]");
}

//Selection
cell_type_selection.addEventListener("change", () => {
    let option_no = parseInt(cell_type_selection.value);
    form.querySelector("[type=hidden][name=option-no]").value = option_no;

    for (let i = 0; i < option_length; i++) {
        let node = document.getElementById(`cell-type-option-${i}`);
        if (i == option_no) {
            node.style.display = 'block';

            //enable required inputs of chosen option
            let fields = required_fields[i];
            fields.forEach(field => field.required = true);
        } else {
            node.style.display = 'none';

            //clear input and disable required inputs of other options
            let inputs = node.querySelectorAll("input");
            inputs.forEach(input => input.value = "");

            let fields = required_fields[i];
            fields.forEach(field => field.required = false);
        }
    }
});

//Create form
let create_form = document.getElementById("create-cell-form");
create_form.addEventListener("submit", async (e) => {
    e.preventDefault();
    await createCellCallBack(create_form);
});

async function createCellCallBack(form) {
    let response = await sendRequestForm(form, { 'do': 'create_cell', 'class-id': class_id });
    let data = JSON.parse(response);
    let result = await addCell(data['cell_id']);
    if (result) {
        alert("Create cell successfully!");
    }

    // addFormEvents();
}