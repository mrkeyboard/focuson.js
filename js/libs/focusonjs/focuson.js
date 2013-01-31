(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  (function($) {
    var focuson;
    focuson = (function() {
      function focuson(options) {
        var _base;
        if (options == null) {
          options = {};
        }
        this.hide = __bind(this.hide, this);
        $('head').append(this.css);
        $('body').append(this.$els);
        if (!window.focuson) {
          window.focuson = this;
        }
        this.conf = $.extend(this.defaults, options);
        (_base = this.conf).on_complete || (_base.on_complete = this.hide);
        this.$shades = $('#focuson-top, #focuson-left, #focuson-right, #focuson-bottom, #focuson-focus');
        this.focus = $('#focuson-focus');
        this.border = $('#focuson-focus .focuson-border');
        this.top = $('#focuson-top');
        this.bottom = $('#focuson-bottom');
        this.right = $('#focuson-right');
        this.left = $('#focuson-left');
        this.html = $('#focuson-html');
        this.$shades.not(this.focus).css({
          'background-color': 'rgba(' + this.conf.shade_color + ', ' + this.conf.shade_opacity + ')'
        });
        this.border.css({
          'box-shadow': '0px 0px 0px 15px rgba(' + this.conf.shade_color + ', ' + this.conf.shade_opacity + ')'
        });
      }
      focuson.prototype.set_target = function(el, animate) {
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
          step: __bind(function() {
            return this.render.apply(this);
          }, this)
        });
      };
      focuson.prototype.render = function() {
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
        this.focus.css(content);
        return this.right.css(right);
      };
      focuson.prototype.play_next = function() {
        var timeLeft, timeToRunTimer, _base;
        if (!this.el_conf.timer) {
          this.el_conf = this.queue.shift();
        }
        if (!this.el_conf) {
          this.el_conf = {};
          if (typeof (_base = this.conf).on_complete === "function") {
            _base.on_complete();
          }
          return this.stop();
        }
        this.remove_html();
        if (this.el_conf.html) {
          this.set_html(this.el_conf.html, this.el_conf.position);
        }
        this.html.on('click', '.focuson-next', __bind(function() {
          return this.play_next.apply(this);
        }, this));
        this.html.on('click', '.focuson-hide', __bind(function() {
          return this.hide.apply(this);
        }, this));
        window.startOfTimeout = new Date();
        $('body').css('overflow', this.el_conf.prevent_scroll ? 'hidden' : 'auto');
        this.border.css({
          'border-radius': this.el_conf.corner + 'px'
        });
        setTimeout((__bind(function() {
          return this.set_target(this.el_conf.el);
        }, this)), 1);
        if (window.elapsedTime != null) {
          timeLeft = this.el_conf.timer - window.elapsedTime;
          window.elapsedTime = null;
          timeToRunTimer = timeLeft;
        } else {
          timeToRunTimer = this.el_conf.timer;
        }
        if (this.el_conf.timer) {
          this.timer = setTimeout(__bind(function() {
            this.el_conf.timer = 0;
            return this.play_next();
          }, this), timeToRunTimer);
        }
        return this;
      };
      focuson.prototype.opposite = function(direction) {
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
      focuson.prototype.set_html = function(content, direction) {
        var wrapper_css;
        this.$shades.css('z-index', 999999);
        this.html.appendTo('#focuson-' + direction).parent().css('z-index', 1999999);
        this.html.css({
          top: 'auto',
          bottom: 'auto',
          left: 'auto',
          right: 'auto',
          width: 'auto'
        });
        wrapper_css = {};
        wrapper_css[this.opposite(direction)] = '0px';
        if (direction === 'top' || direction === 'bottom') {
          wrapper_css['text-align'] = 'center';
          wrapper_css['width'] = '100%';
        } else {
          wrapper_css['text-align'] = this.opposite(direction);
        }
        this.html.css(wrapper_css);
        return $('#focuson-html-inner', this.html).html(content);
      };
      focuson.prototype.remove_html = function(time) {
        var $old_html;
        if (time == null) {
          time = 100;
        }
        $old_html = $($('#focuson-html-inner', this.html).children());
        return $old_html.fadeTo(time, 0, function() {
          return $(this).remove();
        });
      };
      focuson.prototype.destroy = function() {
        this.stop();
        this.$shades.remove();
        return delete this;
      };
      focuson.prototype.add_to_queue = function(element, options) {
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
      focuson.prototype.show = function(play) {
        if (play == null) {
          play = false;
        }
        this.$shades.clearQueue().show(0).fadeTo(this.conf.fade_time, 1);
        return this;
      };
      focuson.prototype.hide = function() {
        this.$shades.clearQueue().fadeTo(this.conf.fade_time, 0, function() {
          return $(this).hide(0);
        });
        return this.stop();
      };
      focuson.prototype.play = function() {
        if (this.playing) {
          return;
        }
        $(window).on('resize scroll', this.render_this = (__bind(function() {
          return this.render.apply(this);
        }, this)));
        this.playing = true;
        this.play_next();
        return this;
      };
      focuson.prototype.stop = function() {
        if (!this.playing) {
          return;
        }
        window.elapsedTime = new Date() - window.startOfTimeout;
        clearInterval(this.timer);
        $(window).off('resize scroll', this.render_this);
        this.playing = false;
        return this;
      };
      focuson.prototype.playing = false;
      focuson.prototype.queue = [];
      focuson.prototype.timer = 0;
      focuson.prototype.target = {
        top: 0,
        left: 0,
        h: $(window).height(),
        w: $(window).width(),
        el: window
      };
      focuson.prototype.conf = {};
      focuson.prototype.defaults = {
        fade_time: 250,
        shade_opacity: '0.5',
        shade_color: '0, 0, 0',
        on_complete: false
      };
      focuson.prototype.el_conf = {};
      focuson.prototype.el_defaults = {
        padding: 5,
        corner: 5,
        timer: false,
        transition: 500,
        prevent_scroll: false,
        html: false,
        position: 'top'
      };
      focuson.prototype.$els = $("	<div id='focuson-top' class='focuson-row focuson-shade'></div>					<div id='focuson-left' class='focuson-shade'></div>					<div id='focuson-focus'><div class='focuson-border'></div></div>					<div id='focuson-right' class='focuson-shade'></div>					<div id='focuson-bottom' class='focuson-row focuson-shade'></div>					<div id='focuson-html'><div id='focuson-html-inner'>content</div></div>");
      focuson.prototype.css = "<style>				#focuson-top,				#focuson-left,				#focuson-focus,				#focuson-right,				#focuson-bottom {					position: fixed;					top: 0px;					display: block;					z-index: 999999;				}				#focuson-html {					position: absolute;					z-index: 1000000;					width: 100%;				}				#focuson-html-inner {					display: inline-block; /* so we can center it */					text-align:left;				}				.focuson-row {					width:100%;				}				.focuson-shade				{					background: rgba(0, 0, 0, .7); /* todo: support non-rgba */				}				/* inside border trick. this is removed for ie/opera */				#focuson-focus {					pointer-events: none; /* So that content inside has mouse events */					overflow:hidden;				}				#focuson-focus .focuson-border {					display: block;					height: 100%;					width: 100%;					box-shadow: 0px 0px 0px 15px rgba(0, 0, 0, .7);					border-radius: 5px;				}			</style>";
      return focuson;
    })();
    return $.fn.focusOn = function(options) {
      return this.each(function() {
        if (window.focuson) {
          return window.focuson.add_to_queue(this, options);
        } else {
          return window.focuson = new focuson(this, {}).add_to_queue(this, options);
        }
      });
    };
  })(jQuery);
}).call(this);
