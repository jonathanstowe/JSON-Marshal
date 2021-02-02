#!raku

use v6;
use Test;

use JSON::Marshal;
use JSON::Fast;

subtest {
    class VersionClassCode {
        has Version $.version is marshalled-by(-> Version $v { $v.defined ?? $v.Str !! Nil });
    }

    my VersionClassCode $obj = VersionClassCode.new(version => Version.new("0.0.1"));

    my $json;


    lives-ok { $json = marshal($obj) }, "marshall with attribute trait (code)";

    my $parsed;
    lives-ok { $parsed = from-json($json) }, "parse the resulting JSON";

    ok $parsed.defined, "got something back";
    is $parsed<version>, "0.0.1", "and has the right value";

    $obj = VersionClassCode.new;

    lives-ok { $json = marshal($obj) }, "marshall with attrbute trait (code) but attribute not defined";
    lives-ok { $parsed = from-json($json) }, "got sensible JSON back";
    ok $parsed.defined, "got something back";
    ok $parsed<version>:exists, "got the key";
    ok !$parsed<version>.defined, "and has the right value (Nil)";

}, "marshalled-by trait with Code";
subtest {
    class VersionClassMethod {
        has Version $.version is marshalled-by('Str');
    }

    my VersionClassMethod $obj = VersionClassMethod.new(version => Version.new("0.0.1"));

    my $json;
    lives-ok { $json = marshal($obj) }, "marshall with attrbute trait (method name)";

    my $parsed;

    lives-ok { $parsed = from-json($json) }, "got sensible JSON back";

    ok $parsed.defined, "got something back";
    is $parsed<version>, "0.0.1", "and has the right value";

    $obj = VersionClassMethod.new;

    lives-ok { $json = marshal($obj) }, "marshall with attrbute trait (method name) but attribute not defined";
    lives-ok { $parsed = from-json($json) }, "got sensible JSON back";
    ok $parsed.defined, "got something back";
    ok $parsed<version>:exists, "got the key";
    ok !$parsed<version>.defined, "and has the right value (Nil)";


}, "marshalled-by trait with Method name";

done-testing;
# vim: expandtab shiftwidth=4 ft=raku
