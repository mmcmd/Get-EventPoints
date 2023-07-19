[CmdletBinding()]
param (
    [Parameter(Mandatory,HelpMessage="Competition ID")]
    [int]
    $CompetitionID,
    [Parameter()]
    [int]
    $FirstPlacePoints = 25,
    [Parameter(ParameterSetName="ParticipationThreshold")]
    [int]
    $ParticipationThreshold,
    [Parameter(Mandatory,ParameterSetName="ParticipationThreshold")]
    [int]
    $ParticipationPoints,
    [Parameter(ParameterSetName="PointMinimum")]
    [int]
    $MinimumPoints = 5
)

$Uri = "https://api.wiseoldman.net/v2/competitions/$CompetitionID"

try {
    $Object = Invoke-RestMethod -Uri $Uri -Method Get
}
catch {
    throw "Error occurred attempting to obtain data from WiseOldMan. $($_.Exception.Message)"
}

# Final object
$GainedTable = $Object.Participations | ForEach-Object { 
    $_ | Select-Object -Property @{Name='RSN';Expression={"$($_.Player.Displayname)"}},@{Name='Gained';Expression={[int]"$($_.Progress.Gained)"}} 
} | Sort-Object -Property "Gained" -Descending

$WinnerGained = $GainedTable | Select-Object -First 1 -ExpandProperty Gained


$PointsObject = $GainedTable | ForEach-Object {
    $_ | Select-Object RSN,@{Name="Points";Expression={
        if ($ParticipationThreshold) {
            if ((([Math]::Round((($($_.Gained) * $FirstPlacePoints) / $WinnerGained),1)) -lt 5) -and ($_.Gained -ge $ParticipationThreshold)) {
                $ParticipationPoints
            }
            else {
                [Math]::Round((($($_.Gained) * $FirstPlacePoints) / $WinnerGained),1)
            }
        }
        else {
            [Math]::Round((($($_.Gained) * $FirstPlacePoints) / $WinnerGained),1)
        }
    }}
}

if ($MinimumPoints -gt 1) {
    $PointsObject = $PointsObject | Where-Object {$_.Points -ge $MinimumPoints}
}

return $PointsObject