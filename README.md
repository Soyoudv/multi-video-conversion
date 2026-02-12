# multi-video-conversion
converting all the video from a folder with a specific format to another format

## **How to use:**

Download `convert-all.sh` or clone the Git repo:

```sh
git clone git@github.com:Soyoudv/multi-video-conversion.git && cd multi-video-conversion
```

Make it executable:

```sh
chmod +x convert-all.sh
```

Run it:

```sh
./convert-all.sh
```

## **Opts:**

### **-i "file_extension"**

Specify the input format

By default: mkv

### **-o "file_extension"**

Specify the output format

By default: mp4

### **-d "directory"**

Specify the working directory

By default: the program where `convert-all.sh` is located

### **-v**

Verbose mode, stores all the ffmpeg logs in a `console.log` file, located in the working directory