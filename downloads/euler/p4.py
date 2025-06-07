# -*- coding: utf-8 -*-

"""A palindromic number reads the same both ways. The largest
palindrome made from the product of two 2-digit numbers is 9009 = 91 ×
99.

Find the largest palindrome made from the product of two 3-digit
numbers.
"""

import itertools


def is_palindromic(n):
    """Test n to be palindromic number.

    The easiest way, I think, is to convert "n" to
    string and test its reverse == itself.
    """
    string_version = str(n)
    return ''.join(reversed(string_version)) == string_version


def main():
    matrix = set(itertools.imap(
        lambda (x, y): x * y, itertools.combinations(range(100, 999), 2)))
    results = filter(lambda x: is_palindromic(x), matrix)
    print max(results)


if __name__ == '__main__':
    main()
