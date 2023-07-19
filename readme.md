**Installation and Usage Guide:**

1. **Install Dependencies:**

Ensure you have the required dependencies installed on your Linux system. You need `N_m3u8DL-RE` and `ffmpeg`:

- For `N_m3u8DL-RE`, you need to install it separately. You can follow the instructions for installation from its official repository - https://github.com/nilaoda/N_m3u8DL-RE.

- For `ffmpeg`, you can install it using the package manager of your Linux distribution. For example, on Ubuntu or Debian, you can run:

  ```bash
  sudo apt-get install ffmpeg
  ```

2. **Save the Scripts:**

Copy and paste the main script (`download_and_convert.sh`), `stop.sh`, and `restart.sh` into separate files on your Linux system. Save them in a convenient location, such as your home directory or a dedicated scripts folder.

3. **Provide Executable Permissions:**

In the terminal, navigate to the location where you saved the scripts and provide them with executable permissions using the following commands:

```bash
chmod +x download_and_convert.sh
chmod +x stop.sh
chmod +x restart.sh
```

4. **Usage:**

The usage of the scripts remains the same as explained in the previous guide. Now, you can run multiple instances of the `download_and_convert.sh` script simultaneously, each processing different URLs and keys independently without interfering with each other. Each instance will have its unique identifier and temporary directory to manage the processes effectively.

**Note:** Keep in mind that running multiple instances of the script may consume significant system resources, including CPU and memory. Make sure your system can handle the load before starting multiple instances simultaneously.
