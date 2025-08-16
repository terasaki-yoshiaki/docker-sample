#!/bin/bash

echo "Building Calculator App with Docker..."

# Build backend image
echo "Building Java backend..."
cd backend
docker build -t java-backend-app .
if [ $? -ne 0 ]; then
    echo "Backend build failed"
    exit 1
fi

# Build frontend image
echo "Building React Native frontend..."
cd ../frontend
docker build -t react-native-frontend .
if [ $? -ne 0 ]; then
    echo "Frontend build failed"
    exit 1
fi

echo "Build complete!"
echo ""
echo "To run the application:"
echo "  docker-compose up"
echo ""
echo "Access the application at:"
echo "  Backend API: http://localhost:8080"
echo "  Frontend: http://localhost:3000"