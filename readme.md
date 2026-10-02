# AWS High-Availability & Auto-Scaling Infrastructure (Terraform)

This project contains a production-ready Terraform configuration designed to deploy a highly available, scalable, and isolated web infrastructure on AWS following the **AWS Well-Architected Framework** best practices.

---

# Infrastructure Architecture

The infrastructure is deployed across two Availability Zones (Multi-AZ)

Key Components
# Networking (VPC Module):

    Multi-AZ VPC with 2 Public and 2 Private subnets.

    Internet Gateway (IGW) handling incoming HTTP traffic for the ALB.

    NAT Gateway in a public subnet allowing secure outbound Internet access for private EC2 instances (package updates, AWS SSM connection) without exposing them publicly.

# Compute & Auto-Scaling (ASG Module):

    Launch Template configured with a user_data script to automatically initialize the web server and install testing utilities (stress).

    Auto Scaling Group (min: 2, desired: 2, max: 4) to ensure high availability and automatic workload distribution.

    Target Tracking Scaling Policy: Automatically triggers a Scale-Out event when average CPU utilization across the group exceeds 50%.

    Self-Healing Capability: Automatically terminates and replaces unhealthy or terminated EC2 instances.

# Traffic Balancing (ALB Module):

    Application Load Balancer deployed in public subnets.

    Target Group with HTTP-based Health Checks to route traffic only to healthy instances.

    Traffic distribution algorithm set to Round Robin.

# Security & Access Control:

    AWS Systems Manager (SSM) Session Manager: Full shell access to private instances without open SSH ports (22) or assigned public IPs.

    Minimalistic Security Groups (EC2 instances accept inbound traffic exclusively from the ALB Security Group).


```mermaid
graph TD
    Client[Client] --> IGW[Internet Gateway]
    
    subgraph AWS_Cloud ["AWS Cloud"]
        subgraph Region ["Region: eu-central-1"]
            subgraph VPC ["VPC: 10.1.0.0/16"]
                
                IGW --> ALB[Application Load Balancer]
                NAT -->|Outbound Internet| IGW
                
                subgraph Public_Subnets ["Public Subnets"]
                    subgraph Public_Subnet_1 ["Public Subnet 1 - eu-central-1a / 10.1.10.0/24"]
                        ALB
                    end
                    subgraph Public_Subnet_2 ["Public Subnet 2 - eu-central-1b / 10.1.20.0/24"]
                        NAT[NAT Gateway]
                    end
                end

                ALB --> EC2_1
                ALB --> EC2_2
                ASG -.->|Outbound Traffic| NAT

                subgraph Private_Subnets ["Private Subnets"]
                    subgraph ASG ["Auto Scaling Group"]
                        subgraph Private_Subnet_1 ["Private Subnet 1 - eu-central-1a / 10.1.30.0/24"]
                            EC2_1[EC2 Instance 1]
                        end
                        subgraph Private_Subnet_2 ["Private Subnet 2 - eu-central-1b / 10.1.40.0/24"]
                            EC2_2[EC2 Instance 2]
                        end
                    end
                end

            end
        end
    end