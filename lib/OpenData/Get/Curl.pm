
package OpenData::Get::Curl;

use Moose::Role;
with 'OpenData::Get::Base';

use LWP::Curl;

has _curl => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub { LWP::Curl->new }
);

sub get {
    my $self = shift;
    return if !$self->has_url;
    $self->_curl->get($self->url);
    
}

sub post {
    my ($self, $form) = @_;
    return if !$self->has_url;
    $self->_curl->post($self->url, $form, $self->referer);
}

1;

