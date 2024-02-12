<?php

/**
 * MyArrayTools クラス
 * 配列に対するユーティリティ関数を提供します。
 */
class MyArrayTools {
    /**
     * 配列から奇数を抽出します。
     *
     * @param array $array 奇数を抽出する元の配列
     * @return array 奇数のみを含む配列
     */
    public static function extractOddNumbers($array) {
        return array_filter($array, function ($value) {
            return $value % 2;
        });
    }
}
