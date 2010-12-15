
package OpenData::Simple;

our $VERSION = '0.001';

use Moose;
use Devel::Declare ();
use Carp qw/ confess /;
use namespace::autoclean;
use OpenData::Provider;
use OpenData::Provider::NCollection;

extends 'Devel::Declare::Context::Simple';

our $provider = undef;
our $default_loader = undef;
our $default_extract = undef;

sub provider {
    my ($hash) = shift;

    die 'Provider need to be clean by clean_provider' if $provider;

    $default_loader = $hash->{default_loader};
    delete $hash->{default_loader};

    $default_extract = $hash->{default_extract};
    delete $hash->{default_extract};

    my $collections = $hash->{collections};
    delete $hash->{collections};

    $provider = OpenData::Provider->new($hash);

    foreach my $options (@{$collections}) {
        my $class = OpenData::Provider::NCollection->new($options);
        $provider->add_collection($class);
    }

    return $provider;
}

sub clean_provider {
    $provider = undef;
    $default_loader = undef;
    $default_extract = undef;
}

sub import {
    my $class = shift;
    my $caller = caller;
    my $context = __PACKAGE__->new;

    my @cmds = ( 'provider' );

    Devel::Declare->setup_for(
        $caller, {
            map { $_ => { const => sub { $context->parser(@_) } } } @cmds
        }
    );

    no strict 'refs';
    map { *{ join('::', $caller, $_) } = \&$_ } @cmds;
}

sub parser {
    my $self = shift;

    $self->init(@_);
    $self->skip_declarator;

    my $name = $self->strip_name;
    my $proto = $self->strip_proto;

}

1;



