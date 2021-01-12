#ifndef MYCLIENTMESSENGER_H
#define MYCLIENTMESSENGER_H

#include <QObject>
#include <QTcpSocket>
#include <QDataStream>
#include <QTimer>

class MyClientMessenger : public QObject
{
    Q_OBJECT
public:
    MyClientMessenger(const QString host, int port);

    QTcpSocket *mySockets;
    bool getStatus();
public slots:
    void fermerConnection();
    void connect2host();
signals:
    void statusChanged(bool);
    void peutLireQqch(QString msg);
private slots:
    void readyRead();
    void connected();
    void connectionTimeout();
private:
    QString host;
    int port;
    bool status;
    quint16 m_nextBlockSize;
    QTimer *monTimeout;
};

#endif // MYCLIENTMESSENGER_H
