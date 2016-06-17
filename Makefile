.PHONY: build run clean removeDir

dir = $(shell pwd)

build:
	docker build -t rpi-transmission .
	mkdir $(dir)/downloads
	mkdir $(dir)/incomplete
	mkdir $(dir)/watch

run:
	docker run --name torrent -d -p 9091:9091 -p 51413:51413 -p 51413:51413/udp -v $(dir)/downloads:/downloads -v $(dir)/config:/config -v $(dir)/incomplete:/incomplete -v $(dir)/watch:/watch rpi-transmission

clean:
	docker rm torrent && docker rmi rpi-transmission

removeDir:
	rm -rf $(dir)/downloads $(dir)/incomplete $(dir)/watch $(dir)/config/blocklists $(dir)/config/resume $(dir)/config/torrents
