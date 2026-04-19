# Terraform AWS Docker infrastructure

This project completely automates the creation of AWS infrastructure to host a simple Nginx web application using Docker, all driven through a Jenkins CI/CD pipeline.

## Features
- **Infrastructure as Code:** Uses Terraform to create an AWS VPC, Subnet, Internet Gateway, Route Table, Security Groups, and an EC2 Instance.
- **Automated Provisioning:** Bootstrap scripts (`install_docker.sh`) automatically setup Docker and deploy the Nginx container upon VM creation.
- **CI/CD Pipeline:** Includes a configured `Jenkinsfile` for automating testing, planning, and deployment of the Terraform code.

## File Structure
- `terraform/`: Contains all terraform manifests.
  - `main.tf`: Core networking and EC2 generation.
  - `outputs.tf`: Prints out useful data post-deployment (e.g. app URL).
  - `provider.tf`: Setup of AWS context.
  - `variables.tf`: Configuration keys.
  - `install_docker.sh`: Bash script that runs inside the VM during launch.
- `Jenkinsfile`: Complete jenkins pipeline logic.

## Usage

### Prerequisites
- [Terraform](https://www.terraform.io/downloads) installed locally
- [AWS CLI](https://aws.amazon.com/cli/) configured with `aws configure`
- An AWS account (Free Tier eligible — uses `t3.micro`)

### 1. Manual Deployment (Quickstart)

```bash
# Clone this repository
git clone <your-repo-url>
cd terraform-aws-docker/terraform

# Initialize Terraform (downloads AWS provider)
terraform init

# Preview what will be created
terraform plan

# Deploy everything to AWS
terraform apply
```

> ⏳ Wait **2–3 minutes** after apply completes for the EC2 instance to finish installing Docker and starting the container.
> Then open the `application_url` printed in the terminal in your browser.

**⚠️ To destroy all resources and avoid AWS charges:**
```bash
terraform destroy
```

### 2. Jenkins CI/CD Pipeline

To automate deployments via Jenkins:

1. Install the **Terraform Plugin** in Jenkins (`Manage Jenkins → Plugins`).
2. In `Manage Jenkins → Tools`, add a Terraform installation named `terraform`.
3. Add your AWS credentials in `Manage Jenkins → Credentials` as:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
4. Create a new **Pipeline** job and point it at this Git repository — Jenkins will auto-detect the `Jenkinsfile`.

## Architecture

```
Developer Machine
      │
      │  terraform apply
      ▼
┌─────────────────────────────────────────┐
│               AWS Cloud                 │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │  VPC (10.0.0.0/16)               │   │
│  │  ┌────────────────────────────┐  │   │
│  │  │  Public Subnet (10.0.1.0)  │  │   │
│  │  │  ┌──────────────────────┐  │  │   │
│  │  │  │   EC2 (t3.micro)     │  │  │   │
│  │  │  │  ┌────────────────┐  │  │  │   │
│  │  │  │  │  Docker        │  │  │  │   │
│  │  │  │  │  └── Nginx:80  │  │  │  │   │
│  │  │  │  └────────────────┘  │  │  │   │
│  │  │  └──────────────────────┘  │  │   │
│  │  └────────────────────────────┘  │   │
│  │  Security Group (Port 80, 22)    │   │
│  └──────────────────────────────────┘   │
│           │ Internet Gateway            │
└───────────┼─────────────────────────────┘
            │
            ▼
      🌐 Public IP → Browser
```

## File Structure

```
terraform-aws-docker/
├── terraform/
│   ├── main.tf            # VPC, Subnet, IGW, Security Group, EC2
│   ├── variables.tf       # Configurable inputs (region, instance type)
│   ├── outputs.tf         # Prints Public IP and App URL after deploy
│   ├── provider.tf        # AWS provider configuration
│   └── install_docker.sh  # Bootstrap: installs Docker, runs Nginx container
├── Jenkinsfile            # CI/CD pipeline (init → plan → apply)
└── README.md
```

## Jenkins CI/CD Pipeline
To deploy this via Jenkins:
1. Ensure Jenkins has the **Terraform Plugin** installed.
2. In Jenkins settings (`Manage Jenkins → Tools`), configure a Terraform installation named `terraform`.
3. Configure AWS credentials in Jenkins (`Manage Credentials`) and map them via the Pipeline script environment variables (commented out in the `Jenkinsfile`).
4. Setup a new "Pipeline" job, point it to your Git repository, and it will automatically detect the `Jenkinsfile`.
