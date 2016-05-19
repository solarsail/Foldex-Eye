import QtQuick 2.4
import Material 0.2
import QtQuick.Controls 1.3 as Controls
import QtQuick.Layouts 1.1
import Material.ListItems 0.1 as ListItem
import com.evercloud.sys 0.1

Item {
    Settingstore {
        id: serversetting
    }
    RegExpValidator {
        id: ipvalidator
        regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
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
                    validator: ipvalidator
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
                    validator: ipvalidator
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
                    validator: ipvalidator
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
                    validator: ipvalidator
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
                    validator: ipvalidator
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
                        if (!checkipvalidate()) {
                            return false
                        }
                        if ((ipfield.text == "") || (submaskfield.text == "")
                                || (gatewayfield.text == "")) {
                            snackbar.open("请输入正确的 IP 地址、子网掩码和默认网关")
                            return false
                        } else {
                            var err = ipsettings.setStaticIp(ipfield.text, submaskfield.text, gatewayfield.text);
                            if (!err) {
                                serversetting.storeIP(ipfield.text,
                                                      submaskfield.text,
                                                      gatewayfield.text)
                                return true;
                            } else {
                                snackbar.open("设置静态 IP 失败：" + err);
                                return false;
                            }
                        }
                    }

                    function saveDNS() {
                        if (!checkdnsvalidate()) {
                            return false
                        }
                        if ((firstdns.text == "")) {
                            snackbar.open("请输入正确的 DNS 服务器地址")
                            return false
                        } else {
                            var err = ipsettings.setStaticDns(firstdns.text, seconddns.text);
                            if (!err) {
                                serversetting.storeDNS(firstdns.text,
                                                       seconddns.text);
                                return true;
                            } else {
                                snackbar.open("设置静态 DNS 失败：" + err);
                                return false;
                            }
                        }
                    }

                    function validateIPaddress(ipaddress) {
                        if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(
                                    ipaddress)) {
                            return (true)
                        }
                        return (false)
                    }

                    function checkipvalidate() {
                        if ((ipfield.text !== "") && (!validateIPaddress(
                                                          ipfield.text))) {
                            snackbar.open("IP 地址输入错误，请重新输入")
                            return false
                        }
                        if ((submaskfield.text !== "")
                                && (!validateIPaddress(submaskfield.text))) {
                            snackbar.open("子网掩码输入错误，请重新输入")
                            return false
                        }
                        if ((gatewayfield.text !== "")
                                && (!validateIPaddress(gatewayfield.text))) {
                            snackbar.open("默认网关输入错误，请重新输入")
                            return false
                        }
                        return true
                    }

                    function checkdnsvalidate() {
                        if ((firstdns.text !== "") && (!validateIPaddress(
                                                           firstdns.text))) {
                            snackbar.open("首选 DNS 服务器地址输入错误，请重新输入")
                            return false
                        }
                        if ((seconddns.text !== "") && (!validateIPaddress(
                                                            seconddns.text))) {
                            snackbar.open("备用 DNS 服务器地址输入错误，请重新输入")
                            return false
                        }
                        return true
                    }

                    onClicked: {
                        var err = -1;

                        if ((ipcheck.checked == true)
                                && (dnscheck.checked == true)) {
                            err = ipsettings.setAutoIp();
                            if (!err) {
                                serversetting.storeIP("", "", "");
                            } else {
                                snackbar.open("自动获取 IP 失败：" + err);
                                return;
                            }

                            err = ipsettings.setAutoDns();
                            if (!err) {
                                serversetting.storeDNS("", "")
                            } else {
                                snackbar.open("自动获取 DNS 失败：" + err);
                                return;
                            }

                            snackbar.open("保存成功");

                        } else if ((ipcheck.checked == true)
                                   && (dnscheck.checked == false)) {
                            err = ipsettings.setAutoIp();
                            if (!err) {
                                serversetting.storeIP("", "", "");
                            } else {
                                snackbar.open("自动获取 IP 失败：" + err);
                                return;
                            }
                            if (saveDNS() === true) {
                                snackbar.open("DNS 配置保存成功")
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

    IPSettings {
        id: ipsettings
        adapter: "vEthernet (wlan-vswitch)"
    }
}
