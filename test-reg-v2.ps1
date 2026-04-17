$jsonBody = @{
    email = "testuser@example.com"
    password = "TestPassword123"
    v_name = "Test User"
    v_username = "testuser001"
} | ConvertTo-Json

Write-Host "Sending registration request..." -ForegroundColor Cyan
Write-Host "Body: $jsonBody" -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod `
        -Uri "http://localhost:8080/api/auth/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $jsonBody
    
    Write-Host "SUCCESS! Response:" -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
    
    if ($response.token) {
        Write-Host "JWT Token received: $($response.token.Substring(0, 50))..." -ForegroundColor Green
    }
} catch {
    Write-Host "ERROR! Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "Message: $_" -ForegroundColor Yellow
}
