#!/usr/bin/env python3
"""Fixtures for tmux copy-filter."""

import sys
import unittest
from importlib.machinery import SourceFileLoader
from pathlib import Path

_path = Path(__file__).with_name("copy-filter")
_mod = SourceFileLoader("copy_filter", str(_path)).load_module()
sys.modules["copy_filter"] = _mod
filter_text = _mod.filter_text


class CopyFilterTest(unittest.TestCase):
    def test_wrapped_url_with_padding(self) -> None:
        src = "  https://example.com/very/long\n  /path?x=1\n"
        self.assertEqual(filter_text(src), "https://example.com/very/long/path?x=1\n")

    def test_wrapped_url_mid_token(self) -> None:
        src = "  https://example.com/filena\n  me.ts"
        self.assertEqual(filter_text(src), "https://example.com/filename.ts")

    def test_url_trailing_spaces_from_tmux_pad(self) -> None:
        src = "  https://example.com/foo   \n  /bar\n"
        self.assertEqual(filter_text(src), "https://example.com/foo/bar\n")

    def test_code_keeps_relative_indent(self) -> None:
        src = "    def foo():\n        return 1\n"
        self.assertEqual(filter_text(src), "def foo():\n    return 1\n")

    def test_single_line_unchanged(self) -> None:
        self.assertEqual(filter_text("  hello"), "  hello")

    def test_intentional_indent_preserved(self) -> None:
        src = "title\n    indented\n"
        self.assertEqual(filter_text(src), src)

    def test_paragraph_not_joined(self) -> None:
        src = "See https://example.com/foo\nand then do this\n"
        self.assertEqual(filter_text(src), src)

    def test_empty(self) -> None:
        self.assertEqual(filter_text(""), "")


if __name__ == "__main__":
    unittest.main()
