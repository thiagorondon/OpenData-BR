
package OpenData::Log;

use Moose::Role;
use Class::MOP ();

our @levels = qw[ debug info warn error fatal ];
our %LEVELS = ();
our %LEVEL_MATCH = ();

has level => ( is => 'rw' );

{
    my $meta = Class::MOP::get_metaclass_by_name(__PACKAGE__);
    my $summed_level = 0;

    for (my $i = $#levels ; $i >= 0 ; $i--) {
        my $name = $levels[$i];

        my $level = 1 << $i;
        $summed_level |= $level;

        $LEVELS{$name} = $level;
        $LEVEL_MATCH{$name} = $summed_level;

        $meta->add_method($name, sub {
            my $self = shift;

            if ( $self->level & $level ) {
                $self->_log( $name, @_ );
            }
        });

        $meta->add_method("is_$name", sub {
            my $self = shift;
            return $self->level & $level;
        });
    }

}

sub BUILD {
    my $self = shift;
    $self->enable(@levels);
}

sub enable {
    my ( $self, @levels ) = @_;
    my $level = 0;
    for (map { $LEVEL_MATCH{$_} } @levels) {
        $level |= $_;
    }
    $self->level($level);
}


sub _log {
    my $self = shift;
    my $level = shift;
    my $message = join( "\n", @_ );
    printf( "[%s] %s\n", $level, $message );
}

#no Moose;
#__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__

=head1 NOME

OpenData::Log - Classe para log do OpenData.

=head1 SINOPSE

    $SIG{__WARN__} = sub { Log->warn(@_) };

=head1 AUTORES, LICENÇA e COPYRIGHT

Veja OpenData.pm

=cut

