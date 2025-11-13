# Asynchronous Web Ingestion Service (SLO Tracker) – Go + MySQL + Terraform + AWS

A high-performance Go service that receives telemetry events from clients (API status, latency, timestamps), processes them asynchronously using goroutines and channels, stores the data in an Amazon RDS **MySQL** database, and exposes Service Level Objective (SLO) metrics for dashboards and monitoring.

This project demonstrates real-world SRE and platform engineering patterns:
- Go concurrency (channels + goroutines)
- Asynchronous event ingestion
- RDS MySQL as a backend
- SLO and error budget calculation
- Terraform provisioning of AWS infra
- API-driven telemetry ingestion
- Cloud-native architecture on EC2

---

## ✨ Project Overview

This system ingests telemetry such as:

- `service` – which service sent the data  
- `latency_ms` – how long the client API call took  
- `status` – HTTP status code  
- `timestamp` – optional  

Clients send telemetry (latency + status), and the Go server:

1. Accepts the event via a REST API  
2. Immediately pushes it into a Go channel (fast response)  
3. Worker goroutines insert the event into **MySQL**  
4. SLO processor computes uptime, latency percentiles, and error budgets  
5. Dashboard endpoints expose SLO status and Prometheus metrics  

---

## 🚀 High-Level Architecture

```
┌──────────────────────────┐
│ Client Applications │
│ (send event telemetry) │
└───────────────┬──────────┘
│ POST /ingest
▼
┌─────────────────────────────────┐
│ Go Web Server (EC2 Instance) │
│ - Exposes REST API │
│ - Queues received events │
└───────────────┬─────────────────┘
│
▼
┌─────────────────────────────────┐
│ Buffered Channel (Event Queue) │
└───────────────┬─────────────────┘
│ background workers
▼
┌─────────────────────────────────┐
│ Worker Goroutines │
│ - Insert events into RDS MySQL │
└───────────────┬─────────────────┘
│
▼
┌─────────────────────────────────┐
│ Amazon RDS MySQL │
│ - Raw event storage │
│ - Latency values │
│ - SLO history windows │
└───────────────┬─────────────────┘
│
▼
┌──────────────────────────────────┐
│ SLO Processor Goroutine │
│ - Computes availability SLO │
│ - Calculates P90/P99 latencies │
│ - Error budget remaining │
└───────────────┬──────────────────┘
│
▼
┌──────────────────────────────────┐
│ Dashboard Endpoints │
│ /slo/status │
│ /metrics (Prometheus) │
└──────────────────────────────────┘
```

---

## 🏗️ AWS Architecture (Terraform)

Terraform provisions the entire infrastructure:

### **Compute**
- Amazon EC2 instance running the Go server  
- Security groups  
- User-data/bootstrap script  

### **Networking**
- VPC  
- Public subnet (EC2)  
- Private subnets (MySQL)  
- Route tables  
- Internet Gateway  

### **Database**
- Amazon RDS **MySQL** instance  
- Private DB subnet group  
- Security group allowing only EC2 → RDS traffic  
- No public DB access  

---

## 📡 How Telemetry Is Sent

Client systems send telemetry via HTTP POST:

```
POST http://<EC2-Public-IP>:8080/ingest
Content-Type: application/json

{
"service": "billing-api",
"latency_ms": 178,
"status": 200
}
```

The client is responsible for measuring its own API latency.

---

## ⚙️ Ingestion Pipeline Breakdown

### **1. REST API Handler**
- Validates the payload  
- Pushes the event into a Go channel  
- Responds immediately with `{ "status": "queued" }`

### **2. Event Queue (Channel)**
Provides buffering and prevents slow clients from blocking ingestion.

### **3. Worker Goroutines**
Continuously:
- Read events from the channel  
- Write them into MySQL  
- Mark good/bad events based on status  

### **4. SLO Processor**
A background goroutine runs every minute and computes:

- Availability (good events / total events)  
- Latency P50/P90/P99  
- Error rate  
- Burn rate  
- Error budget remaining  
- SLO window violations  

These results are exposed through API endpoints for dashboards.

---

## 📊 Dashboard Endpoints

### **`/slo/status`**
Returns:
- Uptime availability  
- Latency percentiles  
- Error budget remaining  
- Overall service health  

### **`/metrics`** (Prometheus)
Metrics include:
- Queue depth  
- Events processed  
- SLO availability  
- Latency P90  
- Error budget gauge  

You can connect Grafana to visualise everything.

---

## 🗄️ Database Schema (Conceptual - MySQL)

### **events**
Stores raw telemetry:
- id  
- service  
- status  
- latency_ms  
- is_good  
- created_at  

### **slo_windows**
Stores computed SLO metrics:
- service  
- window_start  
- window_end  
- good_count  
- bad_count  
- availability  
- latency_p90  

You can expand or optimise this schema as the project evolves.

---

## 🎯 Key Features

- Fast ingestion using Go channels  
- Async MySQL writes via worker goroutines  
- SLO engine for availability + latency  
- Prometheus metrics endpoint  
- Cloud-native AWS architecture  
- Clean, modular design  
- Easy to extend  

---

## 📦 Future Enhancements

- Add HTTPS + ALB  
- Use AWS Secrets Manager for DB credentials  
- Add rate limiting  
- Add OpenTelemetry tracing  
- Add dead letter queue for failed inserts  
- Horizontal autoscaling  
- Build a simple frontend dashboard  

---

## 🧑‍💻 Why This Project Is Valuable

This project demonstrates production-level SRE / Platform Engineering skills:

- Go concurrency (goroutines + channels)  
- Event ingestion pipeline  
- MySQL relational modelling  
- Infrastructure provisioning with Terraform  
- AWS networking & security  
- SLO/error-budget concepts  
- API & monitoring best practices  
