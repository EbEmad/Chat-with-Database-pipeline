FROM apache/airflow:2.5.1 as airflow

COPY requirements.txt /requirements.txt
# Install Python dependencies
RUN pip install --no-cache-dir -r /requirements.txt

# Copy the entrypoint script
COPY  ./Airflow.sh /Airflow.sh

# Switch to the root user to change permissions
USER root
RUN chmod +x /Airflow.sh
RUN apt-get update && apt-get install -y git iputils-ping


# Switch back to the airflow user
USER airflow

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/Airflow.sh"]