@echo off
SET BUILDARGS=-ldflags="-s -w" -gcflags="all=-trimpath=%GOPATH%\src" -asmflags="all=-trimpath=%GOPATH%\src"

echo [*] Updating Dependencies
go get -u

echo [*] mod tidy
go mod tidy -v

echo [*] Generating protobuf code
go get -u github.com/golang/protobuf/protoc-gen-go
protoc --go_out=. rss/rss.proto

echo [*] go fmt
go fmt ./...

echo [*] go vet
go vet ./...

rem echo [*] Running gometalinter
rem go get -u github.com/alecthomas/gometalinter
rem gometalinter --install > nul
rem gometalinter ./...

echo [*] Running Tests
go test -v ./...

echo [*] Running build
set GOOS=linux
set GOARCH=amd64
go build %BUILDARGS% -o rss_fetcher
