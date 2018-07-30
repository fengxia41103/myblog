# -*- coding: utf-8 -*-

"""The decimal number, 585 = 1001001001 (binary), is palindromic in
both bases.

Find the sum of all numbers, less than one million, which are
palindromic in base 10 and base 2.

(Please note that the palindromic number, in either base, may not
include leading zeros.)
"""


def main():
    n = 1000000

    # palindromic test
    test = (lambda x: x == x[::-1])

    # iterate problem space
    result = 0
    for i in range(1, n):
        # test criteria: ending 0
        if i % 10 == 0:
            continue

        # test criteria: most significant == least significant
        if str(i)[0] != str(i)[-1]:
            continue

        # test criteria: palindromic
        # Note: bin(a) generates "0b101..." -> strip off "0b"
        if test(str(i)) and test(bin(i)[2:]):
            print i
            result += i

    print result

if __name__ == '__main__':
    main()
