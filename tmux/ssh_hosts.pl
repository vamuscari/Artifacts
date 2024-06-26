#!/usr/bin/perl
# This script is ment to get ssh names from ssh configs that have host names.
# Why did I do this in perl? Im really not sure myself
use strict;
use warnings;

use Path::Tiny;
use autodie;

my @names;


foreach my $input (@ARGV){
  my $config = path($input)->slurp_utf8();
  #Turn all Hosts into blocks 
  my @blocks = ($config =~ m/^Host\s.*?(?=^\w|\Z)/smg);
  foreach my $block (@blocks){
    #Get name of host where HostName is declared
    $block =~ m/^Host\s(.*?)\R.*?HostName/sm;
    if($1){
      push(@names, $1)
    };
  };
};
foreach my $name (@names){
  print "$name\n";
};
