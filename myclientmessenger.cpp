#include "myclientmessenger.h"

MyClientMessenger::MyClientMessenger(const QString hostAdress, int portNumber) : QObject(), m_nextBlockSize(0)
{
    status = false;
    mySockets = new QTcpSocket();

    host = hostAdress;
    port = portNumber;

    monTimeout = new QTimer();
    monTimeout->setSingleShot(true);
    connect(monTimeout, &QTimer::timeout, this, &MyClientMessenger::connectionTimeout);

    connect(mySockets, &QTcpSocket::disconnected, this, &MyClientMessenger::fermerConnection);
}

bool MyClientMessenger::getStatus()
{
    return status;
}

void MyClientMessenger::fermerConnection()
{
    monTimeout->stop();

    disconnect(mySockets, &QTcpSocket::connected, 0, 0);
    disconnect(mySockets, &QTcpSocket::readyRead, 0, 0);

    bool doitEmmetre = false;
    switch (mySockets->state())
    {
        case 0:
            mySockets->disconnectFromHost();
            doitEmmetre = true;
            break;
        case 2:
            mySockets->abort();
            doitEmmetre = true;
            break;
        default:
            mySockets->abort();
    }

    if (doitEmmetre)
    {
        status = false;
        emit statusChanged(status);
    }
}

void MyClientMessenger::connect2host()
{
    monTimeout->start(3000);

    mySockets->connectToHost(host, port);
    connect(mySockets, &QTcpSocket::connected, this, &MyClientMessenger::connected);
    connect(mySockets, &QTcpSocket::readyRead, this, &MyClientMessenger::readyRead);
}

void MyClientMessenger::readyRead()
{
    QDataStream entre(mySockets);

    for (;;){
        if (!m_nextBlockSize){
            if (mySockets->bytesAvailable() < sizeof (quint16)) { break; }
            entre >> m_nextBlockSize;
        }

        if (mySockets->bytesAvailable() < m_nextBlockSize) { break; }

        QString str;
        entre >> str;

        emit peutLireQqch(str);

        if (str == "0")
        {
            str = "Connection ferme";
            fermerConnection();
        }

        m_nextBlockSize = 0;
    }
}

void MyClientMessenger::connected()
{
    status = true;
    emit statusChanged(status);
}

void MyClientMessenger::connectionTimeout()
{
    if (mySockets->state() == QAbstractSocket::ConnectingState) {
        mySockets->abort();
        emit mySockets->error(QAbstractSocket::SocketTimeoutError);
    }
}
