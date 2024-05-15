<?php

class A
{
    /**
     * Calculate Fibonacci number
     */
    public function fibonacci(int $n): int
    {
        if ($n <= 0) {
            return 0;
        } elseif ($n === 1) {
            return 1;
        } else {
            return $this->fibonacci($n - 1) + $this->fibonacci($n - 2);
        }
    }

    /**
     * hello
     */
    public function aaa(): void
    {
        echo 'aaa';
    }
}
$obj = new A();
echo $obj->fibonacci(10); // Example usage of fibonacci method
$obj->aaa();
