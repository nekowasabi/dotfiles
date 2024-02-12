<?php

use PHPUnit\Framework\TestCase;

require_once 'a.php';

class MyArrayToolsTest extends TestCase {
    /**
     * Data provider for testExtractOddNumbers.
     * 以下のテストケースで奇数の抽出をテストします。
     * - 基本的な奇数と偶数が混在する配列
     * - 奇数のみを含む配列
     * - 偶数のみを含む配列（結果は空の配列）
     * - 空の配列（結果は空の配列）
     */
    public function oddNumberProvider() {
        return [
            // 基本的な奇数と偶数が混在する配列
            [[1, 2, 3, 4, 5], [1, 3, 5]],
            // 奇数のみを含む配列
            [[10, 15, 20, 25], [15, 25]],
            // 偶数のみを含む配列（結果は空の配列）
            [[2, 4, 6, 8], []],
            // 空の配列（結果は空の配列）
            [[1, 3, 5], [1, 3, 5]]
        ];
    }

    /**
     * @dataProvider oddNumberProvider
     * @test
     */
    public function testExtractOddNumbers($array, $expected) {
        $result = MyArrayTools::extractOddNumbers($array);
        $this->assertEquals($expected, $result);
    }
}
