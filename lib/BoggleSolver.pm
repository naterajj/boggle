package BoggleSolver;
use Dancer2;
use Dancer2::Plugin::Ajax;
use Try::Tiny;

use WordTree;
use BoggleGraph;
use Boggle qw(find_all_words);

our $VERSION = '0.1';

my $wt = WordTree->init();

get '/' => sub {
    template 'index';
};

ajax ['post'] => '/solve' => sub {
    # read the JSON body
    my $body = request->body;
    my ($graph, $board);
    eval {
        $board = from_json($body);
    };
    if ($@) {
        return to_json({error => "board must be an array of arrays"});
    }
    
    # populate the board in to the graph
    $graph = BoggleGraph->new();

    for (my $y = 0; $y < @$board; $y++) {
        for (my $x = 0; $x < @{$board->[$y]}; $x++) {
            # simple validation, if we don't get a single letter per cell, bail out
            if ($board->[$x]->[$y] && $board->[$x][$y] =~ /^[a-z]$/i) {
                $graph->insert_node(
                    x      => $x, 
                    y      => $y, 
                    letter => lc($board->[$x][$y])
                );
            }
            else {
                return to_json({
                    error => "invalid character ". $board->[$x]->[$y]
                });
            }
        }
    }

    # define the edges (neighbouring cells)
    $graph->add_edges;

    # Taking advantage of the problem structure,
    # find all words using each cell as a starting point
    my %result;
    for (my $y = 0; $y < 4; $y++) {
        for (my $x = 0; $x < 4; $x++) {
            my $start = $graph->board->[$x][$y];
            map { $result{$_} = 1 } find_all_words($start, $wt);
        }
    }

    to_json([sort keys %result]);
};

true;
