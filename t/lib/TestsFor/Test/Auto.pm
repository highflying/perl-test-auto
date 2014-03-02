package TestsFor::Test::Auto;

use Test::Class::Moose;
use Const::Fast;

use Test::Auto;

const my $CLASS => 'Test::Auto';

sub test_new {
    my $test = shift;

    can_ok( $CLASS, 'new' );

    my $object = $CLASS->new;

    isa_ok( $object, $CLASS );

    return;
}

sub test_run {
    my $test = shift;

    my $object = $CLASS->new;

    can_ok( $object, 'run' );

    # prove -v -I lib t

    return;
}

sub test_attribute_test_path {
    my $test = shift;

    my $object = $CLASS->new;

    can_ok( $object, 'test_path' );

    ok( $object->test_path, 'Has a default test_path' );

    is( $object->test_path, './t', 'Default test path is set' );

    throws_ok( sub { $CLASS->new( { test_path => undef } ) },
        qr/test_path/, 'Exception thrown for undef test_path' );

    throws_ok( sub { $CLASS->new( { test_path => '' } ) },
        qr/test_path/, 'Exception thrown for empty test_path' );

    throws_ok( sub { $CLASS->new( { test_path => '/made_up_path' } ) },
        qr/test_path/, 'Exception thrown for non-existing test_path' );

    throws_ok( sub { $object->test_path('/tmp') },
        qr/test_path/, 'Exception thrown when setting test_path on instance' );

    return;
}

sub test_attribute_inc {
    my $test = shift;

    my $object = $CLASS->new;

    can_ok( $object, '_inc' );

    isa_ok( $object->_inc, 'ARRAY' );

    is_deeply( $object->_inc, [], 'Default is an empty array' );

    can_ok( $object, '_has_inc' );

    ok( !$object->_has_inc, 'Default is no entries in inc' );

    throws_ok( sub { $object->_inc( [] ) },
        qr/inc/, 'Exception thrown when inc is set on an instance' );

    my @inc_paths = ( 'lib', 't/lib' );

    my $object_with_inc = $CLASS->new( { inc => \@inc_paths } );

    is_deeply( $object_with_inc->_inc, \@inc_paths,
        'Paths passed via inc appear in _inc' );

    throws_ok( sub { $CLASS->new( { inc => undef } ) },
        qr/inc/, 'Exception thrown for undef inc' );

    throws_ok( sub { $CLASS->new( { inc => [undef] } ) },
        qr/inc/, 'Exception thrown for undef inc path' );

    throws_ok( sub { $CLASS->new( { inc => ['/bad_path'] } ) },
        qr/inc/, 'Exception thrown for bad inc path' );

    throws_ok( sub { $CLASS->new( { inc => ['/etc/passwd'] } ) },
        qr/inc/, 'Exception thrown for file inc path' );

    return;
}

sub test_prove_args {
    my $test = shift;

    my $object = $CLASS->new;

    can_ok( $object, '_prove_args' );

    ok( $object->_prove_args, 'Prove args defined' );

    isa_ok( $object->_prove_args, 'ARRAY' );

    my @default_prove_args = ( $object->test_path );

    is_deeply( $object->_prove_args, \@default_prove_args,
        'Correct default prove_args' );

    my @single_inc = ('lib');

    my $object_with_inc = $CLASS->new( { inc => \@single_inc } );

    my @single_inc_prove_args = ( '-I', @single_inc, $object->test_path );

    is_deeply( $object_with_inc->_prove_args,
        \@single_inc_prove_args, 'Correct prove_args for single inc' );

    my @double_inc = ('lib');

    my $object_with_double_inc = $CLASS->new( { inc => \@double_inc } );

    my @double_inc_prove_args =
      ( ( map { ( '-I', $_ ) } @double_inc ), $object->test_path );

    is_deeply( $object_with_double_inc->_prove_args,
        \@double_inc_prove_args, 'Correct prove_args for double inc' );

    return;
}

1;
