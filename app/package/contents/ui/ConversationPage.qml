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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.mobilecomponents 0.2 as MobileComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
// import org.kde.plasma.private.spacebar 1.0
import org.kde.telepathy 0.1

MobileComponents.Page {
    anchors.fill: parent

    property Conversation conversation

    Loader {
        anchors.fill: parent
        active: conversation !== null && conversation.valid
        sourceComponent: conversationComponent
    }

    Component {
        id: conversationComponent

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true

                PlasmaCore.IconItem {
                    source: conversation.presenceIcon
                }

                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: conversation.title

                }
            }

            Rectangle {
                Layout.fillWidth: true

                height: 1
                color: "#888888" //FIXME use theme color
                opacity: 0.4
            }

            ListView {
                id: view
                property bool followConversation: true

                Layout.fillWidth: true
                Layout.fillHeight: true

                boundsBehavior: Flickable.StopAtBounds

                section.property: "senderAlias"
                section.delegate: PlasmaComponents.Label {
                    text: section
                    font.bold: true
                    anchors.right: parent.right
                }
                clip: true

                add: Transition {
                    id: addTrans
                    NumberAnimation {
                        properties: "x"
                        //FIXME: this doesn't seem to do what it should
                        from: addTrans.ViewTransition.item.isIncoming ? -100 : 100
                        duration: 60

                    }
                    PropertyAnimation {
                        properties: "opacity"
                        from: 0.0
                        to: 1.0
                        duration: 60
                    }
                }

                //we need this so that scrolling down to the last element works properly
                //this means that all the list is in memory
                cacheBuffer: Math.max(0, contentHeight)

                delegate: Loader {
                    Component.onCompleted: {
                        switch (model.type) {
                            case MessagesModel.MessageTypeOutgoing:
                            case MessagesModel.MessageTypeIncoming:
                                source = "TextDelegate.qml"
                                break;
                            case MessagesModel.MessageTypeAction:
                                source = "ActionDelegate.qml";
                                break;
                        }
                    }
                }

                model: conversation.messages // : undefined
                onMovementEnded: followConversation = atYEnd //we only follow the conversation if moved to the end

                onContentHeightChanged: {
                    if (followConversation && contentHeight > height) {
                        view.positionViewAtEnd()
                    }
                }

                Component.onCompleted: {
                    conversation.messages.visibleToUser = true;
                }
            }

            RowLayout {
                PlasmaComponents.TextField {
                    Layout.fillWidth: true

                    Keys.onReturnPressed: {
                        view.model.sendNewMessage(text);
                        text = "";
                    }
                }

                PlasmaComponents.Button {
                    text: i18nc("Button label; Send message", "Send")
                }
            }

            Item {
                height: 100
            }
        }
    }
}
