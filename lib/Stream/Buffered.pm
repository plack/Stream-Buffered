package Stream::Buffered;
use strict;
use warnings;

use FileHandle; # for seek etc.
use Module::Runtime 'use_module';

our $MaxMemoryBufferSize = 1024 * 1024;

sub new {
    my($class, $length) = @_;

    # $MaxMemoryBufferSize = 0  -> Always temp file
    # $MaxMemoryBufferSize = -1 -> Always PerlIO
    my $backend;
    if ($MaxMemoryBufferSize < 0) {
        $backend = "PerlIO";
    } elsif ($MaxMemoryBufferSize == 0) {
        $backend = "File";
    } elsif (!$length) {
        $backend = "Auto";
    } elsif ($length > $MaxMemoryBufferSize) {
        $backend = "File";
    } else {
        $backend = "PerlIO";
    }

    $class->create($backend, $length, $MaxMemoryBufferSize);
}

sub create {
    my($class, $backend, $length, $max) = @_;
    use_module("${class}::${backend}")->new($length, $max);
}

sub print;
sub rewind;
sub size;

1;

__END__

=head1 NAME

Stream::Buffered - temporary buffer to save bytes

=head1 SYNOPSIS

  my $buf = Stream::Buffered->new($length);
  $buf->print($bytes);

  my $size = $buf->size;
  my $fh   = $buf->rewind;

=head1 DESCRIPTION

Stream::Buffered is a buffer class to store arbitrary length of byte
strings and then get a seekable filehandle once everything is
buffered. It uses PerlIO and/or temporary file to save the buffer
depending on the length of the size.

=head1 SEE ALSO

L<Plack::Request>

=cut
