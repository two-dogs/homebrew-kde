class Kf5PortingaidsFrameworks < Formula
  desc "Metapackage for PortingAids KF5 frameworks"
  homepage "https://api.kde.org/frameworks"
  system "touch", "/tmp/empty"
  url "file:///tmp/empty"
  version "5.57.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  depends_on "KDE-mac/kde/kf5-kdelibs4support" => :build
  depends_on "KDE-mac/kde/kf5-khtml" => :build
  depends_on "KDE-mac/kde/kf5-kjs" => :build
  depends_on "KDE-mac/kde/kf5-kjsembed" => :build
  depends_on "KDE-mac/kde/kf5-kmediaplayer" => :build
  depends_on "KDE-mac/kde/kf5-kross" => :build
  depends_on "KDE-mac/kde/kf5-tier4-frameworks" => :build

  def install
    touch "empty"
    prefix.install "empty"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      find_package(KF5KDELibs4Support REQUIRED)
      find_package(KF5KDE4Support REQUIRED)
      find_package(KF5KHtml REQUIRED)
      find_package(KF5JS REQUIRED)
      find_package(KF5JsEmbed REQUIRED)
      find_package(KF5MediaPlayer REQUIRED)
      find_package(KF5Kross REQUIRED)
    EOS
    system "cmake", ".", "-Wno-dev"
  end
end
