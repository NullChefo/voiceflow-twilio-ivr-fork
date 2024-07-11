# Stage 1: Install dependencies
FROM node:22-alpine AS dependencies

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2: Create a lightweight image for running the application
FROM node:22-alpine AS run

# Install PM2 globally
RUN npm install pm2 -g

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the dependencies stage
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=dependencies /app/package*.json ./
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application with PM2
CMD ["pm2-runtime", "start app.js --attach"]