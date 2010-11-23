
package OpenData::Get::Mechanize;

use Moose::Role;
with 'OpenData::Get::Base';

use WWW::Mechanize;

has _module => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my $self = shift;
        WWW::Mechanize->new(
            stack_depth => 5,
            agent_alias => $self->agent,
            onerror     => sub { $self->debug(@_) },
            timeout     => $self->timeout
        );
    }
);

1;

