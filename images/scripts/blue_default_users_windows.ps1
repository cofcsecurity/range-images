# Creates a list of new users for the box
#  - mix of admin users and regular users
#  - "hidden" user for backdoor access
#  - most users have No passwords
#  - relies on connecting user to connect using provided Default Administrator user provided by aws and to use key pair to connect

new-localuser -name 'h9000' -NoPassword -Fullname 'Hal 9000'
add-localgroupmember -group 'Administrators' -member 'h9000'
$passwordhal = ConvertTo-SecureString 'Daisy123!' -AsPlainText -Force
Set-LocalUser -Name 'h9000' -Password $passwordhal

new-localuser -name 'dbowman' -NoPassword -Fullname 'David Bowman'
add-localgroupmember -group 'Administrators' -member 'dbowman'
$passworddave = ConvertTo-SecureString 'Password123' -AsPlainText -Force
Set-LocalUser -Name 'dbowman' -Password $passworddave

new-localuser -name 'fpoole' -NoPassword -fullname 'Frank Poole' 
add-localgroupmember -group 'Users' -member 'fpoole'
$passwordfp = ConvertTo-SecureString 'Password123' -AsPlainText -Force
Set-LocalUser -Name 'fpoole' -Password $passwordfp

new-localuser -name 'gold' -nopassword -fullname 'Gold Team' 
add-localgroupmember -group 'Administrators' -member 'gold'
$passwordgold = ConvertTo-SecureString 'Team123!' -AsPlainText -Force
Set-LocalUser -Name 'gold' -Password $passwordgold

# re-enable guest account 
Enable-LocalUser -name 'Guest'

# backdoor user 

New-LocalUser -name 'BackupAdmin' -NoPassword -fullname 'Back Administrator' -Description 'incase of computer malfucntion'
Add-LocalGroupMember -group 'Administrators' -member 'BackupAdmin'

# need to change password complexity requirments 
$passwordba = ConvertTo-SecureString 'DoorAccount123!' -AsPlainText -Force
Set-LocalUser -Name 'BackupAdmin' -Password $passwordba 