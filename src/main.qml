/*
 *   Copyright 2018 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>
 */

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.4 as Kirigami

import "qml"

Kirigami.ApplicationWindow {
    visible: true;
    title: qsTr("Hello World");

    pageStack.initialPage: welcomePage;

    Component.onCompleted: {
        initialFakery.start();
    }
    Timer {
        id: initialFakery;
        interval: 1000; running: false; repeat: false;
        onTriggered: {
            connectingToTail.opacity = 1;
            secondaryFakery.start();
        }
    }
    Timer {
        id: secondaryFakery;
        interval: 3000; running: false; repeat: false;
        onTriggered: {
            connectingToTail.opacity = 0;
            showPassiveNotification(qsTr("Connected to tail!"), 1000);
            pageStack.replace(tailPoses);
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        title: "DIGITAiL";
        titleIcon: "applications-graphics";
        actions: [
            Kirigami.Action {
                text: qsTr("Welcome");
                onTriggered: {
                    pageStack.replace(welcomePage);
                }
            },
            Kirigami.Action {
                text: qsTr("Tail Poses");
                onTriggered: {
                    pageStack.replace(tailPoses);
                }
            }
        ]
    }
    Component {
        id: welcomePage;
        WelcomePage {}
    }
    Component {
        id: tailPoses;
        TailPoses {}
    }
    ConnectToTail {
        id: connectToTail;
    }

    Item {
        id: connectingToTail;
        anchors.fill: parent;
        opacity: 0;
        Behavior on opacity { PropertyAnimation { duration: 250; } }
        Rectangle {
            color: "black";
            opacity: 0.2;
            anchors.fill: parent;
        }
        MouseArea {
            anchors.fill: parent;
            enabled: connectingToTail.opacity > 0;
            onClicked: {}
        }
        Label {
            anchors {
                bottom: parent.verticalCenter;
                bottomMargin: Kirigami.Units.smallMargin;
                horizontalCenter: parent.horizontalCenter;
            }
            text: qsTr("Connecting to tail...");
        }
        BusyIndicator {
            anchors {
                top: parent.verticalCenter;
                topMargin: Kirigami.Units.smallMargin;
                horizontalCenter: parent.horizontalCenter;
            }
            running: connectingToTail.opacity > 0;
        }
    }
}