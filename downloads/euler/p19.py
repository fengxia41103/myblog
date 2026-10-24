# -*- coding: utf-8 -*-
"""
You are given the following information, but you may prefer to do some research for yourself.

1 Jan 1900 was a Monday.
Thirty days has September,
April, June and November.
All the rest have thirty-one,
Saving February alone,
Which has twenty-eight, rain or shine.
And on leap years, twenty-nine.
A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.

How many Sundays fell on the first of the month during the twentieth
century (1 Jan 1901 to 31 Dec 2000)?
"""

from datetime import date
from datetime import timedelta


def main():
    count = 0
    start = date(1901, 1, 1)
    while start.year < 2001:
        # check requirements
        # 1. 1st day of a month
        # 2. is a Sunday
        if start.day == 1 and start.weekday() == 6:
            count += 1
            print start

        start += timedelta(days=1)

    print count

if __name__ == '__main__':
    main()
