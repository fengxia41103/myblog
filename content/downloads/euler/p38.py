# -*- coding: utf-8 -*-

"""Take the number 192 and multiply it by each of 1, 2, and 3:

192 × 1 = 192
192 × 2 = 384
192 × 3 = 576

By concatenating each product we get the 1 to 9 pandigital,
192384576. We will call 192384576 the concatenated product of 192 and
(1,2,3)

The same can be achieved by starting with 9 and multiplying by 1, 2,
3, 4, and 5, giving the pandigital, 918273645, which is the
concatenated product of 9 and (1,2,3,4,5).

What is the largest 1 to 9 pandigital 9-digit number that can be
formed as the concatenated product of an integer with (1,2, ... , n)
where n > 1?  """

from operator import add


def main():
    method_1()
    method_2()


def method_1():
    max_digits = 9

    # 1-9 pandigital test
    test = lambda x: set('123456789') == set(x)

    # iterate problem space
    result = 0
    for n in [2, 3, 4]:  # number of digits
        for i in range(10 ** (n - 1) * 9, 10 ** n):  # potential numbers
            # concatenated sum strings
            tmp = reduce(add, [str(i * j)
                               for j in range(1, max_digits / n + 1)])

            # pandigital test
            if test(tmp):
                print 'found', n, i, tmp
                result = max(result, tmp)
    print result


def method_2():
    """Same solution with assumption that the number has 9 digits
    and starts with 9 -> 9xxx.
    """
    for x in range(9000, 10000):
        st = str(x) + str(x * 2)
        if set('123456789') == set(st):
            print x, st

if __name__ == '__main__':
    main()
