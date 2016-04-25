import QtQuick 2.4
import Material 0.2
import com.evercloud.http 0.1

Page {
    actionBar.hidden: true

    View { // 背景卡片
        radius: 3
        width: 400
        height: 500
        elevation: 3
        backgroundColor: "white"
        anchors.centerIn: parent

        View { // 标题板
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

        TextField { // 用户名输入框
            id: username

            placeholderText: "用户名"
            floatingLabel: true
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            onTextChanged: {
                username.hasError = false
            }

            width: 300
            anchors {
                top: caption.bottom
                topMargin: 64
                horizontalCenter: parent.horizontalCenter
            }
        }

        TextField { // 密码输入框
            id: password

            placeholderText: "密码"
            floatingLabel: true
            echoMode: TextInput.Password
            font.family: "微软雅黑 Light"
            font.pixelSize: 24

            onTextChanged: {
                password.hasError = false
                password.helperText = ""
            }

            width: 300
            anchors {
                top: username.bottom
                topMargin: 32
                horizontalCenter: parent.horizontalCenter
            }
        }

        Row { // 开关栏
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

        ProgressCircle { // 登录过程中显示进度圈
            id: login_progress
            anchors.centerIn: login_button
            visible: false
        }

        Button { // 登录按钮
            id: login_button
            anchors {
                bottom: parent.bottom
                bottomMargin: 32
                horizontalCenter: parent.horizontalCenter
            }

            elevation: 1
            backgroundColor: Theme.accentColor

            enabled: input_is_valid()
            onClicked: {
                login_button.visible = false;
                login_progress.visible = true;
                request.url = "http://192.168.1.41:8893/login";
                request.jsonData = JSON.stringify({ 'username': username.text, 'password': password.text });
                request.sendJson();
            }

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

    Row { // 右下按钮栏
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

    Row { // 左下按钮栏
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

    Snackbar { // 通知栏
        id: prompt
    }

    Request {
        id: request
        onResponseChanged: {
            var code = request.code;
            var response = request.response;

            login_progress.visible = false;
            login_button.visible = true;

            if (code === 401) {
                username.hasError = true;
                password.hasError = true;
                password.helperText = "用户名或密码错误";
            } else if (code === 500) {
                prompt.open("服务暂时不可用")
            } else if (code === 200) {
                prompt.open("登录成功")
                // TODO: 处理成功登录
            } else {
                prompt.open("连接服务器失败")
            }
        }

    }
}
