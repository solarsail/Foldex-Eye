import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem

Page {
    id: settingpage
    title: "设置"

    Button {
        anchors.centerIn: parent
        text: "返回登录"
        onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
    }

    rightSidebar: PageSidebar {
        title: "选项"

        width: Units.dp(320)

    }
}

