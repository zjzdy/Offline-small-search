import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

ApplicationWindow {
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("离线小搜")

    MessageDialog {
        id: exit_messageDialog
        title: qsTr("退出")
        text: qsTr("您真的要退出吗?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes:Qt.quit()// main_widget.close_app()
    }

    TabView {
        id: tabview
        anchors.fill: parent
        objectName: "tabView"
        currentIndex: 0
        focus: true
        Keys.enabled: true
        Keys.onBackPressed: {
            console.log(currentIndex)
            if(tabview.currentIndex < 4)
                exit_messageDialog.visible = true;
            else main_widget.show_back()
            if(tabview.currentIndex == 4) {
                main_widget.offline_pkg_list_to_data_file()
                main_widget.init_search_from_offline_pkg_list()
            }
            if(tabview.currentIndex == 5)
                custom1.write_custom()
        }
        Keys.onEscapePressed: {
            if(tabview.currentIndex < 4)
                exit_messageDialog.visible = true;
            else main_widget.show_back()
            if(tabview.currentIndex == 4) {
                main_widget.offline_pkg_list_to_data_file()
                main_widget.init_search_from_offline_pkg_list()
            }
            if(tabview.currentIndex == 5)
                custom1.write_custom()
        }

        Tab {
            title: "Main"
            Main {
                id: main
            }
        }
        Tab {
            title: "More"
            More {
                id: more
            }
        }
        Tab {
            title: "More_search"
            MoreSearch {
                id: moreSearch
            }
        }
        Tab {
            title: "History"
            History {
                id: history
            }
        }
        Tab {
            title: "Pkg"
            Pkg {
                id: pkg
            }
        }
        Tab {
            title: "Custom"
            Custom {
                id: cstom
            }
        }
        Tab {
            title: "About"
            About {
                id:about
            }
        }
        Tab {
            title: "Search"
            Search {
                id: search
            }
        }
        Tab {
            title: "Search_result"
            SearchResult {
                id: searchResult
            }
        }
        Tab {
            id: result_tab
            title: "Result"
            Result {
                id: result
            }
        }
        Tab {
            title: "Mark"
            Mark {
                id:mark
            }
        }
        Tab {
            title: "Crop"
            Crop {
                id: crop
            }
        }
        Tab {
            title: "Online_download"
            OnlineDownload {
                id: onlineDownload
            }
        }
        frameVisible: false
        tabsVisible: false
    }
}
