#!/usr/bin/env raku


use Test;

use JSON::Marshal;

my class TestClass22 {
    has Version $.perl-version is rw is marshalled-by('Str') is json-name('perl');
}

my $obj;

lives-ok { $obj = TestClass22.new }, "create object with json-name and marshalled-by attribute not provided";

my $json;

lives-ok { $json = marshal($obj) }, "and try to marshal it";


done-testing;

# vim: ft=raku
