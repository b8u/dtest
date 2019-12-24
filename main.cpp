#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QQuickStyle>
#include <QSysInfo>

bool isPhone(const QString type) {
     if (type == "android") {
         return true;
     } else if (type == "ios") {
         return true;
     } else {
         return false;
     }
}

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  const QString dbLocation =
      QStandardPaths::writableLocation(isPhone(QSysInfo::productType())
                                       ? QStandardPaths::AppDataLocation
                                       : QStandardPaths::DesktopLocation);

  qDebug() << "OfflineStoragePath: " << dbLocation;

  QQuickStyle::setStyle("Material");
  qDebug() << "QQuickStyle::setStyle(Material);";

  engine.setOfflineStoragePath(dbLocation);
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                   [url](QObject *obj, const QUrl &objUrl) {
                     if (!obj && url == objUrl) QCoreApplication::exit(-1);
                   },
                   Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
