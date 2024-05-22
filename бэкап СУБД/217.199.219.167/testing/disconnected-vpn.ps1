$VpnName = "VPN"
$vpnConnection = Get-VpnConnection -Name $VpnName -AllUserConnection
if ($vpnConnection.ConnectionStatus -eq "Connected") {
        Write-Host "Disconnected VPN"
        rasdial $vpnName /DISCONNECT;
}

Start-Sleep -Seconds 10