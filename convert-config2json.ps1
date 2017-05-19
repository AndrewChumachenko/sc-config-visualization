param (
    $scConfig
)

$out = @{name="sitecore"; children = @() }

$x = [xml](gc $scConfig)                                                                                                                                                                                          
$xe = $x.DocumentElement.ChildNodes                                                                                                                                                                                               

$configNodes = $xe | ? { $_.LocalName -ne '#comment' } 

foreach ($node in $configNodes) { 
    $j = @{}; 
    
    $nodeXname = $node.LocalName;
    $nodeAttrName = $node.name; 
    $nodeAttrId = $node.id;

    $j.name = "<$nodeXname"
    if (-not [String]::IsNullOrEmpty($nodeAttrName)) {
        $j.name += " name='$nodeAttrName' "
    }
    if (-not [String]::IsNullOrEmpty($nodeAttrId)) {
        $j.name += " id='$nodeAttrId' "
    }
    $j.name += ">"
    $j.size =  $node.OuterXml.Length; 
    $out.children += $j 
}

$out | convertto-json | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }