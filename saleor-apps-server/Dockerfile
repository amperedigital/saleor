FROM node:18-alpine
WORKDIR /app

# Install dependencies
COPY package.json ./
RUN npm install

# Copy app code and static assets
COPY server.js ./
COPY static ./static

EXPOSE 8899
CMD ["node", "server.js"]
