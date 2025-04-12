let DEBUG=false;
/** User token, needed to communicate with the distant database **/
let token;
/** Query string **/
let urlparams;
/** State of the application, tells where we are **/
let state = { view: 'surveys' };
/** Table currently displayed **/
let table = null;

/********************************************
 *           Survey management              *
 ********************************************/
function add_survey(id) {
	console.log('add_survey(' + id + ')');
}

function remove_survey(id) {
	console.log('remove_survey(' + id + ')');
}

function edit_survey(id) {
	console.log('edit_survey(' + id + ')');
}

function play_survey(id) {
	console.log('play_survey(' + id + ')');
}
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
		xhttp.open('POST', 'evoting.php', true);
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.onload = function() {
			table = JSON.parse(this.responseText);
			let tbody = document.querySelector('#tsurveys tbody');
			for (const row of table) {
				let r = document.createElement('tr');
				r.dataset['key'] = row.id;
				let td = document.createElement('td');
				for (const listb of [['add.svg','Ajouter un événement', add_survey], ['remove.svg', "Supprimer l'événement", remove_survey], ['edit.svg', 'Éditer les questions', edit_survey], ['play.svg', 'Lancer le questionnaire', play_survey]]) {
					let btn = document.createElement('button');
					btn.classList.add('small', 'tooltip');
					btn.onclick = () => listb[2](row.id);
					let span = document.createElement('span');
					span.classList.add('tooltiptext');
					span.innerHTML = listb[1];
					btn.appendChild(span);
					let img = document.createElement('img');
					img.src = listb[0];
					btn.appendChild(img);
					td.appendChild(btn);
				}
				r.appendChild(td);
				td = document.createElement('td');
				td.textContent = row.title;
				r.appendChild(td);
				td = document.createElement('td');
				td.textContent = row.fullname;
				r.appendChild(td);
				tbody.appendChild(r);
			}
		}
		xhttp.send('api=get-surveys');
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
	if (token) update_ui({view: 'surveys'}); else location.href = 'login.htm';
});
