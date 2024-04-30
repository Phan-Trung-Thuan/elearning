import { sendRequest } from '/elearning/utils/functions.js';

let cell_id = document.getElementById("cell-id").value;

getHomeworkReport();

async function getHomeworkReport() {
    let response = await sendRequest(
        '/elearning/utils/execute-request.php',
        { 'do' : 'get_hw_report', 'cell-id' : cell_id }
    );
    console.log(response);
};