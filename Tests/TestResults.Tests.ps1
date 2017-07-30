


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$FullPath = join-Path -path $here -ChildPath $sut

$module = (get-childitem -path (split-path (split-path $FullPath -Parent) -Parent) -Filter "*.psm1").Fullname

import-module $module



$item = Get-Item "C:\Users\taavast3\OneDrive\Scripting\Repository\Modules\PoshNunitXML\NTOSIMPD116_CompliancyReport_20170222-092429.xml"

$myts = [TestResults]::New($item)
$item = get-item "C:\Users\taavast3\OneDrive\Scripting\Repository\Modules\PoshNunitXML\Tests\pickles.xml"
$myts = [TestResults]::New($item)

$SuiteStats = [TestSuiteStats]::New($myts.TestSuite[0])

Context "Testing TestResults"{

Describe "Testing Constructors"{
    it "Should create a TestSResults instance"{
        $TestSResults | should not be nullorempty
    }
}

}
