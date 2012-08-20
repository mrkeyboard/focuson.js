###
# # # # # # # # # # # # # # # # # # # # #
	guidejs - a javscript UI tutorial
# # # # # # # # # # # # # # # # # # # # #

Code by Ido Tal
License shit goes here

### 

(($) ->
	# Orchestring the show
	class guidejs 
		constructor: (options) ->
			# Append necessary html/css
			$('head').append @css
			$('body').append @template

			# In case we were initiated differently
			window.guidejs = @ if not window.guidejs

			# Extend defaults
			@conf = $.extend {},
					padding  : 0
					corner   : 5 #todo
					#...
				, options

			# All elements
			@$els    = $ '#guidejs-top, #guidejs-left, #guidejs-content, #guidejs-right, #guidejs-bottom'
			# Specific elements
			@top 	 = $ '#guidejs-top'
			@bottom  = $ '#guidejs-bottom'
			@right 	 = $ '#guidejs-right'
			@content = $ '#guidejs-content'
			@left 	 = $ '#guidejs-left'

			# Bind events
			$(window).on 'resize scroll', => @render.apply @
			
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
				top    	: @target.top - @conf.padding
				left   	: @target.left - @conf.padding
				width  	: @target.w + @conf.padding * 2
				height 	: @target.h + @conf.padding * 2
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
		
		add_to_queue: (el, play = yes) ->
			# ...
			return if not el
			@queue.push el
			do @play_next if play

		play_next: () ->
			setTimeout ()=> 
				@set_target(@queue.shift())
			, 0

			# If timer, set timeout...

			return @
		
		show: ->
			@els.clearQueue()
				.show(0)
				.fadeTo(1)

		hide: ->
			@els.clearQueue()
				.fadeTo(0)
				.hide(0)

		# Vars 
		playing: no
		queue: []
		target: 
			top: 0 
			left: 0
			h: $(window).height()
			w: $(window).width()
			el: window
		defaults:
			padding		: 5 	# In px, extra spacing from the element
			corner		: 5 	# In px, round corners 
			auto_play	: no 	# Should it autoplay?
			timer		: 2000  # In ms, speed of the autoplay
			transition  : 500   # In ms, speed of transition. 0 for disabled
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
				}
				.guidejs-row {
					width:100%;
				}
				.guidejs-shade
				{
					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */
				}
				#guidejs #guidejs-middle {
					font-size:0px;
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
			if not window.guidejs
				# Initiate a new class if we don't have one
				window.guidejs = new guidejs(@, options).add_to_queue @
			else 
				window.guidejs.add_to_queue @


			#if not $(@).data('accent') # init, param = options
			#	$(@).data('accent', new Accent(@, param)) 
			#else if typeof param is 'string' # function, param = function string
			#	$(@).data('accent')[param]()
			#@.data

)(jQuery)

$("#logo").guidejs {padding: 0, timer: 2000}


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