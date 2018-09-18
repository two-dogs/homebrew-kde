class Kf5Libkgapi < Formula
  desc ""
  homepage ""
  url "https://download.kde.org/stable/applications/18.08.1/src/libkgapi-18.08.1.tar.xz"
  sha256 "f9b8ef27a5f264fb113b800213c19e568d414db0913ebbc319f5984f2c9a4e67"
  head "git://anongit.kde.org/libkgapi.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kcalcore"
  depends_on "qt"
  depends_on "kde-mac/kde/qt-webkit"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test libkgapi`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
