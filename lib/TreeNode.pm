package TreeNode;

use warnings;
use strict;

use Moose;

has 'letter' => (
    is => 'ro',
    isa => 'Maybe[Str]',
);

has 'children' => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { {}; }
);

has 'is_word' => (
    is => 'ro',
    isa => 'Int',
);

sub insert {
    my ($self, $letters, $len) = @_;
    return if $len == 0;
    my $letter = shift @{$letters};
    if (not exists $self->children->{$letter}) {
        $self->children->{$letter} = TreeNode->new(   
            letter => $letter,
            is_word => ($len == 1) ? 1 : 0
        );
    }
    $self->children->{$letter}->insert($letters, $len - 1);
}

sub search {
    my ($self, $letters, $len) = @_;
    return 'not_found' if $len == 0;
    my $letter = shift @{$letters};
    if (not exists $self->children->{$letter}) {
        return 'not_found'; 
    }
    else {
        if ($len == 1) {
            if ($self->children->{$letter}->is_word) {
                return 'word_found';
            }
            else {
                return 'not_a_word';
            }
        }
        else {
            return $self->children->{$letter}->search($letters, $len - 1);
        }
    }
}
__PACKAGE__->meta->make_immutable;
1;
