package Boggle;

use strict;
use warnings;

use Sub::Exporter -setup => { exports => [ qw(find_all_words) ] };

sub _recursive_find {
    my ($node, $visited, $may_be_word, $words, $tree) = @_;
    my $search = $tree->search($may_be_word, length($may_be_word));
    return if ($search eq 'not_found');
    if ($search eq 'word_found') {
        $words->{$may_be_word} = 1;
    }
    foreach my $neighbour (values %{$node->edges}) {
        next if (exists $visited->{$neighbour->str});
        _recursive_find(
            $neighbour,
            { %$visited, $neighbour->str => 1 },
            $may_be_word . $neighbour->letter,
            $words,
            $tree
        );
    }
}

sub find_all_words {
    my ($node, $tree) = @_;
    my $words = {}; 
    _recursive_find(
        $node, 
        { $node->str => 1 }, 
        $node->letter,
        $words,
        $tree
    );
    my @words = grep { length($_) > 2 } sort keys %$words;
    return @words;
}

1;
