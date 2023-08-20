#!/usr/bin/env raku

unit module Deepgrep:ver<0.1.4>:auth<zef:elcaro>;

proto deepgrep(|) is export { * }

multi deepgrep($xs, Regex $t, *%_) {
    deepgrep($xs, * ~~ $t, |%_)
}

multi deepgrep($xs, Callable $t, :$p!) {
    $xs.kv.map: -> $i, $x {
        if $x ~~ Iterable {
            |&?ROUTINE($x, $t, :p).map: {
                ($i, |.key) => .value
            }
        }
        elsif $t($x) {
            $i => $x
        }
    }
}

multi deepgrep($xs, Callable $t) {
    deepgrep($xs, $t, :p).map(*.value)
}

multi deepgrep($xs, Callable $t, :$k!) {
    deepgrep($xs, $t, :p).map(*.key)
}

multi deepgrep($xs, Callable $t, :$kv!) {
    deepgrep($xs, $t, :p).map(|*.kv)
}

multi deepgrep($xs, Bool:D $t, *%_) {
    X::Match::Bool.new(type => '&deepgrep').throw
}

multi deepgrep($xs, Mu $t, *%_) {
    deepgrep($xs, * ~~ $t, |%_)
}
