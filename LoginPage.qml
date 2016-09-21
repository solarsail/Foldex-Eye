import QtQuick 2.4
import QtQuick.Controls 1.4 as QmlControls
import Material 0.2
import com.evercloud.viewer 0.1
import com.evercloud.sys 0.1
import "./settingPage"
import "./settingPage/globalvar.js" as Globalvar

Page {
    actionBar.hidden: true

    Image {
        fillMode: Image.PreserveAspectCrop
        source: "image/bg_1366x768.png"
        anchors.fill: parent
    }

    Image {
        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 24
        }

        source: "image/logo.png"
        sourceSize.width: 197
        sourceSize.height: 39
    }

    Settingstore {
        id: settings
    }

    View {
        // 背景卡片
        radius: 3
        width: 490
        height: 363
        elevation: 3
        backgroundColor: "white"
        anchors.centerIn: parent

        Image {
            id: logo
            anchors {
                top: parent.top
                topMargin: 45
                horizontalCenter: parent.horizontalCenter
            }

            source: "image/logo.png"
            sourceSize.width: 197
            sourceSize.height: 39
        }

        TextField {
            // 连接 Uri 输入框
            id: conn_uri

            placeholderText: "连接 Uri"
            font.pixelSize: 14
            showBorder: false
            showBox: true
            boxColor: "#d6d6d6"

            width: 280
            height: 30
            anchors {
                top: logo.bottom
                topMargin: 95
                horizontalCenter: parent.horizontalCenter
            }

            onAccepted: {
                if(input_is_valid()){
                    login_button.clicked()
                }
            }

            function input_is_valid() {
                return conn_uri.text !== ""
            }
        }

        CheckBox {
            id: keep_uri
            anchors {
                top: conn_uri.bottom
                topMargin: -6
                left: conn_uri.left
                leftMargin: -15
            }
            text: "记住连接字符串"
            textSize: 10
            enabled: conn_uri.text !== ""
        }


        Component.onCompleted: {
            if (settings.user !== '') {
                conn_uri.text = settings.uri
                keep_uri.checked = true
            } else {
                keep_uri.checked = false
            }

        }

        ProgressCircle {
            // 登录过程中显示进度圈
            id: login_progress
            anchors.centerIn: login_button
            visible: false
        }

        Button {
            // 登录按钮
            id: login_button
            anchors {
                top: keep_uri.bottom
                topMargin: -1
                horizontalCenter: parent.horizontalCenter
            }

            width: 280
            height: 32

            text: "连接"
            elevation: 1
            backgroundColor: Theme.accentColor

            enabled: input_is_valid()
            onClicked: {
                login_button.visible = false
                login_progress.visible = true
                viewer.uri = conn_uri.text
                viewer.start()
            }

            function input_is_valid() {
                return conn_uri.text !== ""
            }
        }
    }

    Dialog {
        id: shutDownDialog
        property string powerAction: "shutdown"
        width: Units.dp(300)
        text: "确定要关机吗？"
        hasActions: true
        positiveButtonText: "确定"
        negativeButtonText: "取消"

        onAccepted: {
            // 保存当前连接 Uri
            if (keep_uri.checked == true) {
                settings.storeUri(conn_uri.text, '')
            }

            if (powerAction === "shutdown") {
                sys.shutdown()
            } else if (powerAction === "reboot") {
                sys.reboot()
            } else {
                console.log("unknown power action")
            }
        }
    }

    Row {
        // 右上按钮栏
        anchors {
            top: parent.top
            topMargin: 24
            right: parent.right
            rightMargin: 24
        }

        spacing: 18

        Action {
            id: rebootAction
            iconName: "navigation/refresh"
            text: "重启"
        }

        Action {
            id: shutDownAction
            iconName: "action/power_settings_new"
            text: "关机"
        }

        Action {
            id: settingAction
            iconName: "action/settings"
            text: "系统设置"
        }

        IconButton {
            action: settingAction
            size: 24
            hoverAnimation: true
            color: Theme.dark.iconColor
            onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
        }

        IconButton {
            action: rebootAction
            size: 24
            hoverAnimation: true
            color: Theme.dark.iconColor
            onClicked: {
                shutDownDialog.powerAction = "reboot"
                shutDownDialog.text = "确定要重启吗？"
                shutDownDialog.show()
            }
        }

        IconButton {
            action: shutDownAction
            size: 24
            color: Theme.dark.iconColor
            hoverAnimation: true
            onClicked: {
                shutDownDialog.powerAction = "shutdown"
                shutDownDialog.text = "确定要关机吗？"
                shutDownDialog.show()
            }
        }
    }

    Snackbar {
        // 通知栏
        id: prompt
    }

    RemoteViewer {
        id: viewer
        onFinished: {
            if (exitCode !== 0) {
                prompt.open("连接错误：" + exitCode)
            }
            login_progress.visible = false;
            login_button.visible = true;
        }
        onErrorOccurred: {
            prompt.open("连接错误：" + "(" + error + ") " + viewer.errorDescription())
            login_progress.visible = false;
            login_button.visible = true;
        }
    }

    SystemPower {
        id: sys
    }
}
