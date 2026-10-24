# -*- coding: utf-8 -*-
"""We shall say that an n-digit number is pandigital if it makes use
of all the digits 1 to n exactly once. For example, 2143 is a 4-digit
pandigital and is also prime.

What is the largest n-digit pandigital prime that exists?
"""

from p10 import is_prime
from itertools import permutations


def main():
    digit_count = 7
    candidates = []
    while digit_count > 1:
        # 1-9 pandigital test
        test = lambda x: set(
            [str(i) for i in range(1, len(str(x)) + 1)]) == set(list(str(x)))

        for digits in permutations(range(1, digit_count + 1), digit_count):
            if digits[-1] in [2, 4, 6, 8, 5]:
                continue

            n = int(''.join([str(x) for x in digits]))

            if is_prime(n) and test(n):
                print 'found one', digit_count, n
                candidates.append(n)
                # raw_input()
        digit_count -= 1

    print max(candidates), len(candidates)

if __name__ == '__main__':
    main()
