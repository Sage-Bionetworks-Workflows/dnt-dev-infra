# single-instance-prefect-infra

This repository sets up AWS infrastructure for prefect installed on a single EC2 instance and an S3 bucket for storing flows and data.

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
* [pre-commit](https://pre-commit.com/), to ensure

## Testing sceptre deployment

If your text editor (_e.g._ Visual Studio Code) or shell (_e.g._ using [`direnv`](https://direnv.net/)) can automatically activate the `pipenv` virtual environment, you can omit the `pipenv shell` command.

```
# Activate the pipenv virtual environment to use sceptre
pipenv shell

# Test the deployment of a single stack in the 'develop' stack group
sceptre launch develop/my-template.yaml

# Delete the test deployment of a single stack the 'develop' stack group
sceptre delete develop/my-template.yaml

# Test deploying the entire 'develop' stack group
sceptre launch develop

# Remove the entire 'develop' stacck group
sceptre delete develop
```

The Github action to deploy AWS stacks relies on setting up the secrets used by
the workflow in [Github Environments](https://docs.github.com/en/actions/reference/environments).
Set up environments for each AWS account you're deploying to. This is where
you'll put secrets such as the ones for your CI user credentials.
