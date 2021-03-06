require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.2.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.2.4.tar.xz'
  sha256 '1e7ca67a7870a82c9ed51d51d0008cdbc550c41d64cc3ff3f9a1c2fc311b4929'

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gstreamer'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'gobject-introspection' => :optional
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
    end

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
