
package OpenData::Get::Curl;

use Moose::Role;
with 'OpenData::Get::Base';
with 'OpenData::Debug';

use WWW::Mechanize;

has _mechanize => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        WWW::Mechanize->new(
            stack_depth => 5,
            agent_alias => 'Linux Mozilla',
            onerror     => sub { $self->debug(@_) },
            timeout     => 30,
        );
    }
);

sub get {
    my $self = shift;
    return if !$self->has_url;
    $self->_mechanize->get( $self->url );
    if ( $self->_mechanize->success ) {
        return $self->_mechanize->content;
    }
    else {
        return;
    }
}

*post = \&get;

1;

