let login_form = document.getElementById("login-form");

async function sendLoginRequest(uname, pass) {
    let url = "/elearning/login/login.php";
    let data = { 'username': uname, 'password': pass };

    const response = await fetch(url, {
        method: 'POST',
        body: JSON.stringify(data)
    });

    return response.text();
}

async function callBack() {
    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;

    let response = await sendLoginRequest(username, password);

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