# LEANPLUM PUSH NOTIFICATION ISSUE

## configuration settings

create a file named keys.json in the root folder containing

```json
{
  "appkey": "your leanplum app key",
  "devkey": "your leanplum dev key",
  "prodkey": "your leanplum prod key"
}
```

## Issue

When app is closed the push notification didn't run the associated action after user clicks it.

### Reproduction

1. Start the app
2. In Leanplum's dashboard search for user with  id ``useridfortest`` and set this device as test device
3. Kill app
4. Open another app (Ex: Safari)
5. Send a preview notification with url ``notiftest://lib/book/9782264064066``
6. On device click on the incoming notification
7. App should start without expected navigation

### Notes

- Killing the app without opening the application will not trigger the bug.
- Appears to work fine when app is opened in foreground and background


### Paths within this testing app

    notiftest://lib/mylib
    notiftest://lib/book/:id => :id is a string
