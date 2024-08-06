FROM tiangolo/uvicorn-gunicorn-fastapi:python3.6

WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    tar \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Menginstal Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

RUN wget -O /tmp/chromedriver-linux64.zip "https://storage.googleapis.com/chrome-for-testing-public/127.0.6533.88/linux64/chromedriver-linux64.zip"
RUN unzip /tmp/chromedriver-linux64.zip chromedriver-linux64/chromedriver -d /usr/local/bin/ \
    && mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver \
    && rm /tmp/chromedriver-linux64.zip

COPY ./app .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
