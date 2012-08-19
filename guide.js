// Generated by CoffeeScript 1.3.3
(function() {
  (function( $ ) { ;

  var Accent, log;

  Accent = function(e, o) {
    return this.init(e, o);
  };

  Accent.prototype = {
    Constructor: Accent,
    template: "	<div id='accentjs'>					<div class='accentjs-row' id='accentjs-top'></div>					<div class='accentjs-row' id='accentjs-middle'>						<span id='accentjs-left'></span>						<span id='accentjs-content'>							<div class='accentjs-border'></div>						</span>						<span id='accentjs-right'></span>					</div>					<div class='accentjs-row' id='accentjs-bottom'></div>				</div>",
    css: "<style>			#accentjs {				position: absolute;				top:0px;				z-index:999999;				/*pointer-events:none; */			}			#accentjs.window {				position:fixed;				width:100%;				height:100%;			}			#accentjs .accentjs-row {				display:block;				/*height:30px;				width:120px;*/			}			#accentjs.round {				border-radius: 10px;			}			#accentjs #accentjs-top,			#accentjs #accentjs-bottom,			#accentjs #accentjs-left,			#accentjs #accentjs-right			{				background: rgba(0, 0, 0, .7);				/* ;				filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#4cffffff', endColorstr='#4cffffff'); */ /* IE */			}			#accentjs #accentjs-middle {				font-size:0px;			}			#accentjs #accentjs-left,			#accentjs #accentjs-right,			#accentjs #accentjs-content {				display: inline-block;				height: 100%; /* as defined in middle/row */				min-width: 10px;			}			/* inside border trick */			#accentjs #accentjs-content {				overflow:hidden;			}			#accentjs .accentjs-border {				display: block;				height: 100%;				width: 100%;				box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);				border-radius: 5px;			}		</style>",
    init: function(element, options) {
      var _this = this;
      console.log("init", this, element);
      $('head').append(this.css);
      $('body').append(this.template);
      this.conf = $.extend({}, {
        size: window,
        position: 1,
        padding: 0,
        corner: 5,
        prevent_click: true,
        prevent_highlight_click: false
      }, options);
      console.log(this.conf, options);
      this.$target = $(element);
      this.$el = $('#accentjs');
      this.top = $('#accentjs-top', this.$el);
      this.bottom = $('#accentjs-bottom', this.$el);
      this.middle = $('#accentjs-middle', this.$el);
      this.right = $('#accentjs-right', this.$el);
      this.highlight = $('#accentjs-content', this.$el);
      this.left = $('#accentjs-left', this.$el);
      this.rows = $('.accentjs-row', this.$el);
      $(window).on('resize', function() {
        return _this.render.apply(_this);
      });
      $(window).on('scroll', function() {
        return _this.render.apply(_this);
      });
      return setTimeout(function() {
        return _this.render.apply(_this, 0);
      });
    },
    render: function() {
      var bottom, camera, dx, dy, highlight, left, mid, right, target, top;
      target = {
        top: this.$target.offset().top - this.conf.padding,
        left: this.$target.offset().left - this.conf.padding,
        width: this.$target.outerWidth() + this.conf.padding * 2,
        height: this.$target.outerHeight() + this.conf.padding * 2
      };
      camera = {
        top: $(window).scrollTop(),
        left: 0,
        width: $(window).width(),
        height: $(window).height()
      };
      console.log('rendering', target, camera);
      if (this.conf.size === !window) {
        return console.log("tba");
      }
      this.$el.addClass('window');
      this.rows.css({
        width: '100%'
      });
      dy = target.top - camera.top;
      top = Math.max(0, dy);
      mid = Math.max(0, Math.min(target.height, target.height + dy));
      bottom = camera.height - (top + mid);
      this.top.css({
        height: top
      });
      this.middle.css({
        height: mid
      });
      this.bottom.css({
        height: bottom
      });
      dx = target.left - camera.left;
      left = Math.max(0, dx);
      highlight = Math.max(0, Math.min(target.width, target.width + dx));
      right = camera.width - (left + highlight);
      this.left.css({
        width: left
      });
      this.highlight.css({
        width: highlight
      });
      return this.right.css({
        width: right
      });
    },
    show: function() {
      return console.log("sjhow");
    },
    hide: function() {
      return console.log("hide");
    }
  };

  $.fn.accent = function(param) {
    return this.each(function() {
      if (!$(this).data('accent')) {
        return $(this).data('accent', new Accent(this, param));
      } else if (typeof param === 'string') {
        return $(this).data('accent')[param]();
      }
    });
  };

  })(window.jQuery);


  log = console.log;

  $(".btn-success").accent({
    padding: 10,
    corner: 10,
    prevent_click: false,
    prevent_highlight_click: false
  });

}).call(this);
