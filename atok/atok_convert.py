#!/usr/bin/env python3
"""
ATOK35 ローマ字設定コンバーター
テキストファイル（一覧出力）から StUser0.plist の ローマ字 バイナリを生成する

Format (tag_RomaKanaInfo, Big-Endian):
  Header  (8 bytes)    : uint32 entry_count, uint32 magic=0x01000002
  Section A (384 bytes): 192 uint16 - first_char lookup: A[(ch-32)*2]=start, A[(ch-32)*2+1]=count
  Section B (4000 bytes): 1000 entries × {uint16 c_offset, uint8 in_len, uint8 out_len}
  Section C (12000 bytes): 6000 uint16 - flat (input_chars..., output_halfwidth_kana...)
"""
import plistlib, struct, shutil
from pathlib import Path

STYLE_FILE = Path('/Users/takets/Library/Preferences/ATOK35/Styles/StUser0.plist')
TEXT_FILE  = Path('/Users/takets/Library/CloudStorage/Dropbox/default(ローマ字出力).txt')

DBL_MARK = 0x001F  # 二重子音マーカー (bb→っb 等)
HW_SOKUON = 0xFF6F  # ｯ

# ひらがな・カタカナ → 半角カタカナ変換テーブル
KANA_TO_HW = {}

def _add(src, *hw_codepoints):
    KANA_TO_HW[src] = list(hw_codepoints)

# 基本ひらがな → 半角カタカナ（1対1）
for h, hw in [
    ('ぁ','ｧ'),('あ','ｱ'),('ぃ','ｨ'),('い','ｲ'),('ぅ','ｩ'),('う','ｳ'),
    ('ぇ','ｪ'),('え','ｴ'),('ぉ','ｫ'),('お','ｵ'),
    ('か','ｶ'),('き','ｷ'),('く','ｸ'),('け','ｹ'),('こ','ｺ'),
    ('さ','ｻ'),('し','ｼ'),('す','ｽ'),('せ','ｾ'),('そ','ｿ'),
    ('た','ﾀ'),('ち','ﾁ'),('っ','ｯ'),('つ','ﾂ'),('て','ﾃ'),('と','ﾄ'),
    ('な','ﾅ'),('に','ﾆ'),('ぬ','ﾇ'),('ね','ﾈ'),('の','ﾉ'),
    ('は','ﾊ'),('ひ','ﾋ'),('ふ','ﾌ'),('へ','ﾍ'),('ほ','ﾎ'),
    ('ま','ﾏ'),('み','ﾐ'),('む','ﾑ'),('め','ﾒ'),('も','ﾓ'),
    ('ゃ','ｬ'),('や','ﾔ'),('ゅ','ｭ'),('ゆ','ﾕ'),('ょ','ｮ'),('よ','ﾖ'),
    ('ら','ﾗ'),('り','ﾘ'),('る','ﾙ'),('れ','ﾚ'),('ろ','ﾛ'),
    ('ゎ','ﾜ'),('わ','ﾜ'),('を','ｦ'),('ん','ﾝ'),
]:
    _add(h, ord(hw))

# 濁音ひらがな → 2文字
for h, hw in [
    ('が','ｶ'),('ぎ','ｷ'),('ぐ','ｸ'),('げ','ｹ'),('ご','ｺ'),
    ('ざ','ｻ'),('じ','ｼ'),('ず','ｽ'),('ぜ','ｾ'),('ぞ','ｿ'),
    ('だ','ﾀ'),('ぢ','ﾁ'),('づ','ﾂ'),('で','ﾃ'),('ど','ﾄ'),
    ('ば','ﾊ'),('び','ﾋ'),('ぶ','ﾌ'),('べ','ﾍ'),('ぼ','ﾎ'),
    ('ゔ','ｳ'),
]:
    _add(h, ord(hw), 0xFF9E)  # + ﾞ

# 半濁音ひらがな → 2文字
for h, hw in [
    ('ぱ','ﾊ'),('ぴ','ﾋ'),('ぷ','ﾌ'),('ぺ','ﾍ'),('ぽ','ﾎ'),
]:
    _add(h, ord(hw), 0xFF9F)  # + ﾟ

# カタカナ版も追加（ひらがな - 0x60 = カタカナ）
for hira_code in range(0x3041, 0x3097):
    hira_ch = chr(hira_code)
    kata_ch = chr(hira_code + 0x60)
    if hira_ch in KANA_TO_HW:
        KANA_TO_HW[kata_ch] = KANA_TO_HW[hira_ch]

KANA_TO_HW['ー'] = [0xFF70]   # 長音符
KANA_TO_HW['\u30F4'] = [0xFF73, 0xFF9E]  # ヴ → ｳﾞ
KANA_TO_HW['\u30F5'] = [0xFF76]          # ヵ (小書きカタカナ KA)
KANA_TO_HW['\u30F6'] = [0xFF79]          # ヶ (小書きカタカナ KE)
KANA_TO_HW['\u309B'] = [0xFF9E]          # ゛ (全角結合濁点) → 半角ﾞ
KANA_TO_HW['\u309C'] = [0xFF9F]          # ゜ (全角結合半濁点) → 半角ﾟ


def to_hw(kana_str):
    result = []
    for ch in kana_str:
        if ch in KANA_TO_HW:
            result.extend(KANA_TO_HW[ch])
        elif 0xFF61 <= ord(ch) <= 0xFF9F:
            result.append(ord(ch))
        else:
            print(f"  WARNING: 未知のかな文字 U+{ord(ch):04X} '{ch}' - スキップ")
            result.append(ord(ch))
    return result


def parse_text_file(path):
    with open(path, 'rb') as f:
        raw = f.read()
    text = raw.decode('utf-16-be')
    rules = []
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith('■') or line.startswith('スタイル'):
            continue
        parts = line.split()
        if len(parts) >= 2:
            romaji = parts[0]  # ASCII ローマ字（大文字小文字そのまま）
            kana   = parts[1]  # かな出力
            rules.append((romaji, kana))
    return rules


def build_romaji_binary(rules):
    """
    rules: List[(romaji_str, kana_str)]
    → 16392 bytes のバイナリデータ（big-endian）
    """
    # 入力コードのリストに変換
    bin_rules = []  # [(input_codes: List[int], output_codes: List[int])]
    for romaji, kana in rules:
        input_codes  = [ord(c) for c in romaji]
        output_codes = to_hw(kana)
        if output_codes:
            bin_rules.append((input_codes, output_codes))

    # 二重子音ルールを生成（n以外の子音）
    vowels = set('aeiou')
    first_chars = set(r[0][0] for r in bin_rules if r[0])
    consonants = sorted(
        c for c in first_chars
        if chr(c).isalpha() and chr(c).lower() not in vowels and chr(c).lower() != 'n'
    )
    print(f"二重子音ルール生成対象: {[chr(c) for c in consonants]}")
    for c in consonants:
        bin_rules.append(([c, DBL_MARK], [HW_SOKUON]))

    # ソート: 入力コード列で辞書順
    bin_rules.sort(key=lambda r: r[0])

    total = len(bin_rules)
    print(f"総エントリ数: {total}")
    assert total <= 1000, f"エントリ数超過: {total} > 1000"

    # Section C を構築
    section_c = []  # List[int] of uint16 values
    b_entries  = []  # List[(c_offset, in_len, out_len)]

    for input_codes, output_codes in bin_rules:
        c_offset = len(section_c)
        assert c_offset <= 0xFFFF, f"Section C オフセット超過: {c_offset}"
        in_len  = len(input_codes)
        out_len = len(output_codes)
        assert in_len  <= 255, f"入力長超過: {in_len}"
        assert out_len <= 255, f"出力長超過: {out_len}"
        section_c.extend(input_codes)
        section_c.extend(output_codes)
        b_entries.append((c_offset, in_len, out_len))

    assert len(section_c) <= 6000, f"Section C サイズ超過: {len(section_c)} > 6000"
    print(f"Section C 使用: {len(section_c)} / 6000 uint16s")
    print(f"Section B 使用: {len(b_entries)} / 1000 エントリ")

    # Section A を構築
    # A[(ch-32)*2] = start_in_B, A[(ch-32)*2+1] = count_in_B
    section_a = [0] * 192

    # 各エントリの最初の文字でグループ化
    from collections import defaultdict
    groups = defaultdict(list)
    for idx, (input_codes, _) in enumerate(bin_rules):
        fc = input_codes[0]
        groups[fc].append(idx)

    for fc, indices in groups.items():
        key = (fc - 32) * 2
        if 0 <= key < 191:
            section_a[key]     = min(indices)
            section_a[key + 1] = len(indices)
        else:
            print(f"  WARNING: first_char=0x{fc:02X} のSection Aインデックスが範囲外: {key}")

    # 有効範囲外の文字には終端値（total）を設定
    for i in range(0, 192, 2):
        if section_a[i] == 0 and section_a[i+1] == 0:
            # 未使用エントリに終端値を設定
            fc = i // 2 + 32
            # すべての有効な最初文字より大きいASCII値には終端を設定
            if fc > max(groups.keys(), default=32):
                section_a[i] = total

    # バイナリを組み立て（Big-Endian）
    buf = bytearray(16392)

    # Header (8 bytes)
    struct.pack_into('>I', buf, 0, total)
    struct.pack_into('>I', buf, 4, 0x01000002)

    # Section A (384 bytes = 192 uint16, offset 8)
    for i, v in enumerate(section_a):
        struct.pack_into('>H', buf, 8 + i*2, v)

    # Section B (4000 bytes = 1000 entries × 4, offset 392)
    # 未使用エントリはゼロのまま（既存バイナリは0xDDで埋まっていたが0でも機能する）
    for i, (c_off, in_l, out_l) in enumerate(b_entries):
        off = 392 + i * 4
        struct.pack_into('>H', buf, off, c_off)
        buf[off + 2] = in_l
        buf[off + 3] = out_l

    # Section C (12000 bytes = 6000 uint16, offset 4392)
    for i, v in enumerate(section_c):
        struct.pack_into('>H', buf, 4392 + i*2, v)

    return bytes(buf)


def main():
    # テキストファイル解析
    print("=== テキストファイル解析 ===")
    rules = parse_text_file(TEXT_FILE)
    print(f"解析エントリ数: {len(rules)}")
    for romaji, kana in rules[:5]:
        hw = to_hw(kana)
        print(f"  '{romaji}' → '{kana}' → {[hex(v) for v in hw]}")

    # バイナリ構築
    print("\n=== バイナリ構築 ===")
    new_roma = build_romaji_binary(rules)
    print(f"生成バイナリサイズ: {len(new_roma)} bytes (期待値: 16392)")
    assert len(new_roma) == 16392

    # plist を更新
    print("\n=== plist 更新 ===")
    with open(STYLE_FILE, 'rb') as f:
        plist_data = plistlib.load(f)

    plist_data['ローマ字'] = new_roma

    with open(STYLE_FILE, 'wb') as f:
        plistlib.dump(plist_data, f, fmt=plistlib.FMT_XML)

    print(f"更新完了: {STYLE_FILE}")

    # 検証
    print("\n=== 検証 ===")
    with open(STYLE_FILE, 'rb') as f:
        verify = plistlib.load(f)
    read_back = verify['ローマ字']
    count = struct.unpack_from('>I', read_back, 0)[0]
    print(f"ヘッダー エントリ数: {count}")
    print(f"最初のエントリ:")
    for i in range(5):
        off = 392 + i * 4
        c_off = struct.unpack_from('>H', read_back, off)[0]
        in_l  = read_back[off+2]
        out_l = read_back[off+3]
        input_chars  = [struct.unpack_from('>H', read_back, 4392+(c_off+j)*2)[0] for j in range(in_l)]
        output_chars = [struct.unpack_from('>H', read_back, 4392+(c_off+in_l+j)*2)[0] for j in range(out_l)]
        in_str  = ''.join(chr(v) if 32<=v<127 else f'[{v:#x}]' for v in input_chars)
        out_str = ''.join(chr(v) for v in output_chars)
        print(f"  B[{i}]: '{in_str}' → '{out_str}'")


if __name__ == '__main__':
    main()
