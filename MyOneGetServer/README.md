# MyOneGetServer

Sample for Custom OneGet Server with NuGet Server

# How to

Launch ```MyOneGetServer.sln``` and Debug **MyOneGetServer** Project.

# Detail article

- [PackageManagement (aka. OneGet) の プライベートパッケージソースを NuGet Server で立ててみよう](http://tech.guitarrapc.com/entry/2015/09/04/042449)

# Management

Add Source
----

```powershell
# Get-PackageSource で Chocolatey の登録がされてない場合
Register-PackageSource -Name chocolatey -Provider PSModule -Trusted -Location http://chocolatey.org/api/v2/

# MyOneGet の登録
Register-PackageSource -Name MyOneGet -Location http://http://myoneget-comtechfest.azurewebsites.net/nuget -Trusted -Force -ProviderName chocolatey
```

Find Package
----

```pwoershell
Find-Package -Source MyOneGet
```
