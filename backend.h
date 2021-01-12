#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include "myclientmessenger.h"

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)
public:
    explicit Backend(QObject *parent = nullptr);
    bool getStatus();
signals:
    void statusChanged(QString newStatus);
    void uneErreur(QString err);
    void unMessage(QString msg);
public slots:
    void setStatus(bool newStatus);
    void recuQqch(QString msg);
    void gotError(QAbstractSocket::SocketError err);
    void sendClicked(QString msg);
    void connectClicked();
    void disconnectClicked();
    QString openPDF();
private:
    MyClientMessenger *client;
};

#endif // BACKEND_H
