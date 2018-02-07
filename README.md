# MeetupPS

PowerShell module to interact with the Meetup.com API

## Install

Install the module from the PowerShell Gallery.

```powershell
Install-Module -Name MeetupPS
```

## Using the module

### Get Group information

```powershell
Get-MeetupGroup -Groupname FrenchPSUG
```

![image-center](/media/MeetupPS-Get-MeetupGroup00.png)

### Get Events information

#### Upcoming events

```powershell
Get-MeetupEvent -Groupname FrenchPSUG -status upcoming
```

#### Past events

```powershell
Get-MeetupEvent -GroupName FrenchPSUG -status past
```

![image-center](/media/MeetupPS-Get-MeetupEvent00.png)

```powershell
Get-MeetupEvent -GroupName FrenchPSUG -status past | Format-List Name,local_date,link, yes_rsvp_count
```

![image-center](/media/MeetupPS-Get-MeetupEvent01.png)

## Contributing to this project

Contributions are more than welcome! (via Pull request and Issues)

### TODO

* Documentations
* Tests
* More functions,
* ...

## Resources

* [Meetup API Documentation](https://www.meetup.com/meetup_api/docs/)
* [Meetup API Console](https://secure.meetup.com/meetup_api/console/?path=/:urlname/events)