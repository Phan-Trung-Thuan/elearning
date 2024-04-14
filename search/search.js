import { sendRequest, sendRequestForm, getDOMFromTemplate } from '/elearning/utils/functions.js';

let search_kw = document.getElementById("search-kw").value;
let page = document.getElementById("page").value;
let ppage = document.getElementById("ppage").value;

getSearchResult();

async function getSearchResult() {
    let response = await sendRequest(
        '/elearning/utils/functions.php',
        { 'do' : 'search_class', 'search-kw' : search_kw, 'record-ppage': ppage, 'page' : page}
    );
    
    let data = JSON.parse(response);

    console.log(data);

    let search_container = document.getElementById("search-container");
    let navigation_container = document.getElementById("search-navigation");

    let class_cell_template = document.getElementById("class-cell-template");
    let navigation_template = document.getElementById("search-navigation-template");
    
    let html = '';
    if (data['raw_data'] == null) {
        // Show warning message
        let warning_message = document.querySelector(".warning-message");
        warning_message.innerHTML = "No class found!";

        warning_message.classList.remove('hidden');
        setTimeout(() => { warning_message.classList.add('hidden'); }, 3000);
        return;
    }
    for (let raw_data of data['raw_data']) {        
        let class_cell_template_clone = class_cell_template.cloneNode(true);
        let node = getDOMFromTemplate(class_cell_template_clone, raw_data);
        search_container.appendChild(node);       
    }
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

    console.log(paging_data);
    
    
    let navigation_template_clone = navigation_template.cloneNode(true);
    let node = getDOMFromTemplate(navigation_template_clone, paging_data);
    navigation_container.appendChild(node);    
    
    let prev_link = document.getElementById("previous-button");
    let next_link = document.getElementById("next-button");
    if (paging['p_prev'] <= 0) {
        prev_link.remove();
    }

    if (paging['p_next'] <= 0) {
        next_link.remove();
    }

    addEvents();
}

function addEvents() {    
    let join_forms = document.getElementsByClassName("join-form");
    for (let form of join_forms) {
        form.addEventListener("submit", async (e) => { 
            e.preventDefault(); 
            let class_id = e.target.querySelector("[name=class-id]").value;
            joinClass(class_id);  
        });
    }
}

async function joinClass(class_id) {
    let form = document.getElementById(`join-form-${class_id}`);
    let response = await sendRequestForm(form, {'do' : 'join_class'});

    if (response === "SUCCESS") {
        window.location.href = `/elearning/class/class.php?class_id=${class_id}`;
    } else {
        // Show warning message
        let warning_message = document.querySelector(".warning-message");
        warning_message.innerHTML = "ERROR: Can't join class";

        warning_message.classList.remove('hidden');
        setTimeout(() => { warning_message.classList.add('hidden'); }, 3000);
        return;
    }
}
