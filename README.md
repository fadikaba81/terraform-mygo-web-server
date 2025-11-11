# Go Web Server + Terraform Deployment (VPC + EC2 + Private MySQL RDS)

This project deploys a Go web server on an EC2 instance inside a Public Subnet, and a MySQL database on a Private Subnet using Terraform.  
The application stores website hit counts into the MySQL database every time a user visits:

- `/`
- `/about`
- `/contact`

---

## 🏗️ Architecture

                 ┌──────────────────────────────────────────┐
                 │                   AWS                     │
                 │        (Terraform Managed Infra)          │
                 │                                            │
                 │     ┌───────────────┐                     │
```
Internet ───────────▶│ IGW │ │ │
│ └──────┬────────┘ │
│ │ Route Table (Public) │
│ ┌──────▼───────┐ │
│ │ Public Subnet│ │
│ │ EC2 │◀──────┐ │
│ │ Go Web App │ │ HTTP (8080) │
│ └──────────────┘ │ │
│ │ │
│ ┌──────────────┐ │ │
│ │ Private │ │ │
│ │ Subnet │ │ │
│ │ RDS MySQL │◀───────┘ │
│ └──────────────┘ │
└────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
├── app/
│ ├── main.go # Go web server (stores page hits in DB)
│ ├── go.mod
│ └── go.sum
├── terraform/
│ ├── vpc.tf # VPC + Subnets + Route tables + IG
│ ├── ec2.tf # EC2 instance + SGs + user data
│ ├── rds.tf # MySQL RDS in private subnet
│ ├── variables.tf
│ ├── outputs.tf
│ └── provider.tf
└── README.md
```

---

## 💻 Go Web Server

The web app exposes:

| Endpoint  | Description |
|----------|-------------|
| `/`       | Home page   |
| `/about`  | About page  |
| `/contact`| Contact page|

Each visit increments a hit counter for that page in MySQL.

---

## 🐳 Local Testing

Update DB creds as environment variables:

```sh
export DB_HOST=localhost
export DB_USER=root
export DB_PASS=password
export DB_NAME=hits

