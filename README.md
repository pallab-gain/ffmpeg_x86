# ffmpeg_x86
****Simple ffmpeg X86 builder scripts for android that helps to build, and test streaming solution(s) @Augmedix****

- ***We need to build sequencially. First openssl, then rtmp, and then ffmpeg***
```
1. build openssl
2. build rtmplib
3. build ffmpeg
```

- ***Also we we need to change the NDK path. i.e. this line, according to where our ndk folder is.***
```
NDK=/home/pallab/Documents/IDE/Sdk/ndk-bundle, and
ANDROID_NDK_ROOT=/home/pallab/Documents/IDE/Sdk/ndk-bundle
```
- ***Build openssl for android x86***
```
 chmod +x build_openssl.sh
 ./build_openssl.sh
```

- ***Build rtmp for android x86***
```
 chmod +x build_rtmp.sh
 ./build_rtmp.sh
```

- ***Build ffmpeg for android x86***
```
 chmod +x build_ffmpeg.sh
 ./build_ffmpeg.sh
```


