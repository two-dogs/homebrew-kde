class KioGdrive < Formula
  desc "Slave to access Google Drive"
  homepage "https://community.kde.org/KIO_GDrive"
  url "http://download.kde.org/stable/kio-gdrive/1.2.4/src/kio-gdrive-1.2.4.tar.xz"
  sha256 "ba903a5bf3b538d42a09bf4d6192e9f06f7e1f80bf5cb4b5c7163b251142c0fc"
  head "git://anongit.kde.org/kio-gdrive.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "kde-mac/kde/kf5-kio"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
    # Extract Qt plugin path
    # qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    # system "/usr/libexec/PlistBuddy",
    #   "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
    #   "#{bin}/dolphin.app/Contents/Info.plist"
  end

  test do
    system "false"
  end
end
