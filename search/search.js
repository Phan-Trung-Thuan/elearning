import { interpolate } from '/elearning/utils/functions.js';

let search_kw = document.getElementById("search-kw").value;
let page = document.getElementById("page").value;
let ppage = document.getElementById("ppage").value;

getSearchResult();

async function getSearchResult() {
    let response = await sendSearchRequest();
    // alert(response);
    let data = JSON.parse(response);
    console.log(data);

    let search_container = document.getElementById("search-container");
    let navigation_container = document.getElementById("search-navigation");

    let class_cell_template = document.getElementById("class-cell-template");
    let navigation_template = document.getElementById("search-navigation-template");
    
    let html = '';
    if (data['raw_data'] == null) {
        alert("No class found!");
        return;
    }
    for (let raw_data of data['raw_data']) {        
        let class_cell_template_clone = class_cell_template.cloneNode(true);
        html += interpolate(class_cell_template_clone.innerHTML, raw_data);        
    }
    console.log(data['paging']);
    let paging = data['paging'];

    let paging_data = {
        p_no : paging['p_no'],
        p_total : paging['p_total'],
        p_prev : paging['p_prev'],
        p_next : paging['p_next'],
        ppage : ppage,
        self_file_path : "/elearning/search/search.php",
        search_kw : search_kw
    };
    // console.log(paging_data);
    
    let nav_html = interpolate(navigation_template.innerHTML, paging_data);


    search_container.innerHTML = html;
    navigation_container.innerHTML = nav_html;
    
    let prev_link = navigation_container.getElementsByTagName("a")[0];
    let next_link = navigation_container.getElementsByTagName("a")[1];
    if (paging['p_prev'] <= 0) {
        prev_link.remove();
    }

    if (paging['p_next'] <= 0) {
        next_link.remove();
    }

    addClassCellEvents();
}

async function sendSearchRequest() {
    let url = '/elearning/utils/functions.php';    
    let data = { 'do' : 'search_class', 'search_kw' : search_kw, 'record_ppage': ppage, 'page' : page};
    console.log(ppage);
    
    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}


function addClassCellEvents() {
    let join_buttons = document.getElementsByClassName("join-button");
    for (let i = 0; i < join_buttons.length; i++) {
        join_buttons[i].addEventListener("click", async (e) => { 
            e.preventDefault(); 
            joinCallBack(e.target.attributes.classId.value);    
        });        
    }
}

async function joinCallBack(class_id) {
    let response = await sendJoinClassRequest(class_id);
    if (response === "SUCCESS") {
        window.location.href = `/elearning/class/class.php?class_id=${class_id}`;
    } else if (response === "ERROR") {
        alert("ERROR: Can't read join class request!");
        return;
    }
}

async function sendJoinClassRequest(class_id) {
    let url = "/elearning/utils/functions.php";
    let data = { 'do': "join_class", 'class_id': class_id };

    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}