FROM golang:alpine AS build
WORKDIR /workspace
COPY go.mod .
COPY main.go .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o defaultservice

FROM scratch
COPY --from=build /workspace/defaultservice /bin/defaultservice
ENTRYPOINT ["/bin/defaultservice"]
