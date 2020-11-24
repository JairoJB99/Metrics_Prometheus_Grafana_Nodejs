FROM node:alpine3.10
WORKDIR /myapp
COPY ./src ./ 
EXPOSE 3000
RUN npm install 
CMD ["node","app.js"]