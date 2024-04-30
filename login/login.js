import { sendRequestForm, warning } from '/elearning/utils/functions.js';

let login_form = document.getElementById("login-form");

async function callBack() {
    let form = document.getElementById("login-form");

    let response = await sendRequestForm(form, {'do' : 'login'});
    console.log(response);
    let data = JSON.parse(response);
    console.log(data);
    
    if (data['login_status'] === "SUCCESS") {
        if (data['login_type'] === "STUDENT") {
            window.location.href = '/elearning/homepage/home.php';
        } else if (data['login_type'] === "INSTRUCTOR") {
            window.location.href = '/elearning/homepage/home.php';
        }
    } else if (data['login_status'] === "FAIL") {
        // Show warning message
        // let warning_message = document.querySelector(".warning-message");

        // warning_message.classList.remove('hidden');
        // setTimeout(() => { warning_message.classList.add('hidden'); }, 3000);

        warning('Wrong username or password. Please try again.');
    } else {
        console.log("Error: Fail to read login status!");
        return;
    }
}

login_form.addEventListener("submit", async (e) => { e.preventDefault(); callBack(); });