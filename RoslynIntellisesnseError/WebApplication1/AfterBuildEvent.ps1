$target = "$env:TEMP\Temporary ASP.NET Files\root";

# 対象のパスがないならさっさと終わる
if (!(Test-Path $target))
{
    [Console]::WriteLine("$target path not found. Exit AfterBuildEvent immediately.");
    return;
}

# 対象のパスから C# 6.0 の Roslyn が余計なインテリセンスエラーとして検知する ASP.global_asax が含まれる .cs を拾って置き換える
Get-ChildItem $target -Recurse -File `
| where Extension -eq .cs `
| where {(Get-Content $_.FullName -Raw -Encoding utf8).Contains("ASP.global_asax")} `
| %{
    $file = $_.FullName;
    [Console]::WriteLine("Replacing ASP.global_asax to System.Web.HttpApplication for file : {0}" -f $file);
    # 2度ファイル読み込みが発生してるけど、大したことないので見やすさ優先
    (Get-Content $file -Raw -Encoding utf8).Replace("ASP.global_asax", "System.Web.HttpApplication") | Out-File -FilePath $file -Encoding utf8;
}