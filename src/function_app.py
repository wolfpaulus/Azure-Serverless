"""
This module contains the Azure Function App that is deployed to Azure.
@author: wolf@paulus.com
"""

import azure.functions as func
import logging
from time import process_time
from json import dumps
from prime import is_prime, n_primes, primes

# no api key required
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="{path?}")
def html(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('html was called.')
    return func.HttpResponse("Ooh", status_code=200)


@app.route(route="health")
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('health_check was called.')
    return func.HttpResponse("OK", status_code=200)


@app.route(route="is_prime")
def foo1(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('foo1 was called.')

    k = req.params.get('k')
    if not k:
        try:
            req_body = req.get_json()
            k = str(req_body.get('k'))
        except ValueError:
            pass

    if k and k.isnumeric():
        return func.HttpResponse(is_prime(int(k))[1], status_code=200)
    else:
        return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass k=<integer> to find out if the integer is a prime number.",
            status_code=200
        )


@app.route(route="n_primes")
def foo2(req: func.HttpRequest) -> func.HttpResponse:
    logging.info(
        f'foo2 was called. Currently {len(primes)} prime numbers are cached.')

    n = req.params.get('n')
    if not n:
        try:
            req_body = req.get_json()
            n = str(req_body.get('n'))
        except ValueError:
            pass

    if n and n.isnumeric():
        t0 = process_time()
        result = {
            "cache_before_call": len(primes),
            "primes": n_primes(int(n)),
            "cache_after_call": len(primes),
            "execution_time": process_time() - t0
        }
        return func.HttpResponse(body=dumps(result),
                                 status_code=200,
                                 mimetype="application/json",
                                 charset="utf-8")
    else:
        return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass a n=<integer> to get the 1st n prime numbers.",
            status_code=200
        )
