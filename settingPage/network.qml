import QtQuick 2.4
import Material 0.2
import QtQuick.Controls 1.3 as Controls

Item {

    Column {
        anchors.centerIn: parent
        spacing: Units.dp(20)

        Button {
            text: "网络设置"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: snackbar.open("网络设置页面，待完善")
        }
    }

    Snackbar {
        id: snackbar
    }
}
