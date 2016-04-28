import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem

Page {
    id: settingpage
    title: "设置"

    backAction: Action {
        text: "返回"
        iconName: "navigation/arrow_back"
        onTriggered: settingpage.pop()
        visible: canGoBack
    }

    rightSidebar: PageSidebar {
        title: "选项"

        width: Units.dp(320)

    }
}

