FROM ubuntu:latest

# Install nginx
RUN apt-get update && apt-get install -y nginx

# Substitute default conf file with mine and add the main applicaton html file
RUN rm -f /etc/nginx/sites-enabled/default
COPY conf /etc/nginx/sites-enabled/

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
