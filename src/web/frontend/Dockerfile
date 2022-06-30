FROM node:14-alpine
WORKDIR /app
ADD package*.json /app/
RUN npm install
CMD ["npm", "run", "serve", "--", "--host", "--port", "80"]
