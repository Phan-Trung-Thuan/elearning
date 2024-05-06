import { sendRequest, getDOMFromTemplate, warning, compareCustomDate, getCurrentDate } from '/elearning/utils/functions.js';

let cell_id = document.getElementById("cell-id").value;
let expiration_date = null;


//Download All button
let download_all_btn = document.getElementById("download-all-button");
//Edit button
let edit_btn = document.getElementById("edit-button");
//Update button
let update_btn = document.getElementById("update-button");
//Cancel button
let cancel_btn = document.getElementById("cancel-button");
//Array to store previous values
let tmp_values = {};

edit_btn.addEventListener("click", () => {
    let inputs = document.getElementsByClassName("grade-input");
    for (let input of inputs) {
        tmp_values[input.id] = input.value
    }
    changeEditState(true);
});

update_btn.addEventListener("click", async (e) => {
    e.preventDefault();
    await updateGradeCallBack()
    changeEditState(false);
    calcAvgGrade();
})

cancel_btn.addEventListener("click", () => {
    let inputs = document.getElementsByClassName("grade-input");
    for (let input of inputs) {
        input.value = tmp_values[input.id];
    }
    changeEditState(false);
    calcAvgGrade();
})

await loadHomeworkInfo();
await getHomeworkReport();
calcAvgGrade();
changeEditState(false);

async function loadHomeworkInfo() {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'get_cell_data', 'cell-id' : cell_id }
    );
    let data = JSON.parse(response);

    document.getElementById("hw-class").innerText = data['class_id'];
    document.getElementById("hw-title").innerText = data['cell_title'];
    document.getElementById("hw-createddate").innerText = data['cell_createddate'];
    document.getElementById("hw-expirationdate").innerText = data['homework_expirationdate'];
    expiration_date = data['homework_expirationdate'];
}

async function getHomeworkReport() {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'get_hw_report', 'cell-id' : cell_id }
    );
    let data = JSON.parse(response);
    // console.log(data);

    let no_submitted = 0;
    let total = data.length;
    let table = document.getElementById("homework-detail");

    let grade_template = document.getElementById("grade-template");
    let download_list = {};

    for (let i = 0; i < total; i++) {
        let is_submitted = false;
        if (data[i]['file']) {
            no_submitted++;
            is_submitted = true;
            download_list[data[i]['info']['student_id']] = data[i]['file'];
        }

        let row = table.insertRow(-1);
        row.insertCell(0).innerText = data[i]['info']['student_id'];
        row.insertCell(1).innerText = data[i]['info']['student_name'];
        row.insertCell(2).innerText = data[i]['info']['student_dateofbirth'];
        row.insertCell(3).innerText = (is_submitted) ? "Done" : "X";

        let submit_date = data[i]['submit_date'];
        let col4 = row.insertCell(4);
        if (submit_date) {
            col4.innerText = submit_date;
            if (compareCustomDate(expiration_date, submit_date)) {
                row.classList.add("late");
            }
        } else {
            col4.innerText = "X";
            if (compareCustomDate(expiration_date, getCurrentDate())) {
                row.classList.add("late");
            }
        }


        if ((i+1) % 2 === 0) {
            row.classList.add('even-row');
        }

        let download_btn = document.createElement('button');
        download_btn.className = "download-button";
        download_btn.id = `download-button-${data[i]['info']['student_id']}`;
        download_btn.innerText = "Download";
        download_btn.value = `${data[i]['info']['student_id']}`;
        download_btn.disabled = !is_submitted;

        if (download_btn.disabled) {
            download_btn.classList.add("disabled");
        }

        download_btn.addEventListener("click", async (e) => {
            e.preventDefault();
            let student_id = e.target.value;
            await downloadCallBack(student_id, data[i]['file']);
        })
        row.insertCell(5).appendChild(download_btn);


        if (is_submitted) {
            let grade_template_clone = grade_template.cloneNode(true);
            let node = getDOMFromTemplate(grade_template_clone, {student_id : data[i]['info']['student_id']});

            //display grade from database
            node.querySelector(".grade-input").value = data[i]['grade'];
            row.insertCell(6).appendChild(node);
        } else {
            row.insertCell(6).innerText = "X";
        }
    }

    document.getElementById("total-student").innerText = total;
    document.getElementById("no-submitted").innerText = no_submitted;
    document.getElementById("submitted-rate").innerText = `${(no_submitted/total * 100).toFixed(2)}%`;


    //Events
    download_all_btn.addEventListener("click", async (e) => {
        e.preventDefault();        
        await downloadAllCallBack(download_list);
    })
}; 

async function downloadCallBack(student_id, file_names) {
    var zip = new JSZip();
    
    const dir_path = `../files/homework/${cell_id}/${student_id}/`;

    let promise_arr = [];
    for (let i = 0; i < file_names.length; i++) {
        promise_arr.push(
            fetch(dir_path + file_names[i])
                .then(res => res.arrayBuffer())
                .then(ab => zip.file(file_names[i], ab))
        )
    }
    Promise.all(promise_arr)
        .then(
            () => zip.generateAsync({ type: "blob" })
                .then(
                    (content) => saveAs(content, `${cell_id}_${student_id}`)
                )
        );
}

/**
 * 
 * @param {Object} download_list  //Format: {student_id : array of file names}
 */
async function downloadAllCallBack(download_list) {
    var zip = new JSZip();
    let promise_arr = [];
    for (const [student_id, file_names] of Object.entries(download_list)) {
        const dir_path = `../files/homework/${cell_id}/${student_id}/`;
        for (let i = 0; i < file_names.length; i++) {
            promise_arr.push(
                fetch(dir_path + file_names[i])
                    .then(res => res.arrayBuffer())
                    .then(ab => zip.file(`${student_id}/${file_names[i]}`, ab))
            )
        }
    }

    Promise.all(promise_arr)
        .then(
            () => zip.generateAsync({ type: "blob" })
                .then(
                    (content) => saveAs(content, `${cell_id}_all`)
                )
        );
}

function changeEditState(edit_state) {
    let inputs = document.getElementsByClassName("grade-input");
    
    if (edit_state) {
        edit_btn.style.display = 'none'
        update_btn.style.display = 'inline';
        cancel_btn.style.display = 'inline';

        for (let input of inputs) {
            input.disabled = false;
        }

    } else {
        edit_btn.style.display = 'inline'
        update_btn.style.display = 'none';
        cancel_btn.style.display = 'none';

        for (let input of inputs) {
            input.disabled = true;
        }
    }
}

async function updateGradeCallBack() {
    let inputs = document.getElementsByClassName("grade-input");
    let grades = {};
    for (let input of inputs) {        
        let student_id = input.id.split("-")[1];

        if (!input.value) {
            continue;
        }  else if (input.value < 0 || input.value > 100) {
            warning(`Invalid grade value of student ${student_id}`);
            for (let input of inputs) {
                input.value = tmp_values[input.id];
            }
            return;
        }

        grades[student_id] = input.value;
    }
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'update_hw_grade', 'cell-id' : cell_id, grades}
    );
    let data = JSON.parse(response);
    if (data['err_code'] === 0) {
        warning('Update grade successfully!');
    } else {
        warning('Fail to update grade!');
    }
}

function calcAvgGrade() {
    let inputs = document.getElementsByClassName("grade-input");
    let no_students = 0, total = 0;
    for (let input of inputs) {
        if (input.value) {
            total += Number(input.value);
            no_students++;
        }
    }

    let avg = (total / no_students).toFixed(2);
    if (isNaN(avg)) {
        document.getElementById('avg-grade').innerText = 0;
    }
    else {
        document.getElementById('avg-grade').innerText = avg;
    }
}