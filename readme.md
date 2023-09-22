**Pushed updated provided by omariobros - https://github.com/omariobros/mpd2hls_v2/tree/main**

1. **Install Dependencies:**

Ensure you have the required dependencies installed on your Linux system. You need `Nginx`, `N_m3u8DL-RE` and `ffmpeg` optional dependencies `packager-linux-x64` :

- For `Nginx`, you can install it using the package manager of your Linux distribution. For example, on Ubuntu or Debian, you can run:

  ```bash
  sudo apt-get install nginx
  ```

- For `ffmpeg`, you can install it using the package manager of your Linux distribution. For example, on Ubuntu or Debian, you can run:


  ```bash
  sudo apt-get install ffmpeg
  ```


2. **Save the Scripts & install N_m3u8DL_RE and the optional dependencies Shaka Packager -  packager-linux-x64**

Download the code into your server, you can use following commands to get it.

```bash
git@github.com:5aWTF/mpd2hls.git
```

or
```bash
https://github.com/5aWTF/mpd2hls/archive/refs/heads/main.zip
```

After download you can install `N_m3u8DL-RE` and optional (Shaka Packager - `packager-linux-x64`):

- For installing the `N_m3u8DL-RE` if you are facing error that the command does not exist or is not found. If you have problem with the install of `N_m3u8DL-RE` please check their instructions from their official repository - https://github.com/nilaoda/N_m3u8DL-RE.

After downloading **mpd2hls** can copy the file `N_m3u8DL-RE` or move it from your **mpd2hls** folder into your bin directory for example Ubuntu.

Use **mv** to move it, or **cp** to copy it.

 ```bash
 cp N_m3u8DL-RE /usr/bin && chmod +x /usr/bin/N_m3u8DL-RE
 ```

**If you want to use Shaka Packager you can do the same step above as we did for N_m3u8DL-RE**

- For installing the `packager-linux-x64` if you are facing error that the command does not exist or is not found. If you have problem with the install of `packager-linux-x64` please check their instructions from their official repository - https://github.com/shaka-project/shaka-packager.

After downloading **mpd2hls** can copy the file `packager-linux-x64` or move it from your **mpd2hls** folder into your bin directory for example Ubuntu.

Use **mv** to move it, or **cp** to copy it.

 ```bash
 cp packager-linux-x64 /usr/bin && chmod +x /usr/bin/packager-linux-x64
 ```

3. **Provide Executable Permissions:**

In the terminal, navigate to the location where you saved the scripts and provide them with executable permissions using the following commands:

```bash
chmod +x mpd2hls_v2.sh
chmod +x stop.sh
chmod +x restart.sh
```

4. **Usage:**

- To start the conversion process:

Without Shaka Packager
```bash
./mpd2hls.sh -folder StreamFolder_Name -file NameOfFile_WITHOUT_EXTENSIONS -url "Stream_URL" -key "your_key_and_kid_here" &
```

With Shaka Packager
```bash
./mpd2hls.sh -folder StreamFolder_Name -file NameOfFile_WITHOUT_EXTENSIONS -url "Stream_URL" -key "your_key_and_kid_here" -shaka &
```

Something Extra
```bash
-custom-proxy # For custom Proxy Server
-use-shaka # For Shaka Packager
-log-no-print # Log output of ffmpeg and N_m3u8D-RE and hide print while running.
-no-logs-or-print # Does not log ffmpeg and N_m3u8D-RE and hide as well prints while running.
```

For debug or inspect you can use:
```bash
tail -f logs/ffmpeg
```
or
```bash
tail -f logs/N_m3u8DL_RE
```

You can also use `-custom-proxy IP:PORT` to use the proxy with the script.

- To stop the conversion process for a specific instance:

```bash
./stop.sh instance_identifier
```

- To restart the conversion process for a specific instance:

```bash
./restart.sh StreamFolder_Name NameOfFile_WITHOUT_EXTENSIONS "Stream_URL" "your_key_and_kid_here" &
```

Make sure to replace `StreamFolder_Name`, `NameOfFile_WITHOUT_EXTENSIONS`, `"Stream_URL"`, and `"your_key_and_kid_here"` with the appropriate values for your use case.
