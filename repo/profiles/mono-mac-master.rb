require 'shutils'

class MonoMacMaster < RockBuild::Profile

  def initialize
    @mono_root = "/Library/Frameworks/Mono.framework"
    @release_version = ENV['MONO_VERSION']
    #FIXME use git distance
    @build_number = "0"
    @mre_guid = "432959f9-ce1b-47a7-94d3-eb99cb2e1aa8"
    @mdk_guid = "964ebddd-1ffe-47e7-8128-5ce17ffffb05"

    raise Exception.new "Please define the environment variable: MONO_VERSION" if @release_version.nil?

    @update_id = @release_version.split('.').concat(["0"] * 3).take(4).map{|p| p.ljust 2, '0'}.join
    @update_id = @update_id + @build_number
    @update_id = @update_id.ljust 9, '0'

    @versions_root = File.join(@mono_root, "Versions")
    @release_root = File.join(@versions_root, @release_version)
    @prefix = @release_root

    @self_dir = Dir.pwd
    @packaging_dir = File.join(@self_dir, "packaging")

    #FIXME why?
    aclocal_dir = File.join(@prefix, "share", "aclocal")
    RockBuild::ShUtils::makedirs(aclocal_dir) unless File.exists? aclocal_dir

  end

  def clean_build_root?
    #FIXME this is a silly test
    !File.exists?(File.join(@release_root, "bin"))
  end

  def packages
    [
      AutoConf.new,
      AutoMake.new,
    ]

		# Toolchain
		#package order is very important.
		#autoconf and automake don't depend on CC
		#ccache uses a different CC since it's not installed yet
		#every thing after ccache needs a working ccache
    # self.packages.extend ([
    #   'autoconf.py',
    #   'automake.py',
    #   'ccache.py',
    #   'libtool.py',
    #   'xz.py',
    #   'tar.py',
    #   'gettext.py',
    #   'pkg-config.py'
    # ])
    # 
    # #needed to autogen gtk+
    # self.packages.extend ([
    #   'gtk-osx-docbook.py',
    #   'gtk-doc.py',
    # ])
    # 
    # # # Base Libraries
    # self.packages.extend([
    #     'libpng.py',
    #     'libjpeg.py',
    #     'libtiff.py',
    #     'libgif.py',
    #     'libxml2.py',
    #     'freetype.py',
    #     'fontconfig.py',
    #     'pixman.py',
    #     'cairo.py',
    #     'libffi.py',
    #     'glib.py',
    #     'pango.py',
    #     'atk.py',
    #     'intltool.py',
    #     'gdk-pixbuf.py',
    #     'gtk+.py',
    #     'libglade.py',
    #     'sqlite.py',
    #     'expat.py',
    #     'ige-mac-integration.py'
    #     ])
    # 
    # # # Theme
    # self.packages.extend([
    #     'libcroco.py',
    #     'librsvg.py',
    #     'hicolor-icon-theme.py',
    #     'gtk-engines.py',
    #     'murrine.py',
    #     'xamarin-gtk-theme.py',
    #     'gtk-quartz-engine.py'
    #     ])
    # 
    # # Mono
    # self.packages.extend([
    #     'mono-llvm.py',
    #     'mono-master.py',
    #     'libgdiplus.py',
    #     'xsp.py',
    #     'gtk-sharp-2.12-release.py',
    #     'boo.py',
    #     # 'nant.py',
    #     'ironlangs.py',
    #     'fsharp-3.0.py',
    #     'mono-addins.py',
    #     'mono-basic.py',
    #     ])

  end
end

