https://filmezando.me/aquaman-2-o-reino-perdido/
https://filmezando.me/beekeeper-rede-de-vinganca/
https://filmezando.me/napoleao/
https://filmezando.me/feriado-sangrento/
https://filmezando.me/intruso/!/usr/bin/perl
# This script parses M3U into tab-separated values (tsv-file)
# Only supports entries with EXTINF tag

# EXTM3U is hard to parse and use from shell scripts
# I couldnt find a working M3U parser so I wrote my own

# Examples:

# cat playlist.m3u | ./m3u.pl | cut -d '\t' -f 3 | sort -u 
# gets all groups(categories) from playlist

# ./m3u.pl playlist.m3u | awk -F'\t' '$1 == "My item" {print $2}' 
# prints URL of My item

use Text::ParseWords;
use strict;
use warnings;
use v5.22;
use utf8::all;


while ( <> ) {
    # m3u parser
    # populate opts hash-array

    chomp;
    next unless /^#EXTINF:/;
    my @p = split(/,/, $_, 2);

    my @args = shellwords($p[0]);

    my %opts = ();
    $opts{time} = shift @args;
    $opts{time} =~ s/^#EXTINF://;

    $opts{name} = $p[1];
    
    my $url = <>;

    while($url =~ /^#/) { $url = <>; }

    chomp $url;
    $opts{url} = $url;
    
    
    for my $a ( @args ) {
        my @kv = split /=/, $a, 2;
        $opts{$kv[0]} = $kv[1];
    }
    # m3u parsed!

    # print channels as tab separated values (tsv-file)
    # you can modify to add your fields
    say join("\t",
             $opts{name},
             $opts{url},
             $opts{'group-title'},
             $opts{'tvg-logo'}
        );
}
