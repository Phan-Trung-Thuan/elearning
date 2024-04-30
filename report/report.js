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
    console.log(data);

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

    document.getElementById("'");
};