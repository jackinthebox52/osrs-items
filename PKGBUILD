pkgname=osrs-items
pkgver=$(cat VERSION)
pkgrel=1
pkgdesc="OSRS Item lookup utility, always up-to-date."
arch=('x86_64')
url="https://github.com/jackinthebox52/osrs-items"
license=('MIT')
depends=('glibc')
makedepends=('go' 'git')
source=("git+https://github.com/jackinthebox52/osrs-items.git")
sha256sums=('SKIP')

build() {
    cd "$pkgname"  # Changed from "$pkgname-$(cat VERSION)"
    export CGO_CPPFLAGS="${CPPFLAGS}"
    export CGO_CFLAGS="${CFLAGS}"
    export CGO_CXXFLAGS="${CXXFLAGS}"
    export CGO_LDFLAGS="${LDFLAGS}"
    export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"
    
    go build -o $pkgname cmd/main.go
}

package() {
    cd "$pkgname"  # Changed from "$pkgname-$(cat VERSION)"
    install -Dm755 $pkgname "$pkgdir/usr/bin/$pkgname"
}