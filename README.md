# guide.js
A jquery library for creating simple UI tutorials. 

## What's it good for?
If you feel like your UI is just too awesome for users to handle at first glance, and you don't have the time for a redesign, how about a good ol' fashioned UI tutorial? guide.js fades out the whole screen except a single element you give it. You can then go and focus on another element after a set amount of time, or a button click. Along with the focused item, you can easily attach HTML right next to the element - allowing you to explain what the focused item is and how the user should interact with it. 

## Usage

Include guidejs by adding it to your html right after jquery:
`<script src="js/libs/guidejs/guide.js"></script>`
Now all you have to do is give guide.js an element through jquery's selector, and it will start the show for you!
`$("#awesome_ui_element").guidejs();`

By default, nothing happens now. 

???


there's a set timer of 4 seconds until guide.js goes to the next item on queue. Since you only have 1 item, it will fade away. 

If you add a few elements at once, they will be added to the queue. So in case you add all the h2 elements in your site, like so:
`$("h2").guidejs();`
guide.js will go through each title every four seconds and eventually fade out.

To change the timer, we can add a configuration object to the focused element. This config is not a global configuration, it only represents the parameters for the given set of elements. 
`$("h2").guidejs({timer:2500, transition: 1000});`
This line of code will tell guide.js to go through all the h2 elements, wait 2.5 seconds each, and have a slow 1 second transition between them. 




## Parameters

Here's a list of all possible parameters each element can take, as well as global parameters

### Element

* timer : 0 - in ms, amount of time between each element in queue. Does not autoplay if 0.
* padding : 0 - in px, amount of padding around the item
* corner : 5 - in px, amount of pixels for rounded corners around the element. Not supported in IE and Opera.
* transition: 500 - in ms, amount of time it takes for the animation to go from the previous element ot this one
* prevent_scroll: false - true or false, whether to prevent the page from scrolling or not
* html : false - If not false, contain an html string or a jquery object and appends it next to the focused element. Very recommended, good for extra information about the focused object. 
* position : 'left' - If there's an html to append, position is where to place it. Accepts left, right, top and bottom. Relative to the focused element, of course!


### Global
* shade_color : '#0' - color of the shade
* shade_opacity : 0.7 - 0.0-1.0, opacity of the shade
* el_default : {} - default empty, allows you to change the above element defaults. For example, if you know you want a 5 secodns timer between each element, you can just set it here instead of in each element. Usage:

`guidejs.config = {el_default:{timer:5000}, shade_opacity: 0.3} // Note 'el_default' is an object. Don't confuse and put 'timer' up in config directly, it won't work!`




## Fuck you