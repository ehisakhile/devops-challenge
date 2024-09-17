# Project Documentation

## Overview

This project leverages Kubernetes (K8s) to deploy, manage, and scale the *bird-fact-app* and *bird-fact-service*. The application is designed with high availability and scalability in mind, using Kubernetes Horizontal Pod Autoscaling (HPA) to adjust the number of application instances based on real-time resource utilization.

## Setting up Autoscaling
For high availability and to manage fluctuating workloads, I implemented Horizontal Pod Autoscaling (HPA) in the Kubernetes manifest. This ensures that the number of running pods adjusts automatically based on CPU and memory usage, helping maintain application performance and optimize resource usage. To gather resource usage data such as CPU and memory from the cluster, I used **Metric Server** because it is lightweight and meets the demand of the application.