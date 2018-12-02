
Class TestSuite {
    [string] $Type
    [String] $Name
    [double]$Time
    [Bool] $Executed
    [Result]$Result
    [Bool]$Success
    
    [int]$Asserts
    [TestCase[]]$Results
    #[TestSuiteStats]$Stats

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
