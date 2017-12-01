"use strict";

// ==UserScript==
// @name Google Search Neutralizer
// @description Removes URL rewrites in Google Search results
// @version 1.0.0
// @include *.google.*/search*
// ==/UserScript==

var links = document.getElementsByTagName("a");

for (var i = 0; i < links.length; i++) {
    /*
        Google's URL rewriting function is triggered by an "onmousedown" event.
        I can't conceive of anything legitimate using this event on a search result page,
        so just nuke it entirely.
    */
    links[i].removeAttribute("onmousedown");
}
