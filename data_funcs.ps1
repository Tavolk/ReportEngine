Remove-Variable * -ErrorAction SilentlyContinue

function data_call {
    param ($item_ID,$source_ID,$data_type,$extra_params)
    
    switch ($data_type)
        {
            "datasource" {
                            #this is for a datasource, so it uses the following resource string, and the parameters as defined.
                            $resource_path = "/device/devices/$item_ID/devicedatasources/$source_ID/data"

                         }
            "devices"    {
                            #doesnt use most parameters
                            $resource_path = "/device/devices"
                                  
                         }
            "groups"{
                        #get host groups
                            $resource_path = "/device/groups"
                         }
            "devicesbygroup" {
                            #get devices in a group
                            $resource_path = "/device/groups/$item_ID/devices"
                    }

        }
    
    #build the param string to append
    $paramString = "?"
    foreach ($param in $extra_params)
        {
            $paramString += "$param&"
        } 
    #for neatness
    $paramString = $paramString.TrimEnd("&")



    #get the access key details and other constants
    $accessId = 'cf3BrMZN6pW5a6vAPn2J'
    $accessKey = 'Btx4{~JH$6GWgRX25RPR}LI_q-N97Y2n93E5Swd5'
    $httpVerb = "GET"
    $company = "ans"

    
    
    #build the URL
    $url = 'https://' + $company + '.logicmonitor.com/santaba/rest' + $resource_path + $paramString

    <# Get current time in milliseconds #>
    $epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)


    <# Concatenate Request Details #>
    $requestVars = $httpVerb + $epoch + $resource_path

    <# Construct Signature #>
    $hmac = New-Object System.Security.Cryptography.HMACSHA256
    $hmac.Key = [Text.Encoding]::UTF8.GetBytes($accessKey)
    $signatureBytes = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($requestVars))
    $signatureHex = [System.BitConverter]::ToString($signatureBytes) -replace '-'
    $signature = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($signatureHex.ToLower()))


    <# Construct Headers #>
    $auth = 'LMv1 ' + $accessId + ':' + $signature + ':' + $epoch
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization",$auth)
    $headers.Add("Content-Type",'application/json')
    
    <# Make Request #>
    $response = Invoke-RestMethod -Uri $url -Method Get -Header $headers 

    write-host $url
    Return $response

}

