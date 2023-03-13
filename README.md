# Single Instance Airflow Infra

This repository sets up AWS infrastructure for airflow installed on a single EC2 instance.

## Setup

1. Install [awscli v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
1. This relies on python dependencies. We recommmend installing one of the latest versions of python3.
1. Install [pipenv](git@github.com:tthyer/infra-template.git) for python environment management.
1. Run `pipenv install --dev` to install [sceptre](https://sceptre.cloudreach.com/2.6.3/) and [pre-commit](https://pre-commit.com/).
1. Run `pipenv run pre-commit install` to install git hooks.
1. [Github actions](https://docs.github.com/en/actions) for CICD
1. Install [pre-commit](https://pre-commit.com/), then run `pre-commit install`.

The Pipfile installs the following dependencies in a virtual environment:
* [sceptre](https://sceptre.cloudreach.com/2.6.3/) for better AWS CloudFormation deployment
* [pre-commit](https://pre-commit.com/) for running pre-commit checks

## Testing sceptre deployment

If your text editor (_e.g._ Visual Studio Code) or shell (_e.g._ using [`direnv`](https://direnv.net/)) can automatically activate the `pipenv` virtual environment, you can omit the `pipenv shell` command.

```
# Activate the pipenv virtual environment to use sceptre
pipenv shell

# Test the deployment of a single stack in the 'prod' stack group
sceptre launch prod/airflow-ec2.yaml

# Delete the test deployment of a single stack the 'develop' stack group
sceptre delete prod/airflow-ec2.yaml

# Test deploying the entire 'prod' stack group
sceptre launch prod

# Remove the entire 'prod' stack group
sceptre delete prod
```

When using this repository locally, you will need to authenticate your AWS account prior to performing any `sceptre` operations.

You can do so by using Session Manager on your local machine: https://sagebionetworks.jira.com/wiki/spaces/IT/pages/2632286259/AWS+SSM+Session+Manager

Once authenticated, `sceptre launch` commands will deploy resources defined in the `prod/` directory to the account which you are logged into.

For example, you could log into a development account such as `org-sagebase-dnt-dev` and then run `sceptre launch prod -y` to launch all resources in the `prod` group.
