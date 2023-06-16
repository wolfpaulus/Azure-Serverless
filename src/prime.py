"""
This module contains functions for working with prime numbers.
@author: wolf@paulus.com
"""
from typing import List, Tuple


def is_prime(k:  int) -> Tuple[bool, str]:
    """
    Return True if k is prime, False otherwise. 
    The 2nd return value is a message that says why k is not prime.    
    """
    if k < 2:
        return False, f"{k} is not a prime number, it's less than 2."
    if k > 2:
        if k % 2 == 0:
            return False, f"{k} is not a prime number, it's divisible by 2."
        for i in range(3, int(k**0.5 + 1), 2):
            if k % i == 0:
                return False, f"{k} is not a prime number, it's divisible by {i}."
    return True, f"Yes, {k} is a prime number."


def n_primes(n: int) -> List[int]:
    """
    Return a list of the first n primes.
    ! maintains a list of primes found so far
    """
    if n < 1:
        return []
    candidate = primes[-1]
    while n > len(primes):
        candidate += 2
        limit = int(candidate**0.5 + 1)
        for p in primes:
            if candidate % p == 0: # it's not prime
                break 
            if p >= limit: # it's prime   
                primes.append(candidate)
                break
    return primes[:n]

primes = [2,3]


