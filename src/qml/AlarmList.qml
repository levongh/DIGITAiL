/*
 *   Copyright 2019 Ildar Gilmanov <gil.ildar@gmail.com>
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
import QtQuick.Controls 2.4 as QQC2
import org.kde.kirigami 2.6 as Kirigami
import QtQuick.Layouts 1.11

Kirigami.ScrollablePage {
    id: root;

    objectName: "alarmList";
    title: qsTr("Alarms");

    actions {
        main: Kirigami.Action {
            text: qsTr("Add New Alarm");
            icon.name: ":/org/kde/kirigami/icons/list-add.svg";
            onTriggered: {
                namePicker.pickName();
            }
        }
    }

    Connections {
        target: AppSettings

        onAlarmExisted: {
            showMessageBox(qsTr("Select another name"),
                           qsTr("Unable to add the alarm because we already have an alarm with the same name.\n\nPlease select another name for the alarm."));
        }

        onAlarmNotExisted: {
            showMessageBox(qsTr("Alarm was removed"),
                           qsTr("Unable to find an alarm with the name '%1'. Maybe another application instance has removed it.").arg(name));
        }
    }

    Component {
        id: alarmListDelegate;

        Kirigami.SwipeListItem {
            id: listItem;

            property var dateTime: modelData["time"]

            ColumnLayout {
                QQC2.Label {
                    text: modelData["name"]
                }

                QQC2.Label {
                    text: Qt.formatDate(dateTime, Qt.DefaultLocaleLongDate)
                          + ", "
                          + (locale.amText ? Qt.formatTime(dateTime, "hh:mm AP") : Qt.formatTime(dateTime, "hh:mm"))
                }
            }

            onClicked: {
                console.debug("Append this list, yo! ...maybe confirm, because it's a bit lots");
            }

            actions: [
                Kirigami.Action {
                    text: qsTr("Edit Alarm Commands");
                    icon.name: ":/org/kde/kirigami/icons/document-edit.svg";

                    onTriggered: {
                        pageStack.push(editorPage, { alarm: modelData });
                    }
                },

                Kirigami.Action {
                    text: qsTr("Set Time To Alarm");
                    icon.name: ":/org/kde/kirigami/icons/accept_time_event.svg";

                    onTriggered: {
                        AppSettings.setActiveAlarmName(modelData["name"]);

                        datePicker.showDatePicker(dateTime, function(date) {
                            var originDate = dateTime;
                            date.setHours(originDate.getHours());
                            date.setMinutes(originDate.getMinutes());

                            timePicker.showTimePicker(originDate.getHours(), originDate.getMinutes(), function(hours, minutes) {
                                date.setHours(hours);
                                date.setMinutes(minutes);
                                AppSettings.setAlarmTime(date);
                                AppSettings.setActiveAlarmName("");
                            });
                        })
                    }
                },

                Kirigami.Action {
                    text: qsTr("Delete this Alarm");
                    icon.name: ":/org/kde/kirigami/icons/list-remove.svg";

                    onTriggered: {
                        showMessageBox(qsTr("Remove the Alarm"),
                                       qsTr("Are you sure that you want to remove the alarm '%1'?").arg(modelData["name"]),
                                       function () {
                                           AppSettings.removeAlarm(modelData["name"]);
                                       });
                    }
                }
            ]
        }
    }

    Component {
        id: editorPage;
        AlarmEditor { }
    }

    ListView {
        model: AppSettings.alarmList;
        delegate: alarmListDelegate;
        header: InfoCard {
            text: qsTr("Set an alarm here. Pick a date and time for your alarm, and then add one or more moves you want to perform when you hit that time.");
        }
    }

    NamePicker {
        id: namePicker;

        description: qsTr("Enter a name to use for your new alarm and click Create");
        placeholderText: qsTr("Enter your alarm name here");
        buttonOkText: qsTr("Create");

        onNamePicked: {
            AppSettings.addAlarm(name);
            namePicker.close();
        }
    }

    DatePicker {
        id: datePicker
    }

    TimePicker {
        id: timePicker
    }
}
