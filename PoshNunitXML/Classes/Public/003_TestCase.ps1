
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

