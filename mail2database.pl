#!/usr/bin/perl
use strict;
use warnings;

my $logfile = "/var/log/mail.log";

open(FH,'<',$logfile) || die("Unable to open $logfile");  # standard open call
for (;;) {
    while (<FH>) {
        # ... process $_ and do something with it ...
		my $line = $_;
		chomp($line);
		
		#print $line, "\n\n";

		if ($line =~ /RelayedInbound/ ) {
		#get the date
			my $date = substr($line, 0, 15);

			my $queued_as = $1 if ($line =~ /queued_as:\s(\w{8,20}),/);
			my $size = $1 if ($line =~ /size:\s(\d{0,10}),/);
			my $spam_score = $1 if ($line =~ /Hits:\s(\S{1,10}),/);
			my $from = $1 if ($line =~ /\s<([a-zA-Z0-9\+\-\_\.\=]{1,255}@[a-zA-Z0-9\+\-\_\.]{1,255})>\s\-\>/);
			my $to = $1 if ($line =~ /\-\>\s<([a-zA-Z0-9\+\-\_\.\=]{1,255}@[a-zA-Z0-9\+\-\_\.]{1,255})/);

			
			print "Date:\t\t",$date, "\n";
			print "Que:\t\t", $queued_as, "\n"; 
			print "Size:\t\t", $size, "\n";
			print "Spam Score:\t", $spam_score, "\n"; 
			print "To:\t\t", $to, "\n";
			print "From:\t\t", $from, "\n";

			print "\n\n";
		

		} elsif ($line =~ /NOQUEUE/ ) {
			#my @m = ( $line =~ /\s/ );
			#system "/bin/echo $line /n/n"; # and this
			#foreach (@m) {
			 # system "/bin/echo $_\n";
			#}

		} elsif ($line =~ /SomethingElse/ ) {
			#system "/bin/echo \"Something else happens with $line\" "; # and this
		}
    }
    # eof reached on FH, but wait a second and maybe there will be more output
    sleep 1;
    seek FH, 0, 1;      # this clears the eof flag on FH
}
