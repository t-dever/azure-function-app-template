import requests
import threading

function_app_name = ""
function_url = f"https://{function_app_name}.azurewebsites.net/api/HttpTrigger1"

def call_api(url, parameters=""):
    print("hit call api")
    response = requests.get(url, params=parameters)
    print(response)
    print(response.text)


test_param = { "name": "testing"}

test_list = [
    { "name": "testing" },
    {""},
    {""}
]


for test in test_list:
    thread = threading.Thread(target=call_api, args=(function_url, test,))
    thread.start()
