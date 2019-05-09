class Gwenview < Formula
  desc "Fast and easy to use image viewer"
  homepage "https://kde.org/applications/graphics/gwenview/"
  url "https://download.kde.org/stable/applications/19.04.0/src/gwenview-19.04.0.tar.xz"
  sha256 "c7d422bddf031fa9d5a23459c65ea6dbb5919e964cc194178a864ee98912b46d"

  head "git://anongit.kde.org/gwenview.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "freetype"
  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kactivities"
  depends_on "KDE-mac/kde/kf5-kitemmodels"
  depends_on "KDE-mac/kde/kf5-kparts"
  depends_on "KDE-mac/kde/libkdcraw"
  depends_on "KDE-mac/kde/phonon"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "little-cms2"

  patch :DATA

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"
    args << "-DGWENVIEW_SEMANTICINFO_BACKEND:STRING=None"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
    # Extract Qt plugin path
    qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/gwenview.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/gwenview"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/gwenview/icontheme.rcc"
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      "$(brew --repo kde-mac/kde)/tools/do_caveats.sh"
  EOS
  end

  test do
    assert `"#{bin}/gwenview.app/Contents/MacOS/gwenview" --help | grep -- --help` =~ /--help/
  end
end

# Fix build

__END__
diff --git a/app/MacOSXBundleInfo.plist.in b/app/MacOSXBundleInfo.plist.in
new file mode 100644
index 000000000..ab421eaf8
--- /dev/null
+++ b/app/MacOSXBundleInfo.plist.in
@@ -0,0 +1,55 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
+<plist version="1.0">
+<dict>
+        <key>NSPrincipalClass</key>
+        <string>NSApplication</string>
+        <key>NSHighResolutionCapable</key>
+        <string>True</string>
+        <key>CFBundleDevelopmentRegion</key>
+        <string>English</string>
+        <key>CFBundleExecutable</key>
+        <string>${MACOSX_BUNDLE_EXECUTABLE_NAME}</string>
+        <key>CFBundleGetInfoString</key>
+        <string>${MACOSX_BUNDLE_INFO_STRING}</string>
+        <key>CFBundleIconFile</key>
+        <string>${MACOSX_BUNDLE_ICON_FILE}</string>
+        <key>CFBundleIdentifier</key>
+        <string>${MACOSX_BUNDLE_GUI_IDENTIFIER}</string>
+        <key>CFBundleInfoDictionaryVersion</key>
+        <string>6.0</string>
+        <key>CFBundleLongVersionString</key>
+        <string>${MACOSX_BUNDLE_LONG_VERSION_STRING}</string>
+        <key>CFBundleName</key>
+        <string>${MACOSX_BUNDLE_BUNDLE_NAME}</string>
+        <key>CFBundlePackageType</key>
+        <string>APPL</string>
+        <key>CFBundleShortVersionString</key>
+        <string>${MACOSX_BUNDLE_SHORT_VERSION_STRING}</string>
+        <key>CFBundleSignature</key>
+        <string>????</string>
+        <key>CFBundleVersion</key>
+        <string>${MACOSX_BUNDLE_BUNDLE_VERSION}</string>
+        <key>CSResourcesFileMapped</key>
+        <true/>
+        <key>LSRequiresCarbon</key>
+        <true/>
+        <key>NSHumanReadableCopyright</key>
+        <string>${MACOSX_BUNDLE_COPYRIGHT}</string>
+        <key>LSMultipleInstancesProhibited</key>
+        <true/>
+        <key>CFBundleDocumentTypes</key>
+        <array>
+            <dict>
+                <key>CFBundleTypeExtensions</key>
+                <array>
+                        <string>*</string>
+                </array>
+                <key>CFBundleTypeName</key>
+                <string>NSStringPboardType</string>
+                <key>CFBundleTypeRole</key>
+                <string>Editor</string>
+            </dict>
+        </array>
+</dict>
+</plist>
