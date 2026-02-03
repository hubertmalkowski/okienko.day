# Stage 1: Build CSS with Node.js
FROM node:18-alpine AS css-builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY css/input.css css/input.css
COPY templates/ templates/
COPY *.html ./
COPY posts/ posts/
RUN npm run build

# Stage 2: Build Haskell site
FROM haskell:9.4 AS haskell-builder

WORKDIR /app

# Copy only dependency files first (cached unless cabal file changes)
COPY okienko.cabal ./
COPY site.hs ./
RUN cabal update
RUN cabal install --only-dependencies --disable-tests --disable-benchmarks

# Copy the rest of the source code
COPY . .

# Copy the built CSS from the first stage, overwriting the original
COPY --from=css-builder /app/css/tailwindcss.css ./css/tailwindcss.css

# Build the site executable
RUN cabal build

# Run the executable to generate the static site
RUN cabal run exe:site -- build

# Stage 3: Serve the site with Nginx
FROM nginx:alpine

# Copy the generated site from the haskell builder stage
COPY --from=haskell-builder /app/_site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
