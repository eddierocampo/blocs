Cls

Write-Host *********************************************************************************************
Write-Host *********************************************************************************************
Write-Host "          Script para obtener información de servidores Windows Server
                    Creado por SETI - Infraestructura Base" -fore Yellow
Write-Host *********************************************************************************************
Write-Host *********************************************************************************************
""
Write-Host 'Reporte del sistema...'

Function Get-LocalGroupMember {
[cmdletbinding()]

Param(
[Parameter(Position = 0)]
[ValidateNotNullorEmpty()]
[string]$Name = "Administradores",

[Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
[ValidateNotNullorEmpty()]
[Alias("CN","host")]
[string[]]$Computername = $env:computername
)


Begin {
    Write-Verbose "[Starting] $($MyInvocation.Mycommand)"  
    Write-Verbose "[Begin]    Querying members of the $Name group"
} #begin

Process {
 
 foreach ($computer in $computername) {

    #define a flag to indicate if there was an error
    $script:NotFound = $False
    
    #define a trap to handle errors because we're not using cmdlets that
    #could support Try/Catch. Traps must be in same scope.
    Trap [System.Runtime.InteropServices.COMException] {
        $errMsg = "Failed to enumerate $name on $computer. $($_.exception.message)"
        Write-Warning $errMsg

        #set a flag
        $script:NotFound = $True
    
        Continue    
    }

    #define a Trap for all other errors
    Trap {
      Write-Warning "Oops. There was some other type of error: $($_.exception.message)"
      Continue
    }

    Write-Verbose "[Process]  Connecting to $computer"
    #the WinNT moniker is case-sensitive
    [ADSI]$group = "WinNT://$computer/$Name,group"
        
    Write-Verbose "[Process]  Getting group member details" 
    $members = $group.invoke("Members") 

    Write-Verbose "[Process]  Counting group members"
    
    if (-Not $script:NotFound) {
        $found = ($members | measure).count
        Write-Verbose "[Process]  Found $found members"

        if ($found -gt 0 ) {
        $members | foreach {
        
            #define an ordered hashtable which will hold properties
            #for a custom object
            $Hash = [ordered]@{Computername = $computer.toUpper()}

            #Get the name property
            $hash.Add("Name",$_[0].GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null))
        
            #get ADS Path of member
            $ADSPath = $_[0].GetType().InvokeMember("ADSPath", 'GetProperty', $null, $_, $null)
            $hash.Add("ADSPath",$ADSPath)
    
            #get the member class, ie user or group
            $hash.Add("Class",$_[0].GetType().InvokeMember("Class", 'GetProperty', $null, $_, $null))  
    
            <#
            Domain members will have an ADSPath like WinNT://MYDomain/Domain Users.  
            Local accounts will be like WinNT://MYDomain/Computername/Administrator
            #>

            $hash.Add("Domain",$ADSPath.Split("/")[2])

            #if computer name is found between two /, then assume
            #the ADSPath reflects a local object
            if ($ADSPath -match "/$computer/") {
                $local = $True
                }
            else {
                $local = $False
                }
            $hash.Add("IsLocal",$local)

            #turn the hashtable into an object
            New-Object -TypeName PSObject -Property $hash
         } #foreach member
        } 
        else {
            Write-Warning "No members found in $Name on $Computer."
        }
    } #if no errors
} #foreach computer

} #process

End {
    Write-Verbose "[Ending]  $($MyInvocation.Mycommand)"
} #end

}

Function Get-Software{$Paths  = @("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall","SOFTWARE\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall") 
ForEach($Path in $Paths) { 
  
  Write-Verbose  "Checking Path: $Path"

  #  Create an instance of the Registry Object and open the HKLM base key 

  $Origenes = @("LocalMachine","CurrentUser")

  Foreach ($Origen in $Origenes) {

  Try  { 

  $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey($Origen,$Computer,'Registry64') 

  } Catch  { 

  Write-Error $_ 

  Continue 

  } 

  #  Drill down into the Uninstall key using the OpenSubKey Method 

  Try  {

  $regkey=$reg.OpenSubKey($Path)  

  # Retrieve an array of string that contain all the subkey names 

  $subkeys=$regkey.GetSubKeyNames()      

  # Open each Subkey and use GetValue Method to return the required  values for each 

  ForEach ($key in $subkeys){   

  Write-Verbose "Key: $Key"

  $thisKey=$Path+"\\"+$key 

  Try {  

  $thisSubKey=$reg.OpenSubKey($thisKey)   

  # Prevent Objects with empty DisplayName 

  $DisplayName =  $thisSubKey.getValue("DisplayName")

  If ($DisplayName  -AND $DisplayName  -notmatch '^Update  for|rollup|^Security Update|^Service Pack|^HotFix') {

  $Date = $thisSubKey.GetValue('InstallDate')

  If ($Date) {

  Try {

  $Date = [datetime]::ParseExact($Date, 'yyyyMMdd', $Null)

  } Catch{

  Write-Warning "$($Computer): $_ <$($Date)>"

  $Date = $Null

  }

  } 

  # Create New Object with empty Properties 

  $Publisher =  Try {

  $thisSubKey.GetValue('Publisher').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('Publisher')

  }

  $Version = Try {

  #Some weirdness with trailing [char]0 on some strings

  $thisSubKey.GetValue('DisplayVersion').TrimEnd(([char[]](32,0)))

  } 

  Catch {

  $thisSubKey.GetValue('DisplayVersion')

  }

  $UninstallString =  Try {

  $thisSubKey.GetValue('UninstallString').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('UninstallString')

  }

  $InstallLocation =  Try {

  $thisSubKey.GetValue('InstallLocation').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('InstallLocation')

  }

  $InstallSource =  Try {

  $thisSubKey.GetValue('InstallSource').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('InstallSource')

  }

  $HelpLink = Try {

  $thisSubKey.GetValue('HelpLink').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('HelpLink')

  }

  $Object = [pscustomobject]@{

  Computername = $Computer

  DisplayName = $DisplayName

  Version  = $Version

  InstallDate = $Date

  Publisher = $Publisher

  UninstallString = $UninstallString

  InstallLocation = $InstallLocation

  InstallSource  = $InstallSource

  HelpLink = $thisSubKey.GetValue('HelpLink')

  EstimatedSizeMB = [decimal]([math]::Round(($thisSubKey.GetValue('EstimatedSize')*1024)/1MB,2))

  }

  $Object.pstypenames.insert(0,'System.Software.Inventory')

  Write-Output $Object

  }

  } Catch {

  Write-Warning "$Key : $_"

  }   

  }

  } Catch  {}   

  $reg.Close() 

  }                  
  }
  }
function get-cpu{
Get-WmiObject win32_processor | 
                   Measure-Object -property LoadPercentage -Average | 
                   Foreach {"{0:N2}" -f ($_.Average) + "%"}
}

Function Get-Info{
Param([Parameter(Mandatory=$true)][string]$OutputPath)
$a = "<style>"
$a = $a + "Body{background-color: #C0C0C0;;font-family: Arial;}"
$a = $a + "TABLE{background-color: white; text-align: left; border-collapse: collapse;width: 100%;}"
$a = $a + "TH{border-width: 1px;padding: 18px;;border-style: solid;border-color: black;background-color: #d43f3f;border-bottom: solid 5px #d43f3f;color: white;text-align:center;}"
$a = $a + "TD{border-width: 1px;padding: 18px;;border-style: solid;border-color: black;text-align:center;}"
$a = $a + "tr:hover td{ background-color: #d43f3f; color: white; }"
$a = $a + "tr:nth-child(even){background-color: #ddd;}"
$a = $a + "</style>"

$date = date
$sys = Get-CimInstance -ClassName Win32_OperatingSystem
$sys1 = $sys.Caption
$title = "<title>System Report</title>"
$log = "<link rel='shortcut icon' href='seti.png'>"
$Seti = "<center><img src='seti.png' title='Seti S.A.S' align='middle' style='margin:0px;'><h1>Documento de evidencias de instalacion y configuracion del sistema operativo $sys1</h1></center><p><h3>En este documento se encuentran las evidencias de la instalación y configuración del sistema operativo $sys1 para el servidor $env:computername, por parte de Proyectos SETI. Dentro de las evidencias se incluyen: Información básica del sistema, propiedades y licenciamiento del equipo, roles y características, programas y agentes instalados, configuración de discos, configuración IP y rutas estáticas, entre otros, Este documento fue generado el $date</h3><p>" 
$Uso = "<div style='padding: 3px 10px; border:#d43f3f 5px double; border-top-left-radius: 20px; border-bottom-right-radius: 20px; background-color: #d43f3f;'><center><h1>Uso y divulgacion</h1></center><p><h3>Este documento, incluyendo cualquier anexo y apéndice, contiene información, contenido y estructura que constituyen secretos de marca y/o información financiera o comercial de carácter confidencial de SETI catalogado como propiedad intelectual. Esta información es entregada al cliente CLIENTE en el entendimiento de que no será utilizada para otros fines que no sean su evaluación y/o control.
Todos los derechos son reservados, ninguna parte de este documento puede ser fotocopiada, reproducida, divulgada o traducida sin la autorización expresa de SETI y CLIENTE.</h3><p></div>"
$SystemInformation = "<center><h1>Informacion del sistema</h1></center>"
$NetworkAdapterInfo = "<center><h1>Información del adaptador de red</h1></center>"
$DiskInformation = "<center><h1>Almacenamiento configurado</h1></center>"
$Services = "<center><h1>Informacion de Servicios</h1></center>"
$SoftIns = "<center><h1>Software instalado</h1></center>"
$Route = "<center><h1>Rutas Persistentes</h1></center>"
$Update = "<center><h1>Actualizaciones instaladas</h1></center>"
$Feature = "<center><h1>Roles y caracteristicas</h1></center>"
$user = "<center><h1>Usuarios locales</h1></center>"
$Act = "<center><h1>Licenciamiento</h1><h3>(Siendo uno (1) activado)</h3></center>"
$Pro ="<center><h1>Informacion procesadores<h1></center>"
$up = "<center><h1>Tiempo de actividad</h1></center>"
$group = "<center><h1>Local Group Membership</h1></center>"
$politicas = "<a class='button' href='Politicas.html' rel='nofollow' target='_blank' style='border-radius:4px; font-size:15px; margin:1px; float:left; color:#797979!important; font-weight:bold; display:inline-block; padding:15px 25px 15px 25px; background:#fff; box-shadow:0 15px 20px -10px rgba(0, 0, 0, 0), inset 0 -3px 0 0 rgba(255, 94, 102, 0.7), inset 0 -0px 0 0 #ff5e66; transition:all .3s ease-in-out;text-decoration:none'>Ver Politicas</a>"
$br = "<br>"

$Volumes = Get-CimInstance -ClassName Win32_Volume | Where-Object {$_.DriveType -eq "3"} | Select-Object DriveLetter,Label,@{Name="Size";Expression={"{0:N2}" -f ($_.Capacity / 1GB) + " " + "GB" } },@{Name="Free Space";Expression={"{0:N2}" -f ($_.FreeSpace / 1GB) + " " + "GB" } },FileSystem
$Memory = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object @{Name="Installed Memory (RAM)";Expression={[math]::Round($_.TotalPhysicalMemory / 1GB), "GB" }}
$Processor = Get-WmiObject -class Win32_processor | ConvertTo-HTML -Property Name,Caption,DeviceID,NumberOfCores,NumberOfLogicalProcessors
$Class = Get-CimInstance -ClassName Win32_OperatingSystem
$Network  = Get-CimInstance -ClassName Win32_NetworkAdapter -Filter "NetEnabled = 'True'" | Select-Object NetconnectionID,Name
$IP =((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
$Service = Get-Service | Select-Object Name,DisplayName,Status,StartType
$Domain = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Domain
$Software = Get-Software | Select-Object DisplayName,Publisher,Version,InstallDate,EstimatedSizeMB
$InsUpdate = Get-CimInstance -ClassName Win32_QuickFixEngineering | Select-Object Description,HotFixID,InstalledOn
$InsFeature = Get-WindowsOptionalFeature -Online | ConvertTo-HTML -Property featurename, state
$Users = Get-LocalGroupMember
$Activation1 = Get-CimInstance -ClassName SoftwareLicensingProduct | where PartialProductKey | ConvertTo-HTML -Property Name,LicenseStatus
$Activation = Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object {$_.LicenseStatus -eq "1" -eq "Activado"} | ConvertTo-Html -Property Name,LicenseStatus
$Persisten = Get-WmiObject -classname Win32_IP4PersistedRouteTable | Select-Object PSComputerName,Caption,Mask,NextHop
$Uptime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime | Select-Object Days,Hours,Minutes
$InsDate = ([WMI]””).ConvertToDateTime((Get-WmiObject Win32_OperatingSystem).InstallDate)
$MemoryFree = Get-WmiObject -Class Win32_OperatingSystem | Select-Object @{Name="Free Memory";Expression={([math]::round(($Class.FreePhysicalMemory / 1024 / 1024), 2)), "GB"}}
$Cpu = get-cpu
#$mkdir = mkdir C:\GPO
#$Gpo = gpresult /h C:\GPO\Politicas.html

$Object = New-Object -TypeName PSObject
$Object | Add-Member -MemberType NoteProperty -Name 'Host Name' -Value $env:computerName.ToUpper()
$Object | Add-Member -MemberType NoteProperty -Name Architecture -Value $Class.OSArchitecture
$Object | Add-Member -MemberType NoteProperty -Name 'Operating System' -Value $Class.Caption
$Object | Add-Member -MemberType NoteProperty -Name 'IP Address' -Value $IP.ToString()
$Object | Add-Member -MemberType NoteProperty -Name 'Memory Ram' -Value $Memory.'Installed Memory (RAM)'
$Object | Add-Member -MemberType NoteProperty -Name 'Free Memory' -Value $MemoryFree.'Free Memory'
$Object | Add-Member -MemberType NoteProperty -Name 'Used Cpu' -Value $Cpu

$Object1 = New-Object -TypeName PSObject
$Object1 | Add-Member -MemberType NoteProperty -Name Domain -Value $Domain.'Domain'
$Object1 | Add-Member -MemberType NoteProperty -Name 'Number Of Processes' -Value $class.NumberOfProcesses
$Object1 | Add-Member -MemberType NoteProperty -Name 'Install Date' -Value $InsDate
$Object1 | Add-Member -MemberType NoteProperty -Name 'Last boot' -Value $Class.LastBootUpTime
$Object1 | Add-Member -MemberType NoteProperty -Name Manufacturer -Value $class.Manufacturer

$IronMan = $Object | ConvertTo-Html -Fragment 

$Spider = $Object1 | ConvertTo-Html -Fragment

$Stranger = $Volumes | ConvertTo-Html -Fragment

$Hulk = $Network | ConvertTo-Html -Fragment

$BlackWidow = $Service | ConvertTo-Html -Fragment

$Clint = $Software | ConvertTo-Html -Fragment

$Loki = $InsUpdate | ConvertTo-Html -Fragment

$Thor = $Users | ConvertTo-Html -Fragment

$Thanos = $Uptime | ConvertTo-Html -Fragment

$Ward = $Persisten | ConvertTo-Html -Fragment

ConvertTo-Html -Body "$log $title $Seti $politicas $br $br $SystemInformation  $IronMan $br $Spider $Up $Thanos $Pro $Processor $DiskInformation $Stranger $NetworkAdapterInfo $Hulk $Act $Activation $group $Thor $Update $Loki $Route $Ward $Services $BlackWidow $SoftIns $Clint $Feature $InsFeature $br $Uso" -Head $a | Out-File "$OutputPath\$(($env:computerName)).html"
}
Get-Info

Write-Host 'Reporte Finalizado'