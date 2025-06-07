# -*- coding: utf-8 -*-

"""The following iterative sequence is defined for the set of
positive integers:

n → n/2 (n is even)
n → 3n + 1 (n is odd)

Using the rule above and starting with 13, we generate the following
sequence:

13 → 40 →  20 → 10 → 5 → 16 →  8 → 4 → 2 → 1

It can be seen that this sequence (starting at 13 and finishing at 1)
contains 10 terms. Although it has not been proved yet (Collatz
Problem), it is thought that all starting numbers finish at 1.

Which starting number, under one million, produces the longest chain?

NOTE: Once the chain starts the terms are allowed to go above one
million.
"""


def chain(n):
    while n > 1:
        yield n
        if n % 2:
            n = 3 * n + 1
        else:
            n = n / 2


def main():
    n = 1000000
    max_len = 0
    for i in range(n, 1, -1):
        chain_len = len(list(chain(i)))
        max_len = max(max_len, chain_len)

        print i, chain_len

if __name__ == '__main__':
    main()
