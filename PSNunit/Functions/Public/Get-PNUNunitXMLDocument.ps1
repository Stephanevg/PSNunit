Function Get-PNUNunitXMLDocument{
    [CmdletBinding()]
    Param(

    $Path

    )


    return [NunitXMLDocument]::New($Path)

}