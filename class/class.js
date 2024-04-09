getInitCell();

async function getInitCell() {
    let response = await sendGetInitCellRequest();
    // alert(response);
    let data = JSON.parse(response);
    console.log(data);
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