import QtQuick 2.4
import Material 0.2
import QtQuick.Controls 1.3 as Controls

Item {

    Column {
        anchors.centerIn: parent
        spacing: Units.dp(20)

        Button {
            text: "协议设置"
            elevation: 1
            activeFocusOnPress: true
            backgroundColor: Theme.primaryColor
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: snackbar.open("协议设置，待完善")
        }
    }

    Snackbar {
        id: snackbar
    }
}
