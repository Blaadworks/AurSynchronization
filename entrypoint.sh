#!/usr/bin/env bash
set -euo pipefail
HOME=/home/synchronizer
cd ~

pkgName="$INPUT_PKG_NAME"
pkgDesc="$INPUT_PKG_DESC"
sshKey="$INPUT_SSH_KEY"
gitBody="$GITHUB_REPOSITORY"



# Setup SSH
mkdir -p ~/.ssh
eval "$(ssh-agent -s)"
echo "$sshKey" | ssh-add -
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts



# Setup AUR & Git
git config --global user.name "${INPUT_COMMIT_USERNAME:-$GITHUB_ACTOR}"
git config --global user.email "${INPUT_COMMIT_EMAIL:-''}"
git -c init.defaultBranch=master clone ssh://aur@aur.archlinux.org/$pkgName.git
cd $pkgName



# Edit PKGBUILD
lastVer=$(curl -s "https://api.github.com/repos/$gitBody/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
curl -s -L "https://github.com/$gitBody/archive/refs/tags/v$lastVer.tar.gz" -o "$pkgName-$lastVer.tar.gz"
sha256sum=$(sha256sum "$pkgName-$lastVer.tar.gz" | cut -d ' ' -f1)
rm "$pkgName-$lastVer.tar.gz"

sed -i -E "s|^pkgver=.*|pkgver=\"$lastVer\"|" PKGBUILD
sed -i -E "s|^sha256sums=.*|sha256sums=(\"$sha256sum\")|" PKGBUILD
sed -i -E "s|^url=.*|url=\"https://github.com/$gitBody\"|" PKGBUILD

if [[ -z "$pkgDesc" ]]; then
    sed -i -E "s|^pkgdesc=.*|pkgdesc=\"$pkgDesc\"|" PKGBUILD
fi

makepkg --printsrcinfo > .SRCINFO

echo -e "\n----Totals----"
cat .SRCINFO
echo -e "----Totals----\n"



# Publish AUR Changes
git add PKGBUILD .SRCINFO
git commit -m "Update to $lastVer"
git push
