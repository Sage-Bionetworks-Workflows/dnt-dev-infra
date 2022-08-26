# Prefect Notes

## Docs Links
- API: https://docs.prefect.io/api-ref/overview/
- Blocks: https://docs.prefect.io/concepts/blocks/
- FileSystems: https://docs.prefect.io/concepts/filesystems/

## Connect to Prefect UI
- Ensure you are set up to use session manager on your local machine: https://sagebionetworks.jira.com/wiki/spaces/IT/pages/2632286259/AWS+SSM+Session+Manager
- Run the port-forwarding script: https://github.com/Sage-Bionetworks-Workflows/dnt-dev-infra/blob/main/utils/prefect-port-forward.sh 
- Goto http://127.0.0.1:4200/
- To create a session on the EC2, see "Helpful Tips" section below.

## Connect to Prefect EC2
Get set up for creating SSM session from command line: https://sagebionetworks.jira.com/wiki/spaces/IT/pages/2632286259/AWS+SSM+Session+Manager.

Here is a helper function for connecting -- note the username and profile are
currently hardcoded, but could easily be parameterized:

```
ssmSession() {
  target=$1
  user=ubuntu
  if [[ -z $target ]]; then
    echo "an aws EC2 ID must be the first argument"
    return 1
  fi
  aws ssm start-session --profile dnt-dev-admin \
                        --target "${target}" \
                        --document-name AWS-StartInteractiveCommand \
                        --parameters command="sudo su - ${user}"
}
```

## User
For all EC2 commands, become root. Currently prefect is installed and run by root. The EC2 deployment could be changed to run the service by the ubuntu user instead.

The sqlite3 db is put in the user home so right now it is at `/root/.prefect/orion.db`

## Checking prefect server and agent
The prefect-ec2 Cloudformation deployment creates an orion server and starts an agent named "test". You can check the status of these with `supervisorctl status`. For more information see the [supervisor docs](http://supervisord.org/index.html).

## Healthcheck Flow
First, Connect to the Prefect EC2 (see above).

### Build the deployment file
This will create a YAML file that describes the deployment. 

```
prefect deployment build ./healthcheck_flow.py:healthcheck -n healthcheck -q test
```

Note that the work-queue is specified. You must specify one that has already been created (see the one create in /etc/supervisor/supervisord.conf) or create a new agent with `prefect agent start -q <some_name>`


### Create the deployment
This command registers the deployment with prefect. This describes a flow, but does not execute it.
```
prefect deployment apply healthcheck-deployment.yaml
```


### Run the flow
```
prefect deployment run healthcheck/healthcheck
```


## Adding an S3 block
- Log onto dnt-dev console and find bucket name. It begins with "prefect-s3-bucket-" but has a random string at the end. You can also get this from the "prefect-s3" CloudFormation stack in the console, or through the awscli.
- Click Blocks then choose S3.
- Create a block called "s3-test-block" and give it an S3 path: "s3://prefect-s3-bucket-7cefr0l5kay6/test". Do not save any auth credentials, as the Prefect EC2 instance has permission to interact with this bucket already through an instance profile.
- The block is created and shows some information about using it.

## Testing the S3 block
First, Connect to the Prefect EC2 (see above). Also note that for this to work, s3fs must be installed. This has been added to prefect-ec2.j2.

### Create the script
Run `mkdir -p $HOME/flows`. Inside the folder just created, create the following script:

```
import asyncio
import os

from prefect import flow
from prefect.filesystems import S3

s3_block = S3.load("s3-test-block")

@flow
async def test_s3_block():
    response = s3_block.write_path("hello-world.txt", b"Hello, World!")
    await response
```

*Do not* put the s3_block variable instantiation inside the async function, or you will get this error: `AttributeError: 'coroutine' object has no attribute 'write_path`.

### Build the deployment

```
prefect deployment build $HOME/flows/test_s3_block_flow.py:test_s3_block -n test_s3_block -q test
```

This creates a deployment YAML file.

### Apply the deployment

```
prefect deployment apply $HOME/flows/test_s3_block-deployment.yaml
```

### Run the deployment

```
prefect deployment run test-s3-block/test_s3_block
```

### Add storage block to deployment
If you specify the storage block when you create the deployment, prefect mirrors all files in the deployment file directory to the s3 block. To see this in action, replace the build deployment command above with `prefect deployment build $HOME/flows/test_s3_block_flow.py:test_s3_block -n test_s3_block -q test --storage-block s3/s3-test-block`.
