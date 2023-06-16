"""
Test the prime module.
@author: wolf@paulus.com
"""
from prime import is_prime, n_primes

def test_is_prime():
    assert not is_prime(0)[0]
    assert not is_prime(1)[0]
    assert is_prime(2)[0]
    assert is_prime(3)[0]
    assert not is_prime(4)[0]
    assert is_prime(5)[0]
    assert not is_prime(6)[0]

def test_is_prime_message():
    assert is_prime(0)[1] == "0 is not a prime number, it's less than 2."
    assert is_prime(1)[1] == "1 is not a prime number, it's less than 2."
    assert is_prime(2)[1] == "Yes, 2 is a prime number."
    assert is_prime(3)[1] == "Yes, 3 is a prime number."
    assert is_prime(4)[1] == "4 is not a prime number, it's divisible by 2."
    assert is_prime(5)[1] == "Yes, 5 is a prime number."
    assert is_prime(9)[1] == "9 is not a prime number, it's divisible by 3."

def test_n_primes():
    assert n_primes(-1) == []
    assert n_primes(0) == []
    assert n_primes(1) == [2]
    assert n_primes(2) == [2,3]
    assert n_primes(3) == [2,3,5]
    assert n_primes(4) == [2,3,5,7]
    assert n_primes(5) == [2,3,5,7,11]
    assert n_primes(6) == [2,3,5,7,11,13]
    lst = n_primes(100)
    assert len(lst) == 100
    assert lst[-1] == 541
    assert n_primes(1_000)[-1] == 7919
    assert n_primes(10_000)[-1] == 104729
    assert n_primes(100_000)[-1] == 1299709




