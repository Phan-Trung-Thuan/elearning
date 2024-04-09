/**
 * References: https://gomakethings.com/html-templates-with-vanilla-javascript/
 * 
 * Get a template from a string
 * https://stackoverflow.com/a/41015840
 * @param  {String} str    The string to interpolate
 * @param  {Object} params The parameters
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