import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import com.myBackend 1.0

Window {
    id: window
    visible: true
    width: 800
    minimumWidth: 700
    height: 500
    color: "#023397"
    minimumHeight: 200
    title: "Client"

    Backend {
        id: backend

        onStatusChanged: {
            textInput.append(addMsg(newStatus));
            pseudo.enabled = false;
            if (currentStatus !== true)
            {
                btn_connexion.enabled = true;
            }
        }

        onUnMessage: {
            textInput.append(addMsg(msg));
        }

        onUneErreur: {
            textInput.append(addMsg("Erreur : " + err));
            if (currentStatus !== true)
            {
                backend.disconnectClicked();
            }
            btn_connexion.enabled = true;
        }
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.margins: 5

        Label {
            id: labelPseudo
            color: "#000000"
            text: "Pseudo : "
            Layout.topMargin: 5
            Layout.rightMargin: 5
            Layout.margins: 5
            font.pixelSize: 22
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Rectangle {
            id: rectangle
            anchors.top: parent.top
            anchors.left: labelPseudo.right
            anchors.right: parent.right
            height: 35
            color: "#ffffff"
            radius: 5
            border.width: 2
            TextInput {
                id: pseudo
                text: ""
                font.italic: true
                anchors.fill: rectangle
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 22
                cursorVisible: true
                focus: true
                enabled: true
                onAccepted: {
                    if (pseudo.text.toString() == "") {
                        textInput.append(addMsg("Veuillez rentrez un pseudo !"));
                        pseudo.focus = true;
                    }else {
                        btn_connexion.enabled = false;
                        pseudo.enabled = false;
                        msgAEnvoyer.focus = true;
                        textInput.append(addMsg("Connexion au serveur..."));
                        backend.connectClicked();
                        btn_connexion.enabled = false;
                        msgAEnvoyer.focus = true;
                    }
                }
            }
        }

        MonLayout {
            id: labelStatus
            height: 40
            color: backend.currentStatus ? "#CAF5CF" : "#EA9FA9"
            radius: 5
            anchors.topMargin: 5
            anchors.left: parent
            anchors.right: parent
            anchors.top: rectangle.bottom
            border.color: "black"
            border.width: 2

            Text {
                id: status
                anchors.centerIn: parent
                text: backend.currentStatus ? "CONNECTÉ" : "DÉCONNECTÉ"
                font.bold: true
                font.italic: true
                font.pixelSize: 22
                font.weight: Font.Bold
            }
        }

        RowLayout {
            id: layoutButtons
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: labelStatus.bottom
            anchors.topMargin: 5

            MonButton {
                id: btn_connexion
                anchors.left: parent.left
                text: "Se connecter au serveur"
                color: enabled ? this.down ? "#78C37F" : "#87DB8D" : "gray"
                border.color: "black"
                border.width: 2
                onClicked: {
                    if (pseudo.text == ""){
                        textInput.append(addMsg("Veuillez rentrez un pseudo !"));
                        enabled = true;
                        pseudo.focus = true;
                    }else{
                        textInput.append(addMsg("Connexion au serveur..."));
                        backend.connectClicked();
                        enabled = false;
                        msgAEnvoyer.focus = true;
                    }
                }
            }

            MonButton {
                id: btn_deconnexion
                enabled: !btn_connexion.enabled
                anchors.right: parent.right
                text: "Se déconnecter du serveur"
                color: enabled ? this.down ? "#DB7A74" : "#FF7E79" : "gray"
                border.color: "black"
                border.width: 2
                onClicked: {
                    textInput.append(addMsg("Déconnexion du serveur..."));
                    backend.disconnectClicked();
                    btn_connexion.enabled = true;
                    msgAEnvoyer.focus = true;
                }
            }

            MonButton {
                id: monButton
                height: 49
                enabled: true
                text: "Mode d'emploi"
                border.color: "black"
                border.width: 2
                anchors.left: parent.left
                anchors.leftMargin: 281
                anchors.right: parent.right
                anchors.rightMargin: 304
                onClicked: {
                    textInput.append(addMsg(backend.openPDF()));
                }
            }
        }

        MonLayout {
            id: layoutMessage
            height: 300
            radius: 5
            border.color: "#000000"
            border.width: 2
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.top: layoutButtons.bottom
            anchors.bottom: layoutMonMessage.top

            ScrollView {
                id: scrollView
                anchors.fill: parent

                TextArea {
                    id: textInput
                    readOnly: true
                    wrapMode: Text.WordWrap
                    selectByMouse: true
                    font.pixelSize: 22
                }
            }


        }

        RowLayout {
            id: layoutMonMessage
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left

            Label {
                id: labelMessage
                anchors.verticalCenter: parent.verticalCenter
                text: "Message : "
                font.pixelSize: 22
                color: "black"
            }

            Rectangle {
                id: backgroundMsg
                width: 300
                anchors.left: labelMessage.right
                anchors.top: parent.top
                anchors.right: btn_envoyer.left
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                border.color: "black"
                border.width: 2
                radius: 5

                TextInput {
                    id: msgAEnvoyer
                    text: ""
                    leftPadding: 10
                    rightPadding: 10
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font.pixelSize: 22
                    clip: true
                    cursorVisible: true
                    onAccepted: {
                        if (msgAEnvoyer.text === "clear()"){
                            textInput.clear();
                            msgAEnvoyer.clear();
                        }else{

                            backend.sendClicked(pseudo.text + " : " + msgAEnvoyer.text);
                            msgAEnvoyer.clear();
                        }
                    }
                }
            }

            MonButton{
                id: btn_envoyer
                enabled: !btn_connexion.enabled
                text: "Envoyer"
                font.pixelSize: 22
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: layoutMonMessage.right
                color: enabled ? this.down ? "#6FA3D2" : "#7DB7E9" : "gray"
                onClicked: {
                    if (msgAEnvoyer.text === "clear()"){
                        textInput.clear();
                        msgAEnvoyer.clear();
                    }else{

                        backend.sendClicked(pseudo.text + " : " + msgAEnvoyer.text);
                        msgAEnvoyer.clear();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        textInput.append(addMsg("Bienvenue !"));
    }

    function addMsg(someText)
    {
        return "[" + tempsActuel() + "] " + someText;
    }

    function tempsActuel()
    {
        var now = new Date();
        var nowString = ("0" + now.getHours()).slice(-2) + ":"
                + ("0" + now.getMinutes()).slice(-2) + ":"
                + ("0" + now.getSeconds()).slice(-2);
        return nowString;
    }

}



/*##^##
Designer {
    D{i:11;anchors_height:49;anchors_width:215;anchors_x:281;anchors_y:90}
}
##^##*/
