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
