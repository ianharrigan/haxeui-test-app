REM password is haxeui-test-app-air
copy haxeui-test-app-air.xml .\bin\flash\bin
copy haxeui-test-app-air.pfx .\bin\flash\bin
cd .\bin\flash\bin
CALL adt -package -storetype pkcs12 -keystore haxeui-test-app-air.pfx haxeuitestapp.air haxeui-test-app-air.xml haxeuitestapp.swf
cd ../../..