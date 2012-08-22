###
# # # # # # # # # # # # # # # # # # # # #
	guidejs - a javscript UI tutorial
# # # # # # # # # # # # # # # # # # # # #

Code by Ido Tal
License shit goes here

### 

(($) ->
	
	# Sup
	class guidejs 

		# Private fns
		constructor: (options = {}) ->
			# Append necessary html/css
			$('head').append @css
			$('body').append @template

			# In case we were initiated differently
			window.guidejs = @ if not window.guidejs

			# Extend defaults
			@conf = $.extend {}, @defaults, options

			# All elements
			@$els    = $ '#guidejs-top, #guidejs-left, #guidejs-content, #guidejs-right, #guidejs-bottom'
			# Specific elements
			@top 	 = $ '#guidejs-top'
			@bottom  = $ '#guidejs-bottom'
			@right 	 = $ '#guidejs-right'
			@content = $ '#guidejs-content'
			@left 	 = $ '#guidejs-left'

			@nothing_to_play = @hide
			# Bind events
			#$(window).on 'resize scroll', => @render.apply @
			#@play()
			
			# ... 

		set_target: (el, animate = 0) ->
			@target.el = (el = $ el)
			$(@target).animate 
					top: el.offset().top
					left: el.offset().left
					h: el.outerHeight()
					w: el.outerWidth() 
				,
					queue: false
					duration: @transition
					step: () =>
						@render.apply @

		# Update 
		render: ->
			# The target and its necessary padding
			target = 
				top    	: @target.top - @el_conf.padding
				left   	: @target.left - @el_conf.padding
				width  	: @target.w + @el_conf.padding * 2
				height 	: @target.h + @el_conf.padding * 2
			# The 'camera', our window position
			camera = 
				top 	: $(window).scrollTop() 
				left   	: 0 #...
				width  	: $(window).width()
				height 	: $(window).height()

			#console.log 'rendering', target, camera, @target.top
			
			# Top and bottom
			dy  	= target.top - camera.top
			top 	= 
				top    	: 0
				height 	: Math.max 0, dy
			mid 	= Math.max 0, (Math.min target.height, (target.height + dy))
			bottom 	= 
				top    	: mid + top.height
				height 	: camera.height - (mid)

			@top.css 		top
			@bottom.css 	bottom
			
			# Middle (left, right, and middle)
			dx    	= target.left - camera.left
			left  	= 
				top    : top.height
				left   : 0
				height : mid
				width  : target.left
			content = 
				top    : top.height
				left   : left.width
				width  : Math.max(0, (Math.min target.width, (target.width + dx)))
				height : mid
			right 	= 
				top    : top.height
				left   : left.width + content.width
				height : mid
				width  : camera.width - (left.width + content.width)

			@left.css 		left
			@content.css 	content
			@right.css 		right
		

		play_next: () ->
			return console.log("play_next when not playing") if not @playing
			# Get the next one to play
			@el_conf = @queue.shift()
			# Gto if we don't have anything. Execute the nothing fn if it exists
			return ((@nothing_to_play() if typeof @nothing_to_play is 'function') and @stop) if not @el_conf
			# Execute the next target
			setTimeout ()=> 
				@set_target @el_conf.el
			, 0
			
			# The autoplay timer if the object's got some
			if @el_conf.timer			
				@timer = setTimeout =>
					do @play_next
				, @el_conf.timer
			
			return @

		# Public fns

		# Add an element to the queue
		add_to_queue: (element, options) ->
			return if not element
			# Push element object to the queue
			options = @default_el_options if not options
			@queue.push $.extend {}, options, {el: $ element}
			# Start playing unless we have an option saying otherwise
			do @play if not @playing
		
		show: ->
			@$els.clearQueue()
				.show(0)
				.fadeTo(@conf.fade_time, 1)

			# play?

		hide: ->
			# Fadeout
			@$els.clearQueue()
				.fadeTo(@conf.fade_time, 0)
				.hide(0)
			
			# Stop any ongoing shits
			do @stop

		play: ->
			# If not already playing, and if there's anything to play
			return if @playing or not @queue.length
			# Set events
			$(window).on 'resize scroll', => @render.apply @
			# Declare that we are indeed playing, and play the next in the queue!
			@playing = yes
			do @play_next
			
			return @

		stop: ->
			# If we are playing
			return if not @playing
			# Remove events
			$(window).off 'resize scroll' # TODO this might collide with existing page events!!
			# Declare that we aren't playing no more 
			@playing = no
			
			return @

		# Vars 
		playing: no
		queue: []
		timer: no # current timer reference
		target: 
			top: 0 
			left: 0
			h: $(window).height()
			w: $(window).width()
			el: window
		nothing_to_play: false #fn
		# Global defaults
		conf: {}
		defaults: 
			fade_time	: 0  	# In ms, time to fade in/out
		# Per-element on queue defaults
		el_conf: {}
		el_defaults:
			padding		: 5 	# In px, extra spacing from the element
			corner		: 5 	# In px, round corners 
			#auto_play	: no 	# Should it autoplay?
			timer		: 2000  # In ms, speed of the autoplay
			transition  : 500   # In ms, speed of transition. 0 for disabled
			#scroll      : yes	# Prevent scroll
			# ...
		template: "	<div id='guidejs-top' class='guidejs-row guidejs-shade'></div>
					<div id='guidejs-left' class='guidejs-shade'></div>
					<div id='guidejs-content'><div class='guidejs-border'></div></div>
					<div id='guidejs-right' class='guidejs-shade'></div>
					<div id='guidejs-bottom' class='guidejs-row guidejs-shade'></div>"
		css: "<style>
				#guidejs-top,
				#guidejs-left,
				#guidejs-content,
				#guidejs-right,
				#guidejs-bottom {
					position: fixed;
					top: 0px;
					display: block;
					z-index: 999999;
				}
				.guidejs-row {
					width:100%;
				}
				.guidejs-shade
				{
					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */
				}
				/* inside border trick. this is removed for ie/opera */
				#guidejs-content {
					pointer-events: none; /* So that content inside has mouse events */
					overflow:hidden;
				}
				#guidejs-content .guidejs-border {
					display: block;
					height: 100%;
					width: 100%;
					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);
					border-radius: 5px;
				}
			</style>"

	# JQuery element function
	$.fn.guidejs = (options)->
		# Add element to the queue
		return @each ->
			console.log @
			if not window.guidejs
				# Initiate a new class if we don't have one
				window.guidejs = new guidejs(@, {}).add_to_queue @, options
			else 
				window.guidejs.add_to_queue @, options


			#if not $(@).data('accent') # init, param = options
			#	$(@).data('accent', new Accent(@, param)) 
			#else if typeof param is 'string' # function, param = function string
			#	$(@).data('accent')[param]()
			#@.data
)(jQuery)

$("h2").guidejs {padding: 0, timer: 2000}
$("#logo").guidejs {padding: 20, timer:2000}
#$("h3").guidejs {padding: 5, timer: 2000}

###
USAGE

set up: NOT REQUIRED
	window.guidejs {global_options:1}

focus on your first element:
	$('.el').guidejs {element_options:1}
this will initiate guidejs with its default 
settings if you didn;t

adding a few elements will add them to the queue

...

callback on end of the loop
	window.guidejs.nothing_to_play = function(){ ... }




###



###
TODO 
- 	Put this list as issues on github when it's up
- 	This was written as a per-element script at first. It is now
	a global controller of a highlighted 'guide'. Change the init 
	and general control flow of the script
- 	Animations: add fade in, fade out on show/hide
-   Add a steps queue - list of jq objs or selectors of targets 
	as well as HTML content for guidance
-   Add HTML content ontop of guide. Allow flexibility of positioning
-   Some calculations are wrong. The outcome looks ok but I think some
	elements go out of the window and they shouldn't. Extra check 
	horizontal cases
-   Allow the cool-ass corner border only for browsers with 
	pointer-events:none support. That way the element can be ontop of
	things without fucking up mouse events of the focused content
-   change_target functin, receives an element and animates to it
-   gogogo

###