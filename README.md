GUI for libavfilter

![screenshot](https://github.com/richardpl/lavfi-preview/blob/master/assets/demo.gif)

GUI to preview filtergraphs from libavfilter.

Depends on ImGui, FFmpeg >=5.0, glfw, OpenGL3 and OpenAL-Soft.

For list of useful keys press F1 while running.

For running in docker: 
```
docker run --rm -it --device /dev/snd -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native -v ~/.config/pulse/cookie:/root/.config/pulse/cookie --group-add $(getent group audio | cut -d: -f3) --env="DISPLAY" --net=host --volume="/run/user/$UID/gdm/Xauthority:/root/.Xauthority:ro" libav-preview
```
