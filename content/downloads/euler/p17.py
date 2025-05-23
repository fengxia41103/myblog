# -*- coding: utf-8 -*-
"""If the numbers 1 to 5 are written out in words: one, two, three,
four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in
total.

If all the numbers from 1 to 1000 (one thousand) inclusive were
written out in words, how many letters would be used?


NOTE: Do not count spaces or hyphens. For example, 342 (three hundred
and forty-two) contains 23 letters and 115 (one hundred and fifteen)
contains 20 letters. The use of "and" when writing out numbers is in
compliance with British usage.
"""


def main():
    n = 1000
    ordinals = {
        0: '',
        1: 'one',
        2: 'two',
        3: 'three',
        4: 'four',
        5: 'five',
        6: 'six',
        7: 'seven',
        8: 'eight',
        9: 'nine',
        10: 'ten',
        11: 'eleven',
        12: 'twelve',
        13: 'thirteen',
        14: 'fourteen',
        15: 'fifteen',
        16: 'sixteen',
        17: 'seventeen',
        18: 'eighteen',
        19: 'nineteen',
        20: 'twenty',
        30: 'thirty',
        40: 'forty',
        50: 'fifty',
        60: 'sixty',
        70: 'seventy',
        80: 'eighty',
        90: 'ninety',
        100: 'hundred',
        1000: 'thousand',
    }
    results = []
    for x in range(1, n + 1):
        tmp = ''

        if x in ordinals and x not in [100, 1000]:
            tmp = ordinals[x]
        else:
            if x / 1000:
                thousand = x / 1000
                tmp = ordinals[thousand] + ordinals[1000]
                x = x - x / 1000 * 1000
            if x / 100:
                # 3-digit numbers
                hundred = x / 100
                tmp += ordinals[hundred] + ordinals[100]
                x = x - x / 100 * 100
                if x:
                    tmp += 'and'
            if x not in ordinals and x / 10:
                # 2-digit numbers
                ten = x / 10 * 10
                tmp += ordinals[ten]
                x = x - ten
            tmp += ordinals[x]
        results.append(tmp)

    print results
    print sum([len(x) for x in results])

if __name__ == '__main__':
    main()
