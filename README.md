# Jenkins System Health Reports Pipeline

## Overview
This project is a Jenkins pipeline that automatically generates system health reports from a Jenkins EC2 instance and uploads them to an S3 bucket. The reports include:

- Date and time
- Hostname
- Uptime
- Memory usage (`free -m`)

After uploading to S3, the local report file is deleted to save disk space.

---

## Prerequisites

1. **Jenkins** running on an **AWS EC2 instance**.
2. **IAM Role** attached to the EC2 instance with permissions to:
   - Create S3 bucket (optional)
   - Upload objects to S3
3. **AWS CLI** installed on the EC2 instance.

---

## Setup Instructions

1. **Clone this repository**:
```bash
git clone https://github.com/<your-username>/JenkinsHealthReports.git
