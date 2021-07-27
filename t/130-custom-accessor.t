#!/usr/bin/env raku

use Test;
use JSON::Marshal;
use JSON::Fast;

class CustomAttr {
    has Int $.int = 10;

    has Str $.string;

    method string( --> Str ) {
        "TESTSTRING";
    }

}

my $obj = CustomAttr.new;

my $json = marshal($obj);
my $data = from-json($json);

is $data<int>, $obj.int, "got the right value for straight accessor";
is $data<string>, $obj.string, "got the right value for custom accessor";

done-testing;
# vim: ft=raku
