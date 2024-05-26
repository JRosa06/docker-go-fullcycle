# Build step
FROM golang:1.20-alpine AS builder

# Define working directory
WORKDIR /app

# Copy the main.go file to the working directory
COPY src/main.go ./

# Create the go module and download dependencies
RUN go mod init fullcycle && go mod tidy

# Compile the application with optimizations to reduce size
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o fullcycle .

# Execution step
FROM scratch

# Copy the builder binary to the final image
COPY --from=builder /app/fullcycle /fullcycle

# Run the application
CMD ["/fullcycle"]
