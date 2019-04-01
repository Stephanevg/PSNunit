
#using module C:\Users\taavast3\OneDrive\Repo\Projects\OpenSource\PoshNunitXML\PSNunit\psnunit.psm1
$d = [NunitXMLDocument]::New(".\Tests\demo.xml")
$PSHTMLres = "C:\Users\taavast3\OneDrive\Repo\Projects\OpenSource\PSHTML\testres.xml"
$ps = [NunitXMLDocument]::New("$PSHTMLres")