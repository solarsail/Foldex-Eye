import QtQuick 2.4
import Material 0.2
import QtQuick.Controls 1.3 as Controls
import QtQuick.Layouts 1.1
import Material.ListItems 0.1 as ListItem

Item {
    Settingstore {
        id: serversetting
    }
    View {
        anchors.centerIn: parent

        width: Units.dp(350)
        height: column.implicitHeight + Units.dp(32)

        elevation: 1
        radius: Units.dp(2)

        ColumnLayout {
            id: column

            anchors {
                fill: parent
                topMargin: Units.dp(16)
                bottomMargin: Units.dp(16)
            }

            spacing: Units.dp(16)

            Label {
                id: titleLabel

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Units.dp(16)
                }

                style: "title"
                text: "本机 IP 设置"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            CheckBox {
                id: ipcheck
                checked: serversetting.ip == "" ? true : false
                text: "IP DHCP 自动设置"
                darkBackground: false
                onCheckedChanged: {
                    if (ipcheck.checked == false) {
                        ipfield.enabled = true
                        submaskfield.enabled = true
                        gatewayfield.enabled = true
                        dnscheck.checked = false
                    } else {
                        ipfield.enabled = false
                        submaskfield.enabled = false
                        gatewayfield.enabled = false
                    }
                }
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 16
                Label {
                    text: "IP 地址   ："
                }
                TextField {
                    id: ipfield
                    enabled: false
                    text: serversetting.ip
                    floatingLabel: true
                    characterLimit: 15
                    validator: RegExpValidator {
                        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
                    }
                }
            }
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 16
                Label {
                    text: "子网掩码："
                }
                TextField {
                    id: submaskfield
                    enabled: false
                    text: serversetting.mask
                    floatingLabel: true
                    characterLimit: 15
                    validator: RegExpValidator {
                        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
                    }
                }
            }
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 16
                Label {
                    text: "默认网关："
                }
                TextField {
                    id: gatewayfield
                    enabled: false
                    text: serversetting.gateway
                    floatingLabel: true
                    characterLimit: 15
                    validator: RegExpValidator {
                        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
                    }
                }
            }

            CheckBox {
                id: dnscheck
                checked: serversetting.mainDNS == "" ? true : false
                enabled: ipcheck.checked
                text: "DNS DHCP 自动设置"
                darkBackground: false
                onCheckedChanged: {
                    if (dnscheck.checked == true) {
                        firstdns.enabled = false
                        seconddns.enabled = false
                    } else {
                        firstdns.enabled = true
                        seconddns.enabled = true
                    }
                }
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 16
                Label {
                    text: "首选 DNS 地址："
                }
                TextField {
                    id: firstdns
                    enabled: false
                    text: serversetting.mainDNS
                    floatingLabel: true
                    characterLimit: 15
                    validator: RegExpValidator {
                        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
                    }
                }
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 16
                Label {
                    text: "备用 DNS 地址："
                }
                TextField {
                    id: seconddns
                    enabled: false
                    text: serversetting.secondDNS
                    floatingLabel: true
                    characterLimit: 15
                    validator: RegExpValidator {
                        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Units.dp(8)

                anchors {
                    right: parent.right
                    margins: Units.dp(16)
                }

                Button {
                    text: "确定"
                    textColor: Theme.primaryColor

                    function saveIP() {
                        if ((ipfield.text == "") || (submaskfield.text == "")
                                || (gatewayfield.text == "")) {
                            snackbar.open("请输入正确的IP地址、子网掩码和默认网关")
                            return false
                        } else {
                            serversetting.storeIP(ipfield.text,
                                                  submaskfield.text,
                                                  gatewayfield.text)
                            return true
                        }
                    }

                    function saveDNS() {
                        if ((firstdns.text == "") || (seconddns.text == "")) {
                            snackbar.open("请输入正确的DNS服务器地址")
                            return false
                        } else {
                            serversetting.storeDNS(firstdns.text,
                                                   seconddns.text)
                            return true
                        }
                    }

                    onClicked: {
                        if ((ipcheck.checked == true)
                                && (dnscheck.checked == true)) {
                            //TODO: DHCP settings
                            serversetting.storeIP("", "", "")
                            serversetting.storeDNS("", "")
                            snackbar.open("保存成功")
                        } else if ((ipcheck.checked == true)
                                   && (dnscheck.checked == false)) {
                            serversetting.storeIP("", "", "")
                            if (saveDNS() === true) {
                                snackbar.open("DNS配置保存成功")
                            }
                        } else if ((ipcheck.checked == false)
                                   && (dnscheck.checked == false)) {
                            if ((saveDNS() === true) && saveIP() === true) {
                                snackbar.open("手动配置保存成功")
                            }
                        }
                    }
                }
            }
        }
    }

    Snackbar {
        id: snackbar
    }
}
