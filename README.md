# test and deploy a PHP web API

## pre requisites

- have Docker installed
- use VSCode
- have [dev containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed

## development

- open this project in VSCode
- open as a dev container
- `composer install`
- go to `http://localhost`

## tests

- `./vendor/bin/phpunit --testdox --colors tests`

## deployment

- test the prod Dockerfile locally with `docker build -f prod.Dockerfile -t webapp . && docker run -p 80:80 -e PORT=80 webapp`
- have a Google Cloud project ready
- enable Google Artifact Registry and Cloud Run Admin APIs
- create a repository in Google Artifact Registry
- if needed, override `iam.disableServiceAccountKeyCreation` organization policy in the GCP project to be able to create service account keys
- create a service account and get its JSON key file, service account must have permissions:

    - `artifactregistry.repositories.downloadArtifacts`
    - `artifactregistry.repositories.uploadArtifacts`
    - `iam.serviceaccounts.actAs`
    - `run.services.create`
    - `run.services.get`

- put the JSON key at the root of the project, named `gcp-creds.json` (this file is in the `.gitignore` file)
- create the relevant secrets in your GitHub repository (check out the `.github/workflows/cd.yml` file to know what secrets are needed)
- the code is deployed on Google Cloud Run at every push to the `main` branch
- if needed, update `iam.allowedPolicyMemberDomains` to allow for unauthenticated invocations of the Cloud Run service