FROM nginx:1.20-alpine

ARG conf

COPY ./gtw-${conf}.conf /etc/nginx/conf.d/default.conf

RUN wget -q https://raw.githubusercontent.com/eficode/wait-for/v2.1.2/wait-for \
&& chmod +x wait-for

CMD ["nginx", "-g", "daemon off;"]
