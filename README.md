# Hello World

Basic stock flask hello world.

For testing AWS and Terraform EKS/ECS/EC2


## How to Serve

Using a basic `requirements.txt`.  You can install the dependencies globally (not recommended) or use a virtual environment manager that understands the basic `requirements.txt`, for example the build in `venv`.

Built on python 3, for this example, your code is in ~/Code/flask-hello-world

```bash
cd ~/Code
git clone https://github.com/mreschke/flask-hello-world.git
cd flask-hello-world
python -m venv env
source env/bin/activate
pip install -r requirements.txt
flask run

# CTRL+C to stop the server
# type `deactivate` to exit the venv environment
```

To serve directly from the venv without activate/deactive, simply run
```
~/Code/env/bin/python -m flask run
```

## Project structure

### ./service
Python hello world service code

### ./modules
Terrafom modules used for deployment

### ./deployment
Terragrunt configurations to manage remote stack, locking and the module with inputs to deploy

## How to Terraform to AWS
Deployed to https://dynatron.brothers.zone

### Releasing a new version
Simply push updates to the source code under `./service/` and GitHub will build a new docker
image and push it to ECR.

### Deploying the service to AWS
A GitHub action is configured to update the service workflow dispatch or by pushing
changes to the modules or deployment configuration.

To run manually, ensure AWS credentials have been set and set the `AWS_REGION` env var to `us-east-2`
``` 
cd deployment/flask-hello-world
terragrunt (plan/apply)
```

## Additional Considerations

### Build / Deploy
- With a more complex program this would include testing and linting steps to support a PR driven workflow

### Infrastructure
Things that would be done if given more time or not under free tier constraints
- I would include a WAF in normal circumstances
- Higher availbility across at least 3 availbility zones and possibly other regions would be used in a non-free tier deployment
- Isoloation into a separate non default VPC, in private subnets, along with an internet gateway if needed
- Break the terraform code into separate modules where re-usability or other requirements dictate such as deploying multiple services in a shared ECS
- Include access logging, application logging, metrics and monitoring
- Allow for auto forwarding http:80 requests to https:443
- Fully manage dns and SSL through terraform
