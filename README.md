# JSON::Marshal

Make JSON from an Object (the opposite of JSON::Unmarshal)

## Synopsis

```
    use JSON::Marshal;

    class SomeClass {
      has Str $.string;
      has Int $.int;
    }

    my $object = SomeClass.new(string => "string", int => 42);


    my Str $json = marshal($object); # -> "{ "string" : "string", "int" : 42 }'

```

## Description

This provides a single exported subroutine to create a JSON representation
of an object.  It should round trip back into an object of the same class
using [JSON::Unmarshal](https://github.com/tadzik/JSON-Unmarshal).

It only outputs the "public" attributes (that is those with accessors
created by declaring them with the '.' twigil. Attributes without acccessors
are ignored.

This is intended to work with objects of arbitrary classes without changes,
though clearly some loss of fidelity may occur as JSON may not carry all
the information that a Perl 6 class can.

## Installation

Assuming you have a working perl6 installation you should be able to
install this with *ufo* :

    ufo
    make test
    make install

*ufo* can be installed with *panda* for rakudo:

    panda install ufo

Or you can install directly with "panda":

    # From the source directory
   
    panda install .

    # Remote installation

    panda install JSON::Marshal

Other install mechanisms may be become available in the future.

## Support

This should be considered experimental software until such time that
Perl 6 reaches an official release.  However suggestions/patches are
welcomed via github at

   https://github.com/jonathanstowe/JSON-Marshal

## Licence

Please see the LICENCE file in the distribution

(C) Jonathan Stowe 2015

