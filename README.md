# redpanda_light_client
Light client for the redPanda network. This library is mainly used for the [flutter app](https://github.com/redPanda-project/app).

Format the code with `dart format --line-length=200 .`

Update generated moor database code with `dart run build_runner build`.

This library is very new and should not be used by the public, since nearly everything may change.

To run this dart command line app on linux you have to install dart and install libsqlite3-dev via ```apt-get install -y libsqlite3-dev```.
You can then run the example app in the example folder.