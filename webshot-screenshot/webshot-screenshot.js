#!/usr/bin/env node

/*  webshot-screenshot.js
 *  Author: William Woodruff
 *  -------------------------
 *  Takes a screenshot of the given website, saving it to the given file.
 *  Uses node-webshot, which uses phantomJS to render the page.
 *  -------------------------
 *  This code is licensed by William Woodruff under the MIT License.
 *  http://opensource.org/licenses/MIT
 */

var webshot = require('webshot')

var options = {
	shotsize: {
		width: 'all',
		height: 'all'
	},
	useragent: 'Mozilla/5.0 (webshot-screenshot.js; )'
}

var args = process.argv.slice(2);

if (args.length != 2)
{
	sys.print("Usage: " + process.argv[1] + "<url> <file>");
	process.exit(1);
}

url = args[0];
file = args[1];

webshot(url, file, options, function(err) {});
