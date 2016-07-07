package BoggleGraph;

use strict;
use warnings;

use Moose;
use GraphNode;

has 'board' => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { []; }
);

sub insert_node {
    my ($self, %args) = @_;
    my $node = GraphNode->new(%args);
    my $x = $node->x;
    my $y = $node->y;
    $self->board->[$x][$y] = $node;
}

sub add_edges {
    my $self = shift;
    for (my $y = 0; $y <= 3; $y++) {
        for (my $x = 0; $x <= 3; $x++) {
            $self->_add_neighbours($x, $y);
        }
    }
}

sub _add_neighbours {
    my ($self, $x, $y) = @_;
    my $from_y = ($y > 0) ? $y - 1 : 0;
    my $to_y   = ($y < 3) ? $y + 1 : 3;
    my $from_x = ($x > 0) ? $x - 1 : 0;
    my $to_x   = ($x < 3) ? $x + 1 : 3;
    for (my $ny = $from_y; $ny <= $to_y; $ny++) {
        for (my $nx = $from_x; $nx <= $to_x; $nx++) {
            if ($nx != $x || $ny != $y) {
                $self->board->[$x]->[$y]->add_edge_to(
                    $self->board->[$nx][$ny]
                );
            }
        }
    }
}

__PACKAGE__->meta->make_immutable();
1;
