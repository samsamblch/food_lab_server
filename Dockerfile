# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app

# Copy the necessary files to resolve dependencies.
COPY pubspec.* ./
COPY lib/ ./lib/
COPY delivery_food_api/ ./delivery_food_api/
RUN dart pub get

# Copy the rest of the application files and assets.
COPY . .

# Compile the Dart application to a self-contained executable.
RUN dart compile exe bin/main.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
# Create a minimal runtime image
FROM scratch

# Copy the Dart runtime from the build stage
COPY --from=build /runtime/ /

# Copy the compiled server and any other necessary files from the build stage
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/assets/ /assets/


# Expose the port the server will run on
EXPOSE 8080

# Set the entrypoint to the compiled server executable
CMD ["/app/bin/server"]
