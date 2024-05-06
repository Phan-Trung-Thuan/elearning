/**
 * References: https://gomakethings.com/html-templates-with-vanilla-javascript/
 * 
 * Get a template from a string
 * @param  {String} str    The string to interpolate
 * @param  {Object} params The parameters
 * 
 * @return {String}        The interpolated string
 * 
 * Example usage:
 * let text = "${var1} - ${var2}";
 * let result = interpolate(text, {var1 : 'abc', var2: 'xyz'});
 * console.log(result);  // abc - xyz
 */
export const interpolate =  function (str, params) {
	let names = Object.keys(params);
	let vals = Object.values(params);
	return new Function(...names, `return \`${str}\`;`)(...vals);
};

export const getDOMFromTemplate = function (template, params="") {
    let node = new DOMParser().parseFromString(interpolate(template.innerHTML, params), "text/html").body.childNodes[0];
    return node;
}


/**
 * Send a request to server using fetch API and get response from server
 * @param  {String} 	url    			The url to php file
 * @param  {any} 		data   			The data for body
 * @param  {String}  	method			'GET' or 'POST' method for fetch;
 * 										default = 'POST'
 * 
 * @return {Promise<string>}        	The response text from server
 */
export const sendRequest = async function (url, data=null, method='POST') {    
    const response = await fetch(url, {
        method: method,
        body: JSON.stringify(data)
    });

    return response.text();
}


/**
 * Send a request to server using fetch API and get response from server (for form)
 * @param  {HTMLFormElement}    form        Form get from document
 * @param  {Object}             params      Additional parameters infos for form     
 * 
 * @return {Promise<string>}        	    The response text from server
 */
export const sendRequestForm = async function (form, params=null) {
    const url = new URL(form.action);
    const form_data = new FormData(form);
    const search_params = new URLSearchParams(form_data);

    let fetch_options = {
        method : form.method
    };

    if (form.method.toUpperCase() === 'POST') {
        if (form.enctype === 'multipart/form-data') {
            if (params != null) { 
                form_data.append("form_params", JSON.stringify(params));
            }   
            fetch_options.body = form_data;
        } else {
            let object = {};
            form_data.forEach(
                (value, key) => object[key] = value
            );

            if (params != null) {
                let keys = Object.keys(params);
                for (let key of keys) {
                    object[key] = params[key];
                }
            }

            fetch_options.body = JSON.stringify(object);
        }
    } else {
        if (params != null) {           
            let keys = Object.keys(params);
                for (let key of keys) {
                    search_params.append(key, params[key]);
                }
        }
        url.search = search_params;
    }
    
    const response = await fetch(url, fetch_options);
    return response.text();
}

/**
 * Get the value of a cookie given the key
 * @param {string}              key         Key to search for value in cookie
 * 
 * @return {string | null}                  Return the value, otherwise null if not found
 */

export const getCookie = function (key) {
    let name = key + "=";
    let decode = decodeURIComponent(document.cookie);
    let arr = decode.split(';');
    for (let i = 0; i < arr.length; i++) {
        let str = arr[i];
        while (str.charAt(0) == ' ') {
            str = str.substring(1);
        }

        if (str.indexOf(name) == 0) {
            return str.substring(name.length, str.length);
        }
    }

    return null;
}

export const warning = async function (message) {
    let warning_box = document.getElementById('warning-box');
    warning_box.innerText = message;
    warning_box.classList.remove('hidden');
    setTimeout(() => { warning_box.classList.add('hidden'); }, 3000);
}

/**
 * Construct date from string representation (format: DD-MM-YYYY HH:mm:ss)
 * @param {string} datetime 
 * @returns {Date}
 */
const constructDateHelper = function (datetime) {
    let [date, time] = datetime.split(" ");
    let date_parts = date.split("-");
    let time_parts = time.split(":");
    // return date_parts;
    return new Date(date_parts[2], date_parts[1]-1, date_parts[0], time_parts[0], time_parts[1], time_parts[2]);
}

/**
 * Compare 2 date represented by string (format: DD-MM-YYYY HH:mm:ss)
 * @param {string} datetime1    //String representation of datetime 1
 * @param {string} datetime2    //String representation of datetime 2
 * 
 * @returns {boolean}           //Return true if datetime1 < datetime2
 */
export const compareCustomDate = function (datetime1, datetime2) { 
    return constructDateHelper(datetime1) < constructDateHelper(datetime2);
}

/**
 * 
 * @returns {string}            //Return a string as current date (format: DD-MM-YYYY HH:mm:ss)
 */
export const getCurrentDate = function() {
    // Get current date and time
    var currentDate = new Date();

    // Extract individual date components
    var day = currentDate.getDate();
    var month = currentDate.getMonth() + 1; // Months are zero indexed, so add 1
    var year = currentDate.getFullYear();
    var hours = currentDate.getHours();
    var minutes = currentDate.getMinutes();
    var seconds = currentDate.getSeconds();

    // Function to pad single digits with a leading zero
    function padZero(num) {
        return (num < 10 ? '0' : '') + num;
    }

    // Format date and time
    var formattedDate = padZero(day) + '-' + padZero(month) + '-' + year + ' ' + padZero(hours) + ':' + padZero(minutes) + ':' + padZero(seconds);
    return formattedDate;
}