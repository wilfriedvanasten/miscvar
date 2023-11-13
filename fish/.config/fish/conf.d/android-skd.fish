set SDK_PATH "$HOME/Android/Sdk"
set ANDROID_SDK_ROOT "$HOME/Android/Sdk"
if test -d "$SDK_PATH"
  # Also fix any mismatch between android_home and sdk_path
  set -gx ANDROID_HOME $SDK_PATH
  set PATH $ANDROID_HOME/{tools{,/bin},platform-tools,emulator} $PATH
  if not [ -e "$HOME/Android/sdk" ]
    # Some tools are ridiculously stupid and expect the sdk
    # here
    ln -s "$ANDROID_HOME" "~/Android/sdk"
  end
end
