# guide.js
A jQuery library for creating UI tutorials.

## What's it good for?
If you feel like your UI is just too awesome for users to handle at first glance, how about a good ol' fashioned, step-by-step UI tutorial? guide.js casually fades out the whole screen except a single element you provide.

## Usage

Include guide.js by adding it to your html right after jquery:

```html
<script src="js/libs/guidejs/guide.js"></script>
```

Now all you have to do is give guide.js an element through jQuery's selector selector:

```javascript
$("#awesome_ui_element").guidejs();
```

The whole screen should now black out, leaving only the given element in focus. Awesome! 


If you add a few elements at once, they will be added to the *queue*. For example:

```javascript
$("h2").guidejs();
```

but hey - guidejs will only focused on the first item. So how do we cycle through them? You can declare a timer using the *element configuration object* like so:

```javascript
$("h2").guidejs({timer:2500});
```

provided with this code, guide.js will go through each h2 title every 2.5 seconds and eventually fade out (because the last h2 element in queue also has a timer, and nothing coems after). Please read below for more information about guide-js parameters.


If a timer wasn't set, guidejs is waiting for an action to tell it to move on to the next element. This can be done manually with the `guidejs.play()` function, or alternatively, you could have a link in the tutorial-text, with a `guidejs-next` class. 

**Recommended:** You can add HTML right next to the focused item easily! Here's how:

```html
<h2>Hello! Focus on me first.</h2>
<h2>Me right after!</h2>
var my_html = $("<div>Awesome stuff in a box! <a class='guidejs-next' href='#'>Next!</a></div>")
$("h2").guidejs({html:my_html});
```

`my_html` will now appear next to the focused `<h2>` element. Notice the `guidejs-next` class on the link inside the provided html - guidejs will recognize it and move on to the next element in the queue by clicking on it. Sweet!

## Parameters

Here's a list of all possible parameters each element can take, as well as global parameters.

NOTE: The object containing the timer key with the 2500 miliseconds value is the config object. It is NOT the global cofig, but only the given element(s) config.

### Element 
Per-element parameters, provided through the first param when initated on an element, as in `$('h2').({params:'go here'})`

* `timer: 0` - in ms, amount of time between each element in queue. Does not autoplay if 0.
* `padding: 0` - in px, amount of padding around the item
* `corner: 5` - in px, amount of pixels for rounded corners around the element. Not supported in IE and Opera.
* `transition: 500` - in ms, amount of time it takes for the animation to go from the previous element to this one
* `prevent_scroll: false` - true or false, whether to prevent the page from scrolling or not
* `auto_scroll: true` - true or false, whether to scroll to the newly focused element if it's out of the user's screen.
* `html: false` - If not false, expects an html string or a jquery object. Appends it next to the focused element. Good for extra information about the focused object. 
* `position: 'left'` - If there's an html to append, position is where to place it. Accepts `left`, `right`, `top` and `bottom`. Relative to the focused element.

### Global parameters

* `shade_color: '#0'` - color of the shade
* `shade_opacity: 0.7` - 0.0-1.0, opacity of the shade
* `el_default: {}` - default empty, allows you to change the above element defaults. For example, if you know you want a 5 secodns timer between each all elements, you can just set it here instead of in each of them. Usage:

```javascript
guidejs.config = {el_default:{timer:5000}, shade_opacity: 0.3} // Note 'el_default' is an object. Don't confuse and put 'timer' up in config directly, it won't work!```


## Global functions

* `$('.el').guidejs({params:'go here'})` - Adds the given elements to the queue, sets the options given to all of them.

TODO window.guidejs.conf 

* guidejs.hide - Force guide.js to fade out. Stops the currently playing timers if such exist
* guidejs.show(play = false) - Force guide.js to fade in, accepts a play parameter which resumes the timers back if set to true and such exist.
* guidejs.add_to_queue(element, options) - Directly add an element to the queue. It's recommended to use jquery's sweet selector though `$('.el').guidejs()` and not directly use this function. 


## HTML tips
WIP 
.guidejs-next
.guidejs-hide
...


## Credits
* guide.js by Ido Tal
* jquery by john resig - guidejs's only dependency 
* The example site in the repo was built with initializr by Jonathan Verrecchia. Credit also goes to HTML5 Boilerplate by Paul Irish, Divya Manian. Bootstrap by Mark Otto and @fat. 