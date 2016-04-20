import QtQuick 2.4
import Material 0.2

Page {
    actionBar.hidden: true

    View {
        radius: 3
        width: 400
        height: 500
        elevation: 3
        backgroundColor: "white"
        anchors.centerIn: parent

        View {
            id: caption

            width: parent.width
            height: 150
            radius: 3
            backgroundColor: Palette.colors["blue"]["500"]
            elevation: 1

            Icon {
                id: caption_icon
                name: "action/account_circle"
                color: "white"
                size: 48
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 32
                anchors.left: parent.left
                anchors.leftMargin: 50
            }

            Text {
                text: "登录"

                color: "white"
                font.family: "微软雅黑 Light"
                font.pixelSize: 48

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 28
                anchors.left: caption_icon.right
                anchors.leftMargin: 16
            }
        }

        TextField {
            id: username

            placeholderText: "用户名"
            floatingLabel: true
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            width: 300
            anchors.top: caption.bottom
            anchors.topMargin: 64
            anchors.horizontalCenter: parent.horizontalCenter


        }

        TextField {
            id: password

            placeholderText: "密码"
            floatingLabel: true
            echoMode: TextInput.Password
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            width: 300
            anchors.top: username.bottom
            anchors.topMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: password.bottom
            anchors.topMargin: 32
            spacing: 16

            Switch {
                id: keep_username
                checked: false
            }

            Label {
                text: "记住用户名"
                font.family: "微软雅黑 Light"
                anchors.verticalCenter: keep_username.verticalCenter
            }

            Rectangle {
                color: "white"
                width: 1
                height: 24
                anchors.verticalCenter: parent.verticalCenter
            }

            Switch {
                id: keep_password
                checked: false
            }

            Label {
                text: "记住密码"
                font.family: "微软雅黑 Light"
                anchors.verticalCenter: keep_password.verticalCenter
            }
        }

        IconButton {
            iconName: "action/done"
            size: 48
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.right: parent.right
        anchors.rightMargin: 32
        spacing: 32

        IconButton {
            iconName: "navigation/refresh"
            size: 32
            color: Theme.light.iconColor
        }

        IconButton {
            iconName: "action/power_settings_new"
            size: 32
            color: Theme.light.iconColor
            onClicked: {
                Qt.quit();
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.left: parent.left
        anchors.leftMargin: 32
        spacing: 32

        IconButton {
            iconName: "action/settings"
            size: 32
            hoverAnimation: true
            color: Theme.light.iconColor
        }
    }
}
