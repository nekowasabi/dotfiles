<?php

class A
{
    public function aaa()
    {
        echo 'aaa';
    }

    public function fibonacci($n)
    {
        if ($n <= 1) {
            return $n;
        } else {
            return $this->fibonacci($n - 1) + $this->fibonacci($n - 2);
        }
    }
}
$obj = new A();
