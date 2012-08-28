# guide.js
A jquery library for creating UI tutorials. WIP

## What's it good for?
If you feel like your UI is just too awesome for users to handle at first glance, and you don't have the time for a redesign, how about a good ol' fashioned UI tutorial? guide.js fades out the whole screen except a single element you provide. 

You can then go and focus on another element - triggered after a set of time or a button click. Along with the focused element, you can easily attach HTML right next to it - allowing you to introduce it to the user and how should they interact with it. 

## Usage

Include guidejs by adding it to your html right after jquery:

`<script src="js/libs/guidejs/guide.js"></script>`

Now all you have to do is give guide.js an element through jquery's selector, and it will start the show for you!

`$("#awesome_ui_element").guidejs();`

The whole screen should now black out, leaving only the given element in focus. Awesome! 

You may add more elements at any given time. If you add a few elements at once, they will be added to the queue. So in case you add all the h2 elements in your site, like so:

`$("h2").guidejs();`

but hey - guidejs will only focused on the first item. So how do we cycle through them? You can define a timer using the element configuration object like so:

`$("h2").guidejs({timer:2500});`

provided with this code, guide.js will go through each title every 2.5 seconds and eventually fade out.
The object containing the timer key with the 2500 miliseconds value is the config object. It is NOT the global cofig, but only the given element(s) config.

If you want to change the global config, you may do this like so:

...

...

Going through the queued elements doesn't have to be by timers. You can also have a certain button clicked. So if a timer wasn't set, guidejs is waiting for an action to tell it to move on to the next element. This can be done manually with the guidejs.play() function.

You can also have HTML attached to the 

### Making a good tutorial

As much as I'd like guide.js to just make your site's UI clearer in two lines of code, I can't assure that. For best results, I'd recommend playing around with the parameters provided. Let me introduce what I believe is a good usage of guide.js and also a great UI tutorial of a possibly complex site. 

...

## Parameters

Here's a list of all possible parameters each element can take, as well as global parameters

### Element

* `timer: 0` - in ms, amount of time between each element in queue. Does not autoplay if 0.
* `padding: 0` - in px, amount of padding around the item
* `corner: 5` - in px, amount of pixels for rounded corners around the element. Not supported in IE and Opera.
* `transition: 500` - in ms, amount of time it takes for the animation to go from the previous element to this one
* `prevent_scroll: false` - true or false, whether to prevent the page from scrolling or not
* `auto_scroll: true` - true or false, whether to scroll to the newly focused element if it's out of the user's screen.
* `html: false` - If not false, contain an html string or a jquery object and appends it next to the focused element. Very recommended, good for extra information about the focused object. 
* `position: 'left'` - If there's an html to append, position is where to place it. Accepts left, right, top and bottom. Relative to the focused element, of course!

### Global

* `shade_color: '#0'` - color of the shade
* `shade_opacity: 0.7` - 0.0-1.0, opacity of the shade
* `el_default: {}` - default empty, allows you to change the above element defaults. For example, if you know you want a 5 secodns timer between each element, you can just set it here instead of in each element. Usage
`guidejs.config = {el_default:{timer:5000}, shade_opacity: 0.3} // Note 'el_default' is an object. Don't confuse and put 'timer' up in config directly, it won't work!`

## Global functions

* $('.el').guidejs(options = {}) - Adds the given elements to the queue, sets the options given to all of them.

TODO window.guidejs.conf 

* guidejs.hide - Force guide.js to fade out. Stops the currently playing timers if such exist
* guidejs.show(play = false) - Force guide.js to fade in, accepts a play parameter which resumes the timers back if set to true and such exist.
* guidejs.add_to_queue(element, options) - Directly add an element to the queue. It's recommended to use jquery's sweet selector though `$('.el').guidejs()` and not directly use this function. 


## HTML tips

It's highly recommended to attach HTML to your focused object, as stated in Usage. There are a few more things cool things

.guidejs-next

.guidejs-hide

...

## Credits
* guide.js by Ido Tal
* jquery by john resig - guidejs's only dependency 
* The example site in the repo was built with initializr by Jonathan Verrecchia. Credit also goes to HTML5 Boilerplate by Paul Irish, Divya Manian. Bootstrap by Mark Otto and @fat. 