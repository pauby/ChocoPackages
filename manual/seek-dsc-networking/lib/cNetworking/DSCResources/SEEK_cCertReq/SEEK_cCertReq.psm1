<# NOTE: This SSL certificate request module is designed for Local Dev machines ONLY !!! #>

<#
Retrieves a SSL certificate for a Subject located on machine
#>

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Subject,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$CertPath
    )

    Write-Verbose "Getting CERT"

    $theCert = Get-ChildItem -path $CertPath | Where-Object {$_.Subject -eq $Subject}

    #find the certificate and return
    $certResult = @{
        Subject = $Cert.Subject
        Ensure = "Present"
        SANs = $Cert.DnsNameList
        OnlineCA = $Cert.Issuer
    }

    return $certResult
}

<#
Creates a SSL certificate for a Subject on machine if Present is ensured.
Removes SSL certificate for a Subject on machine if Absent is ensured.
#>
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Subject,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$CertPath,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]]$SANs,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$OnlineCA
    )

    Write-Verbose "Setting CERT"

    if($Ensure -eq "Present")
    {
        Write-Verbose "Creating CERT for $Subject"

        #call certreq
        $subjectDomain = $Subject.split(',')[0].split('=')[1]
        if ($subjectDomain -match "\*.") {
            $subjectDomain = $subjectDomain -replace "\*", "star"
        }
        $CertificateINI = "$subjectDomain.ini"
        $CertificateREQ = "$subjectDomain.req"
        $CertificateRSP = "$subjectDomain.rsp"
        $CertificateCER = "$subjectDomain.cer"

        ### INI file generation
        new-item -type file $CertificateINI -force
        add-content $CertificateINI '[Version]'
        add-content $CertificateINI 'Signature="$Windows NT$"'
        add-content $CertificateINI ''
        add-content $CertificateINI '[NewRequest]'
        $temp = 'Subject="' + $Subject + '"'
        add-content $CertificateINI $temp
        add-content $CertificateINI 'Exportable=TRUE'
        add-content $CertificateINI 'KeyLength=2048'
        add-content $CertificateINI 'KeySpec=1'
        add-content $CertificateINI 'KeyUsage=0xA0'
        add-content $CertificateINI 'MachineKeySet=True'
        add-content $CertificateINI 'ProviderName="Microsoft RSA SChannel Cryptographic Provider"'
        add-content $CertificateINI 'ProviderType=12'
        add-content $CertificateINI 'RequestType=CMC'
        add-content $CertificateINI ''
        add-content $CertificateINI '[RequestAttributes]'
        add-content $CertificateINI 'CertificateTemplate="WebServer"'
        add-content $CertificateINI ''
        add-content $CertificateINI '[EnhancedKeyUsageExtension]'
        add-content $CertificateINI 'OID=1.3.6.1.5.5.7.3.1'
        add-content $CertificateINI ''

        if ($SANs) {
            add-content $CertificateINI '[Extensions]'
            add-content $CertificateINI '2.5.29.17 = "{text}"'

            foreach ($SAN in $SANs) {
                $temp = '_continue_ = "dns=' + $SAN + '&"'
                add-content $CertificateINI $temp
            }
        }

        try
        {
            ### Certificate request generation
            if (test-path $CertificateREQ)     {
                del $CertificateREQ
            }

            Write-Verbose "Converting $CertificateINI to CSR: certreq -new $CertificateINI $CertificateREQ"
            certreq -new $CertificateINI $CertificateREQ

            ### Online certificate request and import
            if ($OnlineCA) {
                if (test-path $CertificateCER) {del $CertificateCER}
                if (test-path $CertificateRSP) {del $CertificateRSP}

                Write-Verbose "Submitting: certreq -submit -config $OnlineCA $CertificateREQ $CertificateCER"
                certreq -submit -config $OnlineCA $CertificateREQ $CertificateCER


                Write-Verbose "Merging certificate response file and CSR together to generate SSL certificate: certreq -accept -config $OnlineCA $CertificateCER"
                certreq -accept -config $OnlineCA $CertificateCER
            }

            Write-Verbose "Finished creating CERT for $Subject"
        }
        catch
        {
            $errorId = "CertReqFailure";
            $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation;
            $errorMessage = "CertGenerationFailure -f ${Name}";
            $exception = New-Object System.InvalidOperationException $errorMessage ;
            $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $errorCategory, $null

            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }

        Test-TargetResource $Subject $CertPath $Ensure $SANs $OnlineCA
    }
    else
    {
        Write-Verbose "Removing CERT for $Subject"
        $theCert = Get-ChildItem -path $CertPath | Where-Object {$_.Subject -eq $Subject}

        if ($theCert -ne $null)
        {
            $Thumbprint = $theCert.Thumbprint
            Remove-Item -Path "$CertPath\$Thumbprint"

            Write-Verbose "Successfully removed CERT for $Subject"
        }
    }
}

<#
Tests a SSL certificate for a Subject IS located on machine if Present is ensured.
Tests a SSL certificate for a Subject IS NOT located on machine if Absent is ensured.
#>
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Subject,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$CertPath,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]]$SANs,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$OnlineCA
    )

    Write-Verbose "Testing CERT"
    #test that the cert is there
    $theCert = Get-ChildItem -path $CertPath | Where-Object {$_.Subject -eq $Subject}

    if ($theCert -ne $null -and $Ensure -eq "Present")
    {
        Write-Verbose "CERT Thumbprint is $theCert"
        Write-Verbose "CERT is expected to be Present and is Present"
        return $true
    }

    if ($theCert -eq $null -and $Ensure -eq "Absent")
    {
        Write-Verbose "CERT is expected to be Absent and is Absent"
        return $true
    }

    return $false
}


#  FUNCTIONS TO BE EXPORTED
Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource
