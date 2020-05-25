Connect-AzureRMAccount


Set-AzureRMContext -subscriptionid XXXXXXXXXXXXXXXXXXXXXXXXXXXX

$RGs = Get-AzureRMResourceGroup

foreach  ($RG in $RGs)
  {
    $VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName
    Foreach  ($VM in $VMs)
    {
      $VMDetail = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Status
      $RGN = $VMDetail.ResourceGroupName  
      foreach ($VMStatus in $VMDetail.Statuses)
      { 
          if($VMStatus.DisplayStatus -eq "VM stopped"){
            Write-Output $VMStatus
            $VMStatusDetail = $VMStatus.DisplayStatus
            Write-Output "Found Stopped VM Resource Group: $RGN", ("VM Name: " + $VM.Name), "Status: $VMStatusDetail"
            Stop-AzureRmVM -ResourceGroupName $VMDetail.ResourceGroupName -Name $VM.Name
            Write-Output "Initiated deallocation of VM Resource Group: $RGN", ("VM Name: " + $VM.Name), "Status: $VMStatusDetail"

          }
      }
    }
  }


