`(function( $ ) { `

Accent = (e, o)->
	@init(e, o)

Accent:: = 
	Constructor: Accent

	template: "
				<div id='guidejs-top' class='guidejs-row guidejs-shade'></div>
				<div id='guidejs-left' class='guidejs-shade'></div>
				<div id='guidejs-content'>
					<div class='guidejs-border'></div>
				</div>
				<div id='guidejs-right' class='guidejs-shade'></div>
				<div id='guidejs-bottom' class='guidejs-row guidejs-shade'></div>
				"
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
				background: rgba(0, 0, 0, .7);
				/* ;
				filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#4cffffff', endColorstr='#4cffffff'); */ /* IE */
			}
			#guidejs #guidejs-middle {
				font-size:0px;
			}
			/* inside border trick */
			#guidejs-content {
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

	init: (element, options) ->
		# ...
		console.log "init", @, element
		
		# this is a prototype so fuckyou
		$('head').append @css
		$('body').append @template

		@conf = $.extend {},
				padding  : 0
				corner   : 5 #todo
				prevent_click: true #todo pointer-events:none
				prevent_highlight_click: false #todo 
			, options


		console.log @conf, options

		@$target = $ element  # target element
		@$el = $('#guidejs-top, #guidejs-left, #guidejs-content, #guidejs-right, #guidejs-bottom')

		# The elements that needs resizing:
		@top 	= $('#guidejs-top')
		@bottom = $('#guidejs-bottom')
		@right 	= $('#guidejs-right')
		@content = $('#guidejs-content')
		@left 	= $('#guidejs-left')

		#console.log @top, @bottom, @$el
		# Events
		$(window).on 'resize', => @render.apply @
		$(window).on 'scroll', => @render.apply @
		#... close trigger events etc


		# Go!
		setTimeout(()=> 
			@render.apply(@)
		, 0)
		
		# hide and if on init then show
		#@show()

	# Update shit
	render: ->

		target = 
			top    : @$target.offset().top - @conf.padding
			left   : @$target.offset().left - @conf.padding
			width  : @$target.outerWidth() + @conf.padding * 2
			height : @$target.outerHeight() + @conf.padding * 2
		camera = 
			top    : $(window).scrollTop() 
			left   : 0
			width  : $(window).width()
			height : $(window).height()

		console.log 'rendering', target, camera

		#return console.log("tba") if @conf.size is not window

		
		# y
		dy  	= target.top - camera.top
		top 	= 
			top    : 0
			height : Math.max 0, dy
		mid 	= Math.max 0, (Math.min target.height, (target.height + dy))
		bottom 	= 
			top    : mid + top.height
			height : camera.height - (mid)

		@top.css 		top
		@bottom.css 	bottom
		
		# x
		dx    	= target.left - camera.left
		left  	= 
			top    : top.height
			left   : 0
			height : mid
			width  : target.left
		content = Math.max 0, (Math.min target.width, (target.width + dx))
		right 	= 
			top    : top.height
			left   : left.width + content
			height : mid
			width  : camera.width - (left.width + content)

		@left.css 		left
		#@content.css 	content
		@right.css 		right
	
	show: ->
		# ...
		console.log "show"

	hide: ->
		#...
		console.log "hide"


$.fn.accent = (param)->
	
	return @each ->
		if not $(@).data('accent') # init, param = options
			$(@).data('accent', new Accent(@, param)) 
		else if typeof param is 'string' # function, param = function string
			$(@).data('accent')[param]()
		#@.data


`})(window.jQuery)`

log = console.log

$("#logo").accent {padding: 0, corner: 10, prevent_click: false, prevent_highlight_click: false}
#$("#logo").accent('show')

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