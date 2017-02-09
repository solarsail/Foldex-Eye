import QtQuick 2.4
import QtQuick.Controls 1.4 as QmlControls
import Material 0.2
import com.evercloud.http 0.1
import com.evercloud.conn 0.1
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

    Settingstore {
        id: settings
    }

    View {
        // 背景卡片
        radius: 3
        width: 490
        height: 403
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


            source: "image/logo-mono.png"
            sourceSize.width: 280
        }

        TextField {
            // 用户名输入框
            id: username

            placeholderText: "用户名"
            font.pixelSize: 14
            showBorder: false
            showBox: true
            boxColor: "#d6d6d6"

            onTextChanged: {
                username.hasError = false
                if (username.text === "") {
                    keep_username.checked = false
                }
            }

            width: 280
            height: 30
            anchors {
                top: logo.bottom
                topMargin: 50
                horizontalCenter: parent.horizontalCenter
            }

            onAccepted: {
                if(input_is_valid()){
                    login_button.clicked()
                }
            }

            function input_is_valid() {
                return username.text !== "" && password.text !== "" && (otp.text !== "" || otp.visible === false)
            }
        }

        TextField {
            // 密码输入框
            id: password

            placeholderText: "密码"
            echoMode: TextInput.Password
            font.pixelSize: 14
            showBorder: false
            showBox: true
            boxColor: "#d6d6d6"

            onTextChanged: {
                password.hasError = false
                password.helperText = ""
                if (password.text === "") {
                    keep_password.checked = false
                }
            }

            width: 280
            height: 30
            anchors {
                top: username.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            onAccepted: {
                if(input_is_valid()){
                    login_button.clicked()
                }
            }

            function input_is_valid() {
                return username.text !== "" && password.text !== "" && (otp.text !== "" || otp.visible === false)
            }
        }

        TextField {
            // 二次验证码输入框
            id: otp

            placeholderText: "验证码"
            echoMode: TextInput.Password
            font.pixelSize: 14
            showBorder: false
            showBox: true
            boxColor: "#d6d6d6"

            onTextChanged: {
                otp.hasError = false
                otp.helperText = ""
            }

            width: 280
            height: 30
            anchors {
                top: password.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            visible: false // 之后由 otp_enable 决定

            onAccepted: {
                if(input_is_valid()) {
                    login_button.clicked()
                }
            }

            function input_is_valid() {
                return username.text !== "" && password.text !== "" && (otp.text !== "" || otp.visible === false)
            }
        }

        CheckBox {
            id: keep_username
            anchors {
                top: otp.bottom
                topMargin: -6
                left: otp.left
                leftMargin: -15
            }
            text: "记住用户名"
            textSize: 10
            enabled: username.text !== ""
            onCheckedChanged: function () {
                if (keep_username.checked == false) {
                    keep_password.checked = false
                }
            }
        }

        CheckBox {
            id: keep_password
            anchors {
                top: otp.bottom
                topMargin: -6
                right: otp.right
            }
            text: "记住密码"
            textSize: 10
            enabled: password.text !== "" && keep_username.checked
            checked: true
        }

        Component.onCompleted: {
            if (settings.user !== '') {
                username.text = settings.user
                keep_username.checked = true
            } else {
                keep_username.checked = false
            }

            if (settings.passwd !== '') {
                password.text = settings.passwd
                keep_password.checked = true
            } else {
                keep_password.checked = false
            }

            otp_enable.sendJson()
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
                top: keep_username.bottom
                topMargin: -1
                horizontalCenter: parent.horizontalCenter
            }

            width: 280
            height: 32

            text: "登录"
            elevation: 1
            backgroundColor: Theme.accentColor

            enabled: input_is_valid()
            onClicked: {
                login_button.visible = false
                login_progress.visible = true
                if(Globalvar.serverip == "") {
                    Globalvar.serverip = settings.server
                    Globalvar.otpserverip = settings.otpserver
                }
                request.url = "http://" + Globalvar.serverip + ":8893/v1/login"
                request.jsonData = JSON.stringify({
                                                      username: username.text,
                                                      password: password.text
                                                  })
                request.sendJson()
            }

            function input_is_valid() {
                return username.text !== "" && password.text !== "" && (otp.text !== "" || otp.visible === false)
            }

//            function auth_done(type) {
//                var auth_pass = false;
//                var auth_otp = false;
//                if (type === "password") {
//                    auth_pass = true;
//                } else if (type === "otp") {
//                    auth_otp = true;
//                }
//                if (auth_pass && auth_otp) {
//                    pageStack.push(Qt.resolvedUrl("DesktopPage.qml"))
//                }
//            }
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
            //保存当前用户名或密码逻辑
            if ((keep_username.checked == true)
                    && (keep_password.checked == false)) {
                settings.storeUser(username.text, '')
            } else if ((keep_username.checked == true)
                       && (keep_password.checked == true)
                       && (username.text !== '')) {
                settings.storeUser(username.text, password.text)
            } else if (keep_username.checked == false) {
                settings.storeUser('', '')
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

    Request {
        id: request
        onResponseChanged: {
            var code = request.code
            var response = request.response

            login_progress.visible = false
            login_button.visible = true

            if (code === 401) {
                username.hasError = true
                password.hasError = true
                //password.helperText = "用户名或密码错误";
                prompt.open("用户名或密码错误")
            } else if (code === 500) {
                prompt.open("服务暂时不可用")
            } else if (code === 200) {
                UserConnection.username = username.text
                UserConnection.password = password.text
                UserConnection.info = response
                if (!keep_username.checked) {
                    username.text = ""
                }
                if (!keep_password.checked) {
                    password.text = ""
                }

                if (otp.visible) {
                    otp_auth.url = "http://" + Globalvar.otpserverip + ":8080/am/webauth/1/strong/authenticate?"
                        + "tenantName=test&accessServerName=dev1&sharedSecret=123456"
                        + "&loginName=" + username.text + "&password=" + password.text + otp.text
                    otp_auth.get()
                } else {
                    pageStack.push(Qt.resolvedUrl("DesktopPage.qml"))
                }

            } else {
                prompt.open("连接服务器失败")
            }
        }
    }

    Request {
        id: otp_enable
        url: "http://" + settings.server + ":8893/v1/settings"
        jsonData: JSON.stringify({ query: "otp" })
        onResponseChanged: {
            var code = otp_enable.code
            var res = otp_enable.response
            if (code === 200) {
                var info = JSON.parse(res)
                otp.visible = (info["otp"] === "true" || info["otp"] === "True")
            }
        }
    }

    Request {
        id: otp_auth
        onResponseChanged: {
            var code = otp_auth.code
            var res = otp_auth.response
            // TODO
            if (code === 200) {
                var info = JSON.parse(res)
                if (info["success"])
                    pageStack.push(Qt.resolvedUrl("DesktopPage.qml"))
                else {
                    otp.hasError = true
                    prompt.open("动态口令错误")
                }
            } else {
                prompt.open("连接 OTP 服务器失败")
            }
        }
    }

    SystemPower {
        id: sys
    }
}
