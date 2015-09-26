$target = "$env:TEMP\Temporary ASP.NET Files\root";

# �Ώۂ̃p�X���Ȃ��Ȃ炳�����ƏI���
if (!(Test-Path $target))
{
    [Console]::WriteLine("$target path not found. Exit AfterBuildEvent immediately.");
    return;
}

# �Ώۂ̃p�X���� C# 6.0 �� Roslyn ���]�v�ȃC���e���Z���X�G���[�Ƃ��Č��m���� ASP.global_asax ���܂܂�� .cs ���E���Ēu��������
Get-ChildItem $target -Recurse -File `
| where Extension -eq .cs `
| where {(Get-Content $_.FullName -Raw -Encoding utf8).Contains("ASP.global_asax")} `
| %{
    $file = $_.FullName;
    [Console]::WriteLine("Replacing ASP.global_asax to System.Web.HttpApplication for file : {0}" -f $file);
    # 2�x�t�@�C���ǂݍ��݂��������Ă邯�ǁA�債�����ƂȂ��̂Ō��₷���D��
    (Get-Content $file -Raw -Encoding utf8).Replace("ASP.global_asax", "System.Web.HttpApplication") | Out-File -FilePath $file -Encoding utf8;
}