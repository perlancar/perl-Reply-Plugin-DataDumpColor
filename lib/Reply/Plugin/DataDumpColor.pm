package Reply::Plugin::DataDumpColor;

# DATE
# VERSION

use strict;
use warnings;

use base 'Reply::Plugin';

use Data::Dump::Color 'dump';
use overload ();

sub new {
    my $class = shift;
    my %opts = @_;
    $opts{respect_stringification} = 1
        unless defined $opts{respect_stringification};

    my $self = $class->SUPER::new(@_);
    $self->{filter} = sub {
        my ($ctx, $ref) = @_;
        return unless $ctx->is_blessed;
        my $stringify = overload::Method($ref, '""');
        return unless $stringify;
        return {
            dump => $stringify->($ref),
        };
    } if $opts{respect_stringification};

    return $self;
}

sub mangle_result {
    local $Data::Dump::Color::COLOR = 1;

    my $self = shift;
    my (@result) = @_;
    # Data::Dump::Color currently does not support filtering
    #return @result ? dumpf(@result, $self->{filter}) : ();
    return @result ? dump(@result) : ();
}

1;
# ABSTRACT: Format results using Data::Dump::Color

=head1 SYNOPSIS

 ; .replyrc
 [DataDumpColor]

=head1 DESCRIPTION

This is like L<Reply::Plugin::DataDump> except using L<Data::Dump::Color>
instead of L<Data::Dump>.
