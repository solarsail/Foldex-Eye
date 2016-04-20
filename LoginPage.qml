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
            backgroundColor: Theme.primaryColor
            elevation: 1

            Icon {
                id: caption_icon
                name: "action/account_circle"
                color: "white"
                size: 48

                anchors {
                    bottom: parent.bottom
                    bottomMargin: 32
                    left: parent.left
                    leftMargin: 50
                }
            }

            Text {
                text: "登录"

                color: "white"
                font.family: "微软雅黑 Light"
                font.pixelSize: 48

                anchors {
                    bottom: parent.bottom
                    bottomMargin: 28
                    left: caption_icon.right
                    leftMargin: 16
                }
            }
        }

        TextField {
            id: username

            placeholderText: "用户名"
            floatingLabel: true
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            width: 300
            anchors {
                top: caption.bottom
                topMargin: 64
                horizontalCenter: parent.horizontalCenter
            }
        }

        TextField {
            id: password

            placeholderText: "密码"
            floatingLabel: true
            echoMode: TextInput.Password
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            width: 300
            anchors {
                top: username.bottom
                topMargin: 32
                horizontalCenter: parent.horizontalCenter
            }
        }

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: password.bottom
                topMargin: 32
            }

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

        Button {
            anchors {
                bottom: parent.bottom
                bottomMargin: 32
                horizontalCenter: parent.horizontalCenter
            }

            elevation: 1
            backgroundColor: Theme.accentColor

            enabled: input_is_valid()
            onClicked: console.log("done!")

            function input_is_valid() {
                return username.text !== "" && password.text !== "";
            }

            Icon {
                name: "action/done"
                size: 32
                color: "white"

                anchors.centerIn: parent
            }
        }
    }

    Row {
        anchors {
            bottom: parent.bottom
            bottomMargin: 32
            right: parent.right
            rightMargin: 32
        }

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
        anchors {
            bottom: parent.bottom
            bottomMargin: 32
            left: parent.left
            leftMargin: 32
        }

        spacing: 32

        IconButton {
            iconName: "action/settings"
            size: 32
            hoverAnimation: true
            color: Theme.light.iconColor
        }
    }
}
