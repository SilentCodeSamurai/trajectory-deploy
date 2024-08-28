# Deploy.ps1

# Ensure environment variables are loaded
. .\load-env.ps1

# Check if the required environment variables are set
if (-not $env:STACK_NAME) {
    Write-Host "STACK_NAME is not set. Please check your .env file."
    exit 1
}

# Use the loaded environment variables
Write-Host "Removing deployment of stack $env:STACK_NAME"

# Remove the stack using Docker
docker stack rm $env:STACK_NAME
