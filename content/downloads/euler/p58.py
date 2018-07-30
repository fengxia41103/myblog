# -*- coding: utf-8 -*-

from p10 import is_prime


def main():
    m = 1  # m is the circle counter
    num = 1  # corner num
    prime_count = 0
    while not prime_count or 4 * m + 1 <= prime_count * 10:
        # compute 4 corner values
        for i in range(4):
            num += m * 2  # 2*m is the step
            if is_prime(num):
                prime_count += 1

        # next spiral, please
        m += 1

    print 2 * m + 1

if __name__ == '__main__':
    main()
