#Nunit 3.0 XML Schema
    #https://github.com/nunit/docs/wiki/Test-Result-XML-Format

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


Class TestCase {
    [String]$Name
    [String]$Description
    [double]$Time
    [int]$Asserts
    [Bool]$Success
    [Result]$Result
    [Bool]$Executed
    [Failure]$Failure
    $Type

    TestCase([String]$Name, [String]$Description, [double]$Time, [int]$Asserts, [Bool]$Success, [Result]$Result, [Bool]$Executed) {
        $this.Name = $Name
        $this.Description = $Description
        $this.Time = $Time
        $this.Asserts = $Asserts
        $This.Success = $Success
        $this.Result = $Result
        $This.Executed = $Executed
        $this.Type = "TestCase"
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
        $this.Type = "TestCase"
    }

    TestCase([system.xml.XmlElement]$XmlElement) {
        $this.Name = $XmlElement.name
        $this.Description = $XmlElement.description
        $this.Time = $XmlElement.time
        $this.Asserts = $XmlElement.asserts
        $This.Success = $XmlElement.success
        $this.Result = $XmlElement.result
        $This.Executed = $XmlElement.executed
        $this.Type = "TestCase"
        if ($this.Success -eq "Failure") {
            $This.Failure = [failure]::New($XmlElement.failure)
        }
        else {
            $this.Failure = $null
        }
        
    }
}

<#
#Test Suite can represent the following:
    A complete set of tests: Type:'TestFixture' -> Description: contains 'Pester' then.
    A file (Containing one or more tests) (It represents a .Tests.Ps1 file) Type:'TestFixture' Description: will contain the path to the file in that case
    A test (Describe block) Type:'TestFixture' ->  Description: The value of -Name of the Describe.
        This last one will contain one or more 'Test-Case' where 'description' contains the value of the 'name' parameter from the 'it'.

#>
Class TestSuite {
    [string] $Type
    [String] $Name
    [double]$Time
    [Bool] $Executed
    [Result]$Result
    [Bool]$Success
    
    [int]$Asserts
    $Results
    #[TestSuiteStats]$Stats

    TestSuite([String]$Name, [String]$Type, [double]$Time, [int]$Asserts, [Bool]$Success, [Result]$Result, [Bool]$Executed, $Results) {
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

        foreach ($ts in $XmlElement.Results.'test-suite') {
 
            $Res += [TestSuite]::New($ts)
        }

        $this.Results = $res

        #$this.Stats = [TestSuiteStats]::New($this)
    }



    [testCase[]]GetFailedTestsCases(){
        $ret = $this.Results | ? {$_.Type -eq "TestCase" -and $_.Result -eq "Failure"}
        return $ret
    }

    [int] GetFailedTestCasesCount(){
        return ($this.GetFailedTestsCases() | measure).Count
    }

    [testCase[]]GetSuccessTestsCases(){
        $ret = $this.Results | ? {$_.Type -eq "TestCase" -and $_.Result -eq "Success"}
        return $ret
    }

    [int] GetSuccessTestsCasesCount(){
        return ($this.GetSuccessTestsCases() | measure).Count
    }

    [int] GetTotalTestsCasesCount(){
        return ($this.GetSuccessTestsCases() + $this.GetFailedTestCasesCount())
    }
}

Class TestSuiteStats {
    [String]$Name

    
    [int]$Failed
    [int]$Success
    [double]$percentageSuccess
    [double]$percentageFailed
    [int]$Time
    [int]$TotalTestCases
    [int]$FailedTestCases
    [int]$SuccessTestCases

    TestSuiteStats([TestSuite]$TestSuite) {
        $This.Name = $TestSuite.Name
        $this.TotalTestCases = $TestSuite.GetTotalTestsCasesCount()
        $this.Failed = $TestSuite.GetFailedTestCasesCount()
        $this.Success = $TestSuite.GetSuccessTestsCasesCount()
        $this.Time = $TestSuite.Time

        #Avoid a division by zero error
        if ($this.TotalTestCases -eq 0) {
            $this.percentageSuccess = 0
        } else {
            $this.percentageSuccess = [Math]::Round((100 * $this.Success) / $this.TotalTestCases, 2)
        }
        
        if ($this.TotalTestCases -eq 0) {
            $this.percentageFailed = 0
        }else {
            $this.percentageFailed = [Math]::round((100 * $this.Failed) / $this.TotalTestCases, 2)
        }

        $This.FailedTestCases = $TestSuite.GetFailedTestsCases()
        $This.SuccessTestCases = $TestSuite.GetSuccessTestsCases()
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

    TestStats([NunitXMLDocument]$TestResults) {
        $this.Name = $TestResults.Name
        $this.TotalTime = [Math]::Round($TestResults.TestResults.Time, 2)
        $this.SuccessFullTestSuites = $TestResults.TestResults.Success
        $this.TotalTestSuites = $TestResults.TestSuite.count
        #$this.TotalTestCases = $TestResults.TestResults.total
        $this.FailedTestSuites = ($TestResults.TestSuite | where-object {$_.Result -eq 'Failure'}).Count
        $this.SuccessFullTestSuites = ($TestResults.TestSuite | where-object {$_.Result -eq 'Success'}).Count
        $this.percentageSuccess = [Math]::Round((100 * $this.SuccessFullTestSuites) / $this.TotalTestSuites, 2)
        $this.percentageFailed = [Math]::round((100 * $this.FailedTestSuites) / $this.TotalTestSuites, 2)
        
        $this.Name

        foreach ($ts in $TestResults.TestSuite) {
            $this.TestSuiteStats += [TestSuiteStats]::New($ts)
        }
        
        
    }

    TestStats([int]$number,[DAteTime]$Time){
        
    }

    TestStats(){

    }

    [TestCase[]]GetFailedTestCases([TestSuite]$TestSuite,[Datetime]$time) {
        return $TestSuite.Results | where-object {$_.Result -eq [Result]::Failure}
    }

    [TestCase[]]GetSuccessfullTestCases([TestSuite]$TestSuite) {
        return $TestSuite.Results | where-object {$_.Result -eq [Result]::Succes}
    }

    # [TestSuite]GetLongestTestSuite(){
    #     return $return
    # }
}


Class NunitXMLDocument {
    [String]$Name
    [dateTime]$ExecutionDate

    [TestEnvironment]$TestEnvironment
    [CultureInfo]$CultureInfo
    [TestSuite[]]$TestSuite
    [TestSuite]$TestResults
    [TestStats]$TestStats
    hidden [String]$RawResults

    NunitXMLDocument([System.IO.FileInfo]$TestDocument) {
        $this.RawResults = Get-Content $TestDocument.FullName

        [xml]$x = $this.RawResults

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

        $AllTestSuites = (select-xml -Xml $x -XPath "/test-results/test-suite").Node.Results.'test-suite'
        
        foreach ($t in $AllTestSuites) {
            $This.TestSuite += [TestSuite]::New($t) 
        }

        $this.TestStats = [TestStats]::New($this)

        #I know this is ugly, but until I find a smarter way to add this information in TestStats class, I'll have to leave here.
        
        $this.TestStats.errors = $Tres.errors
        $this.TestStats.TotalTestCases = $Tres.total
        $this.TestStats.TotalTestCaseFailures = $Tres.failures
        $this.TestStats.notrun = $Tres.'not-run'
        $this.TestStats.inconclusive = $Tres.inconclusive
        $this.TestStats.ignored = $Tres.ignored
        $this.TestStats.skipped = $Tres.skipped
        $this.TestStats.Invalid = $Tres.Invalid

    }

    GetTestSuites(){
        $this.TestResults
    }
}

Enum Result{
    Success
    Failure
}