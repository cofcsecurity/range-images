# - configures the firewall to be disabled by Default
# - configures the password settings 
#   - no complexity, length, expiration reqs.

# disable firewall period 
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-NetFirewallProfile -DefaultInboundAction Allow -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True -LogFileName %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log
stop-service -Name mpssvc # stops the service in order to make it harder to re-enable 


# disables windows defender
Stop-Service -Name wscsvc # could not be found
Stop-Service -Name WinDefend # could not be found
stop-service -Name SecurityHealthService # stopped

# disable windows update 
stop-service -Name wuauserv # stopped??
