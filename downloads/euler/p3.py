# -*- coding: utf-8 -*-

"""
The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143
"""

import sys
from math import sqrt

'''
if n ≤ 1
  return false
else if n ≤ 3
  return true
else if n mod 2 = 0 or n mod 3 = 0
  return false
let i ← 5
while i×i ≤ n
  if n mod i = 0 or n mod (i + 2) = 0
      return false
  i ← i + 6
return true
'''


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


def next_prime(max_prime):
    i = max_prime + 2
    while not is_prime(i):
        i += 2
    return i


def method_1(n):
    """Method 1 is searching for the largest prime factor from bottom
    up. Starting with the smallest prime number, 2, we divide target
    as much as possible to reduce it, then move on to the next prime
    number and repeat. The remainder, if is a prime, is the result.
    """
    primes = [2, 3]

    while n > 3 and not is_prime(n):
        if n >= primes[-1]:
            primes.append(next_prime(primes[-1]))

        for p in primes:
            if n % p == 0:
                while n > p and n % p == 0:
                    n = n / p

    print 'max prime', n


def method_2(n):
    """Method 2 follows the same logic as method 1's. But its
    implementation is much simpler. We simply searching from 2 and up
    until we find the result. In between, we don't search for the next
    prime as method 1 does. Instead, we step by +1. Since the search
    is from bottom up, only the next prime will possibly yield a %==0
    anyway, so it's the same as method 1's.

    """
    i = 2
    while i * i < n:
        while n % i == 0:
            n = n / i
        i = i + 1

    print (n)


def main():
    n = 600851475143
    method_1(n)
    method_2(n)

if __name__ == '__main__':
    main()
