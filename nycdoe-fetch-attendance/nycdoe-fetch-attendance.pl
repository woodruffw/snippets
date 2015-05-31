#!/usr/bin/env perl

#  nycdoe-attendance-fetch.pl
#  Author: William Woodruff
#  ------------------------
#  Fetches data on school attendance from the NYC DOE's XML API.
#  Depends on LWP::Simple and XML::Simple.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use LWP::Simple;
use XML::Simple;

my $attendance_url = "http://schools.nyc.gov/aboutus/data/attendancexml/";
my $school_id = shift || die "Usage: nycdoe-attendance-fetch.pl <\"school name\" | DBN>\n";

my $xml_data = get($attendance_url);
my $decoded_xml_data = XMLin($xml_data);

foreach (@{$decoded_xml_data->{'item'}})
{
	if (($_->{'SCHOOL_NAME'} eq uc($school_id)) || ($_->{'DBN'} eq uc($school_id)))
	{
		print "School: ", $_->{'SCHOOL_NAME'}, "\n";
		print "Attendance: ", $_->{'ATTN_PCT'}, "% as of ", split_date($_->{'ATTN_DATE_YMD'}), "\n";
		last;
	}
}

sub split_date
{
	return substr($_[0], 4, 2) . "/" . substr($_[0], 6, 2) . "/" . substr($_[0], 0, 4);
}
