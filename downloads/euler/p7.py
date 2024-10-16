# -*- coding: utf-8 -*-


def is_prime(n):
    if n <= 1:
        return False
    elif n <= 3:
        return True
    elif n % 2 == 0 or n % 3 == 0:
        return False

    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True


def main():
    n = 10001
    count = 1
    i = 3
    with open('./data.log', 'w') as f:
        while count < n:
            if is_prime(i):
                print i
                f.write(str(i) + '\n')
                count += 1
            i += 2

    print '%dth prime is' % n, i - 2

if __name__ == '__main__':
    main()
