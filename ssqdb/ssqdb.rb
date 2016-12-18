#!/usr/bin/env ruby

# ssqdb.rb
# Author: William Woodruff
# ------------------------
# A tiny static quote DB, inspired by QDB.
# ssqdb expects the following quote file format:
#  --
#  <person1> witty comment
#  <person2> witty response
#  --
#  <person3> less witty comment
#  --
#  (etc)
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

require "erb"
require "cgi"

HEADER = <<~EOS
<html>
  <head>
    <meta charset="UTF-8">
    <title>ssqdb <%= " - quote \\#\#{index}" if defined? index %></title>
    <style type="text/css">
      body {
        background-color: #F6F6F6;
        font-family: monospace;
        color: #222;
        max-width: 50em;
        margin: auto;
        padding: 1em;
      }

      a {
        color: #555;
      }

      pre {
        white-space: pre-wrap;
      }

      .quote-link {
        text-decoration: none;
      }

      .quote-header {
        padding-left: 0.5em;
        padding-top: 0.5em;
        color: #555;
      }

      .quote-text {
        padding-left: 0.5em;
        padding-right: 0.5em;
        padding-bottom: 0.5em;
      }

      .quote {
        padding: 0;
        margin: 0;
      }

      .quote:nth-of-type(odd) {
        background-color: #e0e0e0;
        padding-bottom: 0.1em;
        margin-bottom: -0.5em;
      }
    </style>
    <script type="text/javascript">
      function makeUrl(count) {
        var num = Math.floor(Math.random() * count) + 1;
        window.location = "quote" + num + ".html";
      }

      function randomQuote() {
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
          if (req.readyState == 4 && req.status == 200) {
            makeUrl(req.responseText);
          }
        }

        req.open("GET", "count", true);
        req.send(null);
      }
    </script>
  </head>
  <body>
    <a href="index.html">all</a> /
    <a href="#" id="random" onclick="randomQuote();">random</a> /
    <a href="about.html">about</a>
EOS

FOOTER = <<~EOS
  </body>
  </html>
EOS

QUOTE = <<~EOS
  <div class="quote">
  <h5 class="quote-header">
    quote #<%= index %>
    <a class="quote-link" href="quote<%= index %>.html">(&rarr;)</a>
  </h5>
  <pre class="quote-text">
  <%= quote %>
  </pre>
  </div>
EOS

INDEX_PAGE = <<~EOS
  #{HEADER}

  <% quotes.each_with_index do |quote, index| %>
    #{QUOTE}
  <% end %>

  #{FOOTER}
EOS

QUOTE_PAGE = <<~EOS
  #{HEADER}

  #{QUOTE}

  #{FOOTER}
EOS

ABOUT_PAGE = <<~EOS
  #{HEADER}

  <p>
    ssqdb is a tiny static quote DB, inspired by QDB and its siblings.
  </p>

  <p>
    usage: <code>$ ssqdb.rb /path/to/your/quotes.txt</code>
  </p>

  <p>
    "quotes.txt" should be formatted as follows:
    <pre>
      --
      &lt;person1&gt; witty comment
      &lt;person2&gt; witty response
      --
      &lt;person3&gt; less witty comment
      --
      (etc)
    </pre>
  </p>

  #{FOOTER}
EOS

quotes_file = ARGV.shift || abort("I need a file to load quotes from.")
output_dir = ARGV.shift || __dir__
abort("That isn't a file.") unless File.file?(quotes_file)
abort("Output directory doesn't exist.") unless Dir.exist?(output_dir)

quotes_string = File.read(quotes_file)
quotes = quotes_string.split(/^--$/).map(&:strip).reject(&:empty?)

abort("This file doesn't look like a quote DB.") if quotes.empty?

# no attempt is made to escape anything besides < and >.
quotes.map! do |quote|
  CGI.escapeHTML(quote)
end

File.write(File.join(output_dir, "count"), quotes.size)
File.write(File.join(output_dir, "index.html"), ERB.new(INDEX_PAGE).result(binding))
File.write(File.join(output_dir, "about.html"), ERB.new(ABOUT_PAGE).result(binding))

quotes.each_with_index do |quote, index|
  File.write(File.join(output_dir, "quote#{index}.html"), ERB.new(QUOTE_PAGE).result(binding))
end
