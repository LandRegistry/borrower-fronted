export SETTINGS="config.DevelopmentConfig"

mkdir -p test-reports
mkdir -p ../logs

py.test --junitxml=test-reports/TEST-dm-borrower-frontend.xml --cov-report term-missing --cov-report=html --cov application tests
