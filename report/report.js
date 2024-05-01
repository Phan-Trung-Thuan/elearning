import { sendRequest } from '/elearning/utils/functions.js';


let cell_id = document.getElementById("cell-id").value;

loadHomeworkInfo();
getHomeworkReport();

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
}

async function getHomeworkReport() {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'get_hw_report', 'cell-id' : cell_id }
    );
    let data = JSON.parse(response);
    console.log(data);

    let no_submitted = 0;
    let total = data.length;
    let table = document.getElementById("homework-detail");

    for (let i = 0; i < total; i++) {
        let is_submitted = false;
        if (data[i]['file']) {
            no_submitted++;
            is_submitted = true;
        }

        let row = table.insertRow(-1);
        row.insertCell(0).innerText = data[i]['info']['student_id'];
        row.insertCell(1).innerText = data[i]['info']['student_name'];
        row.insertCell(2).innerText = data[i]['info']['student_dateofbirth'];
        row.insertCell(3).innerText = (is_submitted) ? "Done" : "X";

        if (i % 2 === 0) {
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
            downloadCallBack(student_id, data[i]['file']);
        })
        row.insertCell(4).appendChild(download_btn);
    }

    document.getElementById("total-student").innerText = total;
    document.getElementById("no-submitted").innerText = no_submitted;
    document.getElementById("submitted-rate").innerText = `${(no_submitted/total * 100).toFixed(2)}%`;
}; 


async function downloadCallBack(student_id, file_names) {
    const dir_path = `../files/homework/${cell_id}/${student_id}/`;

    var zip = new JSZip();
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

// var zip = new JSZip();
// const name = 'bank.png';
// fetch('../files/homework/100006/B2111002/' + name)
//     .then(res => res.arrayBuffer())
//     .then(ab => {
//         zip.file(name, ab);
//         zip.generateAsync({ type: "blob" })
//         .then(function (content) {
//             // see FileSaver.js
//             saveAs(content, "example.zip");
//         });
//     });
