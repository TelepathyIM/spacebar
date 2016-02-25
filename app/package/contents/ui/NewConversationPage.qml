/**
 *   Copyright 2016 Martin Klapetek <mklapetek@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import org.kde.people 1.0 as KPeople
import org.kde.plasma.private.kpeoplehelper 1.0
import org.kde.kquickcontrolsaddons 2.0 as ExtraComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.mobilecomponents 0.2 as MobileComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.telepathy 0.1

MobileComponents.Page {
    anchors.fill: parent

    GridLayout {
        anchors.fill: parent

        columns: 2

        PlasmaExtras.Title {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: i18n("Start New Conversation")
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignRight
            text: i18n("To:")
        }
        PlasmaComponents.TextField {
            id: toInputField
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
        }

        PlasmaExtras.ScrollArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 2
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            contentItem: ContactList {
                id: contactListView
                requiredProperties: ["phoneNumber", "telepathy-contactUri"]
                filterRegExp: toInputField.text
                sourceModel: KPeopleHelper {
                    id: contactsModel
                }
            }
        }
    }
}