# Stage 1: Build the Go binary
FROM golang:1.20 AS builder

# Set working directory inside the container
WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY main.go ./

# Build the Go binary
RUN go build -o main .

# Stage 2: Create a minimal image
FROM alpine:latest

# Install CA certificates for HTTPS if needed
RUN apk --no-cache add ca-certificates

# Set working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose the port your app runs on (update as needed)
EXPOSE 8080

# Run the binary
CMD ["./main"]
