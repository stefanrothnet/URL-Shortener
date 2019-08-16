function Test-URL($url) {
	$uri = $url -as [System.URI]
	$uri.AbsoluteURI -ne $null -and $uri.Scheme -match '[http|https]'
}


function New-RebrandlyURL
{
        
    [CmdletBinding()]
       param

       (

              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $Url,
              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $Key,
              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $DomainId,
              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $WorkspaceId

       )

        $uri= "https://api.rebrandly.com/v1/links"
        
        if(!(Test-URL($Url)))

       {

              throw "Not a valid $($Url)" 

       }
       Else
       {

                $requestHeaders = @{'Content-Type'= "application/json";'apikey'=$Key;'workspace_id'=$WorkspaceId}
                $body = @{'destination'=$Url;'domain'=@{'id'=$DomainId}} | ConvertTo-Json
                $response = Invoke-WebRequest -Uri $uri -Headers $requestHeaders -Method Post -Body $body
                Write-Verbose ($response.Content | ConvertFrom-Json).shortUrl
       		    return ($response.Content | ConvertFrom-Json).shortUrl
       
       }

}

function New-PrivateURL
{
        
    [CmdletBinding()]
       param

       (

              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $Url,
              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $Key,
              [Parameter(Mandatory=$true)]

              [ValidateNotNullOrEmpty()]

              [string] $FunctionUrl

       )

        $uri= $FunctionUrl + "/api/UrlIngest?code=" + "$Key"
        
        if(!(Test-URL($Url)))

        {

                throw "Not a valid $($Url)" 

        }
       Else
        {

                $requestHeaders = @{'Content-Type'= "application/json"}
                $body = @{'input'=$Url} | ConvertTo-Json
                $response = Invoke-WebRequest -Uri $uri -Headers $requestHeaders -Method Post -Body $body
                Write-Verbose ($response.Content | ConvertFrom-Json).shortUrl[0]
       	        return ($response.Content | ConvertFrom-Json).shortUrl[0]       
        }

}

Export-ModuleMember -Function New*