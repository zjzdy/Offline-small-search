import QtQuick 2.8
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.11

ApplicationWindow {
    id: app
    visible: true
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight
    x: initialX
    y: initialY
    width: initialWidth
    height: initialHeight
    title: qsTr("离线小搜")
    property real pd: Math.max(6,Screen.pixelDensity)
    onWidthChanged: if(splash.visible) splash.source = choose_splash()
    onHeightChanged: if(splash.visible) splash.source = choose_splash()
    //onFocusObjectChanged: console.log(activeFocusItem)

    MessageDialog {
        id: exit_messageDialog
        title: qsTr("退出")
        text: qsTr("您真的要退出吗?")
        standardButtons: StandardButton.No | StandardButton.Yes
        onYes: main_widget.close_app()
    }

    MessageDialog {
        id: update_messageDialog
        objectName: "update_dialog"
        title: qsTr("检查更新")
        standardButtons: (text == qsTr("已是最新版本")) ? StandardButton.Ok : (StandardButton.No | StandardButton.Yes)
        onYes: {
            main_widget.openUrl("http://github.com/zjzdy/Offline-small-search/releases")
        }
    }

    MessageDialog {
        id: pluginInstallFinsh_messageDialog
        objectName: "pluginInstallFinsh_messageDialog"
        title: qsTr("插件安装完成")
        property string pluginName: ""
        text: qsTr("插件:")+pluginName+qsTr("安装完成,请重启离线小搜.")
        standardButtons: StandardButton.Ok
    }

    function choose_splash() {
        if(app.width*1.3 < app.height)
            return "qrc:/image/splash.png";
        if(app.width > app.height*1.3)
            return "qrc:/image/splash2.png";
        return "qrc:/image/splash3.png";
    }

    Image {
        id: splash
        objectName: "splash"
        source: choose_splash()
        z: 2
        anchors.fill: parent
    }

    TabView {
        id: tabview
        anchors.fill: parent
        objectName: "tabView"
        currentIndex: 0
        focus: true
        Keys.enabled: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
                if(tabview.currentIndex == 0)
                    exit_messageDialog.visible = true;
                else main_widget.show_back()
                if(tabview.currentIndex == 1) {
                    main_widget.offline_pkg_list_to_data_file()
                    main_widget.init_search_from_offline_pkg_list()
                }
                if(tabview.currentIndex == 2)
                    custom1.write_custom()
                event.accepted = true;
            }
        }

        Tab {
            title: "SwipeMain"
            SwipeMain {
                a_pd: app.pd
                id: swipeview
            }
        }
        Tab {
            title: "Pkg"
            Pkg {
                a_pd: app.pd
                id: pkg
            }
        }
        Tab {
            title: "Custom"
            Custom {
                a_pd: app.pd
                id: cstom
            }
        }
        Tab {
            title: "About"
            About {
                a_pd: app.pd
                id:about
            }
        }
        Tab {
            title: "Search"
            Search {
                a_pd: app.pd
                id: search
            }
        }
        Tab {
            title: "Search_result"
            SearchResult {
                a_pd: app.pd
                id: searchResult
            }
        }
        Tab {
            id: result_tab
            title: "Result"
            Result {
                a_pd: app.pd
                id: result
            }
        }
        Tab {
            title: "Mark"
            Mark {
                a_pd: app.pd
                id:mark
            }
        }
        Tab {
            title: "Crop"
            Crop {
                a_pd: app.pd
                id: crop
            }
        }
        Tab {
            title: "Online_download"
            OnlineDownload {
                a_pd: app.pd
                id: onlineDownload
            }
        }
        Tab {
            title: "Camera"
            Camera {
                a_pd: app.pd
                id: camera
            }
        }
        Tab {
            title: "PluginPages"
            PluginPages {
                a_pd: app.pd
                id: pluginPages
            }
        }

        frameVisible: false
        tabsVisible: false
    }
}
