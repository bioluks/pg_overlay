# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs poly-c_ebuilds

REAL_P="SDL3_image-${MY_PV}"
DESCRIPTION="Image file loading library"
HOMEPAGE="https://www.libsdl.org/projects/SDL_image/"
SRC_URI="https://github.com/libsdl-org/SDL_image/releases/download/release-${MY_PV}/${REAL_P}.tar.gz"
S="${WORKDIR}"/${REAL_P}

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="avif gif jpeg jpegxl png test tiff webp"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( jpeg png )"

RDEPEND="
	>=media-libs/libsdl3-3.2.2[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	avif? ( >=media-libs/libavif-0.9.3:=[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.6.10:0[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpegxl? ( media-libs/libjxl:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.7-r1:=[${MULTILIB_USEDEP}] )
	webp? ( >=media-libs/libwebp-0.3.0:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDLIMAGE_AVIF="$(usex avif)"
		-DSDLIMAGE_AVIF_SHARED=OFF
		-DSDLIMAGE_BACKEND_STB=OFF
		-DSDLIMAGE_BMP=ON
		-DSDLIMAGE_GIF="$(usex gif)"
		-DSDLIMAGE_JPG="$(usex jpeg)"
		-DSDLIMAGE_JPG_SHARED=OFF
		-DSDLIMAGE_JXL="$(usex jpegxl)"
		-DSDLIMAGE_JXL_SHARED=OFF
		-DSDLIMAGE_LBM=ON
		-DSDLIMAGE_PCX=ON
		-DSDLIMAGE_PNG="$(usex png)"
		-DSDLIMAGE_PNG_SHARED=OFF
		-DSDLIMAGE_PNM=ON
		-DSDLIMAGE_TESTS="$(usex test)"
		-DSDLIMAGE_TESTS_INSTALL=OFF
		-DSDLIMAGE_TGA=ON
		-DSDLIMAGE_TIF="$(usex tiff)"
		-DSDLIMAGE_TIF_SHARED=OFF
		-DSDLIMAGE_QOI=ON
		-DSDLIMAGE_XCF=ON
		-DSDLIMAGE_XPM=ON
		-DSDLIMAGE_XV=ON
		-DSDLIMAGE_WEBP="$(usex webp)"
		-DSDLIMAGE_WEBP_SHARED=OFF
	)

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
	multilib_is_native_abi && newbin showimage$(get_exeext) showimage3$(get_exeext)
}

multilib_src_install_all() {
	dodoc CHANGES.txt README.md
}
