$jsonBody = @{
    email = "newtest123@gmail.com"
    password = "Password123"
    v_name = "New Test"
    v_username = "newtest123"
} | ConvertTo-Json

Write-Host "Testing registration..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod `
        -Uri "http://localhost:8080/api/auth/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $jsonBody
    
    if ($response.token) {
        Write-Host "SUCCESS! JWT Token generated:" -ForegroundColor Green
        Write-Host $response.token.Substring(0, 80) + "..." -ForegroundColor Yellow
        Write-Host "User: $($response.user.email)" -ForegroundColor Green
    }
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}
