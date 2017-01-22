import QtQuick 2.4
import Material 0.2
import QtQuick.Layouts 1.1
import com.evercloud.sys 0.1

Item {
    DevId {
        id: devid
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
                id: title
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Units.dp(16)
                }

                style: "title"
                text: "设备信息"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Units.dp(8)
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Units.dp(24)
                }
                Label {
                    text: "设备 ID：" + devid.devId()
                }
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Units.dp(24)
                }
                Label {
                    text: "设备识别码：" + devid.devSecret()
                }
            }
        }
    }
}
