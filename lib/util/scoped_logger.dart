import 'package:logger/logger.dart';

mixin ScopedLogger {
  final _LoggerWithScope _loggerSingleton = _LoggerWithScope();

  _LoggerWithScope get logger {
    _loggerSingleton.type = this.runtimeType;
    return _loggerSingleton;
  }
}

class _LinePrinter extends LogPrinter {
  String getTime() {
    // String _threeDigits(int n) {
    //   if (n >= 100) return "$n";
    //   if (n >= 10) return "0$n";
    //   return "00$n";
    // }

    String _twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    var now = DateTime.now();
    String h = _twoDigits(now.hour);
    String min = _twoDigits(now.minute);
    String sec = _twoDigits(now.second);

    // String ms = _threeDigits(now.millisecond);
    // return '[$h:$min:$sec.$ms]';

    return '[$h:$min:$sec]';
  }

  @override
  void log(LogEvent event) {
    String message = [getTime(), event.message].join(' ');

    println(PrettyPrinter.levelColors[event.level](message));
  }
}

class _LoggerWithScope {
  Logger logger = Logger(printer: _LinePrinter());
  Type type;

  String _formatMessage(String m) {
    String prefix = '[${type.toString()}]'.replaceAll('Impl', 'I').padRight(20);

    return '$prefix $m';
  }

  void v(String m) => logger.v(_formatMessage(m));
  void d(String m) => logger.d(_formatMessage(m));
  void i(String m) => logger.i(_formatMessage(m));
  void w(String m) => logger.w(_formatMessage(m));
  void e(String m) => logger.e(_formatMessage(m));
}
