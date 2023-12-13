<?php

// extract odd numbers from array
$sample = [1, 2, 3, 4, 5, 6, 7, 8, 9];

$extracted = array_filter($sample, function ($value) {
    return $value % 2;
});

var_dump($extracted);
