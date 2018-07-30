# -*- coding: utf-8 -*-
"""An irrational decimal fraction is created by concatenating the
positive integers:

0.123456789101112131415161718192021...

It can be seen that the 12th digit of the fractional part is 1.

If dn represents the nth digit of the fractional part, find the value
of the following expression.

d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000
"""


def method_1():
    n = 1000000
    marks = [10 ** i for i in range(7)]

    start = end = 0
    on = 1
    tmp = ''
    while end <= n:
        tmp += str(on)
        start, end = end, end + len(str(on))
        on += 1
        # print on, start, end

    print [tmp[m - 1] for m in marks]
    print reduce(lambda x, y: x * y, [int(tmp[m - 1]) for m in marks])


def method_2():
    n = 1000000

    # index boundaries we are interested in
    marks = [10 ** i for i in range(7)]
    # next index boundary to watch
    next_mark = 0

    # keep track of string index
    start = end = 0

    # count numbers
    on = 1

    # iterate problem space
    while end <= n:
        # track indexes
        start, end = end, end + len(str(on))

        # check index boundary
        if end >= marks[next_mark]:
            # crossed a boundary, we should have one ''xxth'' digit
            print str(on)[-1 * (end - marks[next_mark] + 1)]

            # next index boundary
            next_mark += 1

        # next number to concatenate
        on += 1


def main():
    method_1()
    method_2()

if __name__ == '__main__':
    main()
