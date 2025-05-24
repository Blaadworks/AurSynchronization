# AurSynchronization
## Inputs
| Name            | Is Required | Default Value     |
|-----------------|-------------|-------------------|
| pkg_name        | true        |                   |
| pkg_desc        | false       | ""                |
| ssh_key         | true        |                   |
| commit_username | false       | Release publisher |
| commit_email    | false       | ""                |

## Example
```yml
name: AUR Synchronization

on:
    release:
        types: [published]

jobs:
    aur-sync:
        runs-on: ubuntu-latest
        steps:
          - uses: Blaadworks/AurSynchronization@v1.0.0
            with:
                pkg_name: incredible-app
                pkg_desc: "Brief description of the app"
                commit_username: AppCreator228
                commit_email: appcreator228@mail.com

```
