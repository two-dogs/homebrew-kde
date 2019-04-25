class Libkdcraw < Formula
  desc "C++ interface used to decode RAW picture"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/applications/19.04.0/src/libkdcraw-19.04.0.tar.xz"
  sha256 "30df02047c0f1b97a7c90c8eb5f7a3c5d322f13e0158395d3f9798ff21ed529e"

  head "git://anongit.kde.org/kdcraw.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "ninja" => :build

  depends_on "libraw"
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end
  
  test do
    (testpath/"CMakeLists.txt").write("find_package(KDcraw REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
