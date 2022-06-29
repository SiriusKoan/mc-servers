FROM node:12-alpine
WORKDIR /app
ADD package*.json /app/
RUN npm install
EXPOSE 8080
CMD ["npm", "run", "serve", "--", "--host"]
