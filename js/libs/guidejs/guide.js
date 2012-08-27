// Generated by CoffeeScript 1.3.3

/*
# # # # # # # # # # # # # # # # # # # # #
	guidejs - a javscript UI tutorial
# # # # # # # # # # # # # # # # # # # # #

Code by Ido Tal
License shit goes here
*/


(function() {

  (function($) {
    var guidejs;
    guidejs = (function() {

      function guidejs(options) {
        if (options == null) {
          options = {};
        }
        $('head').append(this.css);
        $('body').append(this.$els);
        if (!window.guidejs) {
          window.guidejs = this;
        }
        this.conf = $.extend({}, this.defaults, options);
        this.$shades = $('#guidejs-top, #guidejs-left, #guidejs-right, #guidejs-bottom, #guidejs-content');
        this.content = $('#guidejs-content');
        this.top = $('#guidejs-top');
        this.bottom = $('#guidejs-bottom');
        this.right = $('#guidejs-right');
        this.left = $('#guidejs-left');
        this.html = $('#guidejs-html');
        this.nothing_to_play = this.hide;
      }

      guidejs.prototype.remove = function() {};

      guidejs.prototype.set_target = function(el, animate) {
        var _this = this;
        if (animate == null) {
          animate = 0;
        }
        this.target.el = (el = $(el));
        return $(this.target).animate({
          top: el.offset().top,
          left: el.offset().left,
          h: el.outerHeight(),
          w: el.outerWidth()
        }, {
          queue: false,
          duration: this.transition,
          step: function() {
            return _this.render.apply(_this);
          }
        });
      };

      guidejs.prototype.render = function() {
        var bottom, camera, content, dx, dy, left, mid, right, target, top;
        target = {
          top: this.target.top - this.el_conf.padding,
          left: this.target.left - this.el_conf.padding,
          width: this.target.w + this.el_conf.padding * 2,
          height: this.target.h + this.el_conf.padding * 2
        };
        camera = {
          top: $(window).scrollTop(),
          left: 0,
          width: $(window).width(),
          height: $(window).height()
        };
        dy = target.top - camera.top;
        top = {
          top: 0,
          height: Math.max(0, dy)
        };
        mid = Math.max(0, Math.min(target.height, target.height + dy));
        bottom = {
          top: mid + top.height,
          height: camera.height - mid
        };
        this.top.css(top);
        this.bottom.css(bottom);
        dx = target.left - camera.left;
        left = {
          top: top.height,
          left: 0,
          height: mid,
          width: target.left
        };
        content = {
          top: top.height,
          left: left.width,
          width: Math.max(0, Math.min(target.width, target.width + dx)),
          height: mid
        };
        right = {
          top: top.height,
          left: left.width + content.width,
          height: mid,
          width: camera.width - (left.width + content.width)
        };
        this.left.css(left);
        this.content.css(content);
        return this.right.css(right);
      };

      guidejs.prototype.play_next = function() {
        var _this = this;
        if (!this.playing) {
          return console.log("play_next when not playing");
        }
        this.el_conf = this.queue.shift();
        if (!this.el_conf) {
          if (typeof this.nothing_to_play === 'function') {
            this.nothing_to_play();
          }
          this.stop();
          return;
        }
        if (this.el_conf.html) {
          this.set_html(this.el_conf.html, this.el_conf.position);
        }
        setTimeout(function() {
          return _this.set_target(_this.el_conf.el);
        }, 10);
        $('body').css('overflow', this.el_conf.prevent_scroll ? 'hidden' : 'auto');
        if (this.el_conf.timer) {
          this.timer = setTimeout(function() {
            return _this.play_next();
          }, this.el_conf.timer);
        }
        return this;
      };

      guidejs.prototype.opposite = function(direction) {
        if (direction === 'right') {
          return 'left';
        } else if (direction === 'left') {
          return 'right';
        }
        if (direction === 'top') {
          return 'bottom';
        } else if (direction === 'bottom') {
          return 'top';
        }
        return direction;
      };

      guidejs.prototype.set_html = function(content, direction) {
        var new_css;
        this.$shades.css('z-index', 999999);
        this.html.appendTo('#guidejs-' + direction).parent().css('z-index', 1999999);
        this.html.css({
          top: 'auto',
          bottom: 'auto',
          left: 'auto',
          right: 'auto'
        });
        new_css = {};
        new_css[this.opposite(direction)] = '0px';
        return this.html.html(content).css(new_css);
      };

      guidejs.prototype.add_to_queue = function(element, options) {
        if (!element) {
          return;
        }
        if (!options) {
          options = this.default_el_options;
        }
        this.queue.push($.extend({}, this.el_defaults, options, {
          el: $(element)
        }));
        if (!this.playing) {
          return this.play();
        }
      };

      guidejs.prototype.show = function() {
        return this.$shades.clearQueue().show(0).fadeTo(this.conf.fade_time, 1);
      };

      guidejs.prototype.hide = function() {
        this.$shades.clearQueue().fadeTo(this.conf.fade_time, 0);
        return this.stop();
      };

      guidejs.prototype.play = function() {
        var _this = this;
        if (this.playing || !this.queue.length) {
          return;
        }
        $(window).on('resize scroll', function() {
          return _this.render.apply(_this);
        });
        this.playing = true;
        this.play_next();
        return this;
      };

      guidejs.prototype.stop = function() {
        if (!this.playing) {
          return;
        }
        $(window).off('resize scroll');
        this.playing = false;
        return this;
      };

      guidejs.prototype.playing = false;

      guidejs.prototype.queue = [];

      guidejs.prototype.timer = false;

      guidejs.prototype.target = {
        top: 0,
        left: 0,
        h: $(window).height(),
        w: $(window).width(),
        el: window
      };

      guidejs.prototype.nothing_to_play = false;

      guidejs.prototype.conf = {};

      guidejs.prototype.defaults = {
        fade_time: 250,
        shade_opacity: 0.7,
        shade_color: '#0'
      };

      guidejs.prototype.el_conf = {};

      guidejs.prototype.el_defaults = {
        padding: 5,
        corner: 5,
        timer: false,
        transition: 500,
        prevent_scroll: false,
        html: false,
        position: 'top'
      };

      guidejs.prototype.$els = $("	<div id='guidejs-top' class='guidejs-row guidejs-shade'></div>					<div id='guidejs-left' class='guidejs-shade'></div>					<div id='guidejs-content'><div class='guidejs-border'></div></div>					<div id='guidejs-right' class='guidejs-shade'></div>					<div id='guidejs-bottom' class='guidejs-row guidejs-shade'></div>					<div id='guidejs-html'>content</div>");

      guidejs.prototype.css = "<style>				#guidejs-top,				#guidejs-left,				#guidejs-content,				#guidejs-right,				#guidejs-bottom {					position: fixed;					top: 0px;					display: block;					z-index: 999999;				}				#guidejs-html {					position: absolute;					top: 0px;					left: 0px;					z-index: 1000000;				}				.guidejs-row {					width:100%;				}				.guidejs-shade				{					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */				}				/* inside border trick. this is removed for ie/opera */				#guidejs-content {					pointer-events: none; /* So that content inside has mouse events */					overflow:hidden;				}				#guidejs-content .guidejs-border {					display: block;					height: 100%;					width: 100%;					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);					border-radius: 5px;				}			</style>";

      return guidejs;

    })();
    return $.fn.guidejs = function(options) {
      return this.each(function() {
        if (!window.guidejs) {
          return window.guidejs = new guidejs(this, {}).add_to_queue(this, options);
        } else {
          return window.guidejs.add_to_queue(this, options);
        }
      });
    };
  })(jQuery);

  /*
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
  */


  /*
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
  */


}).call(this);