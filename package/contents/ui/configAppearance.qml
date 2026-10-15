import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import Qt.labs.platform 1.1 as Platform

Item {

    property alias cfg_showLogout: showLogout.checked
    property alias cfg_showLockscreen: showLockscreen.checked
    property alias cfg_showSuspend: showSuspend.checked
    property alias cfg_showHibernate: showHibernate.checked
    property alias cfg_showReboot: showReboot.checked
    property alias cfg_showKexec: showKexec.checked
    property alias cfg_showShutdown: showShutdown.checked
    property string cfg_customIcon: ""

    Platform.FileDialog {
        id: iconPicker
        title: i18n("Choose an icon")
        folder: "file:///usr/share/icons"
        nameFilters: ["Image files (*.png *.svg *.svgz *.xpm)"]
        onAccepted: {
            customIconField.text = iconPicker.file.toString().replace("file://", "")
            cfg_customIcon = customIconField.text
        }
    }

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Separator {
            Layout.fillWidth: true
        }
        Label {
            text: i18n("General:")
            font.bold: true
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing

            Label {
                text: i18n("Widget icon:")
            }

            Kirigami.Icon {
                id: iconPreview
                width: Kirigami.Units.iconSizes.medium
                height: Kirigami.Units.iconSizes.medium
                source: customIconField.text.length > 0 ? customIconField.text : "system-shutdown"
            }

            TextField {
                id: customIconField
                placeholderText: i18n("system-shutdown")
                text: cfg_customIcon
                onTextChanged: cfg_customIcon = text
                Layout.fillWidth: true
            }

            Button {
                icon.name: "document-open"
                ToolTip.text: i18n("Browse...")
                ToolTip.visible: hovered
                onClicked: iconPicker.open()
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }
        Label {
            text: i18n("Show buttons:")
            font.bold: true
        }

        CheckBox {
            id: showLogout
            text: i18n("Logout")
        }
        CheckBox {
            id: showLockscreen
            text: i18n("Lock Screen")
        }
        CheckBox {
            id: showSuspend
            text: i18n("Suspend")
        }
        CheckBox {
            id: showHibernate
            text: i18n("Hibernate")
        }
        CheckBox {
            id: showReboot
            text: i18n("Reboot")
        }
        CheckBox {
            id: showKexec
            text: i18n("Kexec Reboot")
        }
        CheckBox {
            id: showShutdown
            text: i18n("Shutdown")
        }
    }
}
