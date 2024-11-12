FROM ghcr.io/cirruslabs/flutter:latest AS flutter
WORKDIR /app
COPY pubspec.yaml ./
RUN flutter pub get
COPY . .
RUN flutter build apk
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=flutter /app/build/app/outputs/flutter-apk/ /app/apks
CMD [ "echo","apk copied from to container successfully" ]