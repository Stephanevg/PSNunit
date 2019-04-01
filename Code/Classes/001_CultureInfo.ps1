

Enum Result{
    Success
    Failure
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
