#!/usr/bin/env raku

use Test;
use JSON::Marshal;
use JSON::Name;
use JSON::OptIn;
use JSON::Fast;

plan 11;

class TestOptin {
    has Str $.secret = 'secret';
    has Str $.public                is json  = 'public';
    has Str $.skipped               is json-skip = 'skipped';
    has Str $.null                  is json-skip-null;
    has Str $.nullable              is json-skip-null = 'nullable';
    has DateTime $.marshalled       is marshalled-by('Str') = DateTime.now;
    has DateTime $.marshalled-sub   is marshalled-by(-> $v { $v.Str }) = DateTime.now;
    has Str      $.named            is json-name('zubzub') = 'named';
    has Real     $!half-priv        is json = 42;
    has Real     $!priv-built       is built = 13;
}

my Str $json;

lives-ok { $json = marshal(TestOptin.new, :opt-in) }, "marshal() with opt-in";

my %data = from-json($json);

is %data<public>, 'public', "explicitly opted in";
ok %data<secret>:!exists, "not opted-in at all";
ok %data<skipped>:!exists, "skipped";
ok %data<null>:!exists, "skip-null";
ok %data<priv-built>:!exists, "is built but not opted-in";
is %data<nullable>, 'nullable', 'skip-null with value';
ok %data<marshalled>:exists, "marshalled-by implicit opt-in (method)";
ok %data<marshalled-sub>:exists, "marshalled-by implicit opt-in (sub)";
is %data<zubzub>, 'named', 'json-name implicit opt-in';
is %data<half-priv>, 42, 'opted-in private';


done-testing;
# vim: ft=raku
