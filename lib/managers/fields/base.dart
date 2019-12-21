typedef RxFieldManagerOnChanged = Function(String);
typedef RxFieldManagerValidate = String Function(String);

typedef RxOnChangedDate = Function(DateTime);
typedef RxValidateDate = String Function(DateTime);

// Mode
enum RxValidateMode { none, onChanged }
enum RxDateTimeMode { date, time, datetime }
