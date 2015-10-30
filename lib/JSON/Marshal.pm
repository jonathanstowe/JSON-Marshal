use v6;

module JSON::Marshal {

    use JSON::Tiny;

    
    multi sub _marshal(Cool $value) {
        $value;
    }

    multi sub _marshal(%obj) returns Hash {
        my %ret;

        for %obj.kv -> $key, $value {
            %ret{$key} = _marshal($value);
        }

        %ret;
    }

    multi sub _marshal(@obj) returns Array {
        my @ret;

        for @obj -> $item {
            @ret.push(_marshal($item));
        }
        @ret;
    }
    
    multi sub _marshal(Mu $obj) returns Hash {
        my %ret;
        for $obj.^attributes -> $attr {
            if $attr.has-accessor {
                my $name = $attr.name.substr(2); # lose the sigil
                %ret{$name} = _marshal($attr.get_value($obj));
            }
        }
        %ret;
    }

    sub marshal(Any $obj) returns Str is export {
        my $ret = _marshal($obj);
        to-json($ret);
    }
}
# vim: expandtab shiftwidth=4 ft=perl6
