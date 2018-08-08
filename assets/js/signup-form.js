document.addEventListener("DOMContentLoaded", function(event) {
  // - Code to execute when all DOM content is loaded. 
  // - including fonts, images, etc.
  
  var elements = document.getElementsByClassName("signup-form");
  Array.prototype.forEach.call(elements, function(div){

  	var $message = div.nextElementSibling.classList.contains("message") && div.nextElementSibling;
  	var $submit = div.querySelectorAll('input[type="submit"]');
    var currentType;
    $message._show = function(type, text) {

      var prefix = "";
  		//var iconClass = icon[type];
  		//if (iconClass) {
  		//	prefix = '<i class="fa ' + iconClass + '"></i>'
  		//}
  		currentType = type;
  		$message.innerHTML = prefix + text;
  		$message.classList.add(type);
  		$message.classList.add('visible');

      if (type == "success") {
        window.setTimeout(function() {
         $message._hide();
       }, 3000);
      }

    };

    $message._hide = function() {
      $message.classList.remove('visible');
      if (currentType) {
       $message.classList.remove(currentType);
     }
   };
   div.addEventListener('submit', function(event) {

    var email = div.querySelector("input[type=email]").value;
    event.stopPropagation();
    event.preventDefault();


    ga && ga('send', 'event', {
      eventCategory: 'signup',
      eventAction: 'submit'
    });
		// Hide message.
		$message._hide();

		// Disable submit.
		$submit.disabled = true;


    var timeStart = Date.now();
    var script = document.createElement('script');
    script.src = div.getAttribute('action') + "&c=signup_success&EMAIL=" + encodeURIComponent(email);

    window.signup_success = function(data)
    {
      ga('send', {
        hitType: 'timing',
        timingCategory: 'signup_form',
        timingVar: 'submission_complete',
        timingValue: (Date.now() - timeStart)
      });
      fbq && fbq('track', 'CompleteRegistration', { 'status' : (data.result || "failure")});
      if (data.result === "success") {
        $message._show('success', data.msg);
        ga && ga('send', 'event', {
          eventCategory: 'signup',
          eventAction: 'completed'
        });
        qb && qp('track', 'CompleteRegistration');
        window.dataLayer = window.dataLayer || [];
         window.dataLayer.push({
         'event': 'signup-completed'
         });
      } else {
        ga('send', 'exception', {
          'exDescription': (data.msg || "unknown error")
        });
        $message._show('failure', data.msg);
      }
      $submit.disabled = false;
      document.getElementsByTagName('head')[0].removeChild(script);
    }
    document.getElementsByTagName('head')[0].appendChild(script);
  });
 });
});

