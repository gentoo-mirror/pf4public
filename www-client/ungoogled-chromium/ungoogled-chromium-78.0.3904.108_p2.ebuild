# Copyright 2009-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

CHROMIUM_LANGS="am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit check-reqs chromium-2 desktop flag-o-matic multilib ninja-utils pax-utils portability python-r1 readme.gentoo-r1 toolchain-funcs xdg-utils

UGC_PV="${PV/_p/-}"
UGC_P="${PN}-${UGC_PV}"
UGC_WD="${WORKDIR}/${UGC_P}"

DESCRIPTION="Modifications to Chromium for removing Google integration and enhancing privacy"
HOMEPAGE="https://www.chromium.org/Home https://github.com/Eloston/ungoogled-chromium"
SRC_URI="
	https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV/_*}.tar.xz
	https://github.com/Eloston/${PN}/archive/${UGC_PV}.tar.gz -> ${UGC_P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
	cfi +clang closure-compile convert-dict cups custom-cflags enable-driver gnome
	gnome-keyring hangouts jumbo-build kerberos libcxx new-tcmalloc	optimize-thinlto
	optimize-webui pdf +proprietary-codecs pulseaudio selinux suid +system-ffmpeg
	+system-harfbuzz +system-icu +system-jsoncpp +system-libevent +system-libvpx
	+system-openh264 system-openjpeg +tcmalloc thinlto vaapi widevine
"
RESTRICT="
	!system-ffmpeg? ( proprietary-codecs? ( bindist ) )
	!system-openh264? ( bindist )
"
REQUIRED_USE="
	|| ( $(python_gen_useflags 'python3*') )
	|| ( $(python_gen_useflags 'python2*') )
	thinlto? ( clang )
	cfi? ( clang thinlto )
	libcxx? ( new-tcmalloc )
	new-tcmalloc? ( tcmalloc )
	optimize-thinlto? ( thinlto )
	system-openjpeg? ( pdf )
	x86? ( !thinlto !cfi )
"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.26:2
	cups? ( >=net-print/cups-1.3.11:= )
	>=dev-libs/atk-2.26
	dev-libs/expat:=
	dev-libs/glib:2
	system-icu? ( >=dev-libs/icu-64:= )
	>=dev-libs/libxml2-2.9.4-r3:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	>=dev-libs/re2-0.2016.11.01:=
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.12:= )
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	system-harfbuzz? (
		media-libs/freetype:=
		>=media-libs/harfbuzz-2.4.0:0=[icu(-)]
	)
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	system-libvpx? (
		media-libs/libvpx:=[postproc,svc]
		|| (
			=media-libs/libvpx-1.7*
			>media-libs/libvpx-1.8.1
		)
	)
	>=media-libs/openh264-1.6.0:=
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? (
		>=media-video/ffmpeg-4:=
		|| (
			media-video/ffmpeg[-samba]
			>=net-fs/samba-4.5.10-r1[-debug(-)]
		)
		!=net-fs/samba-4.5.12-r0
		media-libs/opus:=
	)
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	media-libs/flac:=
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
	pdf? ( media-libs/lcms:= )
	system-jsoncpp? ( dev-libs/jsoncpp )
	system-libevent? ( dev-libs/libevent )
	system-openjpeg? ( media-libs/openjpeg:2= )
	vaapi? ( x11-libs/libva:= )
"
# For nvidia-drivers blocker, see bug #413637 .
RDEPEND="${COMMON_DEPEND}
	!<www-plugins/chrome-binary-plugins-57
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
	!www-client/chromium
	!www-client/chromium-bin
	!www-client/ungoogled-chromium-bin
"
DEPEND="${COMMON_DEPEND}
"
# dev-vcs/git - https://bugs.gentoo.org/593476
BDEPEND="
	${PYTHON_DEPS}
	app-arch/bzip2:=
	>=app-arch/gzip-1.7
	dev-lang/yasm
	dev-lang/perl
	dev-util/gn
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	optimize-webui? ( >=net-libs/nodejs-7.6.0[inspector] )
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	closure-compile? ( virtual/jre )
	virtual/pkgconfig
	clang? ( >=sys-devel/clang-8.0.0 )
	thinlto? ( >=sys-devel/lld-8.0.0 )
	virtual/libusb:1
	cfi? ( >=sys-devel/clang-runtime-8.0.0[sanitize] )
	libcxx? (
		sys-libs/libcxx
		sys-libs/libcxxabi
	)
"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/noto
- media-fonts/noto-emoji
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

To fix broken icons on the Downloads page, you should install an icon
theme that covers the appropriate MIME types, and configure this as your
GTK+ icon theme.

For native file dialogs in KDE, install kde-apps/kdialog.
"

PATCHES=(
	"${FILESDIR}/${PN}-78-gcc-include.patch"
	"${FILESDIR}/${PN}-78-icon.patch"
	"${FILESDIR}/${PN}-78-pm-crash.patch"
	"${FILESDIR}/${PN}-78-protobuf-export.patch"
	"${FILESDIR}/${PN}-disable-installer-r1.patch"
	"${FILESDIR}/${PN}-disable-font-tests.patch"
	"${FILESDIR}/${PN}-disable-swiftshader.patch"
	"${FILESDIR}/${PN}-disable-third-party-lzma-sdk-r0.patch"
	"${FILESDIR}/${PN}-system-libusb-r0.patch"
	"${FILESDIR}/${PN}-system-nspr-r0.patch"
	"${FILESDIR}/${PN}-system-fix-shim-headers-r0.patch"
	"${FILESDIR}/${PN}-unbundle-zlib-r1.patch"
	"${FILESDIR}/${PN}-skia-harmony.patch"
	"${FILESDIR}/${PN}-fix-dns_util.patch"
	"${FILESDIR}/${PN}-79-icu-65.patch"
)

S="${WORKDIR}/chromium-${PV/_*}"

pre_build_checks() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		local -x CPP="$(tc-getCXX) -E"
		if tc-is-gcc && ! ver_test "$(gcc-version)" -ge 8.0; then
			die "At least gcc 8.0 is required"
		fi
	fi

	# Check build requirements, bug #541816 and bug #471810 .
	CHECKREQS_MEMORY="3G"
	CHECKREQS_DISK_BUILD="7G"
	if ( shopt -s extglob; is-flagq '-g?(gdb)?([1-9])' ); then
		CHECKREQS_DISK_BUILD="25G"
	fi
	check-reqs_pkg_setup
}

pkg_pretend() {
	if use custom-cflags && [[ "${MERGE_TYPE}" != binary ]]; then
		ewarn
		ewarn "USE=custom-cflags bypass strip-flags; you are on your own."
		ewarn "Expect build failures. Don't file bugs using that unsupported USE flag!"
		ewarn
	fi
	pre_build_checks
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup 'python3*'

	default

	if use optimize-webui; then
	mkdir -p third_party/node/linux/node-linux-x64/bin || die
	ln -s "${EPREFIX}"/usr/bin/node third_party/node/linux/node-linux-x64/bin/node || die
	fi

	use convert-dict && eapply "${FILESDIR}/${PN}-ucf-dict-utility.patch"
	use system-icu && eapply "${FILESDIR}/${PN}-system-icu.patch"
	use system-icu && eapply "${FILESDIR}/${PN}-77-system-icu.patch"
	use system-icu && eapply "${FILESDIR}/${PN}-system-convertutf.patch"
	use system-jsoncpp && eapply "${FILESDIR}/${PN}-system-jsoncpp-r1.patch"
	use system-libvpx && eapply "${FILESDIR}/${PN}-system-vpx-r1.patch"
	has_version "=media-libs/libvpx-1.7*" && eapply "${FILESDIR}/${PN}-vpx-1.7-compatibility-r1.patch"
	use system-openjpeg && eapply "${FILESDIR}/${PN}-system-openjpeg-r2.patch"
	use vaapi && eapply "${FILESDIR}/${PN}-enable-vaapi-r1.patch"
	use vaapi && eapply "${FILESDIR}/${PN}-fix-vaapi-r1.patch"

	# Hack for libusb stuff (taken from openSUSE)
	rm third_party/libusb/src/libusb/libusb.h || die
	cp -a "${EPREFIX}/usr/include/libusb-1.0/libusb.h" \
		third_party/libusb/src/libusb/libusb.h || die

	# From here we adapt ungoogled-chromium's patches to our needs
	local ugc_pruning_list="${UGC_WD}/pruning.list"
	local ugc_patch_series="${UGC_WD}/patches/series"

	local ugc_unneeded=(
		# GN bootstrap
		extra/debian_buster/gn/parallel
	)

	local ugc_p ugc_dir
	for p in "${ugc_unneeded[@]}"; do
		einfo "Removing ${p}.patch"
		sed -i "\!${p}.patch!d" "${ugc_patch_series}" || die
	done

	if use closure-compile; then
		ewarn "Keeping binary compiler.jar in sources tree for closure-compile"
		sed -i '\!third_party/closure_compiler/compiler/compiler.jar!d' "${ugc_pruning_list}" || die
	fi

	ebegin "Pruning binaries"
	"${UGC_WD}/utils/prune_binaries.py" -q . "${UGC_WD}/pruning.list"
	eend $? || die

	ebegin "Applying ungoogled-chromium patches"
	"${UGC_WD}/utils/patches.py" -q apply . "${UGC_WD}/patches"
	eend $? || die

	ebegin "Applying domain substitution"
	"${UGC_WD}/utils/domain_substitution.py" -q apply -r "${UGC_WD}/domain_regex.list" -f "${UGC_WD}/domain_substitution.list" -c build/domsubcache.tar.gz .
	eend $? || die

	local keeplibs=(
		base/third_party/cityhash
		base/third_party/double_conversion
		base/third_party/dynamic_annotations
		base/third_party/icu
		base/third_party/superfasthash
		base/third_party/symbolize
		base/third_party/valgrind
		base/third_party/xdg_mime
		base/third_party/xdg_user_dirs
		chrome/third_party/mozilla_security_manager
		courgette/third_party
		net/third_party/mozilla_security_manager
		net/third_party/nss
		net/third_party/quic
		net/third_party/uri_template
		third_party/abseil-cpp
		third_party/angle
		third_party/angle/src/common/third_party/base
		third_party/angle/src/common/third_party/smhasher
		third_party/angle/src/common/third_party/xxhash
		third_party/angle/src/third_party/compiler
		third_party/angle/src/third_party/libXNVCtrl
		third_party/angle/src/third_party/trace_event
		third_party/angle/third_party/glslang
		third_party/angle/third_party/spirv-headers
		third_party/angle/third_party/spirv-tools
		third_party/angle/third_party/vulkan-headers
		third_party/angle/third_party/vulkan-loader
		third_party/angle/third_party/vulkan-tools
		third_party/angle/third_party/vulkan-validation-layers
		third_party/apple_apsl
		third_party/axe-core
		third_party/blink
		third_party/boringssl
		third_party/boringssl/src/third_party/fiat
		third_party/boringssl/src/third_party/sike
		third_party/boringssl/linux-x86_64/crypto/third_party/sike
		third_party/breakpad
		third_party/breakpad/breakpad/src/third_party/curl
		third_party/brotli
		third_party/cacheinvalidation
		third_party/catapult
		third_party/catapult/common/py_vulcanize/third_party/rcssmin
		third_party/catapult/common/py_vulcanize/third_party/rjsmin
		third_party/catapult/third_party/beautifulsoup4
		third_party/catapult/third_party/html5lib-python
		third_party/catapult/third_party/polymer
		third_party/catapult/third_party/six
		third_party/catapult/tracing/third_party/d3
		third_party/catapult/tracing/third_party/gl-matrix
		third_party/catapult/tracing/third_party/jpeg-js
		third_party/catapult/tracing/third_party/jszip
		third_party/catapult/tracing/third_party/mannwhitneyu
		third_party/catapult/tracing/third_party/oboe
		third_party/catapult/tracing/third_party/pako
		third_party/ced
		third_party/cld_3
		third_party/closure_compiler
		third_party/crashpad
		third_party/crashpad/crashpad/third_party/lss
		third_party/crashpad/crashpad/third_party/zlib
		third_party/crc32c
		third_party/cros_system_api
		third_party/dav1d
		third_party/dawn
		third_party/depot_tools
		third_party/devscripts
		third_party/dom_distiller_js
		third_party/emoji-segmenter
		third_party/flatbuffers
		third_party/flot
		third_party/glslang
		third_party/google_input_tools
		third_party/google_input_tools/third_party/closure_library
		third_party/google_input_tools/third_party/closure_library/third_party/closure
		third_party/googletest
		third_party/hunspell
		third_party/iccjpeg
		third_party/inspector_protocol
		third_party/jinja2
		third_party/jstemplate
		third_party/khronos
		third_party/leveldatabase
		third_party/libXNVCtrl
		third_party/libaddressinput
		third_party/libaom
		third_party/libaom/source/libaom/third_party/vector
		third_party/libaom/source/libaom/third_party/x86inc
		third_party/libjingle
		third_party/libphonenumber
		third_party/libsecret
		third_party/libsrtp
		third_party/libsync
		third_party/libudev
		third_party/libwebm
		third_party/libxml/chromium
		third_party/libyuv
		third_party/lss
		third_party/markupsafe
		third_party/mesa
		third_party/metrics_proto
		third_party/modp_b64
		third_party/nasm
		third_party/one_euro_filter
		third_party/openscreen
		third_party/openscreen/src/third_party/tinycbor/src/src
		third_party/ots
		third_party/perfetto
		third_party/pffft
		third_party/ply
		third_party/polymer
		third_party/private-join-and-compute
		third_party/protobuf
		third_party/protobuf/third_party/six
		third_party/pyjson5
		third_party/qcms
		third_party/rnnoise
		third_party/s2cellid
		third_party/sfntly
		third_party/simplejson
		third_party/skia
		third_party/skia/include/third_party/skcms
		third_party/skia/include/third_party/vulkan
		third_party/skia/third_party/gif
		third_party/skia/third_party/skcms
		third_party/skia/third_party/vulkan
		third_party/smhasher
		third_party/spirv-headers
		third_party/SPIRV-Tools
		third_party/sqlite
		third_party/swiftshader
		third_party/swiftshader/third_party/llvm-7.0
		third_party/swiftshader/third_party/llvm-subzero
		third_party/swiftshader/third_party/subzero
		third_party/swiftshader/third_party/SPIRV-Headers/include/spirv/unified1
		third_party/ungoogled
		third_party/usrsctp
		third_party/vulkan
		third_party/web-animations-js
		third_party/webdriver
		third_party/webrtc
		third_party/webrtc/common_audio/third_party/fft4g
		third_party/webrtc/common_audio/third_party/spl_sqrt_floor
		third_party/webrtc/modules/third_party/fft
		third_party/webrtc/modules/third_party/g711
		third_party/webrtc/modules/third_party/g722
		third_party/webrtc/rtc_base/third_party/base64
		third_party/webrtc/rtc_base/third_party/sigslot
		third_party/widevine
		third_party/woff2
		third_party/zlib/google
		tools/grit/third_party/six
		url/third_party/mozilla
		v8/src/third_party/siphash
		v8/src/third_party/valgrind
		v8/src/third_party/utf8-decoder
		v8/third_party/inspector_protocol
		v8/third_party/v8

		third_party/adobe
		third_party/speech-dispatcher
		third_party/usb_ids
		third_party/xdg-utils
		third_party/yasm/run_yasm.py

		third_party/libusb
	)

	use optimize-webui && keeplibs+=(
		third_party/node
		third_party/node/node_modules/polymer-bundler/lib/third_party/UglifyJS2
	)

	use pdf && keeplibs+=(
		third_party/pdfium
		third_party/pdfium/third_party/agg23
		third_party/pdfium/third_party/base
		third_party/pdfium/third_party/bigint
		third_party/pdfium/third_party/freetype
		third_party/pdfium/third_party/lcms
		third_party/pdfium/third_party/libtiff
		third_party/pdfium/third_party/skia_shared
	)

	use system-ffmpeg || keeplibs+=(
		third_party/ffmpeg
		third_party/opus
	)

	use system-harfbuzz || keeplibs+=(
		third_party/freetype
		third_party/harfbuzz-ng
	)

	use system-icu || keeplibs+=( third_party/icu )
	use system-jsoncpp || keeplibs+=( third_party/jsoncpp )
	use system-libevent || keeplibs+=( base/third_party/libevent )

	use system-libvpx || keeplibs+=(
		third_party/libvpx
		third_party/libvpx/source/libvpx/third_party/x86inc
	)

	use system-openh264 || keeplibs+=( third_party/openh264 )

	use system-openjpeg || keeplibs+=(
		third_party/pdfium/third_party/libopenjpeg20
	)

	use tcmalloc && keeplibs+=( third_party/tcmalloc )

	ebegin "Removing unneeded bundled libraries"
	python_setup 'python2*'

	# Remove most bundled libraries. Some are still needed.
	build/linux/unbundle/remove_bundled_libraries.py "${keeplibs[@]}" --do-remove

	eend $? || die
}

src_configure() {
	# Calling this here supports resumption via FEATURES=keepwork
	python_setup 'python2*'

	local myconf_gn=""

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	if use clang && ! tc-is-clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		strip-unsupported-flags
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		strip-unsupported-flags
	fi

	if tc-is-clang; then
		myconf_gn+=" is_clang=true clang_use_chrome_plugins=false"
	else
		myconf_gn+=" is_clang=false"
		append-cxxflags -fpermissive
	fi

	# Define a custom toolchain for GN
	myconf_gn+=" custom_toolchain=\"//build/toolchain/linux/unbundle:default\""

	if tc-is-cross-compiler; then
		tc-export BUILD_{AR,CC,CXX,NM}
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:host\""
		myconf_gn+=" v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
	else
		myconf_gn+=" host_toolchain=\"//build/toolchain/linux/unbundle:default\""
	fi

	# GN needs explicit config for Debug/Release as opposed to inferring it from build directory.
	myconf_gn+=" is_debug=false"

	# https://chromium.googlesource.com/chromium/src/+/lkcr/docs/jumbo.md
	myconf_gn+=" use_jumbo_build=$(usex jumbo-build true false)"

	myconf_gn+=" use_allocator=$(usex tcmalloc \"tcmalloc\" \"none\")"

	# Disable nacl, we can't build without pnacl (http://crbug.com/269560).
	myconf_gn+=" enable_nacl=false"

	local gn_system_libraries=(
		flac
		fontconfig
		libdrm
		libjpeg
		libpng
		libusb
		libwebp
		libxml
		libxslt
		re2
		snappy
		yasm
		zlib
	)

	use system-ffmpeg && gn_system_libraries+=( ffmpeg opus )
	use system-harfbuzz && gn_system_libraries+=( freetype harfbuzz-ng )
	use system-icu && gn_system_libraries+=( icu )
	use system-libevent && gn_system_libraries+=( libevent )
	use system-libvpx && gn_system_libraries+=( libvpx )
	use system-openh264 && gn_system_libraries+=( openh264 )

	build/linux/unbundle/replace_gn_files.py --system-libraries "${gn_system_libraries[@]}" || die

	# See dependency logic in third_party/BUILD.gn
	myconf_gn+=" use_system_harfbuzz=true"

	# Optional dependencies.
	myconf_gn+=" closure_compile=$(usex closure-compile true false)"
	myconf_gn+=" enable_hangout_services_extension=$(usex hangouts true false)"
	myconf_gn+=" enable_widevine=$(usex widevine true false)"
	myconf_gn+=" use_cups=$(usex cups true false)"
	myconf_gn+=" use_gnome_keyring=$(usex gnome-keyring true false)"
	myconf_gn+=" use_kerberos=$(usex kerberos true false)"
	myconf_gn+=" use_pulseaudio=$(usex pulseaudio true false)"
	myconf_gn+=" link_pulseaudio=$(usex pulseaudio true false)"

	myconf_gn+=" is_cfi=$(usex cfi true false)"
	if use cfi
	then
		myconf_gn+=(
		" use_cfi_icall=true"
		" use_cfi_cast=true"
		)
	fi

	myconf_gn+=" use_thin_lto=$(usex thinlto true false)"
	myconf_gn+=" thin_lto_enable_optimizations=$(usex optimize-thinlto true false)"
	myconf_gn+=" optimize_webui=$(usex optimize-webui true false)"
	myconf_gn+=" use_gio=$(usex gnome true false)"
	myconf_gn+=" use_openh264=$(usex system-openh264 false true)"
	myconf_gn+=" use_system_freetype=$(usex system-harfbuzz true false)"
	myconf_gn+=" use_system_libopenjpeg2=$(usex system-openjpeg true false)"
	myconf_gn+=" use_vaapi=$(usex vaapi true false)"
	myconf_gn+=" enable_pdf=$(usex pdf true false)"
	myconf_gn+=" use_system_lcms2=$(usex pdf true false)"
	myconf_gn+=" enable_print_preview=$(usex pdf true false)"
	myconf_gn+=" use_new_tcmalloc=$(usex new-tcmalloc true false)"

	# Ungoogled flags
	myconf_gn+=(
		" enable_hevc_demuxing=true"
		" enable_mdns=false"
		" enable_mse_mpeg2ts_stream_parser=true"
		" enable_nacl_nonsfi=false"
		" enable_one_click_signin=false"
		" enable_reading_list=false"
		" enable_remoting=false"
		" enable_reporting=false"
		" enable_service_discovery=false"
		" exclude_unwind_tables=true"
		" use_official_google_api_keys=false"
		" google_api_key=\"\""
		" google_default_client_id=\"\""
		" google_default_client_secret=\"\""
		" safe_browsing_mode=0"
		" use_unofficial_version_number=false"
		" blink_symbol_level=0"
		" symbol_level=0"
		" enable_ac3_eac3_audio_demuxing=true"
		" enable_iterator_debugging=false"
		" enable_swiftshader=false"
		" is_official_build=true"
	)

	# Additional flags
	myconf_gn+=(
		" use_system_libjpeg=true"
		" use_system_zlib=true"
		" rtc_build_examples=false"
	)

	myconf_gn+=" fieldtrial_testing_like_official_build=true"

	# Never use bundled gold binary. Disable gold linker flags for now.
	# Do not use bundled clang.
	# Trying to use gold results in linker crash.
	myconf_gn+=" use_gold=false use_sysroot=false linux_use_bundled_binutils=false use_custom_libcxx=false"

	# Disable forced lld, bug 641556
	myconf_gn+=" use_lld=false"

	ffmpeg_branding="$(usex proprietary-codecs Chrome Chromium)"
	myconf_gn+=" proprietary_codecs=$(usex proprietary-codecs true false)"
	myconf_gn+=" ffmpeg_branding=\"${ffmpeg_branding}\""

	local myarch="$(tc-arch)"

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags

		# Prevent linker from running out of address space, bug #471810 .
		if use x86; then
			filter-flags "-g*"
		fi

		# Prevent libvpx build failures. Bug 530248, 544702, 546984.
		if [[ ${myarch} == amd64 || ${myarch} == x86 ]]; then
			filter-flags -mno-mmx -mno-sse2 -mno-ssse3 -mno-sse4.1 -mno-avx -mno-avx2
		fi
	fi

	if [[ $myarch = amd64 ]] ; then
		myconf_gn+=" target_cpu=\"x64\""
		ffmpeg_target_arch=x64
	elif [[ $myarch = x86 ]] ; then
		myconf_gn+=" target_cpu=\"x86\""
		ffmpeg_target_arch=ia32

		# This is normally defined by compiler_cpu_abi in
		# build/config/compiler/BUILD.gn, but we patch that part out.
		append-flags -msse2 -mfpmath=sse -mmmx
	elif [[ $myarch = arm64 ]] ; then
		myconf_gn+=" target_cpu=\"arm64\""
		ffmpeg_target_arch=arm64
	elif [[ $myarch = arm ]] ; then
		myconf_gn+=" target_cpu=\"arm\""
		ffmpeg_target_arch=$(usex cpu_flags_arm_neon arm-neon arm)
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	if use libcxx; then
		append-cxxflags "-stdlib=libc++"
		append-ldflags "-stdlib=libc++ -Wl,-lc++abi"
	else
		if has_version 'sys-devel/clang[default-libcxx]'; then
			append-cxxflags "-stdlib=libstdc++"
			append-ldflags "-stdlib=libstdc++"
		fi
	fi

	if use thinlto; then
		# We need to change the default value of import-instr-limit in
		# LLVM to limit the text size increase. The default value is
		# 100, and we change it to 30 to reduce the text size increase
		# from 25% to 10%. The performance number of page_cycler is the
		# same on two of the thinLTO configurations, we got 1% slowdown
		# on speedometer when changing import-instr-limit from 100 to 30.
		local thinlto_ldflag=( "-Wl,-plugin-opt,-import-instr-limit=30" )

		#use gold && thinlto_ldflag+=(
		#	"-Wl,-plugin-opt=thinlto"
		#	"-Wl,-plugin-opt,jobs=$(makeopts_jobs)"
		#)

		#use lld && thinlto_ldflag+=( "-Wl,--thinlto-jobs=$(makeopts_jobs)" )

		append-ldflags "${thinlto_ldflag[*]}"
		myconf_gn+=" use_lld=true"
	#else
		#use gold && append-ldflags "-Wl,--threads -Wl,--thread-count=$(makeopts_jobs)"
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors=false"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings=false"

	# Bug 491582.
	export TMPDIR="${WORKDIR}/temp"
	mkdir -p -m 755 "${TMPDIR}" || die

	# https://bugs.gentoo.org/654216
	addpredict /dev/dri/ #nowarn

	#if ! use system-ffmpeg; then
	if false; then
		local build_ffmpeg_args=""
		if use pic && [[ "${ffmpeg_target_arch}" == "ia32" ]]; then
			build_ffmpeg_args+=" --disable-asm"
		fi

		# Re-configure bundled ffmpeg. See bug #491378 for example reasons.
		einfo "Configuring bundled ffmpeg..."
		pushd third_party/ffmpeg > /dev/null || die
		chromium/scripts/build_ffmpeg.py linux ${ffmpeg_target_arch} \
			--branding ${ffmpeg_branding} -- ${build_ffmpeg_args} || die
		chromium/scripts/copy_config.sh || die
		chromium/scripts/generate_gn.py || die
		popd > /dev/null || die
	fi

	# Facilitate deterministic builds (taken from build/config/compiler/BUILD.gn)
	append-cflags -Wno-builtin-macro-redefined
	append-cxxflags -Wno-builtin-macro-redefined
	append-cppflags "-D__DATE__= -D__TIME__= -D__TIMESTAMP__="

	local flags
	einfo "Building with following compiler settings:"
	for flags in {C,CXX,CPP,LD}FLAGS; do
		einfo "  ${flags} = ${!flags}"
	done

	einfo "Configuring Chromium..."
	set -- gn gen --args="${myconf_gn} ${EXTRA_GN}" out/Release
	echo "$@"
	"$@" || die
}

src_compile() {
	# Final link uses lots of file descriptors
	ulimit -n 4096

	# Calling this here supports resumption via FEATURES=keepwork
	python_setup 'python2*'

	use convert-dict && eninja -C out/Release convert_dict

	# Build mksnapshot and pax-mark it.
	local x
	for x in mksnapshot v8_context_snapshot_generator; do
		if tc-is-cross-compiler; then
			eninja -C out/Release "host/${x}"
			pax-mark m "out/Release/host/${x}"
		else
			eninja -C out/Release "${x}"
			pax-mark m "out/Release/${x}"
		fi
	done

	# Work around broken deps
	eninja -C out/Release gen/ui/accessibility/ax_enums.mojom{,-shared}.h

	# Even though ninja autodetects number of CPUs, we respect
	# user's options, for debugging with -j 1 or any other reason.
	eninja -C out/Release chrome

	use enable-driver && eninja -C out/Release chromedriver
	use suid && eninja -C out/Release chrome_sandbox

	pax-mark m out/Release/chrome

	# Build manpage; bug #684550
	sed -e 's|@@PACKAGE@@|chromium-browser|g;
		s|@@MENUNAME@@|Chromium|g;' \
		chrome/app/resources/manpage.1.in > \
		out/Release/chromium-browser.1 || die
}

src_install() {
	local CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser"
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome

	if use convert-dict; then
		newexe "${FILESDIR}/${PN}-update-dicts.sh" ungoogled-chromium-update-dicts.sh
		doexe out/Release/convert_dict
	fi

	if use suid; then
		newexe out/Release/chrome_sandbox chrome-sandbox
		fperms 4755 "${CHROMIUM_HOME}/chrome-sandbox"
	fi

	use enable-driver && doexe out/Release/chromedriver

	local sedargs=( -e "s:/usr/lib/:/usr/$(get_libdir)/:g" )
	sed "${sedargs[@]}" "${FILESDIR}/${PN}-launcher-r3.sh" > chromium-launcher.sh || die
	doexe chromium-launcher.sh

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium

	dosym "${CHROMIUM_HOME}/chromedriver" /usr/bin/chromedriver

	# Allow users to override command-line options, bug #357629.
	insinto /etc/chromium
	newins "${FILESDIR}/${PN}.default" "default"

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.bin
	doins out/Release/*.pak
	doins out/Release/*.so

	if ! use system-icu; then
		doins out/Release/icudtl.dat
	fi

	doins -r out/Release/locales
	doins -r out/Release/resources

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${CHROMIUM_HOME}/swiftshader"
		doins out/Release/swiftshader/*.so
	fi

	# Install icons and desktop entry.
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="chrome/app/theme/default_100_percent/chromium" ;;
				*) branding="chrome/app/theme/chromium" ;;
		esac
		newicon -s ${size} "${branding}/product_logo_${size}.png" \
			chromium-browser.png
	done

	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		chromium-browser \
		"Chromium" \
		chromium-browser \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"
	sed -e "/^Exec/s/$/ %U/" -i "${ED}"/usr/share/applications/*.desktop || die

	# Install GNOME default application entry (bug #303100).
	insinto /usr/share/gnome-control-center/default-apps
	newins "${FILESDIR}"/chromium-browser.xml chromium-browser.xml

	# Install manpage; bug #684550
	doman out/Release/chromium-browser.1
	dosym chromium-browser.1 /usr/share/man/man1/chromium.1

	readme.gentoo_create_doc
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	readme.gentoo_print_elog
}
