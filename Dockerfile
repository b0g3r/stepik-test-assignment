FROM python:3.8
MAINTAINER kotvberloge@gmail.com

ENV PORT=5001
ENV HOST=0.0.0.0

WORKDIR /opt/project

ADD poetry.lock pyproject.toml /opt/project/

# Turn off auto creation of venvs, use system-wide python in docker image
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install

ADD . /opt/project/

RUN PYTHONPATH=/opt/project poetry run python homeworker/manage.py collectstatic --noinput
CMD exec gunicorn --pythonpath /opt/project/ --max-requests 1000 --workers=5 --reload homeworker.wsgi