


$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$FullPath = join-Path -path $here -ChildPath $sut

$module = (get-childitem -path (split-path (split-path $FullPath -Parent) -Parent) -Filter "*.psm1").Fullname

import-module $module



$item = get-item ".\pickles.xml"
$myts = [TestResults]::New($item)

$SuiteStats = [TestSuiteStats]::New($myts.TestSuite[0])

Context "Testing TestResults"{

Describe "Testing Constructors"{
    it "Should create a TestSResults instance"{
        $TestSResults | should not be nullorempty
    }
}

}
