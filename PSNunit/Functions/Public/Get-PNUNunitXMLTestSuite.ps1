
function Get-PNUNunitXMLTestSuite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [NunitXMLDocument]$Document
    )
    
    begin {
    }
    
    process {
        foreach($doc in $Document){
            
            #REturning Test suite
            $Doc.TestSuite
        }
    }
    
    end {
    }
}
