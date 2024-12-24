# -*- coding: utf-8 -*-

from p10 import is_prime2, postponed_sieve
import copy


def method_1():
    N = 5

    # test: is concatenated a prime
    prepend_test = lambda p, r: is_prime2(int(str(p) + str(r)))
    append_test = lambda p, r: is_prime2(int(str(r) + str(p)))

    # searching seed
    results = [[3], [7], [11], [13]]

    # search through primes indefinitely
    tmp_min = 0
    for p in postponed_sieve():
        # when break here, we guarantee the "lowest sum"
        if tmp_min and p >= tmp_min:
            break

        # 2 is a special prime, skip
        if p == 2:
            continue

        print '@', p, len(results)

        # test: primality test
        # Use index because we will modify "results" list
        # within the loop
        for idx in range(len(results)):
            # flag default to True
            is_valid = True

            # check sublist
            tmp = results[idx]
            for r in tmp:
                # test: is concatenated a prime?
                if not prepend_test(p, r) or not append_test(p, r):
                    is_valid = False
                    break

            # passed test, update results list
            # if p is greater than last number on that list
            if is_valid and p > tmp[-1]:
                # save original list
                results.append(copy.copy(tmp))

                # extend list that fits pattern
                results[idx].append(p)
                if len(results[idx]) == N and (sum(results[idx]) < tmp_min or tmp_min < 1):
                    tmp_min = sum(results[idx])

    # print result
    found = filter(lambda x: len(x) == N, results)
    print found, min(sum(x) for x in found)


def main():
    method_1()


if __name__ == '__main__':
    main()
