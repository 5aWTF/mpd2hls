**Updated Installation and Usage Guide:**

1. **Install Dependencies:**

Ensure you have the required dependencies installed on your Linux system. You need `N_m3u8DL-RE` and `ffmpeg`:

- For `N_m3u8DL-RE`, you need to install it separately. You can follow the instructions for installation from its official repository - https://github.com/nilaoda/N_m3u8DL-RE.

- For `ffmpeg`, you can install it using the package manager of your Linux distribution. For example, on Ubuntu or Debian, you can run:



  ```bash
  sudo apt-get install ffmpeg
  ```

2. **Save the Scripts:**

Copy and paste the main script (`mpd2hls.sh`), `stop.sh`, and `restart.sh` into separate files on your Linux system. Save them in a convenient location, such as your home directory or a dedicated scripts folder.

3. **Provide Executable Permissions:**

In the terminal, navigate to the location where you saved the scripts and provide them with executable permissions using the following commands:

```bash
chmod +x mpd2hls.sh
chmod +x stop.sh
chmod +x restart.sh
```

4. **Usage:**

- To start the conversion process:

```bash
./mpd2hls.sh -folder nameOfTheFolder -file nameOfFile -url "your_url_here" -key "your_key_here"
```

- To stop the conversion process for a specific instance:

```bash
./stop.sh instance_identifier
```

- To restart the conversion process for a specific instance:

```bash
./restart.sh nameOfTheFolder nameOfFile "your_url_here" "your_key_here"
```

Make sure to replace `nameOfTheFolder`, `nameOfFile`, `"your_url_here"`, and `"your_key_here"` with the appropriate values for your use case.
