$AzureRmConnection = Get-AutomationConnection -Name 'AzureRunAsConnection'
		
$null = Add-AzureRmAccount -CertificateThumbprint $AzureRmConnection.CertificateThumbprint `
					-ApplicationId $AzureRmConnection.ApplicationId `
					-TenantId $AzureRmConnection.TenantId `
					-ServicePrincipal	
						
$vm = Get-AzureRmResource -ResourceName BES-SRV01 `
							-ResourceType 'Microsoft.Compute/virtualMachines' `
							-ResourceGroupName Bespin-Lab		

$VmNetworkInterface = Get-AzureRmNetworkInterface -ResourceGroupName $Vm.ResourceGroupName | Where-Object {$_.VirtualMachine.Id -eq $Vm.ResourceId}
				 
$VmNetworkInterface.IpConfigurations.PrivateIpAddress