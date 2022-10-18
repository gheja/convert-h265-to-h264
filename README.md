# convert-h265-to-h264
A script to automatically convert H.265 (HEVC) videos to H.264 (AVC) as a systemd service in the background on Linux using [ffmpeg](https://ffmpeg.org/)

The `convert_h265_to_h264.sh` script is intended to be used as a systemd service (defined in `convert-h265-to-h264.service`).

I am using it to convert videos captured by [Zoneminder](https://zoneminder.com/) directly from the camera ("Video Writer: Camera Passthrough") which happens to be H.265 and it cannot be played in web browsers natively.

The script uses ffmpeg and it is [nice()](https://linux.die.net/man/1/nice)-d to lower the priority of the conversion. Also, it aims to convert older events first (sorted by file name) and runs in smaller batches (10 videos per run) so should be looped (the service specifies this).

The script tracks converted files by using [extended file attributes](https://en.wikipedia.org/wiki/Extended_file_attributes), it checks "user.converted" before converting and sets it to "1" after it.

It replaces the original file.

There are hard coded paths in the script and service file you need to adjust for your needs, I just uploaded the version I'm using.
