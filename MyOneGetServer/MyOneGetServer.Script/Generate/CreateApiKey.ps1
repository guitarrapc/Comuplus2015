﻿[Guid]::NewGuid().ToString().Replace("-","")
# PowerShell v5 and later can be...
(New-Guid).ToString().Replace("-","")