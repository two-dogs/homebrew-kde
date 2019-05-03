class Kf5Kjsembed < Formula
  desc "Embedded JS"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.57/portingAids/kjsembed-5.57.0.tar.xz"
  sha256 "741aae8db274febe7e5d0d10dc99271efc590b2465d2c4d4e4a9162d2b36e3b4"

  head "git://anongit.kde.org/kjsembed.git"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-ki18n"
  depends_on "KDE-mac/kde/kf5-kjs"

  patch :DATA

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5JsEmbed REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executable as nongui type

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8939ba5..1ab9bdc 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,6 +21,7 @@ include(GenerateExportHeader)
 include(CMakePackageConfigHelpers)
 include(ECMSetupVersion)
 include(ECMGenerateHeaders)
+include(ECMMarkNonGuiExecutable)
 
 ecm_setup_version(PROJECT VARIABLE_PREFIX KJSEMBED
    #VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kjsembed_version.h"
diff --git a/src/kjscmd/CMakeLists.txt b/src/kjscmd/CMakeLists.txt
index 95f7c31..16b102f 100644
--- a/src/kjscmd/CMakeLists.txt
+++ b/src/kjscmd/CMakeLists.txt
@@ -10,4 +10,5 @@ target_link_libraries(kjscmd5
     KF5::JsEmbed
 )
 
+ecm_mark_nongui_executable(kjscmd5)
 install(TARGETS kjscmd5 ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
