# Set the base image to the base image
FROM lr_base_python_flask

# ---- Database start
# ---- Database end

# ----
# Put your app-specific stuff here (extra yum installs etc).
# Any unique environment variables your config.py needs should also be added as ENV entries here

RUN yum -y install libxslt-devel libxml2-devel

ENV DEBUG True
ENV DEED_API_ADDRESS http://deed-api:8080
ENV APP_SECRET_KEY dm-session-key
ENV AKUMA_ADDRESS 'http://cf-api-stub:8080'
ENV VERIFY False
ENV GOOGLE_ANALYTICS_CODE UA-59849906-6

# WEBSEAL_HEADER_KEY, WEBSEAL_HEADER_VALUE are set by the devenv-config.

RUN mkdir /logs

WORKDIR /src

# ----

# The command to run the app.
#   Eventlet is used as the (asynch) worker.
#   The python source folder is /src (mapped to outside file system in docker-compose-fragment)
#   Access log is redirected to stderr.
#   Flask app object is located at <app name>.main:app
#   Dynamic reloading is enabled
CMD ["/usr/local/bin/gunicorn", "-k", "eventlet", "--pythonpath", "/src", "--access-logfile", "-", "application:manager.app", "--reload"]

# Get the python environment ready
# Have this at the end so if the files change, all the other steps
# don't need to be rerun. Same reason why _test is first.
# This ensures the container always has just what is in the requirements files as it will
# rerun this in a clean image.
ADD requirements_test.txt requirements_test.txt
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt && \
  pip3 install -r requirements_test.txt
