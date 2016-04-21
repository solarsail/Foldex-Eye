import QtQuick 2.4
import QtQuick.Window 2.2
import Material 0.2

ApplicationWindow {
    id: main

    title: "Foldex-Eye"

    visible: true

    theme {
        primaryColor: "blue"
        accentColor: Palette.colors["amber"]["700"]
        tabHighlightColor: "white"
    }

    initialPage: LoginPage {
        id: login_page
    }

}
