## heroku-delpoyment

Deployment rake tasks for Heroku.

## Introduction

Heroku is free for 5 apps for 1 dynos. To scale this out, you would have to just create heroku account as much as possible but to handle that much of accounts would be very tedious. Hence the reason why I wrote this rake tasks. It would help you be more organized and easily scale to number of heroku accounts without worrying about of which account need to be deployed for specific services.

## Pre-requisites.
- rake
- heroku accounts

## Tasks

```
rake -T
rake deploy:<service name>[s]
rake deploy:<service name>[staging]
rake config:<service name>[production]
rake config:set:<service name>[p]
rake start:<service name>[p]
rake restart:<service name>[p]
rake .....
```

## Contribution

If you think this is awesome, and want to make it even more awesome, then feel free to contribute to this project.
