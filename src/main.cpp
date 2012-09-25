/* Copyright (c) 2012 QumoPlayer Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QumoPlayer nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QUMOPLAYER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <QtGui/QApplication>
#include <QtCore/QDebug>
#include <QtCore/QDir>
#include <QtCore/QTimer>
#include <QtOpenGL/QGLWidget>
#include <QtDeclarative/QDeclarativeError>
#include <QtDeclarative/qdeclarative.h>
#include "qmlapplicationviewer.h"
#include "qplatformdefs.h"
#include <inneractiveplugin.h>

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
    inneractivePlugin::initializeEngine(viewer.engine());

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

    qmlRegisterType<QumoPlayerTest>("me.qtquick.qumoplayer", 1, 0, "Test");

    QDir home(QDir::homePath());
    if (home.exists(mainFile)) {
        mainFile = home.absoluteFilePath(mainFile);
        viewer.setMainQmlFile(mainFile);
    } else {
        viewer.setSource(QUrl(QString("qrc:/%1").arg(mainFile)));
    }

    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);
    viewer.setViewport(new QGLWidget);

    if (viewer.status() == QDeclarativeView::Error) {
        qWarning() << viewer.errors();
        return 1;
    }

    viewer.showExpanded();

    return app->exec();
}

#include "main.moc"
