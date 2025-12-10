.PHONY: clean distclean run pretty

dilbertd: main.go go.sum frontend/src/index.html frontend/src/main.css
	go build

go.sum: go.mod
	go get dilbertd
	touch go.sum

frontend/src/main.css: node_modules frontend/src/index.html frontend/src/input.css frontend/tailwind.config.js
	npx @tailwindcss/cli -i frontend/src/input.css -o frontend/src/main.css
	# Stupid tailwindcss does not update mtime...
	touch frontend/src/main.css

node_modules: package.json
	npm install
	touch node_modules

run: dilbertd
	./dilbertd

clean:
	rm -f dilbertd
	rm -f frontend/src/main.css

distclean: clean
	rm -rf node_modules


pretty: node_modules
	go fmt
	npx prettier frontend/src/index.html frontend/tailwind.config.js --write
