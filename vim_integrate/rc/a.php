<?php

function fibonatti($n)
{
    if ($n <= 0) {
        return [];
    }
    $fib = [0, 1];
    for ($i = 2; $i < $n; $i++) {
        $fib[] = $fib[$i - 1] + $fib[$i - 2];
    }

    return $fib;
}
