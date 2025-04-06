let DEBUG=false;
/** User token, needed to communicate with the distant database **/
let token;
/** Query string **/
let urlparams;
/** State of the application, tells where we are **/
let state = { view: 'surveys' };

/********************************************
 *           Main application               *
 ********************************************/
/**
 * Update the main UI
 *
 * @param {object} s - State of the UI, the same type as the {@link state} global variable
 */
function update_ui(s) {
	if (!s.view || s.view == 'surveys') {
		let xhttp = new XMLHttpRequest();
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.onload = function() {

		}
		xhttp.send('api=get-surveys&token=' + token);
	}
}


/**
 * Start the application
 */
document.addEventListener("DOMContentLoaded",function() {
	// Do not submit forms when pressing Enter
	Array.from(document.getElementsByTagName('input')).forEach(function(el) {
		el.onkeydown = function(event) {
			if (event.key == 'Enter') event.preventDefault();
		};
	});
	// Load URL parameters
	urlparams = new URLSearchParams(location.search);
	// Get user from cookie or display login page
	if (document.cookie) {
		let cookies = document.cookie.split(';');
		let tokenel = cookies.find(el=>el.startsWith('token='));
		if (tokenel) token = tokenel.substring(6).trim();
	}
	if (token) update_ui(); else location.href = 'login.htm';
});
