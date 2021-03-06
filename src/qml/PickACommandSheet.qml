/*
 *   Copyright 2019 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *   This file based on sample code from Kirigami
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
import org.kde.kirigami 2.6 as Kirigami

Kirigami.OverlaySheet {
    id: root;

    function pickCommand() {
        open();
    }
    signal commandPicked(string command);
    header: Kirigami.Heading {
        text: qsTr("Pick a command");
    }
    BaseMovesComponent {
        width: root.width - Kirigami.Units.largeSpacing * 4;
        onCommandActivated: {
            pickACommand.commandPicked(command);
        }
        categoriesModel: ListModel {
            ListElement {
                name: qsTr("Calm and Relaxed");
                category: "relaxed";
                color: "#1cdc9a";
            }
            ListElement {
                name: qsTr("Fast and Excited");
                category: "excited";
                color: "#c9ce3b";
            }
            ListElement {
                name: qsTr("Frustrated and Tense");
                category: "tense";
                color: "#f67400";
            }
            ListElement {
                name: qsTr("LED Patterns");
                category: "lights";
                color: "#93cee9";
            }
        }
    }
}
