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

    TestSuiteStats([TestSuite]$TestSuite) {
        $This.Name = $TestSuite.Name
        $this.TotalTestCases = $TestSuite.Results.count
        $this.Failed = ($TestSuite.Results | where-object {$_.Result -eq 'Failure'}).Count
        $this.Success = ($TestSuite.Results | where-object {$_.Result -eq 'Success'}).Count
        $this.Time = $TestSuite.Time

        #Avoid a division by zero error
        if ($this.TotalTestCases -eq 0) {
            $this.percentageSuccess = 0
        }
        else {
            $this.percentageSuccess = [Math]::Round((100 * $this.Success) / $this.TotalTestCases, 2)
        }
        
        if ($this.TotalTestCases -eq 0) {
            $this.percentageFailed = 0
        }
        else {
            $this.percentageFailed = [Math]::round((100 * $this.Failed) / $this.TotalTestCases, 2)
        }

        
        $This.FailedTestCases = ($TestSuite.Results | where-object {$_.Result -eq 'Failure'})
        $This.SuccessfullTestCases = ($TestSuite.Results | where-object {$_.Result -eq 'Success'})
    }



}
