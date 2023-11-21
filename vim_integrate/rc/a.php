<?php

// Class for fizzbuzz
class FizzBuzz
{
    private $n;

    public function __construct($n)
    {
        $this->n = $n;
    }

    public function get()
    {
        $this->ccc();
    }

    private function ccc()
    {
        if ($this->n % 3 == 0 && $this->n % 5 == 0) {
            return 'FizzBuzz';
        } elseif ($this->n % 3 == 0) {
            return 'Fizz';
        } elseif ($this->n % 5 == 0) {
            return 'Buzz';
        } else {
            return $this->n;
        }
    }
}

$fizzbuzz = new FizzBuzz(15);
echo $fizzbuzz->get();
