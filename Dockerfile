FROM node:18-alpine

Workdir /app

COPY . .

RUN npm install 

ExPOSE 3000

CMD ["npm", "start"]