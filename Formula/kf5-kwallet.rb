class Kf5Kwallet < Formula
  desc "Secure and unified container for user passwords"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.57/kwallet-5.57.0.tar.xz"
  sha256 "ad089026f4d5b10d567d0fd56f8b63749acd214fb8029d43187ba42afaf36975"

  head "git://anongit.kde.org/kwallet.git"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "gpgme"
  depends_on "KDE-mac/kde/kf5-kiconthemes"
  depends_on "KDE-mac/kde/kf5-knotifications"
  depends_on "KDE-mac/kde/kf5-kservice"
  depends_on "libgcrypt"

  patch :DATA

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
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

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      "$(brew --repo kde-mac/kde)/tools/do_caveats.sh"
  EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Wallet REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executables as nongui type

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6f1d918..0dbc257 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -22,6 +22,7 @@ include(KDECMakeSettings)
 include(ECMAddQch)
 include(ECMSetupVersion)
 include(ECMQtDeclareLoggingCategory)
+include(ECMMarkNonGuiExecutable)
 
 option(BUILD_KWALLETD "Build the kwallet daemon" ON)
 option(BUILD_KWALLET_QUERY "Build kwallet-query tool" ON)
diff --git a/src/runtime/kwallet-query/src/CMakeLists.txt b/src/runtime/kwallet-query/src/CMakeLists.txt
index 9aa167b..9a98eb4 100644
--- a/src/runtime/kwallet-query/src/CMakeLists.txt
+++ b/src/runtime/kwallet-query/src/CMakeLists.txt
@@ -12,4 +12,5 @@ TARGET_LINK_LIBRARIES(kwallet-query
     Qt5::Widgets
 )
 
+ecm_mark_nongui_executable(kwallet-query)
 install( TARGETS kwallet-query DESTINATION ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
diff --git a/src/runtime/kwalletd/CMakeLists.txt b/src/runtime/kwalletd/CMakeLists.txt
index 918ba5d..7ee4462 100644
--- a/src/runtime/kwalletd/CMakeLists.txt
+++ b/src/runtime/kwalletd/CMakeLists.txt
@@ -119,6 +119,7 @@ if (Gpgmepp_FOUND)
     kde_target_enable_exceptions(kwalletd5 PRIVATE)
 endif(Gpgmepp_FOUND)
 
+ecm_mark_nongui_executable(kwalletd5)
 install(TARGETS kwalletd5  ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
 
 ########### install files ###############
