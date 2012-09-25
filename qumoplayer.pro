# Add more folders to ship with the application, here
folder_01.source = \
qml/qumoplayer/image/qumoplayer-splash-portrait.png \
qml/qumoplayer/image/qumoplayer-splash-landscape.png

folder_01.target = image
DEPLOYMENTFOLDERS = folder_01

include(component/component.pri)

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE7F03DA0

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
CONFIG += qt-components
QT += opengl

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += src/main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/qumoplayer/image/subsonic.png \
    qml/qumoplayer/image/qumoplayer.png \
    qml/qumoplayer/image/qumoplayer-splash-portrait.png \
    qml/qumoplayer/image/qumoplayer-splash-landscape.png \
    qml/qumoplayer/image/pogoplug.png \
    qml/qumoplayer/common/js/subsonic.js \
    qml/qumoplayer/common/js/base64.js \
    qml/qumoplayer/harmattan/ServerSettingsPage.qml \
    qml/qumoplayer/harmattan/ServerListPage.qml \
    qml/qumoplayer/harmattan/SearchPage.qml \
    qml/qumoplayer/harmattan/PreferencesPage.qml \
    qml/qumoplayer/harmattan/PodcastsPage.qml \
    qml/qumoplayer/harmattan/PlaylistsPage.qml \
    qml/qumoplayer/harmattan/PlaylistPage.qml \
    qml/qumoplayer/harmattan/PlayerPage.qml \
    qml/qumoplayer/harmattan/MusicDirectoryPage.qml \
    qml/qumoplayer/harmattan/MainPage.qml \
    qml/qumoplayer/harmattan/MainMenuPage.qml \
    qml/qumoplayer/harmattan/main.qml \
    qml/qumoplayer/harmattan/LibraryPage.qml \
    qml/qumoplayer/harmattan/Components/ToolBarSpacer.qml \
    qml/qumoplayer/harmattan/Components/Settings.qml \
    qml/qumoplayer/harmattan/Components/Separator.qml \
    qml/qumoplayer/harmattan/Components/OperationArea.qml \
    qml/qumoplayer/harmattan/Components/Header.qml \
    qml/qumoplayer/harmattan/Components/AutoScrollText.qml \
    qml/qumoplayer/harmattan/Components/AbstractTwoLinesDelegate.qml \
    qml/qumoplayer/harmattan/Components/AbstractToolBarLayout.qml \
    qml/qumoplayer/harmattan/Components/AbstractTabPage.qml \
    qml/qumoplayer/harmattan/Components/AbstractTabLoadablePage.qml \
    qml/qumoplayer/harmattan/Components/AbstractSectionDelegate.qml \
    qml/qumoplayer/harmattan/Components/AbstractPage.qml \
    qml/qumoplayer/harmattan/Components/AbstractOneLineDelegate.qml \
    qml/qumoplayer/harmattan/Components/AbstractLoadablePage.qml \
    qml/qumoplayer/harmattan/Components/AbstractListView.qml \
    qml/qumoplayer/harmattan/Components/AbstractDelegate.qml \
    qml/qumoplayer/harmattan/AboutPage.qml \
    qml/qumoplayer/desktop/main.qml \
    qml/qumoplayer/common/ServerListModel.qml \
    qml/qumoplayer/common/SearchModel.qml \
    qml/qumoplayer/common/PodcastsModel.qml \
    qml/qumoplayer/common/PlaylistsModel.qml \
    qml/qumoplayer/common/PlaylistModel.qml \
    qml/qumoplayer/common/Ping.qml \
    qml/qumoplayer/common/MusicDirectoryModel.qml \
    qml/qumoplayer/common/LibraryModel.qml \
    qml/qumoplayer/common/CurrentPlaylistModel.qml \
    qml/qumoplayer/common/AbstractSubsonicListModel.qml \
    qml/qumoplayer/common/AbstractMusicDirectoryModel.qml \
    qml/qumoplayer/inneractive/AdItem.qml \
    qml/qumoplayer/inneractive/AdParameters.qml \
    qml/qumoplayer/inneractive/adFunctions.js \
    qml/qumoplayer/harmattan/Ad.qml \
    qml/qumoplayer/harmattan/Components/CurrentVersion.qml

RESOURCES += \
    common_resources.qrc

contains(MEEGO_EDITION,harmattan): {
RESOURCES += \
    harmattan_resources.qrc
}
