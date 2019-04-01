Function Get-PNUnintTestCase {
    <#
    .SYNOPSIS
        Get all the Test cases.
    .DESCRIPTION
        Will return all the test cases from a Document or a TestSuite.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='Document')]
        [NunitXMLDocument]$Document, 
        
        [Parameter(ParameterSetName='TestSuite')]
        [TestSuite[]]$TestSuite = @(),

        [ValidateSet('Success','Failure','All')]
        $Status = 'All'

    )
    
    begin {
    }
    
    process {
        If($Document){

            $TestSuite = @()
            $TestSuite = Get-PNUNuniTestSuite -Document $Document 
        }
        Foreach($TestCase in $TestSuite){
            If($Status -eq 'All'){

                $TestCase.Results 
            }Else{
                $TestCase | ? {$_.Result -eq $Status}
            }
        }
        
    }
    
    end {
    }
}