#!/usr/bin/env ruby

#	canvas-grades.rb
#	Author: William Woodruff
#	------------------------
#	Get a student's current term grades from Canvas.
#	Tested on UMD ELMS. Requires an access token (/profile/settings).
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT


require 'json'
require 'open-uri'

def current_term(courses)
	season_mapping = {
		"Winter" => 0,
		"Spring" => 1,
		"Summer" => 2,
		"Fall" => 3
	}

	terms = courses.map { |c| c["term"]["name"].split(' ') }
	year_terms = terms.select { |t| t[1].to_i == Time.now.year }.uniq

	current_term = year_terms.first
	year_terms.each do |term|
		if season_mapping[term.first] > season_mapping[current_term.first]
			current_term = term
		end
	end

	current_term.join(' ')
end

KEY = ENV["CANVAS_API_KEY"]
URL = "https://myelms.umd.edu/api/v1/courses?" \
	"enrollment_type=student" \
	"&state=available" \
	"&include[]=total_scores&include[]=term" \
	"&access_token=%{key}"

abort("#{$PROGRAM_NAME}: Missing environment: CANVAS_API_KEY.") unless KEY

url = URL % { key: KEY }

begin
	response = JSON.parse(open(url).read)
rescue OpenURI::HTTPError => e
	abort "Fatal: #{e.to_s}"
end

current_courses = response.select do |course|
	course["term"]["name"] == current_term(response)
end

current_courses.each do |course|
	name = course["course_code"]
	grade = course["enrollments"].first["computed_current_score"]

	puts "#{name}: #{grade}"
end
