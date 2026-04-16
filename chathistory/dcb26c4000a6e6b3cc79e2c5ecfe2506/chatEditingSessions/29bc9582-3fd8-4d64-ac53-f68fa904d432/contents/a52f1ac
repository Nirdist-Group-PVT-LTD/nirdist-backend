$baseUrl = "https://api.nirdist.com.np/api"
$body = @{
    v_name = "Test User"
    v_username = "testuser_$(Get-Random)"
    email = "test_$(Get-Random)@example.com"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "$baseUrl/auth/register" `
    -Method POST `
    -Headers @{"Content-Type" = "application/json"} `
    -Body $body

Write-Host "Response Status: $($response.StatusCode)"
Write-Host "Response Content: $($response.Content)" | ConvertFrom-Json
