/**
 * Wrap UI elements with borders.
 * 
 * @param parent parent element to find elements within to wrap
 * 
 * @returns parent
 */
//var wrapUIElements = function(parent) {
//    var elements = typeof parent!=="undefined" ? parent.find("input,textarea,fieldset,button,select") : $("input,textarea,fieldset,button,select");
//    elements.each(function(i, element) {
//        var obj = $(element);
//        var isspinner = obj.hasClass("ui-spinner-input");
//        var tagName = obj.prop("tagName").toString().toLowerCase();
//        var typeUndefined = typeof obj.attr("type") === "undefined";
//        if (!isspinner && !obj.hasClass("ui-widget") && !obj.hasClass("ui-nowrap")) {
//            var type = obj.prop("type");
//            if (tagName==="fieldset") {
//                obj.addClass("ui-corner-all");
//                obj.find("legend").addClass("ui-widget");
//            } else if (tagName==="select") {
//                //alert(obj[0].change);
//                //obj.selectmenu({
//                //    change: obj[0].onchange
//                //});
//            } else if (type==="text" || type==="textarea" || type==="password" || type==="file" || type==="search") {
//                obj.wrap("<label class='ui-input ui-widget ui-widget-content ui-corner-all custom-input-box'></label>");
//                obj.addClass("ui-input-input");
//                obj.on('focus', function() {
//                    $(this).parent().addClass("custom-input-box-focus");
//                    $(this).parent().removeClass("custom-input-box-hover");
//                });
//                obj.on('blur', function() {
//                    $(this).parent().removeClass("custom-input-box-focus");
//                });
//                obj.parent().on('mouseenter', function() {
//                    var child = $(this).children().first();
//                    if (!child.is(":focus") && !child.is(":disabled")) {
//                        $(this).addClass("custom-input-box-hover");
//                    }
//                });
//                obj.parent().on('mouseleave', function() {
//                    $(this).removeClass("custom-input-box-hover");
//                });
//                if (typeof obj.attr("title")!=="undefined") {
//                    obj.parent().attr("title", obj.attr("title"));
//                    obj.removeAttr("title");
//                }
//            } else if (type==="submit" || type==="button" || type==="reset") {
//                if (typeUndefined) {
//                    obj.prop("type", "button"); //If the type attribute is actually undefined, set the propery type to "button"
//                }
//                obj.button();
//            }
//        } else if (isspinner && !obj.parent().hasClass("custom-input-box")) {
//            obj.parent().addClass("custom-input-box");
//        } else if (tagName==="button" && typeUndefined) {
//            obj.prop("type", "button");
//        }
//    });
//    return parent;
//};
//
///**
// * Unwrap UI elements removing borders.
// * 
// * @param parent parent element to find elements within to unwrap
// * 
// * @returns parent
// */
//var unwrapUIElements = function(parent) {
//    var elements = typeof parent!=="undefined" ? parent.find("input,textarea,fieldset,button") : $("input,textarea,fieldset,button");
//    elements.each(function(i, element) {
//        var obj = $(element);
//        var title = null;
//        var isspinner = obj.hasClass("ui-spinner-input");
//        var tagName = obj.prop("tagName").toString().toLowerCase();
//        var typeUndefined = typeof obj.attr("type") === "undefined";
//        if (!isspinner) {
//            var type = obj.prop("type");
//            if (tagName==="fieldset") {
//                obj.removeClass("ui-corner-all");
//                obj.find("legend").removeClass("ui-widget");
//            } else if (type==="text" || type==="textarea" || type==="password" || type==="file") {
//                var objParent = obj.parent();
//                if (typeof objParent.attr("title")!=="undefined") {
//                    title = objParent.attr("title");
//                    obj.attr("title", title);
//                }
//                obj.insertBefore(objParent);
//                objParent.remove();
//                obj.removeClass("ui-input-input");
//                obj.off('focus');
//                obj.off('blur');
//            } else if (type==="submit" || type==="button" || type==="reset") {
//                if (typeUndefined) {
//                    obj.prop("type", "button"); //If the type attribute is actually undefined, set the propery type to "button"
//                }
//                try {
//                    obj.button("destroy");
//                } catch (e) {
//                }
//            }
//        } else if (isspinner && obj.parent().hasClass("custom-input-box")) {
//            obj.parent().removeClass("custom-input-box");
//        }
//    });
//    return parent;
//};

/**
 * Adds multiple selection capability to a data table.
 * 
 * @param {type} table table to add multiple selection capability to
 * @param {type} noDataRowCellValue text that is used to identify if the table is empty
 */
//function addMultiSelect(table, noDataRowCellValue) {
//    var b = $(table.table().body());
//    b.on( 'click', 'tr', function (event) {
//        if (event.shiftKey || event.ctrlKey || $(event.target).is(".noteditable")) {
//            var r = $(this);
//            var tds = r.children("td");
//            if (tds.length>1 || tds.first().text()!==noDataRowCellValue) {
//                if (event.ctrlKey) {
//                    r.toggleClass('selected');
//                    r.parent().parent().addClass('noselect');
//                    selectElementContents();
//                } else if (event.shiftKey) {
//                    var row = b.data("row");
//                    if ($.type(row)!=="undefined") {
//                        var select = false;
//                        var that = this;
//                        r.parent().children().each(function(i, e) {
//                            var last = false;
//                            if (row!==that && (e===row || e===that)) {
//                                last = select;
//                                select = !select;
//                            }
//                            last || select ? $(e).addClass("selected") : $(e).removeClass("selected");
//                        });
//                        if (row===this) {
//                            r.addClass("selected");
//                        }
//                    }
//                } else {
//                    var selected = r.hasClass('selected');
//                    var rows = r.parent().find('tr.selected');
//                    if (rows.length > 1) {
//                        selected = false; //Force selection if transitioning from multiple selctions to a single selection
//                    }
//                    rows.removeClass('selected');
//                    if (!selected) {
//                        r.addClass('selected');
//                        b.data("row", this);
//                    } else {
//                        b.removeData("row");
//                         
//                    }
//                }
//            }
//        }
//    } ).on( 'mouseup', 'tr', function(e) {
//        $(this).parent().parent().removeClass('noselect');
//    } ).on( 'mousedown', 'tr', function(e) {
//        if (e.shiftKey) {
//            e.preventDefault();
//        }
//    });
//    //table.draw(false);
//    return table;
//}

/**
 * Editor for use with data tables.  Simply call trimeditor.edit(event, cell), passing the event and cell within the data table to edit.
 */
var trimeditor = {};
(function() {
    //Array of undos
    var lundo = [];
     
    //Array of redos
    var lredo = [];
    
    //Callbacks to call when undoing or redoing is allowed or disallowed
    var lcallback = [];
    
    var inputWrapper = wrapUIElements($("<div>").append($("<input>"))).children();
    
    /**
     * Edit a cell.
     * 
     * @param {type} event event that triggered the cell to be edited
     * @param {type} cell cell to edit
     * @param {type} callback callback to call if value changes
     */
   
    trimeditor.edit = function(event, cell, callback) {
        var input = cell.find("input");
        //var row = cell.parent();
        //var clickedRow = typesTable.row( tr );
        // console.log("inside trimeditor row = " + clickedRow);
         //console.log("inside uielements - at trimeditor.edit input length =" +  input.length);
        if (input.length===0) {
            if (!event.ctrlKey) {
                //alert("inside commit");
                trimcommitValue();
                //Shrink input
                inputWrapper.outerWidth(0);
                //Get width and height for input
                var height = cell.innerHeight();
                var width = cell.innerWidth();
                //Get text of input, then move input into cell
               var text = cell.text();
               // alert("trimeditor.edit cell text = " + text);
                cell.addClass("editing").empty().append(inputWrapper);
                inputWrapper.outerHeight(height).outerWidth(width).children().val(text);
                inputWrapper.children().width(inputWrapper.width()).select();
                //Store the original value of the cell if not already stored
                var origVal = cell.data("origVal");
                if ($.type(origVal)==="undefined") {
                    cell.data("origVal", text);
                   // alert("trimeditor.edit celldata origVal  = " + text);
                }
                //Store the current value of the cell and the cell itself
                //alert("inputWrapper.data(val, text) = " + text + " cell = " + cell[0] + "callback = " + callback[0]);
                inputWrapper.data("val", text);
                inputWrapper.data("cell", cell);
                inputWrapper.data("callback", callback);
                event.stopPropagation();
            }
        } else {
            input.select();
            event.stopPropagation();
        }
    };

    /**
     * Register a callback to call indicating if undo or redo is available.
     * 
     * @param {type} callback callback to call
     */
    trimeditor.register = function(callback) {
        if ($.type(callback) !== "undefined") {
            var found = false;
            for (var ii=0;ii<lcallback.length;ii++) {
                if (lcallback[ii]===callback) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                lcallback[lcallback.length] = callback;
            }
        }
    };
   
    /**
     * Unregister a callback to call indicating if undo or redo is available.
     * 
     * @param {type} callback callback to no longer call
     */
    trimeditor.unregister = function(callback) {
        for (var ii=0;ii<lcallback.length;ii++) {
            if (lcallback[ii]===callback) {
                lcallback.splice(ii, 1);
                break;
            }
        }
    };
   
    trimeditor.addUndo = function(undo) {
        
        lundo[lundo.length] = undo;
        //console.log("inside trimeditor.addUndo undo =" + undo);
        lredo.length = 0;
        callCallback();
    };
   
    /**
     * Undo last change made.
     */
    trimeditor.undo = function() {
        //console.log("inside trimeditor.undo on button click");
        if (lundo.length!==0) {
            trimrollbackValue();
            console.log("trim lundo[0] = " + lundo[0]); // the console.log keeps the x.undo() below from errors = ???
            var x = lundo.splice(lundo.length-1, 1)[0];
            x.undo();
            lredo[lredo.length] = x;
            callCallback();
        }
    };
    
    /**
     * Redo last undo.
     */
    trimeditor.redo = function() {
        if (lredo.length!==0) {
            trimrollbackValue();
            var x = lredo.splice(lredo.length-1, 1)[0];
            x.redo();
            lundo[lundo.length] = x;
            callCallback();
        }
    };
     
    /**
     * Clear trimeditor, removing all undo and redo edits.
     */
    trimeditor.clear = function() {
        //alert("clearing the trimeditor");
        lundo.length = 0;
        lredo.length = 0;
        callCallback();
    };
   
    /**
     * Call callbacks.
     */
    function callCallback() {
        var e = {
           
            canUndo: lundo.length !== 0,
            canRedo: lredo.length !== 0
        };
        //console.log("adding lcallback length = " + lcallback.length );
        for (var ii=0;ii<lcallback.length;ii++) {
            //alert("lcallback[ii](e) = "+ lcallback[ii](e));
            lcallback[ii](e);
        }
    }
    
    /**
     * Commit value to cell.
     */
    function trimcommitValue() {
        if (inputWrapper.is(":visible")) {
            inputWrapper.detach();
            var cell = inputWrapper.data("cell");
            //Has the value changed
            var origVal = cell.data("origVal");
            var oldVal = inputWrapper.data("val");
            var newVal = inputWrapper.children().val();
            cell.parents(".dataTable").last().DataTable().draw(false).cell(cell[0]).data(newVal);
            
            //alert(newVal + " , " +  oldVal);
            cell.removeClass("editing");
            //cell.text(newVal);
            if (newVal!==oldVal) {
                var callback = inputWrapper.data("callback");
                trimeditor.addUndo({
                    undo: function() {
                        var table = cell.parents(".dataTable").last().DataTable();
                        table.cell(cell[0]).data(oldVal);
                        table.draw(false);
                        if ($.type(callback)!=="undefined") {
                            
                            callback(cell, oldVal, newVal, cell.data("origVal"));
                        }
                    },
                    redo: function() {
                        var table = cell.parents(".dataTable").last().DataTable();
                        table.cell(cell[0]).data(newVal);
                        table.draw(false);
                        if ($.type(callback)!=="undefined") {
                            callback(cell, newVal, oldVal, cell.data("origVal"));
                        }
                    }
                });
                lredo.length = 0;
                if ($.type(callback)!=="undefined") {
                    //alert("going into callback" + "cell newVal oldVal origVal = " + newVal + ", " + oldVal + "," + origVal);
                    callback(cell, newVal, oldVal, origVal);
                    //alert("callback  !==undefined");
                }
                callCallback();
            }
            cell.parents(".dataTable").last().DataTable().draw(false);
            
        }
    }
    
    /**
     * Rollback value in cell to its previous value.
     */
    function trimrollbackValue() {
        if (inputWrapper.is(":visible")) {
            inputWrapper.detach();
            var cell = inputWrapper.data("cell");
            if ($.type(cell)!=="undefined") {
                cell.text(inputWrapper.data("val"));
                cell.removeClass("editing");
                cell.parents(".dataTable").last().DataTable().draw(false);
            }
        }
    }
    
    //Handle when user hits ENTER, TAB, or ESCAPE keys in input
    inputWrapper.children().on("keydown", function(event) {
        var keyCode = $.ui.keyCode;
        switch (event.keyCode) {
            case keyCode.ENTER:
            case keyCode.TAB:
             //var totalw = $( window).width() ;
               //the scrollLeft contains an offset in it - the attempts to scroll during tabbing are crude but work for the most part
               // it could be refined for very small viewports which is where it fails - also if user zooms in or out 
               // the effectiveness is not as good - also there are 2 levels of sizing to address: the accordion object to the window to move the outer 
               // horizontal scrollbar and the size of the accordion object to the table it contains to move the inner horizontal scrollbar
                if(event.shiftKey){
                    var td = $(event.target).parents("td").prev();
                     var index1 =  $(event.target).parents("td").index() * 50;
                    $("div").scrollLeft(index1);
                     if( td.index() < 1 ){
                         var td = $(event.target).parents("tr").prev("tr").find("td").last();
                    }
                   
                }else{
                    var td = $(event.target).parents("td").next();
                    var index1 =   $(event.target).parents("td").index() * 50;
                   $("div").scrollLeft(index1);
                    if( td.index() > 14 ){
                        var td = $(event.target).parents("tr").next("tr").find("td").first();
                       
                    }
                    
                }
                 trimcommitValue();
                if( td.parents("td:not(.noteditable)") ){
                    trimeditor.edit(event, td, function() {});
                    event.preventDefault();
                }
                 event.stopPropagation();
                break;
                //trimcommitValue();
                //break;
            case keyCode.ESCAPE:
                trimrollbackValue();
        }
    });
    
    $(window).on( "click", function() {
        //Commit value if user clicks outside the cell.
        trimcommitValue();
    }).on("keydown", function(event) {
        //Undo or redo edits if CTRL-Z or CTRL-Y are clicked respectively
        if (event.ctrlKey && !event.altKey && !event.shiftKey) {
            switch (event.keyCode) {
                case 90:
                case 122:
                    trimeditor.undo();
                    event.preventDefault();
                    break;
                case 89:
                case 121:
                    trimeditor.redo();
                    event.preventDefault();
                    break;
            }
        }
    });
})();