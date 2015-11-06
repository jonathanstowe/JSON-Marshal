use v6;

=begin pod

=head1 NAME

JSON::Marshal - Make JSON from an Object.

=head1 SYNOPSIS

=begin code
    use JSON::Marshal;

    class SomeClass {
      has Str $.string;
      has Int $.int;
    }

    my $object = SomeClass.new(string => "string", int => 42);


    my Str $json = marshal($object); # -> "{ "string" : "string", "int" : 42 }'

=end code

=head1 DESCRIPTION

This provides a single exported subroutine to create a JSON representation
of an object.  It should round trip back into an object of the same class
using L<JSON::Unmarshal|https://github.com/tadzik/JSON-Unmarshal>.

It only outputs the "public" attributes (that is those with accessors
created by declaring them with the '.' twigil. Attributes without acccessors
are ignored.

This is intended to work with objects of arbitrary classes without changes,
though clearly some loss of fidelity may occur as JSON may not carry all
the information that a Perl 6 class can.

=end pod

module JSON::Marshal:ver<v0.0.2>:auth<github:jonathanstowe> {

    use JSON::Tiny;


    role CustomMarshaller {
        method marshal($value, Mu:D $object) {
            ...
        }
    }

    role CustomMarshallerCode does CustomMarshaller {
        has &.marshaller is rw;

        method marshal($value, Mu:D $object) {
            # the dot below is important otherwise it refers
            # to the accessor method
            self.marshaller.($value);
        }
    }

    role CustomMarshallerMethod does CustomMarshaller {
        has Str $.marshaller is rw;
        method marshal($value, Mu:D $type) {
            my $meth = self.marshaller;
            $value."$meth"();
        }
    }

    multi sub trait_mod:<is> (Attribute $attr, :&marshalled-by!) is export {
        $attr does CustomMarshallerCode;
        $attr.marshaller = &marshalled-by;
    }

    multi sub trait_mod:<is> (Attribute $attr, Str:D :$marshalled-by!) is export {
        $attr does CustomMarshallerMethod;
        $attr.marshaller = $marshalled-by;
    }
    
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
                my $value = $attr.get_value($obj);
                %ret{$name} = do if $attr ~~ CustomMarshaller {
                    $attr.marshal($value, $obj);
                }
                else {
                    _marshal($value);
                }

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
