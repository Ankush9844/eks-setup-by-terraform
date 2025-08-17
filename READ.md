# Lesson 1: VPC Module in Terraform 🚀

In this lesson, we will build a **custom VPC using Terraform**.  
This VPC will be the foundation for deploying our EKS cluster and other AWS resources.  

---

## 🎯 Learning Goals
By the end of this lesson, you’ll learn:
- How to create a reusable **Terraform VPC module**
- Defining **VPC**, **CIDR blocks**, and **Internet Gateway**
- Setting up **public and private subnets**
- Attaching **Route Tables** and **NAT Gateway**
- How to structure your Terraform project

---

## 📂 Project Structure
We’ll follow a modular approach:

── modules/
 └── vpc/
  ├── main.tf
  ├── variables.tf
  └── outputs.tf

# Explanation

## 🔎 Explaning Availability Zones Data Source

```h
data "aws_availability_zones" "zones" {
  state = "available"
}
```

- This is a Terraform data source.
- Instead of creating something new, it reads information from AWS.
- Here, it fetches all Availability Zones (AZs) that are in the available state in the REGION you configured in your AWS provider.
- Instead of hardcoding AZs, we let Terraform dynamically fetch them.
- This makes our code reusable across regions (e.g., us-east-1, eu-west-1) without changes.


```h
output "zones" {
  value = data.aws_availability_zones.zones.names
}
```
- Terraform outputs the fetched AZs when you run 'Terraform plan' or 'Terraform apply'

- Example output:

```h
availability_zones = [
      + "us-east-1a",
      + "us-east-1b",
      + "us-east-1c",
      + "us-east-1d",
      + "us-east-1e",
      + "us-east-1f",
    ]
```

## 🔎 Explaning Subnet CIDR calculation

```h
cidr_block = cidrsubnet("${var.cidr_block}", 8, count.index)
```

Terraform provides a built-in function cidrsubnet() to calculate subnet CIDRs automatically from a base VPC CIDR.

### **Syntax**

```bash
cidrsubnet(prefix, newbits, netnum)
```

- prefix → The base CIDR block (e.g., 10.0.0.0/16)
- newbits → How many extra bits to add to the prefix (controls subnet size)
- netnum → Which subnet number to generate (0,1,2,…)

### **Example**

```bash
var.cidr_block = "10.0.0.0/16"
```

It will make,

```bash
cidrsubnet("10.0.0.0/16", 8, 0)  → 10.0.0.0/24
cidrsubnet("10.0.0.0/16", 8, 1)  → 10.0.1.0/24
cidrsubnet("10.0.0.0/16", 8, 2)  → 10.0.2.0/24
cidrsubnet("10.0.0.0/16", 8, 3)  → 10.0.3.0/24
```

### Why 8?

Original VPC CIDR = /16 (65,536 IPs)

Adding 8 bits makes it /24 (256 IPs per subnet).

So each subnet gets 256 addresses.

### With count.index

When you create multiple subnets in a loop:

```h
resource "aws_subnet" "public" {
  count      = 3
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
}
```

Terraform will generate:

-> Subnet 1 → 10.0.0.0/24
-> Subnet 2 → 10.0.1.0/24
-> Subnet 3 → 10.0.2.0/24

Automatically calculated, no manual CIDR typing needed ✅
