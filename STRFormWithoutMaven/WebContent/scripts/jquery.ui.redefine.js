/*
 * Redefines JQuery UI widgets to suit the needs of the application.
 */
(function($) {
    
    /*
     * This hack will destroy all but the last two entries in the log region.
     * Used by JAWS and Voiceover for accessibility.
     * 
     * To support assistive technologies (JAWS, Voiceover), JQueryUI uses a live
     * region to append the tooltips, so they may be used by the assistive device.
     * Unfortunately, JQueryUI does not remove previous entries made to the live 
     * region, causing a memory leak.
     * See: http://bugs.jqueryui.com/ticket/10689
     */
    $.widget("ui.tooltip", $.ui.tooltip, {
        _open: function(event, target, content) {
            this._super(event, target, content);
            //Fix live region
            var children = this.liveRegion.children();
            for (var ii=children.length-3;ii>=0;ii--) {
                children.eq(ii).remove();
            }
        }
    });
    
    /*
     * This hack turns off scroll of a draggable element, and forces 
     * containment to the "window" if that element is either
     * in a fixed position, or in a parent that is fixed.  Fixed elements are only
     * visible within the window, and should not be allowed to scroll with the document.
     */
    $.widget("ui.draggable", $.ui.draggable, {
        
        /**
         * Bluring the active element should occur if clicking a sub-element within the handle
         * 
         * !!!Bug
         */
	_blurActiveElement: function( event ) {
		var document = this.document[ 0 ];

		// Only need to blur if the event occurred on the draggable itself, see #10527
		if ( !this.handleElement.has( event.target ) ) {
			return;
		}

		// support: IE9
		// IE9 throws an "Unspecified error" accessing document.activeElement from an <iframe>
		try {

			// Support: IE9, IE10
			// If the <body> is blurred, IE will switch windows, see #9520
			if ( document.activeElement && document.activeElement.nodeName.toLowerCase() !== "body" ) {

				// Blur any element that currently has focus, see #4261
				$( document.activeElement ).blur();
			}
		} catch ( error ) {}
	},
        
	_mouseStart: function(event) {
            var isFixed = this.element.css("position")==="fixed";
            if (!isFixed) {
                isFixed = this.element.parents().filter(function() {
                    return $(this).css("position")==="fixed";
                }).length > 0;
            }
            this.origContainment = this.options.containment;
            this.origScroll = this.options.scroll;
            if (isFixed) {
                this.options.scroll = false;
                this.options.containment = "window";
            }
            this._super(event);
        },
        
        _mouseStop: function(event) {
            this._super(event);
            this.options.scroll = this.origScroll;
            this.options.containment = this.origContainment;
        }
        
    });
    
    /*
     * Augment the menu widget.
     */
    $.widget("ui.menu", $.ui.menu, {
        /**
         * Execute the "action" if the ENTER or SPACE key is pressed.
         * 
         * @param {type} event action event
         */
        _activate: function(event) {
            if (!this.active.is(".ui-state-disabled")) {
                if (!this.active.children("a[aria-haspopup='true']").length) {
                    this.active.find("a").first().click();
                }
            }
            this._super(event);
        },
        
        /*
         * Add a hide method to the menu object to collapse all submenus and hide the
         * menu itself.  The collapseAll method does not immediately collapse the submenus but does
         * a delay.  If the menu is then immediately hidden, the collapse will not occur
         * until the menu is redisplayed.  This looks strange on screen.  This method
         * does the collapse and hide immediately.
         */
        hide: function() {
            var currentMenu = this.element;
            this._close( currentMenu );
            this.blur();
            this.activeMenu = currentMenu;
            currentMenu.hide();
        }
    });

    /*
     * Augment the _create method of the tooltip object to prevent focusing on an
     * object showing its associated tooltip.  Only mouse over will show the tool tip.
     */
    $.widget("ui.tooltip", $.ui.tooltip, {
	_create: function() {
            this._super();
            this._off(this.element, "focusin");
	}
    });

    /*
     * Change the _resizeMenu method of the autocomplete object to set
     * the menu size.
     * 
     * Also, allow the option "allowParentClick".  This will be used to prevent
     * closing the menu if the parent element surrounding the menu is clicked.
     */
    $.widget( "ui.autocomplete", $.ui.autocomplete, {
        resize: function() {
            this._resizeMenu();
        },
        _resizeMenu: function() {
            resizeMenu(this.menu.element);
        },
        _suggest: function(items) {
            this._super(items);
            resizeMenu(this.menu.element);
        },
        _renderMenu: function(ul, items) {
            this._super(ul, items);
            resizeMenu(this.menu.element);
        },
        _create: function() {
            this._super();
            this._off(this.menu.element, "mousedown");
            this._on(this.menu.element, {
                mousedown: function( event ) {
                    // prevent moving focus out of the text field
                    event.preventDefault();

                    // IE doesn't prevent moving focus even with event.preventDefault()
                    // so we set a flag to know when we should ignore the blur event
                    this.cancelBlur = true;
                    this._delay(function() {
                        delete this.cancelBlur;
                    });

                    // clicking on the scrollbar causes focus to shift to the body
                    // but we can't detect a mouseup or a click immediately afterward
                    // so we have to track the next mousedown and close the menu if
                    // the user clicks somewhere outside of the autocomplete
                    var menuElement = this.menu.element[ 0 ];
                    var parentElement;
                    if (this.option.allowParentClick) {
                        parentElement = this.menu.element.parent()[ 0 ];
                    }
                    if ( !$( event.target ).closest( ".ui-menu-item" ).length ) {
                        this._delay(function() {
                            var that = this;
                            this.document.one( "mousedown", function( event ) {
                                if ( event.target !== that.element[ 0 ] &&
                                        event.target !== menuElement &&
                                        event.target !== parentElement &&
                                        !$.contains( menuElement, event.target ) &&
                                        !$.contains( parentElement, event.target ) 
                                    ) {
                                    that.close();
                                }
                            });
                        });
                    }
                }
            });
        }
    });
    
    /*
     * Change the _resizeMenu method of the selectmenu object to set
     * the menu size.
     */
    $.widget( "ui.selectmenu", $.ui.selectmenu, {
        resize: function() {
            this._resizeMenu();
        },
        _resizeMenu: function() {
            this._super();
            resizeMenu(this.menu);
        }
    });
    
    /*
     * UI dialog does not properly set the z-index of the overlay underneath modal
     * windows.  This fixes that.
     */
    $.widget( "ui.dialog", $.ui.dialog, {
        _moveToTop: function(event, silent) {
            this._super(event, silent);
            if ($.type(this.overlay)!=="undefined") {
                this.overlay.css("z-index", this.uiDialog.css("z-index")-1);
            }
        }
    });
    
    /*
     * Change the _resizeMenu method of the selectmenu object to set
     * the menu size.
     */
    /*
    $.widget( "ui.selectmenu", $.ui.selectmenu, {
        _create: function() {
            this.options.menuMaxHeight = "500px";
            this._super();
        }
    });
    */
    
    var resizeMenu = function(ul) {
        if (ul.is(":visible")) {
            var scrollTop = ul.scrollTop();
            
            //Set height of menu
            ul.css({
                "height": "",
                "max-height": "",
                "overflow-y": ""
            });
            var padding = ul.outerHeight()-ul.height();
            var height = ul.outerHeight();

            //Determine if menu is in a fixed window
            var fixed = ul.css("position")==="fixed";
            if (!fixed) {
                ul.parents().each(function(indx, elem) {
                    if ($(elem).css("position")==="fixed") {
                        fixed = true;
                        return false;
                    }
                });
            }

            if (fixed) {
                /*
                 * Get the available height for menu.  This depends on if the element is
                 * in a fixed location or not.
                 */
                var availableHeight = $(window).scrollTop() + $(window).height() - ul.offset().top;

                ul.css("height", Math.min(height-padding, availableHeight-padding) + "px");
                ul.css("overflow-y", height>availableHeight ? "scroll" : "");
            } else {
                ul.css("height", "auto");
                ul.css("overflow-y", height>ul.outerHeight() ? "scroll" : "");
            }
            height = ul.height();
            ul.css("max-height", "500px");
            if (height!==ul.height()) {
                ul.css("overflow-y", "scroll");
            }
            ul.scrollTop(scrollTop);
        }
    }
}(jQuery));
