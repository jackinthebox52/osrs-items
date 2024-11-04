pkgname=osrs-items
pkgver=$(cat VERSION)
pkgrel=1
pkgdesc="OSRS Item lookup utility, always up-to-date."
arch=('x86_64')
url="https://github.com/jackinthebox52/osrs-items"
license=('BSD-2-Clause')
depends=('glibc')
makedepends=('go')

prepare() {
    cp -r ../lib ../script ../VERSION .
    cd lib
    ../script/download-items.sh
}

build() {
    cd lib
    export CGO_CPPFLAGS="${CPPFLAGS}"
    export CGO_CFLAGS="${CFLAGS}"
    export CGO_CXXFLAGS="${CXXFLAGS}"
    export CGO_LDFLAGS="${LDFLAGS}"
    export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"
    
    go mod tidy
    go build -o ../$pkgname ./cmd/main.go
}

package() {
    install -Dm755 $pkgname "$pkgdir/usr/bin/$pkgname"
}