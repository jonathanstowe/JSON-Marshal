#!perl6

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

my $ret;

lives-ok { $ret = marshal($outer, :sorted-keys, :pretty) }, "pretty-marshal object doesn't fail";

is $ret, '{
  "bool": true,
  "int": 42,
  "str-array": [
    "one",
    "two",
    "three"
  ],
  "string": "string"
}', "marshalled JSON is pretty";

lives-ok { $ret = marshal($outer, :sorted-keys, :!pretty) }, "compact-marshal object";
is $ret, '{"bool":true,"int":42,"str-array":["one","two","three"],"string":"string"}', "marshalled JSON is compact";

done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
