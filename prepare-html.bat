@echo OFF
pause
powershell -Command "(Get-Content prod/index.html) -replace '/dist/bundle.js', 'bundle.js' | Out-File -encoding ASCII prod/index.html"
