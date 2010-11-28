
package OpenData::Get::Base;

use Moose::Role;
use namespace::autoclean;

has url => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_url',
);

has referer => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

has timeout => (
    is  => 'rw',
    isa => 'Int',
    default => 30
);

has agent => (
    is => 'rw',
    isa => 'Str',
    default => 'Linux Mozilla'
);

has try => (
    is => 'ro',
    isa => 'Int',
    default => 5
);

sub content { $_[1] }

sub get {
    my $self = shift;
    return if !$self->has_url;

    for (1 .. $self->try) {
        my $content = $self->_module->get($self->url);
        return $self->content($content) if $content;
    }
}

sub post {
    my ($self, $form) = @_;
    return if !$self->has_url;
    for (1 .. $self->try) {
        my $content = $self->_module->post($self->url, $form, $self->referer);
        return $content if $content;
    }
}

1;

