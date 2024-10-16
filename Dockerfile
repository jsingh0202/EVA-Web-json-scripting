# Use the official Jupyter image as a base
FROM jupyter/scipy-notebook:latest

# Set the working directory to /app
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the default Jupyter port
EXPOSE 8888

# Run Jupyter Notebook
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.allow_origin='*'"]
