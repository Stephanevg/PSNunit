Function Get-NunitXMLDocument{
    [CmdletBinding()]
    Param(

    $Path

    )


    return [NunitXMLDocument]::New($Path)

}