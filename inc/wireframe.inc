#include %occOptions

#define MultiAsSerial(%subs, %out) set%out = ""  for i=1:1:%subs { set $list(%out, *+1) = """"_$get(%subs(i))_"""" }
#define IsValidMulti(%subs) set hasNull = 0 for i=1:1:%subs { if $get(%subs(i)) = ""  set hasNull = 1  quit }  if hasNull = 1 quit 'hasNull
#define RealMethodName(%methodName) $select($extract(%methodName) = "_" : $extract(%methodName, 2, *), 1: %methodName)
#define SubstituteMethodName(%methodName) $select($extract(%methodName) = "%" : "_"_%methodName, 2: %methodName)
#define NEWLINE $select($$$isWINDOWS: $char(13)_$char(10), 1: $char(10))