FROM python:3.10
WORKDIR /src
COPY . .
RUN pip install -r requirements.txt
CMD mkdocs serve -a 0.0.0.0:8000