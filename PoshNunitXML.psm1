
Class TestResults {
    [String]$Name
    [dateTime]$ExecutionDate

    [TestEnvironment]$TestEnvironment
    [CultureInfo]$CultureInfo
    [TestSuite[]]$TestSuite
    [TestSuite]$TestResults
    [TestStats]$TestStats
    hidden [String]$RawResults

    #New Classwhere-object

    TestResults([System.IO.FileInfo]$TestDocument) {
        $this.RawResults = Get-Content $TestDocument.FullName

        [xml]$x = $this.RawResults
        #Parsing XML

        $Tres = (select-xml -Xml $x -XPath "test-results").Node
        $this.Name = $Tres.Name
        
        $splitedtime = ($Tres.time.split(":"))

        $this.ExecutionDate = Get-date -Date $Tres.date -Hour $splitedtime[0] -Minute $splitedtime[1] -Second $splitedtime[2]


        $TestEnv = (select-xml -Xml $x -XPath "/test-results/environment").Node
  
        $this.TestEnvironment = [TestEnvironment]::New($TestEnv)

        $ci = (select-xml -Xml $x -XPath "/test-results/culture-info").Node
        $this.CultureInfo = [CultureInfo]::New($ci)

        $TestReslts = (select-xml -Xml $x -XPath "/test-results/test-suite").Node
        $this.TestResults = [TestSuite]::New($TestReslts)
        #$this.TestSuite = $TestSuite
        $AllTestSuites = (select-xml -Xml $x -XPath "/test-results/test-suite").Node.Results.'test-suite'
        
        foreach ($t in $AllTestSuites) {
            $This.TestSuite += [TestSuite]::New($t) 
        }

        $this.TestStats = [TestStats]::New($this)

        #I know this is ugly, but until I find a smarter way to add this information in TestStats class, I'll have to leave here.
        
        #$this.Stats.total = $Tres.total
        $this.TestStats.errors = $Tres.errors
        $this.TestStats.TotalTestCases = $Tres.total
        $this.TestStats.TotalTestCaseFailures = $Tres.failures
        $this.TestStats.notrun = $Tres.'not-run'
        $this.TestStats.inconclusive = $Tres.inconclusive
        $this.TestStats.ignored = $Tres.ignored
        $this.TestStats.skipped = $Tres.skipped
        $this.TestStats.Invalid = $Tres.Invalid

    }
}

Class TestEnvironment {

    [string]$User
    [String]$MachineName
    [String]$cwd
    [String]$UserDomain
    [String]$Platform
    [String]$NunitVersion
    [String]$OsVersion
    [String]$CLRVersion

    TestEnvironment([System.Xml.XmlElement]$XmlElement) {
        $this.User = $XmlElement.User
        $this.MachineName = $XmlElement.'machine-name'
        $this.cwd = $XmlElement.'cwd'
        $this.UserDomain = $XmlElement.'user-domain'
        $this.platform = $XmlElement.platform
        $this.NunitVersion = $XmlElement.'nunit-version'
        $this.OsVersion = $XmlElement.'os-version'
        $this.CLRVersion = $XmlElement.'clr-version'
    }

    TestEnvironment([string]$User, [string]$MachineName, [string]$cwd, [string]$Userdomain, [string]$PlatForm, [string]$NunitVersion, [string]$OsVersion, [string]$CLRVersion) {
        $this.User = $User
        $this.MachineName = $MachineName
        $this.cwd = $cwd
        $this.UserDomain = $userdomain
        $this.platform = $platform
        $this.NunitVersion = $nunitversion
        $this.OsVersion = $osversion
        $this.CLRVersion = $clrversion
    }
}

Class CultureInfo {
    [String]$CurrentCulture
    [String]$CurrentUICulture

    CultureInfo([System.Xml.XmlElement]$XmlElement) {
        $this.CurrentCulture = $XmlElement.'current-culture'
        $this.CurrentUICulture = $XmlElement.'current-uiculture'
    }

    CultureInfo([String]$CurrentCulture, [String]$CurrentUICulture) {
        $this.CurrentCulture = $currentculture
        $this.CurrentUICulture = $currentuiculture
    }
}

Class TestSuite {
    [string] $Type
    [String] $Name
    [double]$Time
    [Bool] $Executed
    [Result]$Result
    [Bool]$Success
    
    [int]$Asserts
    [TestCase[]]$Results
    [TestSuiteStats]$Stats

    TestSuite([String]$Name, [String]$Type, [double]$Time, [int]$Asserts, [Bool]$Success, [Result]$Result, [Bool]$Executed, [TestCase[]]$Results) {
        $this.Name = $Name
        $This.Type = $Type
        $this.Time = $Time
        $this.Asserts = $Asserts
        $This.Success = $Success
        $this.Result = $Result
        $This.Executed = $Executed
        $This.Results = $Results
    }

    TestSuite([System.Xml.XmlElement]$XmlElement) {
        $this.Type = $XmlElement.type
        $this.Name = $XmlElement.Name
        $this.Executed = $XmlElement.Executed
        $this.Result = $XmlElement.result
        $this.Success = $XmlElement.Success
        $This.Executed = $XmlElement.Executed
        $This.Time = $XmlElement.time

        $res = @()
        foreach ($tc in $XmlElement.Results.'test-case') {
 
            $Res += [TestCase]::New($tc)
        }

        $this.Results = $res

        #$this.Stats = [TestSuiteStats]::New($this)
    }
}

Class TestCase {
    [String]$Name
    [String]$Description
    [double]$Time
    [int]$Asserts
    [Bool]$Success
    [Result]$Result
    [Bool]$Executed
    [Failure]$Failure

    TestCase([String]$Name, [String]$Description, [double]$Time, [int]$Asserts, [Bool]$Success, [Result]$Result, [Bool]$Executed) {
        $this.Name = $Name
        $this.Description = $Description
        $this.Time = $Time
        $this.Asserts = $Asserts
        $This.Success = $Success
        $this.Result = $Result
        $This.Executed = $Executed
    }

    TestCase([String]$Name, [String]$Description, [double]$Time, [int]$Asserts, [Bool]$Success, [Result]$Result, [Bool]$Executed, [Failure]$Failure) {
        $this.Name = $Name
        $this.Description = $Description
        $this.Time = $Time
        $this.Asserts = $Asserts
        $This.Success = $Success
        $this.Result = $Result
        $This.Executed = $Executed
        $This.Failure = $Failure
    }

    TestCase([system.xml.XmlElement]$XmlElement) {
        $this.Name = $XmlElement.name
        $this.Description = $XmlElement.description
        $this.Time = $XmlElement.time
        $this.Asserts = $XmlElement.asserts
        $This.Success = $XmlElement.success
        $this.Result = $XmlElement.result
        $This.Executed = $XmlElement.executed

        if ($this.Success -eq "Failure") {
            $This.Failure = [failure]::New($XmlElement.failure)
        }
        else {
            $this.Failure = $null
        }
        
    }
}

Class Failure {
    [string]$Message
    [string]$Stack

    Failure([system.xml.XmlElement]$XmlElement) {
        $this.Message = $XmlElement.Message
        $this.Stack = $XmlElement.'stack-trace'
    }

    Failure([string]$Message, [string]$Stack) {
        $this.Message = $Message
        $this.Stack = $Stack
    }

}

Enum Result{
    Success
    Failure
}

Class TestStats {
    [string]$Name
    [int]$FailedTestSuites
    [int]$SuccessFullTestSuites
    [double]$percentageSuccess
    [double]$percentageFailed
    [double]$TotalTime
    [int]$TotalTestSuites

    [int]$TotalTestCases
    [int]$errors
    [int]$TotalTestCaseFailures
    [int]$notrun
    [int]$inconclusive
    [int]$ignored
    [int]$skipped
    [int]$Invalid


    [TestSuiteStats[]]$TestSuiteStats

    TestStats([TestResults]$TestResults){
        $this.Name = $TestResults.Name
        $this.TotalTime = [Math]::Round($TestResults.TestResults.Time,2)
        $this.SuccessFullTestSuites = $TestResults.TestResults.Success
        $this.TotalTestSuites = $TestResults.TestSuite.count
        #$this.TotalTestCases = $TestResults.TestResults.total
        $this.FailedTestSuites = ($TestResults.TestSuite | where-object {$_.Result -eq 'Failure'}).Count
        $this.SuccessFullTestSuites = ($TestResults.TestSuite | where-object {$_.Result -eq 'Success'}).Count
        $this.percentageSuccess =  [Math]::Round((100 * $this.SuccessFullTestSuites)/$this.TotalTestSuites,2)
        $this.percentageFailed =  [Math]::round((100 * $this.FailedTestSuites)/$this.TotalTestSuites,2)
        
        $this.Name

        foreach ($ts in $TestResults.TestSuite){
            $this.TestSuiteStats += [TestSuiteStats]::New($ts)
        }
        
        
    }

    

    [TestCase[]]GetFailedTestCases([TestSuite]$TestSuite){
        return $TestSuite.Results | where-object {$_.Result -eq [Result]::Failure}
    }

    [TestCase[]]GetSuccessfullTestCases([TestSuite]$TestSuite){
        return $TestSuite.Results | where-object {$_.Result -eq [Result]::Succes}
    }

    # [TestSuite]GetLongestTestSuite(){
    #     return $return
    # }
}

Class TestSuiteStats {
    [String]$Name
    [int]$Failed
    [int]$Success
    [double]$percentageSuccess
    [double]$percentageFailed
    [int]$Time
    [int]$TotalTestCases
    [TestCase[]]$FailedTestCases
    [TestCase[]]$SuccessfullTestCases

    TestSuiteStats([TestSuite]$TestSuite){
        $This.Name = $TestSuite.Name
        $this.TotalTestCases = $TestSuite.Results.count
        $this.Failed = ($TestSuite.Results | where-object {$_.Result -eq 'Failure'}).Count
        $this.Success = ($TestSuite.Results | where-object {$_.Result -eq 'Success'}).Count
        $this.Time = $TestSuite.Time
        $this.percentageSuccess =  [Math]::Round((100 * $this.Success)/$this.TotalTestCases,2)
        $this.percentageFailed =  [Math]::round((100 * $this.Failed)/$this.TotalTestCases,2)
        $This.FailedTestCases = ($TestSuite.Results | where-object {$_.Result -eq 'Failure'})
        $This.SuccessfullTestCases = ($TestSuite.Results | where-object {$_.Result -eq 'Success'})
    }



}


# $TestCases = @()
# for ($i = 0; $i -le 25; $i++) {
#     $TestCases += [TestCase]::new("Test$($i)", "Description n° $($i)", 2.43, 0, $true, "Success", $true)
# }

# $Suite = [TestSuite]::New("Standard Compliancy Tests", "TestFixture", 12.3456 , 2, $false, "Failure", $True, [TestCase[]]$TestCases)
# #$Suite

#$item = Get-Item "C:\Users\taavast3\OneDrive\Scripting\Repository\Unclassified\_builds\Pester\NTOSDPP102_CompliancyReport_20170221-173357.xml"

#$myts = [TestResults]::New($item)


#$SuiteStats = [TestSuiteStats]::New($myts.TestSuite[0])

#$SuiteStats

