# focuson.js
Highlight elements on your webpage in a jiffy!

## What's it good for?
If you feel like your UI is just too awesome for users to handle at first glance, how about a good ol' fashioned, step-by-step UI tutorial? focuson.js casually fades out the whole screen except a single element you provide. The perfect tool for shitty user experience!

## Usage

Include focuson.js by adding it to your html right after jQuery:

```html
<script src="js/libs/focusonjs/focuson.js"></script>
```

Now all you have to do is give focuson.js an element through jQuery's selector:

```javascript
$("#notice_me").focusOn(); // Screen fades out, highlighting only #notice_me element
```

The whole screen should now black out, leaving only the given element in the spotlight. Awesome! 


If you add a few elements at once, they will be added to the *queue*. For example:

```javascript
$("h2").focusOn(); // Add all h2 elements to the queue
```

but hey - focuson will only focus on the first item, as it can only focus on one item at a time. So how do we cycle through them? You can declare a timer using the *element configuration object* like so:

```javascript
$("h2").focusOn({timer: 2500}); // Add all h2 elements to the queue, cycle through them every 2.5 seconds
```

provided this code, focuson will go through each `<h2>` title every 2.5 seconds and eventually fade out. Read below for more information about focuson.js parameters.


If a timer wasn't set, focuson will be waiting for an action to tell it to move on to the next element. This can be done manually with the `focuson.play()` function, or alternatively, you could have a link in the tutorial-text, with a `.focuson-next` class. 

**Recommended:** You can add HTML right next to the focused item easily! Here's how:

```html
<h2>Hello, focus on me first.</h2>
<h2>Me right after!</h2>
<script>
	var my_html = $("<div>Awesome stuff in a box! <a class='focuson-next' href='#'>Next!</a></div>")
	$("h2").focusOn({html: my_html});
</script>
```

`my_html` will now appear next to the focused `<h2>` element. Notice the `focuson-next` class on the link inside the provided html - focuson will recognize it and move on to the next element in the queue by clicking on it. Sweet!

## Parameters

Here's a list of parameters for focuson.js

### Element 
Per-element configuration object, provided through the first parameter when initated on an element, as in `$('h2').focusOn({param1: 10, param2: 20, ...})`

```javascript
$('#el').focusOn({
	  timer     : 0   // in ms, time between each element in queue. Does not autoplay if 0.
	, padding   : 0   // in px, amount of padding around the item
	, corner    : 5   // in px, amount of pixels for rounded corners around the element. Not supported in IE and Opera.
	, transition: 500 // in ms, amount of time it takes for the animation to go from the previous element to this one
	, prevent_scroll: false // boolean, whether to prevent the user from scrolling the page or not
	, auto_scroll   : true  // boolean, whether to scroll to the newly focused element if it's out of the user's screen.
	, html     : "<h2>hello world</h2>" // Accepts HTML string or a jquery object. Appends it next to the focused element. Good for extra information about the focused object like tooltips. 
	, position : "left" // If there's an html to append, position is where to place it. Accepts 'left', 'right', 'top' and 'bottom' - relative to the focused element.
});
```

## Global functions

* `$('.el').focusOn({params:'go here'})` - Adds the given elements to the queue, sets the options given to all of them.
* `focusOn.hide()` - Force focuson.js to fade out. Stops the currently playing timers if such exist
* `focusOn.show(play = false)` - Force focuson.js to fade in, accepts a `play` parameter which resumes the timers back if set to true.
* `focusOn.add_to_queue(element, options)` - Directly add an element to the queue. It's recommended to use jquery's sweet selector though `$('.el').focusOn()` and not directly use this function 

## Thank yous:
* jQuery, Bootstrap, HTML5 Boilerplate, Initializr