#!/usr/bin/env bash
set -euo pipefail

HOME=/home/synchronizer
pkgName="$INPUT_PKG_NAME"

cd ~/
mkdir -p ~/.ssh

eval "$(ssh-agent -s)"
echo "$INPUT_SSH_PRIVATE_KEY" | tr -d '' | ssh-add -
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts

git -c init.defaultBranch=master clone ssh://aur@aur.archlinux.org/$pkgName.git
cd $pkgName

lastVer=$(curl -s "https://api.github.com/repos/Blaadick/BlaadPapers/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
curl -s -L "https://github.com/Blaadick/BlaadPapers/archive/refs/tags/v$lastVer.tar.gz" -o "$pkgName-$lastVer.tar.gz"
sha256sum=$(sha256sum "$pkgName-$lastVer.tar.gz" | cut -d ' ' -f1)
rm "$pkgName-$lastVer.tar.gz"

sed -i -E "s/^pkgver=.*/pkgver='$lastVer'/" PKGBUILD
sed -i -E "s/^sha256sums=.*/sha256sums=('$sha256sum')/" PKGBUILD

makepkg --printsrcinfo > .SRCINFO

cat .SRCINFO

git config --global user.name "Blaadick"
git config --global user.email ""

git add PKGBUILD .SRCINFO
git commit -m "Update to $lastVer"
git push
