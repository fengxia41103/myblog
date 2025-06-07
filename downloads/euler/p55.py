# -*- coding: utf-8 -*-


def method_1():
    is_palindromic = lambda x: str(x) == str(x)[::-1]
    next_num = lambda x: x + int(str(x)[::-1])

    MAX_ITERATION = 50
    m = 1
    count = 0
    while m < 10000:
        iter_count = 1
        tmp = next_num(m)
        while iter_count < MAX_ITERATION and not is_palindromic(tmp):
            tmp = next_num(tmp)
            iter_count += 1
        if iter_count == MAX_ITERATION:
            count += 1
        m += 1
    print count


def is_lychrel(n):
    i = 0
    while i < 50:
        i += 1
        n += int(str(n)[::-1])
        if str(n) == str(n)[::-1]:
            return False
    return True


def method_2():
    print sum([1 for x in range(2, 10000) if is_lychrel(x)])


def main():
    method_1()
    method_2()
    method_3()
if __name__ == '__main__':
    main()
