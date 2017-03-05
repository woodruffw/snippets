#!/usr/bin/env ruby

# ffmpeg-mosaic.rb
# Author: William Woodruff
# ------------------------
# Create an NxM "mosaic" of videos using ffmpeg and a generated complex filter.
# Requires ffmpeg.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

throttle = !!ARGV.delete("--throttle")
shortest = !!ARGV.delete("--shortest") ? 1 : 0

width, height = ARGV.shift&.split("x", 2).map(&:to_i)

rows, columns = ARGV.shift&.split("x", 2).map(&:to_i)

output = ARGV.shift

inputs = ARGV

if rows * columns < inputs.size
  abort "Please add another row or column."
end

unless !inputs.empty? && inputs.all? { |i| File.file?(i) }
  abort "One or more invalid inputs."
end

pane_width = width / rows
pane_height = height / columns
pane_dim = "#{pane_width}x#{pane_height}"

args = ["ffmpeg"]

inputs.each_with_index do |input, idx|
  args.concat ["-i", input] # "-threads:#{idx}", "1"]
end

args.concat ["-threads", "1"] if throttle

input_mosaic = inputs.each_slice(columns)

args << "-filter_complex"

filter = ""
filter << "nullsrc=size=#{width}x#{height} [base];\n"

input_mosaic.each_with_index do |row, i|
  row.each_with_index do |col, j|
    idx = (i * columns) + j
    filter << "[#{idx}:v] setpts=PTS-STARTPTS, scale=#{pane_dim} [a#{idx}];\n"
  end
end

tmp = "tmp0"
filter << "[base][a0] overlay=shortest=#{shortest} [#{tmp}];\n"

input_mosaic.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if i.zero? && j.zero? # this one comes for free, see above
    idx = (i * columns) + j
    tmp_next = "tmp#{idx}"
    xy = ":x=#{pane_width * j}:y=#{pane_height * i}"

    if idx != inputs.size - 1
      filter << "[#{tmp}][a#{idx}] overlay=shortest=#{shortest}#{xy} [#{tmp_next}];\n"
    else # last input has special syntax
      filter << "[#{tmp}][a#{idx}] overlay=shortest=#{shortest}#{xy}"
    end

    tmp = tmp_next
  end
end

# -an disables audio output, since it doesn't make much sense here
args.concat [filter, "-an", output]

exec *args
