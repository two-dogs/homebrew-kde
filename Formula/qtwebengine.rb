class Qtwebengine < Formula
  desc "Provides functionality for rendering regions of dynamic web content."
  homepage "https://doc.qt.io/qt-5/qtwebengine-index.html"
  url "https://download.qt.io/official_releases/qt/5.11/5.11.1/submodules/qtwebengine-everywhere-src-5.11.1.tar.xz"
  sha256 "389d9f42ca393ac11ec8932ce9771766dec91a4c761ffb685cc429c2a760d48c"
  head "https://code.qt.io/qt/qtwebengine.git", :branch => "5.12"
  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "pkg-config"
  depends_on "ninja" => :build

  def install
    system "qmake", "-r", "PREFIX=#{prefix}"
    system "ninja", "install"
  end

  test do
    system "false"
  end
end
