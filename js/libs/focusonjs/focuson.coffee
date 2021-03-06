# --------------------------------------
#  focuson.js - a javscript highlighter
# --------------------------------------

(($) ->
	class focuson
		# The constructor initiates focuson on the page. Accepts an
		# optional configuration object, see @defaults
		constructor: (options = {}) ->
			# Append focuson html/css
			$('head').append @css
			$('body').append @$els

			# In case we were initiated differently
			window.focuson = @ if not window.focuson

			# Apply configuration
			@conf = $.extend @defaults, options
			@conf.on_complete ||= @hide

			# Quick access to all elements
			@$shades = $ '#focuson-top, #focuson-left, #focuson-right, #focuson-bottom, #focuson-focus'
			# And specific elements
			@focus  = $ '#focuson-focus'
			@border = $ '#focuson-focus .focuson-border'
			@top    = $ '#focuson-top'
			@bottom = $ '#focuson-bottom'
			@right 	= $ '#focuson-right'
			@left 	= $ '#focuson-left'
			@html 	= $ '#focuson-html'

			# Apply element colors
			@$shades.not(@focus).css 'background-color': 'rgba(' + @conf.shade_color + ', ' + @conf.shade_opacity + ')'
			@border.css 'box-shadow': '0px 0px 0px 15px rgba(' + @conf.shade_color + ', ' + @conf.shade_opacity + ')'

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
			
			# Top and bottom
			dy  	= target.top - camera.top
			top 	= 
				top    	: 0
				height 	: Math.max 0, dy
			mid 	= Math.max 0, (Math.min target.height, (target.height + dy))
			bottom 	= 
				top    	: mid + top.height
				height 	: camera.height - (mid)

			@top.css 	top
			@bottom.css bottom
			
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

			@left.css 	left
			@focus.css 	content
			@right.css 	right
		
		play_next: () ->
			# Get the next one to play, unless timer has not reached 0 in which case
			# we are going to play the same element, which was probably paused
			@el_conf = @queue.shift() if not @timer #@el_conf.timer
			# Gtfo if we don't have anything. Execute the nothing fn if it exists
			if not @el_conf
				@el_conf = {} # No current object 
				@conf.on_complete?()
				return @stop()
			
			# Add HTML or re
			@remove_html()
			@set_html(@el_conf.html, @el_conf.position) if @el_conf.html
			# Events
			@html.on 'click', '.focuson-next', => @play_next.apply @
			@html.on 'click', '.focuson-hide', => @hide.apply @
			
			# Page scroll
			$('body').css('overflow', if @el_conf.prevent_scroll then 'hidden' else 'auto')
			
			# Update border radius
			@border.css {'border-radius': @el_conf.corner+'px'}
			
			# Execute the next target
			setTimeout (()=> @set_target @el_conf.el), 1
			
			# Store the exact time we started the timer, used to 
			# find the delta if later paused 
			@start_of_timeout = new Date()
			
			# Run timer
			if @el_conf.timer
				@timer = setTimeout =>
					@elapsed_time = 0 # Reset elapsed time
					@timer = 0 		  # Reset @timer id
					@play_next() 	  # Play next element
				# How long should we run? The element config timer minus the 
				# elapsed time, if any. Elaprsed_time is set through @stop
				# and calculates the amount of time that was already played
				, @el_conf.timer - @elapsed_time 
				
			return @

		opposite: (direction) ->
			if direction is 'right' then return 'left' else if direction is 'left' then return 'right'
			if direction is 'top' then return 'bottom' else if direction is 'bottom' then return 'top'
			return direction

		set_html: (content, direction) ->
			# Get all z-indexes back to 999999,
			@$shades.css('z-index', 999999)
			# Now append the html to the right side, 
			@html.appendTo('#focuson-' + direction)
				.parent().css('z-index', 1999999) # and raise its z-index

			# Reset
			@html.css(top:'auto', bottom:'auto', left:'auto', right:'auto', width: 'auto')
			# Positioning for the html wrapper
			wrapper_css = {}
			wrapper_css[@opposite(direction)] = '0px' 
			if direction is 'top' or direction is 'bottom'
				wrapper_css['text-align'] = 'center'
				wrapper_css['width'] = '100%'
			else 
				wrapper_css['text-align'] = @opposite direction
				# ... more work to be done here
			
			@html.css wrapper_css

			# Attach the html
			$('#focuson-html-inner', @html).html(content)

		remove_html: (time = 100) ->
			$old_html = $ $('#focuson-html-inner', @html).children()
			$old_html.fadeTo time, 0, -> do $(@).remove

		destroy: ->
			@stop() # Stop any ongoing action
			@$shades.remove() # Remove all elements
			delete @


		# Add an element to the queue
		add_to_queue: (element, options) ->
			return if not element
			# Push element object to the queue
			options = @default_el_options if not options
			@queue.push($.extend {}, @el_defaults, options, {el: $ element})
			# Start playing
			do @play if not @playing
		
		# Fade everything in
		show: (play = no) ->
			@$shades.clearQueue()
				.show(0)
				.fadeTo @conf.fade_time, 1
			return @

		# Fade everything out
		hide: =>
			@$shades.clearQueue()
				.fadeTo @conf.fade_time, 0, -> $(@).hide(0)
			# Stop anything ongoing
			do @stop

		# Start the show
		play: ->
			# If not already playing, and if nothing is currently playing (paused)
			return if @playing 
			# Set events
			$(window).on 'resize scroll', @render_this = (=> @render.apply @) # This is kinda terrible
			# Declare that we are indeed playing, and play the next in the queue!
			@playing = yes
			do @play_next
			
			return @

		# Stop the show
		stop: ->
			return if not @playing
				
			# Store the time between the start of the timer and now.
			# Continue when it's later played again. Use clearInterval 
			# to pause the ongoing timer. 
			@elapsed_time = new Date() - @start_of_timeout 
			clearInterval @timer 

			# Remove events
			$(window).off 'resize scroll', @render_this
			# We aren't playing no more 
			@playing = no
			
			return @

		# Variables 
		playing: no # Current state
		queue  : [] # Array of objects in line to play next
		timer  : 0  # Current interval id, if any
		target : 
			top  : 	0
			left : 	0
			h    :  $(window).height()
			w    :  $(window).width()
			el   :  window

		elapsed_time: 0 		# Set through @stop, it counts the delta between when
								# timer started playing (@start_of_timeout) and the
								# just-stopped playing time
		start_of_timeout: 0 	# Time we started the timer
		
		# Global configuration defaults
		conf: {} # Current configuration
		defaults: 
			fade_time		: 250       # In ms, time to fade in/out
			shade_opacity   : '0.5'     # Opacity of the background
			shade_color     : '0, 0, 0' # Color of the background
			on_complete     : false  	# Function to call when next() is called
										# and there's nothing to play
		
		# Per-element on queue defaults
		el_conf: {} # Current element configuration
		el_defaults:
			padding			: 5     # In px, extra spacing from the element
			corner			: 5     # In px, round corners 
			#auto_play		: no 	# Should it autoplay?
			timer			: no    # In ms, speed of the autoplay
			transition  	: 500   # In ms, speed of transition. 0 for disabled
			prevent_scroll	: no    # Prevent scroll
			html 			: no    # HTML to put next to the focused element
			position        : 'top' #
		
		$els: $ "	<div id='focuson-top' class='focuson-row focuson-shade'></div>
					<div id='focuson-left' class='focuson-shade'></div>
					<div id='focuson-focus'><div class='focuson-border'></div></div>
					<div id='focuson-right' class='focuson-shade'></div>
					<div id='focuson-bottom' class='focuson-row focuson-shade'></div>
					<div id='focuson-html'><div id='focuson-html-inner'>content</div></div>"
		css: "<style>
				#focuson-top,
				#focuson-left,
				#focuson-focus,
				#focuson-right,
				#focuson-bottom {
					position: fixed;
					top: 0px;
					display: block;
					z-index: 999999;
				}
				#focuson-html {
					position: absolute;
					z-index: 1000000;
					width: 100%;
				}
				#focuson-html-inner {
					display: inline-block; /* so we can center it */
					text-align:left;
				}
				.focuson-row {
					width:100%;
				}
				.focuson-shade
				{
					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */
				}
				/* inside border trick. this is removed for ie/opera */
				#focuson-focus {
					pointer-events: none; /* So that content inside has mouse events */
					overflow:hidden;
				}
				#focuson-focus .focuson-border {
					display: block;
					height: 100%;
					width: 100%;
					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);
					border-radius: 5px;
				}
			</style>"

	# JQuery implementation
	$.fn.focusOn = (options)->
		# Add each element to the queue
		return @each ->
			if window.focuson
				window.focuson.add_to_queue @, options
			else 
				# Initiate a new class if we don't have one
				window.focuson = new focuson(@, {}).add_to_queue @, options
)(jQuery)
