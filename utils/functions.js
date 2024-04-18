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



// function resolveAfter2Seconds() {
//     return new Promise((resolve) => {
//       setTimeout(() => {
//         resolve('resolved');
//       }, 2000);
//     });
// }