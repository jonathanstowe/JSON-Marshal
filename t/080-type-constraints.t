#!/usr/bin/env raku

use Test;

use JSON::Marshal;
use JSON::Fast;

my class TestClassConstraint {
    has $.depends is rw where Positional|Associative;
}

my $obj;

lives-ok { $obj = TestClassConstraint.new }, "create object with anonymous constraint (no arguments)";

my $json;

lives-ok {
    $json =  marshal($obj) ;
}, "marshal that";

my $parsed;

lives-ok { $parsed = from-json($json) }, "got some sane JSON";

ok $parsed<depends>:exists, "and we got the expected key";
ok !$parsed<depends>.defined, "and is 'null' as expected";

lives-ok { $obj = TestClassConstraint.new(depends => ['foo'] ) }, "create object with anonymous constraint positional argument";

lives-ok {
    $json =  marshal($obj) ;
}, "marshal that";

lives-ok { $parsed = from-json($json) }, "got some sane JSON";

ok $parsed<depends>:exists, "and we got the expected key";
ok $parsed<depends> ~~ Positional, "and is a Positional as expected";

lives-ok { $obj = TestClassConstraint.new(depends => { foo => 'bar' } ) }, "create object with anonymous constraint associative argument";

lives-ok {
    $json =  marshal($obj) ;
}, "marshal that";

lives-ok { $parsed = from-json($json) }, "got some sane JSON";

ok $parsed<depends>:exists, "and we got the expected key";
ok $parsed<depends> ~~ Associative, "and is a Associative as expected";
is $parsed<depends><foo>, 'bar' , "with the  expected value";


done-testing;
# vim: ft=raku
