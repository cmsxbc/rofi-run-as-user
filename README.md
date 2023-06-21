# Run GUI Application as another user in rofi

Great thanks to [ivanbartsov](https://github.com/davatorium/rofi/issues/584#issuecomment-384555551) and [Matija Nalis](https://unix.stackexchange.com/questions/108784/running-gui-application-as-another-non-root-user/543556#543556) for their idea, which is the base to achieve this.

Notices: X only.

## Usage

1. Put `askpass-rofi.sh` and `run-gui-as.sh` to your environment `PATH`.
2. Run `rofi -show drun -run-command 'run-gui-as.sh {cmd}'`
3. **[Optional]** set evnironment `RUN_GUI_AS_NOLOGIN` to show user which set to nologin, but the application maybe cannot run.

## Known Issues & Solutions

### Audio

If you need audio, redirect the audio of the program's running user to your logind user.

For example, my login user use pipewire and target running user using pulseaudio.
I just start a pipewire-pulse server which listen on `localhost:port`, and change the default pulseaudio server to 'localhost:port' in `/etc/pulse/client.conf`

Check your distrubition documents and pipewire/pulseaudio or other audio server for these infomation.

### input method.

I have not yet found a way to use `fcitx`.