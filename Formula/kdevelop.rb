class Kdevelop < Formula
  desc "Integrated Development Environment for KDE"
  homepage "https://kdevelop.org"
  url "https://download.kde.org/stable/kdevelop/5.3.2/src/kdevelop-5.3.2.tar.xz"
  sha256 "08ccd575514187dcbd01ac976a619803410c26bdfabf5d2d5fd52c95b76d6f2a"
  revision 1
  head "git://anongit.kde.org/kdevelop.git"

  depends_on "boost" => :build
  depends_on "cvs" => :build
  depends_on "gdb" => :build
  depends_on "KDE-mac/kde/kdevelop-pg-qt" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "ninja" => :build
  depends_on "shared-mime-info" => :build

  depends_on "cmake"
  depends_on "KDE-mac/kde/grantlee5"
  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kcmutils"
  depends_on "KDE-mac/kde/kf5-kitemmodels"
  depends_on "KDE-mac/kde/kf5-knewstuff"
  depends_on "KDE-mac/kde/kf5-knotifyconfig"
  depends_on "KDE-mac/kde/kf5-ktexteditor"
  depends_on "KDE-mac/kde/kf5-threadweaver"
  depends_on "KDE-mac/kde/ksysguard"
  depends_on "KDE-mac/kde/libkomparediff2"
  depends_on "llvm"

  depends_on "cppcheck" => :optional
  depends_on "gdb" => :optional
  depends_on "KDE-mac/kde/kf5-plasma-framework" => :optional
  depends_on "KDE-mac/kde/konsole" => :optional
  depends_on "subversion" => :optional

  conflicts_with "KDE-mac/kde/kdevplatform", :because => "Now included in Kdevelop"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"
    args << "-DUPDATE_MIME_DATABASE_EXECUTABLE=OFF"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
    qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    chmod "+w", "#{bin}/kdevelop.app/Contents/Info.plist"
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kdevelop.app/Contents/Info.plist"
    chmod "-w", "#{bin}/kdevelop.app/Contents/Info.plist"
  end

  def post_install
    system HOMEBREW_PREFIX/"bin/update-mime-database", HOMEBREW_PREFIX/"share/mime"
    mkdir_p HOMEBREW_PREFIX/"share/kdevelop"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kdevelop/icontheme.rcc"
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      ln -sfv "$(brew --prefix)/share/kdevappwizard" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevclangsupport" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevcodeutils" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevelop" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevfiletemplates" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevgdb" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevmanpage" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevqmakebuilder" "$HOME/Library/Application Support"
      ln -sfv "$(brew --prefix)/share/kdevqmljssupport" "$HOME/Library/Application Support"
      mkdir -pv "$HOME/Applications/KDE"
      ln -sfv "$(brew --prefix)/opt/kdevelop/bin/kdevelop.app" "$HOME/Applications/KDE/"
  EOS
  end

  test do
    assert `"#{bin}/kdevelop.app/Contents/MacOS/kdevelop" --help | grep -- --help` =~ /--help/
  end
end
