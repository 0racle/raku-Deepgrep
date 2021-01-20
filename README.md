# Deepgrep

Grep elements inside nested iterables.

## USAGE

    use Deepgrep;

    my @xs = (
        [< a  b  c  d >],
        [< e  f* g  h >],
        [< i  j* k  l >],
        [< m  n  o  p >],
    );

    say deepgrep(@xs, *.ends-with('*')).raku;
    # ("f*", "j*")

    say deepgrep(@xs, *.ends-with('*'), :k).raku;
    # ((1, 1), (2, 1)).Seq

    say deepgrep(@xs, *.ends-with('*'), :kv).raku;
    # ((1, 1), "f*", (2, 1), "j*").Seq

    say deepgrep(@xs, *.ends-with('*'), :p).raku;
    # ((1, 1) => "f*", (2, 1) => "j*").Seq
    
## NOTES

Similar to [`deepmap`](https://docs.raku.org/routine/deepmap), this function will descend into any Iterables. It returns a flattened list of values that match the given predicated.

You might think that like `deepmap`, the nesting structure should be maintained, but that functionality can already be achieved with `deepmap`

    say @xs.deepmap(-> $x { $x if $x.ends-with('*') }).raku;
    # [[], ["f*"], ["j*"], []]

However `deepmap` cannot return keys (indices), or pairs, etc. Getting the indicies is also useful if you want to modify deeply nested mutable elements in-place

    for deepgrep(@xs, *.ends-with('*'), :k) -> ($x, $y) {
        @xs[$x;$y] .= chop
    }

This extends down to deeper nested structures as expected

    my @zs = [
        [
            ['a', 'b'], ['c', 'd'],
            ['e', 'F'], ['g', 'h'],
        ],
        [
            ['i', 'J'], ['k', 'l'],
            ['m', 'n'], ['o', 'p'],
        ]
    ];

    for @zs.&deepgrep(* ~~ /<:Lu>/, :k) -> ($x, $y, $z) {
        @zs[$x;$y;$z] .= lc
    }


## CAVEATS & LIMITATIONS

It would be much nice if Raku had support for Semilist syntax on Iterables, which would allow this

    for @zs.&deepgrep(* ~~ /<:Lu>/, :k) -> @idx {
        @zs[||@idx] .= lc  # Unsupported syntax
    }

Semilist support for Associatives was recently added for v6.e.PREVIEW, so hopefully Iterables will support this syntax when 6e is released.

For now you will have to manually unpack your indices and index into the array, which means the shape must be uniform (ie. a M×N matrix).

## LICENSE

    The Artistic License 2.0

See LICENSE file in the repository for the full license text.
