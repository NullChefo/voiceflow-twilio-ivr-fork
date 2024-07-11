# Stage 1: Install dependencies
FROM node:22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application files
COPY . .

# Stage 2: Create a lightweight image for running the application
FROM node:22-alpine

# Install PM2 globally in the runtime stage
RUN npm install pm2 -g

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application with PM2
CMD ["pm2-runtime", "app.js --attach"]
