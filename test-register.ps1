$body = @{
    email = 'test123@example.com'
    password = 'Test123'
    v_name = 'Test User'
    v_username = 'testuser123'
} | ConvertTo-Json

$response = Invoke-RestMethod `
    -Uri 'http://localhost:8080/api/auth/register' `
    -Method POST `
    -ContentType 'application/json' `
    -Body $body `
    -SkipHttpErrorCheck

Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
Write-Host "Response Body:" -ForegroundColor Green
$response | ConvertTo-Json
