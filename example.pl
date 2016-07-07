#!/usr/bin/perl

use lib 'extlib/lib/perl5', 'lib';

use warnings;
use strict;

use v5.14;

use WordTree;
use BoggleGraph;
use Boggle qw(find_all_words);

my $wt = WordTree->init();

say $wt->search('abase');
say $wt->search('ardvark');
say $wt->search('aardvar');

my $board = [
    ['e', 'e', 'c', 'a'],
    ['a', 'l', 'e', 'p'],
    ['h', 'n', 'b', 'o'],
    ['q', 't', 't', 'a'],
];

my $graph = BoggleGraph->new();
for (my $y = 0; $y < @$board; $y++) {
    for (my $x = 0; $x < @{$board->[$y]}; $x++) {
        $graph->insert_node(
            x      => $x, 
            y      => $y, 
            letter => $board->[$x][$y]
        );
    }
}
$graph->add_edges;

my %result;
for (my $y = 0; $y < 4; $y++) {
    for (my $x = 0; $x < 4; $x++) {
        my $start = $graph->board->[$x][$y];
        map { $result{$_} = 1 } find_all_words($start, $wt);
    }
}

say foreach (sort keys %result);
exit;
