Function Join-ValueNode
{
param (
    [System.Xml.XmlElement] $Original,
    [System.Xml.XmlElement] $Override
)

if ($null -eq $Original -or $null -eq $Override) { return }
$Original.'#text' = $Override.'#text'
}

Function Merge-XML {

Param
(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory = $true)] [string] $BaseXMLfile,
    [Parameter(Mandatory = $true)] [string] $OverrideXMLfile
)

$originalXml = [xml](Get-Content $BaseXMLfile)
$overrideXml = [xml](Get-Content $OverrideXMLfile)

$RootElementname = $originalXML.DocumentElement.Name

$BaseRootNode = $originalXml.SelectSingleNode("/$RootElementname")
$OverrideRootNode = $OverrideXml.SelectSingleNode("/$RootElementname")

ForEach ($ChildNode in $OverrideRootNode.ChildNodes)
{
    $BaseNode = $BaseRootNode.SelectSingleNode("$($ChildNode.name)") 
    If ($ChildNode.'#text') {

        Write-Verbose "Merging text XML node $($ChildNode.name)"
        $BaseNode.'#text' = $ChildNode.'#text'
    }

    Else {
        ForEach ($SubChildNode in $ChildNode.ChildNodes) {

            $scn = $SubChildNode.name

            If ($SubChildNode.HasAttribute("Name")) {

                $PreviousSibling = $SubChildNode.LocalName
                $OriginalNamedNode = $BaseNode.SelectSingleNode("$PreviousSibling[@Name='$scn']")
                $OverrideNamedNode = $ChildNode.SelectSingleNode("$PreviousSibling[@Name='$scn']")

                ForEach ($cn in $OverrideNamedNode.ChildNodes) {

                    Write-Verbose "Merging attribute-based XML node $($cn.localname)"

                    Join-ValueNode -Original $OriginalNamedNode.SelectSingleNode($cn.Localname) -Override     $OverrideNamedNode.SelectSingleNode($cn.LocalName)
                }
            }
            Else {

                Write-Verbose "Merging normal XML node $($SubChildNode.name)"
                Join-ValueNode -Original $BaseNode.SelectSingleNode($SubChildNode.name) -Override $ChildNode.SelectSingleNode($SubChildNode.name)
            }            
        }
    }
}

    Return $originalXml

}