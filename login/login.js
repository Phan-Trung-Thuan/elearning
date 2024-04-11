import { sendRequest, sendRequestForm } from '/elearning/utils/functions.js';

let login_form = document.getElementById("login-form");

async function callBack() {
    let form = document.getElementById("login-form");
    let response = await sendRequestForm(form, {'do' : 'login'});

    if (response === "STUDENT LOGIN SUCCESSFULLY") {
        // Go to homepage for student
        window.location.href = '/elearning/homepage/home.php';
    }
    else if (response === "INSTRUCTOR LOGIN SUCCESSFULLY") {
        // Go to homepage for instructor
        window.location.href = '/elearning/homepage/home.php';
    }
    else if (response === "LOGIN FAILED") {
        // Show warning message
        let warning_message = document.querySelector(".warning-message");

        warning_message.classList.remove('hidden');
        setTimeout(() => { warning_message.classList.add('hidden'); }, 3000);
    }
}

login_form.addEventListener("submit", async (e) => { e.preventDefault(); callBack(); });