TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    httprequest.cpp \
    rdpprocess.cpp \
    heartbeat.cpp \
    systempower.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    httprequest.h \
    rdpprocess.h \
    heartbeat.h \
    systempower.h

isEmpty(TARGET_EXT) {
    win32 {
        TARGET_CUSTOM_EXT = .exe
    }
    macx {
        TARGET_CUSTOM_EXT = .app
    }
} else {
    TARGET_CUSTOM_EXT = $${TARGET_EXT}
}

win32 {
    DEPLOY_DLL = windeployqt
    DEPLOY_EXTRA = $(INSTALL_FILE)

    EXTRA_DEPS_DIR = $$shell_quote($$shell_path($$_PRO_FILE_PWD_/extra))
    EXTRA_DEPS += $$EXTRA_DEPS_DIR\\*

    CONFIG( debug, debug|release ) {
        # debug
        DEPLOY_DIR = $$shell_quote($$shell_path($${OUT_PWD}/debug))
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/debug/$${TARGET}$${TARGET_CUSTOM_EXT}))
    } else {
        # release
        DEPLOY_DIR = $$shell_quote($$shell_path($${OUT_PWD}/release))
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/release/$${TARGET}$${TARGET_CUSTOM_EXT}))
    }
}


QMAKE_POST_LINK += $$DEPLOY_EXTRA $$EXTRA_DEPS $$DEPLOY_DIR
#QMAKE_POST_LINK += & $$DEPLOY_DLL $$DEPLOY_TARGET
