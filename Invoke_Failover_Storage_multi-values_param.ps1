param(
[Parameter(Mandatory=$true)][string]$storage_account_resource_group_name,       #Enter the resourcegroup name of the Storageaccount
[Parameter(Mandatory=$true)][array]$storageaccount_names_private,       #Enter the storage account name(s) on which failover has to be initiated
[Parameter(Mandatory=$true)][string]$sku                        #Enter the SKU as Standard_GRS to re-enable geo-replication post failover
)

 
$storageaccounts = $storageaccount_names_private.split(",")
foreach($storageaccount_name in $storageaccounts)
{
#Below command Invokes failover on the selected storage account(s)
$failover = Invoke-AzStorageAccountFailover -ResourceGroupName $storage_account_resource_group_name -Name $storageaccount_name -Force -AsJob
}

Wait-Job $failover

foreach($storageaccount_name in $storageaccounts)
{
#Below command updates the SKU of the storage account(s) to Standard_GRS post failover
Set-AzStorageAccount -ResourceGroupName $storage_account_resource_group_name -Name $storageaccount_name -SkuName $sku -Force
}
