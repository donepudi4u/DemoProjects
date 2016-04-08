/**
 * Will select an elements contents.
 * 
 * @param {type} el element to select
 */
function selectElementContents(el) {
    try {
        if (typeof el !== "undefined") {
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
        } else {
            var sel = window.getSelection();
            sel.removeAllRanges();
        }
    } catch (e) {
        //ignore
    }
}