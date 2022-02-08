NAME
====

Deepgrep - Grep elements inside nested iterables.

SYNOPSIS
========

```raku
use Deepgrep;

my @xs = (
    [< a  b  c  d >],
    [< e  f* g  h >],
    [< i  j* k  l >],
    [< m  n  o  p >],
);

say deepgrep(@xs, *.ends-with('*')).raku;
# ("f*", "j*").Seq

say deepgrep(@xs, *.ends-with('*'), :k).raku;
# ((1, 1), (2, 1)).Seq

say deepgrep(@xs, *.ends-with('*'), :kv).raku;
# ((1, 1), "f*", (2, 1), "j*").Seq

say deepgrep(@xs, *.ends-with('*'), :p).raku;
# ((1, 1) => "f*", (2, 1) => "j*").Seq
```
    
NOTES
=====

Similar to [`deepmap`](https://docs.raku.org/routine/deepmap), this function will descend into Iterables. It returns a flattened list of values that match the given predicate.

You might think that like `deepmap`, the nesting structure should be maintained, but that functionality can already be achieved with `deepmap`

```raku
say @xs.deepmap(-> $x { $x if $x.ends-with('*') }).raku;
# [[], ["f*"], ["j*"], []]
```

However `deepmap` cannot return keys (indices), or pairs, etc. Getting the indicies is useful if you want to modify deeply nested mutable elements in-place

```raku
for deepgrep(@xs, *.ends-with('*'), :k) -> ($x, $y) {
    @xs[$x;$y] .= chop
}
```

This extends down to deeper nested structures as expected

```raku
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

for @zs.&deepgrep(/<:Lu>/, :k) -> ($x, $y, $z) {
    @zs[$x;$y;$z] .= lc
}
```

CAVEATS & LIMITATIONS
=====================

If you are running under v6.e, Raku has support for Semilist syntax on Iterables, which allows this

```raku
use v6.e.PREVIEW;

for @zs.&deepgrep(/<:Lu>/, :k) -> @idx {
    @zs[||@idx] .= lc
}
```

Without Semilist support, you will have to manually unpack your indices and index into the array, which means the shape should be uniform (eg. a M×N matrix).

LICENSE
=======

    The Artistic License 2.0

See LICENSE file in the repository for the full license text.
