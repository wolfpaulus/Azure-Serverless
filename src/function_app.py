"""
This module contains the Azure Function App that is deployed to Azure.
@author: wolf@paulus.com
"""

import azure.functions as func
import logging
from json import dumps
from prime import is_prime, n_primes

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="health")
def foo0(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('health was called.')
    return func.HttpResponse("OK", status_code=200)


@app.route(route="is_prime")
def foo1(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('foo1 was called.')

    k = req.params.get('k')
    if not k:
        try:
            req_body = req.get_json()
            k = req_body.get('k')
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
    logging.info('foo2 was called.')

    n = req.params.get('n')
    if not n:
        try:
            req_body = req.get_json()
            n = req_body.get('n')
        except ValueError:
            pass

    if n and n.isnumeric():
        return func.HttpResponse(body=dumps(n_primes(int(n))),
                                 status_code=200,
                                 mimetype="application/json",
                                 charset="utf-8")
    else:
        return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass a n=<integer> to get the 1st n prime numbers.",
            status_code=200
        )
