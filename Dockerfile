FROM registry.example.com/cicd/generic/python-nodejs:latest
WORKDIR /app
COPY . .
RUN pip install --index-url https://example.com/simple --upgrade pip setuptools wheel 
RUN pip install --index-url https://example.com/simple --no-cache-dir -r requirements.txt
RUN PLAYWRIGHT_DOWNLOAD_HOST=https://example.com/raw-playwright-proxy/ rfbrowser init
CMD ["/usr/bin/tail", "-f","/dev/null"]
