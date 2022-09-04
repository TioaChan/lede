#!/usr/bin/bash

# fetch
git fetch --all
# rebase
git rebase upstream/master
#push
git push -f
# fetch
git fetch --all
# uninstall packages
./scripts/feeds uninstall -a
rm -rf ./feeds
# openwrt
./scripts/feeds update -a && ./scripts/feeds install -a
#remove argon theme 
rm -rf ./feeds/luci/themes/luci-theme-argon
rm -rf ./feeds/luci.tmp/info/.packageinfo-themes_luci-theme-argon
sed -i 's/luci-lib-ipkg/luci-base/' ./feeds/istore/luci/luci-app-store/Makefile
# install packages
./scripts/feeds update -a && ./scripts/feeds install -a
make defconfig
make -j8 download

# make menuconfig
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(go env GOPATH)/bin  make V=s -j$(nproc)