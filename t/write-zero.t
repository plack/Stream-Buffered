#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Stream::Buffered;

{
    local $Stream::Buffered::MaxMemoryBufferSize = -1;
    my $b = Stream::Buffered->new;
    ok $b->print(0), "Writing returns true with PerlIO";
    _is_zero($b);
}

{
    local $Stream::Buffered::MaxMemoryBufferSize = 0;
    my $b = Stream::Buffered->new;
    ok $b->print(0), "Writing returns true with temp file";
    _is_zero($b);
}

{
    # auto
    my $b = Stream::Buffered->new;
    ok $b->print(0), "Writing returns true with auto";
    _is_zero($b);
}

{
    # auto with max
    local $Stream::Buffered::MaxMemoryBufferSize = 3;
    my $b = Stream::Buffered->new;
    for (1..4) {
        ok $b->print(0), "Writing returns true with auto";
    }
    my $fh = $b->rewind;
    is do { local $/; <$fh> }, '0' x 4, "Buffer content OK";
}



sub _is_zero {
    my $b = shift;
    my $fh = $b->rewind;
    is do { local $/; <$fh> }, '0', "Buffer content is zero";
}

done_testing;
