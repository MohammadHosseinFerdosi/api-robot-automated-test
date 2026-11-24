import math

""" The rounding half up strategy rounds every number to the nearest number 
with the specified precision and breaks ties by rounding up. Here are some examples:

| Value | Round Half Up To | Result |
| 13.825 | Tens place | 10 |
| 13.825 | Ones place | 14 |
| 13.825 | Tenths place | 13.8 |
| 13.825 | Hundredths place | 13.83 |
"""
def round_half_up(n, decimals=0):
    multiplier = 10**decimals
    return math.floor(n * multiplier + 0.5) / multiplier

""" The rounding half down strategy rounds to the nearest number with the desired precision, 
just like the rounding half up method, except that it breaks ties by rounding to the lesser of 
the two numbers. Here are some examples:

| Value	| Round Half Down To | Result |
| 13.825 | Tens place | 10 |
| 13.825 | Ones place | 14 |
| 13.825 | Tenths place | 13.8 |
| 13.825 | Hundredths place | 13.82 | 
"""
def round_half_down(n, decimals=0):
    multiplier = 10**decimals
    return math.ceil(n * multiplier - 0.5) / multiplier