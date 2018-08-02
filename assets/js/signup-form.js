document.addEventListener("DOMContentLoaded", function(event) {
  // - Code to execute when all DOM content is loaded. 
  // - including fonts, images, etc.
  var elements = document.getElementsByClassName("signup-form");
  Array.prototype.forEach.call(elements, function(div){

	var $submit = div.querySelectorAll('input[type="submit"]');
  	div.addEventListener('submit', function(event) {

		var email = div.querySelector("input.email").value;
		event.stopPropagation();
		event.preventDefault();

		// Hide message.
		//$message._hide();

		// Disable submit.
		$submit.disabled = true;


		var script = document.createElement('script');
		script.src = div.getAttribute('action') + "&c=signup_success&EMAIL=" + encodeURIComponent(email);

		window.signup_success = function(data)
		{
			if (data.result === "success") {
				//$message._show('success', data.msg);
			} else {
				//$message._show('failure', data.msg);
			}
			$submit.disabled = false;
			document.getElementsByTagName('head')[0].removeChild(script);
		}
		document.getElementsByTagName('head')[0].appendChild(script);
	});
  });
});
