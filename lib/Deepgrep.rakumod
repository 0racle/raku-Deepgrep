#!/usr/bin/env raku

proto deepgrep($, $, *%_) is export { * }

multi deepgrep($xs, &f, :$p!) {
    $xs.kv.map: -> $i, $x {
        if $x ~~ Iterable {
            |deepgrep($x, &f, :p).map: {
                ($i, |.key) => .value
            }
        }
        elsif f($x) {
            $i => $x
        }
    }
}

multi deepgrep($xs, &f) {
    deepgrep($xs, &f, :p).map(*.value)
}

multi deepgrep($xs, &f, :$k!) {
    deepgrep($xs, &f, :p).map(*.key)
}

multi deepgrep($xs, &f, :$kv!) {
    deepgrep($xs, &f, :p).map(|*.kv)
}
