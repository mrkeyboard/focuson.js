`(function( $ ) { `

Accent = (e, o)->
	@init(e, o)

Accent:: = 
	Constructor: Accent

	template: "	<div id='accentjs'>
					<div class='accentjs-row' id='accentjs-top'></div>
					<div class='accentjs-row' id='accentjs-middle'>
						<span id='accentjs-left'></span>
						<span id='accentjs-content'>
							<div class='accentjs-border'></div>
						</span>
						<span id='accentjs-right'></span>
					</div>
					<div class='accentjs-row' id='accentjs-bottom'></div>
				</div>"

	css: "<style>
			#accentjs {
				position: absolute;
				top:0px;

				z-index:999999;
				/*pointer-events:none; */
			}
			#accentjs.window {
				position:fixed;
				width:100%;
				height:100%;
			}
			#accentjs .accentjs-row {
				display:block;
				/*height:30px;
				width:120px;*/
			}
			#accentjs.round {
				border-radius: 10px;
			}
			#accentjs #accentjs-top,
			#accentjs #accentjs-bottom,
			#accentjs #accentjs-left,
			#accentjs #accentjs-right
			{
				background: rgba(0, 0, 0, .7);
				/* ;
				filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#4cffffff', endColorstr='#4cffffff'); */ /* IE */

			}

			#accentjs #accentjs-middle {
				font-size:0px;
			}
			#accentjs #accentjs-left,
			#accentjs #accentjs-right,
			#accentjs #accentjs-content {
				display: inline-block;
				height: 100%; /* as defined in middle/row */
				min-width: 10px;
			}
			/* inside border trick */
			#accentjs #accentjs-content {
				overflow:hidden;
			}
			#accentjs .accentjs-border {
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
				size     : window
				position : 1
				padding  : 0
				corner   : 5 #todo
				prevent_click: true #todo pointer-events:none
				prevent_highlight_click: false #todo 
			, options


		console.log @conf, options

		@$target = $ element  # target element
		@$el = $('#accentjs') # self

		# The elements that needs resizing:
		@top 	= $('#accentjs-top', @$el)
		@bottom = $('#accentjs-bottom', @$el)
		@middle = $('#accentjs-middle', @$el)
		@right 	= $('#accentjs-right', @$el)
		@highlight = $('#accentjs-content', @$el)
		@left 	= $('#accentjs-left', @$el)
		@rows 	= $('.accentjs-row', @$el)

		#console.log @top, @bottom, @$el
		# Events
		$(window).on 'resize', => @render.apply @
		$(window).on 'scroll', => @render.apply @
		#... close trigger events etc


		# Go!
		setTimeout => @render.apply @
		, 0
		
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

		return console.log("tba") if @conf.size is not window

		# window, rows = 100%
		@$el.addClass 'window'
		@rows.css width: '100%'

		# y
		dy  	= target.top - camera.top
		top 	= Math.max 0, dy
		mid 	= Math.max 0, (Math.min target.height, (target.height + dy))
		bottom 	= camera.height - (top + mid)

		@top.css 		height: top
		@middle.css 	height: mid
		@bottom.css 	height: bottom
		
		# x
		dx    		= target.left - camera.left
		left  		= Math.max 0, dx
		highlight 	= Math.max 0, (Math.min target.width, (target.width + dx))
		right 		= camera.width - (left + highlight)

		@left.css 		width: left
		@highlight.css 	width: highlight
		@right.css 		width: right
	
	show: ->
		# ...
		console.log "sjhow"

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

$(".btn-success").accent {padding: 10, corner: 10, prevent_click: false, prevent_highlight_click: false}
#$("#logo").accent('show')