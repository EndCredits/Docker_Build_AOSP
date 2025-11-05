# Docker build AOSP

Build AOSP or CustomROM With Docker technology

---

## Usage

### macOS 26 container with Apple Silicon

**This might not able to build AOSP. But it can be a linux development environment**

First install container. Just following to [Install or Upgrade - apple/Container: A tool for creating and running Linux containers using lightweight virtual machines on a Mac. ](https://github.com/apple/container?tab=readme-ov-file#install-or-upgrade)

Then build the image:

```bash
container build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t android-build-host -f Dockerfile_container
```

And run the image:

```bash
container run -it --rm android-build-host
```

If you wish, you can still map a volume to the container by `-v` option.

### Common Linux x86 machine

1. Clone this repository.
   ```
   git clone https://github.com/EndCredits/Docker_build_AOSP -b main

   cd  Docker_build_AOSP
   ```

2. Copy your local git configs.
    ```
    cp ~/.gitconfig gitconfig
    ```

3. Build docker image.
   ```
   docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t android-build-host .
   ```
   
   If you are using fish
   
   ```
   docker build --build-arg userid=(id -u) --build-arg groupid=(id -g) --build-arg username=(id -un) -t android-build-host .
   ```
   
   Note that if you are using proxy tools like v2raya you may need enable ```host``` network mode by appending ```--network host``` in build command like:

   ```
   docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t android-build-host --network host .

   ```

4. Set Android Build working directory.
   ```
   export DOCKER_WORKING_DIRECTORY=<path to your android os source tree>
   ```
   
   If you are using fish
   
   ```
   set DOCKER_WORKING_DIRECTORY <path to your android os source tree>
   ```

5. Start Docker and map the working directory.
   ```
   docker run -it --rm -v $DOCKER_WORKING_DIRECTORY:/android android-build-host
   ```

6. Init repo (e.g. PixelExperience 11 Plus)
   ```
   cd /android

   repo init -u https://github.com/PixelExperience/manifest -b eleven-plus
   ```

7. Sync up
   ```
   repo sync -j$(nproc --all) --force-sync --no-tags --no-clone-bundle
   ```

8. Add your device specific files.

9. Starting build
    ```
    . build/envsetup.sh
    
    lunch aosp_<codename>-< eng | userdebug | user >

    m bacon -j$(nproc --all)
    ```

## Credits
 - [Git At Google](https://android.googlesource.com/platform/build/+/master/tools/docker)
