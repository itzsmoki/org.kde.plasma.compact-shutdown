/*
    SPDX-FileCopyrightText: 2023, 2024 Dmitry Ilyich Sidorov <jonmagon@gmail.com>

    SPDX-License-Identifier: LGPL-3.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.components 3.0 as PC3

PlasmoidItem {
    id: main

    property bool showLogout: plasmoid.configuration.showLogout
    property bool showLockscreen: plasmoid.configuration.showLockscreen
    property bool showSuspend: plasmoid.configuration.showSuspend
    property bool showHibernate: plasmoid.configuration.showHibernate
    property bool showReboot: plasmoid.configuration.showReboot
    property bool showKexec: plasmoid.configuration.showKexec
    property bool showShutdown: plasmoid.configuration.showShutdown
    property string customIcon: plasmoid.configuration.customIcon

    // Hide tooltip
    toolTipMainText: ""
    toolTipSubText: ""

    preferredRepresentation: compactRepresentation

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function(source, data) {
            disconnectSource(source)
        }

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    fullRepresentation: PlasmaExtras.Representation {
        id: dialogItem

        Layout.minimumWidth: Kirigami.Units.gridUnit * 10
        Layout.maximumWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredWidth: Kirigami.Units.gridUnit * 10

        Layout.preferredHeight: implicitHeight

        contentItem: ColumnLayout {
            PC3.ItemDelegate {
                id: logoutItem
                hoverEnabled: true
                icon.name: "system-log-out"
                text: i18n("Logout")
                onClicked: {
                    executable.exec("qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout");
                    main.expanded = false;
                }
                visible: showLogout
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: lockButton
                hoverEnabled: true
                text: i18n("Lock Screen")
                icon.name: "system-lock-screen"
                onClicked: {
                    executable.exec("qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock");
                    main.expanded = false;
                }
                visible: showLockscreen
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: suspendButton
                hoverEnabled: true
                text: i18n("Suspend")
                icon.name: "system-suspend"
                onClicked: {
                    executable.exec("qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Suspend");
                    main.expanded = false;
                }
                visible: showSuspend
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: hibernateButton
                hoverEnabled: true
                text: i18n("Hibernate")
                icon.name: "system-suspend-hibernate"
                onClicked: {
                    executable.exec("qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate");
                    main.expanded = false;
                }
                visible: showHibernate
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: rebootButton
                hoverEnabled: true
                text: i18n("Reboot")
                icon.name: "system-reboot"
                onClicked: {
                    executable.exec("qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndReboot");
                    main.expanded = false;
                }
                visible: showReboot
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: kexecButton
                text: i18n("Kexec Reboot")
                icon.name: "system-reboot"
                onClicked: {
                    executable.exec("qdbus --system org.freedesktop.systemd1 /org/freedesktop/systemd1 org.freedesktop.systemd1.Manager.StartUnit kexec.target replace-irreversibly");
                    main.expanded = false;
                }
                visible: showKexec
                Layout.fillWidth: true
            }

            PC3.ItemDelegate {
                id: shutdownButton
                hoverEnabled: true
                text: i18n("Shutdown")
                icon.name: "system-shutdown"
                onClicked: {
                    executable.exec("qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndShutdown");
                    main.expanded = false;
                }
                visible: showShutdown
                Layout.fillWidth: true
            }
        }
    }

    compactRepresentation: Kirigami.Icon {
        source: main.customIcon.length > 0 ? main.customIcon : "system-shutdown"
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: main.expanded = !main.expanded
        }
    }
}
