getInitCell();

import { interpolate } from '/elearning/utils/functions.js';

async function getInitCell() {
    let response = await sendGetInitCellRequest();
    let data = JSON.parse(response);

    console.log(data);

    let container = document.getElementById("class-cell-container");
    let template = document.getElementById("notification-cell-template");

    let html = '';
    for (let row of data) {        
        let template_clone = template.cloneNode(true);
        html += interpolate(template_clone.innerHTML, row);        
    }

    container.innerHTML = html;
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