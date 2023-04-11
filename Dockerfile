FROM node:18
WORKDIR /usr/src/app
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json .
# If you are building your code for production
RUN npm ci --omit=dev
# Bundle app source
COPY . .
EXPOSE 3000
CMD ["node", "./bin/www" ]