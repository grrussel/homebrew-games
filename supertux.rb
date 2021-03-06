require 'formula'

class Supertux < Formula
  homepage 'http://supertux.lethargik.org/'
  url 'http://download.berlios.de/supertux/supertux-0.1.3.tar.bz2'
  md5 'f2fc288459f33d5cd8f645fbca737a63'

  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'sdl_mixer'
  depends_on 'physfs'
  depends_on 'libogg'
  depends_on 'libvorbis'

  depends_on 'cmake' => :build if ARGV.build_devel?
  depends_on 'glew' if ARGV.build_devel?
  depends_on 'boost' if ARGV.build_devel?

  devel do
    url 'http://download.berlios.de/supertux/supertux-0.3.3.tar.bz2'
    md5 'f3f803e629ee51a9de0b366a036e393d'
  end

  fails_with :clang do
    build 318
    cause "errors in squtils.h"
  end if ARGV.build_devel?

  def patches
    # Patch from macports port
    # https://trac.macports.org/ticket/29635
    { :p0 => DATA } if not ARGV.build_devel?
  end

  def install
    if ARGV.build_devel?
      args = std_cmake_args
      args << '-DINSTALL_SUBDIR_BIN=bin' << 'DINSTALL_SUBDIR_SHARE=share/supertux2'
      system "cmake", ".", *args
      system "make"
      bin.install ['supertux2']
      share.mkpath
      (share + 'supertux2').mkpath
      (share + 'supertux2').install Dir['data/*']
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end

  def test
    system "supertux"
  end
end

__END__
--- src/menu.h.orig	2005-06-21 16:16:07.000000000 -0500
+++ src/menu.h	2011-08-29 03:28:39.000000000 -0500
@@ -207,7 +207,7 @@
 
   bool isToggled(int id);
 
-  void Menu::get_controlfield_key_into_input(MenuItem *item);
+  void get_controlfield_key_into_input(MenuItem *item);
 
   void draw   ();
   void draw_item(int index, int menu_width, int menu_height);

