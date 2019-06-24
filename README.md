# MeetupPS

[![Build Status](https://dev.azure.com/lazywinadmin/MeetupPS/_apis/build/status/lazywinadmin.MeetupPS?branchName=master)](https://dev.azure.com/lazywinadmin/MeetupPS/_build/latest?definitionId=20&branchName=master)

PowerShell module to interact with the Meetup.com API

![image-center](/media/meetupAPI3.png)

## Contribute

Contributions are welcome by using pull request and issues.

## Table of Contents

* [Install the module](#Install)
* [Configure connection](#Configure)
* [Authentication](#Authentication)
* [Get Meetup Group Information](#GetGroupInfo)
* [Get Meetup Group's events Information](#GetEventInfo)
  * [Get upcoming events](#GetupcomingEventInfo)
  * [Get past events](#GetpastEventInfo)
* [Create Meetup Event](#CreateEvent)
* [API Permission scopes](#APIPermissionScopes)
* [Resources](#Resources)

<a name="Install"/>

## Install

Install the module from the PowerShell Gallery.

```powershell
Install-Module -Name MeetupPS
```

<a name="Configure"/>

## Configure connection

Follow the following steps to request a Oauth Key/Secret.
Fortunately you only need to do this once.

Register a new Oauth Consumer on the [Meetup API Oauth Consumer portal](https://secure.meetup.com/meetup_api/oauth_consumers/)

* `Consumer Name` Provide a name for your Oauth Consumer
* `Application Website` Here I used `https://github.com/lazywinadmin/MeetupPS`
* `Redirect URI` Here I used `https://github.com/lazywinadmin/MeetupPS`
* Agree with terms

![image-center](/media/MeetupPS-RegisterOauthConsumer01.png)

Once the Oauth Consumer is created, copy the Key and the Secret. This will be used to authenticate against the API

![image-center](/media/MeetupPS-RegisterOauthConsumer02.png)

<a name="Authentication"/>

## Connecting to the Meetup.com API

```powershell
# Connect against Meetup.com API
$Key = '<Your Oauth Consumer Key>'
$Secret = '<Your Oauth Consumer Secret>'
Set-MeetupConfiguration -ClientID $Key -Secret $Secret
```

![image-center](/media/MeetupPS-Set-MeetupConfiguration01.png)

Note: This will leverage two private functions of the module:

* `Get-OauthCode`
* `Get-OauthAccessToken`

This will then prompt you to connect to Meetup.

![image-center](/media/MeetupPS-Set-MeetupConfiguration02.png)

<a name="GetGroupInfo"/>

## Get Group information

Retrieve a Meetup group information

```powershell
Get-MeetupGroup -Groupname FrenchPSUG
```

![image-center](/media/MeetupPS-Get-MeetupGroup01.png)

<a name="GetEventInfo"/>

## Get Events information

<a name="GetupcomingEventInfo"/>

### Upcoming events

Retrieve upcoming event(s) for a Meetup group

```powershell
Get-MeetupEvent -Groupname FrenchPSUG -status upcoming
```

<a name="GetpastEventInfo"/>

### Past events

Retrieve past event(s) for a Meetup group

```powershell
Get-MeetupEvent -GroupName FrenchPSUG -status past -page 2
```

![image-center](/media/MeetupPS-Get-MeetupEvent03.png)

```powershell
Get-MeetupEvent -GroupName FrenchPSUG -status past |
Format-List -property Name,local_date,link, yes_rsvp_count
```

![image-center](/media/MeetupPS-Get-MeetupEvent04.png)

<a name="CreateEvent"/>

## Create Event

```powershell
New-MeetupEvent `
    -GroupName FrenchPSUG `
    -Title 'New Event from MeetupPS' `
    -Time '2018/06/01 3:00pm' `
    -Description "PowerShell WorkShop<br><br>In this session we'll talk about ..." `
    -PublishStatus draft
```

![image-center](/media/MeetupPS-New-MeetupEvent01.png)

Here is the event created in Meetup

![image-center](/media/MeetupPS-New-MeetupEvent02.png)

<a name="APIPermissionScopes"/>

## API permission scopes

The API permission scopes are set when the authentication occur in `Get-OAuthAccessToken`.

Currently it is requesting the following permission scopes: `basic`,`reporting`, `event_management`

More permission scopes are available here: https://www.meetup.com/meetup_api/auth/#oauth2-scopes

| scope | permission |
| --- | --- |
| ageless | Replaces the one hour expiry time from oauth2 tokens with a limit of up to two weeks |
| basic | Access to basic Meetup group info and creating and editing Events and RSVP's, posting photos in version 2 API's and below |
| event_management | Allows the authorized application to create and make modifications to events in your Meetup groups on your behalf |
| group_edit | Allows the authorized application to edit the settings of groups you organize on your behalf |
| group_content_edit | Allows the authorized application to create, modify and delete group content on your behalf |
| group_join | Allows the authorized application to join new Meetup groups on your behalf |
| messaging | Enables Member to Member messaging (this is now deprecated) |
| profile_edit | Allows the authorized application to edit your profile information on your behalf |
| reporting | Allows the authorized application to block and unblock other members and submit abuse reports on your behalf |
| rsvp | Allows the authorized application to RSVP you to events on your behalf |


You can take a look a the header passed to the API here:

```powershell
$Headers = @{
    'X-OAuth-Scopes'          = "basic", "reporting", "event_management"
    'X-Accepted-OAuth-Scopes' = "basic", "reporting", "event_management"
}
```

See this line: [Header of Get-OauthAccessToken](/MeetupPS/private/Get-OAuthAccessToken.ps1#L24)

<a name="Resources"/>

## Resources

* [Meetup API Documentation](https://www.meetup.com/meetup_api/docs/)
