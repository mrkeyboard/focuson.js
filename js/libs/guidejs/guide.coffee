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
			$('body').append @$els

			# In case we were initiated differently
			window.guidejs = @ if not window.guidejs

			# Extend defaults
			@conf = $.extend {}, @defaults, options

			# Easy access to elements
			@$shades = $ '#guidejs-top, #guidejs-left, #guidejs-right, #guidejs-bottom, #guidejs-focus'
			# ...
			@focus = $ '#guidejs-focus'
			@top 	 = $ '#guidejs-top'
			@bottom  = $ '#guidejs-bottom'
			@right 	 = $ '#guidejs-right'
			@left 	 = $ '#guidejs-left'
			@html 	 = $ '#guidejs-html'

			#@$shades.css
			#	'background-color': @conf.shade_color # @conf.shade_opacity	

			@nothing_to_play = @hide
			# Bind events
			#$(window).on 'resize scroll', => @render.apply @
			#@play()
			
			# ... 

		remove: ->
			#...
			# stop
			# remove els
			# remove guidejs

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
			
			# TODO: if auto_scroll, and target outside, then scroll to

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
			@focus.css 	content
			@right.css 		right
		

		play_next: () ->
			#return console.log("play_next when not playing") if not @playing
			# Get the next one to play
			@el_conf = @queue.shift()
			# Gto if we don't have anything. Execute the nothing fn if it exists
			if not @el_conf
				@nothing_to_play() if typeof @nothing_to_play is 'function'
				@stop()
				return 
			
			# Add HTML or re
			@remove_html()
			@set_html(@el_conf.html, @el_conf.position) if @el_conf.html
			# Events
			@html.on 'click', '.guidejs-next', => @play_next.apply @
			@html.on 'click', '.guidejs-hide', => @hide.apply @

			# Execute the next target
			setTimeout ()=> 
				@set_target @el_conf.el
			, 10
			# Page scroll
			$('body').css('overflow', if @el_conf.prevent_scroll then 'hidden' else 'auto')
			# The autoplay timer if the object's got some
			if @el_conf.timer			
				@timer = setTimeout =>
					do @play_next
				, @el_conf.timer
			
			return @

		opposite: (direction) ->
			if direction is 'right' then return 'left' else if direction is 'left' then return 'right'
			if direction is 'top' then return 'bottom' else if direction is 'bottom' then return 'top'
			return direction

		set_html: (content, direction) ->
			# Get all z-indexes back to 999999,
			@$shades.css('z-index', 999999)
			# Now append the html to the right side, 
			@html.appendTo('#guidejs-' + direction)
				.parent().css('z-index', 1999999) # and raise its z-index

			# Reset:
			@html.css(top:'auto',bottom:'auto',left:'auto',right:'auto', width: 'auto')
			# Positioning for the html wrapper
			wrapper_css = {}
			wrapper_css[@opposite(direction)] = '0px' 
			if direction is 'top' or direction is 'bottom'
				wrapper_css['text-align'] = 'center'
				wrapper_css['width'] = '100%'
			else 
				wrapper_css['text-align'] = @opposite direction
				# ... not perfect, more work to be done here
			
			@html.css wrapper_css

			# Attach the html
			$('#guidejs-html-inner', @html).html(content)

		remove_html: (time = 100) ->
			$old_html = $ $('#guidejs-html-inner', @html).children()
			$old_html.fadeTo time, 0, -> do $(@).remove

		# Public fns

		# Add an element to the queue
		add_to_queue: (element, options) ->
			return if not element
			# Push element object to the queue
			options = @default_el_options if not options
			@queue.push($.extend {}, @el_defaults, options, {el: $ element})
			# Start playing unless we have an option saying otherwise
			do @play if not @playing
		
		show: (play = no) ->
			@$shades.clearQueue()
				.show(0)
				.fadeTo @conf.fade_time, 1

			# play?
			return @

		hide: ->
			# Fadeout
			@$shades.clearQueue()
				.fadeTo @conf.fade_time, 0, -> $(@).hide(0)
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
			top  : 	0
			left : 	0
			h    :  $(window).height()
			w    :  $(window).width()
			el   :  window
		nothing_to_play: false #fn
		
		# Global defaults
		conf: {}
		defaults: 
			fade_time		: 250  	# In ms, time to fade in/out
			shade_opacity   : 0.7   # Opacity of the background
			shade_color     : '#0'  # Color of the background
		
		# Per-element on queue defaults
		el_conf: {}
		el_defaults:
			padding			: 5 	# In px, extra spacing from the element
			corner			: 5 	# In px, round corners 
			#auto_play		: no 	# Should it autoplay?
			timer			: no  # In ms, speed of the autoplay
			transition  	: 500   # In ms, speed of transition. 0 for disabled
			prevent_scroll	: no	# Prevent scroll
			html 			: no    # HTML to put next to the focused element
			position        : 'top'
		
		$els: $ "	<div id='guidejs-top' class='guidejs-row guidejs-shade'></div>
					<div id='guidejs-left' class='guidejs-shade'></div>
					<div id='guidejs-focus'><div class='guidejs-border'></div></div>
					<div id='guidejs-right' class='guidejs-shade'></div>
					<div id='guidejs-bottom' class='guidejs-row guidejs-shade'></div>
					<div id='guidejs-html'><div id='guidejs-html-inner'>content</div></div>"
		css: "<style>
				#guidejs-top,
				#guidejs-left,
				#guidejs-focus,
				#guidejs-right,
				#guidejs-bottom {
					position: fixed;
					top: 0px;
					display: block;
					z-index: 999999;
				}
				#guidejs-html {
					position: absolute;
					z-index: 1000000;
					width: 100%;
				}
				#guidejs-html-inner {
					display: inline-block; /* so we can center it */
					text-align:left;
				}
				.guidejs-row {
					width:100%;
				}
				.guidejs-shade
				{
					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */
				}
				/* inside border trick. this is removed for ie/opera */
				#guidejs-focus {
					pointer-events: none; /* So that content inside has mouse events */
					overflow:hidden;
				}
				#guidejs-focus .guidejs-border {
					display: block;
					height: 100%;
					width: 100%;
					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);
					border-radius: 5px;
				}
			</style>"

	# JQuery function
	$.fn.guidejs = (options)->
		# Add element to the queue
		return @each ->
			#console.log "adding", @
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




###
-   Add HTML content ontop of guide. Allow flexibility of positioning
-   Some calculations are wrong. The outcome looks ok but I think some
	elements go out of the window and they shouldn't. Extra check 
	horizontal cases

###