#include <QtGui/QApplication>
#include <QtCore/QDebug>
#include <QtCore/QDir>
#include <QtCore/QTimer>
#include <QtDeclarative/QDeclarativeError>
#include <QtDeclarative/qdeclarative.h>
#include "qmlapplicationviewer.h"
#include "qplatformdefs.h"

class QumoPlayerTest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool manual READ manual)
public:
    QumoPlayerTest(QObject *parent = 0)
        : QObject(parent)
    {
        if (QApplication::arguments().contains("-test"))
            QTimer::singleShot(10000, this, SIGNAL(start()));
    }

    bool manual() const { return QApplication::arguments().contains("-manual"); }

signals:
    void start();

public slots:
    void end(int exitCode) { QApplication::exit(exitCode); }
};

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    // viewer.setMainQmlFile(QLatin1String("qml/qumoplayer/main.qml"));

    QString mainFile;
#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    // Symbian
    mainFile = QLatin1String("qml/qumoplayer/symbian/main.qml");
#elif defined(MEEGO_EDITION_HARMATTAN)
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    mainFile = QLatin1String("qml/qumoplayer/harmattan/main.qml");
#else
    // Desktop
    mainFile = QLatin1String("qml/qumoplayer/desktop/main.qml");
#endif

    QDir home(QDir::homePath());
    if (home.exists(mainFile)) {
        mainFile = home.absoluteFilePath(mainFile);
    }

    qmlRegisterType<QumoPlayerTest>("me.qtquick.qumoplayer", 1, 0, "Test");
    viewer.setMainQmlFile(mainFile);

    if (viewer.status() == QDeclarativeView::Error) {
        qWarning() << viewer.errors();
        return 1;
    }

    viewer.showExpanded();

    return app->exec();
}

#include "main.moc"
