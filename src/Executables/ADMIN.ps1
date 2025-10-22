Add-Type -AssemblyName System.Security.Principal

# Get well-known group SIDs
$adminsGroupSid = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::BuiltinAdministratorsSid, $null)
$usersGroupSid = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::BuiltinUsersSid, $null)

# Get the Administrators and Users groups
$adminsGroup = Get-LocalGroup -SID $adminsGroupSid.Value
$usersGroup = Get-LocalGroup -SID $usersGroupSid.Value

# Identify the built-in Administrator user by checking well-known SID type
$adminUser = $null
$adminSid = $null
$localUsers = Get-LocalUser
foreach ($user in $localUsers) {
    $sid = New-Object System.Security.Principal.SecurityIdentifier($user.SID.Value)
    if ($sid.IsWellKnown([System.Security.Principal.WellKnownSidType]::AccountAdministratorSid)) {
        $adminUser = $user
        $adminSid = $sid
        break
    }
}

# Enable the built-in Administrator account if found
if ($adminUser) {
    Enable-LocalUser -InputObject $adminUser

    # Get members of Administrators group
    $members = Get-LocalGroupMember -Group $adminsGroup

    # Remove non-Administrator users from Administrators and add to Users
    $members | Where-Object { $_.SID.Value -ne $adminSid.Value } | ForEach-Object {
        $userToMove = Get-LocalUser -SID $_.SID.Value
        Remove-LocalGroupMember -Group $adminsGroup -Member $userToMove
        Add-LocalGroupMember -Group $usersGroup -Member $userToMove -ErrorAction SilentlyContinue
    }
} else {
    Write-Warning "Built-in Administrator account not found."
}

