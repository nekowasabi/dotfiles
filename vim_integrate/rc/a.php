<?php

class A
{
    public function __construct()
    {
        echo 'A';
    }

    public function test()
    {
        echo 'test';
    }
}

$obj = new A();
$obj->test();
