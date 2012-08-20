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
        var _this = this;
        $('head').append(this.css);
        $('body').append(this.template);
        if (!window.guidejs) {
          window.guidejs = this;
        }
        this.conf = $.extend({}, {
          padding: 0,
          corner: 5
        }, options);
        this.$els = $('#guidejs-top, #guidejs-left, #guidejs-content, #guidejs-right, #guidejs-bottom');
        this.top = $('#guidejs-top');
        this.bottom = $('#guidejs-bottom');
        this.right = $('#guidejs-right');
        this.content = $('#guidejs-content');
        this.left = $('#guidejs-left');
        $(window).on('resize scroll', function() {
          return _this.render.apply(_this);
        });
      }

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
          top: this.target.top - this.conf.padding,
          left: this.target.left - this.conf.padding,
          width: this.target.w + this.conf.padding * 2,
          height: this.target.h + this.conf.padding * 2
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

      guidejs.prototype.add_to_queue = function(el, play) {
        if (play == null) {
          play = true;
        }
        if (!el) {
          return;
        }
        this.queue.push(el);
        if (play) {
          return this.play_next();
        }
      };

      guidejs.prototype.play_next = function() {
        var _this = this;
        setTimeout(function() {
          return _this.set_target(_this.queue.shift());
        }, 0);
        return this;
      };

      guidejs.prototype.show = function() {
        return this.els.clearQueue().show(0).fadeTo(1);
      };

      guidejs.prototype.hide = function() {
        return this.els.clearQueue().fadeTo(0).hide(0);
      };

      guidejs.prototype.playing = false;

      guidejs.prototype.queue = [];

      guidejs.prototype.target = {
        top: 0,
        left: 0,
        h: $(window).height(),
        w: $(window).width(),
        el: window
      };

      guidejs.prototype.defaults = {
        padding: 5,
        corner: 5,
        auto_play: false,
        timer: 2000,
        transition: 500
      };

      guidejs.prototype.template = "	<div id='guidejs-top' class='guidejs-row guidejs-shade'></div>					<div id='guidejs-left' class='guidejs-shade'></div>					<div id='guidejs-content'><div class='guidejs-border'></div></div>					<div id='guidejs-right' class='guidejs-shade'></div>					<div id='guidejs-bottom' class='guidejs-row guidejs-shade'></div>";

      guidejs.prototype.css = "<style>				#guidejs-top,				#guidejs-left,				#guidejs-content,				#guidejs-right,				#guidejs-bottom {					position: fixed;					top: 0px;					display: block;				}				.guidejs-row {					width:100%;				}				.guidejs-shade				{					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */				}				#guidejs #guidejs-middle {					font-size:0px;				}				/* inside border trick. this is removed for ie/opera */				#guidejs-content {					pointer-events: none; /* So that content inside has mouse events */					overflow:hidden;				}				#guidejs-content .guidejs-border {					display: block;					height: 100%;					width: 100%;					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);					border-radius: 5px;				}			</style>";

      return guidejs;

    })();
    return $.fn.guidejs = function(options) {
      return this.each(function() {
        if (!window.guidejs) {
          return window.guidejs = new guidejs(this, options).add_to_queue(this);
        } else {
          return window.guidejs.add_to_queue(this);
        }
      });
    };
  })(jQuery);

  $("#logo").guidejs({
    padding: 0,
    timer: 2000
  });

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
