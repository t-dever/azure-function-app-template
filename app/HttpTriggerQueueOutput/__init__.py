import logging
import azure.functions as func

def main(req: func.HttpRequest, msg: func.Out[str]) -> func.HttpResponse:

    input_msg = req.params.get('message')

    result = msg.set(input_msg)
    logging.info(result)

    return func.HttpResponse(f"Successfully added message {input_msg}.")