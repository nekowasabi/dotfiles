<?php

// extract odd number from array
$sample_array = [1, 2, 3, 4, 5];

$extracted = array_filter($sample_array, function ($value) {
    return $value % 2;
});

var_dump($extracted);
