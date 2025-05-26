# AurSynchronization
## Description
Allows you to easily automate package updates on AUR.
It may work in a few narrow cases at the moment, but it works.

Job Features:
- Requires a pre-existing package on AUR
- Works with only one target — the repository in which the action resides
- Some settings such as build or deployment logic will have to be changed manually

## Inputs
| Name            | Is Required | Default Value                |
|:----------------|:------------|:-----------------------------|
| ssh_key         | true        |                              |
| pkg_name        | true        |                              |
| pkg_desc        | false       | **`Not changed`**            |
| pkg_license     | false       | **`Not changed`**            |
| commit_username | false       | `Release publisher username` |
| commit_email    | false       | `Empty`                      |

## Examples
```yaml
name: AUR Synchronization
on:
    release:
        types: [published]
jobs:
    aur-sync:
        runs-on: ubuntu-latest
        steps:
        -   uses: Blaadworks/AurSynchronization@v1.0.0
            with:
                ssh_key: ${{ secrets.SSH_KEY_AUR }}
                pkg_name: incredible-app
```

Real examples:
 - BlaadPapers
   - [action.yml](https://github.com/Blaadick/BlaadPapers/blob/master/.github/workflows/aur-sync.yml)
   - [PKGBUILD](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=blaadpapers)
