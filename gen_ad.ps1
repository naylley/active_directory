param([Parameter(Mandatory=$true)] $JSONFile)

function createADGroup(){
    param([Parameter(Mandatory=$true)] $groupObject

    $name = $groupObject.name

    New-ADGroup -name $name -GroupScope Global
}

function CreateADUser(){
    param([Parameter(Mandatory=$true)] $userObject)
    #Pulling name form JSON Object
    $name = $userObject.name
    $password = $userObject.password

    #generating username e.g first name first letter + lastname
    $firstname, $lastname = $name.Split(" ")
    $username = ($name[0] + $name.split(" ")[1]).toLower()
    $samAccountName = $username
    $principalname = $username
    
    #Creating AD User Object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount    

    #add user to appropriate groups
    foreach($group_name in $userObject.groups){
        try {
            Get-ADGroup -Identity “$group_name”
            Add-ADGroupMember -Identity $group -Members $username
        }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
            {
            Write-Warning “User $name NOT added to AD because $group_name does not exist”
            }
            catch {}
        
    }

}

$json = (Get-Content $JSONFile | ConvertFrom-JSON)

$Global : Domain =$json.Domain

foreach ( $group in $json.groups){
    createADGroup $group
}

foreach ( $user in $json.users){
    CreateADUser
}