#!raku

use v6;
use Test;

use JSON::Marshal;
use JSON::Fast;

plan 4;

class Outer {
    has Bool $.bool = True;
    has Str  $.string = "string";
    has Str  @.str-array = <one two three>;
    has Int  $.int = 42;
    has $!private = 'private';
}

my $outer = Outer.new;

# Structure that we expect to be serialised
my %exp = (
    bool        => True,
    string      => 'string',
    str-array   => <one two three>,
    int         => 42,
);

my $ret;


# This isn't for testing the output of the JSON::Fast to-json but rather that the switches are
# passed on correctly. Don't want to be a canary for a regression in JSON::Fast
lives-ok { $ret = marshal($outer, :sorted-keys, :pretty) }, "pretty-marshal object doesn't fail";

is $ret, to-json(%exp, :sorted-keys, :pretty), "marshalled JSON is pretty";

lives-ok { $ret = marshal($outer, :sorted-keys, :!pretty) }, "compact-marshal object";
is $ret, to-json(%exp, :sorted-keys, :!pretty ), "marshalled JSON is compact";

done-testing;
# vim: expandtab shiftwidth=4 ft=raku
