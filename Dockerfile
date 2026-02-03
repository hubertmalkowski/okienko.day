# Stage 1: Build the site
FROM haskell:9.2 as builder

WORKDIR /app

# Install Node.js dependencies and build CSS
COPY package.json package-lock.json ./
RUN npm install
COPY css/input.css css/input.css
RUN npm run build

# Install Haskell dependencies
COPY okienko.cabal .
RUN cabal update
RUN cabal install --only-dependencies

# Copy the rest of the source code
COPY . .

# Build the site executable
RUN cabal build

# Run the executable to generate the static site
# The executable is just called "site" but cabal v2-run needs the component name
RUN cabal run exe:site -- build

# Stage 2: Serve the site with Nginx
FROM nginx:alpine

# Copy the generated site from the builder stage
COPY --from=builder /app/_site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
