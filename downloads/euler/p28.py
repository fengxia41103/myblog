# -*- coding: utf-8 -*-

"""Starting with the number 1 and moving to the right in a clockwise
direction a 5 by 5 spiral is formed as follows:

21 22 23 24 25
20  7  8  9 10
19  6  1  2 11
18  5  4  3 12
17 16 15 14 13

It can be verified that the sum of the numbers on the diagonals is
101.

What is the sum of the numbers on the diagonals in a 1001 by 1001
spiral formed in the same way?
"""


def main():
    n = 1001

    total = m = 1  # m is the circle counter
    num = 1
    while m < (n + 1) / 2:  # need (n+1)/2 circles to achieve n by n matrix
        # compute 4 corner values
        for i in range(4):
            num += m * 2  # 2*m is the step
            total += num

        # next spiral, please
        m += 1

    print 'total', total

if __name__ == '__main__':
    main()
