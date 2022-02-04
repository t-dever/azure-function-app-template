# Overview

This project will deploy a basic azure function app with an http trigger. (More features to be added later.)

## Requirements

Install:
- [Azure Core Tools](https://github.com/Azure/azure-functions-core-tools)

## Resource Deployment

1. Fill out the variables located in file `auto.variables.tfvars`

    ```terraform
    resource_group_name          = ""
    location                     = ""
    storage_account_name         = ""
    log_analytics_workspace_name = ""
    app_insights_name            = ""
    app_service_plan_name        = ""
    function_app_name            = ""
    ```

2. Change directory to `deployment` folder.
   - `cd deployment`

3. Run `terraform apply -var-file="auto.variables.tfvars" -auto-approve`

After deployment is successful you can deploy the python function app code to the resource.

## Function App Deployment

1. Change directory to `app` folder.
2. Run command `func azure functionapp publish <function app name>`

### Additional Resources

- [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash)
