# Stage 1: Build the Go app
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod ./

RUN go mod download

# Copy the rest of the Go source code
COPY . .

# Build the Go app
RUN go build -o bird-fact-app .

# Stage 2: Create a smaller image for running the app
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /root/

# Copy the Go binary from the builder stage
COPY --from=builder /app/bird-fact-app .

# Expose the port that the service listens on
EXPOSE 4201

# Command to run the binary
CMD ["./bird-fact-app"]
