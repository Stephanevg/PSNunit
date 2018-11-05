
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$FullPath = join-Path -path $here -ChildPath $sut

$module = (get-childitem -path (split-path (split-path $FullPath -Parent) -Parent) -Filter "*.psm1").Fullname

import-module $module



$item = Get-Item "C:\Users\taavast3\OneDrive\Scripting\Repository\Modules\PoshNunitXML\NTOSIMPD116_CompliancyReport_20170222-092429.xml"
$item = get-item "C:\Users\taavast3\OneDrive\Scripting\Repository\Modules\PoshNunitXML\Tests\pickles.xml"
$myts = [TestResults]::New($item)


$SuiteStats = [TestSuiteStats]::New($myts.TestSuite[0])

Foreach ($suite in $myts.TestSuite) {


    Context "Testing Results of $($suite.Name)" {

        Describe "[$($suite.Name)] Testing Properties for " {

            It "Should be of type TestFixture (in string format)" {
                $suite.Type | should be "TestFixture"
            }

            It "Should have exectued" {
                $suite.Executed | should be $true
            }

            It "Should have a time entry" {
                $suite.time | should not be NullOrEmpty
            }
            It "Should have exectued" {
                $suite.Executed | should be $true
            }
            It "Should have a result value of type [Result]" {
                $suite.Result.GetType().FullName | should be Result
            }
            
            It "Should have results values (if exectued)"{

                if ($suite.Executed -eq $true){
                    $suite.Results | should not be NullOrEmpty
                }else{
                    Set-TestInconclusive -Message "Cannot be evaluated if tests never ran."
                }

            }

        }

    }

}
