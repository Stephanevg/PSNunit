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
