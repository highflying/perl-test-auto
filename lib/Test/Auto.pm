package Test::Auto;

use Moose;
use namespace::sweep;
use Moose::Util::TypeConstraints;

subtype 'Test::Auto::TestPath', as 'Str', where { length $_ > 0 and -e $_ };
subtype 'Test::Auto::IncPath', as 'Str', where { -d $_ };

has test_path => (
    is      => 'ro',
    isa     => 'Test::Auto::TestPath',
    default => './t',
);

has _inc => (
    is       => 'ro',
    init_arg => 'inc',
    isa      => 'ArrayRef[Test::Auto::IncPath]',
    default  => sub { [] },
    traits   => ['Array'],
    handles  => {
        _has_inc => 'count',
    },
);

has _prove_args => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build__prove_args',
);

sub _build__prove_args {
    my ($self) = @_;

    my @prove_args;

    if ( $self->_has_inc ) {
        push @prove_args, map { ( '-I', $_ ) } @{ $self->_inc };
    }

    push @prove_args, $self->test_path;

    return \@prove_args;
}

sub run {
}

__PACKAGE__->meta->make_immutable;

1;
