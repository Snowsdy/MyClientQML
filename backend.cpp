#include "backend.h"
#include <QProcess>

Backend::Backend(QObject *parent) : QObject(parent)
{
    client = new MyClientMessenger("localhost", 3333);

    connect(client, &MyClientMessenger::peutLireQqch, this, &Backend::recuQqch);
    connect(client, &MyClientMessenger::statusChanged, this, &Backend::setStatus);
    connect(client->mySockets, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(gotError(QAbstractSocket::SocketError)));
}

bool Backend::getStatus()
{
    return client->getStatus();
}

void Backend::setStatus(bool newStatus)
{
    if (newStatus) {
        emit statusChanged("CONNECTE");
    } else {
        emit statusChanged("DECONNECTE");
    }
}

void Backend::recuQqch(QString msg)
{
    emit unMessage(QString(msg));
}

void Backend::gotError(QAbstractSocket::SocketError err)
{
    QString strError = "Inconnu";
    switch (err) {
        case 0:
            strError = "La connexion est refusee";
            break;
        case 1:
            strError = "L'hote distant a ferme la connexion";
            break;
        case 2:
            strError = "L'adresse de l'hote n'a pas ete trouve";
            break;
        case 5:
            strError = "Temps d'attente de connection atteinte";
            break;
        default:
            strError = "Erreur inconnue";
    }

    emit uneErreur(strError);
}

void Backend::connectClicked()
{
    client->connect2host();
}

void Backend::sendClicked(QString msg)
{
    QByteArray arrBlock;
    QDataStream sortie(&arrBlock, QIODevice::WriteOnly);
    sortie << quint16(0) << msg;

    sortie.device()->seek(0);
    sortie << quint16(arrBlock.size() - sizeof (quint16));

    client->mySockets->write(arrBlock);
}

void Backend::disconnectClicked()
{
    client->fermerConnection();
}

QString Backend::openPDF()
{
    QString path = ".\\PDF_ReaderRelease\\PDF_Reader.exe";
    QProcess *prog = new QProcess();
    if (prog->startDetached(path))
        return QString("Ouverture du mode d'emploi...");
    else
        return QString("Une erreur s'est produite lors de l'ouverture de l'aperçu du pdf... Soit le dossier 'PDF_ReaderRelease' a été supprimé, soit il manque le pdf 'modeDEmploi.pdf'.");
}
