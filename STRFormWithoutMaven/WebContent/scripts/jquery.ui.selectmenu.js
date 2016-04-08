/*
 * Provides alternative to native select elements.
 * 
 * Author: Kenneth Gendron
 */
(function($, undefined) {

    $.widget("ui.selectmenu", {
        version: "1.0",
        defaultElement: "<select>",
        
        options: {
            appendTo: null,
            position: {
                my: "left top",
                at: "left bottom",
                collision: "flip"
            },
            class: null,
            width: "auto",
            height: "auto",
            menuClass: null,
            menuHeight: "auto",
            menuMaxHeight: null,
            hide: null,
            show: null,
            popup: false,
            inline: false,
            // callbacks
            change: null,
            close: null,
            focus: null,
            open: null,
            select: null
        },
        requestIndex: 0,
        pending: 0,
        popupscroll: false,
        
        _create: function() {
            // Some browsers only repeat keydown events, not keypress events,
            // so we use the suppressKeyPress flag to determine if we've already
            // handled the keydown event. #7269
            // Unfortunately the code for & in keypress is the same as the up arrow,
            // so we use the suppressKeyPressRepeat flag to avoid handling keypress
            // events when we know the keydown event was used to modify the
            // search term. #7799
            var suppressKeyPress, suppressKeyPressRepeat, suppressInput;

            var that = this;

            this.isNewMenu = true;
            
            //Force popup option to false if inline is set to true
            if (this.options.popup===true && this.options.inline===true) {
                this.options.popup = false;
            }

            /*
             * Used to move past a disabled item when navigating the menu using the
             * keyboard.
             */
            this.lastDirection = "next";

            //Hide the select element
            this.element.hide();

            //Create wrapper that button and inline menu will appear in
            this.buttonwrapper = $("<div>")
                    .addClass("ui-selectmenu-wrapper")
                    .insertAfter(this.element);

            /*
             * Create the button.
             */
            //Checkbox that will maintain the state of the button
            this.buttoncheck = $("<input>")
                    .attr("type", "checkbox")
                    .addClass("ui-selectmenu")
                    .uniqueId()
                    .insertAfter(this.element);

            //Transfer attributes to checkbox
            var attr = this.element.attr("tabindex");
            if (typeof attr!=="undefined") {
                this.buttoncheck.attr("tabindex", attr);
            }
            attr = this.element.attr("autofocus");
            if (typeof attr!=="undefined") {
                this.buttoncheck.attr("autofocus", attr);
            }

            //Label of the button
            this.buttonlabel = $("<label>")
                    .attr("for", this.buttoncheck.attr("id"))
                    .appendTo(this.buttonwrapper);
            if (this.options.class!==null) {
                this.buttonlabel.addClass(this.options.class);
            }

            //Actual created button
            this.button = this.buttoncheck
                    .button({
                        icons: {secondary: "ui-icon-triangle-1-s"}
                    })
                    .data("ui-button");

            var buttonChildren = this.buttonlabel.addClass( "ui-selectmenu-button" ).children();

            //Get the button text
            this.buttontext = $("<div>").appendTo(buttonChildren.first());

            //Button icon
            this.buttonicon = buttonChildren.eq(1);

            //Create element to store the previous html in the button text
            this.buttonhidden = $("<span>")
                    .addClass("ui-selectmenu-hidden")
                    .insertAfter(this.buttonlabel);

            //Move checkbox to within the label to allow the button (i.e. widget) to be hidden properly
            this.buttoncheck.appendTo(this.buttonlabel);

            /*
             * Find all "<label>" elements associated with the select and 
             * redirect them to the checkbox.
             */
            this.elementlabels = this.element.closest("label");
            if (this.elementlabels.length!==0) {
                /*
                 * Move the select to outside the label.
                 * Create hidden element that will hold the original location of the element.
                 */
                this.elementplaceholder = $("<div>")
                        .css("display", "none")
                        .insertBefore(this.element);
                this.element.insertAfter(this.elementlabels);
            } else {
                var id = this.element.attr("id");
                if (typeof id!=="undefined") {
                    this.elementlabels = $("label[for='" + id + "']");
                    if (this.elementlabels.length!==0) {
                        this.elementlabels.attr("for", this.buttoncheck.attr("id"));
                    }
                }
            }

            /*
             * Add events to the button label, the outer container of the button.
             */
            this._on(this.buttonlabel, {
                /*
                 * When clicked, the focus leaves the checkbox, prevent
                 * this.
                 */
                mousedown: function(event) {
                    if (this.buttoncheck.is(":checked")) {
                        event.preventDefault();
                        this.cancelBlur = true;
                        this._delay(function() {
                            delete this.cancelBlur;
                        });
                    }
                }
            });

            this._on(this.buttoncheck, {
                change: function(event) {
                    if (this.buttoncheck.is(":checked")) {
                        this._open();
                    } else {
                        this.close();
                    }
                },
                focus: function(event) {
                    //When hidden button (i.e. inline) is focused, focus on the last active element if defined
                    if (this.inline && $.type(this.menu.active)!=="undefined") {
                        var active = this.menu.active;
                        if (active===null) {
                            active = this.menu.element.children("li.ui-menu-item:not(.ui-state-disabled)").first();
                            if (active.length!==0) {
                                this.menu.focus(null, active);
                            }
                        } else {
                            active.addClass("ui-state-focus").removeClass("ui-state-highlight");
                        }
                    }
                },
                keydown: function(event) {
                    if (this.element.prop("readOnly")) {
                        suppressKeyPress = true;
                        suppressInput = true;
                        suppressKeyPressRepeat = true;
                        return;
                    }

                    //Key-press event used to determine if select should change when item is focused (see menufocus event)
                    this.keypressevent = true;
                    suppressKeyPress = false;
                    suppressInput = false;
                    suppressKeyPressRepeat = false;
                    var keyCode = $.ui.keyCode;
                    switch (event.keyCode) {
                        case keyCode.HOME:
                            suppressKeyPress = true;
                            this._move("first", event);
                            break;
                        case keyCode.END:
                            suppressKeyPress = true;
                            this._move("last", event);
                            break;
                        case keyCode.PAGE_UP:
                            suppressKeyPress = true;
                            this._move("previousPage", event);
                            break;
                        case keyCode.PAGE_DOWN:
                            suppressKeyPress = true;
                            this._move("nextPage", event);
                            break;
                        case keyCode.UP:
                            if (event.altKey) {
                                this._openClose(false, event);
                                break;
                            }
                        case keyCode.LEFT:
                            suppressKeyPress = true;
                            this._keyEvent("prev", event);
                            break;
                        case keyCode.DOWN:
                            if (event.altKey) {
                                this._openClose(true, event);
                                break;
                            }
                        case keyCode.RIGHT:
                            suppressKeyPress = true;
                            this._keyEvent("next", event);
                            break;
                        case keyCode.ENTER:
                        case keyCode.NUMPAD_ENTER:
                            event.preventDefault();
                            // when menu is open and has focus
                            if (this.menu.active) {
                                // #6055 - Opera still allows the keypress to occur
                                // which causes forms to submit
                                suppressKeyPress = true;
                                event.preventDefault();
                                this.menu.select(event);
                            } else {
                                //If menu is not active toggle the checkbox
                                this.buttoncheck[0].checked = !this.buttoncheck[0].checked;
                                this.button.refresh();
                                if (this.buttoncheck[0].checked) {
                                    this._open();
                                }
                            }
                            break;
                        case keyCode.TAB:
                            break;
                        case keyCode.ESCAPE:
                            if (this.menuwrapperVisible) {
                                this.close(event);
                                // Different browsers have different default behavior for escape
                                // Single press can mean undo or clear
                                // Double press in IE means clear the whole form
                                event.preventDefault();
                            }
                            break;
                        default:
                            //Delegate key stroke to the menu
                            this.menu._keydown(event);
                            suppressKeyPressRepeat = true;
                            break;
                    }
                    delete this.keypressevent;
                },
                keypress: function(event) {
                    if (suppressKeyPress) {
                        suppressKeyPress = false;
                        if (this.menuwrapperVisible) {
                            event.preventDefault();
                        }
                        return;
                    }
                    if (suppressKeyPressRepeat) {
                        return;
                    }

                    //Key-press event used to determine if select should change when item is focused (see menufocus event)
                    this.keypressevent = true;

                    // replicate some key handlers to allow them to repeat in Firefox and Opera
                    var keyCode = $.ui.keyCode;
                    switch (event.keyCode) {
                        case keyCode.HOME:
                            this._move("first", event);
                            break;
                        case keyCode.END:
                            this._move("last", event);
                            break;
                        case keyCode.PAGE_UP:
                            this._move("previousPage", event);
                            break;
                        case keyCode.PAGE_DOWN:
                            this._move("nextPage", event);
                            break;
                        case keyCode.UP:
                            if (event.altKey) {
                                this._openClose(false, event);
                                break;
                            }
                        case keyCode.LEFT:
                            this._keyEvent("prev", event);
                            break;
                        case keyCode.DOWN:
                            if (event.altKey) {
                                this._openClose(true, event);
                                break;
                            }
                        case keyCode.RIGHT:
                            this._keyEvent("next", event);
                            break;
                    }

                    delete this.keypressevent;
                },
                blur: function(event) {
                    if (this.cancelBlur) {
                        delete this.cancelBlur;
                        return;
                    }
                    this.close(event);
                    
                    //If inline, remove focus from previously focused option, and re-highlight it if it was selected
                    if (this.inline) {
                        if (this.previousFocusedItem!==null) {
                            try {
                                var a = this.previousFocusedItem;
                                a.removeClass("ui-state-focus");
                                if (this.previousFocusedItem.data("ui-selectmenu-item").selected) {
                                    a.addClass("ui-state-highlight");
                                }
                            } catch (e) {
                            }
                        }
                    }
                }
            });

            /**
             * Create the select menu.
             */
            this.menu = $("<ul>")
                    .appendTo(this._appendTo())
                    .menu({
                        // disable ARIA support, the live region takes care of that
                        role: null
                    });
            if (this.options.menuClass!==null) {
                this.menu.addClass(this.options.menuClass);
            }
            this.menu = this.menu
                    .data("ui-menu");
            this.menu.element.attr("tabindex", -1).addClass("ui-corner-all");

            /*
             * Replace the collapseAll method of the menu to prevent its functioning.
             * We do not want selected items to be blurred.
             */
            this.menu.collapseAll = function() {};

            /*
             * Items that were selected from menu.
             */
            this.selectedMenuItems = [];

            /*
             * Create a wrapper around the menu.  This is what will be positioned.
             */
            this.menuwrapper = $("<div>")
                    .addClass("ui-selectmenu-menu ui-front")
                    .append(this.menu.element)
                    .append($("<div>")
                        .addClass("ui-selectmenu-header"))
                    .append($("<div>")
                        .addClass("ui-selectmenu-footer"))
                    .appendTo(this._appendTo())
                    .hide();
            this.menuwrapperVisible = false; //Store visibility of menu externally.  The is(":visible") call is time consuming.
            this.inline = false; //This indicates if the selectmenu is currently in "inline" mode

            /*
             * Create hidden element to store the menu content.  Used for
             * determining the optimal width of the button.
             */
            //For single selection
            var hidden = $("<ul>")
                    .append($("<li>")
                        .append("a")) //Must add something otherwise the item is generated without the ui-menu-item class
                    .menu()
                    .data("ui-menu");
            hidden.element.attr("tabindex", -1);
            this.menuhiddensingle = $("<span>")
                    .addClass("ui-selectmenu-hidden")
                    .append(hidden.element)
                    .appendTo(this._appendTo());
            this.menuhiddensingleli = this.menuhiddensingle.find("li");

            //Change the button icon if needed
            this._changeButtonIcon();

            /*
             * Add listeners for menu wrapper to show/hide the popup scroll when hovering, and
             * to blur the "hidden" button when leaving an inline selectmenu.
             */
            this._on(this.menuwrapper, {
                mouseenter: function() {
                    this._popupShowScroll(true);
                },
                mouseleave: function() {
                    this._popupShowScroll(false);
                    if (this.inline) {
                        this.buttoncheck.blur();
                    }
                }
            });

            this.previousFocusedItem = null;

            this._on(this.menu.element, {

                mousedown: function(event) {
                    // prevent moving focus out of the text field
                    event.preventDefault();

                    // IE doesn't prevent moving focus even with event.preventDefault()
                    // so we set a flag to know when we should ignore the blur event
                    this.cancelBlur = true;
                    this._delay(function() {
                        delete this.cancelBlur;
                    });

                    /* 
                     * Clicking on the scrollbar causes focus to shift to the body
                     * but we can't detect a mouseup or a click immediately afterward
                     * so we have to track the next mouseup and close the menu if
                     * the user clicks somewhere outside of the selectmenu.
                     * This must be a mouseup instead of a mousedown due to the interaction
                     * with the checkbox.  The mousedown would cause the dialog to close
                     * but the subsequent mouseup will recheck the checkbox causing
                     * it to open again.
                     */
                    var menuElement = this.menu.element[ 0 ];
                    if (!$(event.target).closest(".ui-menu-item").length) {
                        this._delay(function() {
                            var that = this;
                            this.document.one("mouseup", function(event) {
                                if (event.target !== that.element[ 0 ] &&
                                        event.target !== menuElement &&
                                        !$.contains(menuElement, event.target)) {
                                    that.close();
                                }
                            });
                        });
                    }
                },
                menufocus: function(event, ui) {
                    // support: Firefox
                    // Prevent accidental activation of menu items in Firefox (#7024 #9118)
                    if (this.isNewMenu) {
                        this.isNewMenu = false;
                        if (event.originalEvent && /^mouse/.test(event.originalEvent.type)) {
                            this.menu.blur();

                            this.document.one("mousemove", function() {
                                $(event.target).trigger(event.originalEvent);
                            });

                            return;
                        }
                    }

                    //If inline, make sure button is focused when menu is focused
                    if (this.inline) {
                        if (!this.buttoncheck.is(":focus")) {
                            this.buttoncheck.focus();
                        }
                    }
                    var option = ui.item.data("ui-selectmenu-item");

                    /*
                     * If the focused item is disabled, and menu is already visible, 
                     * move to the next item.
                     */
                    var menuopening = this.menuopening;
                    delete this.menuopening;
                    if (menuopening) {
                        this.lastDirection = "next";
                    }
                    if (ui.item.hasClass("ui-state-disabled")) {
                        if (menuopening && !this.menu.isFirstItem()) {
                            this.menu.focus(null, this.menu.element.find( ".ui-menu-item:first" ) );
                        } else {
                            this._move(this.lastDirection, event, true);
                        }
                    } else {
                        delete this.directionFlipped;

                        if (this.options.popup===true) {
                            this._menuMove();
                        }

                        //If single selection, select the focused item
                        if (!this.multiple) {
                            if (this.keypressevent) {
                                this._select(option, true, event, ui.item);
                            }
                        } else if (event.shiftKey && event.which!==0) {
                            this._select(option, false, event, ui.item);
                        }

                        /*
                         * Fix the focused item by removing the ui-state-highlight class if applicable
                         */
                        if (that.previousFocusedItem!==null) {
                            try {
                                if (that.previousFocusedItem.data("ui-selectmenu-item").selected) {
                                    that.previousFocusedItem.addClass("ui-state-highlight");
                                }
                            } catch (e) {
                            }
                        }
                        ui.item.removeClass("ui-state-highlight");
                        that.previousFocusedItem = ui.item;

                        if (false === this._trigger("focus", event, {item: option})) {
                            this.liveRegion.html(option.label);
                        }
                    }
                },
                menuselect: function(event, ui) {
                    var option = ui.item.data("ui-selectmenu-item");
                    if (false !== this._trigger("select", event, {item: option})) {
                        this._select(option, false, event, ui.item);
                    }
                }
            });

            this.liveRegion = $("<span>", {
                role: "status",
                "aria-live": "polite"
            })
                    .addClass("ui-helper-hidden-accessible")
                    .insertBefore(this.element);

            this.refresh();
        },
        _destroy: function() {
            //Remove the button
            this.button.destroy();
            this.buttoncheck.remove();
            this.buttonlabel.remove();
            this.buttonhidden.remove();

            //Remove the menu
            this.menu.destroy();
            this.menu.element.remove();
            this.menuhiddensingle.remove();
            this.menuwrapper.remove();
            this.liveRegion.remove();
            
            this.buttonwrapper.remove();

            //Restore any "<label>"s pointing to the select
            if (this.elementlabels.length!==0) {
                if (typeof this.elementplaceholder!=="undefined") {
                    //Move element back
                    this.element.insertAfter(this.elementplaceholder);
                    this.elementplaceholder.remove();
                } else {
                    //Restor the "for" attributes
                    this.elementlabels.attr("for", this.element.attr("id"));
                }
            }

            //Show the select
            this.element.show();
        },
        
        _setOption: function(key, value) {
            this._super(key, value);
        },
        
        _setOptions: function(options) {
            var that = this,
                    refresh = false,
                    resize = false,
                    close = false;

            //Determine if button and menu should be resized
            $.each( options, function( key, value ) {
                if ( key === "inline" ) {
                    refresh = that.options.inline!==value;
                    close = !value;
                } else if ( key === "height" || key === "width" ||
                        key === "menuHeight" || key === "menuMaxHeight" ||
                        key === "position" || key === "popup" ) {
                    resize = true;
                } else if ( key === "appendTo" ) {
                    that.menuwrapper.appendTo(that._appendTo());
                    resize = true;
                } else if ( key === "position" ) {
                    resize = true;
                } else if ( key === "class" ) {
                    if (value==="" && this.options.class) {
                        this.buttonlabel.removeClass(this.options.class);
                    } else {
                        this.buttonlabel.addClass(this.options.class);
                    }
                } else if ( key === "menuClass" ) {
                    if (value==="" && this.options.menuClass) {
                        this.menu.removeClass(this.options.menuClass);
                    } else {
                        this.menu.addClass(this.options.menuClass);
                    }
                }
                that._setOption( key, value );
            });
            
            //Force popup option to false if inline is set to true
            if (this.options.popup===true && this.options.inline===true) {
                this.options.popup = false;
            }

            if ( refresh ) {
                this.refresh();
            } else if ( resize ) {
                this._buttonResize();
                this._changeButtonIcon();
            }
            
            if (close) {
                this.close(undefined, true);
            }
        },
        
        _appendTo: function() {
            var element = this.options.appendTo;

            if (element) {
                element = element.jquery || element.nodeType ?
                        $(element) :
                        this.document.find(element).eq(0);
            }

            if (!element) {
                element = this.element.closest(".ui-front");
            }

            if (!element.length) {
                element = this.document[0].body;
            }

            return element;
        },
        _selectItem: function(li, selected) {
            var icon = li.find(".ui-icon").first();
            if (selected) {
                icon.removeClass("ui-selectmenu-nocheck")
                        .addClass("ui-icon-check");
                if (!li.hasClass("ui-state-focus")) {
                    li.addClass("ui-state-highlight");
                }
            } else {
                icon.removeClass("ui-icon-check")
                        .addClass("ui-selectmenu-nocheck");
                li.removeClass("ui-state-highlight");
            }
        },
        _select: function(option, doNotClose, event, li) {
            var changed = true;
            if (this.multiple) {
                option.selected = !option.selected;
            } else {
                if (option.selected) {
                    changed = false;
                }
                option.selected = true;
            }

            if (this.menuCreated) {
                var children = null;
                if ($.type(li)==="undefined") {
                    //Find the menu object if not provided
                    children = this.menu.element.children("li");
                    $.each(children, function(indx, elem) {
                        elem = $(elem);
                        if (elem.data("ui-selectmenu-item")===option) {
                            li = elem;
                            return false;
                        }
                    });
                }
                if (this.multiple) {
                    if (!option.selected) {
                        for (var ii=0;ii<this.selectedMenuItems.length;ii++) {
                            if (this.selectedMenuItems[ii].data("ui-selectmenu-item")===option) {
                                this.selectedMenuItems.splice(ii, 1);
                                break;
                            }
                        }
                    } else {
                        this.selectedMenuItems[this.selectedMenuItems.length] = li;
                    }
                    //Handle shift key (i.e. selecting a group of items)
                    if (this.previousSelectedItem===null || !event.shiftKey) {
                        this.previousSelectedItem = li;
                        this.previousSelectedSelected = option.selected;
                        this.previousSelectedItems = null;
                    } else if (this.previousSelectedItem!==null && event.shiftKey) {
                        if (children===null) {
                            children = this.menu.element.children("li");
                        }
                        //Toggle all previous items
                        if (this.previousSelectedItems!==null && this.previousSelectedSelected) {
                            this._multiSelect(children, !this.previousSelectedSelected, this.previousSelectedItems[0], this.previousSelectedItems[1]);
                        }
                        //Determine which elements to toggle
                        var arr = [children.index(this.previousSelectedItem), children.index(li)].sort(function(a,b){return a-b;});
                        this.previousSelectedItems = arr;
                        this._multiSelect(children, this.previousSelectedSelected, arr[0], arr[1]);
                    }
                } else {
                    this._selectItem(this.selectedMenuItems[0], false);
                    this.selectedMenuItems[0] = li;
                }
                this._selectItem(li, option.selected);
            }

            this._update();

            if (changed) {
                this.element.trigger("change");
            }

            if (!this.multiple && !doNotClose) {
                this.close();
            }
        },
        _multiSelect: function(siblings, selected, start, end) {
            var changed = false;
            for (var ii=start;ii<=end;ii++) {
                var liSibling = siblings.eq(ii);
                var optSibling = liSibling.data("ui-selectmenu-item");
                if ($.type(optSibling)!=="undefined") {
                    if (optSibling.selected!==selected && !liSibling.hasClass("ui-state-disabled")) {
                        optSibling.selected = selected;
                        this._selectItem(liSibling, selected);
                        if (selected) {
                            this.selectedMenuItems[this.selectedMenuItems.length] = liSibling;
                        } else {
                            for (var jj=0;jj<this.selectedMenuItems.length;jj++) {
                                if (this.selectedMenuItems[jj].data("ui-selectmenu-item")===optSibling) {
                                    this.selectedMenuItems.splice(jj, 1);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            return changed;
        },
        _close: function(event) {
            this.buttoncheck[0].checked=false;
            this.button.refresh();

            this.menuwrapper.hide(this.options.hide!==null ? this.options.hide : false);
            this.menuwrapperVisible = false;
            this.menu.blur();
            this.isNewMenu = true;
            this._trigger("close", event);
        },
        close: function(event, nodelay) {
            this.cancelSearch = true;
            if (this.menuwrapperVisible) {
                //Only close the menu if not an inline menu
                if (!this.inline) {
                    /*
                     * Delay the closing of the menu unless instructed otherwise.
                     * This is necessary when the user uses the scrollbar, then 
                     * clicks on the button instead of the menu or somewhere else.
                     */
                    if (nodelay) {
                        this._close(event);
                    } else {
                        this._delay(function() {
                            this._close(event);
                        });
                    }
                }
            }
            if (this.options.popup!==true) {
                this.buttonicon
                        .removeClass( "ui-icon-triangle-1-n" )
                        .addClass( "ui-icon-triangle-1-s" );
            }
        },
        
        _changeButtonIcon: function() {
            //Change button icon if needed
            var visible = this.menuwrapperVisible;
            this.buttonicon.removeClass("ui-icon-triangle-1-s ui-icon-triangle-1-n ui-icon-triangle-2-n-s")
                    .addClass(this.options.popup===true ? "ui-icon-triangle-2-n-s" : visible ? "ui-icon-triangle-1-n" : "ui-icon-triangle-1-s");
        },
        
        _update: function(updateMenu) {
            var selected = this.element.find( "option:selected" );
            var multiple = this.multiple;

            //Determine button height
            this.buttontextheight = this.buttontext.height();
            var html = this.buttonhidden.html(function() {
                if ( selected.length === 0 ) {
                    return multiple ? "Select Options" : "";
                } else if ( multiple ) {
                    return selected.length + " Option" + (selected.length===1 ? "" : "s") + " Selected";
                } else {
                    return selected[0].label;
                }
            }).html();

            //Change button html if needed
            if (this.buttontext.html()!==html) {
                this._updateButton(this.buttontext, html);
                this._updateResize();
            }
        },
        _updateButton: function(ui, html) {
            ui.html(html);
			return ui;
        },
        _updateResize: function() {
            if (this.buttontext.height()!==this.buttontextheight) {
                this.buttontextheight = this.buttontext.height();
                this.reposition();
            }
        },
        
        refresh: function() {
            this.multiple = typeof this.element.attr("multiple") !== "undefined";

            //Transfer tabindex to checkbox
            var attr = this.element.attr("tabindex");
            if (typeof attr==="undefined") {
                this.buttoncheck.removeAttr("tabindex");
            } else {
                this.buttoncheck.attr("tabindex", attr);
            }

            //Transfer autofocus to checkbox
            attr = this.element.attr("autofocus");
            if (typeof attr==="undefined") {
                this.buttoncheck.removeAttr("autofocus");
            } else {
                this.buttoncheck.attr("autofocus", attr);
            }

            var v = this._organizeOptions(this.element.children( "option,optgroup" ));
            this.hierarchy = v.optionGroups;
            var allOptions = v.allOptions;

            this.selectedMenuItems = []; //Clear those menu items that have been selected

            //Create menu
            this.menuCreated = this.menuwrapperVisible || this.options.inline===true; //Force creation of menu if inline menu
            if (this.menuCreated) {
                this._createMenu(true);
            }
            
            //Reset previously focused item after menu is created
            this.previousFocusedItem = null;
            
            //Reset previously selected item after menu is created
            this.previousSelectedItem = null;

            //Move menu if changing from inline to non-inline, or vice-versa
            if (this.options.inline===true && !this.inline) {
                this.menuwrapper.appendTo(this.buttonwrapper).addClass("ui-selectmenu-inline").removeClass("ui-front").css({
                    position: "",
                    top: "",
                    left: "",
                    display:""
                });
                this.inline = true;
                this.buttonlabel.addClass("ui-selectmenu-hidden");
                this._open();
            } else if (this.options.inline!==true && this.inline) {
                this.menuwrapper.appendTo(this._appendTo()).removeClass("ui-selectmenu-inline").addClass("ui-front");
                this.inline = false;
                this.buttonlabel.removeClass("ui-selectmenu-hidden");
                this.close();
            }
            
            //Set the hidden menu inner HTML directly as the markup is clean and .html() is time-consuming
            if (this.multiple) {
                this.menuhiddensingleli[0].innerHTML = "XXX Options Selected";
            } else {
                var label = new Array(allOptions.length);
                var that = this;
                allOptions.each(function(i, e) {
                    label[i] = "<br>" + $("<div>").append(that._updateButton($("<span>"), e.label)).html();
                });
                this.menuhiddensingleli[0].innerHTML = label.join("");
            }

            //If select has no options, or all options are disabled, prevent moving within menu
            if (allOptions.length===0 || 
                    allOptions.length === allOptions.filter(":disabled").length) {
                this.cannotmove = true;
            } else {
                delete this.cannotmove;
            }

            //Update button and menu
            this._update();

            //Enable/disable the button
            if (typeof this.element.attr("disabled")==="undefined") {
                this.button.enable();
                this.menu.enable();
            } else {
                this.button.disable();
                this.menu.disable();
            }

            this.calculateAndResizeButton = true;
            var images = this.menuhiddensingleli.find("img");
            if (images.length!==0) {
                //Attach event handler to images
                this._on(images, {
                    "load": this._calculateAndResizeButton,
                    "error": this._calculateAndResizeButton
                });
            }
            this._delay(function() {
                this._calculateAndResizeButton();
            });
            
        },
        _calculateAndResizeButton: function() {
            //Multiple refreshes may occur prior to this method executing, make sure method does not execute more than once
            if (this.calculateAndResizeButton) {
                this.optimalButtonSize = Math.ceil(this.menuhiddensingleli.width())+1;
                //this.menuhiddensingleli.empty(); //Remove contents of hidden menu
                this._buttonResize();
                this.calculateAndResizeButton = false;
            }
        },
        _buttonResize: function() {
            this.buttontext.css({
                width: this.options.width==="auto" ? 
                        this.optimalButtonSize : 
                        this.options.width,
                height: this.options.height==="auto" ? "" : this.options.height
            });

            /*
             * Resize the menu as well as the button size change may have changed
             * where the menu must be positioned and/or its size.
             */
            this.reposition();
        },
        
        _createMenu: function() {
            //Create the menu of options
            var ul = this.menu.element.empty();

            if (this.multiple) {
                ul.removeClass( "ui-selectmenu-single" );
            } else {
                ul.addClass( "ui-selectmenu-single" );
            }
            this._renderMenu(ul, this.hierarchy, 0, this.selectedMenuItems);

            this.isNewMenu = true;
            this.menu.refresh();

            for (var ii=0;ii<this.selectedMenuItems.length;ii++) {
                this._selectItem(this.selectedMenuItems[ii], true);
            }

            /*
             * Add a header and footer to the menu. These will be used by the
             * popup menu to add padding to the top and bottom.
             */
            ul.prepend($("<li>").addClass("ui-state-disabled")).append($("<li>").addClass("ui-state-disabled"));

            this.menuCreated = true;
        },
        
        _openClose: function(open, event) {
            var ul = this.menuwrapper;
            var visible = ul.is(":visible");
            if (!visible && open) {
                event.preventDefault();
                this._open();
            } else if (visible && !open) {
                event.preventDefault();
                this.close();
            }
        },
        _open: function() {
            if (!this.menuwrapperVisible) {
                //Reset the cannot move flag
                delete this.cannotmove;

                this.buttoncheck.prop("checked", true);
                this.button.refresh();

                //Create the menu
                if (!this.menuCreated) {
                    this._createMenu();
                }

                //Size and position menu
                if (this.options.show!==null && !this.inline) { //Inline menus must simply be shown
                    /*
                     * If custom show effect, hide the menu during positioning,
                     * then reshow it.
                     */
                    this.menuwrapper.css("visibility", "hidden");
                    this.menuwrapper.show();
                    this.menuwrapperVisible = true;
                    this.reposition();
                    this.menuwrapper.hide();
                    this.menuwrapper.css("visibility", "");
                    this.menuwrapper.show(this.options.show);
                } else {
                    this.menuwrapper.show();
                    this.menuwrapperVisible = true;
                    this.reposition();
                }

                this._update();

                this.menuopening = true;
                var checked = this.menuwrapper.find(".ui-icon-check");
                if (checked.length!==0) {
                    var closest = checked.first().closest("li");
                    this.menu.focus(null, closest);
                } else {
                    this.menu.next();
                }
                
                //If inline, pseudo-blur the active item
                if (this.inline && this.menu.active) {
                    this.menu.active.removeClass("ui-state-focus");
                    //Add the highlight class back
                    if (checked.length!==0) {
                        this.menu.active.addClass("ui-state-highlight");
                    }
                }

                this._menuMove();

                //Change button icon
                if (this.options.popup!==true) {
                    if (!this.menu.element.hasClass("ui-menu-above")) {
                        this.buttonicon
                                .removeClass( "ui-icon-triangle-1-s" )
                                .addClass( "ui-icon-triangle-1-n" );
                    }
                }
                
                this._trigger("open");
            }
        },
        
        reposition: function() {
            if (this.menuwrapperVisible) {
                //Reposition menu
                var position = $.extend({
                        of: this.button.widget()
                    }, this.options.position!==null ? 
                            this.options.position : 
                            {
                                my: "left top",
                                at: "left bottom",
                                collision: "flip"
                            });
                //Do not position inline menus
                if (!this.inline && this.options.popup!==true) {
                    this.menu.element.css("height", "");
                    this.menuwrapper.position(position);
                }

                this._resizeMenu();

                this.menu.element.removeClass("ui-menu-above");
                if (this.options.popup!==true) {
                    if (!this.inline) {
                        //Reposition menu if not a popup and position is not "left top", "left bottom".
                        //This is necessary because the resizing assumes left top, left bottom positioning
                        if (position.my!=="left top" || position.at!=="left bottom" || position.collision!=="none") {
                            position = $.extend({
                                of: this.button.widget()
                            }, this.options.position!==null ? 
                                    this.options.position : 
                                    {
                                        my: "left top",
                                        at: "left bottom",
                                        collision: "flip"
                                    });
                            this.menuwrapper.position(position);
                        }
                        if ((this.buttonlabel.offset().top-this.menu.element.offset().top)>0) {
                            this.menu.element.addClass("ui-menu-above");
                        }
                    }
                } else {
                    //If popup, position it now.
                    if (!this.inline) {
                        //Determine if LTR or RTL by looking at the button icon
                        var ltr = this.buttonicon.offset().left-this.buttontext.offset().left>0;
                        var p = parseFloat(this.buttontext.parent().css("padding-" + (ltr ? "left" : "right")));

                        /*
                         * Position menu twice to get the offset difference when the
                         * menu collides with the window frame. 
                         */
                        this.menuwrapper.position({
                            of: this.buttontext,
                            my: ltr ? "right center" : "left center",
                            at: ltr ? "right+" + p + " center" : "left-" + p + " center",
                            collision: ""
                        });
                    }

                    //Record any collision with the window frame and adjust
                    var diff = 0;
                    var top = this.menuwrapper.offset().top;
                    if (top<0) {
                        this.menuwrapper.css("top", "0px");
                        diff = -top;
                    }

                    //Adjust the top and bottom padding if the menu collided with the window frame
                    var lis = this.menu.element.children("li");
                    var topPad = lis.first();
                    var bottomPad = lis.last();
                    if (diff!==0) {
                        topPad.height(topPad.height()-diff);
                        bottomPad.height(bottomPad.height()+diff);
                    }

                    //Hide or show the shadows at the top/bottom of the menu
                    var shadows = this.menuwrapper.children("div");
                    if (topPad.height()<=topPad.next().height()) {
                        shadows.first().hide();
                    } else {
                        shadows.first().show();
                    }
                    if (bottomPad.height()<=bottomPad.prev().height()) {
                        shadows.last().hide();
                    } else {
                        shadows.last().show();
                    }
                }
            }
        },
        
        _menuMove: function() {
            if (!this.nopopupmove) {
                var ul = this.menu.element;
                var active = this.menu.active;
                //Determine if there is an offset between the header and footer of the menu
                var offset = ul.children("li").last().height()-ul.children("li").first().height();
                ul.scrollTop(ul.scrollTop()+active.position().top-(ul.outerHeight()-active.outerHeight(true)-offset)/2+1);
            }
        },
        _popupShowScroll: function(show) {
            this.popupscroll = show;
            if (this.options.popup===true) {
                this.nopopupmove = show;
                this.menu.element.css("overflow-y", show ? "scroll" : "");
            }
        },
        
        resize: function() {
            this._resizeMenu();
        },
        
        _resizeMenu: function() {
            if (this.menuwrapperVisible) {
                //Store where the scrollbar is at the moment
                var scrollTop = this.menuwrapper.scrollTop();

                var ul = this.menu.element;

                var lis = ul.children("li");
                lis.first().hide();
                lis.last().hide();

                //Get bottom offset before resizing
                var bottom = ul.offset().top + ul.outerHeight();

                /*
                 * Reset height of menu
                 * 
                 * There is a bizarre bug in Chrome where if the menu currently
                 * has an overflow value (i.e. the menu is larger than the viewport),
                 * and the overflow is removed while removing the hieght value, the
                 * menu will be rendered larger than the content.  Simply make the 
                 * overflow visible, then remove the overflow value after calculating the height.
                 */
                ul.css({
                    "height": "",
                    "max-height": "",
                    "overflow-y": "visible"
                });
                var padding = ul.outerHeight()-ul.height();
                var height = ul.outerHeight();
                var popupHeight = ul.height();
                var calculateHeight = false;
                ul.css("overflow-y", "");

                //Calculate optimal height of menu if height is set to "auto".  Note: Inline menus will not have height calculated
                if (this.options.menuHeight==="auto" && !this.inline) { 
                    //Determine if menu is in a fixed window
                    calculateHeight = this.menuwrapper.css("position")==="fixed";
                    if (!calculateHeight) {
                        this.menuwrapper.parents().each(function(i, elem) {
                            if ($(elem).css("position")==="fixed") {
                                calculateHeight = true;
                                return false;
                            }
                        });
                    }
                }
                
                if (calculateHeight) {
                    /*
                     * Get the available height for menu.  This depends on if the element is
                     * in a fixed location or not.
                     */
                    var availableHeight;
                    if (this.options.popup===true) {
                        availableHeight = $(window).height();
                    } else {
                        //Is the menu above or below the button
                        var above = (this.buttonlabel.offset().top-ul.offset().top)>0;
                        if (above) {
                            availableHeight = bottom - $(window).scrollTop();
                        } else {
                            availableHeight = $(window).scrollTop() + $(window).height() - ul.offset().top;
                        }
                    }

                    ul.css("height", Math.min(height-padding, availableHeight-padding) + "px");
                } else {
                    ul.css("height", this.options.menuHeight);
                }
                if (this.options.menuMaxHeight!==null) {
                    ul.css("max-height", this.options.menuMaxHeight);
                }
                if (this.options.popup!==true && ul[0].scrollHeight>ul.innerHeight()) {
                    ul.css("overflow-y", "scroll");
                }

                /*
                 * If this is a popup, hide the overflow and resize the top
                 * and bottom padding.
                 */
                if (this.options.popup===true) {
                    var width = this.optimalButtonSize;
                    this.menuwrapper.css({
                        "overflow-y": "hidden",
                        "min-width": width + "px" //Minimum width must be the width of the button text
                    }).addClass("ui-selectmenu-popup ui-corner-all");
                    var topPad = lis.first();
                    var topElem = topPad.next();
                    var bottomPad = lis.last();
                    var bottomElem = bottomPad.prev();

                    //Set the height of the menu wrapper
                    this.menuwrapper.height(ul.outerHeight(true));

                    //Arbitrarily set the height of the menu to its calculated height
                    ul.height(ul.height());

                    //Set height of menu padding
                    topPad.height(popupHeight/2 - topElem.outerHeight(true)/2 + 1).show();
                    bottomPad.height(popupHeight/2 - bottomElem.outerHeight(true)/2 + 1).show();

                    //Reshow the scroll for the popup if necessary
                    this._popupShowScroll(this.popupscroll);
                } else {
                    this.menuwrapper.removeClass("ui-selectmenu-popup ui-corner-all")
                            .css({
                                "overflow-y": "",
                                "height": "",
                                "min-width": (this.inline ? "" : this.buttonlabel.outerWidth() + "px") //Minimum width must be the width of the button unless its an inline menu
                            });
                    ul.css("top", "");
                    
                    //Determine where the menu is in relation to the button, and adjust location if it has shifted
                    var menuOffset = this.menuwrapper.offset();
                    var menuToButtonHeight = this.buttonlabel.offset().top-menuOffset.top;
                    if (menuToButtonHeight>0) {
                        menuToButtonHeight -= this.menuwrapper.outerHeight(true);
                        menuOffset.top = menuOffset.top + menuToButtonHeight;
                        this.menuwrapper.offset(menuOffset);
                    }
                }

                //Return scroll location to where it was
                this.menuwrapper.scrollTop(scrollTop);
            }
        },
        
        _organizeOptions: function(items) {
            var that = this;
            var optionGroups = new Array(items.length);
            var allOptions = items.filter("option");
            $.each(items, function(i, item) {
                var opt = $(item);
                var tag = opt.prop("tagName");
                var label = item.label.trim();
                if (label.length===0) {
                    label = "&nbsp;";
                }
                var title = opt.attr("title");
                if ($.type(title)==="undefined") {
                    title = null;
                }
                if ( tag === "OPTION" ) {
                    optionGroups[i] = {
                        option: item,
                        label: label,
                        title: title
                    };
                } else {
                    var ret = that._organizeOptions(opt.children( "option,optgroup" ));
                    optionGroups[i] = {
                        label: label,
                        title: title,
                        optionGroups: ret.optionGroups
                    };
                    allOptions = allOptions.add(ret.allOptions);
                }
            });
            return {
                optionGroups: optionGroups,
                allOptions: allOptions
            };
        },
        
        _renderMenu: function(ul, items, indent, selectedLI) {
            var that = this;
            $.each(items, function(index, item) {
                var li = that._renderItem(ul, item, indent, selectedLI);
                if ($.type(item.option)!=="undefined" && item.option.selected) {
                    selectedLI[selectedLI.length] = li;
                }
            });
        },
        _renderItem: function(ul, item, indent, selectedLI) {
            var li;
            if ( $.type(item.optionGroups)==="undefined" ) {
                li = $("<li>")
                        .addClass( item.option.disabled ? "ui-state-disabled" : "" )
                            .append($("<span>")
                                .addClass( "ui-selectmenu-checkbox ui-icon ui-widget-content ui-corner-all "
                                    + (item.option.selected ? " ui-icon-check" : " ui-selectmenu-nocheck") ))
                            .append(this._indentItem(item, indent))
                        .appendTo(ul)
                        .data( "ui-selectmenu-item", item.option);
                //Add title if necessary
                if (item.title!==null) {
                    li.attr("title", item.title);
                }
            } else {
                li = $("<li>")
                        .addClass( "ui-state-disabled ui-selectmenu-optgroup" )
                            .append(this._indentItem(item, indent))
                        .appendTo(ul);
                //Add title if necessary
                if (item.title!==null) {
                    li.attr("title", item.title);
                }
                this._renderMenu(ul, item.optionGroups, indent+1, selectedLI);
            }
            return li;
        },
        _indentItem: function(item, indent) {
            var span = $("<span>").html(item.label);
            for (var i=0;i<indent;i++) {
                span = $("<span>")
                        .addClass( "ui-selectmenu-indent" )
                        .append(span);
            }
            return span;
        },
        _move: function(direction, event, disabled) {
            if (!this.menuwrapperVisible) {
                return;
            }

            var down;
            if (direction==="next" || direction==="nextPage" || direction==="last") {
                down = true;
            } else if (direction==="prev" || direction==="previousPage" || direction==="first") {
                down = false;
            } else {
                return;
            }

            event.preventDefault();

            //Can user move through menu
            if (this.cannotmove) {
                return;
            }

            /*
             * Change direction if menu is currently not active.
             * This will happen if the menu was blurred as a result of
             * no option being enabled.
             */
            if (!this.menu.active) {
                direction = down ? "last" : "first";
            }

            //Alter direction if on the first or last item, and that item is disabled
            if (disabled) {
                if (this.menu.isFirstItem() || this.menu.isLastItem()) {
                    if (this.directionFlipped) {
                        /*
                         * If direction has flipped, we have cycled through all items.
                         * Simply blur the menu and prevent further moving.
                         */
                        this.cannotmove = true;
                        delete this.directionFlipped;
                        this.menu.blur(event);
                        return;
                    }
                    this.directionFlipped = true;
                    direction = this.menu.isFirstItem() ? "next" : "prev";
                }
            } else {
                delete this.directionFlipped;
                if (this.menu.isFirstItem() && !down ||
                    this.menu.isLastItem() && down) {
                    return;
                }
            }

            //Store the direction of motion in case disabled item is about to be selected (see menufocus event of menu)
            this.lastDirection = direction;
            if (/Page$/.test(direction)) {
                this.menu[direction](event);
            } else {
                var secondDirection = direction==="next" ? "end" : direction==="prev" ? "first" : direction;
                this.menu._move(direction, secondDirection, event);
            }
        },
        widget: function() {
            return this.buttonwrapper;
        },
        menuWidget: function() {
            return this.menuwrapper;
        },
        disable: function() {
            this.element.attr("disabled", true);
            this.button.disable();
            this.menu.disable();
            this.close();
        },
        enable: function() {
            this.element.removeAttr("disabled");
            this.button.enable();
            this.menu.enable();
        },
        _keyEvent: function(keyEvent, event) {
            event.preventDefault();
            if (this.menuwrapperVisible) {
                this._move(keyEvent, event);
            } else if (!this.multiple && (keyEvent==="next" || keyEvent==="prev")) {
                var options = this.element.find("option");

                //Handle selecting item by simply up/down arrow keys

                //Find various options
                var first = null,
                        previous = null,
                        next = null,
                        found = false,
                        previousIndx,
                        nextIndx;
                $.each(options, function(indx, item) {
                    if (item.selected) {
                        found = true;
                    } else if (!item.disabled) {
                        if (first === null) {
                            first = item;
                        }
                        if (found) {
                            if (next === null) {
                                next = item;
                                nextIndx = indx;
                            }
                        } else {
                            previous = item;
                            previousIndx = indx;
                        }
                    }
                });

                if (first!==null) {
                    if (keyEvent==="prev" && previous!==null) {
                        this._select(previous, true, event);
                    } else if (keyEvent==="next" && next!==null) {
                        this._select(next, true, event);
                    }
                }
            }
        }
    });

}(jQuery));