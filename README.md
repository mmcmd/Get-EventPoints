# Get-EventPoints

## Description

Small script to import the gained data from a WiseOldMan competition and to convert the points into point form.

Points are calculated the following way: ( Gained * Points given to first place ) / Amount gained by first place

Can set a participation threshold via the ParticipationThreshold parameter

Parameters:
| Parameter Name | Description | Required |
| -------------- | ----------- | -------- |
| CompetitionID | ID of the competition on WiseOldMan| Yes|
| FirstPlacePoints | Default value of 25, points awarded to first place winner | No |
| ParticipationThreshold | Threshold gained at which participation points will be given out | No |
| ParticipationPoints | Participation points given if participation threshold is specified | Yes, if ParticipationThreshold is specified |
| MinimumPoints | Minimum points required to receive a reward. Value by default is 5. Cannot be used alongside ParticipationThreshold+ParticipationPoints | No |


## Example

### Exemple 1

Get the competitionID 12345 with a participation threshold of 10000 and give people over 10000 who wouldn't get points otherwise 5 points

```powershell
.\Get-EventPoints.ps1 -CompetitionID 12345 -ParticipationThreshold 10000 -ParticipationPoints 5
```

### Example 2

Get the competitionID 12345 and calculate the points obtained using the standard formula

```powershell
.\Get-EventPoints -CompetitionID 12345
```
