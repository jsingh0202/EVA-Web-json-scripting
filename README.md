# EVA-Web-json-scripting

The scripts in this folder are run mainly via jupyter notebooks. I would recommend to run these scripts using vscode and installing the necessary extensions.

## Data

The data labelled '...EVA.json' and '...TASKS.json' are data files retrieved from Matt which reflect the current state of the EVA.
The data labelled 'ProjectAnalysis.json' is data retrieved directly from the EVA Site.

## Creating the Virtual Environment on Windows (Venv or Env)

1. To create the venv, run `python -m venv env` in the project terminal. This may take some time.
2. Then run `env\Scripts\activate`.
3. Install all the requirements by running `pip install -r requirements.txt`
4. If you add any new dependencies, run `pip freeze > requirements.txt`.
5. Once you finish, run `deactivate` to deactivate the venv.

You may run step 2 once you have a venv set up for this project in the future.

## mattevatasks

This script takes data that Matt provides directly from the database. It is heavily nested and difficult to work with. The reason the script exists was to retrieve a list of valid 'ids'. Essentially, it provides a list of valid EVA ids that are currently in the EVA Site. I do not recommend using this data or this script to retrieve data regarding the EVA. Instead, refer to [evajson](#evajson).

## evajson

This script uses data directly from the EVA site. Simply press 'download' on the site to retrieve the required data. This data is much easier to work with in regards to getting a list of valid EVA items. The script returns a csv containing data regarding all the leaf and summary EVA items.
