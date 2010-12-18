package OpenData::Get;
use Moose;

with 'MooseX::Traits';
has '+_trait_namespace' => ( default => 'OpenData::Get' );

has referer => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has timeout => (
    is      => 'rw',
    isa     => 'Int',
    default => 30
);

has agent => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Linux Mozilla'
);

has attempts => (
    is      => 'ro',
    isa     => 'Int',
    default => 5
);

has obj => (
	is => 'ro',
	isa => 'Any',
	lazy => 1,
	predicate => 'has_obj',
	default => sub { 
		my $self = shift;
        my $mod = q{OpenData::Get::}.$self->browser;
		eval "with q($mod)";
		$self->confess($@) if $@;
		return $self->_make_obj;
	},
);

has browser => (
	is => 'ro',
	isa => 'Str',
	required => 1,
	lazy => 1,
	default => 'Mechanize',
);

has content_sub => (
	is => 'ro',
	isa => 'CodeRef',
	lazy => 1,
	default => sub { 
		my $self = shift;
        my $mod = q{OpenData::Get::}.$self->browser;
		eval "with q($mod)";
		$self->confess($@) if $@;
		#return $self->_make_obj;
		return sub {
			#print STDERR qq#can content\n# if $self->can('_content');
			return $self->_content(shift);
        } if $self->can('_content');

        return sub { return shift }
	},
);

sub get {
    my ( $self, $url ) = @_;
    #use Data::Dumper;
    #1 if $self->obj;
    #print STDERR Dumper($self);
    for ( 1 .. $self->attempts ) {
        my $content = $self->obj->get( $url );
        #print STDERR Dumper($content);
        #print STDERR 'obj = '.$self->obj."\n";
        #my $res = $self->content_sub->($content) if $content;
        #print STDERR Dumper($res);
        return $self->content_sub->($content) if $content;
    }
    return;
}

sub post {
    my ( $self, $url, $form ) = @_;
    for ( 1 .. $self->attempts ) {
        my $content = $self->obj->post( $url, $form, $self->referer );
        return $self->content_sub->($content) if $content;
    }
}

1;

