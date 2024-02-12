<?php

use PHPUnit\Framework\TestCase;

require_once 'a.php';

class MyArrayToolsTest extends TestCase {
    public function testExtractOddNumbers() {
        $array = [1, 2, 3, 4, 5];
        $expected = [1, 3, 5];
        $result = MyArrayTools::extractOddNumbers($array);
        $this->assertEquals($expected, $result);
    }
}
