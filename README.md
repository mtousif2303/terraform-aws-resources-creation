# Terraform AWS RDS MySQL

 Creation of AWS RDS MySQL database instance using Terraform 

In this project I moved beyond S3 and provisioned a real managed database on AWS using Terraform. I learned how to define an RDS instance in code, deal with IAM permission errors specific to RDS, and successfully deploy a MySQL database on AWS without touching the console.

---

## Project Structure

```
terraform-aws-rds-mysql/
├── main.tf               # RDS instance configuration
├── .terraform.lock.hcl   # Provider lock file (commit this)
├── .gitignore            # Ignore sensitive/generated files
└── README.md
```

---

<img width="3442" height="2032" alt="image" src="https://github.com/user-attachments/assets/bc32b637-3f23-419b-a23c-e1d29a6ab2fc" />


<img width="3420" height="2010" alt="image" src="https://github.com/user-attachments/assets/0070ee13-c9ad-49f3-8057-60a73798fa6f" />


2) EC2 instance
   
   <img width="3452" height="1760" alt="image" src="https://github.com/user-attachments/assets/d9b4675b-9080-4924-b63c-c826a060c7f7" />
   

3) S3 bucket setup

   <img width="3446" height="1718" alt="image" src="https://github.com/user-attachments/assets/f74df13f-827d-4a65-98d1-47a808886c06" />


4) Github repo create
   

<img width="3446" height="1370" alt="image" src="https://github.com/user-attachments/assets/59d847d7-3e3e-4508-bdf0-17687873802e" />



## Prerequisites

- Terraform installed
- AWS CLI configured
- IAM user with RDS permissions (see Part 2)

---

## Part 1 — Terraform Configuration

### `main.tf`

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "devdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
```

> ⚠️ Never hardcode `access_key` and `secret_key` in your `.tf` files for real projects.
> Use `aws configure` or environment variables instead:
> ```bash
> export AWS_ACCESS_KEY_ID="your_key"
> export AWS_SECRET_ACCESS_KEY="your_secret"
> ```

---

## Part 2 — IAM Permissions Required

The IAM user running Terraform needs the following RDS permissions.

Go to **AWS Console → IAM → Users → terraform-mdtousif → Add Permissions → Attach policies directly**

**Quick fix:** attach `AmazonRDSFullAccess`

**Least privilege — custom policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:CreateDBInstance",
        "rds:DeleteDBInstance",
        "rds:DescribeDBInstances",
        "rds:ModifyDBInstance",
        "rds:ListTagsForResource",
        "rds:AddTagsToResource"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Part 3 — Deploy Commands

```bash
# Step 1 — Initialize Terraform and download AWS provider
terraform init

# Step 2 — Preview what will be created
terraform plan

# Step 3 — Create the RDS instance (type 'yes' when prompted)
terraform apply

# Step 4 — When done, destroy the instance to avoid AWS charges
terraform destroy
```

### Expected Output After Apply

```
aws_db_instance.default: Creating...
aws_db_instance.default: Still creating... [10s elapsed]
aws_db_instance.default: Still creating... [2m elapsed]
aws_db_instance.default: Creation complete after ~3m
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

> 💡 RDS takes 2–5 minutes to provision — this is normal. Don't cancel the apply.

---

## Part 4 — Issues Encountered & Fixes

### ❌ Issue 1: AccessDenied when creating RDS Instance

**Error:**
```
Error: creating RDS DB Instance (terraform-20260321193053433100000001):
operation error RDS: CreateDBInstance, StatusCode: 403,
api error AccessDenied: User: arn:aws:iam::825820235640:user/terraform-mdtousif
is not authorized to perform: rds:CreateDBInstance
because no identity-based policy allows the rds:CreateDBInstance action
```

**Cause:**
The IAM user `terraform-mdtousif` had no permissions to create RDS instances.

**Fix:**
Attached `AmazonRDSFullAccess` policy to the IAM user via:
**AWS Console → IAM → Users → terraform-mdtousif → Add Permissions**

**Result:** Re-ran `terraform apply` and the RDS instance was created successfully. ✅

---

## Part 5 — Git Commands

```bash
git init
git add main.tf README.md .gitignore .terraform.lock.hcl
git commit -m "initial commit: RDS MySQL instance with Terraform"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/terraform-aws-rds-mysql.git
git push -u origin main
```

### Useful Git Commands

| Command | What it does |
|---|---|
| `git status` | See staged / unstaged files |
| `git log --oneline` | See commit history |
| `git reset HEAD .` | Unstage all files |
| `git reset HEAD~1` | Undo last commit, keep files |
| `git reset --hard HEAD~1` | Undo commit + delete changes ⚠️ |

---

## .gitignore

```
# Terraform state — contains sensitive data, never commit
*.tfstate
*.tfstate.backup

# Terraform plan output
tfplan

# Terraform working directory
.terraform/

# Credentials — never commit
*.pem
*.env
terraform.tfvars
```

---

## Key Learnings

- RDS takes 2–5 minutes to provision — this is expected
- Every `403 AccessDenied` error means a missing IAM permission — attach the right policy and re-run
- Never hardcode AWS credentials in `.tf` files — use `aws configure` or environment variables
- `skip_final_snapshot = true` is needed for Terraform to destroy RDS without errors
- Always run `terraform destroy` after learning exercises to avoid unexpected AWS charges

---

## Resources

- [Terraform RDS Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [AWS RDS MySQL Docs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
