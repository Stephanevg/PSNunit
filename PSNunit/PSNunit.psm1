
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

if(test-Path "$ScriptPath\Enums\Public"){

    write-verbose "Loading Enums"
    $Enums = gci "$ScriptPath\Enums\Public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($Enum in $Enums){
        write-verbose "importing Enum $($Enum)"
        try{
            . $Enum
        }catch{
            write-warning $_
        }
    }
}

If(Test-Path "$ScriptPath\Classes\Private"){

    write-verbose "Loading Private Classes"
    $PRivateClasses = gci "$ScriptPath\Classes\Private" -Filter *.ps1 | sort name | Select -Expand FullName
    
    
    foreach ($Private in $PRivateClasses){
        write-verbose "importing function $($Private)"
        try{
            . $Private
        }catch{
            write-warning $_
        }
    }
}

If(test-Path "$ScriptPath\Classes\public"){

    write-verbose "Loading Public Classes"
    $PublicClasses = gci "$ScriptPath\Classes\public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($public in $PublicClasses){
        write-verbose "importing function $($Public)"
        try{
            . $public
        }catch{
            write-warning $_
        }
    }
}

if(Test-Path "$ScriptPath\Functions\Private"){

    write-verbose "Loading Private Functions"
    $PrivateFunctions = gci "$ScriptPath\Functions\Private" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($PrivFunc in $PrivateFunctions){
        write-verbose "importing function $($PrivFunc)"
        try{
            . $PrivFunc
        }catch{
            write-warning $_
        }
    }
}

if(Test-Path "$ScriptPath\Functions\public"){

    write-verbose "Loading Public Functions"
    $PublicFunctions = gci "$ScriptPath\Functions\public" -Filter *.ps1 | Select -Expand FullName
    
    
    foreach ($pubfunc in $PublicFunctions){
        write-verbose "importing function $($pubfunc)"
        try{
            . $pubfunc
        }catch{
            write-warning $_
        }
    }
}


