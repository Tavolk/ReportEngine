Remove-Variable * -ErrorAction SilentlyContinue
. ".\data_funcs.ps1"
. ".\pres_funcs.ps1"
. ".\utility_func.ps1"

$base_xml = ".\default.xml"
$override_xml = ".\overrides.xml"
 
$settings_merged = Merge-XML $base_xml $override_xml

Write-Host $settings_merged.settings.resources.path
Write-Host $settings_merged.settings.queryparams.preferredCollectorGroupname

#$item = 1362
#$source = 64604
#$params = @("period=178";"fields=id,name")


$item = 0
$source = 0
$params = @("size=10";"filter=systemProperties.name:system.staticgroups,systemProperties.value~Addleshaw%20Goddard*")


$result = data_call $item $source "devices" $params
$out = $result.data | ConvertTo-Json -Depth 100



<#
$item = 1362
$source = 64604
$params = @("period=178";"fields=id,name")

$result = data_call $item $source "datasource" $params
#$result.data | ConvertTo-Json -Depth 100

#>

<#
$params = @("filter=parentId:1")
$result = data_call 0 0 "groups" $params

$out = $result.data | ConvertTo-Json
#>

<#
$item = 148

$result = data_call $item 0 "devicesbygroup" $params
#>

Remove-Item output.txt
Add-content output.txt $out


#got customer id.. need to find all devices that apply to it, how?

#using customer id, retrieve all devices of type X for them
