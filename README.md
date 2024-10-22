# EVA-Web-json-scripting

R:

- Use R instead of the python scripts, it is easier to read, deploy, run, and understand.

Python:

- The scripts in this folder are run mainly via jupyter notebooks. I would recommend to run these scripts using vscode and installing the necessary extensions.

## Data

The data labelled '...EVA.json' and '...TASKS.json' are data files retrieved from Matt which reflect the current state of the EVA.
The data labelled 'ProjectAnalysis.json' is data retrieved directly from the EVA Site.

## Running using R

If you are using the `ProjectAnalysis.json` file, using the R script is preferred. This avoids setting up a virtual environment or running docker to run the python scripts.

1. Ensure R is installed.
2. Optionally download a GUI for R (R-Studio).
3. Install required Packages.
4. Run `evajson.r`.

### evajson.r

This script takes `ProjectAnalysis.json` and optionally does a few things. A useful thing this script does is take the EVA data and export a csv detailing information similar to information in the `PCL` sheet in the `Cost Summary for EVA` Google Worksheet. The data can be used to audit the work of the person entering in the PCL data into the EVA by making sure the export data matches with the data found in the Google Sheet. 

## Running Locally

### Creating the Virtual Environment on Windows (Venv or Env)

1. To create the venv, run `python -m venv env` in the project terminal. This may take some time.
2. Then run `env\Scripts\activate`.
3. Install all the requirements by running `pip install -r requirements.txt` (May take some time)
4. Now simply run through the notebooks however you wish.
5. Once you finish, run `deactivate` to deactivate the venv if you wish.

You may run step 2 once you have a venv set up for this project in the future.

## Running on Docker

### Docker Setup

1. Ensure Docker is installed and setup
2. Ensure Docker Desktop is running
3. Run `docker build -t my-jupyter-notebook .` to build the Docker container (May take a few minutes)
4. Run `docker run -p 8888:8888 -v ${pwd}:/app my-jupyter-notebook` (Windows) to run the Docker Container
5. Goto [http://127.0.0.1:8888/](http://127.0.0.1:8888/)
6. Run the notebooks using Jupyter Lab, may need to play around with requirement.txt a little.
7. Stop the Docker Container by pressing `Ctrl+C` in the terminal.

## mattevatasks

This script takes data that Matt provides directly from the database. It is heavily nested and difficult to work with. The reason the script exists was to retrieve a list of valid 'ids'. Essentially, it provides a list of valid EVA ids that are currently in the EVA Site. I do not recommend using this data or this script to retrieve data regarding the EVA. Instead, refer to [evajson](#evajson).

## evajson

This script uses data directly from the EVA site. Simply press 'download' on the site to retrieve the required data. This data is much easier to work with in regards to getting a list of valid EVA items. The script returns a csv containing data regarding all the leaf and summary EVA items.