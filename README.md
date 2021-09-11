# Docker build AOSP

Build AOSP or CustomROM With Docker technology

---

## Usage

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

4. Set Android Build working directory.
   ```
   export DOCKER_WORKING_DIRECTORY=<path to your android os source tree>
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

---

## Credits
 - [Git At Google](https://android.googlesource.com/platform/build/+/master/tools/docker)
