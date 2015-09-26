configuration SampleTopShelfContinuousDelivery
{
    $s3Bucket = "INPUT YOUR S3 BUCKET NAME"

    $zip = "S3 KEY ZIP FILE NAME"
    $exe = "SERVICE EXE NAME"
    $serviceName = "SERVICE NAME DEFINED IN TOPSHELF"

    $destination = "C:\DOWNLOADPATH"
    $downloadPath = Join-Path $destination $zip
    $unzipPath = Join-Path $destination $serviceName
    $servicePath = Join-Path $unzipPath "MSBUILD\EXTRACT\PATH\TO\$exe"

    Import-DSCResource -ModuleName GraniResource

    cS3Content SampleTopShelfContinuousDelivery
    {
        S3BucketName = $s3Bucket
        Key = $zip
        DestinationPath = $downloadPath
        PreAction =  {
            if(Get-Service | where Name -eq $using:serviceName){ Stop-Service $using:serviceName }
            if(Test-Path $using:unzipPath){ Remove-Item -Path $using:unzipPath -Recurse -Force }
        }
    }
 
    Archive SampleTopShelfContinuousDelivery
    {
        Ensure = 'Present'
        Path = $downloadPath
        Destination = $unzipPath
    }

    cTopShelf SampleTopShelfContinuousDelivery
    {
        Ensure = "Present"
        Path = $servicePath
        ServiceName = $serviceName
        DependsOn = "[Archive]InstallRapidHouse"
    }

    Service SampleTopShelfContinuousDelivery
    {
        Name = $serviceName
        State = 'Running'
        DependsOn = "[cTopShelf]InstallRapidHouse"
    }
} 
