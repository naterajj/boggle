package GraphNode;

use warnings;
use strict;

use Moose;

has 'letter' => (
    is => 'ro',
    isa => 'Str',
);

has 'x' => (
    is => 'ro',
    isa => 'Int'
);

has 'y' => (
    is => 'ro',
    isa => 'Int'
);

has 'edges' => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { {}; }
);

sub str {
    my $self = shift;
    return $self->x . '-' .  $self->y .'-'. $self->letter;
}

sub add_edge_to {
    my ($self, $to) = @_;
    if (!exists ${$self->edges}{$to->str}) {
        ${$self->edges}{$to->str} = $to;
    }
}

__PACKAGE__->meta->make_immutable;
1;
