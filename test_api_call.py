import requests
import threading

function_app_name = "travis-function-testing-app"
function_app_url = f"https://{function_app_name}.azurewebsites.net/api"

http_trigger1_url = f"{function_app_url}/HttpTrigger1"
http_trigger_queue_output_url = f"{function_app_url}/HttpTriggerQueueOutput"


def call_api(url, parameters=""):
    print("hit call api")
    if parameters:
        response = requests.get(url, params=parameters)
    else:
        response = requests.get(url)
    print(response)
    print(response.text)


def threading_example():
    test_list = [
        { "name": "testing" },
        {""},
        {""}
    ]

    for test in test_list:
        thread = threading.Thread(target=call_api, args=(http_trigger1, test,))
        thread.start()

def http_trigger1(url):
    result = call_api(url, parameters={"name": "testing"})

def http_trigger_queue_output(url):
    result = call_api(url, parameters={"message": "testing storage queue"})

print(http_trigger1_url)
http_trigger1(http_trigger1_url)

print(http_trigger_queue_output_url)
http_trigger_queue_output(http_trigger_queue_output_url)

