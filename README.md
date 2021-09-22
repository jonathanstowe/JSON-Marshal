# JSON::Marshal

Make JSON from an Object (the opposite of JSON::Unmarshal)

![Build Status](https://github.com/jonathanstowe/JSON-Marshal/workflows/CI/badge.svg)

## Synopsis

```raku

   use JSON::Marshal;

    class SomeClass {
      has Str $.string;
      has Int $.int;
      has Version $.version is marshalled-by('Str');
    }

    my $object = SomeClass.new(string => "string", int => 42, version => Version.new("0.0.1"));


    my Str $json = marshal($object); # -> "{ "string" : "string", "int" : 42, "version" : "0.0.1" }'


```

Or with _opt-in_ marshalling:

```raku
    use JSON::Marshal;
    use JSON::OptIn;

    class SomeClass {
      has Str $.string is json;
      has Int $.int    is json;
      has Str $.secret;
      has Version $.version is marshalled-by('Str');
    }

    my $object = SomeClass.new(secret => "secret", string => "string", int => 42, version => Version.new("0.0.1"));


    my Str $json = marshal($object, :opt-in); # -> "{ "string" : "string", "int" : 42, "version" : "0.0.1" }'

```

## Description

This provides a single exported subroutine to create a JSON representation
of an object.  It should round trip back into an object of the same class
using [JSON::Unmarshal](https://github.com/tadzik/JSON-Unmarshal).

It only outputs the "public" attributes (that is those with accessors
created by declaring them with the '.' twigil. Attributes without acccessors
are ignored.


If you want to ignore any attributes without a value you can use the
```:skip-null``` adverb to ```marshal```, which will supress the
marshalling of any undefined attributes.  Additionally if you want a
finer-grained control over this behaviour there is a 'json-skip-null'
attribute trait which will cause the specific attribute to be skipped
if it isn't defined irrespective of the ```skip-null```. If
you want to always explicitly suppress the marshalling of an attribute then
the the trait `json-skip` on an attribute will prevent it being output
in the JSON.

By default *all* public attributes will be candidates to be marshalled to JSON,
which may not be convenient for all applications (for example only a small
number of attributes should be marshalled in a large class,) so the `marshal`
provides an `:opt-in` adverb that inverts the behaviour so that only those
attributes which have one of the traits that control marshalling
(with the exception of `json-skip`,) will be candidates.  The `is json` trait
from [JSON::OptIn](https://github.com/jonathanstowe/JSON-OptIn) can be supplied to 
an attribute to mark it for marshalling explicitly, (it is implicit in all the 
other traits bar `json-skip`.)


To allow a finer degree of control of how an attribute is marshalled an
attribute trait ```is marshalled-by``` is provided, this can take either
a Code object (an anonymous subroutine,) which should take as an argument
the value to be marshalled and should return a value that can be completely
represented as JSON, that is to say a string, number or boolean or a Hash
or Array who's values are those things. Alternatively the name of a method
that will be called on the value, the return value being constrained as
above.

By default the JSON produced is _pretty_ (that is newlines and indentation,) 
which is nice for humans to read but has a lot of superfluous characters in
it, this can be controlled by passing `:!pretty` to `marshal`.

## Installation

Assuming you have a working Rakudo installation, you can install this with ```zef``` :

    # From the source directory
   
    zef install .

    # Remote installation

    zef install JSON::Marshal


## Support

Suggestions/patches are welcomed via github at

https://github.com/jonathanstowe/JSON-Marshal/issues

## Licence

Please see the [LICENCE](LICENCE) file in the distribution

© Jonathan Stowe 2015, 2016, 2017, 2018, 2019, 2020, 2021
