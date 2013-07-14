#!/usr/bin/env perl
#submited by crshd
#depends on http://search.cpan.org/~woldrich/Term-ExtendedColor-0.224/lib/Term/ExtendedColor.pm


use strict;
use warnings FATAL => 'all';
use vars qw($VERSION);

use feature 'switch';
use Term::ExtendedColor qw(:attributes);

my @uname = split(' ', `uname -srnmi`);

print fg('1', $uname[0]); # kernel
print fg('0', ' | ');
print fg('2', $uname[2]); # kernel version
print fg('0', ' | ');
print fg('3', $uname[1]); # hostname
print fg('0', ' | ');
print fg('5', $uname[4]); # platform
print fg('0', ' | ');
print fg('4', $uname[3]); # arch
print "\n"; 
