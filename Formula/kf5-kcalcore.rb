class Kf5Kcalcore < Formula
  desc "KDE calendar access library"
  homepage "https://community.kde.org/KDE_PIM"
  url "https://download.kde.org/stable/applications/18.08.1/src/kcalcore-18.08.1.tar.xz"
  sha256 "563239f2bfc7c4727add80f621781917a1f280c545c4e19d8e98a68a6b14c94d"
  head "git://anongit.kde.org/kcalcore.git"
  
  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    system "false"
  end
end
