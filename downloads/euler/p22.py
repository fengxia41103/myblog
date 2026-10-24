# -*- coding: utf-8 -*-

"""
Using names.txt (right click and 'Save Link/Target As...'), a 46K
text file containing over five-thousand first names, begin by sorting
it into alphabetical order. Then working out the alphabetical value
for each name, multiply this value by its alphabetical position in the
list to obtain a name score.

For example, when the list is sorted into alphabetical order, COLIN,
which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the
list. So, COLIN would obtain a score of 938 × 53 = 49714.

What is the total of all the name scores in the file?
"""

import csv
import string


def main():
    with open('p022_names.txt', 'r') as f:
        names = list(csv.reader(f))[0]

    names.sort()
    score = 0
    for idx, name in enumerate(names):
        # The key is to find the character value based on
        # list "A-Z" instead of its "ord(x)" ordinal value!
        # You can use the test case "COLIN" to verify.
        score += (idx + 1) * \
            sum([string.ascii_uppercase.find(x) + 1 for x in name])

    print score

if __name__ == '__main__':
    main()
