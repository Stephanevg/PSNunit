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
}
