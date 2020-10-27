docker build -t scout .
docker run -it --rm -p 9004:9004 -v `pwd`/data:/data scout -C 128 -d -m 300000000
